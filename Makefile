# Makefile para Ejecutor de Comandos Remotos SSH-like
# Autor: Jorge Salgado Miranda

CC = gcc
CFLAGS = -Wall -Wextra -std=c99
DEBUGFLAGS = -g -O0
RELEASEFLAGS = -O2

SRC_DIR = src
CLIENTE_SRC = $(SRC_DIR)/cliente.c
SERVIDOR_SRC = $(SRC_DIR)/servidor.c

CLIENTE_BIN = cliente
SERVIDOR_BIN = servidor

.PHONY: all debug release clean help

# Target por defecto: compilar cliente y servidor
all: $(CLIENTE_BIN) $(SERVIDOR_BIN)

# Compilar cliente
$(CLIENTE_BIN): $(CLIENTE_SRC)
	$(CC) $(CFLAGS) -o $@ $<
	@echo "Cliente compilado exitosamente"

# Compilar servidor
$(SERVIDOR_BIN): $(SERVIDOR_SRC)
	$(CC) $(CFLAGS) -o $@ $<
	@echo "Servidor compilado exitosamente"

# Compilar con símbolos de debug
debug: CFLAGS += $(DEBUGFLAGS)
debug: clean all
	@echo "Compilado en modo debug (-g -O0)"

# Compilar con optimizaciones
release: CFLAGS += $(RELEASEFLAGS)
release: clean all
	@echo "Compilado en modo release (-O2)"

# Limpiar binarios y archivos temporales
clean:
	rm -f $(CLIENTE_BIN) $(SERVIDOR_BIN)
	rm -f *.o core gmon.out
	rm -rf *.dSYM
	@echo "Archivos limpiados"

# Mostrar ayuda
help:
	@echo "Makefile para Ejecutor de Comandos Remotos SSH-like"
	@echo ""
	@echo "Targets disponibles:"
	@echo "  all      - Compilar cliente y servidor (default)"
	@echo "  debug    - Compilar con símbolos de debug (-g)"
	@echo "  release  - Compilar con optimizaciones (-O2)"
	@echo "  clean    - Eliminar ejecutables y archivos temporales"
	@echo "  help     - Mostrar este mensaje"
	@echo ""
	@echo "Uso:"
	@echo "  make            # Compilar todo"
	@echo "  make clean      # Limpiar"
	@echo "  make debug      # Compilar para debugging"
	@echo "  make help       # Ver ayuda"
