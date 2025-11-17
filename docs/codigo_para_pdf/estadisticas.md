# Estadísticas del Código

## Líneas de Código

| Archivo | Líneas | Comentarios (aprox) | Código |
|---------|--------|---------------------|--------|
| cliente.c       |    188 |                  62 |    126 |
| servidor.c      |    433 |                 147 |    286 |
| common.h        |    192 |                  63 |    129 |

**Total**: 813 líneas de código fuente

## Funciones Implementadas

### servidor.c
- `es_comando_prohibido()` - Verifica comandos en lista negra
- `validar_comando()` - Valida formato y contenido de comando
- `ejecutar_comando()` - Ejecuta comando con popen() y captura output
- `enviar_error()` - Envía mensaje de error al cliente
- `crear_socket_servidor()` - Crea y configura socket TCP del servidor
- `manejar_cliente()` - Maneja sesión completa de un cliente
- `main()` - Punto de entrada del servidor

### cliente.c
- `conectar_servidor()` - Establece conexión TCP con servidor
- `main()` - Punto de entrada del cliente con loop interactivo

### common.h
- `enviar_con_longitud()` - Envía datos con prefijo de longitud
- `recibir_con_longitud()` - Recibe datos con prefijo de longitud

**Total**: 11 funciones

## Constantes Definidas

```c
#define BUFFER_SIZE 4096          // 4KB - tamaño de página estándar
#define MAX_COMANDO_SIZE 1024     // Máximo tamaño de comando
#define MAX_SALIDA_SIZE 65536     // 64KB - máximo tamaño de salida
```

## Comandos Prohibidos

```c
static const char* COMANDOS_PROHIBIDOS[] = {
    "cd", "top", "htop", "vim", "nano", "less", "more", "ssh", NULL
};
```
