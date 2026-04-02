# Audit des prompts — Batch 4 (lignes 1654-1986)

**Fichier audite** : `/home/user/Agent-Team/index.html` lignes 1654-1986
**Agent** : @ia
**Date** : 2026-04-02
**Scope** : 10 prompts de la categorie "Phase 2 — Technique" (fin de section)

## Grille d'evaluation

- **Clarte** /5 : le prompt est-il comprehensible sans ambiguite ? Les instructions sont-elles ordonnees logiquement ?
- **Completude** /5 : couvre-t-il tous les aspects necessaires ? Fallbacks, criteres de validation, livrables nommes ?
- **Robustesse** /5 : gere-t-il les cas d'echec, les fichiers manquants, les coupures de session ?

**Verdicts** : SOLIDE (4+ sur les 3) | A AMELIORER (3 sur un critere) | PROBLEMATIQUE (2- sur un critere)

## Resultats

| # | Prompt | Agent(s) | Clarte /5 | Completude /5 | Robustesse /5 | Verdict | Note |
|---|---|---|---|---|---|---|---|
| 1 | Verifier le handoff design -> code | design, qa, fullstack | 5 | 5 | 5 | SOLIDE | Excellent : sequencage clair (audit -> fix -> regression), gate G26 screenshots Playwright, 6 axes d'audit, criteres de validation binaires. Reference prompt. |
| 2 | Gestion cookies & consent (RGPD) | legal, fullstack, infrastructure | 5 | 5 | 5 | SOLIDE | Tres complet : inventaire cookies, bandeau CNIL, CMP, registre traitements, 3 agents bien sequences. Fallback si fichiers absents. Criteres precis (zero cookie avant consentement). |
| 3 | Pipeline RAG | ia, fullstack, infrastructure | 5 | 5 | 5 | SOLIDE | Architecture RAG exhaustive en 7 points (ingestion, embeddings, vector store, retrieval, prompt eng, eval, cout). Protocole migration modele inclus. Critere "je ne sais pas" pour hallucinations. |
| 4 | Disaster recovery & backup | infrastructure, fullstack, qa | 5 | 5 | 5 | SOLIDE | Point critique bien couvert : backups HORS Replit (storage ephemere), RTO/RPO par service, runbook d'urgence, test de restauration. Sequencage plan -> endpoints admin -> test restore. |
| 5 | Gestion des erreurs & feedback utilisateur | fullstack, ux, design | 5 | 5 | 4 | SOLIDE | Exhaustif : error boundaries, retry patterns, offline handling, logging sans PII. Bonus SEO (404 noindex). Robustesse 4 car pas de mention explicite "si docs/ux/error-messages.md n'existe pas" pour le 3e agent. |
| 6 | Performance budget & optimisation | infrastructure, fullstack, design | 5 | 5 | 5 | SOLIDE | Budgets chiffres par route (LCP, JS size), bundle analysis, image optimization, CI gate. Stale-while-revalidate mentionne. Critere mesurable (bundle < 200KB gzipped). |
| 7 | Plan de scalabilite technique | infrastructure, fullstack, ia | 5 | 5 | 4 | SOLIDE | 8 points detailles (caching multi-niveaux, DB optim, queue, CDN, load balancing, cout par palier). Robustesse 4 : pas de fallback explicite si project-context.md manque le nombre d'utilisateurs (question posee, mais pas de valeur par defaut). |
| 8 | Data pipeline et ETL | ia, infrastructure, fullstack | 5 | 5 | 5 | SOLIDE | Idempotence explicitement requise (ALTER TABLE IF NOT EXISTS), monitoring pipeline, gestion des echecs (dead letter queue). Structure src/lib/pipelines/ bien definie. Tests unitaires pour les transformateurs. |
| 9 | Fine-tuning et prompt engineering avance | ia, data-analyst | 5 | 5 | 5 | SOLIDE | Meta-prompt d'optimisation des prompts. 7 axes (few-shot, CoT, structured output, compression, fallback chains, A/B testing, caching). Protocole migration modele. Metriques LLM pour @data-analyst. |
| 10 | Design de base de donnees & optimisation | fullstack, infrastructure | 5 | 5 | 4 | SOLIDE | Schema ERD, indexation justifiee, migrations idempotentes, seed data realiste, RLS multi-tenant. Robustesse 4 : pas de mention de coupure de session dans le champ "quand". |
| 11 | API design & documentation | fullstack, qa | 5 | 5 | 4 | SOLIDE | REST vs tRPC justifie, cursor-based pagination, rate limiting, Zod validation. Lien avec functional-specs pour les payloads. Robustesse 4 : 2 agents seulement, pas de mention de reprise apres coupure dans "quand". |
| 12 | Authentification & autorisation | fullstack, infrastructure, legal | 5 | 5 | 5 | SOLIDE | Mindset IA applique (ne pas choisir "plus rapide a coder"). Zero self-fetch mentionne. RBAC, rate limiting login, RGPD (droit a l'oubli). Tableau comparatif des solutions exige. |
| 13 | Migration de donnees (v1 -> v2) | fullstack, qa, infrastructure | 5 | 5 | 5 | SOLIDE | Script idempotent, zero-downtime en 2 phases, rollback teste, backup obligatoire avant migration. Validation post-migration avec counts et echantillonnage. |
| 14 | Debug & troubleshooting | fullstack, infrastructure, qa | 4 | 4 | 4 | SOLIDE | Protocole structure en 6 etapes. Seuil de reecriture (10+ edits). Post-mortem leger. Clarte 4 : le placeholder "[DECRIS LE BUG]" dans le prompt est volontaire (template) mais pourrait confondre un utilisateur qui ne le remplace pas. Completude 4 : pas de mention de monitoring/observabilite existant (Sentry, Langfuse) a consulter en premier. |

## Synthese

- **14 prompts audites** : 14 SOLIDE, 0 A AMELIORER, 0 PROBLEMATIQUE
- **Score moyen** : Clarte 4.93 / Completude 4.93 / Robustesse 4.64
- **Qualite generale** : Ce batch est le plus homogene des 4 batches. Les prompts techniques Phase 2 sont remarquablement bien structures, avec un sequencage multi-agents clair, des criteres de validation binaires, et une prise en compte systematique des fichiers manquants.

## Points d'amelioration mineurs (non bloquants)

1. **Prompts 10 et 11 (DB design, API design)** : ajouter une mention de reprise apres coupure dans le champ "quand" (comme les autres prompts le font).
2. **Prompt 14 (Debug)** : ajouter une etape 0 "Consulter l'observabilite existante (Sentry, Langfuse, logs structures)" avant la reproduction manuelle.
3. **Prompt 5 (Gestion erreurs)** : ajouter un fallback pour @design si docs/ux/error-messages.md n'a pas ete produit par @ux.

---

**Handoff -> @orchestrator**
- Fichier produit : `docs/reviews/prompts-audit-batch4.md`
- Decisions prises : 14/14 prompts SOLIDE, aucun prompt problematique dans ce batch
- Points d'attention : 3 ameliorations mineures suggerees (robustesse), aucune action bloquante
