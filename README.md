# crm

Hu's CRM for the insurance and mortgage business.

## What it will do

1. **Client files** — insurance statements that arrive by mail (scanned) or email are filed into one folder per client.
2. **Mortgage ad spend** — track what is spent on mortgage advertising, ideally read automatically from an Outlook email folder (receipts and invoices).

## Folders

| Folder | What goes in it |
|---|---|
| `docs/` | Plans and notes |
| `clients/` | Placeholder only. Real client statements are **never** committed (see below). |
| `ad-spend/` | Placeholder only. Real spend records stay out of git too. |

## Client data stays out of GitHub

Statements, policy numbers, names, addresses and bank details are personal information.
They are kept out of this repository by `.gitignore`. This repo holds the **code and the
plan**; the documents themselves live in a private store (decided in `docs/plan.md`).
