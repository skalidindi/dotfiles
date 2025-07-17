---
description: Load and resume work on an existing project with full context restoration
allowed-tools: Read
---

# 🔄 Project Load & Resume

## Usage
`/project:load [project-name]`

## Arguments
- Optional: Specific project name to load
- If no argument provided, will list available projects for selection
- Automatically restores project context and prepares for work continuation

## Your task
Load and resume work on an existing project. Ensure complete context understanding before beginning work.

**Your objective:** Seamlessly resume project work with full context and clear next steps.

## Context Discovery

### Step 1: Project Discovery
Identify available projects for loading:
```bash
# List active projects
ls -la ~/.projects/*.md 2>/dev/null | grep -v archive
# List archived projects if needed
ls -la ~/.projects/archive/*.md 2>/dev/null
# Show recent activity
ls -lt ~/.projects/*.md 2>/dev/null | head -5
```

### Step 2: Project Selection
**Project Identification Strategy**:
- **If user specifies project**: Match by name or partial name
- **If no project specified**: List available projects with brief descriptions
- **Smart matching**: Match project names by keywords or dates
- **Context hints**: Show recent projects or projects related to current directory

## Loading Process

### Step 3: Project Document Analysis
Read and analyze the selected project document:
```bash
# Load the project document
cat ~/.projects/[project-file].md
# Check file modification date
ls -la ~/.projects/[project-file].md
# Verify git context if project is in a repository
git status --porcelain 2>/dev/null
```

### Step 4: Context Summary Creation
Read the project document and provide comprehensive summary:

```markdown
## 📋 Project Loaded: [PROJECT_NAME]

### Project Overview
- **Main Goal**: [Primary objective from project document]
- **Project Type**: [Feature development/Bug fix/Refactoring/etc.]
- **Created**: [Original project creation date]
- **Last Updated**: [Last modification date of project file]

### Current Status Summary
**Where We Left Off**:
[Concise summary of current project state from status section]

**Progress Made**:
- ✅ [Completed goals/tasks with checkmarks]
- ✅ [Other finished work]

**Remaining Work**:
- [ ] [Uncompleted tasks from project document]
- [ ] [Other pending items]

### Immediate Next Steps
**High Priority Tasks**:
1. [Most important next task from project task list]
2. [Second priority task]
3. [Third priority task if applicable]

**Suggested Starting Point**: [Recommended first task to tackle]

### Key Context
**Important Files**:
- [`filename.ext`](./path) - [Purpose from project references]
- [`other-file.js`](./src/other.js) - [Role in project]

**External References**:
- [Documentation links from project]
- [API or resource references]

**Technical Notes**:
[Any important technical context from project document]
```

### Step 5: Environment Verification
**Project Setup Validation**:
```bash
# Check if referenced files still exist
for file in [referenced-files]; do
  if [ -f "$file" ]; then
    echo "✅ $file exists"
  else
    echo "❌ $file missing"
  fi
done

# Test mentioned commands or tools
[command-from-project] --version 2>/dev/null || echo "⚠️ Command not available"

# Verify git repository state if applicable
git branch --show-current 2>/dev/null
git status --porcelain 2>/dev/null
```

**Reference Validation**:
- Check that file paths in project document are still valid
- Verify line number references point to relevant code
- Test external links for accessibility
- Flag any broken references that need updating

### Step 6: Context Clarification
**Targeted Clarification Questions**:
Based on project analysis, ask specific questions about:

**Priority and Focus**:
- "Has the priority of [specific task] changed since last session?"
- "Are we still focusing on [main goal] or have requirements shifted?"
- "Which of these next tasks should we tackle first: [list options]?"

**Context Updates**:
- "Have there been any changes to [specific requirement/constraint]?"
- "Is the approach for [technical decision] still the right one?"
- "Are there any new requirements or constraints I should know about?"

**Environment Changes**:
- "Are all the file references still accurate?"
- "Have any of the external dependencies or APIs changed?"
- "Should we update any of the technical assumptions?"

## Pre-Work Validation

### Ready to Begin Criteria
Before starting work, confirm:
- [ ] Project goal and current status are crystal clear
- [ ] Next task is identified and well-understood
- [ ] All required files and tools are accessible
- [ ] Any changes since last session are incorporated
- [ ] User has confirmed priority and approach
- [ ] File references have been validated
- [ ] External dependencies are still available

### Context Completeness Check
Ensure understanding of:
- [ ] **What** needs to be built or fixed
- [ ] **Why** this work is important
- [ ] **How** the solution should be approached
- [ ] **Where** the relevant code and files are located
- [ ] **When** this work needs to be completed

## Load Output Templates

### Successful Project Load
```markdown
✅ **Project Successfully Loaded**

## Project: [PROJECT_NAME]
- **Status**: [Current project status]
- **Last Activity**: [Date of last update]
- **Progress**: [X] of [Y] goals completed

## Current Context
**We're working on**: [Main current focus]
**Next up**: [Immediate next task]
**Key files**: [Most important files for current work]

## Environment Status
- ✅ All referenced files accessible
- ✅ Required tools available
- ✅ Git repository in expected state

## Ready to Continue
**Suggested starting point**: [Specific task recommendation]
**Estimated effort**: [Time estimate if available]

**Project context fully loaded - ready to begin work** 🚀
```

### Project Load with Issues
```markdown
⚠️ **Project Loaded with Validation Issues**

## Project: [PROJECT_NAME]
- **Status**: [Current project status]
- **Last Activity**: [Date of last update]

## Context Summary
[Brief summary of project state]

## Issues Found
- ❌ **Missing file**: `path/to/file.ext` (referenced in project)
- ⚠️ **Outdated reference**: Line numbers may have changed
- ❌ **Tool unavailable**: [specific tool] not found

## Recommended Actions
1. Update file references in project document
2. Verify external dependencies are still available
3. Resolve missing files or update project scope

**Manual fixes needed before continuing work**
```

### Project Selection Required
```markdown
📂 **Available Projects for Loading**

## Active Projects
1. **[Project Name 1]** - Last updated [date]
   - Goal: [Brief goal summary]
   - Status: [Current status]

2. **[Project Name 2]** - Last updated [date]
   - Goal: [Brief goal summary]
   - Status: [Current status]

## Recently Archived
3. **[Archived Project]** - Archived [date]
   - Goal: [Brief goal summary]
   - Status: [Final status]

**Please specify which project to load, or use project number**
```

## Advanced Loading Features

### Smart Project Detection
Automatically suggest relevant projects:
- **Directory Context**: Match projects to current working directory
- **Recent Activity**: Prioritize recently modified projects
- **Keyword Matching**: Find projects by feature or technology keywords
- **Git Branch Context**: Match projects to current git branch

### Context Preservation
Maintain session continuity:
- **Working Memory**: Remember key decisions and context between sessions
- **State Restoration**: Recreate the mental model from last session
- **Priority Alignment**: Ensure current priorities match project goals
- **Assumption Validation**: Verify technical assumptions are still valid

### Progressive Context Loading
Load context incrementally:
- **Core Context**: Essential project information first
- **Detailed Context**: Deeper technical details as needed
- **Historical Context**: Background decisions and evolution if relevant
- **Environmental Context**: Current state of files, tools, and dependencies

## Integration Guidelines

### TodoWrite Integration
Seamlessly transition from project context to active work:
- **Task Translation**: Convert project tasks to TodoWrite items
- **Priority Mapping**: Maintain task priorities from project document
- **Progress Sync**: Align TodoWrite completion with project progress
- **Session Planning**: Use project context to plan TodoWrite tasks

### Git Workflow Integration
Align project loading with git state:
- **Branch Context**: Understand relationship between project and current branch
- **Commit History**: Reference recent commits that relate to project work
- **Change Detection**: Identify uncommitted work that relates to project
- **Merge Context**: Understand any pending merges or conflicts

### Development Environment
Prepare environment for project work:
- **Dependency Check**: Verify all required packages and tools
- **Configuration Validation**: Ensure project-specific settings are correct
- **Service Availability**: Check external services or APIs are accessible
- **Permission Verification**: Confirm access to required resources

## Example Usage

```bash
# Load a specific project
/project:load "user-authentication-system"

# Interactive project selection
/project:load

# Load with partial name matching
/project:load "auth"

# The command will:
# 1. Identify and load the specified project
# 2. Analyze current project state and context
# 3. Validate environment and file references
# 4. Provide clear summary and next steps
# 5. Ask clarifying questions if needed
# 6. Confirm readiness to begin work
```

## Error Handling

### Project Not Found
```markdown
❌ **Project Not Found**

**Search term**: "[user-input]"
**Available projects**:
[List of projects with partial name matches]

**Suggestions**:
- Check project name spelling
- Try partial name matching
- Use `/project:load` without arguments to see all projects
```

### Corrupted Project File
```markdown
⚠️ **Project File Issues Detected**

**Project**: [project-name]
**Issues**: [Specific problems found]

**Recovery Options**:
1. Attempt to repair project file
2. Load from backup if available
3. Recreate project from current context

**Manual intervention may be required**
```

This project loading framework ensures seamless work resumption with complete context restoration, environment validation, and clear next steps for continued development work.
