class FincaEntity {
  final String id;
  final String userId;
  final String nombre;
  final double hectares;
  final String tipoCafe;
  final int alturaMetros;
  final int numeroMatas;
  final DateTime createdAt;

  FincaEntity({
    required this.id,
    required this.userId,
    required this.nombre,
    required this.hectares,
    required this.tipoCafe,
    required this.alturaMetros,
    required this.numeroMatas,
    required this.createdAt,
  });
}