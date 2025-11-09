import 'package:sqflite/sqflite.dart';
import '../../core/database/database_helper.dart';
import '../models/empleado_model.dart';

/// Data source local para empleados usando SQLite
/// Capa de datos en arquitectura limpia
abstract class EmpleadoLocalDataSource {
  Future<List<EmpleadoModel>> getEmpleadosByFinca(String fincaId);
  Future<List<EmpleadoModel>> getEmpleadosActivos(String fincaId);
  Future<EmpleadoModel> getEmpleadoById(String id);
  Future<void> insertEmpleado(EmpleadoModel empleado);
  Future<void> updateEmpleado(EmpleadoModel empleado);
  Future<void> deleteEmpleado(String id);
  Future<void> syncEmpleadosFromRemote(List<EmpleadoModel> empleados);
}

class EmpleadoLocalDataSourceImpl implements EmpleadoLocalDataSource {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  Future<List<EmpleadoModel>> getEmpleadosByFinca(String fincaId) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'empleados',
      where: 'finca_id = ?',
      whereArgs: [fincaId],
      orderBy: 'nombre ASC',
    );

    return maps.map((map) => EmpleadoModel.fromLocalDb(map)).toList();
  }

  @override
  Future<List<EmpleadoModel>> getEmpleadosActivos(String fincaId) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'empleados',
      where: 'finca_id = ? AND activo = ?',
      whereArgs: [fincaId, 1],
      orderBy: 'nombre ASC',
    );

    return maps.map((map) => EmpleadoModel.fromLocalDb(map)).toList();
  }

  @override
  Future<EmpleadoModel> getEmpleadoById(String id) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'empleados',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (maps.isEmpty) {
      throw Exception('Empleado no encontrado');
    }

    return EmpleadoModel.fromLocalDb(maps.first);
  }

  @override
  Future<void> insertEmpleado(EmpleadoModel empleado) async {
    final db = await _dbHelper.database;
    await db.insert(
      'empleados',
      empleado.toLocalDb(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> updateEmpleado(EmpleadoModel empleado) async {
    final db = await _dbHelper.database;
    await db.update(
      'empleados',
      empleado.toLocalDb(),
      where: 'id = ?',
      whereArgs: [empleado.id],
    );
  }

  @override
  Future<void> deleteEmpleado(String id) async {
    final db = await _dbHelper.database;
    await db.delete(
      'empleados',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<void> syncEmpleadosFromRemote(List<EmpleadoModel> empleados) async {
    final db = await _dbHelper.database;
    final batch = db.batch();

    for (var empleado in empleados) {
      batch.insert(
        'empleados',
        empleado.toLocalDb()..['sync_status'] = 1,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
  }
}
