# Código Fuente: common.h

```c
     1    /*
     2     * common.h - Definiciones compartidas entre cliente y servidor
     3     *
     4     * Autor: Jorge Salgado Miranda
     5     * Fecha: 2025-11-17
     6     * Propósito: Header con constantes, macros y funciones de utilidad
     7     *            compartidas por cliente y servidor SSH-like
     8     */
     9    
    10    #ifndef COMMON_H
    11    #define COMMON_H
    12    
    13    // Includes estándar
    14    #include <stdio.h>
    15    #include <stdlib.h>
    16    #include <string.h>
    17    #include <unistd.h>
    18    #include <sys/socket.h>
    19    #include <netinet/in.h>
    20    #include <arpa/inet.h>
    21    #include <errno.h>
    22    #include <stdint.h>
    23    
    24    // ==================== CONSTANTES ====================
    25    
    26    // Tamaños de buffer
    27    #define BUFFER_SIZE 4096                // 4KB - tamaño estándar de página
    28    #define MAX_COMANDO_SIZE 1024           // Máximo tamaño de comando
    29    #define MAX_SALIDA_SIZE 65536           // 64KB - máximo tamaño de salida
    30    
    31    // Códigos de retorno
    32    #define EXIT_SUCCESS 0
    33    #define EXIT_FAILURE 1
    34    
    35    // Comandos especiales
    36    #define COMANDO_SALIR "salir"
    37    #define COMANDO_EXIT "exit"
    38    
    39    // Prefijo de errores
    40    #define ERROR_PREFIX "ERROR: "
    41    
    42    // Network byte order
    43    #define LENGTH_FIELD_SIZE sizeof(uint32_t)
    44    
    45    // ==================== FUNCIONES DE UTILIDAD ====================
    46    
    47    /*
    48     * enviar_con_longitud - Envía datos con prefijo de longitud
    49     *
    50     * Parámetros:
    51     *   sockfd: descriptor del socket
    52     *   datos: buffer con los datos a enviar
    53     *   longitud: número de bytes a enviar
    54     *
    55     * Retorno:
    56     *   0 en éxito, -1 en error
    57     *
    58     * Descripción:
    59     *   Envía primero la longitud de los datos (4 bytes en network byte order)
    60     *   y luego los datos completos. Maneja envíos parciales con loop.
    61     */
    62    static inline int enviar_con_longitud(int sockfd, const char* datos, size_t longitud) {
    63        // Enviar longitud primero (network byte order)
    64        uint32_t longitud_red = htonl((uint32_t)longitud);
    65    
    66        ssize_t bytes_enviados = 0;
    67        ssize_t total_a_enviar = (ssize_t)sizeof(uint32_t);
    68    
    69        // Enviar longitud
    70        while (bytes_enviados < total_a_enviar) {
    71            ssize_t enviados = send(sockfd,
    72                                   ((char*)&longitud_red) + bytes_enviados,
    73                                   (size_t)(total_a_enviar - bytes_enviados),
    74                                   0);
    75            if (enviados < 0) {
    76                perror("Error enviando longitud");
    77                return -1;
    78            }
    79            bytes_enviados += enviados;
    80        }
    81    
    82        // Enviar datos
    83        bytes_enviados = 0;
    84        while (bytes_enviados < (ssize_t)longitud) {
    85            ssize_t enviados = send(sockfd,
    86                                   datos + bytes_enviados,
    87                                   longitud - bytes_enviados,
    88                                   0);
    89            if (enviados < 0) {
    90                perror("Error enviando datos");
    91                return -1;
    92            }
    93            bytes_enviados += enviados;
    94        }
    95    
    96        return 0;
    97    }
    98    
    99    /*
   100     * recibir_con_longitud - Recibe datos con prefijo de longitud
   101     *
   102     * Parámetros:
   103     *   sockfd: descriptor del socket
   104     *   buffer_salida: puntero donde se guardará la dirección del buffer asignado
   105     *
   106     * Retorno:
   107     *   Longitud de datos recibidos (>0) en éxito
   108     *   0 si el peer cerró la conexión
   109     *   -1 en error
   110     *
   111     * Descripción:
   112     *   Primero recibe la longitud (4 bytes en network byte order),
   113     *   luego asigna memoria dinámicamente y recibe los datos.
   114     *   El caller debe liberar la memoria con free().
   115     *
   116     * IMPORTANTE: El buffer retornado está null-terminated para facilitar uso como string.
   117     */
   118    static inline ssize_t recibir_con_longitud(int sockfd, char** buffer_salida) {
   119        // Recibir longitud primero
   120        uint32_t longitud_red;
   121        ssize_t bytes_recibidos = 0;
   122        ssize_t total_a_recibir = (ssize_t)sizeof(uint32_t);
   123    
   124        while (bytes_recibidos < total_a_recibir) {
   125            ssize_t recibidos = recv(sockfd,
   126                                    ((char*)&longitud_red) + bytes_recibidos,
   127                                    (size_t)(total_a_recibir - bytes_recibidos),
   128                                    0);
   129            if (recibidos < 0) {
   130                perror("Error recibiendo longitud");
   131                return -1;
   132            }
   133            if (recibidos == 0) {
   134                // Conexión cerrada por el peer
   135                return 0;
   136            }
   137            bytes_recibidos += recibidos;
   138        }
   139    
   140        // Convertir a host byte order
   141        uint32_t longitud = ntohl(longitud_red);
   142    
   143        // Validar longitud
   144        if (longitud == 0) {
   145            fprintf(stderr, "Error: longitud de mensaje es 0\n");
   146            return -1;
   147        }
   148    
   149        if (longitud > MAX_SALIDA_SIZE) {
   150            fprintf(stderr, "Error: longitud de mensaje (%u) excede máximo (%d)\n",
   151                    longitud, MAX_SALIDA_SIZE);
   152            return -1;
   153        }
   154    
   155        // Asignar memoria (+1 para null terminator)
   156        char* buffer = malloc(longitud + 1);
   157        if (buffer == NULL) {
   158            perror("Error asignando memoria");
   159            return -1;
   160        }
   161    
   162        // Recibir datos
   163        bytes_recibidos = 0;
   164        while (bytes_recibidos < longitud) {
   165            ssize_t recibidos = recv(sockfd,
   166                                    buffer + bytes_recibidos,
   167                                    longitud - bytes_recibidos,
   168                                    0);
   169            if (recibidos < 0) {
   170                perror("Error recibiendo datos");
   171                free(buffer);
   172                return -1;
   173            }
   174            if (recibidos == 0) {
   175                // Conexión cerrada antes de recibir todos los datos
   176                fprintf(stderr, "Error: conexión cerrada prematuramente\n");
   177                free(buffer);
   178                return 0;
   179            }
   180            bytes_recibidos += recibidos;
   181        }
   182    
   183        // Null-terminate el buffer
   184        buffer[longitud] = '\0';
   185    
   186        // Asignar buffer de salida
   187        *buffer_salida = buffer;
   188    
   189        return (ssize_t)longitud;
   190    }
   191    
   192    #endif // COMMON_H
```
