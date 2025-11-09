# Guía para Ejecutar en Android Studio

## ✅ Configuración Completada

Se ha creado toda la estructura necesaria para Android:
- ✅ Carpeta `android/` con configuración completa
- ✅ Archivos Gradle (build.gradle, settings.gradle)
- ✅ AndroidManifest.xml con permisos necesarios
- ✅ MainActivity en Kotlin
- ✅ Recursos y estilos

## 📋 Requisitos Previos

1. **Android Studio** instalado (versión Arctic Fox o superior)
2. **Flutter SDK** instalado y configurado
3. **Android SDK** (se instala con Android Studio)
4. **Java JDK** (versión 11 o superior)

## 🚀 Pasos para Ejecutar

### 1. Abrir el Proyecto en Android Studio

```bash
# Opción 1: Desde la terminal
cd c:\Users\User\Documents\trabajo_flutter\todo_flutter
flutter pub get
```

Luego abre Android Studio y selecciona "Open" → Navega a la carpeta `todo_flutter`

### 2. Configurar el Emulador o Dispositivo

**Opción A: Usar un Emulador**
1. En Android Studio: Tools → Device Manager
2. Clic en "Create Device"
3. Selecciona un dispositivo (ej: Pixel 5)
4. Descarga una imagen del sistema (ej: Android 13 - API 33)
5. Finaliza la creación y ejecuta el emulador

**Opción B: Usar un Dispositivo Físico**
1. Habilita "Opciones de Desarrollador" en tu dispositivo Android
2. Activa "Depuración USB"
3. Conecta el dispositivo por USB
4. Acepta la autorización en el dispositivo

### 3. Verificar Dependencias

En la terminal de Android Studio o PowerShell:

```bash
# Navega al directorio del proyecto
cd c:\Users\User\Documents\trabajo_flutter\todo_flutter

# Obtén las dependencias
flutter pub get

# Verifica que Flutter detecta dispositivos
flutter devices
```

### 4. Ejecutar la Aplicación

**Desde Android Studio:**
1. Selecciona el dispositivo/emulador en la barra superior
2. Presiona el botón ▶️ (Run) o presiona `Shift + F10`

**Desde la Terminal:**
```bash
# Ejecutar en modo debug
flutter run

# O especificar el dispositivo
flutter run -d <device-id>
```

## 🔧 Solución de Problemas Comunes

### Error: "Gradle sync failed"
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
```

### Error: "SDK location not found"
Crea el archivo `android/local.properties` con:
```properties
sdk.dir=C:\\Users\\User\\AppData\\Local\\Android\\sdk
flutter.sdk=C:\\src\\flutter
```
*(Ajusta las rutas según tu instalación)*

### Error de permisos de ubicación
Los permisos ya están configurados en `AndroidManifest.xml`. En tiempo de ejecución, la app solicitará permisos al usuario.

### Error: "Minimum supported Gradle version"
Ya está configurado Gradle 8.3 en `gradle-wrapper.properties`

## 📱 Permisos Configurados

La aplicación tiene los siguientes permisos:
- ✅ Internet y red
- ✅ Ubicación (fina y aproximada)
- ✅ Ubicación en segundo plano
- ✅ Almacenamiento (lectura/escritura)

## 🎯 Comandos Útiles

```bash
# Ver dispositivos conectados
flutter devices

# Ejecutar en modo release
flutter run --release

# Construir APK
flutter build apk

# Construir App Bundle (para Google Play)
flutter build appbundle

# Ver logs
flutter logs

# Hot reload (durante ejecución)
# Presiona 'r' en la terminal

# Hot restart
# Presiona 'R' en la terminal
```

## 📝 Notas Importantes

1. **Archivo .env**: Asegúrate de que el archivo `.env` existe con las credenciales de Supabase
2. **Versión mínima**: Android 5.0 (API 21) o superior
3. **Versión objetivo**: Android 14 (API 34)
4. **Iconos**: Los iconos de launcher están como placeholders, puedes reemplazarlos en `android/app/src/main/res/mipmap-*/`

## 🔄 Actualizar Configuración Android

Si necesitas regenerar la configuración de Android en el futuro:

```bash
flutter create --platforms=android .
```

Esto recreará la carpeta android manteniendo tu código actual.

## 📞 Soporte

Si encuentras problemas:
1. Verifica que Flutter esté actualizado: `flutter upgrade`
2. Ejecuta el doctor: `flutter doctor -v`
3. Limpia el proyecto: `flutter clean && flutter pub get`
