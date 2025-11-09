# 🔧 Solución de Problemas del Chatbot

## Error: "No se pudo generar la respuesta. Verifica tu conexión y API key"

### Causas Comunes y Soluciones

#### 1. ✅ Archivo .env no cargado correctamente

**Problema**: El archivo `.env` no se está leyendo al iniciar la app.

**Solución**:
- Asegúrate de que el archivo `.env` está en la raíz del proyecto
- Verifica que `main.dart` tiene la línea: `await dotenv.load(fileName: ".env");`
- **IMPORTANTE**: Haz un **Hot Restart** (no Hot Reload)
  - En VS Code: Presiona `Ctrl+Shift+F5`
  - O detén la app y ejecuta `flutter run` nuevamente

#### 2. ✅ API Key incorrecta o inválida

**Problema**: La API key está mal escrita o ha sido revocada.

**Solución**:
1. Ve a https://platform.openai.com/api-keys
2. Verifica que tu API key está activa
3. Si la revocaste, crea una nueva
4. Actualiza el archivo `.env`:
   ```
   OPENAI_API_KEY=sk-tu-nueva-clave-aqui
   ```
5. Haz un Hot Restart de la app

#### 3. ✅ Sin créditos en OpenAI

**Problema**: Tu cuenta de OpenAI no tiene créditos disponibles.

**Solución**:
1. Ve a https://platform.openai.com/account/billing
2. Verifica tu saldo
3. Agrega créditos si es necesario (mínimo $5 USD)

#### 4. ✅ Problemas de conexión a Internet

**Problema**: El dispositivo no tiene conexión a Internet o está bloqueado.

**Solución**:
- Verifica que el dispositivo tiene conexión WiFi o datos móviles
- Prueba abrir un navegador web para confirmar la conexión
- Si estás en una red corporativa, puede estar bloqueando OpenAI

#### 5. ✅ Formato incorrecto del archivo .env

**Problema**: El archivo `.env` tiene errores de formato.

**Formato correcto**:
```env
SUPABASE_URL=https://tu-proyecto.supabase.co
SUPABASE_ANON_KEY=tu_clave_supabase
OPENAI_API_KEY=sk-tu-clave-openai
```

**Errores comunes**:
- ❌ Espacios antes o después del `=`
- ❌ Comillas alrededor de los valores
- ❌ Múltiples variables en la misma línea
- ❌ Líneas en blanco entre variables

## 🔍 Cómo Verificar los Logs

### En Android Studio / VS Code:

1. Abre la consola de Debug
2. Busca estos mensajes:

**✅ Inicialización correcta**:
```
🔑 Intentando inicializar OpenAI...
🔑 API Key encontrada: Sí (sk-proj-fi...)
✅ OpenAI inicializado correctamente
```

**❌ Error de API Key**:
```
🔑 Intentando inicializar OpenAI...
🔑 API Key encontrada: No
❌ OPENAI_API_KEY no encontrada en .env
```

**❌ Error al enviar mensaje**:
```
🤖 Enviando solicitud a OpenAI...
❌ Error en OpenAI: [detalles del error]
```

### Errores Específicos de OpenAI:

#### Error 401 - Unauthorized
```
❌ Error en OpenAI: 401 Unauthorized
```
**Causa**: API key inválida o revocada  
**Solución**: Verifica tu API key en OpenAI

#### Error 429 - Rate Limit
```
❌ Error en OpenAI: 429 Too Many Requests
```
**Causa**: Demasiadas solicitudes en poco tiempo  
**Solución**: Espera unos minutos antes de intentar de nuevo

#### Error 500 - Server Error
```
❌ Error en OpenAI: 500 Internal Server Error
```
**Causa**: Problema temporal en los servidores de OpenAI  
**Solución**: Espera unos minutos e intenta de nuevo

## 🛠️ Pasos de Diagnóstico

### Paso 1: Verificar el archivo .env

```bash
# En la terminal, desde la raíz del proyecto:
cat .env
```

Deberías ver:
```
SUPABASE_URL=...
SUPABASE_ANON_KEY=...
OPENAI_API_KEY=sk-...
```

### Paso 2: Verificar la API Key en OpenAI

1. Ve a https://platform.openai.com/api-keys
2. Verifica que tu clave existe y está activa
3. Verifica tu saldo en https://platform.openai.com/account/billing

### Paso 3: Hot Restart

**IMPORTANTE**: Hot Reload NO recarga el archivo `.env`

**Cómo hacer Hot Restart**:
- VS Code: `Ctrl+Shift+F5`
- Android Studio: Botón de "Hot Restart" (🔄)
- Terminal: Detén la app (`Ctrl+C`) y ejecuta `flutter run` de nuevo

### Paso 4: Limpiar y Reconstruir

Si nada funciona:

```bash
flutter clean
flutter pub get
flutter run
```

## 📱 Prueba Rápida

Para verificar que todo funciona:

1. Abre la app
2. Selecciona una finca
3. Ve a "Asistente IA"
4. Deberías ver el mensaje de bienvenida
5. Escribe: "Hola"
6. Deberías recibir una respuesta en 2-5 segundos

## 🆘 Si Nada Funciona

1. **Verifica los logs** en la consola de debug
2. **Copia el error exacto** que aparece
3. **Verifica**:
   - ✅ Archivo `.env` existe en la raíz
   - ✅ API key es válida en OpenAI
   - ✅ Tienes créditos en OpenAI
   - ✅ Hiciste Hot Restart (no Hot Reload)
   - ✅ Tienes conexión a Internet

## 💡 Consejos

- **Siempre** haz Hot Restart después de cambiar el `.env`
- Verifica tu saldo en OpenAI regularmente
- Configura límites de gasto en OpenAI para evitar sorpresas
- Los logs con 🔑, 🤖, ✅ y ❌ te ayudan a diagnosticar

## 🔐 Seguridad

- ⚠️ **NUNCA** compartas tu API key
- ⚠️ Si compartiste tu clave accidentalmente, **revócala inmediatamente**
- ✅ El archivo `.env` está en `.gitignore` (no se sube a Git)
