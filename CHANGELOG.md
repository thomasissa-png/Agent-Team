# Changelog — Gradient Agents Framework

Historique des modifications du framework. Ce fichier est séparé du CLAUDE.md pour garder les instructions opérationnelles courtes et scannable.

---

## Session du 2026-06-11 (S5) — Cure "trust the model" : 20 agents + protocole réécrits (v3.0), -2 800L

1. **Audit complet 4 agents parallèles** (@reviewer NO-GO cohérence, @ia agents + prompts, @elon stratégique) — rapports dans `docs/reviews/*-2026-06-11.md`. Constat : la cure S4 avait corrigé les sources de vérité mais pas leurs consommateurs (reviewer.md et _base-agent-protocol.md citaient encore "32 gates G1-G32", @moi mort référencé dans 3 agents, ~47 refs de gates supprimées).
2. **Réécriture des 20 agents en version 3.0** (principe : garder le spécifique au projet et les learnings empiriques, couper le savoir générique qu'un LLM moderne possède déjà — tableaux AIDA/Schwartz, personas décoratifs, sections héritées dupliquées). Agents : ~5 700L → ~1 900L (-67%). Orchestrator 749→217L, agent-factory 444→132L, fullstack 423→118L. Zéro learning cross-projets perdu (self-fetch, SQL idempotent, bottom sheet iOS, Pattern A/B, testing honesty, walkthrough, 10 critères Thomas, etc. tous conservés).
3. **_base-agent-protocol.md réécrit** (470→152L) : aligné 9 gates + G_PROOF, REPLIT_ACTIONS retiré, PVU sur _gates.md, chiffres périmés corrigés.
4. **Corrections de comptes partout** : 20 agents (sales-enablement ajouté aux listes modèles CLAUDE.md et project-context = 12 Sonnet), 94 prompts, 9 gates. INSTALL.md 19→20.
5. **"Un fait = un endroit" outillé** : `tests/validate-framework.sh` vérifie la cohérence des comptes contre les SOT (ls agents / _gates.md / index.html) et détecte les références mortes post-cure (@moi, REPLIT_ACTIONS, G1-G32) dans les fichiers actifs. Whitelist modèles corrigée (Opus 4.8 accepté). `validate-context.sh` tolérant aux accents. Suite `run-all.sh` : 0 erreur.
6. **Cure prompts (94→91, même session)** : audit qualité individuel des 94 prompts (rapport `docs/reviews/prompts-quality-audit-fable-2026-06-11.md`, moyenne 7.5/10) puis application — fusions Onboarding (gamifié + optimiser) et Emailing (séquences + automation), suppression du doublon "SEO + GEO combinés", dégraissage du savoir générique (reporting investisseurs, veille, responsive, API, auth), retrait du boilerplate benchmark ×12 (hérité du protocole), prompt moat en verdicts FORT/FAIBLE/ABSENT. Compteurs 91 propagés (meta, sélecteur, card MAJ, orchestrator, project-context) ; check anti-drift rendu dynamique ; whitelist modèles épurée (opus-4-6 retiré — plus aucune vieille version Claude acceptée).
7. **Routage automatique + orchestrator honnête** : plus besoin de taper `@agent` — CLAUDE.md route automatiquement (la session principale délègue via Task, `@agent` = override). `orchestrator.md` reformulé : pas un 20e agent mais le protocole de coordination de la session principale (les sous-agents ne peuvent pas spawner de sous-agents — la fiction du "chef d'orchestre" séparé est levée). "Zéro production directe" assoupli en "délégation par défaut" avec exceptions explicites (éditions transverses, synthèses, git, demande utilisateur). README + INSTALL alignés.
8. **Orchestrator rétrogradé d'agent à protocole** : `orchestrator.md` → `_orchestration-protocol.md` (frontmatter retiré, préfixe `_` comme `_base-agent-protocol.md`) — il n'est plus enregistré comme 20e agent invocable. La session principale EST l'orchestrator (un sous-agent ne peut pas spawner de sous-agents). Roster honnête : **19 agents spécialisés + 1 protocole de coordination**. CLAUDE.md Modèles 8→7 Opus + ligne protocole ; comptes 20→19 propagés (meta/og/hero/cards index.html, README, INSTALL, project-context) ; chemins mis à jour (agent-factory, perf-trend M5, validation, test-scenarios) ; check anti-drift compte 19 (hors `_*`) dynamiquement. La card MAJ ajoute `rm orchestrator.md` (renommé).
9. **Anti tiret cadratin (—)** : le — est une signature d'écriture IA. Retiré du brand-facing d'index.html (titres, méta/og/twitter, sous-titres, cartes install/sessions), reformulé proprement. Règle gravée comme commandement commun (CLAUDE.md n°12) + question d'auto-éval copywriter + préférence fondateur cross-projets : aucun — dans le site, le copy, les emails, les posts et les livrables clients (pas exigé dans les instructions internes). Garde-fou ajouté à `validate-framework.sh` (brand-facing scanné). Bug compteur '99 prompts' corrigé en 91 + check compteur durci.
10. **Migration Sonnet 5** : les 12 agents Sonnet passent de `claude-sonnet-4-6` à `claude-sonnet-5` (frontmatters, cartes index.html, template agent-factory, exemple d'alias ia.md, whitelist validation). Les 7 agents Opus restent sur `claude-opus-4-8` (version courante). CLAUDE.md section Modèles devient la SOT des IDs (Opus 4.8 / Sonnet 5). Garde anti-régression ajouté à `validate-framework.sh` : refuse toute version Claude obsolète (sonnet-4, opus-4-6/7, claude-3) dans les fichiers actifs. Propagation aux autres projets via `update.sh --all`. Cartes du site resynchronisées (versions = .md : 12 Sonnet en v4.0 suite au bump de modèle, 7 Opus en v3.0), tirets longs retirés des champs role/phase/desc des cartes, carte orchestrator reframée en protocole (le site affichait 20 cartes en annonçant 19 agents). Tiering 7 Opus / 12 Sonnet confirmé inchangé : juste par type de tâche, Sonnet 5 rend les agents Sonnet meilleurs sans re-tiering.
11. **Décisions** : GP/GC purgées des phases obligatoires (testeurs = optionnels via @agent-factory, conforme décision S4) ; SOT prompts = index.html (91 après cure prompts).

---

## Session du 2026-03-22 — 20 nouveaux prompts (39→59) post-audits de couverture

**Ce qui a ete fait :**

1. **Consolidation de 5 audits de couverture** : @elon (6/10), @creative-strategy (5.5/10), @growth (3/10), @product-manager, @design — identification des prompts manquants avec deduplication croisee
2. **20 nouveaux prompts ajoutes** dans `index.html` (39→59 prompts) :
   - Phase 0 (6) : Valider la demande, Proposition de valeur, Messaging matrix, Pricing, Scope MVP, Storytelling
   - Phase 1 (4) : Direction artistique, Identite verbale, Specs interaction composants, Specs responsive
   - Phase 2 (2) : Setup initial projet, Audit handoff design→code
   - Phase 3 (1) : Strategie de contenu & calendrier editorial
   - Phase 4 (5) : Plan de lancement, Referral, Retention/churn, PLG, PMF
   - Raccourcis (2) : Feedback & roadmap v2, A/B testing
3. **Standard 9/10 applique** : chaque prompt inclut le pattern d'autonomie ("Lis [fichier]. S'il n'existe pas, pose-moi les questions..."), les chemins de livrables explicites, le chainage multi-agents avec handoffs, et les notes anti-timeout quand pertinent
4. **8 prompts dedupliques** : Naming, Unit economics, Scalabilite technique, Sprint planning, Retrospective, Upsell/expansion, Scale 1K-10K, Prototype interactif — fusionnes ou integres dans les prompts existants/nouveaux
5. **Plan d'orchestration** : `docs/orchestration-plan-new-prompts.md` mis a jour avec la liste consolidee, la methode de deduplication, et les prompts non retenus avec justification

**Decisions de conception :**
- Priorite aux prompts couvrant les phases manquantes du cycle business (retention, monetisation, validation marche) plutot qu'a la granularite operationnelle (sprint planning, retrospective)
- Les prompts de scale (1K→10K) et d'expansion revenue integres dans PMF et PLG plutot qu'isoles
- Le naming reste geerable via le prompt brand-platform existant (ajout optionnel si demande)

---

## Session du 2026-03-22 — Compaction + @elon + audit 9/10

**Ce qui a été fait :**

1. **Compaction des 19 agents** : sections dupliquées (timeouts, escalade, mode révision, auto-éval, protocole de fin) remplacées par références à `CLAUDE.md` et `_base-agent-protocol.md` → ~900 lignes éliminées
2. **Création de @elon** : agent stratégique incarnant Elon Musk — first principles thinking, audit brutal, scoring sur 10, modes Audit/Conseil/Challenge, communication structurée avec @orchestrator
3. **Dashboard HTML** (`index.html`) : ajout de @agent-factory et @elon (17→19 agents)
4. **Auto-évaluations enrichies** : tous les 19 agents ont maintenant 5+ questions spécifiques
5. **Audit final @elon** : 9/10 sur les 10 dimensions (architecture, qualité agents, calibrations, orchestration, erreurs, tests, doc, versioning, cohérence, impact)

**Décisions de conception :**
- @elon est un agent hors-phase, invocable à tout moment pour auditer le framework ou les projets
- @elon peut émettre des verdicts GO/PIVOT/KILL sur les projets et communiquer à @orchestrator
- Le nombre d'agents reste à 19 (18 opérationnels + @elon advisory) — pas d'inflation

---

## Session du 2026-03-22 — Audit Elon Musk initial + implémentation

**Ce qui a été fait :**

1. **Versioning agents** : ajout de `version: "1.0"` dans le frontmatter des 18 agents
2. **Protocole de base centralisé** : création de `_base-agent-protocol.md` — les sections communes ne sont plus dupliquées dans chaque agent
3. **Calibrations croisées corrigées** : @design←user-flows, @qa←design-tokens+WebSearch, @social←growth-strategy, @fullstack←champs critiques enrichis, @creative-strategy←growth, @data-analyst←growth
4. **Personas renforcés** : opinions fortes ajoutées à @copywriter, @seo, @ia, @social, @geo
5. **CLAUDE.md nettoyé** : journal extrait dans CHANGELOG.md, instructions opérationnelles compactées
6. **Infrastructure de test** : projet-test fictif dans `tests/`, scoring automatique post-livrable
7. **Mécanismes de disruption** : mémoire organisationnelle (`docs/lessons-learned.md`), mode autopilot pour l'orchestrateur
8. **Auto-évaluations enrichies** : @copywriter, @ia, @reviewer portés à 5+ questions spécifiques
9. **Exception chemin livrables** : documentée pour @agent-factory et @orchestrator
10. **@agent-factory v2** : déduplication, sections domaine, mini-templates format, test fonctionnel, garde-fous batch/niche/dépréciation

**Décisions de conception :**
- Les agents héritent des règles communes via CLAUDE.md (toujours en contexte) — pas de duplication
- Le `_base-agent-protocol.md` est une référence, pas un agent exécutable
- Versioning par agent permet de figer une version par projet
- Le journal de setup sort du CLAUDE.md pour garder les instructions ≤200 lignes

---

## Session du 2026-03-22 — Ajout de @agent-factory

**Ce qui a été fait :**

1. **Nouvel agent `@agent-factory`** créé dans `.claude/agents/agent-factory.md` — agent capable de créer des agents spécialisés sur mesure pour chaque projet (architecte, directeur podcast, trader, SFX, etc.)

2. **Processus en 5 étapes** intégré dans l'agent :
   - Recueil du besoin (rôle, mission, livrables, interactions, outils, domaine)
   - Vérification anti-doublon (pas de chevauchement avec agents existants)
   - Construction selon le template canonique exact du framework
   - Intégration dans le framework (CLAUDE.md + orchestrator.md)
   - Validation via checklist de conformité (15 points)

3. **Intégrations** : CLAUDE.md mis à jour (tableau priorité, convention d'appel, compteur 18 agents), orchestrator.md mis à jour (mapping subagent_type)

**Décisions de conception :**
- L'agent-factory lit TOUS les agents existants avant de créer (calibration complète) — évite les doublons
- WebSearch obligatoire si le domaine est inconnu — l'agent ne fabrique jamais un expert sur un domaine qu'il ne comprend pas
- Le template canonique est intégré dans le processus de création, pas dans un fichier séparé — évite la désynchronisation
- L'agent-factory peut aussi modifier des agents existants (mode révision) — pas seulement en créer de nouveaux

---

## Session du 2026-03-22 — Enrichissements et audit qualité

**Ce qui a été fait :**

1. **Règle absolue numéro 2 — Zéro invention de données** : ajoutée au CLAUDE.md et aux 18 agents
2. **Enrichissement des agents** (cas d'usage manquants) :
   - @growth : rétention, churn, pricing & packaging, expansion revenue
   - @data-analyst : roadmap CRO, analyse rétention cohortes, attribution
   - @product-manager : recherche utilisateur, pricing, feedback loops
   - @copywriter : help center, knowledge base, changelog
   - @fullstack : API publique RESTful, webhooks, SDK client
3. **Tableau de performance des agents** ajouté au template project-context.md
4. **Audit complet par @ia** — note moyenne 8.47/10. Rapport dans `docs/ia/agent-audit-report.md`
5. **Implémentation des 7 recommandations de l'audit** (P0-1 à P2-7)
6. **Fix installation** : instructions corrigées pour installer `.claude/agents/` à la racine du repo git

**Décisions prises :**
- Enrichir les agents existants plutôt que créer de nouveaux agents (éviter la complexité)
- La règle anti-invention est la plus importante du framework — un livrable incomplet vaut mieux qu'un livrable faux
- Les calibrations croisées sont le levier #1 de cohérence inter-agents

---

## Session du 2026-03-21 — Setup initial du framework Gradient Agents

**Ce qui a été fait :**

1. **18 agents créés** dans `.claude/agents/` — structure homogène (identité, compétences, protocoles, calibration, handoff)
2. **Agents disponibles :** orchestrator, fullstack, qa, design, ux, copywriter, seo, geo, ia, infrastructure, creative-strategy, product-manager, data-analyst, growth, social, reviewer, legal, agent-factory
3. **Template project-context.md** créé dans `templates/`
4. **CLAUDE.md** — instructions globales, conventions, règles

**Décisions de conception :**
- Modèle claude-opus-4-6 pour tous les agents (qualité maximale)
- Orchestrateur limité à 3 sous-agents par message (anti-timeout)
- Convention de chemins stricte (`docs/[agent]/`) vérifiée par @reviewer
- Langue : français pour tout sauf code et termes techniques
