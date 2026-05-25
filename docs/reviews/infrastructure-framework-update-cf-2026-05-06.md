# Audit framework Gradient — Mise a jour priorite GitHub + Cloudflare + Neon

**Date** : 2026-05-06 (S3)
**Auteur** : @infrastructure
**Statut** : Modifications appliquees, en attente review @reviewer
**Contexte** : extension des 4 fichiers deja modifies en S3 (commit `acf8b21`) — propagation aux autres fichiers du framework qui mentionnaient encore Replit comme defaut/obligation.

---

## 1. Methodologie

1. Grep large `Replit\|.replit\|replit.nix\|Replit Secrets\|PostgreSQL Replit` sur `.claude/agents/`, `CLAUDE.md`, `_gates.md`, `_base-agent-protocol.md`, `templates/`, `scripts/`, `docs/`, `index.html`.
2. Pour chaque fichier hit : decision mise a jour vs conservation, edition mineure (3-10 lignes max).
3. Principe directeur : **futurs projets = CF+Neon, legacy Replit conserve avec protections existantes**. Aucune reintroduction de Replit comme defaut.
4. Verification caps post-modif : CLAUDE.md ≤ 125L, orchestrator.md ≤ 900L.

---

## 2. Fichiers modifies (Mission 1)

| Fichier | Lignes touchees | Justification |
|---|---|---|
| `.claude/agents/_base-agent-protocol.md` | L408, L412-413 | "Actions Replit requises" → "Actions infra requises" + double checklist (CF futurs / Replit legacy). Impact : tous agents qui font handoff. |
| `.claude/agents/ia.md` | L162 | Vector store : ajout Cloudflare Vectorize (edge native), pgvector toujours par defaut mais explicite "Neon ou Replit legacy". |
| `.claude/agents/qa.md` | L98 | Pipeline CI/CD : futurs projets ajoutent step `deploy` via wrangler-action ; legacy Replit s'arrete a `build`. Resout l'ambiguite. |
| `.claude/agents/moi.md` | L41 | Anti-vendor-lock-in : Postgres standard (Neon ou Replit) > Supabase. Ajout note S3 justifiant CF malgre dependance. |
| `.claude/agents/orchestrator.md` | L37 | Exemple Stack technique : Neon Postgres (futurs) ou PostgreSQL Replit (legacy). |
| `.claude/agents/orchestrator.md` | L287 | "Verification build Replit" → "Verification build" + ajout `next-on-pages` pour futurs projets CF. |
| `.claude/agents/orchestrator.md` | L528 | Phase 2 dev : @infrastructure setup initial = repo GitHub + wrangler.toml + Neon (futurs) OU Replit (legacy). Et finalisation : @infrastructure pilote deploy CF (futurs) vs Thomas execute Replit (legacy). |
| `.claude/agents/orchestrator.md` | L673 | Limites identifiees : CF Workers CPU/duree (futurs) vs Replit cold start/storage (legacy). |
| `CLAUDE.md` | L64 | "Actions Replit dans REPLIT_ACTIONS.md" → "Actions infra dans REPLIT_ACTIONS.md (legacy) ou CLOUDFLARE_ACTIONS.md (futurs)". |
| `index.html` | L430, L444 | Description agent fullstack et infrastructure : ajout Neon/CF en priorite, Replit explicitement legacy. |

**Total** : 7 fichiers, 11 modifications. Edition mineure (≤ 5 lignes par modif), aucune refonte.

---

## 3. Sections inchangees (et pourquoi)

| Section / Fichier | Pourquoi pas modifie |
|---|---|
| `.claude/agents/infrastructure.md` (cet agent) | Deja modifie en S3 (commit acf8b21). Stack par defaut = GitHub + CF + Neon, protections Replit conservees pour legacy. |
| `.claude/agents/fullstack.md` | Deja modifie en S3. Stack reco fullstack : Drizzle + NextAuth v5 + jose + bcryptjs + @neondatabase/serverless + Resend + R2. |
| `templates/project-context.md` | Deja modifie en S3. Hebergement et BDD listent CF/Neon en premier (recommande), Replit en legacy. |
| `docs/founder-preferences.md` | Deja modifie en S3 avec section CF + verdicts S3. |
| `_gates.md` | Aucune mention Replit specifique : gates G1-G32 sont stack-agnostic. Pas de modif necessaire. |
| `index.html` lignes 566-1689 (29 mentions Replit residuelles) | **Refonte volontairement non incluse dans cette session** : impacte les prompts copier-coller utilisateur (specs, persona, etc.) — necessite session dediee de re-redaction des 89 prompts client-facing. Recommandation : task @copywriter ou @agent-factory pour pass complet index.html. **Action suivi requise.** |
| `.claude/agents/fullstack.md` mention sharp/bcrypt natifs Replit | Deja documente dans rapport @fullstack S3 (les 5 packages a remplacer pour CF). |
| Protections persistance Replit (PG migrate deploy au boot, /api/health degraded, self-fetch 127.0.0.1, etc.) dans `.claude/agents/infrastructure.md` | **PRESERVEES INTACTES** (decision Thomas : projets legacy doivent garder ces protections jusqu'a migration). |

---

## 4. Verification caps

| Fichier | Cap | Avant S3 | Apres modifs S3 | Statut |
|---|---|---|---|---|
| `CLAUDE.md` | 125L | 108L | 108L | OK (modif L64 = remplacement, pas ajout) |
| `.claude/agents/orchestrator.md` | 900L | 819L | 819L | OK (3 modifs = remplacements, pas ajouts) |
| `.claude/agents/_base-agent-protocol.md` | aucun cap formel | n/a | +1L net | OK |
| `.claude/agents/infrastructure.md` | aucun cap formel | n/a | inchange en S3 cette session | OK |
| `lessons-learned.md` | 80L | non touche | non touche | OK |

---

## 5. Conformite decision Thomas

✓ GitHub + Cloudflare + Neon = priorite explicite pour **futurs projets** dans tous les fichiers touches.
✓ Replit = explicitement **legacy** ou **fallback POC** dans tous les fichiers touches.
✓ **Aucun fichier ne reintroduit Replit comme defaut** apres modifs.
✓ Protections persistance Replit conservees pour projets existants (Versiroom, Sarani, Marrant, ImmoCrew, ISSA Capital).
✓ Choix BDD reste arbitre projet par projet (Neon par defaut, D1/Supabase ecartes par verdict S3).
✓ Verdicts S3 (@infrastructure, @ia, @fullstack) utilises comme source de verite pour formulations.

---

## 6. Livrables associes (Mission 2)

| Fichier | Statut |
|---|---|
| `docs/migrations/issa-capital-migration.md` | **Existait deja** (creee en S3 precedente, complete et conforme). Non modifiee cette session. |
| `docs/migrations/marrant-migration.md` | **Cree cette session** : ~290L, 12 sections, audit pre-migration obligatoire, plan phase, code changes, wrangler.toml, GH Actions, BDD, AI Gateway, criteres validation, risques + escalade. |

---

## 7. Action suivi recommandee

**Refonte index.html (29 mentions Replit residuelles dans les 89 prompts client-facing)** : a planifier en session dediee. Impact : prompts copier-coller utilisateur. Recommandation : task @copywriter ou @agent-factory pour pass complet, avec verification que :
- Chaque prompt mentionne CF+Neon en premier, Replit en alternative legacy
- Les exemples Stack technique sont mis a jour
- Les sections "Persistance Replit — CRITIQUE" sont conservees mais reformulees "si stack legacy Replit"
- Le bandeau "Actions Replit (Regle 15)" devient "Actions infra (CF ou Replit)"

**Verification post-merge** : Grep `PostgreSQL Replit\|Deploy Replit` apres merge → doit ne plus retourner que des hits dans index.html (en attente de la refonte) et docs/migrations (volontaire).

---

## 8. Handoff

**→ @reviewer (audit independant des modifications framework)**
- Verifier chaque modif L par L (cf. tableau section 2)
- Verifier coherence transversale : un nouveau projet lance via @orchestrator → @infrastructure → @fullstack doit produire stack CF+Neon coherente sans residu Replit
- Tester sur exemple : creer un projet "test-cf" et verifier que `project-context.md` template + handoffs successifs convergent vers CF+Neon
- Signaler tout fichier oublie ou toute regression

**→ Thomas**
- Approuver merge des 11 modifs framework
- Planifier session refonte index.html (action suivi section 7)
- Lancer execution migrations : ISSA en premier (4-8h, faible risque), puis Marrant apres pre-audit obligatoire (10-20h)
