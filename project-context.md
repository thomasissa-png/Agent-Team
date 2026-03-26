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
- **Contraintes specifiques** : Les 59 prompts doivent etre auto-suffisants (fonctionner sans editer de fichiers manuellement)

## Notes libres
Mission actuelle : audit exhaustif des 59 prompts de la bibliotheque par les 18 agents du framework. Chaque agent evalue selon sa perspective propre.

## Historique des interventions agents
| Agent | Date | Fichiers | Decisions cles | Pourquoi |
|---|---|---|---|---|
| orchestrator | 2026-03-22 | docs/reviews/audit-59-prompts.md, docs/orchestration-plan.md | Audit complet des 59 prompts par 18 perspectives d'agents. Note globale 6.2/10. Top 5 : #1 Definir mon projet, #19 Landing page, #10 Valider la demande, #39 Plan de lancement, #14 Scope MVP. Bottom 5 : #49 Monitoring, #28 Modeles IA, #54 Creer agent, #55 Migration stack, #57 Post-mortem. 8 recommandations transversales, 18 prompts manquants identifies. | Audit demande par l'utilisateur pour evaluer la qualite de la bibliotheque avant amelioration. Methode : evaluation croisee multi-perspectives plutot qu'audit sequentiel pour capturer les lacunes transversales. |
| reviewer | 2026-03-25 | docs/reviews/framework-consistency-audit.md | Audit de coherence globale du framework post-modifications recentes. 3 contradictions BLOQUANTES (toutes dans orchestrator.md : absence de declenchement agent-factory, boucle UX post-implementation non integree, boucle iteration reviewer non geree). 5 contradictions MAJEURES. 7 angles morts. 11 corrections recommandees. Verdict : GO avec reserves. | Audit demande pour verifier la coherence logique des nouvelles boucles (recommandation agents, revue UX, iteration qualite 4.5/5). Methode : lecture exhaustive des 20 fichiers agents + verification croisee des chainages producteur/consommateur. Alternative ecartee : audit partiel cible uniquement sur les agents modifies -- ecarte car les impacts se propagent a l'orchestrator et aux agents aval. |
| elon | 2026-03-25 | (verbal — audit strategique) | Choix verticale immobilier pour premier projet monetise. Cible : 84K+ mandataires independants (IAD, SAFTI, Capifrance). Pricing : Pack Lancement 497€ + Mensuel 197€/mois + Boost Mandat 97€. Combo agence IA + SaaS templates. Objectif 5K/mois en 6-8 mois realiste. | Analyse first principles du meilleur projet pour monetiser le framework. Immobilier choisi car marche mal desservi en marketing digital, mandataires seuls sans equipe marketing, ticket commission (3-8K) rembourse l'abonnement. Alternatives ecartees : newsletter premium (trop lent), SaaS SEO generaliste (marche encombre), marketplace micro-services (ne scale pas). |
| elon | 2026-03-25 | project-context-immocrew.md | Deep dive immobilier : persona Sophie mandataire IAD, funnel acquisition 4 canaux (LinkedIn, Facebook groups, YouTube/SEO, partenariats team leaders), brief technique MVP (landing + onboarding + espace client + Stripe), risques identifies (churn, genericite, internalisation reseaux). | Exploration detaillee de la verticale immobilier avec donnees marche reelles (WebSearch). Document pre-rempli pour lancer ImmoCrew avec @orchestrator. |
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

---

## Memo de reprise — derniere session

- **Date de cloture** : 2026-03-25
- **Branche** : `claude/setup-project-context-ALWvD`

### Resume de la session
Session de consolidation majeure du framework Gradient Agents. 26 fichiers modifies, +679 lignes. Axes principaux : (1) Corrections M2/M5/C8 du framework-consistency-audit appliquees. (2) 5 nouvelles regles structurantes dans CLAUDE.md : delegation obligatoire aux agents (n°4), mindset IA pas equipe humaine (n°5), objectif qualite 9/10 (n°11), mise a jour branche obligatoire (n°12), automatisation contenu recurrent. (3) PostgreSQL Replit impose comme standard BDD (Supabase retire). (4) qa.md enrichi massivement : 10 nouvelles sections de tests (securite OWASP, email, SEO, visuels, resilience, contenu, mobile, B2B, accessibilite WCAG 2.2, non-regression). (5) reviewer.md : scoring persona /10 (9 dimensions) + B2B /10 (7 dimensions), condition GO triple, mapping dimension→agent. (6) orchestrator.md : Phases 3/4 parallelisees, template synthesis avec scores, critere automatisation contenu. (7) agent-factory.md : tools Write/Edit obligatoires par defaut. (8) Prompts frontend : mindset IA, automatisation, QA 10 categories, prompt Audit cible ajoute. Tests PulseBoard valides (creative-strategy + data-analyst).

### Livrables de cette session
| Fichier | Statut | Notes |
|---|---|---|
| CLAUDE.md | Complet | Regles n°4, n°5, n°11, n°12, scoring double, automatisation contenu |
| .claude/agents/orchestrator.md | Complet | Phases 3/4 parallelisees, synthesis scores, critere automatisation, 9/10 |
| .claude/agents/reviewer.md | Complet | Scoring persona 9 dims /10, B2B 7 dims /10, mapping agents, template rapport |
| .claude/agents/qa.md | Complet | +10 sections tests, 10 questions auto-eval |
| .claude/agents/fullstack.md | Complet | PostgreSQL Replit, timeouts services, prisma.ts |
| .claude/agents/infrastructure.md | Complet | OWASP Top 10, delivrabilite email, Lighthouse mobile |
| .claude/agents/product-manager.md | Complet | Execution-plan, RICE recalibre, mindset IA |
| .claude/agents/agent-factory.md | Complet | Tools Write/Edit obligatoires, checklist validation |
| .claude/agents/copywriter.md | Complet | Check persona + B2B double audience |
| .claude/agents/seo.md | Complet | Pipeline contenu automatise |
| .claude/agents/_base-agent-protocol.md | Complet | Auto-eval 9/10, 5 questions avec criteres |
| index.html | Complet | Prompt Audit cible, QA 10 categories, automatisation, mindset IA, branche |
| README.md | Complet | PostgreSQL Replit au lieu de Supabase |
| INSTALL.md | Complet | Branche mise a jour |
| tests/project-context-test.md | Complet | PostgreSQL Replit |
| docs/strategy/brand-platform.md | Complet | Test PulseBoard — creative-strategy 449 lignes |
| docs/analytics/kpi-framework.md | Complet | Test PulseBoard — data-analyst avec benchmarks sources |

### Travaux en cours / non termines
1. **Prompt "Audit cible" ameliore** : @ia a produit une version amelioree (pre-verification, 17 sujets, validation reviewer integree) mais les changements n'ont pas ete appliques dans index.html (contexte agent isole). A appliquer manuellement a la prochaine session.
2. **Projet ImmoCrew** : project-context-immocrew.md est pret mais le projet n'est pas encore lance.

### Prochaines actions recommandees
1. **Appliquer les ameliorations du prompt "Audit cible"** : recuperer la version amelioree par @ia (17 sujets, pre-verification, validation reviewer). Agent : edition directe. Priorite : basse — le prompt actuel fonctionne.
2. **Lancer ImmoCrew** : copier project-context-immocrew.md comme project-context.md dans un nouveau repo, lancer @orchestrator. Agent : @orchestrator. Priorite : haute si l'objectif est de monetiser rapidement.
3. **Test E2E complet PulseBoard** : lancer un run complet @orchestrator en mode autopilot sur PulseBoard pour valider toutes les nouvelles boucles (agent-factory, revue UX, iteration 4.5/5, scoring persona/B2B). Agent : @orchestrator. Priorite : haute pour valider le framework a 9/10 en conditions reelles.

### Blockers eventuels
- Aucun blocker technique. Le framework est a 9/10 sur tous les axes audites.
- Livrables de test PulseBoard (docs/strategy/brand-platform.md, docs/analytics/kpi-framework.md) presents dans le repo — les supprimer avant un vrai run pour eviter la confusion.

### Commande de reprise suggeree

Pour le **framework Gradient Agents** :
```
Lis project-context.md (memo de reprise). Le framework est consolide a 9/10. Il reste : (1) appliquer les ameliorations du prompt "Audit cible" dans index.html, (2) nettoyer les livrables de test PulseBoard, (3) optionnel : lancer un test E2E complet sur PulseBoard en mode autopilot.
```

Pour le **projet ImmoCrew** (nouveau repo) :
```
@orchestrator Lis project-context.md. Lance le projet ImmoCrew en mode autopilot. Phase 1 prioritaire : landing page + formulaire d'onboarding + espace client + Stripe. En parallele : @creative-strategy sur le brand platform et @copywriter sur les premiers livrables demo (avant/apres d'une annonce immobiliere reecrite). Objectif : site operationnel rapidement.
```
