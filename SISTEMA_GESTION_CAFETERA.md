# Sistema de Gestión Cafetera - Documentación Completa

## 📋 Descripción General

Sistema completo de gestión para fincas cafeteras desarrollado en Flutter con Clean Architecture, que incluye:

- ✅ Gestión de Trabajadores
- ☕ Control de Cosecha y Recolección
- 💰 Inventario y Finanzas
- 📊 Estadísticas y Reportes

## 🏗️ Arquitectura del Proyecto

El proyecto sigue **Clean Architecture** con separación clara de responsabilidades:

```
lib/
├── domain/                    # Capa de Dominio (Lógica de Negocio)
│   ├── entities/             # Entidades del dominio
│   │   ├── empleado_entity.dart
│   │   ├── recoleccion_entity.dart
│   │   ├── gasto_entity.dart
│   │   ├── ingreso_entity.dart
│   │   └── categoria_financiera_entity.dart
│   ├── repositories/         # Interfaces de repositorios
│   │   ├── empleado_repository.dart
│   │   ├── recoleccion_repository.dart
│   │   └── finanzas_repository.dart
│   └── usecases/            # Casos de uso
│       ├── empleado_usecases.dart
│       ├── recoleccion_usecases.dart
│       └── finanzas_usecases.dart
│
├── data/                     # Capa de Datos
│   ├── models/              # Modelos con mappers JSON
│   │   ├── empleado_model.dart
│   │   ├── recoleccion_model.dart
│   │   ├── gasto_model.dart
│   │   ├── ingreso_model.dart
│   │   └── categoria_financiera_model.dart
│   └── repositories/        # Implementaciones de repositorios
│       ├── empleado_repository_impl.dart
│       ├── recoleccion_repository_impl.dart
│       └── finanzas_repository_impl.dart
│
└── presentation/            # Capa de Presentación
    ├── controllers/         # Controladores GetX
    │   ├── empleado_controller.dart
    │   ├── recoleccion_controller.dart
    │   └── finanzas_controller.dart
    └── pages/              # Páginas de la aplicación
        ├── empleados_page.dart
        ├── empleado_form_page.dart
        ├── recolecciones_page.dart
        ├── recoleccion_form_page.dart
        ├── estadisticas_recoleccion_page.dart
        ├── finanzas_page.dart
        ├── gastos_page.dart
        ├── gasto_form_page.dart
        ├── ingresos_page.dart
        ├── ingreso_form_page.dart
        └── dashboard_financiero_page.dart
```

## 📊 Base de Datos (Supabase)

### Tablas Creadas

#### 1. **empleados**
```sql
- id (uuid, PK)
- finca_id (uuid, FK → fincas)
- nombre (text)
- cedula (text, unique)
- tipo_empleado (text: 'temporal' | 'permanente')
- cargo (text, nullable)
- salario (numeric)
- fecha_contratacion (date)
- activo (boolean)
- created_at (timestamptz)
```

#### 2. **recolecciones**
```sql
- id (uuid, PK)
- empleado_id (uuid, FK → empleados)
- finca_id (uuid, FK → fincas)
- fecha (date)
- lote (text, nullable)
- kilos_recolectados (numeric)
- observaciones (text, nullable)
- created_at (timestamptz)
```

#### 3. **categorias_financieras**
```sql
- id (uuid, PK)
- nombre (text, unique)
- tipo (text: 'ingreso' | 'gasto')
- descripcion (text, nullable)
- created_at (timestamptz)
```

#### 4. **gastos**
```sql
- id (uuid, PK)
- finca_id (uuid, FK → fincas)
- categoria_id (uuid, FK → categorias_financieras)
- fecha (date)
- descripcion (text)
- monto (numeric)
- proveedor (text, nullable)
- comprobante_url (text, nullable)
- observaciones (text, nullable)
- created_at (timestamptz)
```

#### 5. **ingresos**
```sql
- id (uuid, PK)
- finca_id (uuid, FK → fincas)
- categoria_id (uuid, FK → categorias_financieras)
- fecha (date)
- descripcion (text)
- cantidad_kg (numeric, nullable)
- precio_kg (numeric, nullable)
- total (numeric, GENERATED)
- metodo_pago (text: 'efectivo' | 'transferencia' | 'cheque' | 'otro')
- observaciones (text, nullable)
- created_at (timestamptz)
```

## 🎯 Funcionalidades Implementadas

### 1. Gestión de Trabajadores

**Páginas:**
- `EmpleadosPage`: Lista de empleados con búsqueda
- `EmpleadoFormPage`: Formulario de creación/edición

**Características:**
- ✅ Registro de empleados temporales y permanentes
- ✅ Gestión de información: nombre, cédula, cargo, salario
- ✅ Estado activo/inactivo
- ✅ Búsqueda por nombre o cédula
- ✅ Edición y eliminación

### 2. Control de Cosecha

**Páginas:**
- `RecoleccionesPage`: Lista de recolecciones
- `RecoleccionFormPage`: Registro de recolección
- `EstadisticasRecoleccionPage`: Estadísticas y reportes

**Características:**
- ✅ Registro diario de kilos recolectados por trabajador
- ✅ Asignación por lote
- ✅ Estadísticas de rendimiento (total, promedio diario)
- ✅ Filtros por fecha y rango
- ✅ Visualización de recolecciones por empleado

### 3. Gestión Financiera

**Páginas:**
- `FinanzasPage`: Menú principal con resumen
- `GastosPage` / `GastoFormPage`: Gestión de gastos
- `IngresosPage` / `IngresoFormPage`: Gestión de ingresos
- `DashboardFinancieroPage`: Dashboard con gráficas

**Características:**
- ✅ Registro de gastos con categorías
- ✅ Registro de ingresos (ventas de café)
- ✅ Cálculo automático de totales
- ✅ Resumen financiero (ingresos vs gastos)
- ✅ Balance y estadísticas por período
- ✅ Filtros por rango de fechas

## 🚀 Cómo Usar el Sistema

### Navegación desde Dashboard

Actualiza tu `dashboard_page.dart` para incluir acceso a las nuevas funcionalidades:

```dart
// Ejemplo de botones en el dashboard
ListTile(
  leading: Icon(Icons.people),
  title: Text('Empleados'),
  onTap: () => Get.to(() => EmpleadosPage(fincaId: fincaId)),
),
ListTile(
  leading: Icon(Icons.agriculture),
  title: Text('Recolecciones'),
  onTap: () => Get.to(() => RecoleccionesPage(fincaId: fincaId)),
),
ListTile(
  leading: Icon(Icons.attach_money),
  title: Text('Finanzas'),
  onTap: () => Get.to(() => FinanzasPage(fincaId: fincaId)),
),
```

### Flujo de Trabajo Típico

1. **Registrar Empleados**
   - Ir a Empleados → Agregar nuevo
   - Completar formulario con datos del empleado
   - Guardar

2. **Registrar Recolecciones**
   - Ir a Recolecciones → Nueva recolección
   - Seleccionar empleado, fecha y kilos
   - Guardar

3. **Ver Estadísticas**
   - Desde Recolecciones → Icono de estadísticas
   - Seleccionar rango de fechas
   - Ver totales y promedios

4. **Gestionar Finanzas**
   - Ir a Finanzas
   - Registrar gastos (insumos, salarios, etc.)
   - Registrar ingresos (ventas)
   - Ver dashboard financiero

## 📦 Dependencias Requeridas

Asegúrate de tener en tu `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  get: ^4.6.5
  supabase_flutter: ^1.10.0
```

## 🔧 Configuración

1. **Ejecutar scripts SQL en Supabase**
   - Copia el script SQL proporcionado
   - Ejecútalo en el SQL Editor de Supabase
   - Verifica que las tablas se crearon correctamente

2. **Configurar categorías iniciales** (Opcional)
   ```sql
   INSERT INTO categorias_financieras (nombre, tipo, descripcion) VALUES
   ('Venta de Café', 'ingreso', 'Ingresos por venta de café'),
   ('Fertilizantes', 'gasto', 'Compra de fertilizantes'),
   ('Salarios', 'gasto', 'Pago de salarios'),
   ('Herramientas', 'gasto', 'Compra de herramientas');
   ```

## 🎨 Personalización

### Colores del Tema

El sistema usa el color verde característico del café:
- Primary: `Color(0xFF27AE60)`
- Gastos: `Colors.red[700]`
- Ingresos: `Colors.green[700]`

### Agregar Nuevas Funcionalidades

Para agregar nuevas características, sigue el patrón Clean Architecture:

1. Crear entidad en `domain/entities/`
2. Crear modelo en `data/models/`
3. Crear repositorio (interfaz e implementación)
4. Crear usecase en `domain/usecases/`
5. Crear controller en `presentation/controllers/`
6. Crear páginas en `presentation/pages/`

## 📈 Próximas Mejoras Sugeridas

- [ ] Gráficas con `fl_chart` o `syncfusion_flutter_charts`
- [ ] Exportación de reportes a PDF/Excel
- [ ] Notificaciones push
- [ ] Calendario agrícola
- [ ] Gestión de calidad del café
- [ ] Control de inventario de insumos
- [ ] Integración con Google Calendar

## 🐛 Troubleshooting

### Error: "No se pudieron cargar los datos"
- Verifica la conexión a Supabase
- Revisa que las tablas existan en la base de datos
- Confirma que el usuario tenga permisos (RLS policies)

### Error: "Empleado no encontrado"
- Asegúrate de haber registrado empleados antes de crear recolecciones
- Verifica que los empleados estén activos

## 📝 Licencia

Este proyecto está bajo la Licencia MIT.

---

**Desarrollado con ❤️ para caficultores**
