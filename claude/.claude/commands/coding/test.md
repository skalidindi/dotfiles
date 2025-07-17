---
description: Execute tests, identify failures, and fix issues until all tests pass
allowed-tools: Bash, Read, Edit, WebFetch
---

# 🧪 Test Execution & Fix Cycle

## Usage
`/coding:test`

## Arguments
- No arguments needed - automatically detects project test configuration
- Analyzes current codebase and runs appropriate test commands

## Your task
Execute the project's test suite, identify failures, fix them systematically, and repeat until all tests pass.

## Testing Philosophy
Your objective: Execute tests, identify failures, fix them, repeat until all tests pass.

## Context Discovery

### Step 1: Test Infrastructure Analysis
Analyze the project's testing setup:
```bash
# Project type and test configuration
fd --base-directory . '(package\.json|Cargo\.toml|pom\.xml|requirements\.txt|pytest\.ini|jest\.config\.)' --type f --no-ignore | head -5
# Test files and patterns
fd '(test|_test|Test)\.(js|ts|py|java|scala|go|rs)$' --type f | head -10
# Test scripts in package.json
cat package.json 2>/dev/null | grep -A 10 '"scripts"'
```

**Test Framework Detection**:
- **JavaScript/Node.js**: Jest, Vitest, Playwright
- **Python**: pytest, unittest, nose2
- **Java**: JUnit, TestNG, Gradle test
- **Rust**: cargo test
- **Go**: go test

### Step 2: Current Test Status
Get baseline test status:
```bash
# Check current git status for context
git status --porcelain
# Recent changes that might affect tests
git diff --name-only HEAD~1
```

## Execution Strategy

### Step 3: Test Execution
Run tests with appropriate commands and quiet flags to minimize output:

**Common Test Commands**:
```bash
# Node.js/JavaScript
npm test --silent
npm run test:unit --silent
yarn test --silent
npx jest --silent

# Python
pytest -q
python -m pytest --quiet
python -m unittest -q

# Java
./gradlew test --quiet
mvn test -q

# Rust
cargo test --quiet

# Go
go test -v ./... -short

# Make/Custom
make test
make test-quiet
```

### Step 4: Failure Analysis & Resolution
**Systematic Fix Approach**:

#### Step 4.1: Categorize Failures
**Test Failure Categories**:
- **Syntax Errors**: Code doesn't compile/parse
- **Unit Test Failures**: Individual function/method tests fail
- **Integration Test Failures**: Component interaction tests fail
- **Environment Issues**: Missing dependencies, configuration problems
- **Timing Issues**: Race conditions, async/await problems

#### Step 4.2: Fix Strategy
**Priority Order**:
1. **Syntax/Compilation Errors**: Fix these first (tests can't run)
2. **Import/Dependency Errors**: Resolve missing modules/packages
3. **Unit Test Failures**: Fix individual component logic
4. **Integration Failures**: Fix component interactions
5. **Flaky Tests**: Address timing and environment issues

#### Step 4.3: Subtask Orchestration
Use subtasks to preserve context during fixes:
- Each failing test becomes a subtask
- Fix one subtask at a time
- Re-run tests after each fix
- Track progress with TodoWrite tool

### Step 5: Fix Implementation
**Fix Workflow**:
```bash
# 1. Run tests to identify failures
[TEST_COMMAND] --silent

# 2. Analyze failure output
# Focus on first failure or most critical

# 3. Fix the issue
# Edit relevant files

# 4. Re-run tests
[TEST_COMMAND] --silent

# 5. Repeat until all pass
```

### Step 6: Validation & Cleanup
Final validation steps:
```bash
# Run full test suite one final time
[TEST_COMMAND]
# Check for any warnings or deprecated usage
# Verify no tests were accidentally disabled
```

## Fix Patterns

### Common Fix Strategies
**Syntax/Import Fixes**:
- Fix typos and syntax errors
- Add missing imports
- Update import paths
- Install missing dependencies

**Logic Fixes**:
- Correct algorithm implementations
- Fix off-by-one errors
- Handle edge cases properly
- Update assertions to match expected behavior

**Environment Fixes**:
- Set up test data/fixtures
- Configure test environment variables
- Mock external dependencies
- Fix file paths and resource loading

**Async/Timing Fixes**:
- Add proper await/async handling
- Fix Promise chains
- Add timeouts for long-running operations
- Handle race conditions

## Output Template

### Success Output
```markdown
✅ **All Tests Passing**

## Test Summary
- **Command**: [TEST_COMMAND]
- **Total Tests**: [NUMBER]
- **Passed**: [NUMBER]
- **Duration**: [TIME]

## Fixes Applied
- **Fixed [N] syntax errors**: [Brief description]
- **Resolved [N] unit test failures**: [Brief description]
- **Updated [N] integration tests**: [Brief description]

**Status**: All tests now pass ✅
```

### Failure Output
```markdown
❌ **Tests Still Failing**

## Current Status
- **Command**: [TEST_COMMAND]
- **Total Tests**: [NUMBER]
- **Passed**: [PASSED_NUMBER]
- **Failed**: [FAILED_NUMBER]

## Remaining Failures
1. **[Test Name]**: [Error description]
2. **[Test Name]**: [Error description]

## Next Steps
- [ ] Fix [specific issue]
- [ ] Address [specific problem]
- [ ] Re-run tests

**Status**: Manual intervention may be required
```

## Tooling Guidelines

### Use Project's Test Commands
Always check project configuration first:
```bash
# Check package.json scripts
cat package.json | jq '.scripts'
# Check Makefile
cat Makefile 2>/dev/null | grep test
# Check CI configuration
cat .github/workflows/*.yml 2>/dev/null | grep -i test
```

### Quiet Mode Preference
Use quiet/silent flags to minimize output:
- `--quiet`, `--silent`, `-q` flags
- Focus on failures, not verbose success output
- Only show full output when debugging specific failures

### Preserve Context
- Use subtasks for each fix to maintain context
- Document what was changed and why
- Keep fixes minimal and focused

## Code Quality Integration

### Pre-Test Checks
Before running tests, ensure:
- Code compiles/parses successfully
- All dependencies are installed
- Environment is properly configured

### Post-Test Validation
After all tests pass:
- Run linting if available (`npm run lint`, `flake8`, etc.)
- Check code formatting (`prettier`, `black`, etc.)
- Verify no console warnings or deprecation notices

### Security Considerations
- Never commit or expose secrets in test fixes
- Don't disable security-related tests
- Maintain test isolation and cleanup

## Example Usage

```bash
# Run tests and fix failures
/coding:test

# The command will:
# 1. Detect test framework and commands
# 2. Run the test suite
# 3. Identify and categorize failures
# 4. Systematically fix each failure
# 5. Re-run tests until all pass
```

## Error Handling

### No Tests Found
```markdown
⚠️ **No Test Infrastructure Detected**

**Issue**: No test files or test commands found
**Possible Solutions**:
- Check if tests exist in non-standard locations
- Verify test dependencies are installed
- Create basic test setup if needed

**Recommendation**: Consider adding tests for better code quality
```

### Test Command Failures
```markdown
❌ **Test Command Failed**

**Issue**: Test runner itself failed to execute
**Common Causes**:
- Missing dependencies (`npm install`, `pip install -r requirements.txt`)
- Incorrect Node.js/Python version
- Environment configuration issues

**Next Steps**: Resolve environment issues before running tests
```

## Integration Notes

### TodoWrite Integration
Automatically creates todos for:
- Each failing test as a separate task
- Categories of failures (syntax, logic, environment)
- Post-test cleanup and validation tasks

### Git Integration
Considers current changes:
- Tests modified files first
- Provides context about recent changes
- Suggests relevant test files to check

This testing framework ensures systematic identification and resolution of test failures while maintaining code quality and following project conventions.
