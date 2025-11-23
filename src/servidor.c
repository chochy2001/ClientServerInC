/*
 * servidor.c - Servidor SSH-like que ejecuta comandos remotamente
 *
 * Autores: Jorge Salgado Miranda
 *          Joshua Ivan Lopez Nava
 * Fecha: 2025-11-17
 * Curso: Arquitectura Cliente-Servidor
 * Propósito: Implementación del servidor que acepta conexiones TCP,
 *            recibe comandos de clientes, los ejecuta localmente y
 *            retorna la salida completa al cliente
 */

#include "common.h"
#include <sys/wait.h>
#include <ctype.h>

// Lista de comandos prohibidos
static const char *COMANDOS_PROHIBIDOS[] = {
    "cd",
    "top",
    "htop",
    "vim",
    "nano",
    "less",
    "more",
    "ssh",
    NULL // Terminator
};

/*
 * es_comando_prohibido - Verifica si un comando está en la lista negra
 *
 * Parámetros:
 *   comando: string con el comando a verificar (solo el primer token)
 *
 * Retorno:
 *   1 si el comando está prohibido
 *   0 si el comando está permitido
 *
 * Descripción:
 *   Compara el primer token del comando contra la lista de
 *   comandos prohibidos.
 */
int es_comando_prohibido(const char *comando)
{
    for (int i = 0; COMANDOS_PROHIBIDOS[i] != NULL; i++)
    {
        if (strcmp(comando, COMANDOS_PROHIBIDOS[i]) == 0)
        {
            return 1; // Comando prohibido
        }
    }
    return 0; // Comando permitido
}

/*
 * validar_comando - Valida que el comando sea ejecutable
 *
 * Parámetros:
 *   comando: string con el comando completo
 *   mensaje_error: buffer donde se guardará el mensaje de error (si hay)
 *   tam_mensaje: tamaño del buffer de mensaje_error
 *
 * Retorno:
 *   0 si el comando es válido
 *   -1 si el comando es inválido
 *
 * Descripción:
 *   Verifica que el comando no esté vacío, no sea solo whitespace,
 *   y no esté en la lista de comandos prohibidos.
 */
int validar_comando(const char *comando, char *mensaje_error, size_t tam_mensaje)
{
    // 1. Verificar que no esté vacío
    if (comando == NULL || strlen(comando) == 0)
    {
        snprintf(mensaje_error, tam_mensaje, "ERROR: Comando vacío");
        return -1;
    }

    // 2. Verificar que no sea solo whitespace
    int solo_espacios = 1;
    for (size_t i = 0; i < strlen(comando); i++)
    {
        if (!isspace((unsigned char)comando[i]))
        {
            solo_espacios = 0;
            break;
        }
    }

    if (solo_espacios)
    {
        snprintf(mensaje_error, tam_mensaje, "ERROR: Comando vacío");
        return -1;
    }

    // 3. Extraer primer token
    char comando_copia[MAX_COMANDO_SIZE];
    strncpy(comando_copia, comando, MAX_COMANDO_SIZE - 1);
    comando_copia[MAX_COMANDO_SIZE - 1] = '\0';

    char *primer_token = strtok(comando_copia, " \t\n");
    if (primer_token == NULL)
    {
        snprintf(mensaje_error, tam_mensaje, "ERROR: Comando vacío");
        return -1;
    }

    // Verifica si empieza con "./" O si contiene "../" en cualquier parte
    if (strncmp(primer_token, "./", 2) == 0 || strstr(primer_token, "../") != NULL)
    {
        snprintf(mensaje_error, tam_mensaje,
                 "ERROR: No se permite ejecución de rutas relativas o scripts locales");
        return -1;
    }

    // 4. Verificar si está en la lista de prohibidos
    if (es_comando_prohibido(primer_token))
    {
        snprintf(mensaje_error, tam_mensaje,
                 "ERROR: Comando '%s' no está soportado", primer_token);
        return -1;
    }

    return 0;
}

/*
 * ejecutar_comando - Ejecuta un comando del sistema y captura su salida
 *
 * Parámetros:
 *   comando: string con el comando a ejecutar
 *   salida: buffer donde se guardará la salida del comando
 *   tam_salida: tamaño máximo del buffer de salida
 *
 * Retorno:
 *   0 en éxito
 *   -1 en error
 *
 * Descripción:
 *   Usa popen() para ejecutar el comando, redirige stderr a stdout (2>&1),
 *   y captura toda la salida en el buffer. Limita la salida a tam_salida
 *   para prevenir buffer overflow.
 */
int ejecutar_comando(const char *comando, char *salida, size_t tam_salida)
{
    // Construir comando con redirección de stderr a stdout
    char comando_completo[MAX_COMANDO_SIZE + 10];
    snprintf(comando_completo, sizeof(comando_completo), "%s 2>&1", comando);

    // Abrir pipe para ejecutar comando
    FILE *fp = popen(comando_completo, "r");
    if (fp == NULL)
    {
        perror("Error ejecutando comando");
        snprintf(salida, tam_salida, "ERROR: No se pudo ejecutar comando");
        return -1;
    }

    // Leer salida del comando
    size_t bytes_leidos = 0;
    char buffer[BUFFER_SIZE];

    while (fgets(buffer, sizeof(buffer), fp) != NULL && bytes_leidos < tam_salida - 1)
    {
        size_t len_buffer = strlen(buffer);
        size_t espacio_disponible = tam_salida - bytes_leidos - 1;

        if (len_buffer > espacio_disponible)
        {
            // Truncar si no cabe todo
            strncat(salida, buffer, espacio_disponible);
            bytes_leidos += espacio_disponible;
            break;
        }
        else
        {
            strcat(salida, buffer);
            bytes_leidos += len_buffer;
        }
    }

    // Cerrar pipe y obtener código de salida
    int status = pclose(fp);

    // Si el comando no generó salida, indicarlo
    if (bytes_leidos == 0)
    {
        snprintf(salida, tam_salida, "(comando ejecutado sin salida)\n");
    }

    // Verificar si hubo error en la ejecución
    if (WIFEXITED(status))
    {
        int exit_code = WEXITSTATUS(status);
        if (exit_code != 0 && bytes_leidos == 0)
        {
            // Comando falló y no produjo salida
            snprintf(salida, tam_salida,
                     "ERROR: Comando terminó con código de salida %d\n", exit_code);
        }
    }

    return 0;
}

/*
 * enviar_error - Envía un mensaje de error al cliente
 *
 * Parámetros:
 *   sock_cliente: descriptor del socket del cliente
 *   mensaje: mensaje de error a enviar
 *
 * Retorno:
 *   Ninguno (void)
 *
 * Descripción:
 *   Envía el mensaje de error al cliente usando el protocolo
 *   de longitud prefijada.
 */
void enviar_error(int sock_cliente, const char *mensaje)
{
    if (enviar_con_longitud(sock_cliente, mensaje, strlen(mensaje)) < 0)
    {
        fprintf(stderr, "Error enviando mensaje de error al cliente\n");
    }
}

/*
 * crear_socket_servidor - Crea y configura el socket del servidor
 *
 * Parámetros:
 *   puerto: número de puerto donde el servidor escuchará (1024-65535)
 *
 * Retorno:
 *   Descriptor del socket del servidor (>= 0) en éxito
 *   -1 en error
 *
 * Descripción:
 *   Crea socket TCP, configura SO_REUSEADDR, hace bind al puerto
 *   especificado y pone el socket en modo listen.
 */
int crear_socket_servidor(int puerto)
{
    int sock_servidor;
    struct sockaddr_in direccion_servidor;
    int opt = 1;

    // Crear socket
    sock_servidor = socket(AF_INET, SOCK_STREAM, 0);
    if (sock_servidor < 0)
    {
        perror("Error creando socket");
        return -1;
    }

    // Configurar SO_REUSEADDR para evitar "Address already in use"
    if (setsockopt(sock_servidor, SOL_SOCKET, SO_REUSEADDR,
                   &opt, sizeof(opt)) < 0)
    {
        perror("Error en setsockopt");
        close(sock_servidor);
        return -1;
    }

    // Configurar dirección del servidor
    memset(&direccion_servidor, 0, sizeof(direccion_servidor));
    direccion_servidor.sin_family = AF_INET;
    direccion_servidor.sin_addr.s_addr = INADDR_ANY;
    direccion_servidor.sin_port = htons((uint16_t)puerto);

    // Bind al puerto
    if (bind(sock_servidor,
             (struct sockaddr *)&direccion_servidor,
             sizeof(direccion_servidor)) < 0)
    {
        perror("Error en bind");
        close(sock_servidor);
        return -1;
    }

    // Listen con backlog de 5
    if (listen(sock_servidor, 5) < 0)
    {
        perror("Error en listen");
        close(sock_servidor);
        return -1;
    }

    return sock_servidor;
}

/*
 * manejar_cliente - Maneja la comunicación con un cliente conectado
 *
 * Parámetros:
 *   sock_cliente: descriptor del socket del cliente
 *
 * Retorno:
 *   Ninguno (void)
 *
 * Descripción:
 *   Loop que recibe comandos del cliente, los valida, ejecuta
 *   y retorna la salida. Termina cuando el cliente se desconecta
 *   o envía comando "salir"/"exit".
 */
void manejar_cliente(int sock_cliente)
{
    char *comando = NULL;
    char mensaje_error[256];
    char *salida = NULL;

    printf("Iniciando sesión con cliente...\n");

    // Loop de recepción de comandos
    while (1)
    {
        // Recibir comando del cliente
        ssize_t bytes_recibidos = recibir_con_longitud(sock_cliente, &comando);

        if (bytes_recibidos < 0)
        {
            fprintf(stderr, "Error recibiendo comando\n");
            break;
        }

        if (bytes_recibidos == 0)
        {
            printf("Cliente cerró la conexión\n");
            break;
        }

        printf("Comando recibido: '%s'\n", comando);

        // Validar comando
        if (validar_comando(comando, mensaje_error, sizeof(mensaje_error)) < 0)
        {
            printf("Comando inválido: %s\n", mensaje_error);
            enviar_error(sock_cliente, mensaje_error);
            free(comando);
            comando = NULL;
            continue;
        }

        // Asignar buffer para salida
        salida = malloc(MAX_SALIDA_SIZE);
        if (salida == NULL)
        {
            perror("Error asignando memoria para salida");
            enviar_error(sock_cliente, "ERROR: Error interno del servidor");
            free(comando);
            comando = NULL;
            break;
        }

        memset(salida, 0, MAX_SALIDA_SIZE);

        // Ejecutar comando
        if (ejecutar_comando(comando, salida, MAX_SALIDA_SIZE) < 0)
        {
            fprintf(stderr, "Error ejecutando comando\n");
            enviar_error(sock_cliente, "ERROR: Error ejecutando comando");
            free(comando);
            free(salida);
            comando = NULL;
            salida = NULL;
            continue;
        }

        printf("Enviando resultado (%zu bytes)\n", strlen(salida));

        // Enviar resultado al cliente
        if (enviar_con_longitud(sock_cliente, salida, strlen(salida)) < 0)
        {
            fprintf(stderr, "Error enviando resultado al cliente\n");
            free(comando);
            free(salida);
            comando = NULL;
            salida = NULL;
            break;
        }

        // Liberar memoria
        free(comando);
        free(salida);
        comando = NULL;
        salida = NULL;
    }

    // Cleanup final si quedó algo asignado
    if (comando != NULL)
    {
        free(comando);
    }
    if (salida != NULL)
    {
        free(salida);
    }

    printf("Sesión con cliente terminada\n");
}

/*
 * main - Punto de entrada del servidor
 *
 * Parámetros:
 *   argc: número de argumentos
 *   argv: array de argumentos (debe ser: ./servidor <puerto>)
 *
 * Retorno:
 *   EXIT_SUCCESS (0) en éxito
 *   EXIT_FAILURE (1) en error
 *
 * Descripción:
 *   Parsea argumentos de línea de comandos, crea socket del servidor,
 *   y entra en loop infinito aceptando conexiones de clientes.
 */
int main(int argc, char *argv[])
{
    int puerto;
    int sock_servidor;
    int sock_cliente;
    struct sockaddr_in direccion_cliente;
    socklen_t longitud_cliente;

    // Validar argumentos
    if (argc != 2)
    {
        fprintf(stderr, "Uso: %s <puerto>\n", argv[0]);
        fprintf(stderr, "Ejemplo: %s 8080\n", argv[0]);
        return EXIT_FAILURE;
    }

    // Parsear puerto
    puerto = atoi(argv[1]);
    if (puerto < 1024 || puerto > 65535)
    {
        fprintf(stderr, "Error: puerto debe estar entre 1024 y 65535\n");
        return EXIT_FAILURE;
    }

    // Crear socket del servidor
    sock_servidor = crear_socket_servidor(puerto);
    if (sock_servidor < 0)
    {
        fprintf(stderr, "Error: no se pudo crear socket del servidor\n");
        return EXIT_FAILURE;
    }

    printf("Servidor escuchando en puerto %d...\n", puerto);

    // Loop infinito aceptando conexiones
    while (1)
    {
        printf("\nEsperando conexión de cliente...\n");

        longitud_cliente = sizeof(direccion_cliente);
        sock_cliente = accept(sock_servidor,
                              (struct sockaddr *)&direccion_cliente,
                              &longitud_cliente);

        if (sock_cliente < 0)
        {
            perror("Error aceptando conexión");
            continue;
        }

        // Log cliente conectado
        printf("Cliente conectado desde %s:%d\n",
               inet_ntoa(direccion_cliente.sin_addr),
               ntohs(direccion_cliente.sin_port));

        // Manejar cliente
        manejar_cliente(sock_cliente);

        // Cerrar conexión con cliente
        close(sock_cliente);
        printf("Cliente desconectado\n");
    }

    // Este código nunca se alcanza (loop infinito)
    close(sock_servidor);
    return EXIT_SUCCESS;
}
