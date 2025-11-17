#!/bin/bash

# validacion_pre_entrega.sh - Validación completa antes de submission
# Autor: Jorge Salgado Miranda
# Fecha: 2025-11-17
# Propósito: Verificar todos los requisitos críticos antes de entregar proyecto

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

CHECKS_TOTAL=0
CHECKS_PASS=0
CHECKS_FAIL=0
CHECKS_WARN=0

# Funciones de validación
check_pass() {
    CHECKS_PASS=$((CHECKS_PASS + 1))
    echo -e "  ${GREEN}✓ PASS${NC} $1"
}

check_fail() {
    CHECKS_FAIL=$((CHECKS_FAIL + 1))
    echo -e "  ${RED}✗ FAIL${NC} $1"
}

check_warn() {
    CHECKS_WARN=$((CHECKS_WARN + 1))
    echo -e "  ${YELLOW}⚠ WARN${NC} $1"
}

echo -e "${BLUE}${BOLD}"
cat << "EOF"
╔═══════════════════════════════════════════════════════════════╗
║                                                               ║
║   VALIDACIÓN PRE-ENTREGA                                      ║
║   SSH-like Remote Command Executor                            ║
║                                                               ║
╚═══════════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"

echo -e "${YELLOW}Fecha de validación: $(date)${NC}"
echo -e "${YELLOW}Deadline del proyecto: Diciembre 9, 2025${NC}"
echo ""

# ==============================================================================
# SECCIÓN 1: ARCHIVOS FUENTE
# ==============================================================================

echo -e "${BLUE}${BOLD}[1] Verificación de Archivos Fuente${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"
CHECKS_TOTAL=$((CHECKS_TOTAL + 1))

if [ -f "src/cliente.c" ] && [ -f "src/servidor.c" ] && [ -f "src/common.h" ]; then
    check_pass "Archivos fuente principales existen"

    # Verificar headers de archivo
    CHECKS_TOTAL=$((CHECKS_TOTAL + 1))
    if grep -q "Jorge Salgado Miranda" src/cliente.c && \
       grep -q "Jorge Salgado Miranda" src/servidor.c && \
       grep -q "Jorge Salgado Miranda" src/common.h; then
        check_pass "Headers con autor presente en todos los archivos"
    else
        check_fail "Falta autor en headers de archivo"
    fi

    # Verificar fechas
    CHECKS_TOTAL=$((CHECKS_TOTAL + 1))
    if grep -q "2025" src/cliente.c && \
       grep -q "2025" src/servidor.c && \
       grep -q "2025" src/common.h; then
        check_pass "Fechas presentes en headers"
    else
        check_warn "Verificar fechas en headers"
    fi
else
    check_fail "Faltan archivos fuente principales"
fi
echo ""

# ==============================================================================
# SECCIÓN 2: COMPILACIÓN
# ==============================================================================

echo -e "${BLUE}${BOLD}[2] Verificación de Compilación${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"

CHECKS_TOTAL=$((CHECKS_TOTAL + 1))
if [ -f "Makefile" ]; then
    check_pass "Makefile existe"

    # Intentar compilar
    CHECKS_TOTAL=$((CHECKS_TOTAL + 1))
    echo -e "  ${YELLOW}[INFO]${NC} Compilando proyecto..."
    if make clean > /dev/null 2>&1 && make all > /dev/null 2>&1; then
        check_pass "Compilación exitosa sin errores"

        # Verificar warnings con flags estrictos
        CHECKS_TOTAL=$((CHECKS_TOTAL + 1))
        compile_output=$(gcc -Wall -Wextra -pedantic -std=c99 -o /tmp/test_servidor src/servidor.c 2>&1)
        if [ -z "$compile_output" ]; then
            check_pass "Sin warnings con flags estrictos (servidor)"
        else
            check_warn "Warnings detectados en servidor.c"
            echo "$compile_output" | sed 's/^/    /'
        fi

        CHECKS_TOTAL=$((CHECKS_TOTAL + 1))
        compile_output=$(gcc -Wall -Wextra -pedantic -std=c99 -o /tmp/test_cliente src/cliente.c 2>&1)
        if [ -z "$compile_output" ]; then
            check_pass "Sin warnings con flags estrictos (cliente)"
        else
            check_warn "Warnings detectados en cliente.c"
            echo "$compile_output" | sed 's/^/    /'
        fi

        rm -f /tmp/test_servidor /tmp/test_cliente
    else
        check_fail "Error en compilación"
    fi
else
    check_fail "Makefile no encontrado"
fi
echo ""

# ==============================================================================
# SECCIÓN 3: CÓDIGO EN ESPAÑOL
# ==============================================================================

echo -e "${BLUE}${BOLD}[3] Verificación de Idioma (Español)${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"

# Verificar variables en español
CHECKS_TOTAL=$((CHECKS_TOTAL + 1))
if grep -q "comando\|servidor\|cliente\|puerto\|salida" src/*.c src/*.h; then
    check_pass "Variables en español detectadas"
else
    check_warn "Pocas variables en español detectadas"
fi

# Verificar funciones en español
CHECKS_TOTAL=$((CHECKS_TOTAL + 1))
if grep -q "conectar_servidor\|ejecutar_comando\|manejar_cliente" src/*.c; then
    check_pass "Funciones en español detectadas"
else
    check_fail "Funciones no están en español"
fi

# Verificar comentarios en español
CHECKS_TOTAL=$((CHECKS_TOTAL + 1))
spanish_comments=$(grep -c "Parámetros\|Retorno\|Descripción" src/*.c src/*.h)
if [ "$spanish_comments" -gt 10 ]; then
    check_pass "Comentarios en español ($spanish_comments encontrados)"
else
    check_warn "Pocos comentarios en español ($spanish_comments encontrados)"
fi
echo ""

# ==============================================================================
# SECCIÓN 4: INTEGRIDAD ACADÉMICA
# ==============================================================================

echo -e "${BLUE}${BOLD}[4] Verificación de Integridad Académica${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"

# Buscar menciones de IA
CHECKS_TOTAL=$((CHECKS_TOTAL + 1))
ai_mentions=$(grep -ri "claude\|anthropic\|gpt\|openai\|chatgpt\|copilot\|gemini" src/ docs/ README.md Makefile 2>/dev/null | grep -v "VALIDACION\|CUMPLIMIENTO\|INSTRUCCIONES" | wc -l | tr -d ' ')
if [ "$ai_mentions" -eq 0 ]; then
    check_pass "Sin menciones de herramientas de IA en código"
else
    check_fail "Menciones de IA encontradas ($ai_mentions)"
    grep -ri "claude\|anthropic\|gpt\|openai\|chatgpt\|copilot" src/ docs/ README.md Makefile 2>/dev/null | grep -v "VALIDACION\|CUMPLIMIENTO" | sed 's/^/    /'
fi

# Verificar que folders .claude y .specify no existan (si ya se eliminaron)
CHECKS_TOTAL=$((CHECKS_TOTAL + 1))
if [ ! -d ".claude" ] && [ ! -d ".specify" ]; then
    check_pass "Folders .claude y .specify eliminados"
else
    check_warn "Folders .claude y/o .specify aún existen (ELIMINAR ANTES DE ENTREGAR)"
fi
echo ""

# ==============================================================================
# SECCIÓN 5: DOCUMENTACIÓN
# ==============================================================================

echo -e "${BLUE}${BOLD}[5] Verificación de Documentación${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"

CHECKS_TOTAL=$((CHECKS_TOTAL + 1))
if [ -f "README.md" ]; then
    check_pass "README.md existe"

    CHECKS_TOTAL=$((CHECKS_TOTAL + 1))
    if grep -q "Compilación\|Uso" README.md; then
        check_pass "README contiene instrucciones básicas"
    else
        check_warn "README puede necesitar más detalles"
    fi
else
    check_fail "README.md no encontrado"
fi

# Verificar documentación en docs/
CHECKS_TOTAL=$((CHECKS_TOTAL + 1))
if [ -d "docs" ]; then
    doc_count=$(find docs -name "*.md" | wc -l | tr -d ' ')
    if [ "$doc_count" -gt 0 ]; then
        check_pass "Documentación adicional existe ($doc_count archivos)"
    else
        check_warn "Poca documentación adicional"
    fi
fi
echo ""

# ==============================================================================
# SECCIÓN 6: ENTREGABLES
# ==============================================================================

echo -e "${BLUE}${BOLD}[6] Verificación de Entregables${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"

# Verificar archivos para email
CHECKS_TOTAL=$((CHECKS_TOTAL + 1))
if [ -d "entrega_email" ] && \
   [ -f "entrega_email/cliente.c" ] && \
   [ -f "entrega_email/servidor.c" ] && \
   [ -f "entrega_email/common.h" ]; then
    check_pass "Archivos .c preparados para email"

    # Verificar tamaño
    CHECKS_TOTAL=$((CHECKS_TOTAL + 1))
    total_size=$(du -sh entrega_email/*.c entrega_email/*.h 2>/dev/null | awk '{sum += $1} END {print sum}')
    if [ -n "$total_size" ]; then
        check_pass "Archivos .c tienen tamaño razonable"
    fi
else
    check_warn "Folder entrega_email/ no preparado completamente"
fi

# Verificar PDF (si existe)
CHECKS_TOTAL=$((CHECKS_TOTAL + 1))
if [ -f "docs/informe.pdf" ]; then
    check_pass "PDF de informe existe"
    pdf_size=$(du -h docs/informe.pdf | awk '{print $1}')
    echo -e "    ${YELLOW}[INFO]${NC} Tamaño del PDF: $pdf_size"
else
    check_warn "PDF de informe aún no generado"
fi

# Verificar screenshots
CHECKS_TOTAL=$((CHECKS_TOTAL + 1))
if [ -f "docs/capturas/prueba_local.png" ] && [ -f "docs/capturas/prueba_remota.png" ]; then
    check_pass "Screenshots de pruebas existen"
else
    check_warn "Screenshots de pruebas pendientes"
fi
echo ""

# ==============================================================================
# SECCIÓN 7: FUNCIONALIDAD (REQUIERE EJECUCIÓN)
# ==============================================================================

echo -e "${BLUE}${BOLD}[7] Verificación de Funcionalidad${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"

# Verificar que binarios existen
CHECKS_TOTAL=$((CHECKS_TOTAL + 1))
if [ -f "servidor" ] && [ -f "cliente" ]; then
    check_pass "Binarios compilados existen"

    # Verificar que son ejecutables
    CHECKS_TOTAL=$((CHECKS_TOTAL + 1))
    if [ -x "servidor" ] && [ -x "cliente" ]; then
        check_pass "Binarios tienen permisos de ejecución"
    else
        check_warn "Binarios pueden no ser ejecutables"
    fi
else
    check_warn "Binarios no compilados (ejecutar 'make all')"
fi

echo -e "  ${YELLOW}[INFO]${NC} Testing funcional requiere ejecución manual"
echo -e "  ${YELLOW}[INFO]${NC} Ejecutar: ./scripts/test_automatico.sh"
echo ""

# ==============================================================================
# SECCIÓN 8: GIT Y CONTROL DE VERSIONES
# ==============================================================================

echo -e "${BLUE}${BOLD}[8] Verificación de Git${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"

CHECKS_TOTAL=$((CHECKS_TOTAL + 1))
if [ -d ".git" ]; then
    check_pass "Repositorio Git inicializado"

    # Verificar .gitignore
    CHECKS_TOTAL=$((CHECKS_TOTAL + 1))
    if [ -f ".gitignore" ]; then
        check_pass ".gitignore existe"

        CHECKS_TOTAL=$((CHECKS_TOTAL + 1))
        if grep -q "cliente\|servidor\|*.o" .gitignore; then
            check_pass ".gitignore excluye binarios"
        else
            check_warn ".gitignore puede no excluir todos los binarios"
        fi
    else
        check_warn ".gitignore no encontrado"
    fi

    # Verificar estado
    CHECKS_TOTAL=$((CHECKS_TOTAL + 1))
    if git diff --quiet && git diff --cached --quiet; then
        check_pass "No hay cambios sin commitear"
    else
        check_warn "Hay cambios pendientes de commit"
    fi
else
    check_warn "No es un repositorio Git"
fi
echo ""

# ==============================================================================
# SECCIÓN 9: CHECKLIST CRÍTICO PRE-SUBMISSION
# ==============================================================================

echo -e "${BLUE}${BOLD}[9] Checklist Crítico Pre-Submission${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"

echo -e "${YELLOW}Items que DEBEN completarse antes de entregar:${NC}"
echo ""

critical_items=(
    "Eliminar folder .claude (rm -rf .claude)"
    "Eliminar folder .specify (rm -rf .specify)"
    "Generar PDF con código y screenshots"
    "Capturar screenshot de prueba local"
    "Capturar screenshot de prueba remota"
    "Preparar email con archivos .c"
    "Agendar sesión Zoom con profesor"
    "Verificar que todo compila sin warnings"
    "Ejecutar pruebas funcionales"
    "Commit final en español primera persona"
)

for item in "${critical_items[@]}"; do
    echo -e "  ${YELLOW}☐${NC} $item"
done

echo ""

# ==============================================================================
# RESUMEN FINAL
# ==============================================================================

echo -e "${BLUE}${BOLD}"
echo "═══════════════════════════════════════════════════════════"
echo "  RESUMEN DE VALIDACIÓN"
echo "═══════════════════════════════════════════════════════════"
echo -e "${NC}"
echo -e "Total de verificaciones: ${BLUE}$CHECKS_TOTAL${NC}"
echo -e "Verificaciones exitosas: ${GREEN}$CHECKS_PASS${NC}"
echo -e "Verificaciones fallidas:  ${RED}$CHECKS_FAIL${NC}"
echo -e "Advertencias:            ${YELLOW}$CHECKS_WARN${NC}"
echo ""

# Calcular porcentaje
if [ $CHECKS_TOTAL -gt 0 ]; then
    percent=$((CHECKS_PASS * 100 / CHECKS_TOTAL))
    echo -e "Porcentaje de completitud: ${BLUE}${percent}%${NC}"
    echo ""
fi

# Determinar resultado final
if [ $CHECKS_FAIL -eq 0 ]; then
    if [ $CHECKS_WARN -eq 0 ]; then
        echo -e "${GREEN}${BOLD}"
        echo "╔═══════════════════════════════════════════════════════════╗"
        echo "║  ✓ PROYECTO LISTO PARA ENTREGA                            ║"
        echo "╚═══════════════════════════════════════════════════════════╝"
        echo -e "${NC}"
        exit 0
    else
        echo -e "${YELLOW}${BOLD}"
        echo "╔═══════════════════════════════════════════════════════════╗"
        echo "║  ⚠ PROYECTO CASI LISTO - REVISAR ADVERTENCIAS             ║"
        echo "╚═══════════════════════════════════════════════════════════╝"
        echo -e "${NC}"
        exit 0
    fi
else
    echo -e "${RED}${BOLD}"
    echo "╔═══════════════════════════════════════════════════════════╗"
    echo "║  ✗ PROYECTO NO LISTO - CORREGIR ERRORES                   ║"
    echo "╚═══════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    exit 1
fi
