import 'package:intl/intl.dart';

/// Utilidades para formatear números
class NumberFormatter {
  /// Formatea un número con separador de miles (punto)
  /// Ejemplo: 100000 -> "100.000"
  static String formatWithThousands(dynamic number) {
    if (number == null) return '0';
    
    final formatter = NumberFormat('#,##0', 'es_ES');
    
    if (number is String) {
      final parsed = double.tryParse(number);
      if (parsed == null) return number;
      return formatter.format(parsed).replaceAll(',', '.');
    }
    
    return formatter.format(number).replaceAll(',', '.');
  }

  /// Formatea un número como moneda (peso colombiano)
  /// Ejemplo: 100000 -> "$100.000"
  static String formatCurrency(dynamic number) {
    if (number == null) return '\$0';
    
    final formatter = NumberFormat('#,##0', 'es_ES');
    
    if (number is String) {
      final parsed = double.tryParse(number);
      if (parsed == null) return '\$$number';
      return '\$${formatter.format(parsed).replaceAll(',', '.')}';
    }
    
    return '\$${formatter.format(number).replaceAll(',', '.')}';
  }

  /// Formatea un número decimal con separador de miles
  /// Ejemplo: 100000.50 -> "100.000,50"
  static String formatDecimal(dynamic number, {int decimals = 2}) {
    if (number == null) return '0';
    
    final formatter = NumberFormat('#,##0.${'0' * decimals}', 'es_ES');
    
    if (number is String) {
      final parsed = double.tryParse(number);
      if (parsed == null) return number;
      // Primero reemplazar comas por TEMP, luego puntos por comas, luego TEMP por puntos
      return formatter.format(parsed)
          .replaceAll(',', 'TEMP')
          .replaceAll('.', ',')
          .replaceAll('TEMP', '.');
    }
    
    return formatter.format(number)
        .replaceAll(',', 'TEMP')
        .replaceAll('.', ',')
        .replaceAll('TEMP', '.');
  }

  /// Remueve el formato de un string con separadores
  /// Ejemplo: "100.000" -> 100000
  static double? parseFormattedNumber(String formattedNumber) {
    if (formattedNumber.isEmpty) return null;
    
    // Remover puntos (separadores de miles) y reemplazar coma por punto (decimal)
    final cleaned = formattedNumber
        .replaceAll('.', '')
        .replaceAll(',', '.')
        .replaceAll('\$', '')
        .trim();
    
    return double.tryParse(cleaned);
  }
}
