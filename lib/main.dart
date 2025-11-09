import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'presentation/pages/home_page.dart';
import 'presentation/pages/login_page.dart';
import 'presentation/pages/welcome_page.dart';
import 'presentation/pages/lista_fincas_page.dart';
import 'presentation/pages/main_navigation_page.dart';
import 'core/constants/app_colors.dart';
import 'core/config/supabase_config.dart';
import 'core/services/auth_service.dart';
import 'core/services/finca_preferences_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // Load environment variables
    await dotenv.load(fileName: ".env");
    
    // Initialize Supabase
    await SupabaseConfig.initialize();
    runApp(MyApp());
  } catch (e) {
    // If initialization fails, show error and run app anyway
    print('Error initializing: $e');
    runApp(MyApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'CosechaCafetera',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF27AE60)),
        useMaterial3: true,
        fontFamily: 'SF Pro Display',
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es', 'ES'),
        Locale('en', 'US'),
      ],
      locale: const Locale('es', 'ES'),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

/// Pantalla de carga inicial que verifica la sesión
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    // Esperar un momento para mostrar el splash
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      // Verificar si hay sesión guardada
      final isLoggedIn = await AuthService.isLoggedIn();
      final currentUser = await AuthService.getCurrentUser();

      if (isLoggedIn && currentUser != null) {
        // Hay sesión activa, verificar si hay finca seleccionada
        final fincaData = await FincaPreferencesService.getFincaSeleccionada();
        
        if (fincaData != null) {
          // Ir directamente a la navegación principal
          Get.offAll(() => MainNavigationPage(
            fincaId: fincaData['id']!,
            fincaNombre: fincaData['nombre']!,
          ));
        } else {
          // Ir a seleccionar finca
          Get.offAll(() => ListaFincasPage());
        }
      } else {
        // No hay sesión, ir a welcome
        Get.offAll(() => const WelcomePage());
      }
    } catch (e) {
      print('Error checking session: $e');
      // En caso de error, ir a welcome
      Get.offAll(() => const WelcomePage());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF2ECC71),
              Color(0xFF27AE60),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'CosechaCafetera',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 0.8,
                ),
              ),
              SizedBox(height: 24),
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}