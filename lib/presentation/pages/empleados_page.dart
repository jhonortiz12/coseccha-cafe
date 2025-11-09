import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/empleado_controller.dart';
import '../../domain/entities/empleado_entity.dart';
import 'empleado_form_page.dart';

class EmpleadosPage extends StatelessWidget {
  final String fincaId;

  const EmpleadosPage({Key? key, required this.fincaId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EmpleadoController());
    controller.loadEmpleados(fincaId);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Gestión de Empleados',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF27AE60),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () => _showSearchDialog(context, controller),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (value) {
              if (value == 'activate_all') {
                _showActivateAllDialog(context, controller);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'activate_all',
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: Color(0xFF27AE60)),
                    SizedBox(width: 8),
                    Text('Activar todos'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.empleados.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.people_outline, size: 100, color: Colors.grey[400]),
                const SizedBox(height: 20),
                Text(
                  'No hay empleados registrados',
                  style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () => _navigateToForm(context, controller),
                  icon: const Icon(Icons.add),
                  label: const Text('Agregar Empleado'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF27AE60),
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => controller.loadEmpleados(fincaId),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.empleados.length,
            itemBuilder: (context, index) {
              final empleado = controller.empleados[index];
              return _buildEmpleadoCard(context, empleado, controller);
            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToForm(context, controller),
        backgroundColor: const Color(0xFF27AE60),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmpleadoCard(
    BuildContext context,
    EmpleadoEntity empleado,
    EmpleadoController controller,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: empleado.activo 
              ? const Color(0xFF27AE60) 
              : Colors.grey,
          child: Text(
            empleado.nombre[0].toUpperCase(),
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          empleado.nombre,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text('Cédula: ${empleado.cedula}'),
            Text('Tipo: ${empleado.tipoEmpleado.displayName}'),
            if (empleado.cargo != null) Text('Cargo: ${empleado.cargo}'),
            if (empleado.salario != null) 
              Text('Salario: \$${empleado.salario!.toStringAsFixed(2)}'),
            Text(
              empleado.activo ? 'Activo' : 'Inactivo',
              style: TextStyle(
                color: empleado.activo ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'edit') {
              _navigateToForm(context, controller, empleado: empleado);
            } else if (value == 'delete') {
              _showDeleteDialog(context, empleado, controller);
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit, color: Colors.blue),
                  SizedBox(width: 8),
                  Text('Editar'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Eliminar'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToForm(
    BuildContext context,
    EmpleadoController controller, {
    EmpleadoEntity? empleado,
  }) {
    Get.to(() => EmpleadoFormPage(
      fincaId: fincaId,
      empleado: empleado,
    ));
  }

  void _showDeleteDialog(
    BuildContext context,
    EmpleadoEntity empleado,
    EmpleadoController controller,
  ) {
    Get.dialog(
      AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: Text('¿Está seguro de eliminar a ${empleado.nombre}?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              controller.deleteEmpleado(empleado.id);
              Get.back();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  void _showSearchDialog(BuildContext context, EmpleadoController controller) {
    final searchController = TextEditingController();
    
    Get.dialog(
      AlertDialog(
        title: const Text('Buscar Empleado'),
        content: TextField(
          controller: searchController,
          decoration: const InputDecoration(
            hintText: 'Nombre o cédula',
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: (value) {
            controller.searchEmpleados(fincaId, value);
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              searchController.clear();
              controller.loadEmpleados(fincaId);
              Get.back();
            },
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  void _showActivateAllDialog(BuildContext context, EmpleadoController controller) {
    Get.dialog(
      AlertDialog(
        title: const Text('Activar todos los empleados'),
        content: const Text(
          '¿Deseas activar todos los empleados? Esto permitirá que aparezcan en el formulario de recolección.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              Get.back();
              await _activarTodosLosEmpleados(controller);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF27AE60),
            ),
            child: const Text('Activar todos'),
          ),
        ],
      ),
    );
  }

  Future<void> _activarTodosLosEmpleados(EmpleadoController controller) async {
    try {
      // Mostrar indicador de carga
      Get.dialog(
        const Center(
          child: CircularProgressIndicator(),
        ),
        barrierDismissible: false,
      );

      // Activar cada empleado
      for (var empleado in controller.empleados) {
        if (!empleado.activo) {
          final empleadoActualizado = EmpleadoEntity(
            id: empleado.id,
            fincaId: empleado.fincaId,
            nombre: empleado.nombre,
            cedula: empleado.cedula,
            tipoEmpleado: empleado.tipoEmpleado,
            cargo: empleado.cargo,
            salario: empleado.salario,
            fechaContratacion: empleado.fechaContratacion,
            activo: true, // Activar
            createdAt: empleado.createdAt,
          );
          await controller.updateEmpleado(empleadoActualizado);
        }
      }

      // Cerrar indicador de carga
      Get.back();

      // Recargar lista
      await controller.loadEmpleados(fincaId);

      // Mostrar mensaje de éxito
      Get.snackbar(
        'Éxito',
        'Todos los empleados han sido activados',
        backgroundColor: const Color(0xFF27AE60),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      // Cerrar indicador de carga si hay error
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
      
      Get.snackbar(
        'Error',
        'No se pudieron activar todos los empleados: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
