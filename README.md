# Codex Skills

Private backup repository for 24 installed Codex skills.

The repository root is also the active global skill directory:

```text
%USERPROFILE%\.agents\skills
```

Every tracked skill directory is a direct copy of the installed skill. Adding,
removing, or updating a skill changes this Git working tree immediately.

## Backup

```powershell
.\backup-skills.ps1
.\backup-skills.ps1 -Commit
.\backup-skills.ps1 -Push
```

`-Push` implies `-Commit`. The script validates the generated skill manifest, refreshes
the support files, commits changes, and pushes to `origin`.

## Support Files

- `manifest.json` - generated inventory of installed skills
- `references/` - shared checklists used by several installed skills
- `skill-lock.json` - source metadata copied from `%USERPROFILE%\.agents`
- `backup-skills.ps1` - validation, commit, and push helper

`manifest.json` is regenerated on every backup. New, removed, or modified skill
directories are therefore reflected without a second manual synchronization.
