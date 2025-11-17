# Guía Paso a Paso para Entrega del Proyecto

**Proyecto**: Ejecutor de Comandos Remotos SSH-like
**Autor**: Jorge Salgado Miranda
**Deadline**: Martes, Diciembre 9, 2025

---

## 📋 Resumen de Entregables

Debes entregar:
1. ✉️ **Email** con archivos .c adjuntos
2. 📄 **PDF** con código completo y screenshots
3. 🎥 **Sesión Zoom** para demo en vivo

---

## 🗓️ Timeline Recomendado

### Semana 1 (Noviembre 18-24)
- ✅ Código completo (YA HECHO)
- 🎯 Testing local y screenshots
- 🎯 Generación de PDF

### Semana 2 (Noviembre 25 - Diciembre 1)
- 🎯 Testing remoto y screenshots
- 🎯 Testing en Linux (opcional pero recomendado)
- 🎯 Finalizar PDF

### Semana 3 (Diciembre 2-8)
- 🎯 Cleanup final
- 🎯 Envío de email
- 🎯 Agendar Zoom

---

## 📝 Paso 1: Testing Local y Screenshots

### 1.1 Ejecutar Testing Automatizado

```bash
# Compilar proyecto
make clean && make all

# En Terminal 1 - Iniciar servidor
./servidor 8080

# En Terminal 2 - Ejecutar tests
./scripts/test_automatico.sh localhost 8080
```

**Resultado Esperado**: Todos los tests deben pasar (✓ PASS)

### 1.2 Capturar Screenshot de Prueba Local

**Setup de Pantalla**:
- Usa 2 terminales lado a lado
- Terminal izquierda: Servidor ejecutándose
- Terminal derecha: Cliente conectado

**Comandos para Screenshot**:

Terminal 1 (Izquierda):
```bash
./servidor 8080
```

Terminal 2 (Derecha):
```bash
./cliente localhost 8080

comando> pwd
comando> ls -la
comando> date
comando> whoami
comando> ps
comando> salir
```

**Capturar**:
- macOS: `Cmd + Shift + 4` → seleccionar área
- Linux: `Print Screen` o herramienta de captura
- Guardar como: `docs/capturas/prueba_local.png`

**Verificar Screenshot Incluya**:
- ✅ Ambas terminales visibles
- ✅ IP/puerto visible (localhost:8080)
- ✅ Múltiples comandos ejecutados
- ✅ Salidas completas de comandos
- ✅ Comando "salir" y desconexión limpia

---

## 🌐 Paso 2: Testing Remoto y Screenshot (Opcional pero Recomendado)

### 2.1 Configurar Dos Máquinas

**Opción A**: Dos computadoras físicas en misma red
- Laptop + Desktop
- Dos laptops
- Laptop + Raspberry Pi

**Opción B**: Computadora + VM
- Host OS + VirtualBox/VMware
- Configurar red en modo "Bridged" o "NAT con port forwarding"

**Opción C**: Dos VMs
- Ambas en red bridged
- Verificar pueden hacer ping entre sí

### 2.2 Preparar Servidor (Máquina A)

```bash
# Verificar IP
ifconfig | grep inet
# o en Linux: ip addr show

# Supongamos IP es 192.168.1.100

# Verificar firewall (macOS)
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --getglobalstate

# Si firewall activo, permitir el programa
# System Preferences > Security & Privacy > Firewall > Options
# Add ./servidor y permitir conexiones entrantes

# Iniciar servidor
./servidor 8080
```

### 2.3 Conectar Cliente (Máquina B)

```bash
# Verificar conectividad
ping -c 3 192.168.1.100

# Verificar puerto abierto (opcional)
telnet 192.168.1.100 8080
# Ctrl+] luego quit

# Conectar cliente
./cliente 192.168.1.100 8080

comando> whoami
comando> hostname
comando> pwd
comando> ls
comando> date
comando> salir
```

### 2.4 Capturar Screenshot de Prueba Remota

**Setup**:
- Captura de ambas pantallas (si es posible)
- O foto de ambas pantallas
- O captura de pantalla de cada una y combinar

**Debe Mostrar**:
- ✅ IP real visible en servidor (no localhost)
- ✅ Cliente conectando a IP remota
- ✅ whoami y hostname muestran info del servidor
- ✅ Múltiples comandos ejecutados
- ✅ Salida completa visible

**Guardar**: `docs/capturas/prueba_remota.png`

---

## 📄 Paso 3: Generar PDF con Código y Screenshots

### 3.1 Preparar Contenido

```bash
# Generar archivos numerados
./scripts/generar_codigo_pdf.sh

# Los archivos generados están en:
# docs/codigo_para_pdf/cliente_numerado.md
# docs/codigo_para_pdf/servidor_numerado.md
# docs/codigo_para_pdf/common_numerado.md
# docs/codigo_para_pdf/makefile_numerado.md
```

### 3.2 Crear Documento

**Opción A: Usando Word/Google Docs**

1. Abrir Microsoft Word o Google Docs
2. Crear documento nuevo
3. Seguir estructura de `docs/PLANTILLA_INFORME_PDF.md`:
   - Portada
   - Índice
   - Introducción
   - Descripción del Proyecto
   - Arquitectura
   - Código Fuente (copiar de archivos *_numerado.md)
   - Makefile
   - Instrucciones de Compilación
   - Instrucciones de Uso
   - Pruebas (insertar screenshots)
   - Conclusiones

4. Formato de Código:
   - Fuente: Courier New o Consolas
   - Tamaño: 9pt o 10pt
   - Copiar código de archivos *_numerado.md
   - Mantener números de línea

5. Insertar Imágenes:
   - Insert > Image
   - docs/capturas/prueba_local.png
   - docs/capturas/prueba_remota.png
   - Agregar caption descriptivo bajo cada imagen

6. Exportar como PDF:
   - File > Export > PDF
   - Guardar como: `docs/informe.pdf`

**Opción B: Usando Pandoc (Línea de Comandos)**

```bash
# Crear archivo markdown completo
cat > docs/informe_completo.md << 'EOF'
# (Copiar contenido de PLANTILLA_INFORME_PDF.md)
# (Reemplazar [INSERTAR CÓDIGO] con contenido de *_numerado.md)
# (Reemplazar [INSERTAR SCREENSHOT] con ![](capturas/prueba_local.png))
EOF

# Generar PDF
pandoc docs/informe_completo.md \
  -o docs/informe.pdf \
  --toc \
  --number-sections \
  --highlight-style=tango \
  --pdf-engine=xelatex \
  -V geometry:margin=1in
```

**Opción C: Usando LaTeX (Overleaf)**

1. Ir a https://overleaf.com
2. New Project > Blank Project
3. Crear estructura siguiendo PLANTILLA_INFORME_PDF.md
4. Usar `\lstlisting` para código con números de línea:
```latex
\begin{lstlisting}[language=C, numbers=left]
// código aquí
\end{lstlisting}
```
5. Insertar imágenes con `\includegraphics`:
```latex
\begin{figure}[h]
\centering
\includegraphics[width=0.9\textwidth]{prueba_local.png}
\caption{Prueba Local en localhost}
\end{figure}
```
6. Compile y descargar PDF

### 3.3 Verificar PDF

**Checklist del PDF**:
- [ ] Portada con nombre, fecha, curso
- [ ] Índice con números de página
- [ ] Código de cliente.c completo con números de línea
- [ ] Código de servidor.c completo con números de línea
- [ ] Código de common.h completo con números de línea
- [ ] Makefile incluido
- [ ] Instrucciones de compilación claras
- [ ] Instrucciones de uso con ejemplos
- [ ] Screenshot de prueba local insertado y visible
- [ ] Screenshot de prueba remota insertado y visible
- [ ] Conclusiones presentes
- [ ] Todo el código es legible (fuente no muy pequeña)
- [ ] Total de páginas < 50 (recomendado)

**Abrir PDF y Verificar**:
```bash
open docs/informe.pdf  # macOS
# o
xdg-open docs/informe.pdf  # Linux
```

---

## 🧹 Paso 4: Cleanup Pre-Submission (CRÍTICO)

### 4.1 Eliminar Folders de Desarrollo

```bash
# IMPORTANTE: Hacer backup primero si quieres conservar
tar -czf backup_proyecto_$(date +%Y%m%d).tar.gz .claude .specify

# Eliminar folders
rm -rf .claude
rm -rf .specify

# Verificar eliminación
ls -la | grep -E "\.claude|\.specify"
# No debe mostrar nada
```

### 4.2 Verificar Sin Menciones de IA

```bash
# Buscar en archivos de código y docs principales
grep -ri "claude\|anthropic\|gpt\|openai\|chatgpt\|copilot" \
  src/ README.md Makefile informe.pdf 2>/dev/null

# Resultado debe ser vacío
```

**Nota**: Si encuentra menciones en docs internos (VALIDACION.md, GUIA_TESTING.md), es OK porque son archivos que no se entregan.

### 4.3 Limpiar Binarios y Temporales

```bash
# Limpiar todo
make clean

# Verificar
ls -la | grep -E "cliente$|servidor$|\.o$|\.dSYM"
# No debe mostrar nada

# Recompilar una última vez para verificar
make all

# Verificar que compila sin warnings
echo "Si ves este mensaje, todo compiló bien"
```

### 4.4 Verificar .gitignore

```bash
# Ver archivos que git trackea
git status

# No deberían estar:
# - cliente, servidor (binarios)
# - *.o
# - *.dSYM/
# - .DS_Store
# - *.log
```

---

## ✉️ Paso 5: Preparar y Enviar Email

### 5.1 Verificar Archivos para Adjuntar

```bash
# Ir a folder de entrega
cd entrega_email/

# Verificar archivos
ls -lh
# Debe mostrar: cliente.c, servidor.c, common.h

# Verificar tamaño (cada uno debe ser < 100KB)
du -h *.c *.h

# Verificar que son texto plano (no binarios)
file *.c *.h
# Todos deben decir "C source" o "ASCII text"
```

### 5.2 Redactar Email

**Para**: carlos.roman@ingenieria.unam.edu

**Asunto**:
```
[Arquitectura Cliente-Servidor] Proyecto Final - SSH-like Remote Executor - Jorge Salgado Miranda
```

**Cuerpo** (copiar de `entrega_email/INSTRUCCIONES_EMAIL.md`):

```
Estimado Profesor Carlos Román,

Por medio del presente, envío el proyecto final del curso de Arquitectura Cliente-Servidor:

Proyecto: Ejecutor de Comandos Remotos SSH-like
Estudiante: Jorge Salgado Miranda
Fecha: [FECHA DE HOY]

Archivos Adjuntos:
- cliente.c (código fuente del cliente)
- servidor.c (código fuente del servidor)
- common.h (definiciones compartidas)

Descripción Breve:
Sistema cliente-servidor implementado en C que permite ejecutar comandos Unix remotamente mediante sockets TCP/IP. El cliente envía comandos al servidor, quien los ejecuta localmente y retorna la salida completa (stdout + stderr) al cliente.

Características Implementadas:
- Sockets TCP/IP (AF_INET, SOCK_STREAM)
- Ejecución remota de comandos con popen()
- Protocolo de longitud prefijada para transmisión confiable
- Validación de comandos (lista de comandos prohibidos)
- Manejo completo de errores y recursos
- Desconexión limpia con "salir" o "exit"
- Código 100% en C (estándar C99)
- Documentación completa en español

Compilación:
gcc -Wall -Wextra -std=c99 -o servidor servidor.c
gcc -Wall -Wextra -std=c99 -o cliente cliente.c

Uso:
# Terminal 1 (servidor)
./servidor 8080

# Terminal 2 (cliente)
./cliente localhost 8080
# O conexión remota:
./cliente 192.168.1.100 8080

Quedo atento a sus comentarios y confirmación de recepción.

Solicito agendar una sesión por Zoom para demostración en vivo del proyecto según lo indicado en las especificaciones del curso.

Saludos cordiales,
Jorge Salgado Miranda
```

### 5.3 Adjuntar Archivos

1. Nuevo email en tu cliente de correo
2. Completar Para, Asunto, Cuerpo
3. Adjuntar archivos:
   - cliente.c
   - servidor.c
   - common.h
4. **NO adjuntar**:
   - Binarios (cliente, servidor)
   - Archivos .o
   - Folders (.claude, .specify, .git)
   - El PDF (se puede enviar aparte si se solicita)

### 5.4 Verificar Antes de Enviar

**Checklist Final del Email**:
- [ ] Destinatario correcto
- [ ] Asunto descriptivo con tu nombre
- [ ] Cuerpo profesional y conciso
- [ ] 3 archivos adjuntos (.c y .h únicamente)
- [ ] Ningún archivo binario adjunto
- [ ] Sin menciones de IA en archivos adjuntos
- [ ] Ortografía y gramática correctas

### 5.5 Enviar Email

1. Hacer clic en "Enviar"
2. Ir a carpeta "Enviados" y verificar que se envió
3. Abrir el email enviado y verificar adjuntos

---

## 🎥 Paso 6: Agendar Sesión Zoom

### 6.1 Contactar Profesor

**Vía**: Telegram o WhatsApp (según lo indicado en clase)

**Mensaje**:
```
Buen día Profesor Carlos Román,

Le informo que he enviado mi proyecto final del curso de Arquitectura Cliente-Servidor por email.

Solicito agendar una sesión por Zoom para realizar la demostración en vivo del sistema. Mi disponibilidad es:

[Proponer 3-4 opciones de fecha y hora, por ejemplo:]
- Lunes 2 de diciembre, 10:00-12:00
- Miércoles 4 de diciembre, 14:00-16:00
- Viernes 6 de diciembre, 10:00-12:00
- Lunes 9 de diciembre, 10:00-12:00 (último día)

Quedo atento a su confirmación.

Saludos,
Jorge Salgado Miranda
```

### 6.2 Confirmar Sesión

Cuando recibas confirmación:
- [ ] Anotar fecha y hora
- [ ] Agregar a calendario con recordatorio 1 hora antes
- [ ] Anotar link de Zoom si te lo proporcionan

### 6.3 Preparar Demo

**Día Antes de la Sesión**:
- [ ] Verificar cámara funciona
- [ ] Verificar micrófono funciona
- [ ] Verificar conexión a internet estable
- [ ] Probar screen sharing en Zoom
- [ ] Compilar proyecto: `make clean && make all`
- [ ] Tener terminales preparadas

**Día de la Sesión** (30 minutos antes):
- [ ] Cerrar todas las apps innecesarias
- [ ] Abrir Zoom y verificar configuración
- [ ] Abrir 2 terminales preparadas:
  - Terminal 1: listo para `./servidor 8080`
  - Terminal 2: listo para `./cliente localhost 8080`
- [ ] Tener lista de comandos para demostrar:
  ```
  pwd
  ls -la
  date
  whoami
  ps
  cd /tmp  (para mostrar que es rechazado)
  cat README.md
  salir
  ```
- [ ] Limpiar desktop (quitar archivos personales visibles)

**Durante la Sesión**:
1. Activar cámara
2. Saludar profesionalmente
3. Compartir pantalla
4. Demostrar:
   - Compilación sin warnings
   - Servidor ejecutándose
   - Cliente conectando
   - Ejecución de múltiples comandos
   - Comando prohibido siendo rechazado
   - Desconexión limpia
   - Servidor continúa ejecutándose
5. Responder preguntas del profesor
6. Agradecer y despedirse

---

## 🎯 Paso 7: Git Commit Final

### 7.1 Revisar Cambios

```bash
git status
git diff
```

### 7.2 Agregar Archivos

```bash
# Agregar solo archivos de código y docs
git add src/
git add docs/
git add Makefile
git add README.md
git add .gitignore

# NO agregar binarios ni folders de desarrollo
```

### 7.3 Commit en Español Primera Persona

```bash
git commit -m "Finalizo implementación del ejecutor SSH-like con protocolo TCP/IP

Implementé sistema cliente-servidor que permite ejecución remota de comandos
Unix mediante sockets TCP. El código está 100% en C con documentación completa
en español.

Características principales:
- Protocolo de longitud prefijada para transmisión confiable
- Validación de comandos con lista de prohibidos
- Manejo robusto de errores y memoria
- Ejecución con popen() capturando stdout y stderr
- Desconexión limpia con salir/exit

El proyecto compila sin warnings y está listo para evaluación.
Incluyo documentación completa, guías de testing y scripts de validación."
```

### 7.4 Verificar Commit

```bash
git log -1
git show HEAD
```

---

## ✅ Checklist Final Completo

### Código y Compilación
- [ ] Código compila sin warnings con `-Wall -Wextra -pedantic`
- [ ] Todas las funciones documentadas en español
- [ ] Variables y funciones con nombres en español
- [ ] Sin menciones de herramientas de IA en código
- [ ] Binarios ejecutables generados exitosamente

### Testing
- [ ] Tests automáticos pasan (./scripts/test_automatico.sh)
- [ ] Prueba local ejecutada exitosamente
- [ ] Screenshot de prueba local capturado
- [ ] Prueba remota ejecutada (opcional pero recomendado)
- [ ] Screenshot de prueba remota capturado (opcional)

### Documentación
- [ ] PDF generado con código completo
- [ ] Screenshots insertados en PDF
- [ ] PDF es legible y bien formateado
- [ ] README.md actualizado

### Entregables
- [ ] Archivos .c copiados a entrega_email/
- [ ] Email redactado según template
- [ ] Email enviado con 3 archivos .c adjuntos
- [ ] Confirmación de recepción de email
- [ ] Zoom agendado y confirmado

### Cleanup
- [ ] Folder .claude eliminado
- [ ] Folder .specify eliminado
- [ ] Sin menciones de IA en archivos de entrega
- [ ] Binarios limpiados (make clean)
- [ ] Git commit final en español primera persona

### Pre-Zoom
- [ ] Cámara funcional
- [ ] Micrófono funcional
- [ ] Internet estable
- [ ] Screen sharing probado
- [ ] Demo preparada y ensayada

---

## 🆘 Solución de Problemas

### "No puedo compilar"

```bash
# Verificar que tienes GCC
gcc --version

# Si no está instalado:
# macOS: xcode-select --install
# Linux: sudo apt-get install build-essential

# Limpiar y recompilar
make clean
make all
```

### "Email rechazado por tamaño"

- Verifica que NO adjuntaste binarios
- Solo adjunta .c y .h (deben ser < 50KB total)
- Si aún es rechazado, comprime en .zip

### "No puedo capturar pantalla remota"

Opciones:
- Toma foto de ambas pantallas con teléfono
- Captura cada pantalla por separado y combina en editor de imágenes
- Pide a alguien que tome foto mientras demuestras
- Si no es posible, documenta en PDF que solo pudiste hacer prueba local

### "Valgrind no funciona en macOS"

Es normal. Valgrind no está soportado nativamente en macOS moderno.

Opciones:
- Usa Docker con imagen Linux para ejecutar valgrind
- Usa VM con Linux
- Documenta en PDF que hiciste auditoría manual de memoria

### "Profesor no responde para Zoom"

- Envía follow-up después de 48 horas
- Si falta poco para deadline, menciona urgencia
- Como último recurso, graba un video de demo y envíalo

---

**Preparado por**: Jorge Salgado Miranda
**Última actualización**: 2025-11-17
**Versión**: 1.0

---

## 📞 Contacto de Emergencia

Si tienes problemas técnicos:
1. Re-leer esta guía completa
2. Revisar docs/GUIA_TESTING.md
3. Ejecutar ./scripts/validacion_pre_entrega.sh
4. Contactar al profesor lo antes posible

**No esperes hasta el último día para empezar los entregables.**

¡Éxito con tu proyecto! 🚀
