class IngresoEntity {
  final String id;
  final String fincaId;
  final String? categoriaId;
  final DateTime fecha;
  final String descripcion;
  final double? cantidadKg;
  final double? precioKg;
  final double? total;
  final MetodoPago? metodoPago;
  final String? observaciones;
  final DateTime createdAt;

  // Datos relacionados (opcional)
  final String? categoriaNombre;

  IngresoEntity({
    required this.id,
    required this.fincaId,
    this.categoriaId,
    required this.fecha,
    required this.descripcion,
    this.cantidadKg,
    this.precioKg,
    this.total,
    this.metodoPago,
    this.observaciones,
    required this.createdAt,
    this.categoriaNombre,
  });

  IngresoEntity copyWith({
    String? id,
    String? fincaId,
    String? categoriaId,
    DateTime? fecha,
    String? descripcion,
    double? cantidadKg,
    double? precioKg,
    double? total,
    MetodoPago? metodoPago,
    String? observaciones,
    DateTime? createdAt,
    String? categoriaNombre,
  }) {
    return IngresoEntity(
      id: id ?? this.id,
      fincaId: fincaId ?? this.fincaId,
      categoriaId: categoriaId ?? this.categoriaId,
      fecha: fecha ?? this.fecha,
      descripcion: descripcion ?? this.descripcion,
      cantidadKg: cantidadKg ?? this.cantidadKg,
      precioKg: precioKg ?? this.precioKg,
      total: total ?? this.total,
      metodoPago: metodoPago ?? this.metodoPago,
      observaciones: observaciones ?? this.observaciones,
      createdAt: createdAt ?? this.createdAt,
      categoriaNombre: categoriaNombre ?? this.categoriaNombre,
    );
  }
}

enum MetodoPago {
  efectivo,
  transferencia,
  cheque,
  otro;

  String get displayName {
    switch (this) {
      case MetodoPago.efectivo:
        return 'Efectivo';
      case MetodoPago.transferencia:
        return 'Transferencia';
      case MetodoPago.cheque:
        return 'Cheque';
      case MetodoPago.otro:
        return 'Otro';
    }
  }
}
