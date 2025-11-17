# Implementation Plan: [FEATURE]

**Branch**: `[###-feature-name]` | **Date**: [DATE] | **Spec**: [link]
**Input**: Feature specification from `/specs/[###-feature-name]/spec.md`

**Note**: This template is filled in by the `/speckit.plan` command. See `.specify/templates/commands/plan.md` for the execution workflow.

## Summary

[Extract from feature spec: primary requirement + technical approach from research]

## Technical Context

<!--
  ACTION REQUIRED: Replace the content in this section with the technical details
  for the project. The structure here is presented in advisory capacity to guide
  the iteration process.
-->

**Language/Version**: C (C99 or C11 standard)
**Compiler**: gcc with flags: -Wall -Wextra -std=c99 (or c11)
**Primary Dependencies**: POSIX sockets API (sys/socket.h, netinet/in.h, arpa/inet.h)
**Command Execution**: popen() (recommended) or fork()+exec()+pipe()+dup2()
**Testing**: Manual testing (local + remote), valgrind for memory leak detection
**Target Platform**: Linux and MacOS (cross-platform compatible)
**Project Type**: Client-Server architecture (two separate executables)
**Performance Goals**: Handle multiple sequential client connections, sub-second command response
**Constraints**: No external libraries beyond POSIX standard, no memory leaks, compile on both Linux/MacOS
**Scale/Scope**: Single client connection at a time, support standard Unix commands

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

Based on `.specify/memory/constitution.md`:

- [ ] **C Language Only (NON-NEGOTIABLE)**: Implementation is 100% C language
- [ ] **TCP/IP Socket Architecture**: Uses TCP sockets (SOCK_STREAM with AF_INET)
- [ ] **Command Line Interface**: Server accepts port; Client accepts IP/domain and port
- [ ] **Remote Command Execution**: Server executes commands and returns output to client
- [ ] **Supported Command Set**: Handles standard commands; excludes dynamic/interactive commands
- [ ] **Graceful Disconnection**: Supports "salir"/"exit" with proper resource cleanup
- [ ] **Code Documentation**: All functions documented with headers and inline comments
- [ ] **Cross-Platform Compatibility**: Compiles and runs on both Linux and MacOS
- [ ] **Spanish Language & Academic Integrity (NON-NEGOTIABLE)**: All code in Spanish; no AI mentions; commits in Spanish first person
- [ ] **Error Handling**: All system calls checked; errors reported with perror()
- [ ] **Memory Management**: No memory leaks; all allocations freed

## Project Structure

### Documentation (this feature)

```text
specs/[###-feature]/
├── plan.md              # This file (/speckit.plan command output)
├── research.md          # Phase 0 output (/speckit.plan command)
├── data-model.md        # Phase 1 output (/speckit.plan command)
├── quickstart.md        # Phase 1 output (/speckit.plan command)
├── contracts/           # Phase 1 output (/speckit.plan command)
└── tasks.md             # Phase 2 output (/speckit.tasks command - NOT created by /speckit.plan)
```

### Source Code (repository root)

```text
proyecto-ssh/
├── src/
│   ├── client.c          # Client implementation
│   ├── server.c          # Server implementation
│   ├── common.h          # Shared constants, buffer sizes, protocol definitions
│   └── utils.c/h         # Optional: shared utility functions (if needed)
│
├── docs/
│   ├── informe.pdf       # Final report with code + screenshots
│   └── capturas/         # Screenshots for documentation
│       ├── prueba_local.png
│       └── prueba_remota.png
│
├── Makefile              # Build automation (optional but recommended)
├── README.md             # Compilation and usage instructions
└── .gitignore            # Ignore compiled binaries

Compiled outputs (not committed to git):
├── client                # Compiled client executable
└── server                # Compiled server executable
```

**Structure Decision**: Simple C project structure with separate source files for client and server. Shared definitions in common.h. Documentation directory for final deliverables (PDF report and screenshots).

**Build Commands**:
```bash
# Compile client
gcc -Wall -Wextra -std=c99 -o client src/client.c

# Compile server
gcc -Wall -Wextra -std=c99 -o server src/server.c

# Or use Makefile
make all
make clean
```

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| [e.g., 4th project] | [current need] | [why 3 projects insufficient] |
| [e.g., Repository pattern] | [specific problem] | [why direct DB access insufficient] |
