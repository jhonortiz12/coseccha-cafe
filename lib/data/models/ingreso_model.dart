import '../../domain/entities/ingreso_entity.dart';

class IngresoModel extends IngresoEntity {
  IngresoModel({
    required super.id,
    required super.fincaId,
    super.categoriaId,
    required super.fecha,
    required super.descripcion,
    super.cantidadKg,
    super.precioKg,
    super.total,
    super.metodoPago,
    super.observaciones,
    required super.createdAt,
    super.categoriaNombre,
  });

  factory IngresoModel.fromJson(Map<String, dynamic> json) {
    return IngresoModel(
      id: json['id'] as String,
      fincaId: json['finca_id'] as String,
      categoriaId: json['categoria_id'] as String?,
      fecha: DateTime.parse(json['fecha'] as String),
      descripcion: json['descripcion'] as String,
      cantidadKg: json['cantidad_kg'] != null 
          ? double.parse(json['cantidad_kg'].toString()) 
          : null,
      precioKg: json['precio_kg'] != null 
          ? double.parse(json['precio_kg'].toString()) 
          : null,
      total: json['total'] != null 
          ? double.parse(json['total'].toString()) 
          : null,
      metodoPago: json['metodo_pago'] != null 
          ? _parseMetodoPago(json['metodo_pago'] as String) 
          : null,
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
      'cantidad_kg': cantidadKg,
      'precio_kg': precioKg,
      'metodo_pago': metodoPago?.name,
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
      'cantidad_kg': cantidadKg,
      'precio_kg': precioKg,
      'metodo_pago': metodoPago?.name,
      'observaciones': observaciones,
    };
  }

  static MetodoPago _parseMetodoPago(String metodo) {
    switch (metodo.toLowerCase()) {
      case 'efectivo':
        return MetodoPago.efectivo;
      case 'transferencia':
        return MetodoPago.transferencia;
      case 'cheque':
        return MetodoPago.cheque;
      case 'otro':
        return MetodoPago.otro;
      default:
        return MetodoPago.efectivo;
    }
  }

  IngresoEntity toEntity() {
    return IngresoEntity(
      id: id,
      fincaId: fincaId,
      categoriaId: categoriaId,
      fecha: fecha,
      descripcion: descripcion,
      cantidadKg: cantidadKg,
      precioKg: precioKg,
      total: total,
      metodoPago: metodoPago,
      observaciones: observaciones,
      createdAt: createdAt,
      categoriaNombre: categoriaNombre,
    );
  }
}
