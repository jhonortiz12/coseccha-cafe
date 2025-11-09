import '../../domain/entities/gasto_entity.dart';

class GastoModel extends GastoEntity {
  GastoModel({
    required super.id,
    required super.fincaId,
    super.categoriaId,
    required super.fecha,
    required super.descripcion,
    required super.monto,
    super.proveedor,
    super.comprobanteUrl,
    super.observaciones,
    required super.createdAt,
    super.categoriaNombre,
  });

  factory GastoModel.fromJson(Map<String, dynamic> json) {
    return GastoModel(
      id: json['id'] as String,
      fincaId: json['finca_id'] as String,
      categoriaId: json['categoria_id'] as String?,
      fecha: DateTime.parse(json['fecha'] as String),
      descripcion: json['descripcion'] as String,
      monto: double.parse(json['monto'].toString()),
      proveedor: json['proveedor'] as String?,
      comprobanteUrl: json['comprobante_url'] as String?,
      observaciones: json['observaciones'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      categoriaNombre: json['categoria_nombre'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'finca_id': fincaId,
      'categoria_id': categoriaId,
      'fecha': fecha.toIso8601String().split('T')[0],
      'descripcion': descripcion,
      'monto': monto,
      'proveedor': proveedor,
      'comprobante_url': comprobanteUrl,
      'observaciones': observaciones,
      'created_at': createdAt.toIso8601String(),
    };
  }

  Map<String, dynamic> toJsonForInsert() {
    return {
      'finca_id': fincaId,
      'categoria_id': categoriaId,
      'fecha': fecha.toIso8601String().split('T')[0],
      'descripcion': descripcion,
      'monto': monto,
      'proveedor': proveedor,
      'comprobante_url': comprobanteUrl,
      'observaciones': observaciones,
    };
  }

  GastoEntity toEntity() {
    return GastoEntity(
      id: id,
      fincaId: fincaId,
      categoriaId: categoriaId,
      fecha: fecha,
      descripcion: descripcion,
      monto: monto,
      proveedor: proveedor,
      comprobanteUrl: comprobanteUrl,
      observaciones: observaciones,
      createdAt: createdAt,
      categoriaNombre: categoriaNombre,
    );
  }
}
