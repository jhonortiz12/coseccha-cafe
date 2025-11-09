import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dashboard_page.dart';
import 'finanzas_page.dart';
import 'recolecciones_page.dart';
import 'empleados_page.dart';
import 'menu_gestion_page.dart';
import '../../core/config/supabase_config.dart';
import '../../core/services/finca_preferences_service.dart';
import '../../core/services/auth_service.dart';
import 'login_page.dart';
import 'lista_fincas_page.dart';

/// Página principal con BottomNavigationBar para navegación entre secciones
class MainNavigationPage extends StatefulWidget {
  final String? fincaId;
  final String? fincaNombre;

  const MainNavigationPage({
    Key? key,
    this.fincaId,
    this.fincaNombre,
  }) : super(key: key);

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _selectedIndex = 0;

  // Lista de páginas según el índice seleccionado
  List<Widget> _getPages() {
    if (widget.fincaId != null) {
      return [
        _buildDashboardWithFinca(),
        EmpleadosPage(fincaId: widget.fincaId!),
        RecoleccionesPage(fincaId: widget.fincaId!),
        FinanzasPage(fincaId: widget.fincaId!),
      ];
    }
    return [
      DashboardPage(),
      _buildEmptyPage('Empleados', Icons.people),
      _buildEmptyPage('Recolección', Icons.agriculture),
      _buildEmptyPage('Finanzas', Icons.attach_money),
    ];
  }

  Widget _buildDashboardWithFinca() {
    return MenuGestionPage(
      fincaId: widget.fincaId!,
      fincaNombre: widget.fincaNombre!,
    );
  }

  Widget _buildEmptyPage(String title, IconData icon) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: const Color(0xFF27AE60),
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Selecciona una finca primero',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerfilPage() {
    final user = SupabaseConfig.client.auth.currentUser;
    final userName = user?.userMetadata?['nombre'] ?? 'Usuario';
    final userEmail = user?.email ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        backgroundColor: const Color(0xFF27AE60),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header con gradiente
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF2ECC71),
                    Color(0xFF27AE60),
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        size: 60,
                        color: Color(0xFF27AE60),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      userName,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      userEmail,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Opciones de perfil
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  const Text(
                    'Configuración',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Card de opciones
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        _buildProfileOption(
                          icon: Icons.person_outline,
                          title: 'Editar Perfil',
                          onTap: () {
                            Get.snackbar(
                              'Próximamente',
                              'Función en desarrollo',
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          },
                        ),
                        const Divider(height: 1),
                        _buildProfileOption(
                          icon: Icons.notifications_outlined,
                          title: 'Notificaciones',
                          onTap: () {
                            Get.snackbar(
                              'Próximamente',
                              'Función en desarrollo',
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          },
                        ),
                        const Divider(height: 1),
                        _buildProfileOption(
                          icon: Icons.help_outline,
                          title: 'Ayuda y Soporte',
                          onTap: () {
                            Get.snackbar(
                              'Próximamente',
                              'Función en desarrollo',
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Botón de cerrar sesión
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        await FincaPreferencesService.clearFincaSeleccionada();
                        await AuthService.logout();
                        Get.offAll(() => const LoginPage());
                      },
                      icon: const Icon(Icons.logout),
                      label: const Text('Cerrar Sesión'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF27AE60)),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _getPages(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color(0xFF27AE60),
        unselectedItemColor: Colors.grey,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Empleados',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.agriculture),
            label: 'Recolección',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: 'Finanzas',
          ),
        ],
      ),
    );
  }
}
