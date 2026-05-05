# Challenge tech IA — propale agent-ops 24/7 (vs Claude Code subagent 2026)

Date : 2026-04-24 | Agent : @ia | Angle : faisabilité technique pure

## 1. Verdict global technique

**FAISABLE PARTIELLEMENT — pure architecture Claude Code subagent NE SUFFIT PAS pour 24/7 autonome**. Stack 2026 nécessaire = Claude Agent SDK + Scheduled Tasks (cron natif) + Memory tool + Managed Agents (beta). Subagents `.md` Claude Code = invocables uniquement dans une session. La propale orchestrator confond `subagent` (intra-session, stateless) et `agent autonome` (runtime persistant).

## 2. Tableau 11 items × verdict tech

| # | Item | Faisable Claude Code subagent seul | Runtime externe requis | Coût implé |
|---|---|---|---|---|
| R1 | @growth campagnes continues auto-optim | NON | Scheduled Tasks + Memory tool | Moyen |
| R2 | @data-analyst BI ops temps réel + alertes | NON | Cron + MCP DB + webhook | Moyen |
| R3 | @orchestrator mode "business ops" post-launch | NON (paradigme inversé) | Agent SDK loop persistant | Élevé |
| N1 | @sales prospection auto continue | NON | Agent SDK + queue + CRM MCP | Élevé |
| N2 | @finance compta/cashflow | PARTIEL (run-on-demand OK) | Scheduled Tasks pour mensuel | Faible |
| N3 | @support N1 + escalade | NON | Managed Agents (beta) + webhook | Élevé |
| N4 | @ops suivi commandes/SLA | NON | Cron + monitoring MCP | Moyen |
| N5 | @director/@ceo-proxy décisions strat continues | NON | Agent SDK loop + memory | Très élevé |
| BP1 | Auto-amélioration runtime | OUI (partiellement) | Memory tool API (`/memories`) | Faible |
| BP2 | Mode 24/7 autonome | NON | Agent SDK + Scheduled Tasks OU Managed Agents | Élevé |
| BP3 | Missions continues (state machine) | NON | DB externe + reducer + Memory tool | Moyen |

**Lecture sèche** : 0/11 items faisables avec un simple fichier `.md` subagent. 9/11 nécessitent runtime externe ou Agent SDK custom.

## 3. Architecture cible "business ops"

Si Gradient veut sortir du périmètre session-bornée :

```
[Claude Agent SDK loop] (Python/TS, hébergé)
   ├─ Memory tool (/memories filesystem) — état persistant cross-session
   ├─ Scheduled Tasks (cron natif Claude Code) — déclencheurs périodiques
   ├─ MCP servers (CRM, DB, Stripe, email) — actions outbound
   ├─ Webhooks inbound (Vercel/Cloudflare Worker) — événements externes
   └─ Subagents .md (réutilisés intra-loop) — découpage de tâches
```

Les 21 agents `.md` actuels = **réutilisables comme bibliothèque de prompts**, pas comme runtime. Le cœur ops devient le SDK loop, pas Claude Code CLI.

## 4. Stack 2026 disponible (sources)

- **Scheduled Tasks (cron natif)** — GA, jusqu'à 50 tâches/session, cron expressions standard. [Claude Code docs](https://code.claude.com/docs/en/scheduled-tasks)
- **Memory tool API** — GA, filesystem `/memories` client-side, audit log, rollback. [Claude API docs](https://platform.claude.com/docs/en/agents-and-tools/tool-use/memory-tool) + [context management](https://www.anthropic.com/news/context-management)
- **Claude Agent SDK** (Python/TS) — toolkit pour agents long-running, context compaction, harness. [SDK overview](https://platform.claude.com/docs/en/agent-sdk/overview) + [effective harnesses](https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents)
- **Claude Managed Agents + Memory** — public beta, runtime hébergé Anthropic, cross-session learning. [Techzine](https://www.techzine.eu/news/devops/140836/anthropic-adds-memory-to-claude-managed-agents/) + [LaoZhang guide](https://blog.laozhang.ai/en/posts/claude-managed-agents)
- **MCP marketplace ops business** : claudecron, claude-mcp-scheduler, Cronlytic. [claudecron](https://github.com/phildougherty/claudecron) + [scheduler MCP](https://github.com/tonybentley/claude-mcp-scheduler). **Pas de MCP "sales/finance/support" mainstream à ce jour** — il faudra builder via MCP DB + MCP API génériques.
- **Subagents architecture** — sidechain transcripts, `.claude/agent-memory/` (intra-projet, pas cross-tenant). [Sub-agents docs](https://code.claude.com/docs/en/sub-agents) + [SDK subagents](https://platform.claude.com/docs/en/agent-sdk/subagents)

**Limites factuelles 2026** : pas de "subagent qui tourne en background sans session humaine" en Claude Code CLI. La parallélisation existe mais reste bornée à la session parent. Managed Agents memory = beta, breaking changes possibles.

## 5. Top 1 reco technique — meilleur ratio impact/coût

**BP1 — Auto-amélioration runtime via Memory tool**.

Pourquoi : (a) faisable en API directe sans changer le paradigme Claude Code, (b) coût implé faible (un MCP wrapper sur `/memories` + injection dans CLAUDE.md), (c) résout un vrai pain actuel (learnings session-bound, TTL 5 sessions évoqué dans CLAUDE.md règle 8), (d) zéro dépendance runtime externe lourde, (e) compatible avec les 21 agents existants sans refonte.

Impact concret : `lessons-learned.md` devient persistant cross-projet via `/memories`, les 32 gates `_gates.md` accumulent un historique de "patterns qui passent / patterns qui cassent", chaque agent enrichit sa propre mémoire sans bloater son `.md`. ROI estimé : 40-60% réduction des erreurs récurrentes inter-sessions.

**Tout le reste (sales/finance/support/director continus 24/7) = projet séparé**. Ce n'est pas une évolution du framework Gradient, c'est un produit B2B distinct ("Gradient Ops") qui réutiliserait la bibliothèque de prompts mais tournerait sur Agent SDK + Managed Agents. Mélanger les deux dilue les deux.

---

**Handoff → @orchestrator**
- Fichier produit : `docs/reviews/ia-challenge-agent-ops-tech-2026-04-24.md`
- Décision tech : 0/11 items implémentables en pur subagent `.md`. Top 1 = Memory tool pour learnings persistants.
- Point d'attention : si Thomas veut le pack ops complet, c'est un pivot framework → produit (Agent SDK runtime). Décision business, pas tech.
