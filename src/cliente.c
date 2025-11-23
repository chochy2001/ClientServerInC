/*
 * cliente.c - Cliente SSH-like para ejecutar comandos remotamente
 *
 * Autores: Jorge Salgado Miranda
 *          Joshua Ivan Lopez Nava
 * Fecha: 2025-11-17
 * Curso: Arquitectura Cliente-Servidor
 * Propósito: Implementación del cliente que se conecta al servidor,
 *            envía comandos y muestra la salida recibida
 */

#include "common.h"

/*
 * conectar_servidor - Conecta al servidor remoto
 *
 * Parámetros:
 *   ip: dirección IP del servidor (string formato "192.168.1.100" o "localhost")
 *   puerto: número de puerto del servidor
 *
 * Retorno:
 *   Descriptor del socket conectado (>= 0) en éxito
 *   -1 en error
 *
 * Descripción:
 *   Crea socket TCP, convierte IP de string a binario,
 *   y se conecta al servidor especificado.
 */
int conectar_servidor(const char *ip, int puerto)
{
    int sock;
    struct sockaddr_in direccion_servidor;

    if (strcmp(ip, "localhost") == 0)
    {
        ip = "127.0.0.1";
    }

    // Crear socket
    sock = socket(AF_INET, SOCK_STREAM, 0);
    if (sock < 0)
    {
        perror("Error creando socket");
        return -1;
    }

    // Configurar dirección del servidor
    memset(&direccion_servidor, 0, sizeof(direccion_servidor));
    direccion_servidor.sin_family = AF_INET;
    direccion_servidor.sin_port = htons((uint16_t)puerto);

    // Convertir IP de string a binario
    if (inet_pton(AF_INET, ip, &direccion_servidor.sin_addr) <= 0)
    {
        fprintf(stderr, "Error: IP inválida '%s'\n", ip);
        close(sock);
        return -1;
    }

    // Conectar al servidor
    if (connect(sock,
                (struct sockaddr *)&direccion_servidor,
                sizeof(direccion_servidor)) < 0)
    {
        perror("Error conectando al servidor");
        close(sock);
        return -1;
    }

    return sock;
}

/*
 * main - Punto de entrada del cliente
 *
 * Parámetros:
 *   argc: número de argumentos
 *   argv: array de argumentos (debe ser: ./cliente <IP> <puerto>)
 *
 * Retorno:
 *   EXIT_SUCCESS (0) en éxito
 *   EXIT_FAILURE (1) en error
 *
 * Descripción:
 *   Parsea argumentos, conecta al servidor, y entra en loop interactivo
 *   leyendo comandos del usuario, enviándolos al servidor y mostrando
 *   los resultados.
 */
int main(int argc, char *argv[])
{
    int puerto;
    int sock;
    char comando[MAX_COMANDO_SIZE];
    char *resultado = NULL;

    // Validar argumentos
    if (argc != 3)
    {
        fprintf(stderr, "Uso: %s <IP> <puerto>\n", argv[0]);
        fprintf(stderr, "Ejemplo: %s localhost 8080\n", argv[0]);
        fprintf(stderr, "Ejemplo: %s 192.168.1.100 8080\n", argv[0]);
        return EXIT_FAILURE;
    }

    const char *ip = argv[1];

    // Parsear puerto
    puerto = atoi(argv[2]);
    if (puerto < 1024 || puerto > 65535)
    {
        fprintf(stderr, "Error: puerto debe estar entre 1024 y 65535\n");
        return EXIT_FAILURE;
    }

    // Conectar al servidor
    sock = conectar_servidor(ip, puerto);
    if (sock < 0)
    {
        fprintf(stderr, "Error: no se pudo conectar al servidor %s:%d\n", ip, puerto);
        return EXIT_FAILURE;
    }

    printf("Conectado al servidor %s:%d\n", ip, puerto);
    printf("Escribe 'salir' o 'exit' para desconectar\n\n");

    // Loop interactivo
    while (1)
    {
        printf("comando> ");
        fflush(stdout);

        // Leer comando del usuario
        if (fgets(comando, sizeof(comando), stdin) == NULL)
        {
            // EOF (Ctrl+D) o error
            printf("\n");
            break;
        }

        // Remover newline del final
        comando[strcspn(comando, "\n")] = '\0';

        // Verificar si el comando está vacío
        if (strlen(comando) == 0)
        {
            continue;
        }

        // Verificar comando de salida
        if (strcmp(comando, COMANDO_SALIR) == 0 || strcmp(comando, COMANDO_EXIT) == 0)
        {
            printf("Cerrando conexión...\n");
            break;
        }

        // Enviar comando al servidor
        if (enviar_con_longitud(sock, comando, strlen(comando)) < 0)
        {
            fprintf(stderr, "Error enviando comando al servidor\n");
            break;
        }

        // Recibir resultado del servidor
        ssize_t bytes_recibidos = recibir_con_longitud(sock, &resultado);

        if (bytes_recibidos < 0)
        {
            fprintf(stderr, "Error recibiendo resultado del servidor\n");
            break;
        }

        if (bytes_recibidos == 0)
        {
            fprintf(stderr, "Servidor cerró la conexión\n");
            break;
        }

        // Verificar si es un mensaje de error
        if (strncmp(resultado, "ERROR:", 6) == 0)
        {
            // Mostrar error en stderr con color rojo (si terminal lo soporta)
            fprintf(stderr, "\033[1;31m%s\033[0m\n", resultado);
        }
        else
        {
            // Mostrar resultado normal en stdout
            printf("%s", resultado);

            // Agregar newline si el resultado no termina con uno
            if (bytes_recibidos > 0 && resultado[bytes_recibidos - 1] != '\n')
            {
                printf("\n");
            }
        }

        // Liberar memoria del resultado
        free(resultado);
        resultado = NULL;

        // Línea en blanco para separar comandos
        printf("\n");
    }

    // Cleanup final si quedó algo asignado
    if (resultado != NULL)
    {
        free(resultado);
    }

    // Cerrar conexión
    close(sock);
    printf("Desconectado del servidor\n");

    return EXIT_SUCCESS;
}
