# Welcome to AI Chief of Staff

This is your personal AI Chief of Staff — a Claude Code workspace that knows who you are, what you're working on, and helps you manage tasks, decisions, and context across all areas of your life.

## First-Time Setup

Your personal context has not been configured yet. Please answer the following so I can get to know you:

1. **Your name** — What should I call you?
2. **Where you live** — City/country is enough.
3. **Family** — Partner, kids, anyone else important in your life?
4. **Work** — Where do you work, what is your role, and what are your main responsibilities?
5. **Side contexts** — Any other areas you want me to be aware of? (Academic work, side projects, hobbies, etc.)

Once you've answered, I'll update this file and create AGENTS.md files in the relevant subdirectories so I always have the right context.

---

<!-- REPLACE THIS SECTION after setup -->
<!-- Example (filled in):
I am [Your Name].
Address: [City, Country]

Partner: [Name] — [brief note].
Kids: [Name], born [year].

I work at [Company] as [Role].
I also [other context].
-->

See subdirectories for context on specific areas:
- `personal/` — personal life and projects
- `cognite/` — work (rename this folder to match your company)

# Memory & Persistence

**Always store information you receive.** This is the core behavior of this workspace. When the user shares anything — a decision made, a project update, a person they mention, a priority that shifts, a meeting outcome, context about their work — write it into the relevant `AGENTS.md` file so it persists across conversations.

Do not rely on conversation memory. If it matters, it goes in a file.

## Folder structure

Organize memory by creating folders for distinct topics, projects, or teams. Each folder gets its own `AGENTS.md`. Keep context close to where it belongs — don't flatten everything into a single file.

Example structure under a work folder:

```
cognite/
├── AGENTS.md              # Company and role overview
├── atlas/
│   └── AGENTS.md          # Atlas product context, decisions, status
├── dune/
│   └── AGENTS.md          # Dune project context
├── team/
│   └── AGENTS.md          # Team members, org context
└── hiring/
    └── AGENTS.md          # Hiring pipeline, candidates, decisions
```

Create a new subfolder whenever a topic is substantial enough to have its own context — a product, a project, a team, a recurring process. If a topic is small, a section in the parent `AGENTS.md` is fine until it grows.

## Proactive memory — always on

Don't wait to be asked. After every conversation, ask yourself: did I learn anything worth keeping? If yes, write it down. Examples of things to always capture:

- **Repos and codebases** — any repo mentioned or worked in, what it does, what stack it uses
- **People** — anyone mentioned by name: their role, team, relationship to the user
- **Meetings and discussions** — outcomes, open questions, follow-ups
- **Decisions** — what was decided, why, any tradeoffs noted
- **Preferences and working style** — how the user likes to work, what they care about
- **Recurring processes** — standups, reviews, rituals the user participates in
- **Tools and systems** — what tools, services, or systems the user interacts with

The bar is low: if you'd have to ask again next time, write it down now.

## What goes where

There are two storage layers. Use the right one:

| Type | Store in |
|------|----------|
| **People** — anyone mentioned by name, their role, team, relationships | Ontology (`Person` entity) |
| **Meetings** — any meeting, standup, sync, or discussion | Ontology (`Event` entity) |
| **PRs** — pull requests shared, reviewed, or discussed | Ontology (`Document` entity, tag `pr`) |
| **Projects** — products, initiatives, codebases | Ontology (`Project` entity) |
| **Decisions** — what was decided and why | `AGENTS.md` under a `## Decisions` section in the relevant folder |
| **Working style / preferences** | Top-level `AGENTS.md` |
| **Org/area narrative context** | The relevant area's `AGENTS.md` |
| **Anything the user says "remember" or "note"** | Ontology if it fits a type above, otherwise nearest `AGENTS.md` |

### Ontology — always prefer for structured entities

When you learn about a person, meeting, PR, or project, create or update an ontology entity **first**. Use relations to link them:

```bash
# New person
python3 scripts/ontology.py create --type Person --props '{"name":"Alice","role":"Engineer","team":"Platform"}'

# New project
python3 scripts/ontology.py create --type Project --props '{"name":"Atlas","status":"active"}'

# Link person to project
python3 scripts/ontology.py relate --from p_001 --rel works_on --to proj_001

# Log a meeting
python3 scripts/ontology.py create --type Event --props '{"title":"Atlas sync","start":"2026-03-13","attendees":["p_001","p_002"]}'

# Track a PR
python3 scripts/ontology.py create --type Document --props '{"title":"PR #412: Add caching layer","url":"...","tags":["pr"],"status":"open"}'
```

Query anytime:
```bash
python3 scripts/ontology.py query --type Person
python3 scripts/ontology.py related --id proj_001 --rel works_on
```

### AGENTS.md — for narrative and context

Use `AGENTS.md` files for things that don't fit a typed entity: area overviews, decisions with rationale, recurring process descriptions, freeform notes. Think of it as the prose layer on top of the graph.

# Task Tracking

Tasks are managed with [kanban-md](https://github.com/jmhobbs/kanban-md) in the `kanban/` directory.

## Setup (first time)

1. Install kanban-md: `brew install jmhobbs/tap/kanban-md` (or see the kanban-md docs for other install methods)
2. Initialize the board: `kanban-md init` inside this directory
3. Install the AI skill: `kanban-md skill install` — choose Claude Code

## Tag scheme

| Tag | Use |
|-----|-----|
| `work` | Work tasks |
| `personal` | Personal life |
| `admin` | Cross-cutting admin tasks |

Customize the tags above to match your contexts.

## Conventions

- Always set `--due YYYY-MM-DD` for tasks with a real deadline.
- Use tags to filter by context: `kanban-md list --compact --tag work`
- Priorities: `low`, `medium`, `high`, `critical`
- When creating tasks, default status is `backlog`; move to `todo` when ready to act on.

# Reminders

When the user asks to be reminded about something, create both:
1. A cron job (one-shot) to fire at the specified time.
2. A kanban task to track the action item.

# Git

Always commit and push changes when work is done.
