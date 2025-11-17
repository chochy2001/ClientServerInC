# Código Fuente: servidor.c

```c
     1    /*
     2     * servidor.c - Servidor SSH-like que ejecuta comandos remotamente
     3     *
     4     * Autor: Jorge Salgado Miranda
     5     * Fecha: 2025-11-17
     6     * Propósito: Implementación del servidor que acepta conexiones TCP,
     7     *            recibe comandos de clientes, los ejecuta localmente y
     8     *            retorna la salida completa al cliente
     9     */
    10    
    11    #include "common.h"
    12    #include <sys/wait.h>
    13    #include <ctype.h>
    14    
    15    // Lista de comandos prohibidos
    16    static const char* COMANDOS_PROHIBIDOS[] = {
    17        "cd",
    18        "top",
    19        "htop",
    20        "vim",
    21        "nano",
    22        "less",
    23        "more",
    24        "ssh",
    25        NULL  // Terminator
    26    };
    27    
    28    /*
    29     * es_comando_prohibido - Verifica si un comando está en la lista negra
    30     *
    31     * Parámetros:
    32     *   comando: string con el comando a verificar (solo el primer token)
    33     *
    34     * Retorno:
    35     *   1 si el comando está prohibido
    36     *   0 si el comando está permitido
    37     *
    38     * Descripción:
    39     *   Compara el primer token del comando contra la lista de
    40     *   comandos prohibidos.
    41     */
    42    int es_comando_prohibido(const char* comando) {
    43        for (int i = 0; COMANDOS_PROHIBIDOS[i] != NULL; i++) {
    44            if (strcmp(comando, COMANDOS_PROHIBIDOS[i]) == 0) {
    45                return 1;  // Comando prohibido
    46            }
    47        }
    48        return 0;  // Comando permitido
    49    }
    50    
    51    /*
    52     * validar_comando - Valida que el comando sea ejecutable
    53     *
    54     * Parámetros:
    55     *   comando: string con el comando completo
    56     *   mensaje_error: buffer donde se guardará el mensaje de error (si hay)
    57     *   tam_mensaje: tamaño del buffer de mensaje_error
    58     *
    59     * Retorno:
    60     *   0 si el comando es válido
    61     *   -1 si el comando es inválido
    62     *
    63     * Descripción:
    64     *   Verifica que el comando no esté vacío, no sea solo whitespace,
    65     *   y no esté en la lista de comandos prohibidos.
    66     */
    67    int validar_comando(const char* comando, char* mensaje_error, size_t tam_mensaje) {
    68        // Verificar que no esté vacío
    69        if (comando == NULL || strlen(comando) == 0) {
    70            snprintf(mensaje_error, tam_mensaje, "ERROR: Comando vacío");
    71            return -1;
    72        }
    73    
    74        // Verificar que no sea solo whitespace
    75        int solo_espacios = 1;
    76        for (size_t i = 0; i < strlen(comando); i++) {
    77            if (!isspace((unsigned char)comando[i])) {
    78                solo_espacios = 0;
    79                break;
    80            }
    81        }
    82    
    83        if (solo_espacios) {
    84            snprintf(mensaje_error, tam_mensaje, "ERROR: Comando vacío");
    85            return -1;
    86        }
    87    
    88        // Extraer primer token (nombre del comando)
    89        char comando_copia[MAX_COMANDO_SIZE];
    90        strncpy(comando_copia, comando, MAX_COMANDO_SIZE - 1);
    91        comando_copia[MAX_COMANDO_SIZE - 1] = '\0';
    92    
    93        char* primer_token = strtok(comando_copia, " \t\n");
    94        if (primer_token == NULL) {
    95            snprintf(mensaje_error, tam_mensaje, "ERROR: Comando vacío");
    96            return -1;
    97        }
    98    
    99        // Verificar si está prohibido
   100        if (es_comando_prohibido(primer_token)) {
   101            snprintf(mensaje_error, tam_mensaje,
   102                    "ERROR: Comando '%s' no está soportado", primer_token);
   103            return -1;
   104        }
   105    
   106        return 0;  // Comando válido
   107    }
   108    
   109    /*
   110     * ejecutar_comando - Ejecuta un comando del sistema y captura su salida
   111     *
   112     * Parámetros:
   113     *   comando: string con el comando a ejecutar
   114     *   salida: buffer donde se guardará la salida del comando
   115     *   tam_salida: tamaño máximo del buffer de salida
   116     *
   117     * Retorno:
   118     *   0 en éxito
   119     *   -1 en error
   120     *
   121     * Descripción:
   122     *   Usa popen() para ejecutar el comando, redirige stderr a stdout (2>&1),
   123     *   y captura toda la salida en el buffer. Limita la salida a tam_salida
   124     *   para prevenir buffer overflow.
   125     */
   126    int ejecutar_comando(const char* comando, char* salida, size_t tam_salida) {
   127        // Construir comando con redirección de stderr a stdout
   128        char comando_completo[MAX_COMANDO_SIZE + 10];
   129        snprintf(comando_completo, sizeof(comando_completo), "%s 2>&1", comando);
   130    
   131        // Abrir pipe para ejecutar comando
   132        FILE* fp = popen(comando_completo, "r");
   133        if (fp == NULL) {
   134            perror("Error ejecutando comando");
   135            snprintf(salida, tam_salida, "ERROR: No se pudo ejecutar comando");
   136            return -1;
   137        }
   138    
   139        // Leer salida del comando
   140        size_t bytes_leidos = 0;
   141        char buffer[BUFFER_SIZE];
   142    
   143        while (fgets(buffer, sizeof(buffer), fp) != NULL && bytes_leidos < tam_salida - 1) {
   144            size_t len_buffer = strlen(buffer);
   145            size_t espacio_disponible = tam_salida - bytes_leidos - 1;
   146    
   147            if (len_buffer > espacio_disponible) {
   148                // Truncar si no cabe todo
   149                strncat(salida, buffer, espacio_disponible);
   150                bytes_leidos += espacio_disponible;
   151                break;
   152            } else {
   153                strcat(salida, buffer);
   154                bytes_leidos += len_buffer;
   155            }
   156        }
   157    
   158        // Cerrar pipe y obtener código de salida
   159        int status = pclose(fp);
   160    
   161        // Si el comando no generó salida, indicarlo
   162        if (bytes_leidos == 0) {
   163            snprintf(salida, tam_salida, "(comando ejecutado sin salida)\n");
   164        }
   165    
   166        // Verificar si hubo error en la ejecución
   167        if (WIFEXITED(status)) {
   168            int exit_code = WEXITSTATUS(status);
   169            if (exit_code != 0 && bytes_leidos == 0) {
   170                // Comando falló y no produjo salida
   171                snprintf(salida, tam_salida,
   172                        "ERROR: Comando terminó con código de salida %d\n", exit_code);
   173            }
   174        }
   175    
   176        return 0;
   177    }
   178    
   179    /*
   180     * enviar_error - Envía un mensaje de error al cliente
   181     *
   182     * Parámetros:
   183     *   sock_cliente: descriptor del socket del cliente
   184     *   mensaje: mensaje de error a enviar
   185     *
   186     * Retorno:
   187     *   Ninguno (void)
   188     *
   189     * Descripción:
   190     *   Envía el mensaje de error al cliente usando el protocolo
   191     *   de longitud prefijada.
   192     */
   193    void enviar_error(int sock_cliente, const char* mensaje) {
   194        if (enviar_con_longitud(sock_cliente, mensaje, strlen(mensaje)) < 0) {
   195            fprintf(stderr, "Error enviando mensaje de error al cliente\n");
   196        }
   197    }
   198    
   199    /*
   200     * crear_socket_servidor - Crea y configura el socket del servidor
   201     *
   202     * Parámetros:
   203     *   puerto: número de puerto donde el servidor escuchará (1024-65535)
   204     *
   205     * Retorno:
   206     *   Descriptor del socket del servidor (>= 0) en éxito
   207     *   -1 en error
   208     *
   209     * Descripción:
   210     *   Crea socket TCP, configura SO_REUSEADDR, hace bind al puerto
   211     *   especificado y pone el socket en modo listen.
   212     */
   213    int crear_socket_servidor(int puerto) {
   214        int sock_servidor;
   215        struct sockaddr_in direccion_servidor;
   216        int opt = 1;
   217    
   218        // Crear socket
   219        sock_servidor = socket(AF_INET, SOCK_STREAM, 0);
   220        if (sock_servidor < 0) {
   221            perror("Error creando socket");
   222            return -1;
   223        }
   224    
   225        // Configurar SO_REUSEADDR para evitar "Address already in use"
   226        if (setsockopt(sock_servidor, SOL_SOCKET, SO_REUSEADDR,
   227                       &opt, sizeof(opt)) < 0) {
   228            perror("Error en setsockopt");
   229            close(sock_servidor);
   230            return -1;
   231        }
   232    
   233        // Configurar dirección del servidor
   234        memset(&direccion_servidor, 0, sizeof(direccion_servidor));
   235        direccion_servidor.sin_family = AF_INET;
   236        direccion_servidor.sin_addr.s_addr = INADDR_ANY;
   237        direccion_servidor.sin_port = htons((uint16_t)puerto);
   238    
   239        // Bind al puerto
   240        if (bind(sock_servidor,
   241                 (struct sockaddr*)&direccion_servidor,
   242                 sizeof(direccion_servidor)) < 0) {
   243            perror("Error en bind");
   244            close(sock_servidor);
   245            return -1;
   246        }
   247    
   248        // Listen con backlog de 5
   249        if (listen(sock_servidor, 5) < 0) {
   250            perror("Error en listen");
   251            close(sock_servidor);
   252            return -1;
   253        }
   254    
   255        return sock_servidor;
   256    }
   257    
   258    /*
   259     * manejar_cliente - Maneja la comunicación con un cliente conectado
   260     *
   261     * Parámetros:
   262     *   sock_cliente: descriptor del socket del cliente
   263     *
   264     * Retorno:
   265     *   Ninguno (void)
   266     *
   267     * Descripción:
   268     *   Loop que recibe comandos del cliente, los valida, ejecuta
   269     *   y retorna la salida. Termina cuando el cliente se desconecta
   270     *   o envía comando "salir"/"exit".
   271     */
   272    void manejar_cliente(int sock_cliente) {
   273        char* comando = NULL;
   274        char mensaje_error[256];
   275        char* salida = NULL;
   276    
   277        printf("Iniciando sesión con cliente...\n");
   278    
   279        // Loop de recepción de comandos
   280        while (1) {
   281            // Recibir comando del cliente
   282            ssize_t bytes_recibidos = recibir_con_longitud(sock_cliente, &comando);
   283    
   284            if (bytes_recibidos < 0) {
   285                fprintf(stderr, "Error recibiendo comando\n");
   286                break;
   287            }
   288    
   289            if (bytes_recibidos == 0) {
   290                printf("Cliente cerró la conexión\n");
   291                break;
   292            }
   293    
   294            printf("Comando recibido: '%s'\n", comando);
   295    
   296            // Validar comando
   297            if (validar_comando(comando, mensaje_error, sizeof(mensaje_error)) < 0) {
   298                printf("Comando inválido: %s\n", mensaje_error);
   299                enviar_error(sock_cliente, mensaje_error);
   300                free(comando);
   301                comando = NULL;
   302                continue;
   303            }
   304    
   305            // Asignar buffer para salida
   306            salida = malloc(MAX_SALIDA_SIZE);
   307            if (salida == NULL) {
   308                perror("Error asignando memoria para salida");
   309                enviar_error(sock_cliente, "ERROR: Error interno del servidor");
   310                free(comando);
   311                comando = NULL;
   312                break;
   313            }
   314    
   315            memset(salida, 0, MAX_SALIDA_SIZE);
   316    
   317            // Ejecutar comando
   318            if (ejecutar_comando(comando, salida, MAX_SALIDA_SIZE) < 0) {
   319                fprintf(stderr, "Error ejecutando comando\n");
   320                enviar_error(sock_cliente, "ERROR: Error ejecutando comando");
   321                free(comando);
   322                free(salida);
   323                comando = NULL;
   324                salida = NULL;
   325                continue;
   326            }
   327    
   328            printf("Enviando resultado (%zu bytes)\n", strlen(salida));
   329    
   330            // Enviar resultado al cliente
   331            if (enviar_con_longitud(sock_cliente, salida, strlen(salida)) < 0) {
   332                fprintf(stderr, "Error enviando resultado al cliente\n");
   333                free(comando);
   334                free(salida);
   335                comando = NULL;
   336                salida = NULL;
   337                break;
   338            }
   339    
   340            // Liberar memoria
   341            free(comando);
   342            free(salida);
   343            comando = NULL;
   344            salida = NULL;
   345        }
   346    
   347        // Cleanup final si quedó algo asignado
   348        if (comando != NULL) {
   349            free(comando);
   350        }
   351        if (salida != NULL) {
   352            free(salida);
   353        }
   354    
   355        printf("Sesión con cliente terminada\n");
   356    }
   357    
   358    /*
   359     * main - Punto de entrada del servidor
   360     *
   361     * Parámetros:
   362     *   argc: número de argumentos
   363     *   argv: array de argumentos (debe ser: ./servidor <puerto>)
   364     *
   365     * Retorno:
   366     *   EXIT_SUCCESS (0) en éxito
   367     *   EXIT_FAILURE (1) en error
   368     *
   369     * Descripción:
   370     *   Parsea argumentos de línea de comandos, crea socket del servidor,
   371     *   y entra en loop infinito aceptando conexiones de clientes.
   372     */
   373    int main(int argc, char *argv[]) {
   374        int puerto;
   375        int sock_servidor;
   376        int sock_cliente;
   377        struct sockaddr_in direccion_cliente;
   378        socklen_t longitud_cliente;
   379    
   380        // Validar argumentos
   381        if (argc != 2) {
   382            fprintf(stderr, "Uso: %s <puerto>\n", argv[0]);
   383            fprintf(stderr, "Ejemplo: %s 8080\n", argv[0]);
   384            return EXIT_FAILURE;
   385        }
   386    
   387        // Parsear puerto
   388        puerto = atoi(argv[1]);
   389        if (puerto < 1024 || puerto > 65535) {
   390            fprintf(stderr, "Error: puerto debe estar entre 1024 y 65535\n");
   391            return EXIT_FAILURE;
   392        }
   393    
   394        // Crear socket del servidor
   395        sock_servidor = crear_socket_servidor(puerto);
   396        if (sock_servidor < 0) {
   397            fprintf(stderr, "Error: no se pudo crear socket del servidor\n");
   398            return EXIT_FAILURE;
   399        }
   400    
   401        printf("Servidor escuchando en puerto %d...\n", puerto);
   402    
   403        // Loop infinito aceptando conexiones
   404        while (1) {
   405            printf("\nEsperando conexión de cliente...\n");
   406    
   407            longitud_cliente = sizeof(direccion_cliente);
   408            sock_cliente = accept(sock_servidor,
   409                                 (struct sockaddr*)&direccion_cliente,
   410                                 &longitud_cliente);
   411    
   412            if (sock_cliente < 0) {
   413                perror("Error aceptando conexión");
   414                continue;
   415            }
   416    
   417            // Log cliente conectado
   418            printf("Cliente conectado desde %s:%d\n",
   419                   inet_ntoa(direccion_cliente.sin_addr),
   420                   ntohs(direccion_cliente.sin_port));
   421    
   422            // Manejar cliente
   423            manejar_cliente(sock_cliente);
   424    
   425            // Cerrar conexión con cliente
   426            close(sock_cliente);
   427            printf("Cliente desconectado\n");
   428        }
   429    
   430        // Este código nunca se alcanza (loop infinito)
   431        close(sock_servidor);
   432        return EXIT_SUCCESS;
   433    }
```
