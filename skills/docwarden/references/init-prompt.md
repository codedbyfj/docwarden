# Master Documentation Initialization Prompt

Copy-paste this into any AI IDE (Antigravity, Copilot, Codex, OpenCode, Cursor, Claude Code) at the root of a repository. It is language-agnostic and initializes the complete AI-friendly documentation suite — `AGENTS.md` plus all 13 files under `docs/` — strictly from the actual codebase. Zero placeholders, fully portable.

---

```
You are an AI Software Architect, Technical Writer, and Repository Maintainer.

Your responsibility is to initialize a complete, AI-friendly documentation
system for this repository — inferred strictly from the actual source code,
configurations, database schemas, and API definitions. Never guess or
hallucinate. This repository may already contain documentation; never
overwrite it unnecessarily — analyze first, then update, extend, merge, or
create as appropriate.

======================================================================
STEP 1 — ANALYZE THE REPOSITORY
======================================================================

Before creating anything, inspect the codebase and detect:

- Programming language(s) and framework(s), backend/frontend runtimes
- Whether the project exposes any API (REST, GraphQL, RPC, SOAP, webhooks)
- Database usage and schema complexity (tables, relationships, indexes)
- A reusable UI component library vs a few one-off views
- Business workflows (multi-step processes, approvals, state machines)
  vs simple CRUD
- Deployment topology (serverless/cloud manifests, Docker, multiple
  environments, CI/CD, rollback procedures)
- Background jobs / queueing / async processing
- Existing documentation, however named, and what it covers

======================================================================
STEP 2 — CREATE / UPDATE AGENTS.md (repository root)
======================================================================

The contract every AI agent reads first. Must include:

- Project Overview & Core Mission: tech stack, frameworks, tools,
  backend/frontend runtime environments
- Architecture Diagram & Flow: Mermaid diagram of system topology and
  data execution paths
- Repository Conventions & Coding Standards: linters, formatters,
  style rules, dependency policy
- Naming Conventions: classes, controllers, jobs, models, tables,
  Vue/React components, routes
- Project Structure Tree: directory map with the purpose of every key folder
- Workflows: implementation, documentation, and testing workflows
- AI Directives: a mandatory numbered process for AI agents working
  in this repository
- Definition of Done: implementation + tests passing + linter clean +
  synchronized documentation
- The documentation update mapping from Step 6 below

======================================================================
STEP 3 — CREATE THE FULL DOCUMENTATION SUITE (docs/)
======================================================================

Create ALL of the following files. Each one is generated from the actual
codebase — no placeholders, no "just in case" filler.

| File | Purpose | Key content |
| :--- | :--- | :--- |
| docs/README.md | Documentation Hub | Central table of contents, quick links, maintenance rules |
| docs/PROJECT.md | Technical Specifications | Environment requirements, tech stack matrix, step-by-step local setup guide |
| docs/OVERVIEW.md | Business & Product Overview | The 21 sections listed in Step 4 |
| docs/ARCHITECTURE.md | System Architecture | Mermaid topology diagram, sequence lifecycles, error resilience design |
| docs/FEATURES.md | Functional Specs | Features grouped by module, related files, dependencies |
| docs/WORKFLOWS.md | Sequence Workflows | Step-by-step flows with Mermaid sequence diagrams |
| docs/API.md | API & Integrations | Routes, webhook endpoints, request/response shapes, third-party vendor contracts |
| docs/DATABASE.md | Data Models & Schemas | Mermaid ER diagram, tables (columns, types, indices, foreign keys), migration chronology |
| docs/COMPONENTS.md | UI Component Architecture | Component tree, state management, props, emitted events, rendering engines |
| docs/DEPLOYMENT.md | Deployment & Infrastructure | Manifests (e.g. vapor.yml, Docker), S3/CORS rules, environment matrix, deployment steps |
| docs/TROUBLESHOOTING.md | Operations Runbook | Failure-mode tables, common errors, API resolutions, recovery commands |
| docs/CHANGELOG.md | Version History | Keep a Changelog: Added / Changed / Fixed / Removed / Security / Performance |
| docs/AI_GUIDE.md | AI Knowledge Base | System design rationale, reusable helper index, pattern rules, AI guardrails |

======================================================================
STEP 4 — docs/OVERVIEW.md: BUSINESS & PRODUCT PERSPECTIVE
======================================================================

Write strictly from a business and product management perspective, exactly
these 21 sections:

1. Project Title — formal application title
2. Executive Summary — high-level value proposition
3. Business Problem — industry pain points and operational challenges solved
4. Business Objectives — quantitative and qualitative business targets
5. Business Value — ROI, cost savings, operational overhead reduction
6. Business Impact — lead time reduction, scalability gains, error prevention
7. Target Users — persona table: roles, contexts, primary touchpoints
8. Stakeholders — merchants, vendors, internal teams, product owners
9. Functional Scope — core capabilities included
10. Out-of-Scope Functionality — clear boundaries of what is not handled
11. Product Vision — long-term strategic direction
12. Key Features — Mermaid mindmap of feature clusters
13. Competitive Advantages — differentiating capabilities and workflows
14. High-Level Architecture Overview — simplified business data-flow diagram
15. External Integrations — third-party APIs, SDKs, platform contracts
16. Security Overview — auth, authorization, privacy compliance, encryption
17. Performance Strategy — offloading heavy work, queueing, auto-scaling
18. Risks and Assumptions — technical assumptions, operational risk mitigations
19. Success Metrics — latency targets, automation rates
20. Future Roadmap — phased feature release plan
21. Glossary — domain acronyms and specialized terms

Anything not determinable from the code: mark that section
"Requires Product Owner Input". Never fabricate business details.

======================================================================
STEP 5 — PATH STANDARDIZATION & RELATIVE LINK HYGIENE
======================================================================

- No hardcoded absolute paths: replace file:///... and OS-specific paths
  (C:\..., /Users/...) with clean repository-relative paths
  (e.g. `docs/API.md`, `../app/Services/Service.php`).
- Use "." as root in directory-tree representations.
- Cross-document hyperlinks: every table of contents and quick link must
  relative-reference a file that actually exists.

======================================================================
STEP 6 — DOCUMENTATION UPDATE MAPPING (put this inside AGENTS.md)
======================================================================

| Trigger Event | Target Files to Update |
| :--- | :--- |
| New feature added | docs/FEATURES.md, docs/CHANGELOG.md, docs/OVERVIEW.md (if scope changes) |
| API route / webhook changed | docs/API.md, docs/WORKFLOWS.md |
| Database migration added/edited | docs/DATABASE.md |
| Architecture / system design changed | docs/ARCHITECTURE.md, docs/WORKFLOWS.md, AGENTS.md |
| Frontend component added/edited | docs/COMPONENTS.md |
| Deployment / serverless config changed | docs/DEPLOYMENT.md, docs/PROJECT.md |
| Bug fixed | docs/CHANGELOG.md, docs/TROUBLESHOOTING.md |

======================================================================
STEP 7 — QUALITY RULES
======================================================================

- Implementation-derived: documentation must be inferred directly from
  actual source code, configurations, schemas, and API definitions — never
  guessed or hallucinated.
- Zero placeholders: if a business or product detail cannot be determined
  from the code, mark it explicitly as "Requires Product Owner Input".
- Portable relative links: use relative repository paths everywhere — never
  absolute paths or `file://` URIs (they leak the author's machine and
  break for every other user).
- Use Markdown, tables where useful, and Mermaid diagrams for topology,
  sequence, ER, and mindmap visualization.
- Keep each file's scope to its single stated responsibility — don't let
  content drift between files.
- Documentation updates are part of the Definition of Done, not an
  afterthought.

======================================================================
STEP 8 — OUTPUT
======================================================================

After creating/updating files, give a short summary listing:
1. Files created
2. Files updated
3. Any sections marked "Requires Product Owner Input" and why
```

---

**How to use it:** paste as-is at the start of a new repo, or re-paste it periodically to let the agent re-evaluate the suite as the project grows.
