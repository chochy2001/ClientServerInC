# Makefile

```c
     1    # Makefile para Ejecutor de Comandos Remotos SSH-like
     2    # Autor: Jorge Salgado Miranda
     3    
     4    CC = gcc
     5    CFLAGS = -Wall -Wextra -std=c99
     6    DEBUGFLAGS = -g -O0
     7    RELEASEFLAGS = -O2
     8    
     9    SRC_DIR = src
    10    CLIENTE_SRC = $(SRC_DIR)/cliente.c
    11    SERVIDOR_SRC = $(SRC_DIR)/servidor.c
    12    
    13    CLIENTE_BIN = cliente
    14    SERVIDOR_BIN = servidor
    15    
    16    .PHONY: all debug release clean help
    17    
    18    # Target por defecto: compilar cliente y servidor
    19    all: $(CLIENTE_BIN) $(SERVIDOR_BIN)
    20    
    21    # Compilar cliente
    22    $(CLIENTE_BIN): $(CLIENTE_SRC)
    23         $(CC) $(CFLAGS) -o $@ $<
    24         @echo "Cliente compilado exitosamente"
    25    
    26    # Compilar servidor
    27    $(SERVIDOR_BIN): $(SERVIDOR_SRC)
    28         $(CC) $(CFLAGS) -o $@ $<
    29         @echo "Servidor compilado exitosamente"
    30    
    31    # Compilar con símbolos de debug
    32    debug: CFLAGS += $(DEBUGFLAGS)
    33    debug: clean all
    34         @echo "Compilado en modo debug (-g -O0)"
    35    
    36    # Compilar con optimizaciones
    37    release: CFLAGS += $(RELEASEFLAGS)
    38    release: clean all
    39         @echo "Compilado en modo release (-O2)"
    40    
    41    # Limpiar binarios y archivos temporales
    42    clean:
    43         rm -f $(CLIENTE_BIN) $(SERVIDOR_BIN)
    44         rm -f *.o core gmon.out
    45         rm -rf *.dSYM
    46         @echo "Archivos limpiados"
    47    
    48    # Mostrar ayuda
    49    help:
    50         @echo "Makefile para Ejecutor de Comandos Remotos SSH-like"
    51         @echo ""
    52         @echo "Targets disponibles:"
    53         @echo "  all      - Compilar cliente y servidor (default)"
    54         @echo "  debug    - Compilar con símbolos de debug (-g)"
    55         @echo "  release  - Compilar con optimizaciones (-O2)"
    56         @echo "  clean    - Eliminar ejecutables y archivos temporales"
    57         @echo "  help     - Mostrar este mensaje"
    58         @echo ""
    59         @echo "Uso:"
    60         @echo "  make            # Compilar todo"
    61         @echo "  make clean      # Limpiar"
    62         @echo "  make debug      # Compilar para debugging"
    63         @echo "  make help       # Ver ayuda"
```
