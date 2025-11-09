# 🚀 Guía de Inicio Rápido - Sistema de Gestión Cafetera

## ✅ Pasos para Poner en Marcha el Sistema

### 1. Configurar Base de Datos en Supabase

Ejecuta el siguiente script SQL en tu proyecto de Supabase:

```sql
-- ====================================
-- BORRAR TABLAS EXISTENTES (opcional)
-- ====================================
DROP TABLE IF EXISTS public.recolecciones CASCADE;
DROP TABLE IF EXISTS public.empleados CASCADE;
DROP TABLE IF EXISTS public.ingresos CASCADE;
DROP TABLE IF EXISTS public.gastos CASCADE;
DROP TABLE IF EXISTS public.categorias_financieras CASCADE;

-- ====================================
-- TABLA: categorias_financieras
-- ====================================
CREATE TABLE public.categorias_financieras (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    nombre TEXT NOT NULL UNIQUE,
    tipo TEXT CHECK (tipo IN ('ingreso', 'gasto')) NOT NULL,
    descripcion TEXT,
    created_at timestamptz DEFAULT now()
);

-- ====================================
-- TABLA: empleados
-- ====================================
CREATE TABLE public.empleados (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    finca_id uuid REFERENCES public.fincas (id) ON DELETE CASCADE,
    nombre TEXT NOT NULL,
    cedula TEXT UNIQUE NOT NULL,
    tipo_empleado TEXT CHECK (tipo_empleado IN ('temporal', 'permanente')) NOT NULL,
    cargo TEXT,
    salario NUMERIC(10,2),
    fecha_contratacion DATE DEFAULT current_date,
    activo BOOLEAN DEFAULT true,
    created_at timestamptz DEFAULT now()
);

-- ====================================
-- TABLA: recolecciones
-- ====================================
CREATE TABLE public.recolecciones (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    empleado_id uuid REFERENCES public.empleados (id) ON DELETE CASCADE,
    finca_id uuid REFERENCES public.fincas (id) ON DELETE CASCADE,
    fecha DATE NOT NULL,
    lote TEXT,
    kilos_recolectados NUMERIC(10,2) NOT NULL CHECK (kilos_recolectados >= 0),
    observaciones TEXT,
    created_at timestamptz DEFAULT now()
);

-- ====================================
-- TABLA: gastos
-- ====================================
CREATE TABLE public.gastos (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    finca_id uuid REFERENCES public.fincas (id) ON DELETE CASCADE,
    categoria_id uuid REFERENCES public.categorias_financieras (id) ON DELETE SET NULL,
    fecha DATE NOT NULL,
    descripcion TEXT NOT NULL,
    monto NUMERIC(12,2) NOT NULL CHECK (monto > 0),
    proveedor TEXT,
    comprobante_url TEXT,
    observaciones TEXT,
    created_at timestamptz DEFAULT now()
);

-- ====================================
-- TABLA: ingresos
-- ====================================
CREATE TABLE public.ingresos (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    finca_id uuid REFERENCES public.fincas (id) ON DELETE CASCADE,
    categoria_id uuid REFERENCES public.categorias_financieras (id) ON DELETE SET NULL,
    fecha DATE NOT NULL,
    descripcion TEXT NOT NULL,
    cantidad_kg NUMERIC(10,2),
    precio_kg NUMERIC(10,2),
    total NUMERIC(12,2) GENERATED ALWAYS AS (cantidad_kg * precio_kg) STORED,
    metodo_pago TEXT CHECK (metodo_pago IN ('efectivo', 'transferencia', 'cheque', 'otro')),
    observaciones TEXT,
    created_at timestamptz DEFAULT now()
);

-- ====================================
-- ÍNDICES PARA OPTIMIZAR CONSULTAS
-- ====================================
CREATE INDEX IF NOT EXISTS idx_empleados_finca_id ON public.empleados(finca_id);
CREATE INDEX IF NOT EXISTS idx_recolecciones_fecha ON public.recolecciones(fecha);
CREATE INDEX IF NOT EXISTS idx_recolecciones_empleado_id ON public.recolecciones(empleado_id);
CREATE INDEX IF NOT EXISTS idx_ingresos_fecha ON public.ingresos(fecha);
CREATE INDEX IF NOT EXISTS idx_gastos_fecha ON public.gastos(fecha);

-- ====================================
-- DATOS INICIALES: Categorías
-- ====================================
INSERT INTO categorias_financieras (nombre, tipo, descripcion) VALUES
('Venta de Café', 'ingreso', 'Ingresos por venta de café procesado'),
('Venta de Café Pergamino', 'ingreso', 'Venta de café en pergamino'),
('Otros Ingresos', 'ingreso', 'Otros ingresos varios'),
('Fertilizantes', 'gasto', 'Compra de fertilizantes y abonos'),
('Pesticidas', 'gasto', 'Compra de pesticidas y fungicidas'),
('Salarios', 'gasto', 'Pago de salarios a empleados'),
('Herramientas', 'gasto', 'Compra y mantenimiento de herramientas'),
('Transporte', 'gasto', 'Gastos de transporte'),
('Servicios', 'gasto', 'Servicios públicos y otros');
```

### 2. Verificar Políticas de Seguridad (RLS)

Asegúrate de que las políticas de Row Level Security permitan el acceso:

```sql
-- Habilitar RLS en todas las tablas
ALTER TABLE public.empleados ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.recolecciones ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.gastos ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.ingresos ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.categorias_financieras ENABLE ROW LEVEL SECURITY;

-- Políticas básicas (ajustar según necesidades)
CREATE POLICY "Allow all for authenticated users" ON public.empleados
  FOR ALL USING (auth.role() = 'authenticated');

CREATE POLICY "Allow all for authenticated users" ON public.recolecciones
  FOR ALL USING (auth.role() = 'authenticated');

CREATE POLICY "Allow all for authenticated users" ON public.gastos
  FOR ALL USING (auth.role() = 'authenticated');

CREATE POLICY "Allow all for authenticated users" ON public.ingresos
  FOR ALL USING (auth.role() = 'authenticated');

CREATE POLICY "Allow read for authenticated users" ON public.categorias_financieras
  FOR SELECT USING (auth.role() = 'authenticated');
```

### 3. Instalar Dependencias

Verifica que tu `pubspec.yaml` tenga las dependencias necesarias:

```yaml
dependencies:
  flutter:
    sdk: flutter
  get: ^4.6.5
  supabase_flutter: ^1.10.0
```

Ejecuta:
```bash
flutter pub get
```

### 4. Estructura de Archivos Creados

El sistema ha creado los siguientes archivos:

#### Domain Layer (Lógica de Negocio)
```
lib/domain/
├── entities/
│   ├── empleado_entity.dart
│   ├── recoleccion_entity.dart
│   ├── gasto_entity.dart
│   ├── ingreso_entity.dart
│   └── categoria_financiera_entity.dart
├── repositories/
│   ├── empleado_repository.dart
│   ├── recoleccion_repository.dart
│   └── finanzas_repository.dart
└── usecases/
    ├── empleado_usecases.dart
    ├── recoleccion_usecases.dart
    └── finanzas_usecases.dart
```

#### Data Layer (Acceso a Datos)
```
lib/data/
├── models/
│   ├── empleado_model.dart
│   ├── recoleccion_model.dart
│   ├── gasto_model.dart
│   ├── ingreso_model.dart
│   └── categoria_financiera_model.dart
└── repositories/
    ├── empleado_repository_impl.dart
    ├── recoleccion_repository_impl.dart
    └── finanzas_repository_impl.dart
```

#### Presentation Layer (UI)
```
lib/presentation/
├── controllers/
│   ├── empleado_controller.dart
│   ├── recoleccion_controller.dart
│   └── finanzas_controller.dart
└── pages/
    ├── menu_gestion_page.dart
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

### 5. Ejecutar la Aplicación

```bash
flutter run
```

## 📱 Flujo de Uso

### Primera Vez

1. **Iniciar sesión** en la aplicación
2. **Registrar una finca** (si no tienes ninguna)
3. **Hacer clic en la finca** para acceder al menú de gestión

### Menú de Gestión

Desde el menú principal de la finca podrás acceder a:

#### 🧑‍🌾 Empleados
- Registrar empleados temporales o permanentes
- Gestionar información: nombre, cédula, cargo, salario
- Activar/desactivar empleados
- Buscar empleados

#### ☕ Recolecciones
- Registrar recolecciones diarias
- Asignar kilos por empleado
- Especificar lote de recolección
- Ver estadísticas de rendimiento
- Filtrar por fechas

#### 💰 Finanzas
- **Gastos**: Registrar compras, salarios, insumos
- **Ingresos**: Registrar ventas de café
- **Dashboard**: Ver resumen financiero con balance
- Filtrar por períodos

## 🎯 Casos de Uso Comunes

### Registrar una Recolección Diaria

1. Ir a **Recolecciones** → Botón **+**
2. Seleccionar **empleado**
3. Seleccionar **fecha** (hoy por defecto)
4. Ingresar **kilos recolectados**
5. Opcional: agregar lote y observaciones
6. Guardar

### Ver Estadísticas de Recolección

1. Ir a **Recolecciones**
2. Clic en icono de **estadísticas** (gráfica)
3. Seleccionar rango de fechas
4. Ver totales y promedios

### Registrar un Gasto

1. Ir a **Finanzas** → **Gastos** → Botón **+**
2. Ingresar descripción y monto
3. Seleccionar categoría
4. Opcional: proveedor, fecha, observaciones
5. Guardar

### Ver Balance Financiero

1. Ir a **Finanzas** → **Dashboard Financiero**
2. Seleccionar período
3. Ver ingresos, gastos y balance

## ⚠️ Notas Importantes

- **Empleados Activos**: Solo los empleados activos aparecen al registrar recolecciones
- **Categorías**: Las categorías se crean automáticamente con el script SQL
- **Fechas**: Por defecto se usa la fecha actual, pero puedes cambiarla
- **Total de Ingresos**: Se calcula automáticamente como `cantidad_kg * precio_kg`

## 🐛 Solución de Problemas

### "No se pudieron cargar los datos"
- Verifica la conexión a internet
- Revisa que las tablas existan en Supabase
- Confirma que las políticas RLS estén configuradas

### "No hay empleados activos"
- Registra al menos un empleado antes de crear recolecciones
- Verifica que el empleado esté marcado como "activo"

### Error al guardar
- Verifica que todos los campos requeridos (*) estén completos
- Revisa que los valores numéricos sean válidos

## 📚 Documentación Adicional

- Ver `SISTEMA_GESTION_CAFETERA.md` para documentación completa
- Revisar código fuente para personalización

## 🎉 ¡Listo!

Tu sistema de gestión cafetera está configurado y listo para usar.

**¡Feliz gestión de tu finca! ☕🌱**
