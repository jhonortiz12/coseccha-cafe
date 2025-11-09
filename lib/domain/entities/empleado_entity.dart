class EmpleadoEntity {
  final String id;
  final String fincaId;
  final String nombre;
  final String cedula;
  final TipoEmpleado tipoEmpleado;
  final String? cargo;
  final double? salario;
  final DateTime fechaContratacion;
  final bool activo;
  final DateTime createdAt;

  EmpleadoEntity({
    required this.id,
    required this.fincaId,
    required this.nombre,
    required this.cedula,
    required this.tipoEmpleado,
    this.cargo,
    this.salario,
    required this.fechaContratacion,
    required this.activo,
    required this.createdAt,
  });

  EmpleadoEntity copyWith({
    String? id,
    String? fincaId,
    String? nombre,
    String? cedula,
    TipoEmpleado? tipoEmpleado,
    String? cargo,
    double? salario,
    DateTime? fechaContratacion,
    bool? activo,
    DateTime? createdAt,
  }) {
    return EmpleadoEntity(
      id: id ?? this.id,
      fincaId: fincaId ?? this.fincaId,
      nombre: nombre ?? this.nombre,
      cedula: cedula ?? this.cedula,
      tipoEmpleado: tipoEmpleado ?? this.tipoEmpleado,
      cargo: cargo ?? this.cargo,
      salario: salario ?? this.salario,
      fechaContratacion: fechaContratacion ?? this.fechaContratacion,
      activo: activo ?? this.activo,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

enum TipoEmpleado {
  temporal,
  permanente;

  String get displayName {
    switch (this) {
      case TipoEmpleado.temporal:
        return 'Temporal';
      case TipoEmpleado.permanente:
        return 'Permanente';
    }
  }
}
