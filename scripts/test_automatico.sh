#!/bin/bash

# test_automatico.sh - Script de testing automatizado para cliente SSH-like
# Autor: Jorge Salgado Miranda
# Fecha: 2025-11-17
# Propósito: Ejecutar suite de pruebas automatizadas contra servidor

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuración
SERVER_IP="${1:-localhost}"
SERVER_PORT="${2:-8080}"
TEST_COUNT=0
TEST_PASS=0
TEST_FAIL=0

echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   Testing Automatizado - SSH-like Remote Executor         ║${NC}"
echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo ""
echo -e "${YELLOW}Servidor: ${SERVER_IP}:${SERVER_PORT}${NC}"
echo -e "${YELLOW}Fecha: $(date)${NC}"
echo ""

# Verificar que servidor esté accesible
echo -e "${BLUE}[Verificación]${NC} Comprobando conectividad al servidor..."
if ! nc -z -w5 "$SERVER_IP" "$SERVER_PORT" 2>/dev/null; then
    echo -e "${RED}[ERROR]${NC} No se puede conectar al servidor ${SERVER_IP}:${SERVER_PORT}"
    echo -e "${YELLOW}[INFO]${NC} Asegúrate de que el servidor esté ejecutándose:"
    echo -e "        ./servidor ${SERVER_PORT}"
    exit 1
fi
echo -e "${GREEN}[OK]${NC} Servidor accesible"
echo ""

# Función para ejecutar test
run_test() {
    local test_name="$1"
    local command="$2"
    local expected_pattern="$3"

    TEST_COUNT=$((TEST_COUNT + 1))

    echo -e "${BLUE}[Test #${TEST_COUNT}]${NC} ${test_name}"
    echo -e "  Comando: ${YELLOW}${command}${NC}"

    # Ejecutar comando
    output=$(echo "$command" | timeout 5 ./cliente "$SERVER_IP" "$SERVER_PORT" 2>&1 | grep -v "Conectado" | grep -v "Escribe" | grep -v "comando>" | grep -v "Cerrando" | grep -v "Desconectado")

    # Verificar output
    if echo "$output" | grep -q "$expected_pattern"; then
        echo -e "  ${GREEN}✓ PASS${NC}"
        TEST_PASS=$((TEST_PASS + 1))
        return 0
    else
        echo -e "  ${RED}✗ FAIL${NC}"
        echo -e "  Output recibido:"
        echo "$output" | sed 's/^/    /'
        TEST_FAIL=$((TEST_FAIL + 1))
        return 1
    fi
}

# Función para ejecutar test de error
run_error_test() {
    local test_name="$1"
    local command="$2"
    local expected_error="$3"

    TEST_COUNT=$((TEST_COUNT + 1))

    echo -e "${BLUE}[Test #${TEST_COUNT}]${NC} ${test_name}"
    echo -e "  Comando: ${YELLOW}${command}${NC}"

    # Ejecutar comando
    output=$(echo "$command" | timeout 5 ./cliente "$SERVER_IP" "$SERVER_PORT" 2>&1)

    # Verificar que contenga ERROR
    if echo "$output" | grep -q "ERROR.*${expected_error}"; then
        echo -e "  ${GREEN}✓ PASS${NC} (Error esperado detectado)"
        TEST_PASS=$((TEST_PASS + 1))
        return 0
    else
        echo -e "  ${RED}✗ FAIL${NC} (Error esperado no detectado)"
        echo -e "  Output recibido:"
        echo "$output" | sed 's/^/    /'
        TEST_FAIL=$((TEST_FAIL + 1))
        return 1
    fi
}

echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}  Suite 1: Comandos Básicos${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
echo ""

# Test 1: pwd
run_test "Comando pwd" "pwd" "/"
echo ""

# Test 2: date
run_test "Comando date" "date" "202"
echo ""

# Test 3: whoami
run_test "Comando whoami" "whoami" "."
echo ""

# Test 4: ls
run_test "Comando ls" "ls" "."
echo ""

# Test 5: echo
run_test "Comando echo" "echo 'Hola Mundo'" "Hola Mundo"
echo ""

echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}  Suite 2: Comandos con Opciones${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
echo ""

# Test 6: ls con opciones
run_test "Comando ls -la" "ls -la" "total"
echo ""

# Test 7: ps
run_test "Comando ps" "ps" "PID"
echo ""

# Test 8: df -h
run_test "Comando df -h" "df -h" "Filesystem"
echo ""

echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}  Suite 3: Comandos Prohibidos (Deben Fallar)${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
echo ""

# Test 9: cd (prohibido)
run_error_test "Comando cd (prohibido)" "cd /tmp" "cd"
echo ""

# Test 10: top (prohibido)
run_error_test "Comando top (prohibido)" "top" "top"
echo ""

# Test 11: vim (prohibido)
run_error_test "Comando vim (prohibido)" "vim test.txt" "vim"
echo ""

# Test 12: htop (prohibido)
run_error_test "Comando htop (prohibido)" "htop" "htop"
echo ""

echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}  Suite 4: Manejo de Errores${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
echo ""

# Test 13: Archivo inexistente
run_test "Archivo inexistente" "cat /archivo_que_no_existe_12345.txt" "No such file"
echo ""

# Test 14: Directorio inexistente
run_test "Directorio inexistente" "ls /directorio_inexistente_12345/" "No such file"
echo ""

# Test 15: Comando inexistente
run_test "Comando inexistente" "comando_inexistente_12345" "not found"
echo ""

echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}  Suite 5: Múltiples Comandos en Sesión${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
echo ""

# Test 16: Múltiples comandos
TEST_COUNT=$((TEST_COUNT + 1))
echo -e "${BLUE}[Test #${TEST_COUNT}]${NC} Múltiples comandos en una sesión"

multi_output=$(cat <<'EOF' | timeout 10 ./cliente "$SERVER_IP" "$SERVER_PORT" 2>&1
pwd
ls
date
whoami
salir
EOF
)

if echo "$multi_output" | grep -q "/" && \
   echo "$multi_output" | grep -q "202" && \
   echo "$multi_output" | grep -q "."; then
    echo -e "  ${GREEN}✓ PASS${NC} (Múltiples comandos ejecutados exitosamente)"
    TEST_PASS=$((TEST_PASS + 1))
else
    echo -e "  ${RED}✗ FAIL${NC} (Error en ejecución de múltiples comandos)"
    TEST_FAIL=$((TEST_FAIL + 1))
fi
echo ""

echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}  Resumen de Testing${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "Total de tests ejecutados: ${BLUE}${TEST_COUNT}${NC}"
echo -e "Tests exitosos:           ${GREEN}${TEST_PASS}${NC}"
echo -e "Tests fallidos:           ${RED}${TEST_FAIL}${NC}"

if [ $TEST_FAIL -eq 0 ]; then
    echo ""
    echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║  ✓ TODOS LOS TESTS PASARON EXITOSAMENTE                   ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
    exit 0
else
    echo ""
    echo -e "${RED}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${RED}║  ✗ ALGUNOS TESTS FALLARON                                  ║${NC}"
    echo -e "${RED}╚════════════════════════════════════════════════════════════╝${NC}"
    exit 1
fi
