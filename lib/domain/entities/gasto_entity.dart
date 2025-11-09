class GastoEntity {
  final String id;
  final String fincaId;
  final String? categoriaId;
  final DateTime fecha;
  final String descripcion;
  final double monto;
  final String? proveedor;
  final String? comprobanteUrl;
  final String? observaciones;
  final DateTime createdAt;

  // Datos relacionados (opcional)
  final String? categoriaNombre;

  GastoEntity({
    required this.id,
    required this.fincaId,
    this.categoriaId,
    required this.fecha,
    required this.descripcion,
    required this.monto,
    this.proveedor,
    this.comprobanteUrl,
    this.observaciones,
    required this.createdAt,
    this.categoriaNombre,
  });

  GastoEntity copyWith({
    String? id,
    String? fincaId,
    String? categoriaId,
    DateTime? fecha,
    String? descripcion,
    double? monto,
    String? proveedor,
    String? comprobanteUrl,
    String? observaciones,
    DateTime? createdAt,
    String? categoriaNombre,
  }) {
    return GastoEntity(
      id: id ?? this.id,
      fincaId: fincaId ?? this.fincaId,
      categoriaId: categoriaId ?? this.categoriaId,
      fecha: fecha ?? this.fecha,
      descripcion: descripcion ?? this.descripcion,
      monto: monto ?? this.monto,
      proveedor: proveedor ?? this.proveedor,
      comprobanteUrl: comprobanteUrl ?? this.comprobanteUrl,
      observaciones: observaciones ?? this.observaciones,
      createdAt: createdAt ?? this.createdAt,
      categoriaNombre: categoriaNombre ?? this.categoriaNombre,
    );
  }
}
