# Ejecutor de Comandos Remotos SSH-like

Sistema cliente-servidor en C que permite ejecutar comandos Unix remotamente mediante sockets TCP/IP.

## 📊 Estado del Proyecto

**Progreso**: 70% Completado
**Deadline**: Martes, Diciembre 9, 2025

- ✅ Implementación Core (100%)
- ✅ Validación de Código (100%)
- ⏳ Testing y Screenshots (Pendiente)
- ⏳ Generación de PDF (Pendiente)
- ⏳ Entregables (Pendiente)

## 🚀 Quick Start

```bash
# 1. Compilar
make clean && make all

# 2. Ejecutar servidor (Terminal 1)
./servidor 8080

# 3. Ejecutar cliente (Terminal 2)
./cliente localhost 8080

# 4. Probar comandos
comando> ls -la
comando> pwd
comando> salir
```

## 📚 Documentación Completa

### 🎯 Documentos Principales (Empieza aquí)
- **[CUMPLIMIENTO_REQUISITOS_PROFESOR.md](CUMPLIMIENTO_REQUISITOS_PROFESOR.md)** 📋 - Análisis vs requisitos del profesor
- **[RESUMEN_VISUAL_FALTANTE.md](RESUMEN_VISUAL_FALTANTE.md)** 🔥 - Vista rápida de lo que falta
- **[ANALISIS_ULTRATHINK_FALTANTE.md](ANALISIS_ULTRATHINK_FALTANTE.md)** 🧠 - Análisis exhaustivo completo
- **[ESTADO_ACTUAL.md](ESTADO_ACTUAL.md)** 📊 - Estado actual y próximos pasos
- **[CHECKLIST_ENTREGA.md](CHECKLIST_ENTREGA.md)** ✅ - Checklist interactivo día a día

### 📖 Guías y Manuales
- **[docs/GUIA_PASO_A_PASO_ENTREGA.md](docs/GUIA_PASO_A_PASO_ENTREGA.md)** - Guía completa de entrega
- **[docs/GUIA_TESTING.md](docs/GUIA_TESTING.md)** - Manual de pruebas
- **[docs/PLANTILLA_INFORME_PDF.md](docs/PLANTILLA_INFORME_PDF.md)** - Template para PDF
- **[docs/INDICE_DOCUMENTACION.md](docs/INDICE_DOCUMENTACION.md)** - Índice maestro de docs
- **[docs/RESUMEN_PROYECTO.md](docs/RESUMEN_PROYECTO.md)** - Estado y arquitectura
- **[scripts/README.md](scripts/README.md)** - Scripts de automatización

## 🧪 Testing Automatizado

```bash
# Ejecutar suite de tests
./scripts/test_automatico.sh

# Validación completa pre-entrega
./scripts/validacion_pre_entrega.sh
```

## Autor

Jorge Salgado Miranda

## Descripción

Proyecto académico que implementa un sistema similar a SSH usando sockets TCP en C. El cliente envía comandos al servidor, quien los ejecuta localmente y retorna la salida completa (stdout + stderr) al cliente.

## Compilación

### Compilar todo
```bash
make all
```

### Compilar individualmente
```bash
# Servidor
gcc -Wall -Wextra -std=c99 -o servidor src/servidor.c

# Cliente
gcc -Wall -Wextra -std=c99 -o cliente src/cliente.c
```

### Limpiar binarios
```bash
make clean
```

## Uso

### Servidor
```bash
./servidor <puerto>
```

Ejemplo:
```bash
./servidor 8080
```

### Cliente
```bash
./cliente <IP> <puerto>
```

Ejemplos:
```bash
# Conexión local
./cliente localhost 8080

# Conexión remota
./cliente 192.168.1.100 8080
```

## Comandos Disponibles

Comandos soportados:
- `ls`, `ls -la` - Listar archivos
- `pwd` - Directorio actual
- `ps`, `ps aux` - Procesos
- `date` - Fecha y hora
- `whoami` - Usuario actual
- `cat <archivo>` - Mostrar contenido de archivo
- Y cualquier otro comando estándar de Unix

Comandos prohibidos:
- `cd` - No soportado (no cambia directorio)
- `top`, `htop` - Comandos dinámicos no soportados
- `vim`, `nano`, `less`, `more` - Comandos interactivos no soportados

Para salir:
- `salir` o `exit` - Cierra la conexión limpiamente

## Requisitos

- Sistema operativo: Linux o MacOS
- Compilador: GCC 4.8+ o Clang
- Estándar: C99

## Testing

### Verificar memory leaks (Linux only)
```bash
valgrind --leak-check=full ./servidor 8080
valgrind --leak-check=full ./cliente localhost 8080
```

### Prueba local
Terminal 1:
```bash
./servidor 8080
```

Terminal 2:
```bash
./cliente localhost 8080
comando> ls -la
comando> pwd
comando> date
comando> salir
```

### Prueba remota
En máquina servidor (ej: 192.168.1.100):
```bash
./servidor 8080
```

En máquina cliente:
```bash
./cliente 192.168.1.100 8080
```

## Estructura del Proyecto

```
.
├── src/
│   ├── cliente.c       # Implementación del cliente
│   ├── servidor.c      # Implementación del servidor
│   └── common.h        # Definiciones compartidas
├── docs/
│   ├── informe.pdf     # Documento final con código y screenshots
│   └── capturas/       # Screenshots de pruebas
├── Makefile            # Build automation
├── README.md           # Este archivo
└── .gitignore          # Excluye binarios de git
```

## Licencia

Proyecto académico para el curso de Arquitectura Cliente-Servidor.
