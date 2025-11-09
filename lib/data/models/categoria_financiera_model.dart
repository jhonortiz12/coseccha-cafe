import '../../domain/entities/categoria_financiera_entity.dart';

class CategoriaFinancieraModel extends CategoriaFinancieraEntity {
  CategoriaFinancieraModel({
    required super.id,
    required super.nombre,
    required super.tipo,
    super.descripcion,
    required super.createdAt,
  });

  factory CategoriaFinancieraModel.fromJson(Map<String, dynamic> json) {
    return CategoriaFinancieraModel(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      tipo: _parseTipoCategoria(json['tipo'] as String),
      descripcion: json['descripcion'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'tipo': tipo.name,
      'descripcion': descripcion,
      'created_at': createdAt.toIso8601String(),
    };
  }

  Map<String, dynamic> toJsonForInsert() {
    return {
      'nombre': nombre,
      'tipo': tipo.name,
      'descripcion': descripcion,
    };
  }

  static TipoCategoria _parseTipoCategoria(String tipo) {
    switch (tipo.toLowerCase()) {
      case 'ingreso':
        return TipoCategoria.ingreso;
      case 'gasto':
        return TipoCategoria.gasto;
      default:
        return TipoCategoria.gasto;
    }
  }

  CategoriaFinancieraEntity toEntity() {
    return CategoriaFinancieraEntity(
      id: id,
      nombre: nombre,
      tipo: tipo,
      descripcion: descripcion,
      createdAt: createdAt,
    );
  }
}
