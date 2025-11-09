import '../../domain/entities/recoleccion_entity.dart';

class RecoleccionModel extends RecoleccionEntity {
  RecoleccionModel({
    required super.id,
    required super.empleadoId,
    required super.fincaId,
    required super.fecha,
    super.lote,
    required super.kilosRecolectados,
    super.pagoDia,
    super.observaciones,
    required super.createdAt,
    super.empleadoNombre,
  });

  factory RecoleccionModel.fromJson(Map<String, dynamic> json) {
    return RecoleccionModel(
      id: json['id'] as String,
      empleadoId: json['empleado_id'] as String,
      fincaId: json['finca_id'] as String,
      fecha: DateTime.parse(json['fecha'] as String),
      lote: json['lote'] as String?,
      kilosRecolectados: double.parse(json['kilos_recolectados'].toString()),
      pagoDia: json['pago_dia'] != null ? double.parse(json['pago_dia'].toString()) : null,
      observaciones: json['observaciones'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      empleadoNombre: json['empleado_nombre'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'empleado_id': empleadoId,
      'finca_id': fincaId,
      'fecha': fecha.toIso8601String().split('T')[0],
      'lote': lote,
      'kilos_recolectados': kilosRecolectados,
      'pago_dia': pagoDia,
      'observaciones': observaciones,
      'created_at': createdAt.toIso8601String(),
    };
  }

  Map<String, dynamic> toJsonForInsert() {
    return {
      'empleado_id': empleadoId,
      'finca_id': fincaId,
      'fecha': fecha.toIso8601String().split('T')[0],
      'lote': lote,
      'kilos_recolectados': kilosRecolectados,
      'pago_dia': pagoDia,
      'observaciones': observaciones,
    };
  }

  RecoleccionEntity toEntity() {
    return RecoleccionEntity(
      id: id,
      empleadoId: empleadoId,
      fincaId: fincaId,
      fecha: fecha,
      lote: lote,
      kilosRecolectados: kilosRecolectados,
      pagoDia: pagoDia,
      observaciones: observaciones,
      createdAt: createdAt,
      empleadoNombre: empleadoNombre,
    );
  }
}
