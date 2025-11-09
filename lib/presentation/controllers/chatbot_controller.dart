import 'package:get/get.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../../domain/models/finca_model.dart';
import '../../domain/entities/ingreso_entity.dart';
import '../../domain/entities/gasto_entity.dart';
import '../../domain/entities/recoleccion_entity.dart';
import '../../core/services/gemini_service.dart';
import '../../core/config/supabase_config.dart';
import '../../data/repositories/finanzas_repository_impl.dart';
import '../../data/repositories/recoleccion_repository_impl.dart';

class ChatbotController extends GetxController {
  final GeminiService _aiService = GeminiService();
  final _finanzasRepository = FinanzasRepositoryImpl();
  final _recoleccionRepository = RecoleccionRepositoryImpl();

  final RxList<ChatMessageEntity> messages = <ChatMessageEntity>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  
  String? currentFincaId;
  FincaModel? currentFinca;

  @override
  void onInit() {
    super.onInit();
    try {
      GeminiService.initialize();
    } catch (e) {
      error.value = 'Error al inicializar Gemini: $e';
    }
  }

  /// Inicializar el chat con una finca específica
  Future<void> initializeChat(String fincaId) async {
    try {
      currentFincaId = fincaId;
      messages.clear();
      error.value = '';

      // Cargar datos de la finca desde Supabase
      final response = await SupabaseConfig.client
          .from('fincas')
          .select()
          .eq('id', fincaId)
          .single();

      currentFinca = FincaModel.fromJson(response);

      if (currentFinca != null) {
        // Mensaje de bienvenida
        final welcomeMessage = ChatMessageEntity(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          role: MessageRole.assistant,
          content: '''¡Hola! 👋 Soy tu asistente de gestión cafetera.

Estoy aquí para ayudarte con la finca "${currentFinca!.nombre}".

Puedo ayudarte con:
• Análisis de productividad
• Recomendaciones de cultivo
• Optimización de costos
• Estrategias de venta
• Mejores prácticas agrícolas

¿En qué puedo ayudarte hoy?''',
          timestamp: DateTime.now(),
        );
        messages.add(welcomeMessage);
      }
    } catch (e) {
      error.value = 'Error al inicializar chat: $e';
    }
  }

  /// Enviar un mensaje del usuario
  Future<void> sendMessage(String content) async {
    if (content.trim().isEmpty || currentFinca == null) return;

    try {
      isLoading.value = true;
      error.value = '';

      // Agregar mensaje del usuario
      final userMessage = ChatMessageEntity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        role: MessageRole.user,
        content: content,
        timestamp: DateTime.now(),
      );
      messages.add(userMessage);

      // Obtener contexto de la finca
      final fincaContext = await _buildFincaContext();

      // Generar respuesta
      final response = await _aiService.generateResponse(
        messages: messages.where((m) => m.role != MessageRole.system).toList(),
        fincaContext: fincaContext,
      );

      // Agregar respuesta del asistente
      final assistantMessage = ChatMessageEntity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        role: MessageRole.assistant,
        content: response,
        timestamp: DateTime.now(),
      );
      messages.add(assistantMessage);
    } catch (e) {
      error.value = 'Error al enviar mensaje: $e';
      Get.snackbar(
        'Error',
        'No se pudo generar la respuesta. Verifica tu conexión y API key.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Generar análisis completo de la finca
  Future<void> generateFullAnalysis() async {
    if (currentFinca == null) return;

    try {
      isLoading.value = true;
      error.value = '';

      final fincaContext = await _buildFincaContext();
      final analysis = await _aiService.generateFarmAnalysis(fincaContext);

      final analysisMessage = ChatMessageEntity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        role: MessageRole.assistant,
        content: '📊 **Análisis Completo de la Finca**\n\n$analysis',
        timestamp: DateTime.now(),
      );
      messages.add(analysisMessage);
    } catch (e) {
      error.value = 'Error al generar análisis: $e';
      Get.snackbar('Error', 'No se pudo generar el análisis');
    } finally {
      isLoading.value = false;
    }
  }

  /// Construir contexto de la finca con todos los datos relevantes
  Future<String> _buildFincaContext() async {
    if (currentFinca == null || currentFincaId == null) {
      return 'No hay datos de finca disponibles';
    }

    final StringBuffer context = StringBuffer();

    // Datos básicos de la finca
    context.writeln('INFORMACIÓN BÁSICA:');
    context.writeln('- Nombre: ${currentFinca!.nombre}');
    context.writeln('- Hectáreas: ${currentFinca!.hectareas} ha');
    context.writeln('- Tipo de café: ${currentFinca!.tipoCafe}');
    context.writeln('- Altura: ${currentFinca!.alturaMetros} metros sobre el nivel del mar');
    context.writeln('- Número de matas: ${currentFinca!.numeroMatas}');
    context.writeln('');

    try {
      // Datos de recolecciones (últimos 30 días)
      final recolecciones = await _recoleccionRepository.getRecoleccionesByFinca(currentFincaId!);
      if (recolecciones.isNotEmpty) {
        final totalKilos = recolecciones.fold<double>(0, (sum, r) => sum + r.kilosRecolectados);
        final totalPagos = recolecciones.fold<double>(0, (sum, r) => sum + (r.pagoDia ?? 0));
        
        context.writeln('DATOS DE RECOLECCIÓN (Últimos registros):');
        context.writeln('- Total kilos recolectados: ${totalKilos.toStringAsFixed(2)} kg');
        context.writeln('- Total pagos a trabajadores: \$${totalPagos.toStringAsFixed(2)}');
        context.writeln('- Número de recolecciones: ${recolecciones.length}');
        context.writeln('');
      }

      // Datos financieros
      final ingresos = await _finanzasRepository.getIngresosByFinca(currentFincaId!);
      final gastos = await _finanzasRepository.getGastosByFinca(currentFincaId!);

      if (ingresos.isNotEmpty) {
        final totalIngresos = ingresos.fold<double>(0, (sum, i) {
          if (i.cantidadKg != null && i.precioKg != null) {
            return sum + (i.cantidadKg! * i.precioKg!);
          }
          return sum + (i.total ?? 0);
        });
        final totalKgVendidos = ingresos.fold<double>(0, (sum, i) => sum + (i.cantidadKg ?? 0));

        context.writeln('DATOS DE VENTAS:');
        context.writeln('- Total ingresos: \$${totalIngresos.toStringAsFixed(2)}');
        context.writeln('- Total kg vendidos: ${totalKgVendidos.toStringAsFixed(2)} kg');
        context.writeln('- Número de ventas: ${ingresos.length}');
        if (totalKgVendidos > 0) {
          context.writeln('- Precio promedio por kg: \$${(totalIngresos / totalKgVendidos).toStringAsFixed(2)}');
        }
        context.writeln('');
      }

      if (gastos.isNotEmpty) {
        final totalGastos = gastos.fold<double>(0, (sum, g) => sum + g.monto);
        
        context.writeln('DATOS DE GASTOS:');
        context.writeln('- Total gastos: \$${totalGastos.toStringAsFixed(2)}');
        context.writeln('- Número de gastos: ${gastos.length}');
        context.writeln('');
      }

      // Calcular rentabilidad si hay datos
      if (ingresos.isNotEmpty && gastos.isNotEmpty) {
        final totalIngresos = ingresos.fold<double>(0, (sum, i) {
          if (i.cantidadKg != null && i.precioKg != null) {
            return sum + (i.cantidadKg! * i.precioKg!);
          }
          return sum + (i.total ?? 0);
        });
        final totalGastos = gastos.fold<double>(0, (sum, g) => sum + g.monto);
        final utilidad = totalIngresos - totalGastos;
        
        context.writeln('ANÁLISIS FINANCIERO:');
        context.writeln('- Utilidad: \$${utilidad.toStringAsFixed(2)}');
        context.writeln('- Margen: ${((utilidad / totalIngresos) * 100).toStringAsFixed(2)}%');
      }
    } catch (e) {
      context.writeln('Nota: Algunos datos financieros no están disponibles');
    }

    return context.toString();
  }

  /// Limpiar el chat
  void clearChat() {
    messages.clear();
    if (currentFinca != null) {
      initializeChat(currentFincaId!);
    }
  }
}
