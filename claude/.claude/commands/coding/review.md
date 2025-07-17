---
description: Comprehensive automated code review with intelligent analysis
allowed-tools: Bash(mkdir:*), Bash(rg:*), Bash(cd:*), Bash(fd:*), Bash(ls:*), Read, Edit, WebFetch
---

# 🔍 Automated Code Review

## Usage
`/coding:review`

## Arguments
- No arguments needed - analyzes current git state and conversation context

## Your task
You are a comprehensive code review specialist. Your mission is to analyze code changes, detect issues, suggest improvements, and ensure code quality standards.

## Context Analysis
- Current git status: !`git status --porcelain`
- Current branch: !`git branch --show-current`
- Unstaged changes: !`git diff --name-only`
- Staged changes: !`git diff --cached --name-only`
- Recent commits: !`git log --oneline -5`

## Execution Steps

### Step 1: Repository State Analysis
Gather comprehensive git information:
- **Working Directory Status**: Parse `git status --porcelain` output
- **Current Branch**: Extract from `git branch --show-current`
- **Change Summary**: Get statistical overview with `git diff --shortstat`
- **Modified Files**: List all changed files
- **Quality Check**: Run `git diff --check` for whitespace issues

### Step 2: Change Impact Analysis
For each modified file, analyze the changes:
```bash
# Get detailed diff for each file
git diff [filename]
git diff --cached [filename]  # For staged files
```

**Change Classification**:
- **File Type**: Identify file extensions and purposes
- **Change Scope**: Minor fixes, features, refactors, or breaking changes
- **Business Impact**: Critical, moderate, or low impact
- **Complexity**: Simple, moderate, or complex changes
- **Test Coverage**: Related test changes or missing tests

### Step 3: Code Quality Assessment
Perform comprehensive code analysis:

**Security Review**:
- Authentication and authorization checks
- Input validation and sanitization
- SQL injection prevention
- XSS vulnerability assessment
- Sensitive data exposure risks

**Performance Analysis**:
- Algorithm efficiency
- Database query optimization
- Memory usage patterns
- Network request optimization
- Caching opportunities

**Maintainability Review**:
- Code complexity and readability
- Naming conventions
- Function/class size and responsibility
- Code duplication
- Documentation completeness
- Maintain existing code style and patterns

### Step 4: Best Practices Validation
Check adherence to coding standards:

**Style Consistency**:
- Indentation and formatting
- Naming conventions
- Comment quality and placement
- File organization
- Import/dependency management

**Architecture Patterns**:
- SOLID principles compliance
- Design pattern usage
- Separation of concerns
- Error handling strategies
- Logging and monitoring

### Step 5: Test Quality Review
Analyze test coverage and quality:
```bash
# Check for test files related to changes
fd '(test|spec)\.(js|ts|py|java|scala|go|rs)$'
```

**Test Assessment**:
- Unit test coverage for new code
- Integration test requirements
- Edge case coverage
- Test naming and clarity
- Mock usage appropriateness

### Step 6: Generate Review Report
Create comprehensive review report and save the output to a file

## Example Usage

```bash
# Perform comprehensive code review
/coding:review

# The command will:
# 1. Analyze current git state
# 2. Review all code changes
# 3. Check quality and security
# 4. Validate best practices
# 5. Generate detailed report
```

## Example Output

```markdown
🔍 **Code Review Complete**

## Review Summary
- **Branch**: feature/user-authentication
- **Files Changed**: 8 files
- **Lines Added**: 234
- **Lines Deleted**: 67
- **Overall Quality**: 9/10

## Files Reviewed
### ✅ High Quality
- `src/auth/login.ts` - Well structured authentication logic
- `src/utils/validation.ts` - Comprehensive input validation

### ⚠️ Needs Attention
- `src/api/users.ts:45` - Missing error handling for database queries
- `src/components/UserForm.tsx:123` - Consider memoizing expensive calculations

### ❌ Issues Found
- `src/auth/password.ts:67` - Potential security vulnerability: plaintext password logging

## Security Assessment
**Status**: ⚠️ Minor Issues Found
- **Critical**: 0 issues
- **High**: 1 issue (password logging)
- **Medium**: 2 issues (input validation gaps)
- **Low**: 3 issues (timing attack vectors)

## Performance Analysis
**Status**: ✅ Good Performance
- Database queries optimized
- Proper caching implemented
- No N+1 query patterns detected
- Memory usage within acceptable limits

## Test Coverage
**Status**: ⚠️ Needs Improvement
- **Unit Tests**: 78% coverage (target: 85%)
- **Integration Tests**: Present and comprehensive
- **Missing Tests**: Password reset functionality
- **Test Quality**: High - clear and focused tests

## Recommendations
1. **Immediate**: Fix password logging security issue
2. **Short-term**: Add unit tests for password reset
3. **Long-term**: Implement rate limiting for auth endpoints
4. **Consider**: Migrating to newer authentication library

**Overall Assessment**: Ready for merge after addressing security issue
```

## Features

### Intelligent Code Analysis
- Multi-layered security vulnerability detection
- Performance bottleneck identification
- Code smell and anti-pattern recognition
- Technical debt assessment

### Quality Metrics
- Cyclomatic complexity analysis
- Code duplication detection
- Maintainability index calculation
- Test coverage analysis

### Best Practices Enforcement
- Style guide compliance checking
- Architecture pattern validation
- Documentation completeness review
- Error handling assessment

### Comprehensive Reporting
- Prioritized issue lists with severity levels
- File-specific recommendations
- Statistical code quality metrics
- Actionable improvement suggestions

## Prerequisites

### Required Tools
- **Git**: Repository must be initialized
- **Code Analysis Tools**: Language-specific linters and analyzers

### Repository Requirements
- Working directory must be a git repository
- Code changes should be committed or staged
- Project should have established coding standards

## Integration Notes
This command integrates with:
- `/git:commit` - Review code before committing
- `/coding:refactor` - Apply suggested improvements
- `/coding:test` - Add missing test coverage

## Advanced Features

### Language-Specific Analysis
The command provides specialized analysis for:
- **JavaScript/TypeScript**: ESLint rules, type safety, async patterns
- **Python**: PEP 8 compliance, security best practices, performance patterns
- **Java**: Code conventions, design patterns, memory management
- **Go**: Idiomatic Go patterns, error handling, concurrency safety
- **Rust**: Ownership patterns, unsafe code usage, performance optimization

### Security Deep Dive
Advanced security analysis includes:
- OWASP Top 10 vulnerability scanning
- Dependency vulnerability assessment
- Secrets and credentials detection
- Privacy and data protection compliance

### Performance Profiling
Comprehensive performance analysis covers:
- Big O complexity estimation
- Database query optimization opportunities
- Caching strategy effectiveness
- Memory leak potential detection

## Error Handling

### Merge Conflicts
```markdown
❌ **Merge Conflicts Detected**

- **Files**: [CONFLICTED_FILES]
- **Status**: Review blocked - resolve conflicts first

**Resolution Steps**:
1. Resolve merge conflicts in affected files
2. Stage resolved files: `git add [files]`
3. Re-run code review: `/coding:review`
```

### Missing Dependencies
```markdown
⚠️ **Analysis Tools Missing**

- **Missing**: [TOOL_NAME]
- **Impact**: Limited analysis capabilities

**Installation**:
```bash
# Install required tools
npm install -g eslint   # For JavaScript projects
uv tool install ruff    # For Python projects
```

### Large Changesets
```markdown
📊 **Large Changeset Detected**

- **Files Changed**: 50+ files
- **Recommendation**: Consider breaking into smaller reviews

**Suggested Approach**:
1. Review critical/security changes first
2. Group related changes by feature
3. Use incremental review process
```
