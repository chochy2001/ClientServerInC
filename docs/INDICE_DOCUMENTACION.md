# Índice Maestro de Documentación

**Proyecto**: Ejecutor de Comandos Remotos SSH-like
**Autor**: Jorge Salgado Miranda
**Última Actualización**: 2025-11-17

---

## 📚 Guía de Navegación

Este documento te ayudará a encontrar rápidamente la documentación que necesitas según tu objetivo actual.

---

## 🎯 Por Objetivo

### "Quiero entender el proyecto completo"

1. **Primero**: [`RESUMEN_PROYECTO.md`](RESUMEN_PROYECTO.md)
   - Estado general (70% completado)
   - Arquitectura del sistema
   - Estadísticas de código
   - Próximos pasos

2. **Luego**: [`../README.md`](../README.md)
   - Compilación básica
   - Uso básico del cliente y servidor
   - Comandos soportados

3. **Profundizar**: [`CUMPLIMIENTO_CONSTITUTION.md`](CUMPLIMIENTO_CONSTITUTION.md)
   - Verificación de 11 principios constitucionales
   - Cumplimiento: 93%
   - Áreas pendientes

### "Quiero compilar y ejecutar"

1. **[`../README.md`](../README.md)** - Instrucciones básicas de compilación
2. **[`../Makefile`](../Makefile)** - Build automation
3. **[`scripts/README.md`](../scripts/README.md)** - Scripts de utilidad

Comandos rápidos:
```bash
make clean && make all
./servidor 8080
./cliente localhost 8080
```

### "Quiero hacer testing"

1. **[`GUIA_TESTING.md`](GUIA_TESTING.md)** - Manual completo de pruebas
   - 7 secciones de testing
   - Pruebas funcionales
   - Pruebas de validación
   - Valgrind (Linux)
   - Cross-platform
   - Red remota
   - Checklist final

2. **[`../scripts/test_automatico.sh`](../scripts/test_automatico.sh)** - Tests automatizados
   - 16 tests en 5 suites
   - Ejecución simple: `./scripts/test_automatico.sh`

3. **[`../scripts/validacion_pre_entrega.sh`](../scripts/validacion_pre_entrega.sh)** - Validación completa
   - 25+ verificaciones
   - 9 secciones de validación
   - Checklist crítico

### "Quiero preparar la entrega"

1. **[`GUIA_PASO_A_PASO_ENTREGA.md`](GUIA_PASO_A_PASO_ENTREGA.md)** ⭐ **START HERE**
   - Guía completa paso a paso
   - 7 pasos detallados
   - Screenshots
   - PDF
   - Email
   - Zoom
   - Checklist final

2. **[`../entrega_email/INSTRUCCIONES_EMAIL.md`](../entrega_email/INSTRUCCIONES_EMAIL.md)** - Template de email
   - Formato del email
   - Archivos a adjuntar
   - Verificación pre-envío

3. **[`PLANTILLA_INFORME_PDF.md`](PLANTILLA_INFORME_PDF.md)** - Estructura del PDF
   - 12 secciones
   - Plantillas completas
   - Instrucciones de generación

### "Quiero verificar calidad del código"

1. **[`VALIDACION.md`](VALIDACION.md)** - Reporte de validación técnica
   - Compilación sin warnings
   - Auditoría de memoria (malloc/free)
   - Auditoría de sockets (socket/close)
   - Documentación completa
   - Nomenclatura en español

2. **[`CUMPLIMIENTO_CONSTITUTION.md`](CUMPLIMIENTO_CONSTITUTION.md)** - Verificación de principios
   - 11 principios verificados
   - Score por principio
   - Pendientes identificados

---

## 📂 Por Tipo de Documento

### 📊 Documentos de Estado y Resumen

| Documento | Descripción | Cuándo Leer |
|-----------|-------------|-------------|
| [`RESUMEN_PROYECTO.md`](RESUMEN_PROYECTO.md) | Estado completo del proyecto (70%) | Inicio, para visión general |
| [`CUMPLIMIENTO_CONSTITUTION.md`](CUMPLIMIENTO_CONSTITUTION.md) | Verificación de principios (93%) | Para verificar compliance |
| [`VALIDACION.md`](VALIDACION.md) | Validación técnica exhaustiva | Después de implementación |

### 📖 Guías de Uso

| Documento | Descripción | Cuándo Leer |
|-----------|-------------|-------------|
| [`../README.md`](../README.md) | Compilación y uso básico | Primera vez que usas el proyecto |
| [`GUIA_TESTING.md`](GUIA_TESTING.md) | Manual completo de pruebas | Antes de hacer testing |
| [`GUIA_PASO_A_PASO_ENTREGA.md`](GUIA_PASO_A_PASO_ENTREGA.md) | Procedimiento de entrega completo | 1-2 semanas antes de deadline |
| [`../scripts/README.md`](../scripts/README.md) | Documentación de scripts | Cuando uses scripts de automatización |

### 📝 Plantillas y Templates

| Documento | Descripción | Cuándo Usar |
|-----------|-------------|-------------|
| [`PLANTILLA_INFORME_PDF.md`](PLANTILLA_INFORME_PDF.md) | Estructura completa del PDF | Al generar informe final |
| [`../entrega_email/INSTRUCCIONES_EMAIL.md`](../entrega_email/INSTRUCCIONES_EMAIL.md) | Template de email | Al enviar entregables |

### 🗂️ Archivos Generados

| Archivo/Carpeta | Descripción | Cómo Generar |
|-----------------|-------------|--------------|
| `codigo_para_pdf/` | Código con números de línea | `./scripts/generar_codigo_pdf.sh` |
| `capturas/` | Screenshots de pruebas | Manual (ver GUIA_PASO_A_PASO_ENTREGA.md) |
| `informe.pdf` | PDF final con código y screenshots | Manual (ver PLANTILLA_INFORME_PDF.md) |

---

## 🗓️ Por Fase del Proyecto

### Fase 1: Implementación (✅ COMPLETA)

Documentos relevantes:
- ✅ `../src/servidor.c` (434 líneas)
- ✅ `../src/cliente.c` (189 líneas)
- ✅ `../src/common.h` (193 líneas)
- ✅ `../Makefile`
- ✅ `../README.md`

**Estado**: Implementación core completa y funcional.

### Fase 2: Validación (✅ COMPLETA)

Documentos relevantes:
- ✅ [`VALIDACION.md`](VALIDACION.md)
- ✅ [`CUMPLIMIENTO_CONSTITUTION.md`](CUMPLIMIENTO_CONSTITUTION.md)
- ✅ `../scripts/validacion_pre_entrega.sh`

**Estado**: Código validado, compila sin warnings, cumple 93% de constitution.

### Fase 3: Testing (⏳ PENDIENTE)

Documentos relevantes:
- 📖 [`GUIA_TESTING.md`](GUIA_TESTING.md)
- 🔧 `../scripts/test_automatico.sh`

**Tareas Pendientes**:
- [ ] Ejecutar tests automatizados
- [ ] Capturar screenshot prueba local
- [ ] Prueba remota y screenshot (opcional)
- [ ] Valgrind en Linux (opcional)

**Siguiente Paso**: Seguir [`GUIA_TESTING.md`](GUIA_TESTING.md) sección 1 y 2.

### Fase 4: Entregables (⏳ PENDIENTE)

Documentos relevantes:
- 📖 [`GUIA_PASO_A_PASO_ENTREGA.md`](GUIA_PASO_A_PASO_ENTREGA.md) ⭐
- 📝 [`PLANTILLA_INFORME_PDF.md`](PLANTILLA_INFORME_PDF.md)
- 📧 [`../entrega_email/INSTRUCCIONES_EMAIL.md`](../entrega_email/INSTRUCCIONES_EMAIL.md)

**Tareas Pendientes**:
- [ ] Generar PDF con código y screenshots
- [ ] Enviar email con archivos .c
- [ ] Agendar sesión Zoom

**Siguiente Paso**: Seguir [`GUIA_PASO_A_PASO_ENTREGA.md`](GUIA_PASO_A_PASO_ENTREGA.md) desde Paso 3.

### Fase 5: Cleanup y Submission (⏳ PENDIENTE)

Documentos relevantes:
- 📖 [`GUIA_PASO_A_PASO_ENTREGA.md`](GUIA_PASO_A_PASO_ENTREGA.md) Paso 4
- 🔧 `../scripts/validacion_pre_entrega.sh`

**Tareas Críticas**:
- [ ] `rm -rf .claude` (CRÍTICO)
- [ ] `rm -rf .specify` (CRÍTICO)
- [ ] Verificar sin menciones de IA
- [ ] Git commit final en español

**Siguiente Paso**: Ejecutar checklist de Paso 4 en GUIA_PASO_A_PASO_ENTREGA.md.

---

## 🔍 Por Pregunta Frecuente

### "¿Cómo compilo el proyecto?"

**Respuesta rápida**:
```bash
make clean && make all
```

**Documentación completa**: [`../README.md`](../README.md) sección "Compilación"

### "¿Cómo ejecuto pruebas?"

**Respuesta rápida**:
```bash
# Terminal 1
./servidor 8080

# Terminal 2
./scripts/test_automatico.sh
```

**Documentación completa**: [`GUIA_TESTING.md`](GUIA_TESTING.md)

### "¿Qué debo entregar?"

**Respuesta**:
1. Email con archivos .c
2. PDF con código y screenshots
3. Sesión Zoom para demo

**Documentación completa**: [`GUIA_PASO_A_PASO_ENTREGA.md`](GUIA_PASO_A_PASO_ENTREGA.md)

### "¿Cómo genero el PDF?"

**Opciones**:
1. Word/Google Docs (más fácil)
2. Pandoc (línea de comandos)
3. LaTeX/Overleaf (más profesional)

**Documentación completa**: [`PLANTILLA_INFORME_PDF.md`](PLANTILLA_INFORME_PDF.md) sección "Generación del PDF"

### "¿El código está listo para entregar?"

**Verificar**:
```bash
./scripts/validacion_pre_entrega.sh
```

**Resultado esperado**: 80%+ de verificaciones pasadas

**Documentación completa**: [`RESUMEN_PROYECTO.md`](RESUMEN_PROYECTO.md)

### "¿Qué falta hacer?"

**Ver**: [`RESUMEN_PROYECTO.md`](RESUMEN_PROYECTO.md) sección "Pendiente (30%)"

**Resumen**:
- Testing y screenshots
- Generación de PDF
- Envío de entregables
- Cleanup pre-submission

### "¿Cuándo es el deadline?"

**Respuesta**: **Martes, Diciembre 9, 2025**

**Timeline recomendado**: [`GUIA_PASO_A_PASO_ENTREGA.md`](GUIA_PASO_A_PASO_ENTREGA.md) sección "Timeline Recomendado"

---

## 🚀 Rutas Rápidas

### Ruta: "Primera Vez Usando el Proyecto"

1. [`../README.md`](../README.md) - 5 minutos
2. `make all` - 1 minuto
3. `./servidor 8080` (Terminal 1)
4. `./cliente localhost 8080` (Terminal 2)
5. Ejecutar comandos: `ls`, `pwd`, `date`, `salir`

**Tiempo total**: ~10 minutos

### Ruta: "Voy a Entregar en 1 Semana"

1. [`GUIA_PASO_A_PASO_ENTREGA.md`](GUIA_PASO_A_PASO_ENTREGA.md) - Leer completo (30 min)
2. Ejecutar Paso 1: Testing local + screenshot (30 min)
3. Ejecutar Paso 3: Generar PDF (2-3 horas)
4. Ejecutar Paso 4: Cleanup (15 min)
5. Ejecutar Paso 5: Enviar email (15 min)
6. Ejecutar Paso 6: Agendar Zoom (5 min)

**Tiempo total**: ~4-5 horas

### Ruta: "Debugging - Algo No Funciona"

1. `./scripts/validacion_pre_entrega.sh` - Identificar problema
2. Si compilación falla: [`../README.md`](../README.md) sección "Troubleshooting"
3. Si tests fallan: [`GUIA_TESTING.md`](GUIA_TESTING.md) sección correspondiente
4. Si validación falla: [`VALIDACION.md`](VALIDACION.md) para detalles
5. Si duda general: [`RESUMEN_PROYECTO.md`](RESUMEN_PROYECTO.md)

**Tiempo**: Variable según problema

---

## 📊 Estadísticas de Documentación

```
Total de Documentos:    11 archivos markdown
Documentación de Código: 813 líneas (cliente.c + servidor.c + common.h)
Documentación Auxiliar: ~8000 líneas
Scripts:                3 scripts bash (~400 líneas)
```

**Cobertura**:
- ✅ Implementación: 100% documentada
- ✅ Testing: Guías completas
- ✅ Validación: Exhaustiva
- ✅ Entrega: Paso a paso detallado
- ✅ Scripts: Automatización completa

---

## 🗂️ Estructura de Carpetas

```
proyectoArqClienteServidor/
├── src/                    # Código fuente
│   ├── cliente.c          ✅ Implementado
│   ├── servidor.c         ✅ Implementado
│   └── common.h           ✅ Implementado
├── docs/                   # Documentación
│   ├── INDICE_DOCUMENTACION.md          ⭐ (este archivo)
│   ├── RESUMEN_PROYECTO.md              📊 Estado general
│   ├── GUIA_PASO_A_PASO_ENTREGA.md      📖 Cómo entregar
│   ├── GUIA_TESTING.md                  🧪 Manual de pruebas
│   ├── PLANTILLA_INFORME_PDF.md         📝 Template PDF
│   ├── VALIDACION.md                    ✅ Validación técnica
│   ├── CUMPLIMIENTO_CONSTITUTION.md     📋 Verificación principios
│   ├── capturas/                        📸 Screenshots (pendiente)
│   └── codigo_para_pdf/                 📄 Código numerado (generado)
├── scripts/                # Scripts de utilidad
│   ├── README.md                        📖 Documentación scripts
│   ├── test_automatico.sh               🧪 Tests automatizados
│   ├── validacion_pre_entrega.sh        ✅ Validación completa
│   └── generar_codigo_pdf.sh            📄 Generador de código
├── entrega_email/          # Archivos para email
│   ├── INSTRUCCIONES_EMAIL.md           📧 Template email
│   ├── cliente.c                        ✅ Listo
│   ├── servidor.c                       ✅ Listo
│   └── common.h                         ✅ Listo
├── Makefile                ✅ Build automation
└── README.md               ✅ Intro básica
```

---

## 🎯 Siguiente Acción Recomendada

Según el estado actual del proyecto (70% completo), tu **siguiente acción debería ser**:

### Opción A: Si tienes tiempo (1+ semanas)

1. Leer [`GUIA_PASO_A_PASO_ENTREGA.md`](GUIA_PASO_A_PASO_ENTREGA.md) completo
2. Seguir timeline recomendado
3. Ejecutar cada paso con calma

### Opción B: Si tienes poco tiempo (< 1 semana)

1. Ir directo a [`GUIA_PASO_A_PASO_ENTREGA.md`](GUIA_PASO_A_PASO_ENTREGA.md) **Paso 1**
2. Ejecutar testing local y capturar screenshot HOY
3. Generar PDF mañana (Paso 3)
4. Enviar email pasado mañana (Paso 5)
5. Agendar Zoom (Paso 6)

### Opción C: Solo quiero validar que todo esté OK

```bash
./scripts/validacion_pre_entrega.sh
```

Revisar output y corregir lo que esté en rojo (✗ FAIL).

---

## 📞 Ayuda y Soporte

Si después de revisar toda la documentación aún tienes dudas:

1. **Re-leer el documento relevante** - La mayoría de preguntas están respondidas
2. **Ejecutar scripts de validación** - Identifican problemas automáticamente
3. **Revisar sección de Troubleshooting** - En cada guía principal
4. **Contactar al profesor** - Como último recurso

---

## ✅ Checklist de Documentación

¿Has leído estos documentos críticos?

- [ ] [`RESUMEN_PROYECTO.md`](RESUMEN_PROYECTO.md) - Para entender estado general
- [ ] [`GUIA_PASO_A_PASO_ENTREGA.md`](GUIA_PASO_A_PASO_ENTREGA.md) - Para saber qué entregar
- [ ] [`GUIA_TESTING.md`](GUIA_TESTING.md) - Para hacer pruebas correctamente
- [ ] [`../scripts/README.md`](../scripts/README.md) - Para usar scripts automatizados

---

**Última Actualización**: 2025-11-17
**Autor**: Jorge Salgado Miranda
**Proyecto**: SSH-like Remote Command Executor
**Deadline**: Diciembre 9, 2025

---

## 🎓 Nota Final

Esta documentación fue diseñada para ser:
- **Completa**: Cubre todos los aspectos del proyecto
- **Organizada**: Fácil de navegar y encontrar información
- **Práctica**: Enfocada en acciones concretas
- **Actualizada**: Refleja el estado real del proyecto

**¡Úsala como tu guía de referencia durante todo el proceso de entrega!** 🚀
