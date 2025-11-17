# Guía Completa de Testing

**Proyecto**: Ejecutor de Comandos Remotos SSH-like
**Autor**: Jorge Salgado Miranda
**Fecha**: 2025-11-17

---

## Tabla de Contenidos

1. [Pruebas Funcionales](#1-pruebas-funcionales)
2. [Pruebas de Validación](#2-pruebas-de-validación)
3. [Pruebas de Memoria (Valgrind)](#3-pruebas-de-memoria-valgrind)
4. [Pruebas Cross-Platform](#4-pruebas-cross-platform)
5. [Pruebas de Red Remota](#5-pruebas-de-red-remota)
6. [Pruebas de Estrés](#6-pruebas-de-estrés)
7. [Checklist Final](#7-checklist-final)

---

## 1. Pruebas Funcionales

### 1.1 Prueba Local Básica

**Objetivo**: Verificar funcionalidad básica en localhost

**Procedimiento**:

```bash
# Terminal 1 - Servidor
$ ./servidor 8080
```

```bash
# Terminal 2 - Cliente
$ ./cliente localhost 8080

comando> ls -la
comando> pwd
comando> date
comando> whoami
comando> ps
comando> salir
```

**Resultado Esperado**:
- ✅ Cliente se conecta exitosamente
- ✅ Cada comando retorna su salida completa
- ✅ Comando "salir" cierra conexión limpiamente
- ✅ Servidor continúa ejecutándose después de desconexión

### 1.2 Prueba de Comandos con Argumentos

**Objetivo**: Verificar comandos con múltiples argumentos y opciones

```bash
comando> ls -lah /tmp
comando> ps aux | head
comando> cat /etc/hosts
comando> echo "Hola Mundo"
comando> df -h
comando> du -sh .
comando> find . -name "*.c"
```

**Resultado Esperado**:
- ✅ Opciones y argumentos se pasan correctamente al comando
- ✅ Salida completa se transmite sin truncamiento
- ✅ Pipes y redirecciones funcionan (ejecutados por sh)

### 1.3 Prueba de Comandos con Salida Larga

**Objetivo**: Verificar manejo de salidas grandes

```bash
comando> cat src/servidor.c
comando> ls -laR /usr
comando> ps aux
comando> dmesg
```

**Resultado Esperado**:
- ✅ Salida completa se transmite (hasta MAX_SALIDA_SIZE = 64KB)
- ✅ Si salida > 64KB, se trunca pero no crashea
- ✅ Cliente muestra toda la salida recibida

### 1.4 Prueba de Múltiples Comandos en una Sesión

**Objetivo**: Verificar que cliente puede ejecutar múltiples comandos sin desconectar

```bash
comando> pwd
comando> ls
comando> date
comando> whoami
comando> hostname
comando> uname -a
comando> uptime
comando> w
comando> last | head
comando> netstat -an | grep LISTEN
comando> salir
```

**Resultado Esperado**:
- ✅ Todos los comandos se ejecutan exitosamente
- ✅ No hay degradación de performance
- ✅ Memoria se libera entre comandos

### 1.5 Prueba de Reconexión

**Objetivo**: Verificar que servidor acepta múltiples conexiones secuenciales

```bash
# Cliente 1
$ ./cliente localhost 8080
comando> ls
comando> salir

# Cliente 2 (inmediatamente después)
$ ./cliente localhost 8080
comando> pwd
comando> salir

# Cliente 3
$ ./cliente localhost 8080
comando> date
comando> salir
```

**Resultado Esperado**:
- ✅ Servidor acepta segunda conexión inmediatamente
- ✅ No hay errores "Address already in use"
- ✅ Cada sesión es independiente y funcional

---

## 2. Pruebas de Validación

### 2.1 Prueba de Comandos Prohibidos

**Objetivo**: Verificar que comandos prohibidos son rechazados

```bash
comando> cd /tmp
# Esperado: ERROR: Comando 'cd' no está soportado

comando> top
# Esperado: ERROR: Comando 'top' no está soportado

comando> htop
# Esperado: ERROR: Comando 'htop' no está soportado

comando> vim test.txt
# Esperado: ERROR: Comando 'vim' no está soportado

comando> nano test.txt
# Esperado: ERROR: Comando 'nano' no está soportado

comando> less /etc/hosts
# Esperado: ERROR: Comando 'less' no está soportado

comando> more /etc/hosts
# Esperado: ERROR: Comando 'more' no está soportado

comando> ssh usuario@host
# Esperado: ERROR: Comando 'ssh' no está soportado
```

**Resultado Esperado**:
- ✅ Todos los comandos prohibidos son rechazados
- ✅ Mensaje de error claro indicando el comando
- ✅ Cliente puede continuar ejecutando otros comandos después del error

### 2.2 Prueba de Comandos Vacíos

**Objetivo**: Verificar manejo de input vacío

```bash
comando>
# (solo presionar Enter)

comando>
# (solo espacios)

comando>
# (solo tabs)
```

**Resultado Esperado**:
- ✅ Servidor rechaza comandos vacíos
- ✅ O simplemente ignora (sin crashear)
- ✅ Mensaje de error claro

### 2.3 Prueba de Comandos con Errores

**Objetivo**: Verificar que errores de comandos se transmiten correctamente

```bash
comando> cat archivo_no_existe.txt
# Esperado: cat: archivo_no_existe.txt: No such file or directory

comando> ls /directorio/inexistente
# Esperado: ls: /directorio/inexistente: No such file or directory

comando> rm archivo_protegido
# Esperado: rm: archivo_protegido: Permission denied

comando> comando_inexistente
# Esperado: sh: comando_inexistente: command not found
```

**Resultado Esperado**:
- ✅ Errores del comando se capturan (stderr)
- ✅ Errores se transmiten al cliente
- ✅ Cliente muestra errores claramente

### 2.4 Prueba de Argumentos de Línea de Comandos

**Objetivo**: Verificar validación de argumentos CLI

#### Servidor

```bash
# Sin argumentos
$ ./servidor
# Esperado: Uso: ./servidor <puerto>

# Puerto inválido (< 1024)
$ ./servidor 80
# Esperado: Error: puerto debe estar entre 1024 y 65535

# Puerto inválido (> 65535)
$ ./servidor 70000
# Esperado: Error: puerto debe estar entre 1024 y 65535

# Puerto válido
$ ./servidor 8080
# Esperado: Servidor escuchando en puerto 8080...
```

#### Cliente

```bash
# Sin argumentos
$ ./cliente
# Esperado: Uso: ./cliente <IP> <puerto>

# Falta puerto
$ ./cliente localhost
# Esperado: Uso: ./cliente <IP> <puerto>

# Puerto inválido
$ ./cliente localhost 80
# Esperado: Error: puerto debe estar entre 1024 y 65535

# IP inválida
$ ./cliente 999.999.999.999 8080
# Esperado: Error: IP inválida '999.999.999.999'

# Argumentos válidos
$ ./cliente localhost 8080
# Esperado: Conectado al servidor localhost:8080
```

**Resultado Esperado**:
- ✅ Todos los casos de error son detectados
- ✅ Mensajes de error claros y útiles
- ✅ Ejemplos de uso mostrados

---

## 3. Pruebas de Memoria (Valgrind)

**Requisito**: Linux (valgrind no funciona nativamente en macOS)

### 3.1 Configurar Ambiente Linux

**Opción A**: Docker

```bash
# Ejecutar contenedor Linux
docker run -it --rm -v $(pwd):/proyecto ubuntu:latest bash

# Dentro del contenedor
apt-get update
apt-get install -y gcc valgrind make
cd /proyecto
make clean && make all
```

**Opción B**: VM Linux

- VirtualBox / VMware con Ubuntu o Fedora
- Copiar archivos fuente a VM
- Compilar en VM

**Opción C**: Linux físico

- Si tienes máquina Linux disponible
- Copiar archivos y compilar

### 3.2 Prueba de Valgrind - Servidor

```bash
# Compilar con debug symbols
make debug

# Ejecutar servidor con valgrind
valgrind --leak-check=full \
         --show-leak-kinds=all \
         --track-origins=yes \
         --verbose \
         --log-file=valgrind_servidor.log \
         ./servidor 8080
```

En otra terminal:

```bash
# Conectar cliente y ejecutar comandos
./cliente localhost 8080
comando> ls
comando> pwd
comando> date
comando> salir
```

Detener servidor (Ctrl+C) y revisar log:

```bash
cat valgrind_servidor.log
```

**Resultado Esperado**:

```
HEAP SUMMARY:
    in use at exit: 0 bytes in 0 blocks
  total heap usage: X allocs, X frees, Y bytes allocated

All heap blocks were freed -- no leaks are possible

ERROR SUMMARY: 0 errors from 0 contexts
```

- ✅ 0 bytes leaked
- ✅ Mismo número de allocs y frees
- ✅ 0 errors

### 3.3 Prueba de Valgrind - Cliente

```bash
# Asegurarse de que servidor esté corriendo
./servidor 8080 &

# Ejecutar cliente con valgrind
valgrind --leak-check=full \
         --show-leak-kinds=all \
         --track-origins=yes \
         --verbose \
         --log-file=valgrind_cliente.log \
         ./cliente localhost 8080
```

Ejecutar varios comandos y luego salir:

```bash
comando> ls
comando> pwd
comando> date
comando> salir
```

Revisar log:

```bash
cat valgrind_cliente.log
```

**Resultado Esperado**:
- ✅ 0 bytes leaked
- ✅ Mismo número de allocs y frees
- ✅ 0 errors

### 3.4 Prueba de Memory Leaks con Sesiones Múltiples

```bash
# Servidor con valgrind
valgrind --leak-check=full ./servidor 8080 > /dev/null 2>&1 &

# Script de prueba: 10 conexiones secuenciales
for i in {1..10}; do
    echo "ls" | ./cliente localhost 8080
    sleep 1
done

# Detener servidor
pkill -INT valgrind

# Revisar que no hay leaks acumulativos
```

**Resultado Esperado**:
- ✅ No hay incremento de memoria con múltiples sesiones
- ✅ Cada sesión libera toda su memoria

---

## 4. Pruebas Cross-Platform

### 4.1 Prueba en macOS

**Sistema**: Darwin 24.6.0 (o superior)

```bash
# Compilar
make clean && make all

# Verificar no hay warnings
# Debería compilar sin warnings con -Wall -Wextra -pedantic

# Ejecutar pruebas funcionales
./servidor 8080 &
./cliente localhost 8080
# Ejecutar comandos de prueba
```

**Resultado Esperado**:
- ✅ Compilación sin warnings
- ✅ Todas las pruebas funcionales pasan

### 4.2 Prueba en Linux

**Distribuciones a probar**: Ubuntu 20.04+, Fedora 35+, o Debian 11+

```bash
# Compilar
make clean && make all

# Verificar no hay warnings
gcc --version
# Debería ser GCC 7.0+

# Ejecutar pruebas funcionales
./servidor 8080 &
./cliente localhost 8080
# Ejecutar comandos de prueba
```

**Resultado Esperado**:
- ✅ Compilación sin warnings
- ✅ Todas las pruebas funcionales pasan
- ✅ Comportamiento idéntico a macOS

### 4.3 Comparación de Salidas

**Objetivo**: Verificar que salidas son idénticas en ambos sistemas

```bash
# En macOS
./cliente localhost 8080 << EOF > output_macos.txt
ls -la
pwd
date
whoami
salir
EOF

# En Linux
./cliente localhost 8080 << EOF > output_linux.txt
ls -la
pwd
date
whoami
salir
EOF

# Comparar (deben ser esencialmente iguales, excepto paths específicos del sistema)
diff output_macos.txt output_linux.txt
```

**Resultado Esperado**:
- ✅ Formato de salida idéntico
- ✅ Sin errores de sistema específicos de plataforma

---

## 5. Pruebas de Red Remota

### 5.1 Configuración de Entorno

**Requisitos**:
- 2 máquinas en misma red local
- Ambas con binarios compilados
- Firewall configurado para permitir puerto TCP

**Máquinas de Ejemplo**:
- **Host A (Servidor)**: MacBook Pro - IP 192.168.1.100
- **Host B (Cliente)**: Desktop Linux - IP 192.168.1.101

### 5.2 Configuración del Servidor

#### En Host A (192.168.1.100):

```bash
# 1. Verificar IP
$ ifconfig | grep "inet "
inet 192.168.1.100 netmask 0xffffff00 broadcast 192.168.1.255

# 2. Verificar firewall (macOS)
$ sudo /usr/libexec/ApplicationFirewall/socketfilterfw --getglobalstate
Firewall is enabled

# 3. Permitir puerto (si firewall está activo)
# En macOS: System Preferences > Security & Privacy > Firewall > Firewall Options
# Add ./servidor, Allow incoming connections

# 4. Iniciar servidor
$ ./servidor 8080
Servidor escuchando en puerto 8080...

Esperando conexión de cliente...
```

### 5.3 Configuración del Cliente

#### En Host B (192.168.1.101):

```bash
# 1. Verificar conectividad de red
$ ping -c 3 192.168.1.100
PING 192.168.1.100: 56 data bytes
64 bytes from 192.168.1.100: icmp_seq=0 ttl=64 time=1.234 ms
...

# 2. Verificar puerto abierto (opcional)
$ telnet 192.168.1.100 8080
Trying 192.168.1.100...
Connected to 192.168.1.100.
# Presionar Ctrl+] luego quit

# 3. Conectar cliente
$ ./cliente 192.168.1.100 8080
Conectado al servidor 192.168.1.100:8080
Escribe 'salir' o 'exit' para desconectar

comando> whoami
servidor_user

comando> hostname
servidor-macbook

comando> pwd
/Users/servidor_user/proyecto

comando> ls
cliente  servidor  src/  docs/

comando> date
Dom Nov 17 15:30:00 CST 2025

comando> ps aux | grep servidor
servidor_user  12345   0.0  0.1  ...  ./servidor 8080

comando> salir
Cerrando conexión...
Desconectado del servidor
```

### 5.4 Verificación en Servidor

#### En Host A:

```bash
Cliente conectado desde 192.168.1.101:54321
Iniciando sesión con cliente...
Comando recibido: 'whoami'
Enviando resultado (14 bytes)
Comando recibido: 'hostname'
Enviando resultado (17 bytes)
Comando recibido: 'pwd'
Enviando resultado (28 bytes)
Comando recibido: 'ls'
Enviando resultado (56 bytes)
Comando recibido: 'date'
Enviando resultado (32 bytes)
Comando recibido: 'ps aux | grep servidor'
Enviando resultado (124 bytes)
Cliente cerró la conexión
Sesión con cliente terminada
Cliente desconectado

Esperando conexión de cliente...
```

### 5.5 Captura de Screenshots

**Screenshot 1 - Prueba Local** (docs/capturas/prueba_local.png):

Contenido:
- Lado izquierdo: Terminal con `./servidor 8080`
- Lado derecho: Terminal con `./cliente localhost 8080` ejecutando comandos
- Mostrar outputs de: ls, pwd, date, ps
- Mostrar comando "salir" y desconexión limpia

**Screenshot 2 - Prueba Remota** (docs/capturas/prueba_remota.png):

Contenido:
- Lado izquierdo: Host A con servidor, mostrando IP (192.168.1.100)
- Lado derecho: Host B con cliente, conectando a IP remota
- Mostrar outputs de: whoami, hostname, pwd, ls, date
- CRÍTICO: IPs deben ser visibles en ambos lados
- Mostrar que whoami/hostname corresponden al servidor, no al cliente

### 5.6 Troubleshooting

#### Problema: Connection Refused

```bash
$ ./cliente 192.168.1.100 8080
Error conectando al servidor: Connection refused
```

**Soluciones**:
1. Verificar servidor está corriendo: `ps aux | grep servidor`
2. Verificar puerto correcto: `netstat -an | grep 8080`
3. Verificar firewall: temporalmente desactivar para probar
4. Verificar conectividad: `ping 192.168.1.100`

#### Problema: Connection Timeout

```bash
$ ./cliente 192.168.1.100 8080
[cuelga por ~30 segundos]
Error conectando al servidor: Connection timed out
```

**Soluciones**:
1. Firewall bloqueando puerto
2. Router/NAT en medio bloqueando
3. IP incorrecta (verificar con ifconfig)
4. Máquinas en redes diferentes (VPN, subnets)

#### Problema: No Route to Host

```bash
$ ./cliente 192.168.1.100 8080
Error conectando al servidor: No route to host
```

**Soluciones**:
1. Máquinas en redes completamente separadas
2. IP incorrecta
3. Host apagado o sin red

---

## 6. Pruebas de Estrés

### 6.1 Prueba de Comandos Largos

**Objetivo**: Verificar manejo de salidas muy largas

```bash
comando> find / -type f 2>/dev/null
# Puede generar miles de líneas

comando> cat /var/log/system.log
# Archivo de log grande

comando> ls -laR /usr
# Listado recursivo masivo
```

**Resultado Esperado**:
- ✅ Output se transmite hasta MAX_SALIDA_SIZE (64KB)
- ✅ Si excede, se trunca pero no crashea
- ✅ Cliente puede continuar ejecutando comandos

### 6.2 Prueba de Sesiones Largas

**Objetivo**: Verificar estabilidad en sesiones prolongadas

```bash
# Script de prueba
for i in {1..100}; do
    echo "Iteración $i"
    ./cliente localhost 8080 << EOF
ls
pwd
date
whoami
EOF
    sleep 1
done
```

**Resultado Esperado**:
- ✅ Todas las 100 conexiones exitosas
- ✅ Sin degradación de performance
- ✅ Sin memory leaks (verificar con valgrind)

### 6.3 Prueba de Comandos Rápidos Consecutivos

**Objetivo**: Verificar no hay race conditions

```bash
comando> ls
comando> pwd
comando> date
comando> whoami
comando> hostname
# (sin pausa entre comandos)
```

**Resultado Esperado**:
- ✅ Todos los comandos se ejecutan en orden
- ✅ No se pierden comandos
- ✅ No hay corrupción de datos

---

## 7. Checklist Final

### Antes de Submission

#### Código

- [ ] Compilación sin warnings con `-Wall -Wextra -pedantic`
- [ ] Todas las funciones documentadas en español
- [ ] Headers de archivo completos (autor, fecha, propósito)
- [ ] Variables y funciones en español
- [ ] Sin menciones de herramientas de IA

#### Pruebas Funcionales

- [ ] Prueba local exitosa (localhost)
- [ ] Múltiples comandos en una sesión
- [ ] Desconexión limpia con "salir"/"exit"
- [ ] Reconexión después de desconexión
- [ ] Comandos con argumentos múltiples
- [ ] Comandos con salida larga

#### Pruebas de Validación

- [ ] Todos los comandos prohibidos son rechazados
- [ ] Comandos vacíos manejados correctamente
- [ ] Errores de comandos se transmiten al cliente
- [ ] Validación de argumentos CLI funciona

#### Pruebas de Memoria (Linux)

- [ ] Valgrind servidor: 0 bytes leaked
- [ ] Valgrind cliente: 0 bytes leaked
- [ ] Sin errores de memoria inválida
- [ ] Sin memory leaks con múltiples sesiones

#### Pruebas Cross-Platform

- [ ] Compila sin warnings en macOS
- [ ] Compila sin warnings en Linux
- [ ] Funcionalidad idéntica en ambos sistemas
- [ ] Sin código específico de plataforma

#### Pruebas de Red Remota

- [ ] Conexión exitosa entre hosts diferentes
- [ ] Comandos se ejecutan en servidor remoto
- [ ] IP visible en ambos lados
- [ ] Screenshot de prueba remota capturado

#### Documentación

- [ ] README.md actualizado con instrucciones
- [ ] Screenshots capturados (local y remoto)
- [ ] PDF generado con código completo
- [ ] Archivos .c preparados para email

#### Pre-Submission Crítico

- [ ] Eliminar directorio .claude
- [ ] Eliminar directorio .specify
- [ ] Verificar sin menciones de IA en archivos
- [ ] Git commit en español primera persona
- [ ] Email preparado para envío
- [ ] Zoom session agendado

### Evidencia de Testing

Guardar logs y outputs de todas las pruebas:

```
docs/testing/
├── prueba_local.log
├── prueba_remota.log
├── valgrind_servidor.log
├── valgrind_cliente.log
├── cross_platform_macos.log
├── cross_platform_linux.log
└── stress_test.log
```

---

**Guía preparada por**: Jorge Salgado Miranda
**Fecha**: 2025-11-17
**Proyecto**: SSH-like Remote Command Executor
