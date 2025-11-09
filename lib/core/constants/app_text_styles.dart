import 'package:flutter/material.dart';

/// Estilos de texto consistentes para toda la aplicación
class AppTextStyles {
  // Títulos principales
  static const TextStyle heading1 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: Color(0xFF1F2937),
    letterSpacing: 0.5,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: Color(0xFF1F2937),
    letterSpacing: 0.3,
  );

  static const TextStyle heading3 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Color(0xFF1F2937),
  );

  // Texto normal
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    color: Color(0xFF374151),
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    color: Color(0xFF6B7280),
    height: 1.4,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    color: Color(0xFF9CA3AF),
  );

  // Texto en botones
  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );

  // Subtítulos
  static const TextStyle subtitle = TextStyle(
    fontSize: 14,
    color: Color(0xFF6B7280),
    fontWeight: FontWeight.w500,
  );

  // Texto de caption
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    color: Color(0xFF9CA3AF),
    fontWeight: FontWeight.w400,
  );

  // Texto en blanco (para fondos oscuros)
  static const TextStyle whiteHeading = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    letterSpacing: 0.5,
  );

  static const TextStyle whiteBody = TextStyle(
    fontSize: 16,
    color: Colors.white,
  );
}
