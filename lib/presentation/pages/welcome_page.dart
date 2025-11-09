import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' as math;
import 'login_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo verde con patrón topográfico
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF2ECC71), // Verde claro
                  Color(0xFF27AE60), // Verde oscuro
                ],
              ),
            ),
            child: CustomPaint(
              painter: TopographicPainter(),
              size: Size.infinite,
            ),
          ),

          // Texto "CosechaCafetera" en la parte superior izquierda
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 24.0, top: 104.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'CosechaCafetera',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.8,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.3),
                        offset: Offset(2, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Contenido principal
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 24),
                          Text(
                            'Bienvenido',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                          SizedBox(height: 12),
                          Text(
                            'Gestiona tus fincas y tareas de manera eficiente. Organiza tu trabajo agrícola con nuestra aplicación.',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey[600],
                              height: 1.5,
                            ),
                          ),
                          SizedBox(height: 32),
                          // Botón Continue
                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () {
                                Get.off(() => const LoginPage());
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 16,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFF2ECC71),
                                      Color(0xFF27AE60),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0xFF2ECC71).withOpacity(0.3),
                                      blurRadius: 12,
                                      offset: Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Continuar',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Icon(
                                      Icons.arrow_forward,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 24),
                        ],
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

// Painter para crear el patrón topográfico
class TopographicPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Dibujar líneas topográficas curvas
    for (int i = 0; i < 8; i++) {
      final path = Path();
      final yOffset = size.height * 0.1 * i;
      
      path.moveTo(0, yOffset);
      
      for (double x = 0; x <= size.width; x += 20) {
        final y = yOffset + 
                  30 * math.sin(x * 0.02 + i * 0.5) + 
                  20 * math.cos(x * 0.015 + i * 0.3);
        path.lineTo(x, y);
      }
      
      canvas.drawPath(path, paint);
    }

    // Dibujar círculos concéntricos (como en el diseño)
    final circlePaint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Círculo 1
    for (int i = 1; i <= 5; i++) {
      canvas.drawCircle(
        Offset(size.width * 0.3, size.height * 0.25),
        30.0 * i,
        circlePaint,
      );
    }

    // Círculo 2
    for (int i = 1; i <= 4; i++) {
      canvas.drawCircle(
        Offset(size.width * 0.7, size.height * 0.45),
        25.0 * i,
        circlePaint,
      );
    }

    // Formas orgánicas adicionales
    final organicPaint = Paint()
      ..color = Colors.white.withOpacity(0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    // Forma orgánica 1
    final organicPath1 = Path();
    organicPath1.moveTo(size.width * 0.1, size.height * 0.4);
    organicPath1.quadraticBezierTo(
      size.width * 0.25, size.height * 0.35,
      size.width * 0.4, size.height * 0.42,
    );
    organicPath1.quadraticBezierTo(
      size.width * 0.5, size.height * 0.47,
      size.width * 0.6, size.height * 0.4,
    );
    canvas.drawPath(organicPath1, organicPaint);

    // Forma orgánica 2
    final organicPath2 = Path();
    organicPath2.moveTo(size.width * 0.5, size.height * 0.15);
    organicPath2.quadraticBezierTo(
      size.width * 0.65, size.height * 0.2,
      size.width * 0.8, size.height * 0.18,
    );
    canvas.drawPath(organicPath2, organicPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

