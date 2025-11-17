# Código Fuente: cliente.c

```c
     1    /*
     2     * cliente.c - Cliente SSH-like para ejecutar comandos remotamente
     3     *
     4     * Autor: Jorge Salgado Miranda
     5     * Fecha: 2025-11-17
     6     * Propósito: Implementación del cliente que se conecta al servidor,
     7     *            envía comandos y muestra la salida recibida
     8     */
     9    
    10    #include "common.h"
    11    
    12    /*
    13     * conectar_servidor - Conecta al servidor remoto
    14     *
    15     * Parámetros:
    16     *   ip: dirección IP del servidor (string formato "192.168.1.100" o "localhost")
    17     *   puerto: número de puerto del servidor
    18     *
    19     * Retorno:
    20     *   Descriptor del socket conectado (>= 0) en éxito
    21     *   -1 en error
    22     *
    23     * Descripción:
    24     *   Crea socket TCP, convierte IP de string a binario,
    25     *   y se conecta al servidor especificado.
    26     */
    27    int conectar_servidor(const char* ip, int puerto) {
    28        int sock;
    29        struct sockaddr_in direccion_servidor;
    30    
    31        // Crear socket
    32        sock = socket(AF_INET, SOCK_STREAM, 0);
    33        if (sock < 0) {
    34            perror("Error creando socket");
    35            return -1;
    36        }
    37    
    38        // Configurar dirección del servidor
    39        memset(&direccion_servidor, 0, sizeof(direccion_servidor));
    40        direccion_servidor.sin_family = AF_INET;
    41        direccion_servidor.sin_port = htons((uint16_t)puerto);
    42    
    43        // Convertir IP de string a binario
    44        if (inet_pton(AF_INET, ip, &direccion_servidor.sin_addr) <= 0) {
    45            fprintf(stderr, "Error: IP inválida '%s'\n", ip);
    46            close(sock);
    47            return -1;
    48        }
    49    
    50        // Conectar al servidor
    51        if (connect(sock,
    52                    (struct sockaddr*)&direccion_servidor,
    53                    sizeof(direccion_servidor)) < 0) {
    54            perror("Error conectando al servidor");
    55            close(sock);
    56            return -1;
    57        }
    58    
    59        return sock;
    60    }
    61    
    62    /*
    63     * main - Punto de entrada del cliente
    64     *
    65     * Parámetros:
    66     *   argc: número de argumentos
    67     *   argv: array de argumentos (debe ser: ./cliente <IP> <puerto>)
    68     *
    69     * Retorno:
    70     *   EXIT_SUCCESS (0) en éxito
    71     *   EXIT_FAILURE (1) en error
    72     *
    73     * Descripción:
    74     *   Parsea argumentos, conecta al servidor, y entra en loop interactivo
    75     *   leyendo comandos del usuario, enviándolos al servidor y mostrando
    76     *   los resultados.
    77     */
    78    int main(int argc, char *argv[]) {
    79        int puerto;
    80        int sock;
    81        char comando[MAX_COMANDO_SIZE];
    82        char* resultado = NULL;
    83    
    84        // Validar argumentos
    85        if (argc != 3) {
    86            fprintf(stderr, "Uso: %s <IP> <puerto>\n", argv[0]);
    87            fprintf(stderr, "Ejemplo: %s localhost 8080\n", argv[0]);
    88            fprintf(stderr, "Ejemplo: %s 192.168.1.100 8080\n", argv[0]);
    89            return EXIT_FAILURE;
    90        }
    91    
    92        const char* ip = argv[1];
    93    
    94        // Parsear puerto
    95        puerto = atoi(argv[2]);
    96        if (puerto < 1024 || puerto > 65535) {
    97            fprintf(stderr, "Error: puerto debe estar entre 1024 y 65535\n");
    98            return EXIT_FAILURE;
    99        }
   100    
   101        // Conectar al servidor
   102        sock = conectar_servidor(ip, puerto);
   103        if (sock < 0) {
   104            fprintf(stderr, "Error: no se pudo conectar al servidor %s:%d\n", ip, puerto);
   105            return EXIT_FAILURE;
   106        }
   107    
   108        printf("Conectado al servidor %s:%d\n", ip, puerto);
   109        printf("Escribe 'salir' o 'exit' para desconectar\n\n");
   110    
   111        // Loop interactivo
   112        while (1) {
   113            printf("comando> ");
   114            fflush(stdout);
   115    
   116            // Leer comando del usuario
   117            if (fgets(comando, sizeof(comando), stdin) == NULL) {
   118                // EOF (Ctrl+D) o error
   119                printf("\n");
   120                break;
   121            }
   122    
   123            // Remover newline del final
   124            comando[strcspn(comando, "\n")] = '\0';
   125    
   126            // Verificar si el comando está vacío
   127            if (strlen(comando) == 0) {
   128                continue;
   129            }
   130    
   131            // Verificar comando de salida
   132            if (strcmp(comando, COMANDO_SALIR) == 0 || strcmp(comando, COMANDO_EXIT) == 0) {
   133                printf("Cerrando conexión...\n");
   134                break;
   135            }
   136    
   137            // Enviar comando al servidor
   138            if (enviar_con_longitud(sock, comando, strlen(comando)) < 0) {
   139                fprintf(stderr, "Error enviando comando al servidor\n");
   140                break;
   141            }
   142    
   143            // Recibir resultado del servidor
   144            ssize_t bytes_recibidos = recibir_con_longitud(sock, &resultado);
   145    
   146            if (bytes_recibidos < 0) {
   147                fprintf(stderr, "Error recibiendo resultado del servidor\n");
   148                break;
   149            }
   150    
   151            if (bytes_recibidos == 0) {
   152                fprintf(stderr, "Servidor cerró la conexión\n");
   153                break;
   154            }
   155    
   156            // Verificar si es un mensaje de error
   157            if (strncmp(resultado, "ERROR:", 6) == 0) {
   158                // Mostrar error en stderr con color rojo (si terminal lo soporta)
   159                fprintf(stderr, "\033[1;31m%s\033[0m\n", resultado);
   160            } else {
   161                // Mostrar resultado normal en stdout
   162                printf("%s", resultado);
   163    
   164                // Agregar newline si el resultado no termina con uno
   165                if (bytes_recibidos > 0 && resultado[bytes_recibidos - 1] != '\n') {
   166                    printf("\n");
   167                }
   168            }
   169    
   170            // Liberar memoria del resultado
   171            free(resultado);
   172            resultado = NULL;
   173    
   174            // Línea en blanco para separar comandos
   175            printf("\n");
   176        }
   177    
   178        // Cleanup final si quedó algo asignado
   179        if (resultado != NULL) {
   180            free(resultado);
   181        }
   182    
   183        // Cerrar conexión
   184        close(sock);
   185        printf("Desconectado del servidor\n");
   186    
   187        return EXIT_SUCCESS;
   188    }
```
