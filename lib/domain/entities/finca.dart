import 'estudio_suelo.dart';

class Finca {
  final String id;
  final DateTime fechaSembrado;
  final String nombre;
  final double hectareas;
  final int numeroMatas;
  final String variedadCafe;
  final double altitud;
  final bool tieneEstudioSuelo;
  final EstudioSuelo? estudioSuelo;

  Finca({
    required this.id,
    required this.fechaSembrado,
    required this.nombre, 
    required this.hectareas,
    required this.numeroMatas,
    required this.variedadCafe,
    required this.altitud,
    required this.tieneEstudioSuelo,
    this.estudioSuelo,
  });
}
