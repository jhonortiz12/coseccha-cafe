import '../../domain/entities/empleado_entity.dart';

class EmpleadoModel extends EmpleadoEntity {
  EmpleadoModel({
    required super.id,
    required super.fincaId,
    required super.nombre,
    required super.cedula,
    required super.tipoEmpleado,
    super.cargo,
    super.salario,
    required super.fechaContratacion,
    required super.activo,
    required super.createdAt,
  });

  factory EmpleadoModel.fromJson(Map<String, dynamic> json) {
    return EmpleadoModel(
      id: json['id'] as String,
      fincaId: json['finca_id'] as String,
      nombre: json['nombre'] as String,
      cedula: json['cedula'] as String,
      tipoEmpleado: _parseTipoEmpleado(json['tipo_empleado'] as String),
      cargo: json['cargo'] as String?,
      salario: json['salario'] != null 
          ? double.parse(json['salario'].toString()) 
          : null,
      fechaContratacion: DateTime.parse(json['fecha_contratacion'] as String),
      activo: json['activo'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'finca_id': fincaId,
      'nombre': nombre,
      'cedula': cedula,
      'tipo_empleado': tipoEmpleado.name,
      'cargo': cargo,
      'salario': salario,
      'fecha_contratacion': fechaContratacion.toIso8601String().split('T')[0],
      'activo': activo,
      'created_at': createdAt.toIso8601String(),
    };
  }

  Map<String, dynamic> toJsonForInsert() {
    return {
      'finca_id': fincaId,
      'nombre': nombre,
      'cedula': cedula,
      'tipo_empleado': tipoEmpleado.name,
      'cargo': cargo,
      'salario': salario,
      'fecha_contratacion': fechaContratacion.toIso8601String().split('T')[0],
      'activo': activo,
    };
  }

  static TipoEmpleado _parseTipoEmpleado(String tipo) {
    switch (tipo.toLowerCase()) {
      case 'temporal':
        return TipoEmpleado.temporal;
      case 'permanente':
        return TipoEmpleado.permanente;
      default:
        return TipoEmpleado.temporal;
    }
  }

  EmpleadoEntity toEntity() {
    return EmpleadoEntity(
      id: id,
      fincaId: fincaId,
      nombre: nombre,
      cedula: cedula,
      tipoEmpleado: tipoEmpleado,
      cargo: cargo,
      salario: salario,
      fechaContratacion: fechaContratacion,
      activo: activo,
      createdAt: createdAt,
    );
  }

  /// Convierte desde SQLite local
  factory EmpleadoModel.fromLocalDb(Map<String, dynamic> map) {
    return EmpleadoModel(
      id: map['id'] as String,
      fincaId: map['finca_id'] as String,
      nombre: map['nombre'] as String,
      cedula: map['cedula'] as String,
      tipoEmpleado: _parseTipoEmpleado(map['tipo_empleado'] as String),
      cargo: map['cargo'] as String?,
      salario: map['salario'] != null ? (map['salario'] as num).toDouble() : null,
      fechaContratacion: DateTime.parse(map['fecha_contratacion'] as String),
      activo: (map['activo'] as int) == 1,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  /// Convierte a SQLite local
  Map<String, dynamic> toLocalDb() {
    return {
      'id': id,
      'finca_id': fincaId,
      'nombre': nombre,
      'cedula': cedula,
      'tipo_empleado': tipoEmpleado.name,
      'cargo': cargo,
      'salario': salario,
      'fecha_contratacion': fechaContratacion.toIso8601String().split('T')[0],
      'activo': activo ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
      'sync_status': 0, // Pendiente de sincronizar por defecto
      'last_sync': null,
    };
  }
}
