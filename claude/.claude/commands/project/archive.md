---
description: Archive completed or paused projects with proper documentation for future reference
allowed-tools: Bash(mkdir:*), Bash(rg:*), Bash(cd:*), Bash(fd:*), Bash(ls:*), Read, Edit
---

# 📦 Project Archive Management

## Usage
`/project:archive [project-name]`

## Arguments
- Optional: Specific project name to archive
- If no argument provided, will help select from active projects
- Automatically creates archive summary and moves to archive directory

## Your task
Archive a completed or paused project with proper documentation for future reference.

**Your objective:** Cleanly archive projects with complete outcome documentation and easy retrieval.

## Context Discovery

### Step 1: Project Identification
Identify which project to archive:
```bash
# List active projects for selection
ls -la ~/.projects/*.md 2>/dev/null | grep -v archive
# Check current working directory for project context
pwd && basename $(pwd)
# Look for project references in recent git history
git log --oneline -10 2>/dev/null | head -5
```

### Step 2: Project Validation
Confirm the correct project:
```bash
# Read project document header
head -20 ~/.projects/[project-file].md 2>/dev/null
# Check project last modified date
ls -la ~/.projects/[project-file].md 2>/dev/null
# Verify project goals and current status
grep -A 5 -E "(## Goals|## Current Status)" ~/.projects/[project-file].md 2>/dev/null
```

## Archive Process

### Step 3: Project Confirmation
**Confirmation Strategy**:
- **If user specifies project**: Confirm it's the right one by showing project summary
- **If current project context**: Confirm this is what should be archived
- **If unclear**: List active projects for user selection
- **Show project overview**: Display goals, status, and key details before archiving

### Step 4: Archive Summary Creation
Read project document and create comprehensive final summary:

```markdown
# [Project Name] - ARCHIVED [Current Date]

## Final Status: [Completed/Paused/Cancelled]
**Archive Reason**: [Why this project is being archived]

## Project Summary
[What was accomplished, key outcomes, and overall success]

## Final Outcomes
### Goals Achieved ✅
- [List completed goals with checkmarks]
- [Specific deliverables and features completed]

### Goals Not Completed ❌
- [List incomplete goals]
- [Reason why these weren't finished]

### Key Deliverables
- **Files Created**: [List of important files and their purposes]
- **Features Implemented**: [Functional capabilities delivered]
- **Documentation**: [README files, guides, or other docs created]
- **Tests Added**: [Test coverage and validation work]

## Technical Outcomes
### Architecture Decisions
- [Important technical choices made]
- [Design patterns or approaches used]

### Code Quality
- [Testing coverage achieved]
- [Performance improvements made]
- [Security considerations addressed]

## Lessons Learned
### What Worked Well ✅
- [Successful approaches and strategies]
- [Effective tools or techniques used]
- [Process improvements discovered]

### What Could Be Improved 🔄
- [Areas for improvement in future projects]
- [Tools or approaches that didn't work well]
- [Process bottlenecks encountered]

### Important Discoveries 💡
- [Key insights or breakthroughs]
- [Unexpected challenges and solutions]
- [Knowledge gained that applies to future work]

## Archive Metadata
- **Archived Date**: [Current date and time]
- **Original Start Date**: [When project was created]
- **Total Duration**: [Time from first to last activity]
- **Original Goal**: [Primary objective from project document]
- **Final File Count**: [Number of files in key references]
- **Archive Location**: `~/.projects/archive/[filename]`

## Related Work
- **Connected Projects**: [Links to related ongoing projects]
- **Follow-up Work**: [Future projects that build on this work]
- **Dependencies**: [Other projects that depended on this one]

---

## Original Project Document
[Complete original project content preserved below]

---

[ORIGINAL PROJECT CONTENT INSERTED HERE]
```

### Step 5: File Management Operations
**Archive File Operations**:
```bash
# Create archive directory if it doesn't exist
mkdir -p ~/.projects/archive/

# Move project file to archive with preserved filename
mv ~/.projects/[project-file].md ~/.projects/archive/[project-file]-archived-[date].md

# Update any cross-references in other active projects
grep -l "[project-name]" ~/.projects/*.md 2>/dev/null
```

**Reference Management**:
- Preserve original filename with archive date suffix
- Update cross-references in other active projects
- Maintain file reference validity for future access
- Create archive index entry if archive grows large

### Step 6: Cleanup Operations
**Project Cleanup Check**:
- Remove from active project lists or indices
- Identify related temporary files that should be cleaned up
- Suggest cleanup of feature branches or experimental code
- Note any external resources that can be decommissioned

**Cleanup Suggestions**:
```bash
# Check for related git branches
git branch -a | grep -i [project-keywords]
# Look for temporary or project-specific files
fd '[project-slug]' --type f
# Check for project-specific dependencies or services
grep -r [project-name] . --include="*.json" --include="*.yml" 2>/dev/null
```

## Archive Quality Standards

### Pre-Archive Verification
Before archiving, verify:
- [ ] Project summary accurately reflects final outcomes
- [ ] All completed goals are properly documented
- [ ] Important lessons and decisions are captured
- [ ] Key deliverables and files are listed
- [ ] File references will remain valid after archiving
- [ ] Archive reason is clearly stated
- [ ] User confirms this project should be archived

### Archive Completeness
Ensure archive contains:
- [ ] Complete project context and background
- [ ] Detailed outcome documentation
- [ ] Technical decisions and architecture notes
- [ ] Lessons learned for future reference
- [ ] All original project content preserved
- [ ] Proper metadata for future searchability

## Archive Output Templates

### Successful Archive
```markdown
✅ **Project Successfully Archived**

## Archive Summary
- **Project**: [PROJECT_NAME]
- **Final Status**: [Completed/Paused/Cancelled]
- **Archive Location**: `~/.projects/archive/[filename]`
- **Duration**: [Total project timespan]

## Key Outcomes
- **Goals Achieved**: [Number] of [total] goals completed
- **Files Created**: [Number] key deliverables
- **Lessons Captured**: [Number] important insights documented

## Archive Details
- **Original File**: `~/.projects/[original-filename]`
- **Archive File**: `~/.projects/archive/[archive-filename]`
- **Archive Date**: [Current timestamp]

**Project archived and available for future reference** 📦
```

### Archive Confirmation Required
```markdown
⚠️ **Archive Confirmation Needed**

## Project to Archive
- **Name**: [PROJECT_NAME]
- **Current Status**: [Current project status]
- **Last Activity**: [Date of last modification]
- **Goals**: [Number completed] of [total] goals finished

## Archive Impact
- [ ] Project will be moved to archive directory
- [ ] Active project lists will be updated
- [ ] Cross-references in other projects will be noted

**Please confirm this project should be archived**
```

## Advanced Archive Features

### Archive Search Integration
Enable future project discovery:
- **Keyword Tagging**: Add searchable tags for project types
- **Outcome Classification**: Categorize by success level and reasons
- **Technology Indexing**: Tag by languages, frameworks, and tools used
- **Timeline Organization**: Group by date ranges and project phases

### Archive Analytics
Track project patterns:
- **Success Factors**: Analyze what made projects successful
- **Common Blockers**: Identify recurring obstacles across projects
- **Duration Patterns**: Understand typical project timelines
- **Learning Trends**: Track skill development over time

### Cross-Project Learning
Connect archived knowledge:
- **Solution Reuse**: Reference successful approaches from past projects
- **Anti-Pattern Recognition**: Avoid repeating past mistakes
- **Best Practice Evolution**: Track how approaches improve over time
- **Knowledge Transfer**: Make insights accessible for future work

## Integration Guidelines

### Git Workflow Integration
Archive projects align with git practices:
- **Branch Cleanup**: Suggest archiving related feature branches
- **Tag Creation**: Recommend git tags for project milestones
- **Repository Cleanup**: Identify files that can be cleaned up

### Documentation Integration
Connect with broader documentation:
- **Knowledge Base**: Reference archived projects in team documentation
- **Process Improvement**: Use lessons learned to update development processes
- **Training Materials**: Extract examples for team learning

## Example Usage

```bash
# Archive a specific project
/project:archive "user-authentication-system"

# Archive with interactive selection
/project:archive

# The command will:
# 1. Identify and confirm the project to archive
# 2. Create comprehensive archive summary
# 3. Move project to archive directory
# 4. Update cross-references and suggest cleanup
# 5. Provide archive confirmation and location
```

## Error Handling

### Project Not Found
```markdown
❌ **Project Not Found**

**Issue**: No project matches the specified name
**Available Projects**:
[List of current active projects]

**Suggestions**:
- Check project name spelling
- Use `/project:list` to see all active projects
- Specify project by partial name match
```

### Archive Directory Issues
```markdown
⚠️ **Archive Setup Required**

**Issue**: Archive directory doesn't exist or isn't accessible
**Resolution**: Creating `~/.projects/archive/` directory
**Status**: Archive directory ready for use
```

This archive framework ensures systematic project closure with comprehensive documentation, enabling effective knowledge capture and future reference for completed development work.
