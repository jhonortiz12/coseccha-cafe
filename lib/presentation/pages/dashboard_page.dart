import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/models/finca_model.dart';
import '../../core/config/supabase_config.dart';
import 'registro_finca_page.dart';
import 'login_page.dart';
import 'menu_gestion_page.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List<FincaModel> _fincas = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _cargarFincas();
  }

  Future<void> _cargarFincas() async {
    try {
      final userId = SupabaseConfig.client.auth.currentUser?.id;
      if (userId == null) return;

      final response = await SupabaseConfig.client
          .from('fincas')
          .select()
          .eq('user_id', userId);

      setState(() {
        _fincas = (response as List)
            .map((finca) => FincaModel.fromJson(finca))
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      print('Error cargando fincas: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Color(0xFF27AE60),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Mis Fincas',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(Icons.add_circle_outline, color: Colors.white, size: 28),
            onPressed: () async {
              await Get.to(() => RegistroFincaPage());
              _cargarFincas();
            },
          ),
          SizedBox(width: 8),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: Color(0xFF27AE60)))
          : _fincas.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.agriculture, size: 120, color: Colors.grey[300]),
                        SizedBox(height: 24),
                        Text(
                          'No tienes fincas registradas',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Comienza agregando tu primera finca cafetera',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 32),
                        ElevatedButton.icon(
                          onPressed: () async {
                            await Get.to(() => RegistroFincaPage());
                            _cargarFincas();
                          },
                          icon: Icon(Icons.add),
                          label: Text('Añadir Nueva Finca'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF27AE60),
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.all(20),
                  itemCount: _fincas.length,
                  itemBuilder: (context, index) {
                    final finca = _fincas[index];
                    return Card(
                      margin: EdgeInsets.only(bottom: 20),
                      elevation: 2,
                      shadowColor: Colors.black26,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: InkWell(
                        onTap: () {
                          if (finca.id != null) {
                            Get.to(() => MenuGestionPage(
                              fincaId: finca.id!,
                              fincaNombre: finca.nombre,
                            ));
                          } else {
                            Get.snackbar(
                              'Error',
                              'ID de finca no válido',
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          }
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Row(
                            children: [
                              // Ícono de la finca
                              Container(
                                width: 64,
                                height: 64,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Color(0xFF2ECC71),
                                      Color(0xFF27AE60),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(Icons.coffee, color: Colors.white, size: 32),
                              ),
                              SizedBox(width: 16),
                              // Información de la finca
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      finca.nombre,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Color(0xFF1F2937),
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Icon(Icons.landscape, size: 16, color: Colors.grey[600]),
                                        SizedBox(width: 4),
                                        Text(
                                          '${finca.hectareas} ha',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                        SizedBox(width: 16),
                                        Icon(Icons.eco, size: 16, color: Colors.grey[600]),
                                        SizedBox(width: 4),
                                        Text(
                                          '${finca.numeroMatas} matas',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Icon(Icons.terrain, size: 16, color: Colors.grey[600]),
                                        SizedBox(width: 4),
                                        Text(
                                          '${finca.alturaMetros} msnm',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              // Flecha
                              Icon(
                                Icons.arrow_forward_ios,
                                color: Color(0xFF27AE60),
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
