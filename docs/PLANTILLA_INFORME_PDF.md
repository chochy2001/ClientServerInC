# Plantilla para Informe PDF

**Proyecto**: Ejecutor de Comandos Remotos SSH-like
**Autor**: Jorge Salgado Miranda
**Curso**: Arquitectura Cliente-Servidor

---

## Instrucciones para Generar el PDF

Este documento sirve como plantilla y guía para generar el informe final en PDF. El PDF debe incluir las secciones descritas abajo en el orden especificado.

### Herramientas Recomendadas para Generación

1. **Markdown to PDF**:
   - Pandoc: `pandoc informe.md -o informe.pdf`
   - VS Code con extensión "Markdown PDF"
   - Typora (export to PDF)

2. **LaTeX** (para formato más profesional):
   - Overleaf (online)
   - TeXShop (macOS)
   - TeXworks (Linux/Windows)

3. **Procesador de Texto**:
   - Microsoft Word / Google Docs
   - LibreOffice Writer
   - Export to PDF cuando esté completo

---

## Estructura del Informe PDF

### Sección 1: Portada

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

                UNIVERSIDAD NACIONAL AUTÓNOMA DE MÉXICO
                    FACULTAD DE INGENIERÍA

                 ARQUITECTURA CLIENTE-SERVIDOR


            EJECUTOR DE COMANDOS REMOTOS SSH-LIKE
                   Proyecto Final


                Presenta:
                Jorge Salgado Miranda


                Profesor:
                Carlos Román


                Fecha de Entrega:
                [Fecha de entrega - antes de Dec 9, 2025]


━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

### Sección 2: Índice

```
Contenido

1. Introducción ..................................................... 3
2. Descripción del Proyecto ........................................ 4
3. Arquitectura del Sistema ........................................ 5
4. Código Fuente: cliente.c ....................................... 6
5. Código Fuente: servidor.c ...................................... 10
6. Código Fuente: common.h ........................................ 18
7. Makefile ....................................................... 22
8. Instrucciones de Compilación ................................... 23
9. Instrucciones de Uso ........................................... 24
10. Pruebas del Sistema ............................................ 25
    10.1. Prueba Local (localhost) ................................. 25
    10.2. Prueba Remota (hosts diferentes) ......................... 26
11. Conclusiones ................................................... 27
```

---

### Sección 3: Introducción

**Contenido**:

```markdown
# 1. Introducción

El presente documento describe la implementación de un sistema ejecutor de
comandos remotos tipo SSH (Secure Shell), desarrollado como proyecto final
para el curso de Arquitectura Cliente-Servidor.

## 1.1 Objetivo

Implementar un sistema cliente-servidor en lenguaje C que permita la ejecución
remota de comandos Unix/Linux a través de sockets TCP/IP, simulando el
comportamiento básico de herramientas como SSH.

## 1.2 Alcance

El sistema permite:

- Conexión cliente-servidor mediante sockets TCP/IP
- Ejecución remota de comandos estándar de Unix (ls, pwd, ps, date, etc.)
- Transmisión completa de la salida del comando (stdout y stderr)
- Validación de comandos (prohibición de comandos interactivos)
- Manejo robusto de errores y recursos
- Desconexión limpia y gestión de múltiples sesiones

## 1.3 Tecnologías Utilizadas

- **Lenguaje**: C (estándar C99)
- **Protocolo**: TCP/IP (SOCK_STREAM, AF_INET)
- **APIs**: POSIX sockets, popen/pclose
- **Plataformas**: Linux y MacOS
- **Compilador**: GCC / Clang
```

---

### Sección 4: Descripción del Proyecto

**Contenido**:

```markdown
# 2. Descripción del Proyecto

## 2.1 Componentes del Sistema

El sistema consta de tres componentes principales:

### 2.1.1 Cliente (cliente.c)

El cliente es el programa que inicia la conexión con el servidor. Sus
responsabilidades incluyen:

- Conectarse al servidor especificado (IP y puerto)
- Leer comandos desde la entrada estándar (stdin)
- Enviar comandos al servidor mediante sockets
- Recibir y mostrar la salida de los comandos
- Detectar comandos especiales ("salir", "exit") para desconexión limpia

### 2.1.2 Servidor (servidor.c)

El servidor es el programa que escucha conexiones entrantes y ejecuta comandos.
Sus responsabilidades incluyen:

- Crear y configurar socket TCP en el puerto especificado
- Aceptar conexiones entrantes de clientes
- Recibir comandos de los clientes
- Validar comandos (rechazar comandos prohibidos)
- Ejecutar comandos usando popen()
- Capturar salida completa (stdout + stderr)
- Enviar resultados de vuelta al cliente
- Gestionar múltiples sesiones secuencialmente

### 2.1.3 Biblioteca Compartida (common.h)

Define constantes, estructuras y funciones compartidas:

- Constantes de buffer y protocolo
- Función enviar_con_longitud(): Envía datos con prefijo de longitud
- Función recibir_con_longitud(): Recibe datos con prefijo de longitud

## 2.2 Protocolo de Comunicación

Se implementó un protocolo simple y robusto de **longitud prefijada**:

1. **Envío de mensaje**:
   - Enviar 4 bytes: longitud del mensaje (uint32_t en network byte order)
   - Enviar N bytes: contenido del mensaje

2. **Recepción de mensaje**:
   - Recibir 4 bytes: leer longitud del mensaje
   - Convertir de network byte order a host byte order
   - Asignar buffer dinámicamente (malloc)
   - Recibir N bytes del mensaje
   - Agregar null terminator para uso como string

Este protocolo garantiza transmisión completa de mensajes sin truncamiento,
incluso para salidas largas de comandos.

## 2.3 Comandos Soportados y Prohibidos

### Comandos Soportados

El sistema soporta cualquier comando Unix estándar que produzca salida estática:

- **Archivos**: ls, ls -la, pwd, cat <archivo>
- **Procesos**: ps, ps aux, whoami
- **Sistema**: date, uname, hostname, df, du
- **Red**: ifconfig, netstat (con opciones que no sean dinámicas)

### Comandos Prohibidos

Por limitaciones técnicas y de seguridad, se prohiben:

- **cd** - No tiene efecto en sesión remota (cada comando ejecuta en su propio proceso)
- **top, htop** - Salida dinámica que requiere terminal interactivo
- **vim, nano, less, more** - Editores y paginadores interactivos
- **ssh** - No se permite SSH anidado
```

---

### Sección 5: Arquitectura del Sistema

**Contenido**:

```markdown
# 3. Arquitectura del Sistema

## 3.1 Diagrama de Flujo General

```
     ┌─────────────┐                         ┌─────────────┐
     │   CLIENTE   │                         │  SERVIDOR   │
     │             │                         │             │
     │ cliente.c   │                         │ servidor.c  │
     └──────┬──────┘                         └──────┬──────┘
            │                                       │
            │  1. socket() + connect()              │
            │─────────────────────────────────────>│
            │                                       │
            │  2. Conexión TCP establecida          │
            │<─────────────────────────────────────│
            │                                       │
            │  3. Usuario ingresa comando           │
            │     "ls -la"                          │
            │                                       │
            │  4. enviar_con_longitud(comando)      │
            │─────────────────────────────────────>│
            │     [4 bytes longitud][datos]         │
            │                                       │
            │                                  5. Recibe comando
            │                                  6. Valida comando
            │                                  7. Ejecuta con popen()
            │                                  8. Captura salida
            │                                       │
            │  9. enviar_con_longitud(resultado)    │
            │<─────────────────────────────────────│
            │     [4 bytes longitud][salida]        │
            │                                       │
            │  10. Muestra resultado al usuario     │
            │                                       │
            │  11. Usuario ingresa "salir"          │
            │                                       │
            │  12. close(socket)                    │
            │─────────────────────────────────────>│
            │                                       │
            │                                  13. Detecta desconexión
            │                                  14. Libera recursos
            │                                  15. Vuelve a accept()
            │                                       │
     ┌──────┴──────┐                         ┌──────┴──────┐
     │   Cliente   │                         │  Servidor   │
     │  Terminado  │                         │  Continúa   │
     └─────────────┘                         └─────────────┘
```

## 3.2 Modelo de Concurrencia

El servidor implementa un modelo **secuencial** (un cliente a la vez):

- **Ventaja**: Simplicidad, sin necesidad de threads o fork múltiple
- **Limitación**: Solo un cliente activo simultáneamente
- **Justificación**: Suficiente para proyecto académico demostrativo

**Flujo del Servidor**:

```
main()
  ├─> crear_socket_servidor(puerto)
  │     ├─> socket(AF_INET, SOCK_STREAM, 0)
  │     ├─> setsockopt(SO_REUSEADDR)
  │     ├─> bind(puerto)
  │     └─> listen(backlog=5)
  │
  └─> while (1) {  // Loop infinito
        ├─> sock_cliente = accept()
        ├─> manejar_cliente(sock_cliente)
        │     └─> while (1) {
        │           ├─> recibir_comando()
        │           ├─> validar_comando()
        │           ├─> ejecutar_comando()
        │           └─> enviar_resultado()
        │         }
        └─> close(sock_cliente)
      }
```

## 3.3 Gestión de Memoria

### Asignaciones Dinámicas

1. **recibir_con_longitud()** (common.h):
   - `malloc(longitud + 1)` para buffer de mensaje
   - El caller debe hacer `free()` después de usar

2. **manejar_cliente()** (servidor.c):
   - `malloc(MAX_SALIDA_SIZE)` para buffer de salida de comando
   - `free()` en todas las rutas (éxito, error, cleanup)

### Estrategia de Cleanup

- Todos los mallocs tienen su free correspondiente
- Cleanup en rutas de error con goto o return anticipado
- Verificación final con bloques if (ptr != NULL) free(ptr)

## 3.4 Manejo de Errores

### Principios

1. **Todas** las system calls verifican return value
2. Errores reportados con `perror()` para incluir errno
3. Recursos liberados incluso en rutas de error
4. Cliente distingue entre errores de red y errores de comando

### Ejemplo de Manejo de Error

```c
sock = socket(AF_INET, SOCK_STREAM, 0);
if (sock < 0) {
    perror("Error creando socket");  // Imprime "Error creando socket: <errno>"
    return -1;                       // Retorna error al caller
}
```
```

---

### Sección 6-8: Código Fuente

**Para estas secciones, incluir el código completo con números de línea**:

```markdown
# 4. Código Fuente: cliente.c

```c
     1  /*
     2   * cliente.c - Cliente SSH-like para ejecutar comandos remotamente
     3   *
     4   * Autor: Jorge Salgado Miranda
     ...
   189
```

[Incluir código completo de cliente.c con números de línea]

---

# 5. Código Fuente: servidor.c

```c
     1  /*
     2   * servidor.c - Servidor SSH-like que ejecuta comandos remotamente
     ...
   434
```

[Incluir código completo de servidor.c con números de línea]

---

# 6. Código Fuente: common.h

```c
     1  /*
     2   * common.h - Definiciones compartidas entre cliente y servidor
     ...
   193
```

[Incluir código completo de common.h con números de línea]

---

# 7. Makefile

```makefile
# Makefile para Ejecutor de Comandos Remotos SSH-like
...
```

[Incluir Makefile completo]
```

---

### Sección 9: Instrucciones de Compilación

**Contenido**:

```markdown
# 8. Instrucciones de Compilación

## 8.1 Requisitos

- Sistema operativo: Linux o MacOS
- Compilador: GCC 4.8+ o Clang
- Estándar: C99
- No requiere bibliotecas externas (solo libc estándar)

## 8.2 Compilación Manual

### Compilar Servidor

```bash
gcc -Wall -Wextra -std=c99 -o servidor src/servidor.c
```

**Flags Explicados**:
- `-Wall`: Activa todos los warnings comunes
- `-Wextra`: Activa warnings adicionales
- `-std=c99`: Usa el estándar C99
- `-o servidor`: Nombre del ejecutable de salida

### Compilar Cliente

```bash
gcc -Wall -Wextra -std=c99 -o cliente src/cliente.c
```

## 8.3 Compilación con Makefile

### Compilar Todo

```bash
make all
```

o simplemente:

```bash
make
```

### Compilar en Modo Debug

```bash
make debug
```

Agrega flags `-g -O0` para debugging con gdb/lldb.

### Compilar en Modo Release

```bash
make release
```

Agrega flag `-O2` para optimización.

### Limpiar Binarios

```bash
make clean
```

Elimina ejecutables y archivos temporales.

## 8.4 Verificación de Compilación

Después de compilar, verificar que no hay warnings:

```bash
$ make all
gcc -Wall -Wextra -std=c99 -o cliente src/cliente.c
Cliente compilado exitosamente
gcc -Wall -Wextra -std=c99 -o servidor src/servidor.c
Servidor compilado exitosamente
```

Verificar que los binarios existen:

```bash
$ ls -lh cliente servidor
-rwxr-xr-x  1 user  staff    35K Nov 17 14:00 cliente
-rwxr-xr-x  1 user  staff    42K Nov 17 14:00 servidor
```
```

---

### Sección 10: Instrucciones de Uso

**Contenido**:

```markdown
# 9. Instrucciones de Uso

## 9.1 Ejecución del Servidor

### Sintaxis

```bash
./servidor <puerto>
```

### Parámetros

- `<puerto>`: Número de puerto entre 1024 y 65535
  - Puertos < 1024 requieren privilegios root (no recomendado)
  - Puertos comunes para pruebas: 8080, 8000, 9000

### Ejemplo

```bash
$ ./servidor 8080
Servidor escuchando en puerto 8080...

Esperando conexión de cliente...
```

El servidor quedará esperando conexiones. Cuando un cliente se conecte, mostrará:

```
Cliente conectado desde 192.168.1.100:54321
Iniciando sesión con cliente...
Comando recibido: 'ls -la'
Enviando resultado (823 bytes)
```

### Detener el Servidor

- `Ctrl+C` para terminar el servidor
- El servidor liberará el socket automáticamente gracias a SO_REUSEADDR

## 9.2 Ejecución del Cliente

### Sintaxis

```bash
./cliente <IP> <puerto>
```

### Parámetros

- `<IP>`: Dirección IP o hostname del servidor
  - Para prueba local: `localhost` o `127.0.0.1`
  - Para prueba remota: IP real del servidor (ej: `192.168.1.100`)
- `<puerto>`: Número de puerto del servidor (1024-65535)

### Ejemplo - Conexión Local

```bash
$ ./cliente localhost 8080
Conectado al servidor localhost:8080
Escribe 'salir' o 'exit' para desconectar

comando> ls -la
total 120
drwxr-xr-x  10 user  staff   320 Nov 17 14:00 .
drwxr-xr-x   8 user  staff   256 Nov 16 10:30 ..
-rw-r--r--   1 user  staff  5234 Nov 17 13:45 cliente.c
-rw-r--r--   1 user  staff 12456 Nov 17 13:50 servidor.c

comando> pwd
/Users/user/proyecto

comando> date
Dom Nov 17 14:05:23 CST 2025

comando> salir
Cerrando conexión...
Desconectado del servidor
```

### Ejemplo - Conexión Remota

```bash
$ ./cliente 192.168.1.100 8080
Conectado al servidor 192.168.1.100:8080
Escribe 'salir' o 'exit' para desconectar

comando> whoami
servidor_user

comando> hostname
servidor-hostname

comando> salir
Cerrando conexión...
Desconectado del servidor
```

## 9.3 Comandos Disponibles

### Comandos Soportados

- `ls`, `ls -la`, `ls -lh` - Listar archivos
- `pwd` - Directorio actual del servidor
- `ps`, `ps aux` - Procesos del servidor
- `date` - Fecha y hora del servidor
- `whoami` - Usuario del servidor
- `hostname` - Nombre del host del servidor
- `cat <archivo>` - Mostrar contenido de archivo
- `echo <texto>` - Imprimir texto
- `df -h` - Espacio en disco
- `uname -a` - Información del sistema
- Y cualquier otro comando Unix estándar no interactivo

### Comandos Prohibidos

Si intentas ejecutar un comando prohibido:

```bash
comando> cd /tmp
ERROR: Comando 'cd' no está soportado

comando> top
ERROR: Comando 'top' no está soportado
```

Los comandos prohibidos son:
- `cd` - No tiene efecto en ejecución remota
- `top`, `htop` - Salida dinámica no soportada
- `vim`, `nano`, `less`, `more` - Interactivos no soportados
- `ssh` - No se permite SSH anidado

### Comando de Salida

Para terminar la sesión:

```bash
comando> salir
# o
comando> exit
```

Ambos comandos cierran la conexión limpiamente.

## 9.4 Manejo de Errores

### Error de Conexión

```bash
$ ./cliente 192.168.1.200 8080
Error conectando al servidor: Connection refused
Error: no se pudo conectar al servidor 192.168.1.200:8080
```

**Causa**: Servidor no está ejecutándose o firewall bloquea conexión

### Error de Puerto Inválido

```bash
$ ./servidor 100
Error: puerto debe estar entre 1024 y 65535
```

### Comando con Error

```bash
comando> cat archivo_no_existe.txt
cat: archivo_no_existe.txt: No such file or directory
```

El error del comando se muestra normalmente al cliente.
```

---

### Sección 11: Pruebas del Sistema

**Contenido**:

```markdown
# 10. Pruebas del Sistema

## 10.1 Prueba Local (localhost)

### Descripción

Prueba de ejecución en la misma máquina usando localhost como dirección IP.
Esto verifica que la funcionalidad básica del sistema funciona correctamente.

### Procedimiento

1. **Terminal 1 - Iniciar Servidor**:
   ```bash
   $ ./servidor 8080
   Servidor escuchando en puerto 8080...
   ```

2. **Terminal 2 - Conectar Cliente**:
   ```bash
   $ ./cliente localhost 8080
   Conectado al servidor localhost:8080
   Escribe 'salir' o 'exit' para desconectar
   ```

3. **Ejecutar Comandos de Prueba**:
   ```bash
   comando> ls -la
   [salida del comando ls]

   comando> pwd
   [directorio actual]

   comando> date
   [fecha y hora]

   comando> ps
   [lista de procesos]

   comando> salir
   Cerrando conexión...
   Desconectado del servidor
   ```

### Screenshot

[INSERTAR AQUÍ: docs/capturas/prueba_local.png]

**Descripción de la Screenshot**:
La imagen muestra dos terminales lado a lado. Terminal izquierda ejecutando
el servidor en puerto 8080. Terminal derecha con cliente conectado a localhost,
mostrando la ejecución exitosa de varios comandos (ls, pwd, date, ps) con sus
respectivas salidas completas.

---

## 10.2 Prueba Remota (hosts diferentes)

### Descripción

Prueba de ejecución entre dos máquinas diferentes en una red, usando direcciones
IP reales. Esto verifica la capacidad del sistema para comunicación remota real
mediante TCP/IP.

### Configuración

- **Host A (Servidor)**:
  - IP: 192.168.1.100 (ejemplo)
  - Sistema: macOS / Linux
  - Puerto: 8080

- **Host B (Cliente)**:
  - IP: 192.168.1.101 (ejemplo)
  - Sistema: macOS / Linux
  - Conexión: Misma red local que Host A

### Procedimiento

1. **Host A - Verificar IP del Servidor**:
   ```bash
   $ ifconfig | grep inet
   inet 192.168.1.100 netmask 0xffffff00 broadcast 192.168.1.255
   ```

2. **Host A - Iniciar Servidor**:
   ```bash
   $ ./servidor 8080
   Servidor escuchando en puerto 8080...
   ```

3. **Host B - Conectar Cliente desde Otra Máquina**:
   ```bash
   $ ./cliente 192.168.1.100 8080
   Conectado al servidor 192.168.1.100:8080
   Escribe 'salir' o 'exit' para desconectar
   ```

4. **Host B - Ejecutar Comandos Remotos**:
   ```bash
   comando> whoami
   servidor_user

   comando> hostname
   servidor-hostname

   comando> pwd
   /home/servidor_user/proyecto

   comando> ls
   cliente.c  servidor.c  common.h  Makefile

   comando> date
   Dom Nov 17 14:30:00 CST 2025

   comando> salir
   Cerrando conexión...
   Desconectado del servidor
   ```

5. **Host A - Verificar Logs del Servidor**:
   ```bash
   Cliente conectado desde 192.168.1.101:54321
   Iniciando sesión con cliente...
   Comando recibido: 'whoami'
   Enviando resultado (14 bytes)
   Comando recibido: 'hostname'
   Enviando resultado (17 bytes)
   ...
   Cliente cerró la conexión
   Sesión con cliente terminada
   Cliente desconectado
   ```

### Screenshot

[INSERTAR AQUÍ: docs/capturas/prueba_remota.png]

**Descripción de la Screenshot**:
La imagen muestra dos computadoras diferentes. Lado izquierdo: servidor ejecutándose
en Host A (192.168.1.100), mostrando aceptación de conexión desde 192.168.1.101.
Lado derecho: cliente en Host B conectado al servidor remoto mediante IP real,
ejecutando comandos que se ejecutan en el servidor y mostrando que whoami y
hostname corresponden al servidor, no al cliente.

---

## 10.3 Pruebas de Validación

### Prueba de Comandos Prohibidos

```bash
comando> cd /tmp
ERROR: Comando 'cd' no está soportado

comando> top
ERROR: Comando 'top' no está soportado

comando> vim test.txt
ERROR: Comando 'vim' no está soportado
```

**Resultado**: ✅ Sistema rechaza correctamente comandos no soportados

### Prueba de Comandos con Error

```bash
comando> cat archivo_inexistente.txt
cat: archivo_inexistente.txt: No such file or directory
```

**Resultado**: ✅ Error del comando se transmite correctamente al cliente

### Prueba de Desconexión Limpia

```bash
comando> salir
Cerrando conexión...
Desconectado del servidor
```

**Servidor muestra**:
```
Cliente cerró la conexión
Sesión con cliente terminada
Cliente desconectado

Esperando conexión de cliente...
```

**Resultado**: ✅ Desconexión limpia, servidor continúa aceptando conexiones

### Prueba de Múltiples Sesiones Secuenciales

1. Cliente 1 se conecta, ejecuta comandos, se desconecta
2. Cliente 2 se conecta inmediatamente después
3. Cliente 2 ejecuta comandos sin problemas

**Resultado**: ✅ Servidor maneja múltiples sesiones secuenciales correctamente
```

---

### Sección 12: Conclusiones

**Contenido**:

```markdown
# 11. Conclusiones

## 11.1 Objetivos Cumplidos

Se logró implementar exitosamente un sistema cliente-servidor SSH-like con las
siguientes características:

1. ✅ **Arquitectura TCP/IP**: Comunicación confiable mediante sockets TCP
2. ✅ **Ejecución Remota**: Comandos ejecutados en servidor, output retornado a cliente
3. ✅ **Protocolo Robusto**: Longitud prefijada garantiza transmisión completa
4. ✅ **Validación**: Comandos prohibidos rechazados con mensajes claros
5. ✅ **Manejo de Errores**: Todas las system calls verificadas, recursos liberados
6. ✅ **Documentación**: Código completamente documentado en español
7. ✅ **Portabilidad**: Funciona en Linux y MacOS sin modificaciones

## 11.2 Aprendizajes Técnicos

### Programación de Sockets

- Configuración de sockets TCP con socket(), bind(), listen(), accept()
- Importancia de SO_REUSEADDR para evitar "Address already in use"
- Manejo de envíos/recepciones parciales con loops
- Detección de desconexión del peer (recv() == 0)

### Gestión de Procesos

- Uso de popen() para ejecutar comandos y capturar salida
- Redirección de stderr a stdout con "2>&1"
- Manejo de códigos de salida con WIFEXITED() y WEXITSTATUS()

### Diseño de Protocolos

- Ventaja de length-prefixed protocol sobre delimitadores
- Network byte order (htonl, ntohl) para portabilidad
- Importancia de validación de longitudes para seguridad

### Gestión de Memoria en C

- Asignación dinámica con malloc() basada en mensaje recibido
- Importancia de free() en todas las rutas (incluyendo errores)
- Null terminators para compatibilidad con strings

## 11.3 Limitaciones y Mejoras Futuras

### Limitaciones Actuales

1. **Concurrencia**: Un cliente a la vez (modelo secuencial)
2. **Autenticación**: Sin mecanismo de login o password
3. **Encriptación**: Comunicación en texto plano (no segura)
4. **Cambio de Directorio**: cd no soportado (por diseño)

### Mejoras Propuestas

1. **Concurrencia**: Implementar con fork() o threads para múltiples clientes
2. **Autenticación**: Agregar challenge-response o integración con PAM
3. **Seguridad**: Integrar SSL/TLS para encriptar comunicación
4. **Estado de Sesión**: Mantener directorio actual entre comandos
5. **Logs**: Agregar logging a archivo para auditoría

## 11.4 Reflexión Final

Este proyecto permitió aplicar conceptos fundamentales de programación de sistemas:
sockets, procesos, gestión de memoria, y protocolos de comunicación. La implementación
en C reforzó la importancia del manejo explícito de recursos y verificación de errores.

El resultado es un sistema funcional que demuestra los principios básicos de
comunicación cliente-servidor, comparable a herramientas reales como SSH en su
funcionalidad esencial (aunque sin la robustez y seguridad de implementaciones
profesionales).

---

**Proyecto realizado por**: Jorge Salgado Miranda
**Curso**: Arquitectura Cliente-Servidor
**Profesor**: Carlos Román
**Fecha**: 2025-11-17
```

---

## Checklist de Contenido del PDF

Antes de generar el PDF final, verificar que incluya:

- [ ] Portada con información del proyecto y autor
- [ ] Índice con números de página
- [ ] Introducción (objetivos, alcance, tecnologías)
- [ ] Descripción del proyecto (componentes, protocolo)
- [ ] Arquitectura del sistema (diagramas, flujos)
- [ ] Código fuente completo de cliente.c con números de línea
- [ ] Código fuente completo de servidor.c con números de línea
- [ ] Código fuente completo de common.h con números de línea
- [ ] Makefile completo
- [ ] Instrucciones de compilación claras y probadas
- [ ] Instrucciones de uso con ejemplos
- [ ] Screenshot de prueba local (docs/capturas/prueba_local.png)
- [ ] Screenshot de prueba remota (docs/capturas/prueba_remota.png)
- [ ] Resultados de pruebas de validación
- [ ] Conclusiones y reflexión

---

## Generación del PDF

### Opción 1: Pandoc (Recomendado)

```bash
# Crear archivo markdown con todo el contenido
cat portada.md intro.md codigo.md conclusiones.md > informe_completo.md

# Generar PDF con Pandoc
pandoc informe_completo.md -o docs/informe.pdf \
  --toc \
  --number-sections \
  --highlight-style=tango \
  --pdf-engine=xelatex
```

### Opción 2: LaTeX (Overleaf)

1. Subir código a Overleaf
2. Usar template "Academic Project Report"
3. Copiar/pegar contenido en secciones apropiadas
4. Insertar screenshots con `\includegraphics{}`
5. Compilar y descargar PDF

### Opción 3: Procesador de Texto

1. Abrir Word / Google Docs / LibreOffice
2. Configurar estilos (Heading 1, Heading 2, Code)
3. Copiar/pegar contenido sección por sección
4. Insertar código con fuente monospace (Courier New / Consolas)
5. Insertar imágenes de screenshots
6. Exportar como PDF

---

**Preparado por**: Jorge Salgado Miranda
**Fecha**: 2025-11-17
