# 🌟 Configuración de Gemini (Google AI) - GRATIS

## 🎉 ¡Excelente Elección!

Gemini es la IA de Google, **completamente GRATIS** y de excelente calidad para análisis de fincas cafeteras.

## ✅ Ventajas de Gemini

| Característica | Valor |
|---------------|-------|
| **Costo** | 🎉 **100% GRATIS** |
| **Calidad** | ⭐⭐⭐⭐⭐ Excelente |
| **Límites** | 60 solicitudes/minuto |
| **Tarjeta** | ❌ No requerida |
| **Registro** | ✅ Solo cuenta Google |

## 🚀 Configuración (5 minutos)

### Paso 1: Obtener tu API Key GRATIS

1. **Ve a Google AI Studio**
   - Abre: https://makersuite.google.com/app/apikey
   - O busca "Google AI Studio API Key"

2. **Inicia sesión con tu cuenta Google**
   - Usa tu Gmail personal
   - No necesitas tarjeta de crédito

3. **Crea tu API Key**
   - Haz clic en "Create API Key"
   - Selecciona "Create API key in new project" (o usa un proyecto existente)
   - Copia la clave (empieza con `AIza...`)

4. **Guarda tu clave de forma segura**
   - La necesitarás en el siguiente paso

### Paso 2: Agregar la API Key al Proyecto

1. **Abre el archivo `.env`** en la raíz del proyecto

2. **Pega tu API key**:
   ```env
   SUPABASE_URL=https://dzlnvsdvohlcpwrcwryc.supabase.co
   SUPABASE_ANON_KEY=tu_clave_supabase
   GEMINI_API_KEY=AIza_tu_clave_aqui
   ```

3. **Guarda el archivo**

### Paso 3: Reiniciar la App

**IMPORTANTE**: Debes hacer **Hot Restart** (no Hot Reload)

- En VS Code: Presiona `Ctrl+Shift+F5`
- O detén la app y ejecuta `flutter run` de nuevo

## 🎯 Verificación

Cuando la app inicie, deberías ver en los logs:

```
🔑 Intentando inicializar Gemini...
🔑 API Key encontrada: Sí (AIza...)
✅ Gemini inicializado correctamente
```

## 💬 Prueba el Chatbot

1. Selecciona una finca
2. Ve a "Asistente IA"
3. Prueba estas preguntas:
   - "¿Cómo puedo mejorar la productividad de mi finca?"
   - "¿Qué precio debería cobrar por mi café?"
   - "Analiza mis costos y dame recomendaciones"

## 🌟 Características de Gemini

### ✅ Lo que Gemini puede hacer:

- **Análisis profundo** de datos de tu finca
- **Recomendaciones personalizadas** según tu contexto
- **Respuestas en español** natural y fluido
- **Seguimiento de conversación** (recuerda el contexto)
- **Análisis financiero** detallado
- **Estrategias de mejora** específicas

### 📊 Ejemplos de Análisis:

**Pregunta:** "¿Cómo puedo mejorar mi productividad?"

**Gemini responderá con:**
- Análisis de tu producción actual
- Comparación con estándares
- Recomendaciones específicas para TU finca
- Pasos concretos y medibles

## 🔒 Seguridad

- ✅ API key gratuita de Google
- ✅ No requiere tarjeta de crédito
- ✅ Puedes revocarla en cualquier momento
- ✅ El archivo `.env` está en `.gitignore`

## 📈 Límites Gratuitos

**Límites Generosos:**
- 60 solicitudes por minuto
- 1,500 solicitudes por día
- Suficiente para uso normal

**Si necesitas más:**
- Puedes crear múltiples API keys
- O esperar a que se renueven los límites

## 🆘 Solución de Problemas

### Error: "GEMINI_API_KEY no encontrada"

**Solución:**
1. Verifica que el archivo `.env` existe
2. Verifica que la línea `GEMINI_API_KEY=` tiene tu clave
3. Haz Hot Restart (no Hot Reload)

### Error: "Invalid API Key"

**Solución:**
1. Verifica que copiaste la clave completa
2. Asegúrate de que no tiene espacios
3. Verifica en https://makersuite.google.com/app/apikey que la clave está activa

### Respuestas lentas

**Causa:** Primera solicitud puede tardar 2-3 segundos  
**Solución:** Normal, las siguientes serán más rápidas

## 📚 Recursos

- [Google AI Studio](https://makersuite.google.com/)
- [Documentación de Gemini](https://ai.google.dev/docs)
- [Límites y Cuotas](https://ai.google.dev/pricing)

## 🎓 Tips de Uso

### Mejores Prácticas:

1. **Sé específico en tus preguntas**
   - ❌ "Ayúdame"
   - ✅ "¿Cómo puedo reducir mis costos de fertilización?"

2. **Proporciona contexto**
   - Gemini usa los datos de tu finca automáticamente
   - Puedes agregar detalles adicionales en tus preguntas

3. **Haz seguimiento**
   - Gemini recuerda la conversación
   - Puedes hacer preguntas de seguimiento

### Ejemplos de Buenas Preguntas:

```
"Analiza mi rentabilidad y dame 3 recomendaciones concretas"

"¿Qué estrategias puedo usar para vender mi café a mejor precio?"

"Compara mis gastos actuales con los estándares de la industria"

"Dame un plan de acción para los próximos 3 meses"
```

## 🎉 ¡Listo!

Una vez que agregues tu API key y reinicies la app, tendrás un asistente de IA de clase mundial, **completamente GRATIS**, para ayudarte con tu finca cafetera.

---

**¿Necesitas ayuda?** Revisa los logs de la app para ver mensajes de error específicos.
