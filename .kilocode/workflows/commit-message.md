# Instruction: Generate a conventional commit message for staged changes, then commit the changes

## TASK:

1. Analyze the staged git changes
2. Generate an appropriate conventional commit message
3. Commit the changes using the generated message

## REQUIRED FORMAT:

```
<type>(<scope>): <summary>
```

## RULES:

- Summary MUST be max 50 characters
- Summary MUST be lowercase
- Summary MUST NOT end with a period
- Type MUST be one of the allowed types below
- Scope SHOULD use course codes when relevant

## EXAMPLE OUTPUT:

```
docs(CSE-807): add week 4 cryptography notes
```

## ALLOWED TYPES:

- `docs` → notes, slides, readings, summaries
- `feat` → new course module/chapter/material
- `fix` → correction of mistakes in notes/diagrams
- `lab` → lab or assignment uploads/updates
- `asset` → images, diagrams, charts
- `chore` → folder restructure, file rename, cleanup
- `refactor` → reorganizing content without changing meaning

## VALID SCOPES:

CSE-801, CSE-802, CSE-804, CSE-807, general, folders, diagrams, slides

## OPTIONAL DESCRIPTION:

- Add if the change needs explanation
- Keep lines under 72 characters
- Explain WHAT changed and WHY

## OPTIONAL FOOTER:

- Use for references: "Related: #12"
- Use for assignments: "Assignment: Lab 3"

## EXAMPLES:

### ✅ Valid Examples:

```
docs(CSE-807): add asymmetric encryption notes
lab(CSE-801): add network scanning lab 3
fix(CSE-804): correct XSS vulnerability example
asset(CSE-802): add attack tree diagram
```

### ❌ Invalid Examples:

```
Added some notes (missing type and scope)
docs(CSE-807): Added notes. (capitalized, has period)
```
