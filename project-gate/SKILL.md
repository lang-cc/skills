---
name: project-gate
description: Use before non-trivial implementation work in a repository when the scope or approach is not already approved. Inspect project instructions, current changes, stack, commands, and risks; resolve factual questions directly; ask only a blocking product decision; then present a concrete plan and wait for explicit approval before modifying files. Do not use for read-only questions or trivial one-step fixes.
---

# Project Gate

Turn repository context into an approved implementation boundary. The gate is
complete only when the user has seen the plan and explicitly approved it.

## Read before deciding

Inspect only the context needed to plan safely:

- `AGENTS.md`, `CLAUDE.md`, `README`, and project documentation;
- package manifests, build files, test configuration, and generated command
  references;
- `git status --short --untracked-files=all` and recent history when available;
- the entry points, tests, and configuration likely to be affected.

Do not ask the user for facts that the repository can answer.

## Gate checks

Establish:

1. **Requested outcome** - what must work when the task is complete.
2. **Current state** - what exists, what is broken, and what is already being
   changed by the user.
3. **Project commands** - the canonical install, run, test, lint, and build
   commands, or state that none are defined.
4. **Scope** - the smallest set of modules and files the work needs.
5. **Constraints** - compatibility, security, performance, data, permissions,
   and destructive-operation boundaries.
6. **Risk** - the most likely regression and the safest rollback.
7. **Verification** - evidence that will prove completion.

If a missing fact does not change the plan, use the conservative assumption and
record it.

## Ask only when blocked

Ask at most one high-impact question at a time. Ask only when the answer changes
the outcome, scope, or acceptable risk and cannot be discovered from the
project.

Use recommended options when possible:

- **Recommended**: the safest option consistent with the stated request.
- **Alternative**: a faster or broader option with a concrete tradeoff.

Do not turn implementation details into a questionnaire.

## Present the gate

Keep the plan short enough to review in one pass:

- **Outcome**: completion definition and required evidence.
- **Scope**: files or modules to change and explicit non-goals.
- **Plan**: ordered implementation steps with expected results.
- **Verification**: exact checks to run after implementation.
- **Risks and rollback**: what can fail and how to recover.
- **Assumptions**: unresolved choices adopted conservatively.

End with a direct approval request. Do not modify files, install dependencies,
commit, or start external actions before the user explicitly approves.

## After approval

Follow the approved scope. Treat newly discovered scope expansion, changed
acceptance criteria, destructive operations, or credentials as a reason to
stop and re-confirm. Before the final response, verify the agreed checks and
report the actual result.
