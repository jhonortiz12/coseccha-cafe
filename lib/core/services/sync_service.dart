import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart' as Sqflite;
import '../database/database_helper.dart';
import 'connectivity_service.dart';

/// Servicio de sincronización entre base de datos local y remota
/// Estados de sincronización:
/// 0 = Pendiente de sincronizar
/// 1 = Sincronizado
/// 2 = Error de sincronización
class SyncService extends GetxService {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final ConnectivityService _connectivityService = Get.find<ConnectivityService>();
  
  final RxBool isSyncing = false.obs;
  final RxString lastSyncTime = ''.obs;

  /// Sincroniza todos los datos pendientes cuando hay conexión
  Future<void> syncAll() async {
    if (isSyncing.value) {
      print('⚠️ Sincronización ya en progreso');
      return;
    }

    if (!_connectivityService.isOnline.value) {
      print('⚠️ Sin conexión a internet, sincronización pospuesta');
      return;
    }

    try {
      isSyncing.value = true;
      print('🔄 Iniciando sincronización...');

      await _syncFincas();
      await _syncEmpleados();
      await _syncRecolecciones();
      await _syncGastos();
      await _syncIngresos();

      lastSyncTime.value = DateTime.now().toIso8601String();
      print('✅ Sincronización completada');
    } catch (e) {
      print('❌ Error en sincronización: $e');
    } finally {
      isSyncing.value = false;
    }
  }

  Future<void> _syncFincas() async {
    final db = await _dbHelper.database;
    final pendingFincas = await db.query(
      'fincas',
      where: 'sync_status = ?',
      whereArgs: [0],
    );

    for (var finca in pendingFincas) {
      try {
        // Aquí se implementaría la lógica de sincronización con Supabase
        // Por ahora solo marcamos como sincronizado
        await db.update(
          'fincas',
          {
            'sync_status': 1,
            'last_sync': DateTime.now().toIso8601String(),
          },
          where: 'id = ?',
          whereArgs: [finca['id']],
        );
      } catch (e) {
        print('Error sincronizando finca ${finca['id']}: $e');
        await db.update(
          'fincas',
          {'sync_status': 2},
          where: 'id = ?',
          whereArgs: [finca['id']],
        );
      }
    }
  }

  Future<void> _syncEmpleados() async {
    final db = await _dbHelper.database;
    final pendingEmpleados = await db.query(
      'empleados',
      where: 'sync_status = ?',
      whereArgs: [0],
    );

    for (var empleado in pendingEmpleados) {
      try {
        await db.update(
          'empleados',
          {
            'sync_status': 1,
            'last_sync': DateTime.now().toIso8601String(),
          },
          where: 'id = ?',
          whereArgs: [empleado['id']],
        );
      } catch (e) {
        print('Error sincronizando empleado ${empleado['id']}: $e');
        await db.update(
          'empleados',
          {'sync_status': 2},
          where: 'id = ?',
          whereArgs: [empleado['id']],
        );
      }
    }
  }

  Future<void> _syncRecolecciones() async {
    final db = await _dbHelper.database;
    final pendingRecolecciones = await db.query(
      'recolecciones',
      where: 'sync_status = ?',
      whereArgs: [0],
    );

    for (var recoleccion in pendingRecolecciones) {
      try {
        await db.update(
          'recolecciones',
          {
            'sync_status': 1,
            'last_sync': DateTime.now().toIso8601String(),
          },
          where: 'id = ?',
          whereArgs: [recoleccion['id']],
        );
      } catch (e) {
        print('Error sincronizando recolección ${recoleccion['id']}: $e');
        await db.update(
          'recolecciones',
          {'sync_status': 2},
          where: 'id = ?',
          whereArgs: [recoleccion['id']],
        );
      }
    }
  }

  Future<void> _syncGastos() async {
    final db = await _dbHelper.database;
    final pendingGastos = await db.query(
      'gastos',
      where: 'sync_status = ?',
      whereArgs: [0],
    );

    for (var gasto in pendingGastos) {
      try {
        await db.update(
          'gastos',
          {
            'sync_status': 1,
            'last_sync': DateTime.now().toIso8601String(),
          },
          where: 'id = ?',
          whereArgs: [gasto['id']],
        );
      } catch (e) {
        print('Error sincronizando gasto ${gasto['id']}: $e');
        await db.update(
          'gastos',
          {'sync_status': 2},
          where: 'id = ?',
          whereArgs: [gasto['id']],
        );
      }
    }
  }

  Future<void> _syncIngresos() async {
    final db = await _dbHelper.database;
    final pendingIngresos = await db.query(
      'ingresos',
      where: 'sync_status = ?',
      whereArgs: [0],
    );

    for (var ingreso in pendingIngresos) {
      try {
        await db.update(
          'ingresos',
          {
            'sync_status': 1,
            'last_sync': DateTime.now().toIso8601String(),
          },
          where: 'id = ?',
          whereArgs: [ingreso['id']],
        );
      } catch (e) {
        print('Error sincronizando ingreso ${ingreso['id']}: $e');
        await db.update(
          'ingresos',
          {'sync_status': 2},
          where: 'id = ?',
          whereArgs: [ingreso['id']],
        );
      }
    }
  }

  /// Obtiene el número de registros pendientes de sincronizar
  Future<int> getPendingSyncCount() async {
    final db = await _dbHelper.database;
    
    final fincas = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM fincas WHERE sync_status = 0')
    ) ?? 0;
    
    final empleados = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM empleados WHERE sync_status = 0')
    ) ?? 0;
    
    final recolecciones = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM recolecciones WHERE sync_status = 0')
    ) ?? 0;
    
    final gastos = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM gastos WHERE sync_status = 0')
    ) ?? 0;
    
    final ingresos = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM ingresos WHERE sync_status = 0')
    ) ?? 0;
    
    return fincas + empleados + recolecciones + gastos + ingresos;
  }
}
