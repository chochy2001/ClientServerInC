---

description: "Task list template for feature implementation"
---

# Tasks: [FEATURE NAME]

**Input**: Design documents from `/specs/[###-feature-name]/`
**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md, data-model.md, contracts/

**Tests**: The examples below include test tasks. Tests are OPTIONAL - only include them if explicitly requested in the feature specification.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

## Path Conventions

- **Single project**: `src/`, `tests/` at repository root
- **Web app**: `backend/src/`, `frontend/src/`
- **Mobile**: `api/src/`, `ios/src/` or `android/src/`
- Paths shown below assume single project - adjust based on plan.md structure

<!-- 
  ============================================================================
  IMPORTANT: The tasks below are SAMPLE TASKS for illustration purposes only.
  
  The /speckit.tasks command MUST replace these with actual tasks based on:
  - User stories from spec.md (with their priorities P1, P2, P3...)
  - Feature requirements from plan.md
  - Entities from data-model.md
  - Endpoints from contracts/
  
  Tasks MUST be organized by user story so each story can be:
  - Implemented independently
  - Tested independently
  - Delivered as an MVP increment
  
  DO NOT keep these sample tasks in the generated tasks.md file.
  ============================================================================
-->

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Project initialization and basic structure

- [ ] T001 Create project directory structure (src/, docs/, docs/capturas/)
- [ ] T002 Create Makefile with targets: all, client, server, clean
- [ ] T003 [P] Create common.h with buffer sizes, protocol constants, shared macros
- [ ] T004 [P] Create .gitignore to exclude compiled binaries (client, server, *.o)
- [ ] T005 [P] Create README.md with compilation and usage instructions

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core infrastructure that MUST be complete before ANY user story can be implemented

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

C Socket Programming Foundations:

- [ ] T006 [P] Implement error handling macros in common.h (perror wrapper, exit codes)
- [ ] T007 [P] Implement command validation function (check for "exit", "salir", restricted commands)
- [ ] T008 Implement socket creation and configuration (SO_REUSEADDR) in server.c stub
- [ ] T009 Implement command execution function using popen() in server.c stub
- [ ] T010 [P] Implement send_all() function to handle partial sends
- [ ] T011 [P] Implement recv_all() function to handle partial receives
- [ ] T012 Test compilation with gcc -Wall -Wextra on Linux and MacOS

**Checkpoint**: Foundation ready - user story implementation can now begin in parallel

---

## Phase 3: User Story 1 - Basic Server Implementation (Priority: P1) 🎯 MVP

**Goal**: Server accepts connections and executes simple commands

**Independent Test**: Start server, connect with telnet, send "pwd" command, receive output

### Implementation for User Story 1

- [ ] T013 [US1] Implement main() in server.c: parse command-line args (port validation)
- [ ] T014 [US1] Implement socket(), bind(), listen() in server.c with error checking
- [ ] T015 [US1] Implement accept() loop to handle incoming connections
- [ ] T016 [US1] Implement receive command logic using recv_all()
- [ ] T017 [US1] Integrate command execution (popen) with command validation
- [ ] T018 [US1] Implement send output back to client using send_all()
- [ ] T019 [US1] Add connection close and resource cleanup
- [ ] T020 [US1] Add file header and function documentation comments
- [ ] T021 [US1] Test with: ./server 8080, then telnet localhost 8080

**Checkpoint**: Server accepts connection, executes commands, returns output

---

## Phase 4: User Story 2 - Client Implementation (Priority: P2)

**Goal**: Client connects to server, sends commands, displays output

**Independent Test**: ./client localhost 8080, enter commands, verify output matches server execution

### Implementation for User Story 2

- [ ] T022 [P] [US2] Implement main() in client.c: parse args (IP/domain, port validation)
- [ ] T023 [P] [US2] Implement socket() and connect() with error checking
- [ ] T024 [US2] Implement interactive command loop (read from stdin)
- [ ] T025 [US2] Implement send command using send_all()
- [ ] T026 [US2] Implement receive and display output using recv_all()
- [ ] T027 [US2] Implement "exit"/"salir" detection and graceful disconnect
- [ ] T028 [US2] Add file header and function documentation comments
- [ ] T029 [US2] Test local: ./server 8080 & ./client localhost 8080

**Checkpoint**: Full client-server interaction working locally

---

## Phase 5: User Story 3 - Testing & Validation (Priority: P3)

**Goal**: Verify all requirements, test edge cases, ensure cross-platform compatibility

**Independent Test**: Test suite passes on both Linux and MacOS

### Testing Tasks

- [ ] T030 [P] [US3] Test multiple commands: ls -l, ps -e, pwd, date, whoami, cat [file]
- [ ] T031 [P] [US3] Test error cases: invalid port, connection refused, command not found
- [ ] T032 [P] [US3] Test restricted commands: verify "cd" is rejected or handled safely
- [ ] T033 [P] [US3] Test large output: cat of large file, ls of large directory
- [ ] T034 [US3] Test memory leaks: run valgrind --leak-check=full on both client/server
- [ ] T035 [US3] Test compilation on MacOS (if developed on Linux, or vice versa)
- [ ] T036 [US3] Test remote connection: deploy server on one host, client on another
- [ ] T037 [US3] Verify all error messages use perror() or equivalent

**Checkpoint**: All tests pass, no memory leaks, cross-platform verified

---

[Add more user story phases as needed, following the same pattern]

---

## Phase 6: Documentation & Submission Preparation

**Purpose**: Final deliverables for project submission

- [ ] T038 [P] Take screenshot of local test (localhost client-server interaction)
- [ ] T039 [P] Take screenshot of remote test (different hosts client-server)
- [ ] T040 Create PDF document (informe.pdf) with:
  - Cover page with project title, author, date
  - Complete source code (client.c, server.c, common.h, Makefile)
  - Compilation instructions
  - Usage instructions
  - Screenshots (local + remote tests)
- [ ] T041 [P] Verify source files ready for email: client.c, server.c, common.h
- [ ] T042 [P] Update README.md with final compilation and usage instructions
- [ ] T043 Run final constitution compliance check (see .specify/memory/constitution.md)
- [ ] T044 Schedule Zoom review session (via Telegram/WhatsApp)

---

## Dependencies & Execution Order

### Phase Dependencies

- **Phase 1 (Setup)**: No dependencies - can start immediately
- **Phase 2 (Foundational)**: Depends on Phase 1 (Setup) - BLOCKS all implementation
- **Phase 3 (Server Implementation)**: Depends on Phase 2 (Foundational)
- **Phase 4 (Client Implementation)**: Can start in parallel with Phase 3, but requires Phase 2
- **Phase 5 (Testing)**: Depends on Phases 3 AND 4 being complete
- **Phase 6 (Documentation)**: Depends on Phase 5 (Testing) passing

### Critical Path

```
Phase 1 (Setup)
    ↓
Phase 2 (Foundational - BLOCKING)
    ↓
    ├──→ Phase 3 (Server) ─┐
    │                      ↓
    └──→ Phase 4 (Client) ─┤
                           ↓
                    Phase 5 (Testing)
                           ↓
                    Phase 6 (Documentation)
```

### Parallel Opportunities

- Phase 3 (Server) and Phase 4 (Client) can be developed in parallel after Phase 2
- Within each phase, tasks marked [P] can run in parallel
- Testing tasks in Phase 5 marked [P] can run in parallel

### Within Each Phase

- **Phase 1**: All tasks can be done in parallel (marked [P])
- **Phase 2**: Common utility functions can be developed in parallel
- **Phase 3**: Server functions should be implemented in order: socket setup → accept loop → receive → execute → send
- **Phase 4**: Client functions should be implemented in order: argument parsing → socket setup → connect → send → receive → display
- **Phase 5**: All testing tasks can run in parallel
- **Phase 6**: Documentation tasks can run in parallel except PDF creation (depends on screenshots)

---

## Implementation Strategy

### Sequential Development (Recommended for Solo Work)

1. **Week 1-2**: Complete Phases 1-2 (Setup + Foundational)
   - Create project structure
   - Implement utility functions
   - Verify compilation
2. **Week 3**: Complete Phase 3 (Server)
   - Implement and test server
   - Verify with telnet/nc
3. **Week 4**: Complete Phase 4 (Client)
   - Implement and test client
   - Verify local client-server interaction
4. **Week 5**: Complete Phase 5 (Testing)
   - Run all test scenarios
   - Fix bugs and memory leaks
   - Cross-platform verification
5. **Week 6**: Complete Phase 6 (Documentation)
   - Capture screenshots
   - Generate PDF
   - Prepare submission

### Parallel Team Strategy (2 Developers)

With two team members:

1. **Both together**: Complete Phases 1-2 (Setup + Foundational)
2. **Split work**:
   - Developer A: Phase 3 (Server implementation)
   - Developer B: Phase 4 (Client implementation)
3. **Both together**: Phase 5 (Testing) - pair testing reveals more bugs
4. **Split work**:
   - Developer A: Take screenshots and prepare PDF
   - Developer B: Update README and verify deliverables

---

## Notes

- [P] tasks = can be done in parallel (independent files/functions, no dependencies)
- [US#] label = maps task to specific user story/phase for traceability
- Compile frequently: gcc -Wall -Wextra catches errors early
- Test incrementally: don't wait until the end to test functionality
- Use version control: commit after each completed task or logical group
- Memory safety: run valgrind regularly during development, not just at the end
- Constitution compliance: refer to `.specify/memory/constitution.md` for requirements
- Deadline: December 9, 2025 - plan backwards from submission date

### Common Pitfalls to Avoid

- Forgetting to check return values (causes hard-to-debug crashes)
- Buffer overflows from unchecked string operations
- Memory leaks from missing free() calls
- Platform-specific code (test on both Linux and MacOS early)
- Hardcoded buffer sizes without defined constants
- Missing error handling in socket operations
- Not handling partial send/recv (network can split messages)
