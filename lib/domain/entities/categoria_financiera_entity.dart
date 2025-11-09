class CategoriaFinancieraEntity {
  final String id;
  final String nombre;
  final TipoCategoria tipo;
  final String? descripcion;
  final DateTime createdAt;

  CategoriaFinancieraEntity({
    required this.id,
    required this.nombre,
    required this.tipo,
    this.descripcion,
    required this.createdAt,
  });

  CategoriaFinancieraEntity copyWith({
    String? id,
    String? nombre,
    TipoCategoria? tipo,
    String? descripcion,
    DateTime? createdAt,
  }) {
    return CategoriaFinancieraEntity(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      tipo: tipo ?? this.tipo,
      descripcion: descripcion ?? this.descripcion,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

enum TipoCategoria {
  ingreso,
  gasto;

  String get displayName {
    switch (this) {
      case TipoCategoria.ingreso:
        return 'Ingreso';
      case TipoCategoria.gasto:
        return 'Gasto';
    }
  }
}
