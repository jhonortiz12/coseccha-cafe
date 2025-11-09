import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

/// Helper para mostrar DatePicker en español con color verde
class DatePickerHelper {
  static Future<DateTime?> showSpanishDatePicker({
    required BuildContext context,
    required DateTime initialDate,
    required DateTime firstDate,
    required DateTime lastDate,
  }) async {
    return await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      locale: const Locale('es', 'ES'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF27AE60), // Color verde para selección
              onPrimary: Colors.white, // Color del texto en el día seleccionado
              onSurface: Colors.black, // Color del texto de los días
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF27AE60), // Color de los botones
              ),
            ),
          ),
          child: child!,
        );
      },
    );
  }
}
