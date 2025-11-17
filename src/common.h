/*
 * common.h - Definiciones compartidas entre cliente y servidor
 *
 * Autores: Jorge Salgado Miranda
 *          Joshua Ivan Lopez Nava
 * Fecha: 2025-11-17
 * Curso: Arquitectura Cliente-Servidor
 * Propósito: Header con constantes, macros y funciones de utilidad
 *            compartidas por cliente y servidor SSH-like
 */

#ifndef COMMON_H
#define COMMON_H

// Includes estándar
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <errno.h>
#include <stdint.h>

// ==================== CONSTANTES ====================

// Tamaños de buffer
#define BUFFER_SIZE 4096                // 4KB - tamaño estándar de página
#define MAX_COMANDO_SIZE 1024           // Máximo tamaño de comando
#define MAX_SALIDA_SIZE 65536           // 64KB - máximo tamaño de salida

// Códigos de retorno
#define EXIT_SUCCESS 0
#define EXIT_FAILURE 1

// Comandos especiales
#define COMANDO_SALIR "salir"
#define COMANDO_EXIT "exit"

// Prefijo de errores
#define ERROR_PREFIX "ERROR: "

// Network byte order
#define LENGTH_FIELD_SIZE sizeof(uint32_t)

// ==================== FUNCIONES DE UTILIDAD ====================

/*
 * enviar_con_longitud - Envía datos con prefijo de longitud
 *
 * Parámetros:
 *   sockfd: descriptor del socket
 *   datos: buffer con los datos a enviar
 *   longitud: número de bytes a enviar
 *
 * Retorno:
 *   0 en éxito, -1 en error
 *
 * Descripción:
 *   Envía primero la longitud de los datos (4 bytes en network byte order)
 *   y luego los datos completos. Maneja envíos parciales con loop.
 */
static inline int enviar_con_longitud(int sockfd, const char* datos, size_t longitud) {
    // Enviar longitud primero (network byte order)
    uint32_t longitud_red = htonl((uint32_t)longitud);

    ssize_t bytes_enviados = 0;
    ssize_t total_a_enviar = (ssize_t)sizeof(uint32_t);

    // Enviar longitud
    while (bytes_enviados < total_a_enviar) {
        ssize_t enviados = send(sockfd,
                               ((char*)&longitud_red) + bytes_enviados,
                               (size_t)(total_a_enviar - bytes_enviados),
                               0);
        if (enviados < 0) {
            perror("Error enviando longitud");
            return -1;
        }
        bytes_enviados += enviados;
    }

    // Enviar datos
    bytes_enviados = 0;
    while (bytes_enviados < (ssize_t)longitud) {
        ssize_t enviados = send(sockfd,
                               datos + bytes_enviados,
                               longitud - bytes_enviados,
                               0);
        if (enviados < 0) {
            perror("Error enviando datos");
            return -1;
        }
        bytes_enviados += enviados;
    }

    return 0;
}

/*
 * recibir_con_longitud - Recibe datos con prefijo de longitud
 *
 * Parámetros:
 *   sockfd: descriptor del socket
 *   buffer_salida: puntero donde se guardará la dirección del buffer asignado
 *
 * Retorno:
 *   Longitud de datos recibidos (>0) en éxito
 *   0 si el peer cerró la conexión
 *   -1 en error
 *
 * Descripción:
 *   Primero recibe la longitud (4 bytes en network byte order),
 *   luego asigna memoria dinámicamente y recibe los datos.
 *   El caller debe liberar la memoria con free().
 *
 * IMPORTANTE: El buffer retornado está null-terminated para facilitar uso como string.
 */
static inline ssize_t recibir_con_longitud(int sockfd, char** buffer_salida) {
    // Recibir longitud primero
    uint32_t longitud_red;
    ssize_t bytes_recibidos = 0;
    ssize_t total_a_recibir = (ssize_t)sizeof(uint32_t);

    while (bytes_recibidos < total_a_recibir) {
        ssize_t recibidos = recv(sockfd,
                                ((char*)&longitud_red) + bytes_recibidos,
                                (size_t)(total_a_recibir - bytes_recibidos),
                                0);
        if (recibidos < 0) {
            perror("Error recibiendo longitud");
            return -1;
        }
        if (recibidos == 0) {
            // Conexión cerrada por el peer
            return 0;
        }
        bytes_recibidos += recibidos;
    }

    // Convertir a host byte order
    uint32_t longitud = ntohl(longitud_red);

    // Validar longitud
    if (longitud == 0) {
        fprintf(stderr, "Error: longitud de mensaje es 0\n");
        return -1;
    }

    if (longitud > MAX_SALIDA_SIZE) {
        fprintf(stderr, "Error: longitud de mensaje (%u) excede máximo (%d)\n",
                longitud, MAX_SALIDA_SIZE);
        return -1;
    }

    // Asignar memoria (+1 para null terminator)
    char* buffer = malloc(longitud + 1);
    if (buffer == NULL) {
        perror("Error asignando memoria");
        return -1;
    }

    // Recibir datos
    bytes_recibidos = 0;
    while (bytes_recibidos < longitud) {
        ssize_t recibidos = recv(sockfd,
                                buffer + bytes_recibidos,
                                longitud - bytes_recibidos,
                                0);
        if (recibidos < 0) {
            perror("Error recibiendo datos");
            free(buffer);
            return -1;
        }
        if (recibidos == 0) {
            // Conexión cerrada antes de recibir todos los datos
            fprintf(stderr, "Error: conexión cerrada prematuramente\n");
            free(buffer);
            return 0;
        }
        bytes_recibidos += recibidos;
    }

    // Null-terminate el buffer
    buffer[longitud] = '\0';

    // Asignar buffer de salida
    *buffer_salida = buffer;

    return (ssize_t)longitud;
}

#endif // COMMON_H
