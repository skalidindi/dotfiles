---
description: Analyze git changes, stage files, create intelligent commit
allowed-tools: Bash(git:*)
---

# 📝 Git Diff, Add, & Commit

## Usage
`/git:commit`

## Arguments
- No arguments needed - analyzes current git state and conversation context

## Your task
You are a Git workflow specialist. Your mission is to analyze current changes, stage appropriate files, create an intelligent commit message

## Context Analysis
- Current git status: !`git status --porcelain`
- Current branch: !`git branch --show-current`
- Unstaged changes: !`git diff --name-only`
- Staged changes: !`git diff --cached --name-only`
- Recent commits: !`git log --oneline -3`

## Execution Steps

### Step 1: Analyze Current Git State
Gather comprehensive git information:
- **Working Directory Status**: Parse `git status --porcelain` output
- **Current Branch**: Extract from `git branch --show-current`
- **Unstaged Changes**: List files with modifications
- **Staged Changes**: List files already staged
- **Untracked Files**: Identify new files

### Step 2: Analyze File Changes
For each modified file, analyze the changes:
```bash
# Get detailed diff for each file
git diff [filename]
git diff --cached [filename]  # For staged files
```

**Change Analysis**:
- **File Type**: Identify file extensions and purposes
- **Change Scope**: Determine if changes are minor fixes, features, or major refactors
- **Business Impact**: Assess significance of changes
- **Related Files**: Group related changes together

### Step 3: Intelligent File Staging
Stage files based on analysis:

**Auto-Stage Categories**:
- Source code files with logical changes
- Configuration files with updates
- Documentation updates
- Test files with new tests

**Skip Categories**:
- Temporary files (*.tmp, *.log, *.cache)
- IDE-specific files (.vscode/, .idea/)
- Build artifacts (dist/, build/, node_modules/)
- Sensitive files (.env, *.key, *.secret)

**Staging Strategy**:
```bash
# Stage specific files based on analysis
git add [analyzed-files]

# Or stage all appropriate files
git add .
```

### Step 4: Generate Intelligent Commit Message
Create commit message following conventional commit format but with emojis:

**Message Structure**:
```
<type>(<scope>): <emoji><description>

<body>

<footer>
```

**Commit Types**:
- `feat: ✨` New feature
- `fix: 🐛` Bug fix
- `docs: 📝` Documentation changes
- `style: 💅` Code style changes
- `refactor: ♻️` Code refactoring
- `test: 🚦` Test additions/modifications
- `chore: 🔧` Maintenance tasks

**Message Generation Logic**:
- Analyze file changes to determine primary type
- Extract scope from file paths or conversation context
- Create concise but descriptive subject line
- Add detailed body for complex changes
- Include breaking change notes if applicable

### Step 5: Create Commit
Execute git commit with generated message:
```bash
git commit -m "$COMMIT_MESSAGE"
```

### Step 6: Process Results
If all operations are successful:

```markdown
✅ **Git Changes Committed Successfully**

## Commit Information
- **Branch**: [CURRENT_BRANCH]
- **Commit Hash**: [COMMIT_HASH]
- **Message**: [COMMIT_MESSAGE]
- **Files Changed**: [NUMBER] files

## Files Modified
[LIST_OF_MODIFIED_FILES]

## Change Summary
**Type**: [COMMIT_TYPE]
**Scope**: [COMMIT_SCOPE]
**Description**: [CHANGE_DESCRIPTION]

**Status**: All changes committed
```

If operations fail:

```markdown
❌ **Git Operation Failed**

## Error Details
- **Operation**: [FAILED_OPERATION]
- **Branch**: [CURRENT_BRANCH]
- **Error**: [ERROR_MESSAGE]

## Possible Issues
- Merge conflicts need resolution
- Network connectivity issues
- Authentication problems

## Troubleshooting Steps
1. Check git status: `git status`
2. Resolve any merge conflicts
4. Check authentication: `git config --list | grep user`
5. Pull latest changes: `git pull origin [BRANCH]`

**Status**: Manual intervention required
```

## Example Usage

```bash
# Analyze, stage, and commit
/git:commit

# The command will:
# 1. Analyze current git state
# 2. Stage appropriate files
# 3. Generate intelligent commit message
# 4. Commit changes
```

## Example Output

```markdown
✅ **Git Changes Committed Successfully**

## Commit Information
- **Branch**: sk/feature-add-db
- **Commit Hash**: 1a502dd
- **Message**: feat(data): ✨ add postgres db
- **Files Changed**: 5 files

## Files Modified
- client/src/components/pokemon.ts
- server/src/api/db.ts

## Change Summary
**Type**: feat (new feature)
**Scope**: db (Add postgres db)
**Description**: Added support to talk to postgres db and created a UI component to fetch data from it

**Status**: All changes committed
```

## Features

### Intelligent Change Analysis
- Analyzes file types and change patterns
- Groups related changes logically
- Identifies change scope and business impact
- Generates contextual commit messages

### Smart File Staging
- Automatically stages relevant files
- Skips temporary and build artifacts
- Handles untracked files appropriately
- Respects .gitignore patterns

### Conventional Commit Messages
- Follows conventional commit format
- Determines appropriate commit type
- Extracts scope from file paths
- Creates descriptive subject lines
- Adds detailed body for complex changes

### Comprehensive Error Handling
- Detects merge conflicts
- Provides clear troubleshooting steps
- Suggests resolution strategies

## Prerequisites

### Required Tools
- **Git**: Repository must be initialized

### Repository Requirements
- Working directory must be a git repository
- No unresolved merge conflicts

## Integration Notes
This command integrates with:
- `/git:create-pr` - Create a pull request before pushing to a remote branch

## Advanced Features

### Selective Staging
The command intelligently stages files based on:
- File extensions and types
- Change significance
- Conversation context
- Project structure patterns

### Commit Message Intelligence
Generates commit messages by:
- Analyzing file change patterns
- Extracting business context from conversation
- Following team conventions
- Including relevant scope information

## Error Handling

### Merge Conflicts
```markdown
❌ **Merge Conflicts Detected**

- **Files**: [CONFLICTED_FILES]
- **Status**: Manual resolution required

**Resolution Steps**:
1. Open conflicted files in editor
2. Resolve conflict markers (<<<<<<< ======= >>>>>>>)
3. Stage resolved files: `git add [files]`
4. Continue with commit: `git commit`
```
