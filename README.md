# Ejecutor de Comandos Remotos (Cliente-Servidor SSH-like)

Sistema cliente-servidor implementado en C que permite ejecutar comandos Unix remotamente mediante sockets TCP/IP.

## Autores

- Jorge Salgado Miranda
- Joshua Ivan Lopez Nava

## Descripción

Proyecto académico para el curso de Arquitectura Cliente-Servidor que implementa un sistema similar a SSH. El cliente se conecta al servidor a través de sockets TCP, envía comandos que son ejecutados en el servidor, y recibe la salida completa (stdout + stderr) de vuelta.

## Características

- Comunicación mediante sockets TCP/IP (AF_INET, SOCK_STREAM)
- Ejecución remota de comandos Unix con `popen()`
- Protocolo de comunicación con longitud prefijada para transmisión confiable
- Validación de comandos con lista de comandos prohibidos
- Manejo robusto de errores y recursos
- Soporte para múltiples comandos con sus opciones
- Desconexión limpia con comandos `salir` o `exit`
- Compatible con Linux y MacOS
- Código 100% en C (estándar C99)

## Requisitos

- Sistema operativo: Linux o MacOS
- Compilador: GCC 4.8+ o Clang con soporte para C99
- Librerías estándar de C (POSIX)

## Compilación

El proyecto consta de tres archivos fuente principales:
- `src/cliente.c` - Implementación del cliente
- `src/servidor.c` - Implementación del servidor
- `src/common.h` - Definiciones compartidas y funciones del protocolo

### Compilar el servidor

```bash
gcc -Wall -Wextra -std=c99 -o servidor src/servidor.c
```

### Compilar el cliente

```bash
gcc -Wall -Wextra -std=c99 -o cliente src/cliente.c
```

### Compilar ambos

```bash
gcc -Wall -Wextra -std=c99 -o servidor src/servidor.c
gcc -Wall -Wextra -std=c99 -o cliente src/cliente.c
```

## Uso

### Ejecutar el servidor

El servidor debe iniciarse primero y requiere especificar el puerto como argumento:

```bash
./servidor <puerto>
```

Ejemplo:
```bash
./servidor 8080
```

El servidor quedará escuchando conexiones en el puerto especificado.

### Ejecutar el cliente

El cliente requiere la dirección IP (o hostname) del servidor y el puerto:

```bash
./cliente <IP_o_hostname> <puerto>
```

Ejemplos:

**Conexión local:**
```bash
./cliente localhost 8080
```

**Conexión remota:**
```bash
./cliente 192.168.1.100 8080
```

### Uso interactivo

Una vez conectado, el cliente mostrará el prompt `comando>` donde puedes escribir comandos Unix:

```bash
comando> pwd
/Users/usuario/proyecto

comando> ls -la
total 64
drwxr-xr-x  10 usuario  staff   320 Nov 17 14:00 .
drwxr-xr-x  20 usuario  staff   640 Nov 17 13:00 ..
-rw-r--r--   1 usuario  staff  4499 Nov 17 14:00 README.md
drwxr-xr-x   5 usuario  staff   160 Nov 17 12:00 src
...

comando> date
Sun Nov 17 14:30:25 CST 2025

comando> whoami
usuario

comando> salir
Cerrando conexión...
```

## Comandos Soportados

### Comandos permitidos

El servidor acepta la mayoría de comandos Unix estándar, incluyendo:

- `pwd` - Directorio actual
- `ls`, `ls -la`, `ls -lh` - Listar archivos
- `date` - Fecha y hora del sistema
- `whoami` - Usuario actual
- `hostname` - Nombre del host
- `ps`, `ps aux` - Lista de procesos
- `cat <archivo>` - Mostrar contenido de archivo
- `echo <texto>` - Imprimir texto
- `uname -a` - Información del sistema
- Y cualquier otro comando Unix no interactivo

### Comandos prohibidos

Por limitaciones técnicas, los siguientes comandos están prohibidos:

- `cd` - No cambia el directorio de trabajo del servidor
- `top`, `htop` - Comandos con salida dinámica no soportados
- `vim`, `nano`, `less`, `more` - Editores interactivos no soportados
- `ssh` - Conexiones SSH anidadas no permitidas

Si intentas ejecutar un comando prohibido, recibirás un mensaje de error:
```bash
comando> cd /tmp
ERROR: Comando 'cd' está prohibido
```

### Desconexión

Para cerrar la conexión con el servidor:

```bash
comando> salir
```

O también:

```bash
comando> exit
```

El servidor continuará ejecutándose y podrá aceptar nuevas conexiones.

## Arquitectura

### Protocolo de Comunicación

El proyecto utiliza un protocolo simple pero robusto de longitud prefijada:

1. **Envío de datos:**
   - Se envían 4 bytes con la longitud del mensaje (en network byte order)
   - Luego se envían los datos del mensaje

2. **Recepción de datos:**
   - Se leen primero los 4 bytes de longitud
   - Se reserva memoria dinámica para el mensaje
   - Se leen los datos según la longitud recibida

Este protocolo asegura que los mensajes se transmitan completos, manejando correctamente el caso donde `send()` o `recv()` no transmiten todos los bytes en una sola llamada.

### Flujo de Comunicación

```
Cliente                                    Servidor
  │                                           │
  │──────── 1. Conectar (TCP) ──────────────►│
  │                                           │
  │──── 2. Enviar comando (ej: "ls -la") ───►│
  │                                           │
  │                                      3. Validar
  │                                      comando
  │                                           │
  │                                      4. Ejecutar
  │                                      con popen()
  │                                           │
  │◄──── 5. Retornar salida (stdout+stderr) ─│
  │                                           │
  │──────── 6. Mostrar resultado ────────────│
  │                                           │
  │──────── 7. Nuevo comando o salir ────────│
```

## Estructura del Proyecto

```
.
├── src/
│   ├── cliente.c       # Implementación del cliente TCP
│   ├── servidor.c      # Implementación del servidor TCP
│   └── common.h        # Protocolo de comunicación compartido
├── README.md           # Este archivo
└── .gitignore          # Archivos excluidos de git
```

## Manejo de Errores

El sistema incluye manejo robusto de errores:

- Validación de argumentos de línea de comandos
- Verificación de errores en llamadas de sistema (socket, bind, listen, accept, connect)
- Validación de comandos antes de ejecutarlos
- Detección de errores en la ejecución de comandos
- Liberación correcta de recursos (memoria, sockets, descriptores de archivo)
- Mensajes de error descriptivos en español

## Ejemplo de Sesión Completa

**Terminal 1 (Servidor):**
```bash
$ ./servidor 8080
Servidor iniciado en puerto 8080
Esperando conexiones...
Cliente conectado desde 127.0.0.1:54321
Comando recibido: pwd
Comando ejecutado exitosamente
Comando recibido: ls -la
Comando ejecutado exitosamente
Cliente desconectado
Esperando conexiones...
```

**Terminal 2 (Cliente):**
```bash
$ ./cliente localhost 8080
Conectado al servidor localhost:8080
Escribe 'salir' o 'exit' para terminar

comando> pwd
/Users/usuario/proyecto

comando> ls -la
total 64
drwxr-xr-x  10 usuario  staff   320 Nov 17 14:00 .
drwxr-xr-x  20 usuario  staff   640 Nov 17 13:00 ..
-rw-r--r--   1 usuario  staff  4499 Nov 17 14:00 README.md
-rwxr-xr-x   1 usuario  staff 34632 Nov 17 14:00 cliente
-rwxr-xr-x   1 usuario  staff 51944 Nov 17 14:00 servidor
drwxr-xr-x   5 usuario  staff   160 Nov 17 12:00 src

comando> salir
Cerrando conexión...
Desconectado del servidor
```

## Pruebas Recomendadas

### Prueba Local
1. Compilar ambos programas
2. En Terminal 1: `./servidor 8080`
3. En Terminal 2: `./cliente localhost 8080`
4. Ejecutar varios comandos
5. Verificar que la salida es correcta

### Prueba Remota
1. Compilar en dos máquinas diferentes en la misma red
2. En Máquina A (servidor): `./servidor 8080`
3. Obtener IP de Máquina A: `ifconfig | grep inet`
4. En Máquina B (cliente): `./cliente <IP_de_A> 8080`
5. Ejecutar comandos y verificar que se ejecutan en Máquina A

### Prueba de Validación
1. Intentar comando prohibido: `cd /tmp` → Debe mostrar ERROR
2. Intentar comando inexistente: `comando_falso` → Debe mostrar error del sistema
3. Probar comando con archivo: `cat README.md` → Debe mostrar contenido

## Limitaciones Conocidas

- El servidor maneja un cliente a la vez (implementación secuencial)
- No soporta comandos interactivos que requieren entrada del usuario
- No soporta comandos que cambian el estado del shell (como `cd`)
- No soporta comandos con salida dinámica continua (como `top`)
- El tamaño máximo del comando es de 1024 bytes
- El tamaño máximo de la salida es de 64KB

## Notas Técnicas

- El servidor usa `popen()` con redirección `2>&1` para capturar tanto stdout como stderr
- Los mensajes de error del servidor se muestran en rojo en terminales que soportan colores ANSI
- El cliente valida la respuesta del servidor antes de mostrarla
- El protocolo usa `htonl()` y `ntohl()` para portabilidad entre arquitecturas
- Todos los buffers tienen protección contra desbordamiento

## Licencia

Proyecto académico para el curso de Arquitectura Cliente-Servidor.
Universidad Nacional Autónoma de México (UNAM) - Facultad de Ingeniería.
