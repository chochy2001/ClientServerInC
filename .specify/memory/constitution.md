<!--
SYNC IMPACT REPORT
==================
Version Change: 1.0.0 → 1.1.0
Rationale: MINOR version bump - Added new principle (IX. Spanish Language and Academic Integrity)

Modified Principles:
  - Added Principle IX: Spanish Language and Academic Integrity (NON-NEGOTIABLE)
    * All code in Spanish (variables, functions, comments)
    * Git commits in Spanish, first person
    * No AI tool mentions anywhere
    * Delete .claude and .specify folders before submission

Added Sections: None (principle addition only)

Templates Requiring Updates:
  ✅ .specify/templates/plan-template.md - Constitution Check updated with Principle IX
  ✅ .specify/templates/spec-template.md - Already includes Spanish language requirements (FR-016 to FR-020)
  ✅ .specify/templates/tasks-template.md - Already includes C development workflow
  ⚠️  Template updates may be needed to emphasize Spanish language requirement in generated artifacts

Follow-up TODOs:
  - Ensure all generated code uses Spanish identifiers
  - Verify git commit messages are in Spanish and first person
  - Add final cleanup task to delete .claude and .specify folders
-->

# SSH-like Remote Command Executor Constitution

## Core Principles

### I. C Language Only (NON-NEGOTIABLE)

The project MUST be implemented exclusively in C language. No other programming languages are accepted for the client or server implementation.

**Rationale**: This is a hard requirement from the academic project specification. The project will be rejected if implemented in any other language.

### II. TCP/IP Socket Architecture

All client-server communication MUST use TCP sockets (SOCK_STREAM with AF_INET). The architecture MUST support remote connections between different hosts.

**Rationale**: TCP provides reliable, ordered delivery required for command execution and output transmission. While development and local testing use localhost, the final evaluation requires remote host-to-host communication.

### III. Command Line Interface Design

- Server MUST accept port number as command-line argument
- Client MUST accept server IP/domain and port as command-line arguments
- Both programs MUST validate command-line input before execution
- Error messages MUST be clear and descriptive

**Rationale**: Standardized CLI interface ensures the project can be evaluated consistently across different testing environments without code modifications.

### IV. Remote Command Execution

The server MUST:
- Receive commands from client via socket
- Execute commands in the server's local environment (NOT client environment)
- Capture complete command output (stdout and stderr)
- Return output to client via socket
- Handle command execution errors gracefully

**Rationale**: Core functionality requirement - the client issues commands that execute remotely on the server, mimicking SSH behavior.

### V. Supported Command Set

System MUST support standard Linux/MacOS commands including:
- File operations: `ls`, `cat`, `pwd`
- Process information: `ps`, `whoami`
- System information: `date`, `uname`
- And any other standard command with appropriate options

System MUST NOT support:
- Dynamic output commands (e.g., `top`, `htop`)
- Commands that change working directory (e.g., `cd`)
- Interactive commands requiring user input

**Rationale**: Static output commands are sufficient to demonstrate remote execution capability. Dynamic/interactive commands introduce complexity beyond project scope.

### VI. Graceful Disconnection

Client MUST disconnect cleanly when receiving `salir` or `exit` command. Server MUST:
- Detect client disconnection
- Release resources (close sockets, free memory)
- Continue accepting new connections
- Log disconnection events

**Rationale**: Proper resource management prevents memory leaks and allows server to remain available for multiple client sessions.

### VII. Code Documentation (NON-NEGOTIABLE)

ALL source code MUST include:
- File header with purpose, author, and date
- Function documentation (parameters, return values, side effects)
- Inline comments for complex logic
- Clear variable naming (no single-letter names except loop counters)

**Rationale**: Academic requirement and professional best practice. Code will be reviewed and must be maintainable.

### VIII. Cross-Platform Compatibility

Code MUST compile and run on both Linux and MacOS without modifications. Platform-specific code MUST be avoided or properly abstracted.

**Rationale**: Evaluation environment is not predetermined - instructor may test on either Linux or MacOS.

### IX. Spanish Language and Academic Integrity (NON-NEGOTIABLE)

ALL code, comments, and commits MUST adhere to these requirements:
- All code MUST be written in Spanish (variable names, function names, comments)
- All git commits MUST be in Spanish, written in first person
- NO mentions of AI tools or assistance anywhere in the code, comments, commits, or documentation
- Folders `.claude` and `.specify` MUST be deleted before final project submission
- Each important function MUST have explanatory comments in Spanish

**Rationale**: Academic integrity requirement - the submitted work must appear as original student work without external AI tool assistance. Spanish language requirement ensures code is accessible and maintainable by Spanish-speaking evaluators and future students.

## Technical Requirements

### Implementation Approach

Developers MUST choose one of these approaches for command execution:

**Option A: fork() + exec() + pipe()**
- Use `fork()` to create child process
- Use `pipe()` to capture child output
- Use `dup2()` to redirect stdout/stderr to pipe
- Use `exec()` family to execute command
- Parent uses `wait()` to collect child status

**Option B: popen() (RECOMMENDED)**
- Use `popen()` to execute command and capture output
- Simpler implementation with built-in pipe management
- Easier error handling
- Less code, fewer edge cases

### Socket Programming Standards

- MUST use `socket()`, `bind()`, `listen()`, `accept()` for server
- MUST use `socket()`, `connect()` for client
- MUST use `send()`/`recv()` or `write()`/`read()` for data transfer
- MUST handle partial sends/receives in loops
- MUST set appropriate socket options (SO_REUSEADDR recommended)
- MUST check ALL system call return values for errors

### Error Handling Requirements

- ALL system calls MUST check return values
- Errors MUST be reported using `perror()` or equivalent
- Client MUST distinguish between connection errors and command errors
- Server MUST NOT crash on malformed input
- Resource cleanup MUST occur even on error paths

### Memory Management

- ALL dynamically allocated memory MUST be freed
- NO memory leaks (validate with `valgrind` if available)
- Buffer sizes MUST be clearly defined constants
- Buffer overflows MUST be prevented

## Deliverables & Documentation

### Source Code Submission

MUST submit:
1. **PDF document** containing:
   - Complete source code (client.c and server.c)
   - Compilation instructions
   - Usage instructions
   - Screenshots of at least 2 test executions
2. **Email attachment** with `.c` source files (NO executables)
   - Email to: carlos.roman@ingenieria.unam.edu
   - Subject format: [Project-specific format if specified]
   - MUST NOT include compiled binaries (blocked by email security)

### Testing Evidence

MUST provide screenshots demonstrating:
1. **Local test**: Client and server on same host (localhost)
2. **Remote test**: Client and server on different hosts (actual IPs)

Each screenshot MUST show:
- Command execution
- Server output returned to client
- Proper formatting and completeness

### Zoom Review Requirements

MUST schedule Zoom session (via Telegram/WhatsApp) for live demonstration:
- Camera MUST be enabled during session
- MUST share screen for local test demonstration
- Instructor will perform remote test using submitted source code
- If team project (2 members max), both MUST be present

## Governance

### Constitution Authority

This constitution defines the non-negotiable requirements for the SSH-like Client-Server project. All implementation decisions MUST align with these principles.

### Amendment Procedure

Constitution amendments require:
1. Identification of requirement conflict or ambiguity
2. Reference to authoritative source (project specification)
3. Documentation of change rationale
4. Update of affected templates and documentation

### Compliance Verification

Before submission, verify:
- [ ] Code is 100% C language
- [ ] Compiles without warnings (`gcc -Wall -Wextra`)
- [ ] Runs on both Linux and MacOS
- [ ] All functions are documented
- [ ] Local and remote tests pass
- [ ] Memory management is correct
- [ ] PDF includes all required sections
- [ ] Source files attached to email
- [ ] Zoom review scheduled

### Quality Gates

**Pre-Implementation**:
- Constitution reviewed and understood
- Implementation approach selected (fork/exec vs popen)
- Project structure defined

**During Implementation**:
- Code compiles without warnings
- Each function tested individually
- Memory leaks checked
- Error handling verified

**Pre-Submission**:
- All tests pass (local and remote)
- Documentation complete
- PDF generated with screenshots
- Source code emailed
- Zoom session scheduled

### Deadline

**Final submission deadline**: Tuesday, December 9, 2025
- Grades submitted to system on December 10, 2025
- Late submissions not accepted

**Version**: 1.1.0 | **Ratified**: 2025-11-17 | **Last Amended**: 2025-11-17
