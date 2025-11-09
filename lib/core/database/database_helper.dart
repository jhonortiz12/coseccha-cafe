import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

/// Helper para gestionar la base de datos local SQLite
/// Sigue el patrón Singleton para garantizar una única instancia
class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'cosecha_cafetera.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Tabla de fincas
    await db.execute('''
      CREATE TABLE fincas (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        nombre TEXT NOT NULL,
        hectareas REAL NOT NULL,
        numero_matas INTEGER NOT NULL,
        variedad TEXT NOT NULL,
        fecha_sembrado TEXT NOT NULL,
        altitud_gps REAL,
        ph REAL,
        textura TEXT,
        created_at TEXT NOT NULL,
        sync_status INTEGER DEFAULT 0,
        last_sync TEXT
      )
    ''');

    // Tabla de empleados
    await db.execute('''
      CREATE TABLE empleados (
        id TEXT PRIMARY KEY,
        finca_id TEXT NOT NULL,
        nombre TEXT NOT NULL,
        cedula TEXT NOT NULL,
        tipo_empleado TEXT NOT NULL,
        cargo TEXT,
        salario REAL,
        fecha_contratacion TEXT NOT NULL,
        activo INTEGER DEFAULT 1,
        created_at TEXT NOT NULL,
        sync_status INTEGER DEFAULT 0,
        last_sync TEXT,
        FOREIGN KEY (finca_id) REFERENCES fincas (id) ON DELETE CASCADE
      )
    ''');

    // Tabla de recolecciones
    await db.execute('''
      CREATE TABLE recolecciones (
        id TEXT PRIMARY KEY,
        empleado_id TEXT NOT NULL,
        finca_id TEXT NOT NULL,
        fecha TEXT NOT NULL,
        lote TEXT,
        kilos_recolectados REAL NOT NULL,
        pago_dia REAL,
        observaciones TEXT,
        created_at TEXT NOT NULL,
        sync_status INTEGER DEFAULT 0,
        last_sync TEXT,
        FOREIGN KEY (empleado_id) REFERENCES empleados (id) ON DELETE CASCADE,
        FOREIGN KEY (finca_id) REFERENCES fincas (id) ON DELETE CASCADE
      )
    ''');

    // Tabla de gastos
    await db.execute('''
      CREATE TABLE gastos (
        id TEXT PRIMARY KEY,
        finca_id TEXT NOT NULL,
        fecha TEXT NOT NULL,
        descripcion TEXT NOT NULL,
        monto REAL NOT NULL,
        categoria TEXT,
        proveedor TEXT,
        created_at TEXT NOT NULL,
        sync_status INTEGER DEFAULT 0,
        last_sync TEXT,
        FOREIGN KEY (finca_id) REFERENCES fincas (id) ON DELETE CASCADE
      )
    ''');

    // Tabla de ingresos
    await db.execute('''
      CREATE TABLE ingresos (
        id TEXT PRIMARY KEY,
        finca_id TEXT NOT NULL,
        fecha TEXT NOT NULL,
        descripcion TEXT NOT NULL,
        monto REAL NOT NULL,
        categoria TEXT,
        cliente TEXT,
        created_at TEXT NOT NULL,
        sync_status INTEGER DEFAULT 0,
        last_sync TEXT,
        FOREIGN KEY (finca_id) REFERENCES fincas (id) ON DELETE CASCADE
      )
    ''');

    // Índices para mejorar el rendimiento
    await db.execute('CREATE INDEX idx_empleados_finca ON empleados(finca_id)');
    await db.execute('CREATE INDEX idx_empleados_activo ON empleados(activo)');
    await db.execute('CREATE INDEX idx_recolecciones_finca ON recolecciones(finca_id)');
    await db.execute('CREATE INDEX idx_recolecciones_fecha ON recolecciones(fecha)');
    await db.execute('CREATE INDEX idx_gastos_finca ON gastos(finca_id)');
    await db.execute('CREATE INDEX idx_gastos_fecha ON gastos(fecha)');
    await db.execute('CREATE INDEX idx_ingresos_finca ON ingresos(finca_id)');
    await db.execute('CREATE INDEX idx_ingresos_fecha ON ingresos(fecha)');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Aquí se manejarán las migraciones futuras
  }

  /// Cierra la base de datos
  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }

  /// Limpia toda la base de datos (útil para testing o logout)
  Future<void> clearDatabase() async {
    final db = await database;
    await db.delete('fincas');
    await db.delete('empleados');
    await db.delete('recolecciones');
    await db.delete('gastos');
    await db.delete('ingresos');
  }
}
