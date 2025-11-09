import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../domain/entities/chat_message_entity.dart';
import 'package:flutter/foundation.dart'; // para debugPrint

class GeminiService {
  static bool _initialized = false;
  static String? _apiKey;

  // ✅ Modelo estable y soportado por la API v1
  static const String baseUrl = 'https://generativelanguage.googleapis.com/v1';
  static const String model = 'models/gemini-2.0-flash-001';

  static void initialize() {
    if (!_initialized) {
      _apiKey = dotenv.env['GEMINI_API_KEY'];
      debugPrint('🔑 Intentando inicializar Gemini...');

      if (_apiKey != null && _apiKey!.isNotEmpty) {
        _initialized = true;
        debugPrint('✅ Gemini inicializado correctamente');
        debugPrint('🧠 Modelo: $model');
      } else {
        throw Exception('❌ GEMINI_API_KEY no encontrada en .env');
      }
    }
  }

  /// Genera una respuesta del chatbot basada en el contexto de la finca
  Future<String> generateResponse({
    required List<ChatMessageEntity> messages,
    required String fincaContext,
  }) async {
    if (_apiKey == null || _apiKey!.isEmpty) {
      throw Exception('Gemini no está inicializado');
    }

    try {
      final prompt = _buildPrompt(messages, fincaContext);
      final url = Uri.parse('$baseUrl/$model:generateContent?key=$_apiKey');

      debugPrint('🤖 Enviando solicitud a Gemini (API v1)...');
      debugPrint('📝 Pregunta: ${_getLastUserMessage(messages)}');

      final body = jsonEncode({
        'contents': [
          {'parts': [{'text': prompt}]}
        ],
        'generationConfig': {
          'temperature': 0.7,
          'maxOutputTokens': 1000,
        }
      });

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      debugPrint('📡 Status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final text = data['candidates']?[0]?['content']?['parts']?[0]?['text'];
        return text ?? 'Lo siento, no pude generar una respuesta.';
      } else {
        debugPrint('❌ Error ${response.statusCode}: ${response.body}');
        return _generateContextualResponse(
          _getLastUserMessage(messages),
          fincaContext,
        );
      }
    } catch (e) {
      debugPrint('❌ Error en Gemini: $e');
      return _generateContextualResponse(
        _getLastUserMessage(messages),
        fincaContext,
      );
    }
  }

  // 🔧 Construcción del prompt con instrucciones y contexto
  String _buildPrompt(List<ChatMessageEntity> messages, String fincaContext) {
    final buffer = StringBuffer();
    buffer.writeln('Eres un asistente experto en cultivo de café y gestión de fincas cafeteras.');
    buffer.writeln('Basado en los datos de la finca, ofrece respuestas claras y en español.\n');

    buffer.writeln('CONTEXTO DE LA FINCA:\n$fincaContext\n');
    buffer.writeln('INSTRUCCIONES:');
    buffer.writeln('- Proporciona recomendaciones precisas según los datos.');
    buffer.writeln('- Sé conciso, útil y profesional.');
    buffer.writeln('- Máximo 5 párrafos.\n');

    final recentMessages = messages.length > 5
        ? messages.sublist(messages.length - 5)
        : messages;

    buffer.writeln('HISTORIAL DE CONVERSACIÓN:');
    for (var msg in recentMessages) {
      final role = msg.role == MessageRole.user ? 'Usuario' : 'Asistente';
      buffer.writeln('$role: ${msg.content}');
    }

    buffer.writeln('\nPREGUNTA ACTUAL:');
    buffer.writeln(_getLastUserMessage(messages));
    buffer.writeln('\nResponde en español de forma clara y práctica.');

    return buffer.toString();
  }

  String _getLastUserMessage(List<ChatMessageEntity> messages) {
    final userMessages =
        messages.where((m) => m.role == MessageRole.user).toList();
    return userMessages.isNotEmpty ? userMessages.last.content : 'Hola';
  }

  // 🧠 Respuesta alternativa si la IA falla
  String _generateContextualResponse(String question, String fincaContext) {
    final q = question.toLowerCase();

    if (q.contains('productividad')) {
      return 'Te recomiendo mejorar la productividad con análisis de suelo, registro de cosechas y renovación de cafetales improductivos.';
    }
    if (q.contains('precio') || q.contains('venta')) {
      return 'El precio del café depende de la altura, la variedad y la calidad. Considera vender a tostadores locales o ferias.';
    }
    if (q.contains('hola')) {
      return '¡Hola! 👋 Soy tu asistente virtual para fincas cafeteras. ¿Deseas hablar sobre productividad, costos o cultivos?';
    }

    return 'Puedo ayudarte con análisis de productividad, costos, fertilización o estrategias de venta. ¿Sobre qué tema te gustaría hablar?';
  }

  // 🔍 Generar análisis completo de finca
  Future<String> generateFarmAnalysis(String fincaContext) async {
    if (_apiKey == null || _apiKey!.isEmpty) {
      throw Exception('Gemini no está inicializado');
    }

    try {
      final prompt = '''
Eres un experto en gestión de fincas cafeteras. Analiza los siguientes datos y da un diagnóstico completo:

$fincaContext

Incluye:
1. Productividad actual
2. Análisis financiero
3. Recomendaciones estratégicas
4. Próximos pasos concretos
''';

      final url = Uri.parse('$baseUrl/$model:generateContent?key=$_apiKey');
      final body = jsonEncode({
        'contents': [
          {'parts': [{'text': prompt}]}
        ],
        'generationConfig': {
          'temperature': 0.7,
          'maxOutputTokens': 2000,
        }
      });

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final text = data['candidates']?[0]?['content']?['parts']?[0]?['text'];
        return text ?? _generateDefaultAnalysis(fincaContext);
      } else {
        debugPrint('❌ Error ${response.statusCode}: ${response.body}');
        return _generateDefaultAnalysis(fincaContext);
      }
    } catch (e) {
      debugPrint('❌ Error generando análisis: $e');
      return _generateDefaultAnalysis(fincaContext);
    }
  }

  String _generateDefaultAnalysis(String fincaContext) {
    return '''
📊 **Análisis general de tu finca:**

$fincaContext

1. **Productividad:** Evalúa tu producción por hectárea.
2. **Finanzas:** Controla tus gastos y busca reducir costos sin afectar calidad.
3. **Estrategia:** Diversifica ventas y mejora prácticas agrícolas.

¿Deseas que te ayude a optimizar alguno de estos aspectos?''';
  }
}
