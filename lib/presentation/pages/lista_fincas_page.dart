import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'registro_finca_page.dart';
import 'main_navigation_page.dart';
import '../../domain/models/finca_model.dart';
import '../../core/config/supabase_config.dart';
import '../../core/services/finca_preferences_service.dart';
import '../../core/services/auth_service.dart';
import 'login_page.dart';

class ListaFincasPage extends StatefulWidget {
  @override
  State<ListaFincasPage> createState() => _ListaFincasPageState();
}

class _ListaFincasPageState extends State<ListaFincasPage> {
  List<FincaModel> _fincas = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _cargarFincas();
  }

  Future<void> _cargarFincas() async {
    try {
      setState(() => _isLoading = true);
      
      final currentUser = SupabaseConfig.client.auth.currentUser;
      if (currentUser == null) {
        Get.offAll(() => const LoginPage());
        return;
      }

      final response = await SupabaseConfig.client
          .from('fincas')
          .select()
          .eq('user_id', currentUser.id)
          .order('created_at', ascending: false);

      setState(() {
        _fincas = (response as List)
            .map((json) => FincaModel.fromJson(json))
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      print('Error cargando fincas: $e');
      setState(() => _isLoading = false);
      Get.snackbar(
        'Error',
        'No se pudieron cargar las fincas',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _confirmarEliminarFinca(FincaModel finca) async {
    final confirmar = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Eliminar Finca'),
        content: Text('¿Estás seguro de que deseas eliminar la finca "${finca.nombre}"?\n\nEsta acción no se puede deshacer y eliminará todos los datos asociados.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      await _eliminarFinca(finca.id!);
    }
  }

  Future<void> _eliminarFinca(String fincaId) async {
    try {
      // Verificar si es la finca seleccionada actualmente
      final fincaSeleccionada = await FincaPreferencesService.getFincaId();
      if (fincaSeleccionada == fincaId) {
        await FincaPreferencesService.clearFincaSeleccionada();
      }

      await SupabaseConfig.client
          .from('fincas')
          .delete()
          .eq('id', fincaId);

      Get.snackbar(
        'Éxito',
        'Finca eliminada correctamente',
        backgroundColor: const Color(0xFF27AE60),
        colorText: Colors.white,
      );

      _cargarFincas();
    } catch (e) {
      print('Error eliminando finca: $e');
      Get.snackbar(
        'Error',
        'No se pudo eliminar la finca',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mis Fincas',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF27AE60),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FincaPreferencesService.clearFincaSeleccionada();
              await AuthService.logout();
              Get.offAll(() => const LoginPage());
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _fincas.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.agriculture, size: 80, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      const Text(
                        'No tienes fincas registradas',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: () async {
                          await Get.to(() => RegistroFincaPage());
                          _cargarFincas();
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Añadir Finca'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF27AE60),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _fincas.length,
                  itemBuilder: (context, index) {
                    final finca = _fincas[index];
                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: InkWell(
                        onTap: () async {
                          // Guardar la finca seleccionada
                          await FincaPreferencesService.saveFincaSeleccionada(
                            fincaId: finca.id!,
                            fincaNombre: finca.nombre,
                          );
                          
                          Get.offAll(() => MainNavigationPage(
                                fincaId: finca.id!,
                                fincaNombre: finca.nombre,
                              ));
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFF2ECC71),
                                Color(0xFF27AE60),
                              ],
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(
                                      Icons.agriculture,
                                      color: Colors.white,
                                      size: 32,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          finca.nombre,
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          finca.tipoCafe,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color:
                                                Colors.white.withOpacity(0.9),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                          Icons.delete_outline,
                                          color: Colors.white,
                                          size: 24,
                                        ),
                                        onPressed: () => _confirmarEliminarFinca(finca),
                                      ),
                                      const Icon(
                                        Icons.arrow_forward_ios,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildInfoChip(
                                      Icons.landscape,
                                      '${finca.hectareas} ha',
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: _buildInfoChip(
                                      Icons.height,
                                      '${finca.alturaMetros} msnm',
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: _fincas.isNotEmpty
          ? FloatingActionButton(
              onPressed: () async {
                await Get.to(() => RegistroFincaPage());
                _cargarFincas();
              },
              backgroundColor: const Color(0xFF27AE60),
              child: const Icon(Icons.add),
              tooltip: 'Añadir Finca',
            )
          : null,
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 16),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
