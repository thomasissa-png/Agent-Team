# Audit global du framework Gradient Agents

**Agent** : @ia | **Date** : 2026-04-02 | **Scope** : Architecture agents, pipeline qualite, performance IA, coherence globale

**Methode** : analyse structurelle des 22 fichiers agents (6630 lignes), CLAUDE.md (504 lignes), project-context.md, echantillonnage de 5 agents (orchestrator, fullstack, reviewer, ia, design). Findings issus de deux passes d'analyse.

---

## Axe 1 — Architecture des agents | Verdict : PASS

**Points forts** :
- 22 agents couvrent l'integralite du cycle projet (strategie, produit, code, qualite, croissance, legal). Aucun trou fonctionnel identifie.
- Chaine de dependances bien documentee : creative-strategy produit brand-platform.md, consomme par copywriter, design, seo. product-manager produit functional-specs.md, consomme par fullstack, qa, ux. Pas de boucle circulaire.
- Le protocole de base (_base-agent-protocol.md, 377 lignes) factorise correctement les regles communes (calibration, escalade, handoff, auto-evaluation). Chaque agent herite sans duplication.
- agent-factory permet la creation d'agents custom par projet (testeur-persona, expert sectoriel) — extension propre du framework.

**Points d'attention** :
- **Ratio orchestrator vs agents** : orchestrator.md represente 17% du volume total (1144/6630 lignes). C'est un point de fragilite — un fichier aussi long risque d'etre tronque en contexte avant d'etre lu completement. Les sections post-ligne-800 (metriques live, compression contexte) sont en zone a risque de coupure.
- **Agents legers sous-specifies** : legal (113 lignes), data-analyst (116 lignes) et growth (145 lignes) sont 3-4x plus courts que fullstack (376) ou qa (332). Cela peut indiquer un manque de profondeur dans leurs protocoles specifiques.
- **Pas de graphe de dependances machine-readable** : les dependances inter-agents sont documentees en prose dans chaque agent. Un fichier `agent-dependencies.json` permettrait a l'orchestrator de valider automatiquement les pre-requis.

**Recommandation** : decouper orchestrator.md en orchestrator-core.md (~400 lignes, boucle principale) + orchestrator-reference.md (~700 lignes, templates, metriques, modes speciaux). Le core est charge systematiquement, la reference est chargee a la demande.

---

## Axe 2 — Efficacite du pipeline qualite | Verdict : PASS avec reserve

**Points forts** :
- Systeme de 32 gates binaires PASS/FAIL — reproductible, pas d'inflation de scores, verification par Grep/Read automatisable. Nettement superieur a l'ancien scoring 1-5.
- Classification BLOQUANT/REQUIS/CONDITIONNEL claire — permet le triage : un BLOQUANT FAIL declenche une relance immediate, pas un REQUIS FAIL.
- Gates persona GP1-GP10 et client GC1-GC10 ajoutent une couche de validation experiencielle au-dela de la conformite technique.
- Pipeline pre-deploy (G28 : tsc + lint + build) promu BLOQUANT — justifie par les donnees (40% des commits etaient des fix post-commit).

**Points d'attention** :
- **Cout cognitif des 32 gates** : un reviewer (humain ou IA) qui execute les 32 gates sur chaque livrable consomme un volume significatif de tokens et de temps. Sur un projet a 10 livrables, c'est 320 evaluations de gates. Le ROI est positif pour les gates BLOQUANT (evitent les regressions couteuses), mais certaines gates REQUIS a faible impact (G16 "nom cite 3 fois", G17 "persona cite 2 fois") ajoutent du bruit sans prevenir de vrais defauts.
- **Residu scoring 1-5 detecte** : orchestrator.md ligne 870 contient `Score moyen des livrables : X/5` dans un template de checkpoint. C'est un residu de l'ancien systeme — incoherent avec le systeme gates PASS/FAIL documente partout ailleurs. Bug mineur mais source potentielle de confusion.
- **Pas de fast-track pour livrables mineurs** : un correctif de 5 lignes dans un prompt passe par les memes 32 gates qu'une refonte complete. Un mode "light review" (gates BLOQUANT uniquement) pour les changements mineurs reduirait l'overhead.

**Recommandation** : (1) Corriger le residu X/5 dans orchestrator.md. (2) Introduire un mode review "light" (gates BLOQUANT only) pour les changements < 20 lignes. (3) Envisager de fusionner G16+G17+G18 en une seule gate "specificite minimum" (nom projet + persona + refs amont).

---

## Axe 3 — Performance IA (couts, contexte, timeout) | Verdict : PASS avec reserve

**Points forts** :
- Strategie bi-modele (Opus pour raisonnement complexe, Sonnet pour production) est le bon pattern — economies estimees 40-60% vs tout-Opus.
- Regle anti-timeout (Regle n3) bien concue : decoupage par fichier, sauvegarde incrementale, limites de Task par message, compteur de session avec alerte rouge.
- Prompt caching Anthropic mentionne dans ia.md — les system prompts stables (agent definitions) beneficient du caching ephemeral.

**Points d'attention** :
- **Budget contexte critique** : CLAUDE.md (504 lignes) + orchestrator.md (1144 lignes) + _base-agent-protocol.md (377 lignes) = 2025 lignes de contexte charge AVANT que l'agent lise le project-context ou produise quoi que ce soit. En comptant ~3 tokens/ligne, c'est ~6000 tokens de system prompt incompressible. Pour un agent comme @fullstack qui charge aussi fullstack.md (376 lignes), on atteint ~7100 tokens de contexte statique.
- **Pas de budget-tokens explicite par agent** : ia.md documente les caps de contexte dynamique (3000 tokens par source) mais il n'y a pas de budget global par agent. Un agent qui recoit un project-context de 200 lignes + 5 livrables amont en reference peut saturer sa fenetre utile.
- **Cout non mesure en production** : le framework recommande l'observabilite LLM (Langfuse, Helicone) mais ne l'applique pas a lui-meme. Combien coute une session d'orchestration complete ? L'information n'existe pas. Pour un framework qui prone le ROI mesurable, c'est un angle mort.
- **Risque timeout sur orchestrator** : avec 1144 lignes de prompt + coordination de 10+ agents par session, l'orchestrator est le plus expose aux timeouts. Le compteur de session (6 phases / 18 Task max) est une mitigation, mais pas une garantie.

**Recommandation** : (1) Mesurer le cout tokens reel d'une session type (strategie-to-deploy) et le documenter dans project-context.md. (2) Ajouter un budget contexte max recommande par agent (~8000 tokens system + ~4000 tokens dynamiques). (3) Investiguer le split d'orchestrator.md (voir Axe 1).

---

## Axe 4 — Coherence globale | Verdict : PASS

**Points forts** :
- Supabase correctement nettoye — les 3 mentions restantes (moi.md, fullstack.md, infrastructure.md) sont toutes en negatif ("ne PAS utiliser"). Aucune reference positive residuelle.
- Le systeme de learnings v2 (11 colonnes, gate bloquante de reprise, propagation check) est un mecanisme de coherence inter-sessions robuste. Les learnings P0/P1 non-propages bloquent la reprise — bon pattern.
- Les regles de CLAUDE.md (n1 a n6) sont referenceees de maniere coherente dans les agents.
- Le cycle Idee/V1/Production/Croissance a remplace MVP/Beta partout — grep confirme l'absence de references residuelles a "MVP" dans les agents.

**Points d'attention** :
- **Residu scoring 1-5 (orchestrator.md:870)** : deja identifie en Axe 2. Seule incoherence detectee avec le systeme gates PASS/FAIL.
- **Qualite (1-5) dans ia.md** : la grille de selection de modeles utilise "Qualite (1-5)". C'est un usage DIFFERENT du scoring de livrables — c'est une echelle comparative entre modeles IA, pas un score de qualite de livrable. Usage acceptable et non-confusant dans son contexte.
- **Double section "Blockers eventuels" et "Commande de reprise suggeree"** dans project-context.md (lignes 155-178) : duplication residuelle de deux sessions. Le memo de reprise devrait n'avoir qu'une seule instance de chaque section (la plus recente).
- **Regles n1-n6 mais pas n7+** : CLAUDE.md definit les Regles n1 a n6 comme "absolues". D'autres regles tout aussi importantes (13: UTF-8, 14: zero concurrent, 15: Replit actions, 16: emails draft) sont numerotees mais pas qualifiees d'"absolues". Pas de contradiction, mais l'escalade de severite n'est pas uniforme.

**Recommandation** : (1) Corriger le residu X/5 (orchestrator.md:870). (2) Nettoyer la duplication dans project-context.md. (3) Harmoniser le niveau de severite des regles 13-16 (les qualifier comme "obligatoires" ou les integrer dans les regles absolues si justifie).

---

## Top 10 recommandations priorisees

| # | Priorite | Recommandation | Impact | Effort |
|---|---|---|---|---|
| 1 | P0 | Corriger `Score moyen des livrables : X/5` dans orchestrator.md:870 → remplacer par un verdict gates PASS/FAIL | Coherence systeme qualite | 1 min |
| 2 | P0 | Nettoyer la duplication "Blockers eventuels" / "Commande de reprise suggeree" dans project-context.md | Clarte memo reprise | 2 min |
| 3 | P1 | Decouper orchestrator.md (1144 lignes) en core (~400) + reference (~700) pour reduire le risque de troncature en contexte | Fiabilite orchestration | 30 min |
| 4 | P1 | Mesurer et documenter le cout tokens reel d'une session type (estimations : 50-150K tokens input pour une orchestration complete) | ROI mesurable du framework | 1h |
| 5 | P1 | Introduire un mode review "light" (gates BLOQUANT only) pour les changements < 20 lignes | Reduction overhead pipeline | 15 min |
| 6 | P2 | Enrichir les agents legers (legal 113L, data-analyst 116L, growth 145L) au meme standard que les agents enrichis | Couverture qualite uniforme | 2h |
| 7 | P2 | Ajouter un budget contexte max recommande par agent (ex: 8K system + 4K dynamique) | Prevention saturation contexte | 15 min |
| 8 | P2 | Fusionner les gates de specificite (G16+G17+G18) en une seule gate composite | Simplification review | 10 min |
| 9 | P2 | Creer un fichier `agent-dependencies.json` pour validation automatique des pre-requis | Robustesse orchestration | 30 min |
| 10 | P2 | Harmoniser le niveau de severite des regles 13-16 dans CLAUDE.md | Coherence documentation | 5 min |

---

## Verdict global

| Axe | Verdict | Score derive |
|---|---|---|
| Architecture des agents | PASS | 9/10 |
| Pipeline qualite | PASS avec reserve | 8.5/10 |
| Performance IA | PASS avec reserve | 8/10 |
| Coherence globale | PASS | 9/10 |
| **Global** | **GO** | **8.6/10** |

Le framework Gradient Agents est en etat de production solide. Les 2 corrections P0 sont triviales (5 minutes). Les recommandations P1 (decoupe orchestrator, mesure couts, mode light review) apporteraient un gain significatif de robustesse et d'efficacite operationnelle. Les P2 sont des ameliorations de confort et d'uniformite.

Le principal risque structurel est la taille du contexte charge par session (~2000 lignes de system prompt avant toute production). C'est geerable avec les modeles actuels (200K context window) mais impose une discipline stricte sur les livrables amont injectes.

---

**Handoff → @orchestrator**
- Fichier produit : `docs/reviews/ia-global-audit-2026-04-02.md`
- Decisions prises : framework GO production (8.6/10), 2 corrections P0 identifiees, 3 recommandations P1
- Points d'attention : residu scoring X/5 dans orchestrator.md:870, duplication dans project-context.md, risque troncature orchestrator.md (1144 lignes)
