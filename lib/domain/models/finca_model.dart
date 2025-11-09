class FincaModel {
  final String? id;
  final String userId;
  final String nombre;
  final double hectareas;
  final String tipoCafe;
  final int alturaMetros;
  final int numeroMatas;
  final DateTime? createdAt;

  FincaModel({
    this.id,
    required this.userId,
    required this.nombre,
    required this.hectareas,
    required this.tipoCafe,
    required this.alturaMetros,
    required this.numeroMatas,
    this.createdAt,
  });

  factory FincaModel.fromJson(Map<String, dynamic> json) {
    return FincaModel(
      id: json['id'],
      userId: json['user_id'],
      nombre: json['nombre'],
      hectareas: json['hectareas']?.toDouble() ?? 0.0,
      tipoCafe: json['tipo_cafe'] ?? '',
      alturaMetros: json['altura_metros'] ?? 0,
      numeroMatas: json['numero_matas'] ?? 0,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'user_id': userId,
      'nombre': nombre,
      'hectareas': hectareas,
      'tipo_cafe': tipoCafe,
      'altura_metros': alturaMetros,
      'numero_matas': numeroMatas,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
    };
  }
}
