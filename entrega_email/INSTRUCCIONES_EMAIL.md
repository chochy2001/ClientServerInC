# Instrucciones para Envío por Email

**Proyecto**: Ejecutor de Comandos Remotos SSH-like
**Autor**: Jorge Salgado Miranda
**Destinatario**: carlos.roman@ingenieria.unam.edu

---

## Archivos a Adjuntar

Esta carpeta contiene los archivos que deben ser adjuntados al email de entrega:

1. **cliente.c** (5.2 KB)
   - Implementación del cliente SSH-like
   - Se conecta al servidor, envía comandos, muestra resultados

2. **servidor.c** (12 KB)
   - Implementación del servidor SSH-like
   - Acepta conexiones, ejecuta comandos, retorna salida

3. **common.h** (5.4 KB)
   - Definiciones compartidas entre cliente y servidor
   - Protocolo de comunicación (longitud prefijada)

**Total**: ~22.6 KB - Todos los archivos son menores a 100KB ✅

---

## Formato del Email

### Asunto (Subject)
```
[Arquitectura Cliente-Servidor] Proyecto Final - SSH-like Remote Executor - Jorge Salgado Miranda
```

### Cuerpo del Email

```
Estimado Profesor Carlos Román,

Por medio del presente, envío el proyecto final del curso de Arquitectura Cliente-Servidor:

**Proyecto**: Ejecutor de Comandos Remotos SSH-like
**Estudiante**: Jorge Salgado Miranda
**Fecha**: [Fecha de envío]

**Archivos Adjuntos**:
- cliente.c (código fuente del cliente)
- servidor.c (código fuente del servidor)
- common.h (definiciones compartidas)

**Descripción Breve**:
Sistema cliente-servidor implementado en C que permite ejecutar comandos Unix remotamente mediante sockets TCP/IP. El cliente envía comandos al servidor, quien los ejecuta localmente y retorna la salida completa (stdout + stderr) al cliente.

**Características Implementadas**:
- Sockets TCP/IP (AF_INET, SOCK_STREAM)
- Ejecución remota de comandos con popen()
- Protocolo de longitud prefijada para transmisión confiable
- Validación de comandos (lista de comandos prohibidos)
- Manejo completo de errores y recursos
- Desconexión limpia con "salir" o "exit"
- Código 100% en C (estándar C99)
- Documentación completa en español

**Compilación**:
```bash
gcc -Wall -Wextra -std=c99 -o servidor servidor.c
gcc -Wall -Wextra -std=c99 -o cliente cliente.c
```

**Uso**:
```bash
# Terminal 1 (servidor)
./servidor 8080

# Terminal 2 (cliente)
./cliente localhost 8080
# O conexión remota:
./cliente 192.168.1.100 8080
```

Quedo atento a sus comentarios y confirmación de recepción.

Solicito agendar una sesión por Zoom para demostración en vivo del proyecto según lo indicado en las especificaciones del curso.

Saludos cordiales,
Jorge Salgado Miranda
```

---

## Verificación Antes de Enviar

### Checklist Pre-Envío

- [ ] Archivos tienen la extensión correcta (.c, .h)
- [ ] Ningún archivo es binario (no .o, no ejecutables)
- [ ] Tamaño total < 1 MB (actualmente ~22.6 KB ✅)
- [ ] Headers de archivo incluyen autor y fecha
- [ ] No hay menciones de herramientas de IA en el código
- [ ] Código compila sin warnings
- [ ] Subject line del email es claro y descriptivo
- [ ] Cuerpo del email es profesional y conciso

### Verificación de Contenido

```bash
# Verificar que archivos son texto plano
file cliente.c servidor.c common.h

# Verificar que no hay binarios
ls -lh

# Buscar posibles menciones de IA (debe retornar vacío)
grep -i "claude\|gpt\|openai\|copilot" *.c *.h
```

---

## Notas Importantes

### ❌ NO Adjuntar

- Binarios compilados (cliente, servidor, *.o)
- Archivos temporales (*.dSYM, core, gmon.out)
- Carpetas de configuración (.claude, .specify, .git)
- Makefile (no solicitado)
- README.md (no solicitado)
- PDF del informe (se envía por otro medio o se sube a plataforma)

### ✅ SÍ Adjuntar

- **Únicamente** los archivos .c y .h
- Solo archivos de código fuente texto plano

### 🔒 Seguridad del Email

Los servidores de email bloquean ejecutables por seguridad, por eso es crítico que:
- **NUNCA** adjuntar binarios compilados
- **SOLO** adjuntar archivos fuente .c y .h
- Verificar que los archivos son texto plano con `file` command

---

## Confirmación de Envío

Después de enviar el email:

1. **Verificar que el email se envió**:
   - Revisar carpeta "Enviados"
   - Confirmar que los 3 archivos se adjuntaron correctamente

2. **Esperar confirmación**:
   - El profesor debería confirmar recepción
   - Si no hay respuesta en 24-48 horas, enviar follow-up

3. **Agendar Zoom**:
   - Contactar al profesor via Telegram/WhatsApp
   - Confirmar fecha y hora para demo en vivo
   - Preparar ambiente de prueba antes de la sesión

---

## Timeline Recomendado

1. **1 semana antes del deadline**: Enviar email con archivos .c
2. **5 días antes del deadline**: Follow-up si no hay respuesta
3. **3 días antes del deadline**: Zoom session agendado y confirmado
4. **1 día antes del deadline**: Test de cámara y screen sharing
5. **Día del deadline**: Todo listo, sin sorpresas

**Deadline Final**: Tuesday, December 9, 2025

---

**Preparado por**: Jorge Salgado Miranda
**Fecha**: 2025-11-17
