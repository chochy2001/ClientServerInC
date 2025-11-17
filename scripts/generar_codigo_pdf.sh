#!/bin/bash

# generar_codigo_pdf.sh - Genera archivos de código con números de línea para PDF
# Autor: Jorge Salgado Miranda
# Fecha: 2025-11-17
# Propósito: Preparar código fuente formateado con números de línea para inclusión en PDF

# Colores
BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

OUTPUT_DIR="docs/codigo_para_pdf"

echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}  Generador de Código para PDF${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
echo ""

# Crear directorio de output
mkdir -p "$OUTPUT_DIR"
echo -e "${YELLOW}[INFO]${NC} Creando directorio: $OUTPUT_DIR"
echo ""

# Función para generar archivo con números de línea
generate_numbered() {
    local input_file="$1"
    local output_file="$2"
    local title="$3"

    echo -e "${BLUE}[Procesando]${NC} $input_file"

    # Crear header
    cat > "$output_file" <<EOF
# $title

\`\`\`c
EOF

    # Agregar código con números de línea
    cat -n "$input_file" | expand -t 5 >> "$output_file"

    # Cerrar bloque de código
    echo '```' >> "$output_file"

    # Contar líneas
    local line_count=$(wc -l < "$input_file" | tr -d ' ')
    echo -e "  ${GREEN}✓${NC} Generado: $output_file ($line_count líneas)"
}

# Generar archivos
echo -e "${BLUE}Generando archivos numerados...${NC}"
echo ""

generate_numbered "src/cliente.c" "$OUTPUT_DIR/cliente_numerado.md" "Código Fuente: cliente.c"
generate_numbered "src/servidor.c" "$OUTPUT_DIR/servidor_numerado.md" "Código Fuente: servidor.c"
generate_numbered "src/common.h" "$OUTPUT_DIR/common_numerado.md" "Código Fuente: common.h"
generate_numbered "Makefile" "$OUTPUT_DIR/makefile_numerado.md" "Makefile"

echo ""
echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}  Generando estadísticas de código${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
echo ""

# Generar estadísticas
cat > "$OUTPUT_DIR/estadisticas.md" <<EOF
# Estadísticas del Código

## Líneas de Código

| Archivo | Líneas | Comentarios (aprox) | Código |
|---------|--------|---------------------|--------|
EOF

for file in src/cliente.c src/servidor.c src/common.h; do
    total_lines=$(wc -l < "$file" | tr -d ' ')
    comment_lines=$(grep -c "^\s*\(//\|/\*\|\*\)" "$file" || echo 0)
    code_lines=$((total_lines - comment_lines))

    basename=$(basename "$file")
    printf "| %-15s | %6s | %19s | %6s |\n" "$basename" "$total_lines" "$comment_lines" "$code_lines" >> "$OUTPUT_DIR/estadisticas.md"
done

# Agregar totales
total_all=$(cat src/*.c src/*.h | wc -l | tr -d ' ')
cat >> "$OUTPUT_DIR/estadisticas.md" <<EOF

**Total**: $total_all líneas de código fuente

## Funciones Implementadas

### servidor.c
- \`es_comando_prohibido()\` - Verifica comandos en lista negra
- \`validar_comando()\` - Valida formato y contenido de comando
- \`ejecutar_comando()\` - Ejecuta comando con popen() y captura output
- \`enviar_error()\` - Envía mensaje de error al cliente
- \`crear_socket_servidor()\` - Crea y configura socket TCP del servidor
- \`manejar_cliente()\` - Maneja sesión completa de un cliente
- \`main()\` - Punto de entrada del servidor

### cliente.c
- \`conectar_servidor()\` - Establece conexión TCP con servidor
- \`main()\` - Punto de entrada del cliente con loop interactivo

### common.h
- \`enviar_con_longitud()\` - Envía datos con prefijo de longitud
- \`recibir_con_longitud()\` - Recibe datos con prefijo de longitud

**Total**: 11 funciones

## Constantes Definidas

\`\`\`c
#define BUFFER_SIZE 4096          // 4KB - tamaño de página estándar
#define MAX_COMANDO_SIZE 1024     // Máximo tamaño de comando
#define MAX_SALIDA_SIZE 65536     // 64KB - máximo tamaño de salida
\`\`\`

## Comandos Prohibidos

\`\`\`c
static const char* COMANDOS_PROHIBIDOS[] = {
    "cd", "top", "htop", "vim", "nano", "less", "more", "ssh", NULL
};
\`\`\`
EOF

cat "$OUTPUT_DIR/estadisticas.md"

echo ""
echo -e "${GREEN}═══════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}  ✓ Archivos generados exitosamente en:${NC}"
echo -e "${GREEN}    $OUTPUT_DIR/${NC}"
echo -e "${GREEN}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${YELLOW}[Próximo paso]${NC} Usa estos archivos para generar el PDF:"
echo -e "  1. Copia el contenido de *_numerado.md al documento"
echo -e "  2. Usa fuente monospace (Courier New, Consolas, Monaco)"
echo -e "  3. Asegúrate que los números de línea sean visibles"
echo ""
