---
description: Synchronize project document with actual progress and current state for accurate tracking
allowed-tools: Bash(mkdir:*), Bash(rg:*), Bash(cd:*), Bash(fd:*), Bash(ls:*), Read, Edit
---

# 🔄 Project Status Update

## Usage
`/project:update [project-name]`

## Arguments
- Optional: Specific project name to update
- If no argument provided, will update the most recently active project
- Automatically synchronizes project document with current reality

## Your task
Perform an explicit status update on the current project document, ensuring it reflects current reality.

**Your objective:** Synchronize project document with actual progress and current state for accurate tracking.

## Context Discovery

### Step 1: Project Identification
Identify which project to update:
```bash
# Find most recently modified project if none specified
ls -t ~/.projects/*.md 2>/dev/null | head -1
# List active projects for selection
ls -la ~/.projects/*.md 2>/dev/null | grep -v archive
# Check current directory context for project hints
pwd && basename $(pwd)
```

### Step 2: Current Project Analysis
Load and analyze the current project document:
```bash
# Read the project document
cat ~/.projects/[project-file].md
# Check last modification time
ls -la ~/.projects/[project-file].md
# Get current git context
git status --porcelain 2>/dev/null
git log --oneline -5 2>/dev/null
```

## Update Process

### Step 3: Current Project State Assessment
**Read Current Project Document**:
- Load the active project document completely
- Review current status section and last update information
- Analyze task list and goal completion states
- Note last update date and any recent changes
- Identify sections that may need updates

**Document Analysis Summary**:
```markdown
## 📊 Current Project Analysis

### Project Overview
- **Name**: [Project name from document]
- **Last Updated**: [File modification date]
- **Status Section**: [Current status summary]
- **Goals Progress**: [X completed of Y total goals]
- **Tasks Progress**: [X completed of Y total tasks]

### Document Health Check
- **File References**: [Number of file references to validate]
- **External Links**: [Number of external references]
- **Changelog Entries**: [Number of changelog items]
- **Last Session**: [When was last work session]
```

### Step 4: Actual State Assessment
**File System Reality Check**:
```bash
# Check if all referenced files still exist
grep -E '\[`[^`]+`\]\([^)]+\)' ~/.projects/[project-file].md | while read ref; do
  file_path=$(echo "$ref" | sed -E 's/.*\]\(([^)]+)\).*/\1/' | cut -d':' -f1)
  if [ -f "$file_path" ]; then
    echo "✅ $file_path exists"
  else
    echo "❌ $file_path missing"
  fi
done

# Review git status for uncommitted changes
git status --porcelain 2>/dev/null
git diff --name-only 2>/dev/null

# Check for new files that might be relevant
find . -name "*.js" -o -name "*.ts" -o -name "*.py" -o -name "*.java" -newer ~/.projects/[project-file].md 2>/dev/null | head -10
```

**Reality vs Documentation Gap Analysis**:
- **File System Changes**: Compare referenced files with actual file system
- **Git Repository State**: Check for uncommitted work or new commits
- **Task Completion Evidence**: Look for completed work not yet documented
- **New Discoveries**: Identify new files or changes since last update

### Step 5: Document Section Updates

#### Current Status Update
**Status Section Refresh**:
```markdown
## Current Status Update

### Previous Status
[What the document currently says]

### Actual Current State
[What's really happening now based on analysis]

### Status Update Needed
- **Work Progress**: [Recent accomplishments to document]
- **Current Focus**: [What's actively being worked on]
- **Blockers**: [Any current obstacles or dependencies]
- **Next Session**: [What should happen next]
```

#### Task List Synchronization
**Task Status Verification**:
- **Completed Tasks**: Check off tasks that have been finished
- **New Tasks**: Add tasks discovered during recent work
- **Updated Priorities**: Reorder tasks based on current priorities
- **Obsolete Tasks**: Remove or archive tasks no longer relevant
- **Task Details**: Update task descriptions with current understanding

#### File References Validation
**Reference Accuracy Check**:
- **File Path Verification**: Ensure all file paths are correct and accessible
- **Line Number Updates**: Update line numbers if code has shifted
- **New File References**: Add references to important new files
- **Dead Link Removal**: Remove references to deleted or moved files
- **Description Updates**: Update file descriptions to reflect current purpose

#### Changelog Management
**Changelog Entry Addition**:
```markdown
### New Changelog Entry
- **[Current Date]**: [Concise summary of significant changes made]
  - [Specific accomplishment or change]
  - [Another important update]
  - [Technical decision or discovery]
```

### Step 6: Document Update Execution
**Systematic Document Updates**:
```bash
# Create backup of current project document
cp ~/.projects/[project-file].md ~/.projects/[project-file].md.backup

# Apply updates using Edit tool for each section:
# 1. Update "Current Status" section
# 2. Synchronize task checkboxes and add new tasks
# 3. Update file references and line numbers
# 4. Add changelog entry with current date
# 5. Update last modified timestamp
```

### Step 7: Update Quality Validation
**Pre-Finalization Quality Check**:
- [ ] All completed work is properly documented in tasks and status
- [ ] Task list accurately reflects remaining work priorities
- [ ] File references are current, correct, and accessible
- [ ] Status description matches actual current state
- [ ] Changelog entry captures significant changes since last update
- [ ] User can resume work seamlessly from updated document

## Update Output Templates

### Successful Update
```markdown
✅ **Project Document Successfully Updated**

## Update Summary
- **Project**: [PROJECT_NAME]
- **Previous Update**: [Previous modification date]
- **Current Update**: [Current timestamp]

## Changes Made
### Status Updates
- **Previous**: [Previous status summary]
- **Current**: [Updated status summary]

### Task Progress
- ✅ **Completed**: [Number] tasks marked as finished
- 📝 **Added**: [Number] new tasks discovered
- 🔄 **Updated**: [Number] tasks modified or reprioritized
- 🗑️ **Removed**: [Number] obsolete tasks cleaned up

### Reference Updates
- ✅ **Verified**: [Number] file references validated
- 📝 **Added**: [Number] new file references
- 🔄 **Updated**: [Number] references with corrected paths/lines
- ❌ **Fixed**: [Number] broken references resolved

### Documentation Health
- **Changelog**: New entry added for [current date]
- **File References**: [Total] references, [valid] accessible
- **Task Completion**: [X] of [Y] goals completed

**Project document synchronized with current reality** 🎯
```

### Update with Issues Found
```markdown
⚠️ **Project Updated with Issues Detected**

## Update Summary
- **Project**: [PROJECT_NAME]
- **Update Status**: Completed with warnings

## Issues Found and Resolved
### File Reference Issues
- ❌ **Missing Files**: [List of missing referenced files]
- 🔄 **Updated Paths**: [Files that were moved or renamed]
- ⚠️ **Line Number Shifts**: [References with outdated line numbers]

### Task Synchronization Issues
- 🔄 **Status Mismatches**: [Tasks marked wrong in document vs reality]
- 📝 **Undocumented Work**: [Completed work not reflected in tasks]
- ❓ **Unclear Tasks**: [Tasks that need clarification]

## Recommendations
1. **File Management**: [Specific recommendations for file issues]
2. **Task Cleanup**: [Suggestions for task list improvements]
3. **Documentation**: [Areas needing better documentation]

**Update completed - manual review recommended for flagged issues**
```

### No Updates Needed
```markdown
✅ **Project Document Already Current**

## Validation Results
- **Project**: [PROJECT_NAME]
- **Last Updated**: [Modification date]
- **Validation Date**: [Current timestamp]

## Status Check
- ✅ **Task Status**: All task states match current reality
- ✅ **File References**: All references are valid and accessible
- ✅ **Status Accuracy**: Current status reflects actual state
- ✅ **Recent Activity**: No significant changes since last update

## Project Health
- **Goals Progress**: [X] of [Y] completed
- **Task Completion**: [X] of [Y] tasks finished
- **Reference Integrity**: [All/Most] references accessible

**No updates required - project document is current** 📋
```

## Advanced Update Features

### Intelligent Change Detection
**Smart Update Identification**:
- **Git Integration**: Detect changes based on recent commits
- **File Timestamp Analysis**: Identify modified files since last project update
- **Task Pattern Recognition**: Automatically detect completed work patterns
- **Reference Validation**: Systematic checking of all project references

### Automated Synchronization
**Semi-Automated Updates**:
- **Task Completion Detection**: Automatically check off obviously completed tasks
- **File Reference Updates**: Update line numbers based on current file content
- **Status Inference**: Suggest status updates based on recent activity
- **Priority Adjustment**: Recommend task priority changes based on recent focus

### Update History Tracking
**Change Audit Trail**:
- **Update Frequency**: Track how often projects are updated
- **Change Patterns**: Identify common types of updates needed
- **Accuracy Metrics**: Monitor how well documents stay synchronized
- **Maintenance Insights**: Learn from update patterns to improve process

## Integration Guidelines

### Git Workflow Integration
**Version Control Alignment**:
- **Commit-Based Updates**: Trigger updates based on significant commits
- **Branch Context**: Update project context when switching branches
- **Merge Documentation**: Document integration work in project updates
- **Release Milestones**: Major updates for version releases

### TodoWrite Integration
**Active Work Synchronization**:
- **Session Completion**: Update project docs when TodoWrite sessions complete
- **Task Translation**: Sync completed TodoWrite items to project tasks
- **Priority Alignment**: Ensure project priorities match active work priorities
- **Progress Continuity**: Maintain continuity between active and long-term tracking

### Development Environment
**Environment-Aware Updates**:
- **Tool Validation**: Check that referenced tools and commands still work
- **Dependency Updates**: Note changes in project dependencies
- **Configuration Changes**: Document environment or configuration updates
- **Service Status**: Validate external services and APIs still accessible

## Example Usage

```bash
# Update most recent project
/project:update

# Update specific project
/project:update "user-authentication-system"

# Update with partial name match
/project:update "auth"

# The command will:
# 1. Load and analyze the current project document
# 2. Assess actual current state vs documented state
# 3. Update all sections to reflect reality
# 4. Validate references and fix broken links
# 5. Add changelog entry for the update
# 6. Confirm synchronization is complete
```

## Error Handling

### Project Not Found
```markdown
❌ **Project Update Failed - Not Found**

**Issue**: No project matches the specified criteria
**Search Context**: [What was searched for]

**Available Projects**:
[List of current projects with last update dates]

**Suggestions**:
- Specify exact project name
- Use partial name matching
- Check if project was archived
```

### File Permission Issues
```markdown
⚠️ **Update Partially Completed**

**Issue**: Cannot write to project document
**Project**: [PROJECT_NAME]
**Error**: [Specific permission or file system error]

**Resolution Steps**:
1. Check file permissions on project document
2. Verify ~/.projects/ directory is writable
3. Ensure no other process has file locked

**Manual intervention required**
```

This project update framework ensures systematic synchronization between project documentation and actual development progress, maintaining accurate project tracking across long-term development work.
