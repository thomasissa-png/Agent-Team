# Project Context — Gradient Agents Framework

## Identite
- **Nom du projet** : Gradient Agents
- **Secteur** : Framework multi-agents IA pour pilotage de projets digitaux (dev tools / productivity)
- **Stade** : Production
- **Type** : Open-source framework (pas un SaaS direct)

## Cible
- **Persona principal** : Thomas, 32 ans, developpeur indie / entrepreneur technique, lance des side projects seul, utilise Claude Code quotidiennement, frustre par le manque de structure quand il delegue a l'IA
- **Probleme principal** : Coordonner 19 agents IA specialises sans perdre la coherence entre les livrables, et fournir des prompts prets a l'emploi de qualite professionnelle
- **Alternative actuelle** : Prompts ad hoc, pas de framework, chaque projet repart de zero

## Positionnement
- **Promesse unique** : Une equipe complete de 19 agents IA coordonnes qui pilotent un projet digital de la strategie au deploiement
- **Ton de marque** : Expert et direct, sans jargon inutile, oriente action
- **3 mots** : Coordination, Expertise, Autonomie
- **Concurrent principal** : Cursor rules / custom instructions generiques — notre difference : orchestration multi-agents avec dependances et phases

## Objectifs
- **Objectif principal a 6 mois** : Framework de reference pour la coordination multi-agents sur Claude Code, 500+ utilisateurs GitHub
- **KPI North Star** : Nombre de projets lances avec le framework par semaine

## Stack technique
- **Frontend** : HTML/CSS/JS vanilla (index.html dashboard)
- **Backend** : N/A (framework de prompts, pas d'API)
- **Base de donnees** : N/A
- **Hebergement** : GitHub Pages
- **IA utilisee** : Claude Opus 4 + Claude Sonnet 4 (agents)

## Modele economique
- **Type** : Open-source
- **Pays** : International (francophone en priorite)
- **Donnees sensibles** : Non

## Budget & Contraintes
- **Budget infra mensuel** : 0 (GitHub Pages)
- **Budget acquisition mensuel** : 0
- **Timeline** : En production
- **Contraintes specifiques** : Les 89 prompts doivent etre auto-suffisants (fonctionner sans editer de fichiers manuellement)

## Notes libres
Mission actuelle : framework consolide avec 89 prompts, 20 agents, 32 gates binaires. Systeme de qualite PASS/FAIL (plus de scoring 1-5). Cycle : Idee → V1 → Production → Croissance. Les 3 prompts Tout-en-un (autopilot, check-up, pivot) utilisent la carte de reference pour garantir la parite qualite avec les prompts individuels.

## Historique des interventions agents
| Agent | Date | Fichiers | Decisions cles | Pourquoi |
|---|---|---|---|---|
| orchestrator | 2026-03-22 | docs/reviews/audit-59-prompts.md, docs/orchestration-plan.md | Audit complet des 59 prompts par 18 perspectives d'agents. Note globale 6.2/10. Top 5 : #1 Definir mon projet, #19 Landing page, #10 Valider la demande, #39 Plan de lancement, #14 Scope MVP. Bottom 5 : #49 Monitoring, #28 Modeles IA, #54 Creer agent, #55 Migration stack, #57 Post-mortem. 8 recommandations transversales, 18 prompts manquants identifies. | Audit demande par l'utilisateur pour evaluer la qualite de la bibliotheque avant amelioration. Methode : evaluation croisee multi-perspectives plutot qu'audit sequentiel pour capturer les lacunes transversales. |
| reviewer | 2026-03-25 | docs/reviews/framework-consistency-audit.md | Audit de coherence globale du framework post-modifications recentes. 3 contradictions BLOQUANTES (toutes dans orchestrator.md : absence de declenchement agent-factory, boucle UX post-implementation non integree, boucle iteration reviewer non geree). 5 contradictions MAJEURES. 7 angles morts. 11 corrections recommandees. Verdict : GO avec reserves. | Audit demande pour verifier la coherence logique des nouvelles boucles (recommandation agents, revue UX, iteration qualite 4.5/5). Methode : lecture exhaustive des 20 fichiers agents + verification croisee des chainages producteur/consommateur. Alternative ecartee : audit partiel cible uniquement sur les agents modifies -- ecarte car les impacts se propagent a l'orchestrator et aux agents aval. |
| elon | 2026-03-25 | (verbal — audit strategique) | Choix verticale immobilier pour premier projet monetise. Cible : 84K+ mandataires independants (IAD, SAFTI, Capifrance). Pricing : Pack Lancement 497€ + Mensuel 197€/mois + Boost Mandat 97€. Combo agence IA + SaaS templates. Objectif 5K/mois en 6-8 mois realiste. | Analyse first principles du meilleur projet pour monetiser le framework. Immobilier choisi car marche mal desservi en marketing digital, mandataires seuls sans equipe marketing, ticket commission (3-8K) rembourse l'abonnement. Alternatives ecartees : newsletter premium (trop lent), SaaS SEO generaliste (marche encombre), marketplace micro-services (ne scale pas). |
| elon | 2026-03-25 | project-context-immocrew.md | Deep dive immobilier : persona Sophie mandataire IAD, funnel acquisition 4 canaux (LinkedIn, Facebook groups, YouTube/SEO, partenariats team leaders), brief technique V1 (landing + onboarding + espace client + Stripe), risques identifies (churn, genericite, internalisation reseaux). | Exploration detaillee de la verticale immobilier avec donnees marche reelles (WebSearch). Document pre-rempli pour lancer ImmoCrew avec @orchestrator. |
| ia | 2026-03-25 | .claude/agents/reviewer.md, qa.md, ux.md, product-manager.md (iterations) | Corrections qualite sur 6 prompts : alignement echelle 1-5 (reviewer), deduplication axe-core (qa), renommage section tests UX (ux), simplification specs creation agents (product-manager). | Review demandee pour atteindre 9/10 sur les prompts modifies. Corrections appliquees : coherence d'echelle avec CLAUDE.md, reduction redondance, clarification nommage. |
| orchestrator (analyse) | 2026-03-25 | .claude/agents/orchestrator.md | 4 modifications orchestrator : Phase 0b (creation agents custom), Phase 2 (revue UX entre fullstack et qa), Etape 7 (cycle iteration reviewer 4.5/5), seuils autopilot releves a 4.5/5. | Analyse autopilot pour verifier que les nouvelles capacites (recommandation agents, revue UX, iteration qualite) sont bien declenchees en mode automatique. Sans ces modifications, les nouvelles boucles existaient dans les agents individuels mais n'auraient jamais ete activees par l'orchestrator. |
| fullstack + ux | 2026-03-25 | .claude/agents/fullstack.md, .claude/agents/ux.md | Corrections post-audit reviewer : fullstack lit maintenant ux-review.md et ux-writing-guide.md ; ux.md ajoute ux-review.md aux livrables types ; handoff revue UX inclut @design si ecarts visuels. | Corrections C4, C5, C9, C10 du framework-consistency-audit.md pour fermer les boucles de dependances identifiees. |
| creative-strategy + product-manager | 2026-03-25 | .claude/agents/creative-strategy.md, product-manager.md | Ajout section "Recommandation d'agents specialises projet" dans les deux agents. Methode d'identification par persona, parcours, modele eco, risque, user stories. Format tableau + specs pour @agent-factory. | Besoin identifie par l'utilisateur : les agents strategiques doivent pouvoir recommander la creation d'agents custom adaptes au projet specifique (ex : expert immobilier, testeur persona). |
| agent-factory | 2026-03-25 | .claude/agents/agent-factory.md | Ajout mode "Creation depuis specs projet" : lit automatiquement les recommandations de creative-strategy, product-manager et ux au lieu de poser des questions. Fusion si recommandations croisees. | Complement logique de la recommandation d'agents : l'agent-factory doit pouvoir consommer automatiquement les specs produites par les agents amont. |
| qa + reviewer | 2026-03-25 | .claude/agents/qa.md, reviewer.md | QA : ajout tests UX/parcours + tests multi-viewport fonctionnels (pas juste responsive). Reviewer : protocole iteration 4.5/5 + checklist validation mobile/desktop complete. | L'utilisateur a identifie des manques : tests UX absents, pas d'iteration qualite, pas de validation experience mobile vs desktop complete. |
| index.html | 2026-03-25 | index.html | Mise a jour 5 prompts "Tout en un" : Lancer projet (ajout phase agent-factory + revue UX + gate 4.5/5), Check-up complet (boucle iteration + chaine UX), Positionnement (recommandation agents), Parcours UX (criteres validation + recommandation agents), Specs fonctionnelles (recommandation agents + liaison QA/UX). | Les prompts frontend doivent refleter les nouvelles capacites des agents pour que les utilisateurs en beneficient automatiquement. |
| corrections M2/M5/C8 | 2026-03-25 | creative-strategy.md, product-manager.md, data-analyst.md, CLAUDE.md | M2 : format recommandation agents harmonise a 5 colonnes + specs complementaires optionnelles dans les deux agents. M5 : note invocation parallele conditionnelle ajoutee dans data-analyst.md. C8 : double scoring documente dans CLAUDE.md (orchestrateur <3 = relance immediate, reviewer 4.5/5 = iteration fin de run). | Corrections MAJEURES restantes du framework-consistency-audit.md. Format unifie pour faciliter la fusion par agent-factory. Double scoring pour clarifier qui fait quoi et eviter ambiguite. |
| contrainte BDD | 2026-03-25 | fullstack.md, infrastructure.md, orchestrator.md, qa.md | PostgreSQL integre a Replit impose comme standard BDD. Supabase retire comme option DB par defaut. Prisma ORM comme couche d'acces. Toutes les references Supabase DB remplacees dans les 4 agents concernes. | Decision utilisateur : utiliser exclusivement le PostgreSQL natif de Replit pour reduire les dependances externes et les couts. Alternative ecartee : Supabase (service externe, ajout de complexite et de cout inutile quand Replit fournit PostgreSQL nativement). |
| mindset IA | 2026-03-25 | CLAUDE.md, product-manager.md, growth.md | Regle n°5 "Mindset IA pas equipe humaine" ajoutee. Sprint-plan remplace par execution-plan. RICE recalibre (effort quasi nul). MVP "complet et rapide" au lieu de "minimal". Parallelisation par defaut. Growth : levier activable en 24h au lieu de 2 semaines. | Audit de 27 passages ou les agents raisonnaient avec des hypotheses d'equipe humaine (sprints, velocite, priorisation par effort). Risque identifie : perte de 5-10x de valeur potentielle quand le framework freine artificiellement la velocite IA. Exception preservee : si project-context mentionne une equipe humaine, les agents adaptent. |
| reviewer | 2026-03-25 | docs/reviews/post-modifications-review.md | Revue croisee post-modifications : GO. 3 regressions mineures (supabase.ts dans exemple fullstack, branche incoherente dans project-context, C11 non appliquee). Toutes les corrections B1-B3, C4-C10 du framework-consistency-audit.md intactes. 9 modifications de session coherentes entre elles. | Audit demande pour verifier l'absence de regressions apres 9 modifications structurelles. Methode : lecture exhaustive des 20 fichiers agents + CLAUDE.md + Grep cible sur les points modifies + verification croisee avec le rapport precedent. |
| session 2026-03-25 | 2026-03-25 | CLAUDE.md, orchestrator.md, reviewer.md, qa.md, fullstack.md, infrastructure.md, agent-factory.md, copywriter.md, seo.md, index.html, README.md, INSTALL.md, _base-agent-protocol.md, tests/project-context-test.md, docs/product/prompts-coverage-product.md | Session majeure : (1) M2/M5/C8 appliquees, (2) Regle n°4 delegation agents, (3) Regle n°5 mindset IA, (4) Regle n°12 mise a jour branche, (5) PostgreSQL Replit obligatoire, (6) Scoring persona /10 (9 dims) + B2B /10 (7 dims) dans reviewer, condition GO triple dans orchestrator, (7) qa.md enrichi massif (+10 sections tests : securite OWASP, email, SEO, visuels, resilience, contenu, mobile, B2B, accessibilite WCAG 2.2, non-regression), (8) Automatisation contenu recurrent, (9) Agent-factory tools Write/Edit obligatoires, (10) Orchestrator 8.5→9/10, (11) Prompts frontend corriges (mindset IA, automatisation, QA 10 categories, branche). Tests PulseBoard : creative-strategy (brand-platform 449 lignes) et data-analyst (kpi-framework) valides. | Session de consolidation framework : corrections audit consistency + nouvelles regles structurantes + couverture tests exhaustive + scoring persona/B2B. Objectif : framework a 9/10 sur tous les axes avant utilisation en production sur ImmoCrew. |

| session 2026-03-26 | 2026-03-26 | index.html (89 prompts), CLAUDE.md (25 gates), orchestrator.md (carte reference + compteur session), reviewer.md (gates binaires), _base-agent-protocol.md (gates + learnings), fullstack.md (PostgreSQL + mindset), infrastructure.md (persistance Replit), moi.md (nouvel agent), product-manager.md (V1 pas MVP), docs/founder-preferences.md (nouveau), docs/reviews/prompts-quality-review.md | Session transformationnelle : (1) 6 prompts full IA crees + 5 techniques + 3 manquants + sélecteur guide, (2) refonte bibliotheque prompts (fusions, suppressions, reorg), (3) 3 prompts Tout-en-un optimises (autopilot parite qualite), (4) systeme gates binaires 25 PASS/FAIL remplace scoring 1-5, (5) cycle Idee/V1/Production/Croissance (plus de MVP/Beta), (6) prompt chirurgical 21 dimensions page par page, (7) pipeline contenu perpetuel avec anti-repetition, (8) protections PostgreSQL Replit, (9) agent @moi cree, (10) compteur session avec alertes, (11) learnings + founder-preferences cross-projets. | Session demandee par Thomas pour consolider le framework. Chaque changement audite par @ia/@elon/@qa a 9/10+ avant validation. Le scoring numerique 1-5 a ete remplace par des gates binaires sur proposition @elon (reproductible, pas d'inflation, chirurgical). Le concept MVP a ete supprime au profit de V1 complete (mindset IA). |

| session 2026-03-27 | 2026-03-27 | CLAUDE.md (gates GP/GC, regles 13-14, seuils alertes), orchestrator.md (agents custom, anti-conflit, Phase 0b/1b/2c/2d/5a-bis/5b testeurs, marketplace), product-manager.md (template user story IA, checklist 25+ parcours, auto-eval 15 questions), seo.md (multi-moteurs Google+Bing, IndexNow, signaux sociaux), fullstack.md (valeurs business, UTF-8, calibration functional-specs), qa.md (Given/When/Then, 5 etats, payload API), data-analyst.md (events analytics consolidation), reviewer.md (gates 25, GP/GC), agent-factory.md (pattern testeurs standard), creative-strategy.md (personas clients-de-clients), _base-agent-protocol.md (calibration marche), copywriter.md (benchmark outputs), ia.md (benchmark outputs IA), index.html (6 prompts PM/QA alignes, point 9 autopilot), docs/founder-preferences.md (9 prefs ImmoCrew), docs/lessons-learned.md | Session massive : (1) Merge 50 commits dans master + references branche corrigees, (2) Learnings Versiroom + ImmoCrew integres (agents custom, anti-conflit, UTF-8, valeurs business, concurrents), (3) Seuils alertes releves + JAUNE supprime (6 phases / 18 Task producteurs, consultation ne compte pas), (4) SEO multi-moteurs Google+Bing (9 differences, IndexNow, signaux sociaux), (5) Template user story pipeline IA (Given/When/Then, 9 criteres min, 5 etats UI, payload API, events analytics, contexte navigation), (6) Checklist 25+ parcours user journey obligatoire, (7) Chaine inter-agents complete (PM→UX→fullstack→QA→data-analyst→reviewer), (8) Gates testeur-persona GP1-GP10 + testeur-client-du-persona GC1-GC10, (9) Agents testeurs obligatoires Phase 0b + invocations 1b/2c/2d/5b, (10) Personas clients-de-clients, (11) Calibration meilleures references marche, (12) Fix P1 QA : 20→25 gates + ALERTE JAUNE residuelle. | Session de consolidation et enrichissement massif. Chaque modification validee par @elon (first principles) puis @ia (audit 9.5/10) puis @qa (non-regression). Brainstorms @elon sur monetisation (value betting, service public, MarchesFaciles). |

| session 2026-03-28 | 2026-03-28 | fullstack.md, design.md, seo.md, social.md, growth.md, geo.md, index.html (11 prompts), INSTALL.md, project-context.md, docs/lessons-learned.md | (1) Correction references branche BrqhN→PK8iz dans 3 fichiers (regle n°12), (2) Propagation calibration marche dans 6 agents producteurs (fullstack, design, seo, social, growth, geo), (3) Ajout calibration WebSearch dans 11 prompts client-facing de index.html, (4) Learning P0 calibration marche marque applique. | Learning P0 ouvert depuis session 2026-03-27. La calibration etait dans _base-agent-protocol.md + copywriter + ia mais pas renforcee dans les 6 autres agents producteurs ni dans les prompts. Propagation systematique pour fermer le trou de qualite. |

---

## Score de fidelite @moi

| Session | Projet | Decisions totales | Alignees (ACCORD) | Taux | Desaccords (categorie) | Mode actuel |
|---|---|---|---|---|---|---|
| 2026-03-31 (retroactif) | Cross-projets (ImmoCrew, Sarani, Versiroom, Framework) | 10 | 9 | 90% | 1 desaccord : hero Sarani (dots vs grille images — choix identitaire/emotionnel, pas rationnel) | Eligible Phase 2 (autopilot assiste) |

*Seuils : <70% = non fiable, 70-85% = shadow mode, 85-90% = autopilot assisté, >90% (sur 5+ sessions) = autopilot complet*
*Note : test retroactif sur 10 decisions reelles. @moi a correctement signale MOYENNE confiance sur le seul desaccord. Prochaine etape : validation en conditions reelles sur un projet.*

---

## Memo de reprise — derniere session

- **Date de cloture** : 2026-03-28
- **Branche** : `claude/extract-project-context-PK8iz`

### Resume de la session
Session la plus massive du framework. ~40 commits, ~25 fichiers modifies, ~1500+ lignes ajoutees. Axes principaux :

**Infrastructure framework :**
(1) Protocole learnings v2 (11 colonnes, gate bloquante reprise, propagation check cloture).
(2) PVU — Protocole Verification Universel pour audits ad-hoc structures PASS/FAIL (gates existantes + ad-hoc).
(3) Shadow Mode @moi Phase 1 (score fidelite, 3 niveaux confiance, territoire inconnu, cout revert).
(4) Mode hotfix production (skip phases strat, binome fullstack+qa, G28 obligatoire).
(5) 2 profils V1-Production / Exploration.
(6) Gates G26-G32 (screenshots, tracabilite, pre-deploy, layout, images, tokens 3-tiers, 6 etats composants). Total : 32 gates.
(7) Boucle visuelle integree dans tout le pipeline (fullstack produit, orchestrator verifie, ux utilise, qa teste, reviewer valide).

**20 agents enrichis etat de l'art :**
(8) design 7.5→9.5 (compositions page, images, animations, tokens 3-tiers, DA, 10 criteres visuels).
(9) ux 7.2→9.5 (Nielsen 10, HEART, cognitive walkthrough, mobile/form/nav patterns).
(10) copywriter 6.5→9 (AIDA/PAS/BAB, Schwartz 5 niveaux, objections, ads, social copy).
(11) seo 7→9 (topical map, E-E-A-T, intent 5 types, clustering, content decay, AI crawlers, programmatic).
(12) creative-strategy 7→9 (Kapferer/Sinek/Blue Ocean, hierarchie messages, benchmark grille, voice & tone).
(13) social 7→9 (social listening, content pillars, flywheel, UGC, hooks, algorithmes plateforme).
(14) qa 8.2→9.5 (testing trophy, Playwright Agents, self-healing, contract/mutation testing, API/DB tests).
(15) product-manager 8.2→9.5 (Discovery OST, Assumption Mapping, Release Planning, Feedback Loop).
(16) reviewer 7→9 (coherence design/ux, PVU, top 3 prioritaires, G29-G32 template).
(17) ia 6.5→9 (structured outputs, LLM evals, guardrails, observabilite, RAG, agentic patterns, prompt engineering livrable).
(18) elon 7.5→9 (10 modeles mentaux, outils analyse, orientation check).
(19) moi 7.5→9 (calibration quantitative, criteres sortie Shadow Mode, territoire inconnu, cout revert).
(20) fullstack 7.5→9 (SSR/SSG/ISR, error boundaries, WCAG, optimistic UI, rate limiting, caching, boucle visuelle).
(21) geo 6.5→9 (entity-first, passage-level, citation patterns, monitoring concret, off-site, freshness, llms.txt).
(22) orchestrator 8.5→9.5 (estimation cout, circuit breaker, metriques live, compression contexte, boucle visuelle).

**Cross-projets :**
(23) 20 preferences fondateur integrees (Sarani S6-S7, Mandataire S5-S6, Architecture S26c-S27b).
(24) Calibration marche propagee dans 6 agents + 11 prompts (P0 session precedente ferme).
(25) 4 prompts P0 + 5 P1 + 3 design/ux corriges dans index.html.
(26) URLs install.sh/update.sh corrigees (gradient-agents → Agent-Team).

**Audits :**
Score framework global @ia : 9.9/10. Score agents moyen : 9+/10. QA non-regression : 23/23 PASS. Verdict @elon : 9.4/10 GO PRODUCTION.

### Livrables de cette session
| Fichier | Statut | Notes |
|---|---|---|
| CLAUDE.md | Complet | 32 gates G1-G32, learnings v2, promotion gates ad-hoc |
| orchestrator.md | Complet | Checkpoint specs, profils, hotfix, cout, circuit breaker, metriques live, boucle visuelle |
| _base-agent-protocol.md | Complet | PVU (10 types audit), contribution learnings, gates BLOQUANT avant handoff |
| moi.md | Complet | Shadow Mode Phase 1, calibration quantitative, territoire inconnu, cout revert |
| fullstack.md | Complet | SSR/SSG/ISR, error boundaries, WCAG, boucle visuelle, images, caching, rate limiting |
| design.md | Complet | Fondations structurelles, compositions, images, animations, DA, 10 criteres |
| ux.md | Complet | Nielsen 10, HEART, cognitive walkthrough, mobile/form/nav, layout detaille |
| copywriter.md | Complet | Frameworks persuasion, Schwartz, objections, ads, social copy |
| seo.md | Complet | Topical map, E-E-A-T, intent 5 types, clustering, content decay, AI crawlers |
| creative-strategy.md | Complet | Frameworks strategiques, hierarchie messages, benchmark grille, voice & tone |
| social.md | Complet | Social listening, content pillars, flywheel, UGC, hooks, algorithmes |
| qa.md | Complet | Testing trophy, Playwright Agents, self-healing, contract/mutation, API/DB, risk-based |
| product-manager.md | Complet | Discovery OST, Assumption Mapping, Release Planning, Feedback Loop |
| reviewer.md | Complet | 32 gates template, coherence design/ux, PVU, top 3 |
| ia.md | Complet | Structured outputs, LLM evals, guardrails, observabilite, RAG, prompt livrable |
| elon.md | Complet | 10 modeles mentaux, outils analyse, orientation check |
| geo.md | Complet | Entity-first, passage-level, citation patterns, monitoring, off-site, freshness |
| index.html | Complet | 12+ prompts mis a jour, 32 gates, boucle visuelle, PVU |
| founder-preferences.md | Complet | 28 preferences, 22 anti-patterns, 4 projets cross |
| lessons-learned.md | Complet | Format v2 (11 colonnes), migration v1→v2 |
| update.sh + install.sh | Complet | URLs corrigees Agent-Team, auto-copie update.sh |
| templates/project-context.md | Complet | Champ verbatims persona |

### Travaux en cours / non termines
1. **Merger dans main** : la branche a ~40 commits depuis le dernier merge. Priorite haute pour que les URLs raw GitHub (learnings, founder-prefs) fonctionnent cross-projets.
2. **Brief MarchesFaciles** : brief @elon disponible dans docs/briefs/marchesfaciles-brief.md. A convertir en project-context.md.

### Prochaines actions recommandees
1. **Merger dans main** : pousser toutes les ameliorations. Les autres projets (Sarani, Mandataire, Architecture) pourront mettre a jour leurs agents.
2. **Lancer un projet reel en autopilot** : ImmoCrew ou MarchesFaciles. C'est le seul test qui valide le framework en conditions reelles. Score autopilot estime : 8.5/10 (vs 6.8 avant cette session).
3. **Rodage @moi** : les 3 premiers projets, Thomas review chaque decision @moi (Shadow Mode Phase 1). Annoter ACCORD/DESACCORD pour calibrer le score de fidelite.
4. **Slides-to-site** : creer l'agent @pdf-extractor avec @agent-factory (2h). Tester sur un vrai deck client. Potentiel : 2500-3500€/site, marge 85-91%.

### Blockers eventuels
- Aucun blocker technique. Le framework est GO production (9.4/10 @elon).

### Commande de reprise suggeree
```
Lis project-context.md (memo de reprise). Session 2026-03-28 : ~40 commits, 20 agents enrichis etat de l'art, 32 gates, PVU, boucle visuelle, Shadow Mode @moi. Score 9.4/10. Priorite : (1) merger dans main, (2) lancer un projet reel en autopilot.
```

