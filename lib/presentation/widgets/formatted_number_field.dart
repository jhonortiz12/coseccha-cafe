import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/utils/number_formatter.dart';

/// TextField que formatea números automáticamente con separador de miles
class FormattedNumberField extends StatefulWidget {
  final TextEditingController controller;
  final String? labelText;
  final String? hintText;
  final String? prefixText;
  final IconData? prefixIcon;
  final bool enabled;
  final int? maxLength;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;

  const FormattedNumberField({
    Key? key,
    required this.controller,
    this.labelText,
    this.hintText,
    this.prefixText,
    this.prefixIcon,
    this.enabled = true,
    this.maxLength,
    this.validator,
    this.onChanged,
  }) : super(key: key);

  @override
  State<FormattedNumberField> createState() => _FormattedNumberFieldState();
}

class _FormattedNumberFieldState extends State<FormattedNumberField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      enabled: widget.enabled,
      keyboardType: TextInputType.number,
      maxLength: widget.maxLength,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        ThousandsSeparatorInputFormatter(),
      ],
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        prefixText: widget.prefixText,
        prefixIcon: widget.prefixIcon != null ? Icon(widget.prefixIcon) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFF27AE60), width: 2),
        ),
        counterText: '',
      ),
      validator: widget.validator,
      onChanged: widget.onChanged,
    );
  }
}

/// Formateador que agrega puntos cada 3 dígitos mientras escribes
class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Remover todos los puntos existentes
    String newText = newValue.text.replaceAll('.', '');

    // Si solo hay dígitos, formatear
    if (RegExp(r'^\d+$').hasMatch(newText)) {
      // Agregar puntos cada 3 dígitos desde la derecha
      String formatted = '';
      int count = 0;

      for (int i = newText.length - 1; i >= 0; i--) {
        if (count == 3) {
          formatted = '.$formatted';
          count = 0;
        }
        formatted = newText[i] + formatted;
        count++;
      }

      // Calcular la nueva posición del cursor
      int cursorPosition = formatted.length;
      
      // Si el usuario está escribiendo, mantener el cursor al final
      if (newValue.selection.baseOffset == newValue.text.length) {
        cursorPosition = formatted.length;
      } else {
        // Ajustar la posición del cursor considerando los puntos agregados
        int digitsBeforeCursor = newValue.selection.baseOffset;
        int dotsBeforeCursor = 0;
        int digitCount = 0;
        
        for (int i = 0; i < formatted.length && digitCount < digitsBeforeCursor; i++) {
          if (formatted[i] == '.') {
            dotsBeforeCursor++;
          } else {
            digitCount++;
          }
        }
        
        cursorPosition = digitsBeforeCursor + dotsBeforeCursor;
      }

      return TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: cursorPosition),
      );
    }

    return newValue;
  }
}

/// TextField para moneda con símbolo de peso
class CurrencyFormattedField extends StatelessWidget {
  final TextEditingController controller;
  final String? labelText;
  final String? hintText;
  final bool enabled;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;

  const CurrencyFormattedField({
    Key? key,
    required this.controller,
    this.labelText,
    this.hintText,
    this.enabled = true,
    this.validator,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FormattedNumberField(
      controller: controller,
      labelText: labelText,
      hintText: hintText,
      prefixText: '\$ ',
      prefixIcon: Icons.attach_money,
      enabled: enabled,
      validator: validator,
      onChanged: onChanged,
    );
  }
}
