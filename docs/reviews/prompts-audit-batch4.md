# Audit des prompts — Batch 4 (lignes 1654-1986)

**Fichier audite** : `/home/user/Agent-Team/index.html` lignes 1654-1986
**Agent** : @ia
**Date** : 2026-04-02
**Scope** : 10 prompts de la catégorie "Phase 2 — Technique" (fin de section)

## Grille d'evaluation

- **Clarte** /5 : le prompt est-il comprehensible sans ambiguite ? Les instructions sont-elles ordonnees logiquement ?
- **Completude** /5 : couvre-t-il tous les aspects nécessaires ? Fallbacks, critères de validation, livrables nommes ?
- **Robustesse** /5 : gere-t-il les cas d'échec, les fichiers manquants, les coupures de session ?

**Verdicts** : SOLIDE (4+ sur les 3) | A Améliorer (3 sur un critère) | PROBLEMATIQUE (2- sur un critère)

## Résultats

| # | Prompt | Agent(s) | Clarte /5 | Completude /5 | Robustesse /5 | Verdict | Note |
|---|---|---|---|---|---|---|---|
| 1 | Vérifier le handoff design -> code | design, qa, fullstack | 5 | 5 | 5 | SOLIDE | Excellent : sequencage clair (audit -> fix -> régression), gate G26 screenshots Playwright, 6 axes d'audit, critères de validation binaires. Référence prompt. |
| 2 | Gestion cookies & consent (RGPD) | legal, fullstack, infrastructure | 5 | 5 | 5 | SOLIDE | Très complet : inventaire cookies, bandeau CNIL, CMP, registre traitements, 3 agents bien sequences. Fallback si fichiers absents. Critères précis (zéro cookie avant consentement). |
| 3 | Pipeline RAG | ia, fullstack, infrastructure | 5 | 5 | 5 | SOLIDE | Architecture RAG exhaustive en 7 points (ingestion, embeddings, vector store, retrieval, prompt eng, eval, coût). Protocole migration modèle inclus. Critère "je ne sais pas" pour hallucinations. |
| 4 | Disaster recovery & backup | infrastructure, fullstack, qa | 5 | 5 | 5 | SOLIDE | Point critique bien couvert : backups HORS Replit (storage ephemere), RTO/RPO par service, runbook d'urgence, test de restauration. Sequencage plan -> endpoints admin -> test restore. |
| 5 | Gestion des erreurs & feedback utilisateur | fullstack, ux, design | 5 | 5 | 4 | SOLIDE | Exhaustif : error boundaries, retry patterns, offline handling, logging sans PII. Bonus SEO (404 noindex). Robustesse 4 car pas de mention explicite "si docs/ux/error-messages.md n'existe pas" pour le 3e agent. |
| 6 | Performance budget & optimisation | infrastructure, fullstack, design | 5 | 5 | 5 | SOLIDE | Budgets chiffres par route (LCP, JS size), bundle analysis, image optimization, CI gate. Stale-while-revalidate mentionne. Critère mesurable (bundle < 200KB gzipped). |
| 7 | Plan de scalabilite technique | infrastructure, fullstack, ia | 5 | 5 | 4 | SOLIDE | 8 points detailles (caching multi-niveaux, DB optim, queue, CDN, load balancing, coût par palier). Robustesse 4 : pas de fallback explicite si project-context.md manque le nombre d'utilisateurs (question posee, mais pas de valeur par défaut). |
| 8 | Data pipeline et ETL | ia, infrastructure, fullstack | 5 | 5 | 5 | SOLIDE | Idempotence explicitement requise (ALTER TABLE IF NOT EXISTS), monitoring pipeline, gestion des échecs (dead letter queue). Structure src/lib/pipelines/ bien definie. Tests unitaires pour les transformateurs. |
| 9 | Fine-tuning et prompt engineering avance | ia, data-analyst | 5 | 5 | 5 | SOLIDE | Meta-prompt d'optimisation des prompts. 7 axes (few-shot, CoT, structured output, compression, fallback chains, A/B testing, caching). Protocole migration modèle. Métriques LLM pour @data-analyst. |
| 10 | Design de base de données & optimisation | fullstack, infrastructure | 5 | 5 | 4 | SOLIDE | Schema ERD, indexation justifiee, migrations idempotentes, seed data realiste, RLS multi-tenant. Robustesse 4 : pas de mention de coupure de session dans le champ "quand". |
| 11 | API design & documentation | fullstack, qa | 5 | 5 | 4 | SOLIDE | REST vs tRPC justifie, cursor-based pagination, rate limiting, Zod validation. Lien avec functional-specs pour les payloads. Robustesse 4 : 2 agents seulement, pas de mention de reprise après coupure dans "quand". |
| 12 | Authentification & autorisation | fullstack, infrastructure, legal | 5 | 5 | 5 | SOLIDE | Mindset IA applique (ne pas choisir "plus rapide a coder"). Zéro self-fetch mentionne. RBAC, rate limiting login, RGPD (droit a l'oubli). Tableau comparatif des solutions exige. |
| 13 | Migration de données (v1 -> v2) | fullstack, qa, infrastructure | 5 | 5 | 5 | SOLIDE | Script idempotent, zero-downtime en 2 phases, rollback teste, backup obligatoire avant migration. Validation post-migration avec counts et echantillonnage. |
| 14 | Debug & troubleshooting | fullstack, infrastructure, qa | 4 | 4 | 4 | SOLIDE | Protocole structure en 6 étapes. Seuil de réécriture (10+ edits). Post-mortem léger. Clarte 4 : le placeholder "[DECRIS LE BUG]" dans le prompt est volontaire (template) mais pourrait confondre un utilisateur qui ne le remplace pas. Completude 4 : pas de mention de monitoring/observabilite existant (Sentry, Langfuse) a consulter en premier. |

## Synthese

- **14 prompts audites** : 14 SOLIDE, 0 A Améliorer, 0 PROBLEMATIQUE
- **Score moyen** : Clarte 4.93 / Completude 4.93 / Robustesse 4.64
- **Qualité générale** : Ce batch est le plus homogene des 4 batches. Les prompts techniques Phase 2 sont remarquablement bien structures, avec un sequencage multi-agents clair, des critères de validation binaires, et une prise en compte systématique des fichiers manquants.

## Points d'amélioration mineurs (non bloquants)

1. **Prompts 10 et 11 (DB design, API design)** : ajouter une mention de reprise après coupure dans le champ "quand" (comme les autres prompts le font).
2. **Prompt 14 (Debug)** : ajouter une étape 0 "Consulter l'observabilite existante (Sentry, Langfuse, logs structures)" avant la reproduction manuelle.
3. **Prompt 5 (Gestion erreurs)** : ajouter un fallback pour @design si docs/ux/error-messages.md n'a pas ete produit par @ux.

---

**Handoff -> @orchestrator**
- Fichier produit : `docs/reviews/prompts-audit-batch4.md`
- Décisions prises : 14/14 prompts SOLIDE, aucun prompt problematique dans ce batch
- Points d'attention : 3 améliorations mineures suggerees (robustesse), aucune action bloquante
