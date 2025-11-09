class RecoleccionEntity {
  final String id;
  final String empleadoId;
  final String fincaId;
  final DateTime fecha;
  final String? lote;
  final double kilosRecolectados;
  final double? pagoDia;
  final String? observaciones;
  final DateTime createdAt;

  // Datos relacionados (opcional, para vistas con JOIN)
  final String? empleadoNombre;

  RecoleccionEntity({
    required this.id,
    required this.empleadoId,
    required this.fincaId,
    required this.fecha,
    this.lote,
    required this.kilosRecolectados,
    this.pagoDia,
    this.observaciones,
    required this.createdAt,
    this.empleadoNombre,
  });

  RecoleccionEntity copyWith({
    String? id,
    String? empleadoId,
    String? fincaId,
    DateTime? fecha,
    String? lote,
    double? kilosRecolectados,
    double? pagoDia,
    String? observaciones,
    DateTime? createdAt,
    String? empleadoNombre,
  }) {
    return RecoleccionEntity(
      id: id ?? this.id,
      empleadoId: empleadoId ?? this.empleadoId,
      fincaId: fincaId ?? this.fincaId,
      fecha: fecha ?? this.fecha,
      lote: lote ?? this.lote,
      kilosRecolectados: kilosRecolectados ?? this.kilosRecolectados,
      pagoDia: pagoDia ?? this.pagoDia,
      observaciones: observaciones ?? this.observaciones,
      createdAt: createdAt ?? this.createdAt,
      empleadoNombre: empleadoNombre ?? this.empleadoNombre,
    );
  }
}
