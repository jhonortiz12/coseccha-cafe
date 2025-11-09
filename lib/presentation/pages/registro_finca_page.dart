import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/finca.dart';
import '../../domain/entities/estudio_suelo.dart';
import '../../domain/models/finca_model.dart';
import '../../core/config/supabase_config.dart';
import 'home_page.dart';
import 'lista_fincas_page.dart';

class RegistroFincaPage extends StatefulWidget {
  @override
  _RegistroFincaPageState createState() => _RegistroFincaPageState();
}

class _RegistroFincaPageState extends State<RegistroFincaPage> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _fechaSembrado;
  bool _tieneEstudioSuelo = false;
  double? _altitudGPS;
  
  final _nombreController = TextEditingController();
  final _hectareasController = TextEditingController();
  final _matasController = TextEditingController();
  final _variedadController = TextEditingController();
  final _phController = TextEditingController();
  final _texturaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      // Verificar permisos
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('Permisos de ubicación denegados');
          return;
        }
      }
      
      if (permission == LocationPermission.deniedForever) {
        print('Permisos de ubicación denegados permanentemente');
        return;
      }

      // Obtener posición
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _altitudGPS = position.altitude;
      });
    } catch (e) {
      print('Error obteniendo ubicación: $e');
      // Establecer un valor por defecto si falla
      setState(() {
        _altitudGPS = 0.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Registro de Finca',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF27AE60),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header de Nueva Finca (separado y elegante)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF2ECC71),
                    Color(0xFF27AE60),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF27AE60).withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.agriculture,
                    size: 48,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Nueva Finca',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Registra los datos de tu finca cafetera',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white.withOpacity(0.95),
                    ),
                  ),
                ],
              ),
            ),
            // Formulario
            Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Datos Básicos',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 16),
              
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF27AE60).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.calendar_today,
                            color: Color(0xFF27AE60),
                          ),
                        ),
                        title: const Text(
                          'Fecha de sembrado',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        subtitle: Text(
                          _fechaSembrado != null
                              ? DateFormat('dd/MM/yyyy').format(_fechaSembrado!)
                              : 'Selecciona una fecha',
                          style: TextStyle(
                            color: _fechaSembrado != null
                                ? Colors.black87
                                : Colors.grey[600],
                          ),
                        ),
                        onTap: () async {
                          final fecha = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime.now(),
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: const ColorScheme.light(
                                    primary: Color(0xFF27AE60),
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (fecha != null) {
                            setState(() => _fechaSembrado = fecha);
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _nombreController,
                      decoration: InputDecoration(
                        labelText: 'Nombre de la finca',
                        prefixIcon: const Icon(Icons.agriculture, color: Color(0xFF27AE60)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFF27AE60), width: 2),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      validator: (v) => v?.isEmpty ?? true ? 'Campo requerido' : null,
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _hectareasController,
                      decoration: InputDecoration(
                        labelText: 'Hectáreas cultivadas',
                        prefixIcon: const Icon(Icons.landscape, color: Color(0xFF27AE60)),
                        suffixText: 'ha',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFF27AE60), width: 2),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      keyboardType: TextInputType.number,
                      validator: (v) => v?.isEmpty ?? true ? 'Campo requerido' : null,
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _matasController,
                      decoration: InputDecoration(
                        labelText: 'Número de matas',
                        prefixIcon: const Icon(Icons.grass, color: Color(0xFF27AE60)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFF27AE60), width: 2),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      keyboardType: TextInputType.number,
                      validator: (v) => v?.isEmpty ?? true ? 'Campo requerido' : null,
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _variedadController,
                      decoration: InputDecoration(
                        labelText: 'Variedad de café',
                        prefixIcon: const Icon(Icons.local_cafe, color: Color(0xFF27AE60)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFF27AE60), width: 2),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      validator: (v) => v?.isEmpty ?? true ? 'Campo requerido' : null,
                    ),
                    const SizedBox(height: 16),

                    Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFF27AE60).withOpacity(0.1),
                              const Color(0xFF2ECC71).withOpacity(0.05),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: _altitudGPS != null
                                  ? Colors.green.withOpacity(0.2)
                                  : Colors.orange.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.location_on,
                              color: _altitudGPS != null ? Colors.green : Colors.orange,
                            ),
                          ),
                          title: const Text(
                            'Altura sobre el nivel del mar',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                            _altitudGPS != null
                                ? '${_altitudGPS!.toStringAsFixed(0)} metros (msnm)'
                                : 'Obteniendo ubicación GPS...',
                          ),
                          trailing: _altitudGPS == null
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : IconButton(
                                  icon: const Icon(Icons.refresh),
                                  onPressed: _getCurrentLocation,
                                  tooltip: 'Actualizar ubicación',
                                  color: const Color(0xFF27AE60),
                                ),
                          onTap: _altitudGPS == null ? _getCurrentLocation : null,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: SwitchListTile(
                        title: const Text(
                          '¿Cuenta con estudio de suelos?',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        value: _tieneEstudioSuelo,
                        onChanged: (value) => setState(() => _tieneEstudioSuelo = value),
                        activeColor: const Color(0xFF27AE60),
                      ),
                    ),

                    if (_tieneEstudioSuelo) ...[
                      const SizedBox(height: 24),
                      const Text(
                        'Estudio de Suelos',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _phController,
                        decoration: InputDecoration(
                          labelText: 'Acidez (pH)',
                          prefixIcon: const Icon(Icons.science, color: Color(0xFF27AE60)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFF27AE60), width: 2),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        keyboardType: TextInputType.number,
                        validator: (v) => _tieneEstudioSuelo && (v?.isEmpty ?? true) ? 'Campo requerido' : null,
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _texturaController,
                        decoration: InputDecoration(
                          labelText: 'Textura del suelo',
                          prefixIcon: const Icon(Icons.terrain, color: Color(0xFF27AE60)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFF27AE60), width: 2),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        validator: (v) => _tieneEstudioSuelo && (v?.isEmpty ?? true) ? 'Campo requerido' : null,
                      ),
                    ],

                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF27AE60),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 3,
                        ),
                        child: const Text(
                          'Guardar Finca',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        final currentUser = SupabaseConfig.client.auth.currentUser;
        if (currentUser == null) {
          throw Exception('No hay usuario autenticado');
        }

        final finca = FincaModel(
          userId: currentUser.id,
          nombre: _nombreController.text,
          hectareas: double.parse(_hectareasController.text),
          tipoCafe: _variedadController.text,
          alturaMetros: _altitudGPS?.round() ?? 0,
          numeroMatas: int.parse(_matasController.text),
        );

        final response = await SupabaseConfig.client
            .from('fincas')
            .insert(finca.toJson())
            .select()
            .single();

        print('Finca guardada con éxito: $response');
        Get.snackbar(
          'Éxito',
          'Finca registrada correctamente',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        // Redirigir a la lista de fincas
        Get.offAll(() => ListaFincasPage());

      } catch (e) {
        print('Error al guardar finca: $e');
        Get.snackbar(
          'Error',
          'No se pudo guardar la finca: ${e.toString()}',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _hectareasController.dispose();
    _matasController.dispose();
    _variedadController.dispose();
    _phController.dispose();
    _texturaController.dispose();
    super.dispose();
  }
}
