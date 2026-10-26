# CRM — working notes for Claude

Hu's CRM for an insurance + mortgage business. Separate from the `meet360` app — don't
pull Meet360 code or conventions in here.

## Goals
- File insurance statements (from mail scans and email) into a folder per client.
- Track mortgage ad spend, ideally fed from an Outlook email folder.

## Rules
- **No client data in git.** Statements, names, policy/account numbers, SIN, addresses
  and bank details never get committed. `clients/` and `ad-spend/` are git-ignored except
  their README. Use made-up data for examples and tests.
- Plain language, short answers to Hu.
- Routine, reversible setup steps can be done without asking first. Ask before anything
  that sends email, touches real client records, or can't be undone.

## Open decisions
See `docs/plan.md`.
