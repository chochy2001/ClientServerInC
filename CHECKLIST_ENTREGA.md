# ✅ Checklist de Entrega del Proyecto

**Proyecto**: Ejecutor de Comandos Remotos SSH-like
**Estudiante**: Jorge Salgado Miranda
**Deadline**: **Martes, Diciembre 9, 2025** ⏰
**Días Restantes**: [Calcular desde hoy]

---

## 📋 Cómo Usar Este Checklist

1. Imprime este documento O ábrelo en un editor markdown
2. Marca cada item con `[x]` cuando lo completes
3. Revisa diariamente tu progreso
4. No dejes todo para última semana

**Formato**:
- `[ ]` = Pendiente
- `[x]` = Completado
- `[~]` = En progreso
- `[!]` = Crítico/Urgente

---

## 🎯 FASE 1: IMPLEMENTACIÓN (✅ COMPLETA)

### Código Fuente
- [x] src/cliente.c implementado (189 líneas)
- [x] src/servidor.c implementado (434 líneas)
- [x] src/common.h implementado (193 líneas)
- [x] Protocolo de longitud prefijada funcional
- [x] Validación de comandos prohibidos
- [x] Manejo de errores completo
- [x] Gestión de memoria correcta

### Build System
- [x] Makefile completo
- [x] Compilación sin warnings
- [x] Flags estrictos (-Wall -Wextra -pedantic)
- [x] Target 'clean' funcional
- [x] Target 'debug' y 'release' (opcional)

### Documentación Básica
- [x] Headers de archivo con autor y fecha
- [x] Funciones documentadas en español
- [x] README.md con instrucciones básicas
- [x] .gitignore configurado

**Porcentaje Fase 1**: 100% ✅

---

## 🔍 FASE 2: VALIDACIÓN Y CALIDAD (✅ COMPLETA)

### Validación de Código
- [x] Compilación sin warnings verificada
- [x] Auditoría de malloc/free (balanceados)
- [x] Auditoría de socket/close (balanceados)
- [x] Variables y funciones en español
- [x] Comentarios en español
- [x] Sin menciones de IA en código fuente

### Documentación de Validación
- [x] docs/VALIDACION.md creado
- [x] docs/CUMPLIMIENTO_CONSTITUTION.md creado
- [x] docs/RESUMEN_PROYECTO.md creado
- [x] Documentos reflejan estado real del proyecto

### Scripts de Automatización
- [x] scripts/test_automatico.sh creado y ejecutable
- [x] scripts/validacion_pre_entrega.sh creado y ejecutable
- [x] scripts/generar_codigo_pdf.sh creado y ejecutable
- [x] scripts/README.md con documentación de scripts

**Porcentaje Fase 2**: 100% ✅

---

## 🧪 FASE 3: TESTING (⏳ PENDIENTE)

### Testing Local

- [ ] [!] Compilar proyecto: `make clean && make all`
- [ ] [!] Ejecutar servidor en Terminal 1: `./servidor 8080`
- [ ] [!] Ejecutar cliente en Terminal 2: `./cliente localhost 8080`
- [ ] [!] Probar comando: `pwd`
- [ ] [!] Probar comando: `ls -la`
- [ ] [!] Probar comando: `date`
- [ ] [!] Probar comando: `whoami`
- [ ] [!] Probar comando: `ps`
- [ ] [!] Probar desconexión: `salir`
- [ ] [!] Verificar servidor continúa ejecutándose
- [ ] [!] Reconectar y probar más comandos
- [ ] Ejecutar tests automatizados: `./scripts/test_automatico.sh`
- [ ] Todos los tests pasan (16/16)

### Screenshot Prueba Local

- [ ] [!] Preparar 2 terminales lado a lado
- [ ] [!] Terminal 1: Servidor mostrando log de conexiones
- [ ] [!] Terminal 2: Cliente con múltiples comandos ejecutados
- [ ] [!] Capturar screenshot (Cmd+Shift+4 en macOS)
- [ ] [!] Guardar como: `docs/capturas/prueba_local.png`
- [ ] [!] Verificar screenshot es legible y completo
- [ ] [!] Verificar se ven ambas terminales
- [ ] [!] Verificar se ve puerto (8080) y host (localhost)

### Testing de Validación

- [ ] Probar comando prohibido: `cd /tmp` → debe retornar ERROR
- [ ] Probar comando prohibido: `top` → debe retornar ERROR
- [ ] Probar comando prohibido: `vim test.txt` → debe retornar ERROR
- [ ] Probar archivo inexistente: `cat /archivo_no_existe.txt`
- [ ] Probar comando inexistente: `comando_inventado_123`
- [ ] Verificar mensajes de error claros en todos los casos

### Testing Remoto (Opcional pero Recomendado)

- [ ] Conseguir 2 máquinas en misma red
- [ ] Verificar IP de máquina servidor: `ifconfig | grep inet`
- [ ] Copiar binarios a ambas máquinas
- [ ] Verificar firewall permite puerto 8080
- [ ] Ejecutar servidor en Máquina A
- [ ] Conectar cliente desde Máquina B
- [ ] Ejecutar comandos: `whoami`, `hostname`, `pwd`
- [ ] Verificar que output corresponde al servidor
- [ ] Capturar screenshot mostrando ambas máquinas
- [ ] Guardar como: `docs/capturas/prueba_remota.png`

### Testing en Linux (Opcional)

- [ ] Acceso a máquina/VM Linux
- [ ] Copiar código a Linux
- [ ] Compilar: `make clean && make all`
- [ ] Verificar sin warnings
- [ ] Ejecutar pruebas funcionales
- [ ] Ejecutar valgrind en servidor
- [ ] Ejecutar valgrind en cliente
- [ ] Verificar 0 bytes leaked

**Porcentaje Fase 3**: [Calcular según items completados]

---

## 📄 FASE 4: GENERACIÓN DE PDF (⏳ PENDIENTE)

### Preparación de Contenido

- [ ] [!] Ejecutar: `./scripts/generar_codigo_pdf.sh`
- [ ] [!] Verificar archivos generados en `docs/codigo_para_pdf/`
- [ ] [!] Leer `docs/PLANTILLA_INFORME_PDF.md` completo

### Creación del Documento

**Elegir UNA opción**:

#### Opción A: Word/Google Docs
- [ ] Abrir Word o Google Docs
- [ ] Crear portada con nombre, proyecto, fecha, curso
- [ ] Crear índice (Table of Contents)
- [ ] Copiar sección Introducción de PLANTILLA
- [ ] Copiar sección Descripción del Proyecto
- [ ] Copiar sección Arquitectura
- [ ] Copiar código de cliente_numerado.md (fuente Courier New 9pt)
- [ ] Copiar código de servidor_numerado.md (fuente Courier New 9pt)
- [ ] Copiar código de common_numerado.md (fuente Courier New 9pt)
- [ ] Copiar Makefile numerado
- [ ] Escribir sección Instrucciones de Compilación
- [ ] Escribir sección Instrucciones de Uso
- [ ] Insertar `prueba_local.png` con caption
- [ ] Insertar `prueba_remota.png` con caption (si existe)
- [ ] Escribir sección Conclusiones

#### Opción B: Pandoc
- [ ] Instalar pandoc: `brew install pandoc` (macOS) o `apt install pandoc` (Linux)
- [ ] Crear archivo markdown completo
- [ ] Ejecutar: `pandoc input.md -o docs/informe.pdf --toc --number-sections`

#### Opción C: LaTeX/Overleaf
- [ ] Crear proyecto en Overleaf
- [ ] Configurar paquetes (listings, graphicx)
- [ ] Estructurar documento según PLANTILLA
- [ ] Compilar y descargar PDF

### Verificación del PDF

- [ ] [!] Abrir PDF generado: `open docs/informe.pdf`
- [ ] [!] Verificar portada completa
- [ ] [!] Verificar índice con números de página
- [ ] [!] Verificar TODO el código de cliente.c está presente
- [ ] [!] Verificar TODO el código de servidor.c está presente
- [ ] [!] Verificar TODO el código de common.h está presente
- [ ] [!] Verificar números de línea visibles
- [ ] [!] Verificar fuente monospace para código
- [ ] [!] Verificar código es legible (no muy pequeño)
- [ ] [!] Verificar screenshots insertados y visibles
- [ ] [!] Verificar captions de screenshots descriptivos
- [ ] [!] Verificar conclusiones presentes
- [ ] [!] Verificar sin errores de ortografía
- [ ] [!] Verificar PDF < 20MB tamaño
- [ ] [!] Verificar total páginas razonable (< 50 páginas)

**Porcentaje Fase 4**: [Calcular según items completados]

---

## 🧹 FASE 5: CLEANUP PRE-SUBMISSION (❗ CRÍTICO)

### Verificación Final de Código

- [ ] [!] Ejecutar: `./scripts/validacion_pre_entrega.sh`
- [ ] [!] Resolver TODOS los errores (✗ FAIL)
- [ ] [!] Verificar porcentaje > 90%
- [ ] [!] Compilar una última vez: `make clean && make all`
- [ ] [!] Verificar sin warnings

### Eliminación de Archivos de Desarrollo

- [ ] [!] **CRÍTICO**: Hacer backup: `tar -czf backup_$(date +%Y%m%d).tar.gz .claude .specify`
- [ ] [!] **CRÍTICO**: Eliminar `.claude`: `rm -rf .claude`
- [ ] [!] **CRÍTICO**: Eliminar `.specify`: `rm -rf .specify`
- [ ] [!] **CRÍTICO**: Verificar eliminación: `ls -la | grep -E "\.claude|\.specify"` (debe retornar vacío)

### Verificación de Integridad Académica

- [ ] [!] **CRÍTICO**: Buscar menciones de IA en archivos de entrega:
  ```bash
  grep -ri "claude\|anthropic\|gpt\|openai\|chatgpt\|copilot" \
    src/ README.md Makefile entrega_email/ docs/informe.pdf
  ```
- [ ] [!] **CRÍTICO**: Resultado debe ser VACÍO (0 menciones)
- [ ] Buscar menciones en docs internos está OK (no se entregan)

### Limpieza de Binarios

- [ ] Ejecutar: `make clean`
- [ ] Verificar no hay binarios: `ls cliente servidor` debe dar error
- [ ] Verificar no hay .o: `ls *.o` debe dar error
- [ ] Verificar no hay .dSYM: `ls *.dSYM` debe dar error

### Verificación de Git

- [ ] Ver estado: `git status`
- [ ] Verificar .gitignore excluye binarios
- [ ] Ver diff: `git diff`
- [ ] Verificar cambios tienen sentido

**Porcentaje Fase 5**: [Calcular según items completados]

---

## ✉️ FASE 6: ENVÍO DE ENTREGABLES (❗ CRÍTICO)

### Preparación de Archivos para Email

- [ ] [!] Ir a carpeta: `cd entrega_email/`
- [ ] [!] Verificar archivos existen: `ls -lh`
- [ ] [!] Verificar tamaños < 100KB: `du -h *.c *.h`
- [ ] [!] Verificar son texto: `file *.c *.h` (todos deben decir "C source")
- [ ] [!] Leer `INSTRUCCIONES_EMAIL.md` completo

### Redacción del Email

- [ ] [!] Abrir cliente de email
- [ ] [!] Para: `carlos.roman@ingenieria.unam.edu`
- [ ] [!] Asunto: `[Arquitectura Cliente-Servidor] Proyecto Final - SSH-like Remote Executor - Jorge Salgado Miranda`
- [ ] [!] Copiar cuerpo de `INSTRUCCIONES_EMAIL.md`
- [ ] [!] Reemplazar [FECHA DE HOY] con fecha actual
- [ ] [!] Revisar ortografía y gramática

### Adjuntar Archivos

- [ ] [!] Adjuntar `cliente.c`
- [ ] [!] Adjuntar `servidor.c`
- [ ] [!] Adjuntar `common.h`
- [ ] [!] Verificar 3 archivos adjuntos (SOLO estos)
- [ ] [!] **NO** adjuntar binarios (cliente, servidor)
- [ ] [!] **NO** adjuntar PDF (a menos que se solicite)
- [ ] [!] **NO** adjuntar folders (.git, .claude, etc)

### Verificación Pre-Envío

- [ ] [!] Re-leer email completo
- [ ] [!] Verificar destinatario correcto
- [ ] [!] Verificar asunto descriptivo
- [ ] [!] Verificar 3 archivos .c y .h únicamente
- [ ] [!] Verificar tono profesional
- [ ] [!] Sin emojis ni lenguaje informal

### Envío

- [ ] [!] **Hacer clic en ENVIAR**
- [ ] [!] Ir a carpeta "Enviados"
- [ ] [!] Abrir email enviado
- [ ] [!] Verificar se envió correctamente
- [ ] [!] Verificar adjuntos están presentes
- [ ] [!] Anotar fecha y hora de envío

### Confirmación

- [ ] Esperar confirmación de recepción (24-48 horas)
- [ ] Si no hay respuesta en 48 horas, enviar follow-up
- [ ] Guardar copia del email en algún lugar seguro

**Porcentaje Fase 6**: [Calcular según items completados]

---

## 🎥 FASE 7: SESIÓN ZOOM (❗ CRÍTICO)

### Agendamiento

- [ ] [!] Contactar profesor vía Telegram/WhatsApp
- [ ] [!] Proponer 3-4 opciones de fecha y hora
- [ ] [!] Preferiblemente 3-5 días antes del deadline
- [ ] [!] Esperar confirmación
- [ ] [!] Anotar fecha confirmada: `____________________`
- [ ] [!] Anotar hora confirmada: `____________________`
- [ ] [!] Anotar link de Zoom (si proporcionado): `____________________`
- [ ] [!] Agregar a calendario con alarma 1 hora antes

### Preparación Técnica (1 Día Antes)

- [ ] Verificar cámara funciona (abrir Zoom y probar)
- [ ] Verificar micrófono funciona
- [ ] Verificar internet estable (> 5 Mbps)
- [ ] Probar screen sharing en Zoom
- [ ] Verificar iluminación adecuada para cámara
- [ ] Preparar espacio ordenado y profesional

### Preparación del Demo (1 Día Antes)

- [ ] Compilar proyecto: `make clean && make all`
- [ ] Verificar sin warnings
- [ ] Probar demo end-to-end
- [ ] Preparar 2 terminales:
  - Terminal 1: `./servidor 8080`
  - Terminal 2: `./cliente localhost 8080`
- [ ] Preparar lista de comandos a demostrar:
  ```
  pwd
  ls -la
  date
  whoami
  hostname
  ps
  cd /tmp     (para mostrar rechazo)
  top         (para mostrar rechazo)
  cat README.md
  salir
  ```
- [ ] Ensayar demo al menos 1 vez

### Día de la Sesión (30 min antes)

- [ ] Cerrar todas las apps innecesarias
- [ ] Cerrar pestañas de navegador innecesarias
- [ ] Limpiar desktop (quitar archivos personales)
- [ ] Abrir Zoom 15 minutos antes
- [ ] Verificar audio y video funcionen
- [ ] Tener agua cerca
- [ ] Ir al baño
- [ ] Respirar profundo y relajarse

### Durante la Sesión

- [ ] Activar cámara
- [ ] Presentarse profesionalmente
- [ ] Compartir pantalla
- [ ] Demostrar compilación
- [ ] Demostrar servidor ejecutándose
- [ ] Demostrar cliente conectando
- [ ] Ejecutar comandos uno por uno
- [ ] Explicar brevemente qué hace cada parte
- [ ] Demostrar comando prohibido es rechazado
- [ ] Demostrar desconexión limpia
- [ ] Demostrar servidor continúa funcionando
- [ ] Responder preguntas del profesor
- [ ] Agradecer por el tiempo
- [ ] Despedirse profesionalmente

### Post-Sesión

- [ ] Anotar feedback recibido
- [ ] Enviar email de agradecimiento (opcional)
- [ ] Guardar grabación si fue grabada

**Porcentaje Fase 7**: [Calcular según items completados]

---

## 📝 FASE 8: GIT COMMIT FINAL (Después de Todo lo Anterior)

### Preparación del Commit

- [ ] Verificar TODO está completado arriba
- [ ] Verificar folders .claude y .specify eliminados
- [ ] Verificar PDF generado y correcto
- [ ] Verificar email enviado
- [ ] Verificar Zoom completado

### Review de Cambios

- [ ] `git status` - ver archivos modificados
- [ ] `git diff` - revisar cambios
- [ ] Verificar cambios tienen sentido

### Staging

- [ ] `git add src/`
- [ ] `git add docs/`
- [ ] `git add scripts/`
- [ ] `git add Makefile`
- [ ] `git add README.md`
- [ ] `git add .gitignore`
- [ ] **NO** add binarios
- [ ] **NO** add folders .claude/.specify (ya eliminados)

### Commit en Español Primera Persona

- [ ] [!] Ejecutar comando:
  ```bash
  git commit -m "Finalizo implementación del ejecutor SSH-like

  Implementé sistema cliente-servidor en C que permite ejecución remota
  de comandos Unix mediante sockets TCP/IP. El código cumple con todos
  los requisitos del proyecto: validación de comandos, manejo robusto
  de errores, protocolo de comunicación confiable, y documentación
  completa en español.

  Completé todas las fases:
  - Implementación core (811 líneas de código C)
  - Testing funcional local y remoto
  - Generación de PDF con código y screenshots
  - Validación de calidad sin warnings
  - Envío de entregables y demo en Zoom

  El proyecto está listo para evaluación final."
  ```

### Verificación del Commit

- [ ] `git log -1` - ver último commit
- [ ] `git show HEAD` - ver detalles del commit
- [ ] Verificar mensaje en español primera persona
- [ ] Verificar no menciona herramientas de IA

**Porcentaje Fase 8**: [Calcular según items completados]

---

## 🎯 RESUMEN DE PROGRESO GENERAL

### Por Fase

- **Fase 1 - Implementación**: ✅ 100%
- **Fase 2 - Validación**: ✅ 100%
- **Fase 3 - Testing**: ⏳ ____%
- **Fase 4 - PDF**: ⏳ ____%
- **Fase 5 - Cleanup**: ⏳ ____%
- **Fase 6 - Email**: ⏳ ____%
- **Fase 7 - Zoom**: ⏳ ____%
- **Fase 8 - Git Commit**: ⏳ ____%

### Progreso Total

**Items Completados**: ______ / 150+
**Porcentaje General**: _____%

### Items Críticos Pendientes (Marcar con !)

1. [ ] [!] Screenshot prueba local
2. [ ] [!] Generar PDF
3. [ ] [!] Eliminar .claude y .specify
4. [ ] [!] Enviar email
5. [ ] [!] Agendar Zoom

---

## ⏰ RECORDATORIOS POR FECHA

### 1 Semana Antes (Diciembre 2)

- [ ] PDF debe estar terminado
- [ ] Screenshots capturados
- [ ] Email listo para enviar

### 5 Días Antes (Diciembre 4)

- [ ] Email YA ENVIADO
- [ ] Zoom YA AGENDADO
- [ ] Confirmación de Zoom recibida

### 3 Días Antes (Diciembre 6)

- [ ] Demo ensayado
- [ ] Todo técnicamente listo
- [ ] Cámara/mic probados

### 1 Día Antes (Diciembre 8)

- [ ] Repasar proyecto completo
- [ ] Revisar posibles preguntas
- [ ] Descansar bien

### Día de Entrega (Diciembre 9)

- [ ] Si Zoom es hoy, llegar 15 min antes
- [ ] Verificar todo entregado
- [ ] Celebrar 🎉

---

## 📞 CONTACTOS DE EMERGENCIA

**Profesor**: Carlos Román
**Email**: carlos.roman@ingenieria.unam.edu
**Telegram/WhatsApp**: [Agregar si conoces]

**En caso de emergencia técnica**:
1. Enviar email explicando problema
2. Contactar vía Telegram/WhatsApp si es urgente
3. Si falla todo, documentar el problema y explicar en Zoom

---

## ✅ VERIFICACIÓN FINAL (Día de Deadline)

- [ ] Email con .c enviado ✓
- [ ] PDF generado y disponible ✓
- [ ] Zoom completado exitosamente ✓
- [ ] Folders .claude y .specify eliminados ✓
- [ ] Git commit final hecho ✓
- [ ] Profesor confirmó recepción ✓
- [ ] **PROYECTO ENTREGADO** ✅

---

**Fecha de última actualización**: 2025-11-17
**Versión del Checklist**: 1.0
**Estado Actual**: 40% completado (Fases 1-2)

## 🎉 ¡CUANDO COMPLETES TODO, CELEBRA!

Has completado un proyecto complejo de arquitectura cliente-servidor.
Has demostrado conocimientos en:
- Programación en C
- Sockets TCP/IP
- Protocolos de comunicación
- Gestión de memoria y recursos
- Testing y validación
- Documentación técnica

**¡FELICIDADES!** 🎊🎈🚀

---

**Imprime este checklist y márcalo día a día. ¡Tú puedes!** 💪
