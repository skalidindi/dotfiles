---
description: Systematic software implementation with test-driven development methodology
allowed-tools: Bash, Edit, MultiEdit, Read, WebFetch, WebSearch, Write
---

# 🚀 Strategic Software Implementation

## Usage
`/coding:implement [--skip-tests]`

## Arguments
- Optional: Specific feature/component description
- `--skip-tests`: Skip test-driven development methodology for projects without a need for tests
- Automatically analyzes current codebase and conversation context

## Your task
Transform planned requirements into working code through systematic, test-driven implementation using structured decomposition and quality-first development.

## Implementation Methodology

### Phase 1: Requirements Analysis & Implementation Planning
**Define Purpose & Scope**: Clearly outline what needs to be built and its boundaries
**Establish Precise, Testable Requirements**: Formulate requirements that can be validated through tests or manual verification
**Design for Parallelism**: Break down complex work into discrete, parallelizable implementation subtasks
**Identify Key Files & Dependencies**: List files to create/modify, their roles, and critical dependencies
**Create Execution Plan**: Map out parallel vs sequential implementation tasks with clear handoff points

### Phase 2: Context Analysis
Analyze the current codebase:
```bash
# Project structure and technology stack
fd --base-directory . '(package\.json|Cargo\.toml|pom\.xml|requirements\.txt|pyproject\.toml)' --type f --no-ignore
# Testing patterns
fd '(test|spec|_test)' --extension js --extension ts --extension py --extension java --extension scala --extension go --extension rs | head -5
# Recent changes
git log --oneline -5
```

**Architecture Discovery**:
- Identify primary languages, frameworks, and libraries
- Understand existing testing patterns and tools
- Discover build systems and conventions
- Map current component structure

### Phase 3: Test-First Implementation Strategy (Preferred Methodology)
**Note**: This methodology is preferred but optional. Use `--skip-tests` flag for projects without existing test infrastructure.

**Skeleton First**: Create minimal skeleton code and test files
**Write Failing Tests**: Write tests that fail for the correct reason
**Implement to Pass**: Write minimum production code to make all tests pass
**Refactor & Improve**: Clean up code while maintaining test coverage
**Repeat**: Continue TDD cycle for all functionality

### Phase 4: Implementation Execution & Orchestration
**Execute All Implementation**: All coding work is executed via well-defined subtasks using available tools (Edit, MultiEdit, Write)
**Subtask Boundaries**: Each subtask should be self-contained with clear objectives and success criteria
**Orchestrator Role**: Focus on systematic implementation, integration validation, testing, and quality review

## Code Quality and Best Practices

### Minimal Diffs
Make the smallest effective changes

### Evergreen Comments Only
Add comments explaining why, not what

### Security First
- Never introduce code that exposes or logs secrets and keys
- Never commit secrets or keys to the repository
- Follow security best practices in all implementations

### Follow Existing Conventions
- Mimic existing code style and patterns
- Use project's existing libraries and utilities
- Check package.json/dependencies before assuming library availability
- Match framework choice, naming conventions, and typing patterns

## Tooling Guidelines

### Project Build System
Use project's designated build system (check package.json scripts, Makefile, etc.)

### Code Search
Use fd for finding files
Use ripgrep (rg) for code search, not grep

### Language-Specific Tools
- **Java**: Use `./gradlew sL dL` for dependencies
- **Node.js**: Check package.json.
- **Python**: Look for requirements.txt, pyproject.toml, or Pipfile.

## Implementation Execution Template

```markdown
## 🚀 Implementation: [FEATURE_NAME]

### Requirements Analysis
- **Purpose**: [What and why]
- **Scope**: [Boundaries and limitations]
- **Success Criteria**: [Testable outcomes]

### Technical Design
- **Components**: [List key components and their responsibilities]
- **Dependencies**: [Files and systems that will be affected]
- **Integration Points**: [How components connect]

### Implementation Execution
#### Phase 1: Foundation Implementation (Parallel Tracks)
- [ ] **Track A**: [Backend/Core Logic Implementation]
  - Create/modify: [Specific files with actual code changes]
  - Tests: [Implement test files and strategies] *(if testing enabled)*
- [ ] **Track B**: [Frontend/Interface Implementation]
  - Create/modify: [UI components and related files with actual code]
  - Tests: [Implement component and integration tests] *(if testing enabled)*

#### Phase 2: Integration & Validation
- [ ] **Connect Components**: [Actually implement integration code]
- [ ] **End-to-End Testing**: [Run and validate full workflow] *(if testing enabled)*
- [ ] **Manual Validation**: [Perform manual testing steps] *(if testing disabled)*
- [ ] **Performance & Security Review**: [Code review and optimization]

### Quality Checkpoints
- [ ] Code formatting and linting pass
- [ ] Security scan clean (use tooling like NDex railguard if available)
- [ ] Code diff review completed
- [ ] All tests pass (unit, integration, e2e) *(if testing enabled)*
- [ ] Manual verification completed *(if testing disabled)*
- [ ] Documentation updated
```

## Implementation Checkpoints
At each major phase transition, verify:
- **After Analysis**: Requirements are clear and implementation tasks are well-defined
- **After Each Test**: Test fails for the right reason before coding *(if testing enabled)*
- **After Each Implementation**: Code works correctly and passes tests *(or manual validation if testing disabled)*
- **After Integration**: All components work together correctly
- **After Review**: Code quality standards are met and functionality is complete

## TodoWrite Integration
All implementations automatically generate structured todos using the TodoWrite tool:
- High-level implementation phases as major todos with high priority
- Individual coding subtasks as actionable items with medium priority
- Quality gates and testing as validation checkpoints with high priority
- Real-time status tracking (pending, in_progress, completed) as code is written

## Example Usage

```bash
# Implement with test-driven development (default)
/coding:implement "Add user authentication with JWT tokens"

# Implement without testing for legacy projects
/coding:implement --skip-tests "Add user authentication with JWT tokens"

# Implement a refactoring task
/coding:implement "Extract email service into separate module"

# Implement a bug fix without tests
/coding:implement --skip-tests "Fix memory leak in data processing pipeline"
```

## Risk Mitigation
- **Identify High-Risk Components**: Plan these for early implementation
- **Create Spike Solutions**: Prototype uncertain areas first
- **Plan Rollback Strategies**: Always have a way to revert changes
- **Incremental Delivery**: Break large features into smaller, deliverable chunks

This implementation framework ensures systematic, hands-on development while maintaining code quality and following project conventions, with flexibility for projects with or without existing test infrastructure.
