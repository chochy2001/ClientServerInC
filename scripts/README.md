# Scripts de Utilidad

Esta carpeta contiene scripts automatizados para facilitar testing, validación y preparación de entregables.

---

## 📜 Scripts Disponibles

### 1. test_automatico.sh

**Propósito**: Ejecuta suite completa de pruebas automatizadas contra el servidor.

**Uso**:
```bash
# Testing en localhost (default)
./scripts/test_automatico.sh

# Testing en servidor remoto
./scripts/test_automatico.sh 192.168.1.100 8080
```

**Qué Hace**:
- Verifica conectividad al servidor
- Ejecuta 16 tests categorizados en 5 suites:
  1. Comandos básicos (pwd, date, whoami, ls, echo)
  2. Comandos con opciones (ls -la, ps, df -h)
  3. Comandos prohibidos (cd, top, vim, htop)
  4. Manejo de errores (archivos inexistentes, comandos inválidos)
  5. Múltiples comandos en sesión
- Reporta resultados con colores (✓ PASS / ✗ FAIL)
- Retorna exit code 0 si todos pasan, 1 si alguno falla

**Requisitos**:
- Servidor debe estar ejecutándose en el puerto especificado
- Cliente compilado en el directorio raíz

**Output Ejemplo**:
```
╔════════════════════════════════════════════════════════════╗
║   Testing Automatizado - SSH-like Remote Executor         ║
╚════════════════════════════════════════════════════════════╝

[Test #1] Comando pwd
  ✓ PASS

[Test #2] Comando date
  ✓ PASS

...

Total de tests ejecutados: 16
Tests exitosos:           16
Tests fallidos:           0

╔════════════════════════════════════════════════════════════╗
║  ✓ TODOS LOS TESTS PASARON EXITOSAMENTE                   ║
╚════════════════════════════════════════════════════════════╝
```

---

### 2. generar_codigo_pdf.sh

**Propósito**: Genera archivos de código con números de línea listos para incluir en PDF.

**Uso**:
```bash
./scripts/generar_codigo_pdf.sh
```

**Qué Hace**:
- Crea directorio `docs/codigo_para_pdf/`
- Genera archivos markdown con código numerado:
  - `cliente_numerado.md`
  - `servidor_numerado.md`
  - `common_numerado.md`
  - `makefile_numerado.md`
- Genera estadísticas de código:
  - Líneas totales por archivo
  - Estimación de comentarios vs código
  - Lista de funciones
  - Constantes definidas
- Formato markdown listo para copiar a Word/Google Docs/LaTeX

**Output Generado**:
```
docs/codigo_para_pdf/
├── cliente_numerado.md      (188 líneas numeradas)
├── servidor_numerado.md     (433 líneas numeradas)
├── common_numerado.md       (192 líneas numeradas)
├── makefile_numerado.md     (63 líneas numeradas)
└── estadisticas.md          (Resumen de código)
```

**Uso del Output**:
1. Abrir archivos *_numerado.md
2. Copiar contenido
3. Pegar en documento de Word/Docs con fuente monospace
4. O usar con Pandoc para generar PDF directamente

---

### 3. validacion_pre_entrega.sh

**Propósito**: Validación completa del proyecto antes de submission.

**Uso**:
```bash
./scripts/validacion_pre_entrega.sh
```

**Qué Hace**:
Ejecuta 9 secciones de validación con 25+ verificaciones:

1. **Archivos Fuente**
   - Verifica existencia de cliente.c, servidor.c, common.h
   - Valida headers con autor y fecha

2. **Compilación**
   - Compila con Makefile
   - Verifica compilación con flags estrictos (-Wall -Wextra -pedantic)
   - Detecta warnings

3. **Idioma (Español)**
   - Busca variables en español
   - Busca funciones en español
   - Cuenta comentarios en español

4. **Integridad Académica**
   - Busca menciones de herramientas de IA
   - Verifica que folders .claude y .specify no existan

5. **Documentación**
   - Verifica README.md existe
   - Cuenta documentos en docs/

6. **Entregables**
   - Verifica archivos en entrega_email/
   - Verifica PDF (si existe)
   - Verifica screenshots (si existen)

7. **Funcionalidad**
   - Verifica binarios compilados
   - Verifica permisos de ejecución

8. **Git**
   - Verifica repositorio inicializado
   - Verifica .gitignore
   - Verifica estado de commits

9. **Checklist Crítico**
   - Lista 10 items que DEBEN completarse antes de entregar

**Output Ejemplo**:
```
╔═══════════════════════════════════════════════════════════╗
║   VALIDACIÓN PRE-ENTREGA                                  ║
║   SSH-like Remote Command Executor                        ║
╚═══════════════════════════════════════════════════════════╝

[1] Verificación de Archivos Fuente
════════════════════════════════════
  ✓ PASS Archivos fuente principales existen
  ✓ PASS Headers con autor presente
  ...

═══════════════════════════════════════════════════════════
  RESUMEN DE VALIDACIÓN
═══════════════════════════════════════════════════════════
Total de verificaciones: 25
Verificaciones exitosas: 20
Verificaciones fallidas:  1
Advertencias:            4

Porcentaje de completitud: 80%

╔═══════════════════════════════════════════════════════════╗
║  ⚠ PROYECTO CASI LISTO - REVISAR ADVERTENCIAS             ║
╚═══════════════════════════════════════════════════════════╝
```

**Exit Codes**:
- 0: Proyecto listo o casi listo
- 1: Proyecto tiene errores críticos

---

## 🔄 Workflow Recomendado

### Durante Desarrollo

```bash
# Después de hacer cambios al código
make clean && make all
./scripts/validacion_pre_entrega.sh
```

### Antes de Testing

```bash
# Compilar
make clean && make all

# En Terminal 1
./servidor 8080

# En Terminal 2
./scripts/test_automatico.sh
```

### Antes de Generar PDF

```bash
# Generar archivos numerados
./scripts/generar_codigo_pdf.sh

# Usar archivos de docs/codigo_para_pdf/ para PDF
```

### Antes de Entregar

```bash
# Validación final
./scripts/validacion_pre_entrega.sh

# Si pasa, continuar con entrega
# Si falla, corregir errores y volver a validar
```

---

## 🛠️ Troubleshooting

### "Script no ejecutable"

```bash
# Dar permisos de ejecución
chmod +x scripts/*.sh
```

### "Comando no encontrado: nc"

El script test_automatico.sh usa `nc` (netcat) para verificar conectividad.

**Instalar**:
- macOS: viene preinstalado
- Linux: `sudo apt-get install netcat`

### "Tests fallan pero servidor funciona"

Verifica:
1. Servidor está ejecutándose: `ps aux | grep servidor`
2. Puerto correcto: `netstat -an | grep 8080`
3. Cliente compila: `make clean && make all`
4. No hay firewall bloqueando

### "Validación reporta errores de IA"

Si encuentra menciones en archivos internos (VALIDACION.md, GUIA_TESTING.md, etc.), es normal. Esos archivos no se entregan.

Solo importa que NO haya menciones en:
- src/*.c
- src/*.h
- README.md
- Makefile
- informe.pdf

---

## 📝 Notas Adicionales

### Personalización de Tests

Puedes modificar `test_automatico.sh` para agregar más tests:

```bash
# Agregar nuevo test
run_test "Nombre del test" "comando a ejecutar" "patrón esperado"

# Ejemplo:
run_test "Comando hostname" "hostname" "."
```

### Integración con CI/CD

Los scripts pueden integrarse con sistemas de CI/CD:

```yaml
# Ejemplo .gitlab-ci.yml
test:
  script:
    - make clean && make all
    - ./scripts/test_automatico.sh
    - ./scripts/validacion_pre_entrega.sh
```

---

**Autor**: Jorge Salgado Miranda
**Fecha**: 2025-11-17
**Proyecto**: SSH-like Remote Command Executor
