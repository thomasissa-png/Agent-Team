# Gradient Agents — Instructions globales

## Règle absolue numéro 1

Avant toute action dans ce projet, lire `project-context.md` à la racine.
S'il est absent : s'arrêter, afficher le template et demander à l'utilisateur de le remplir.
Ne jamais commencer un travail sans contexte projet validé.

## Installer l'équipe dans un autre projet

Ce repo est le **repo source** de l'équipe Gradient Agents. Pour utiliser l'équipe dans un projet existant :

### Scénario A — Nouveau projet (pas encore de code)

Ouvrir une session Claude Code **sur le dossier du nouveau projet** et dire :

> "Installe l'équipe Gradient Agents depuis `/chemin/vers/Agent-Team` dans ce projet. C'est un nouveau projet."

Claude Code va :
1. **Détecter la racine du repo git** via `git rev-parse --show-toplevel` — installer `.claude/agents/` là, pas dans un sous-dossier
2. Copier les 18 agents dans `.claude/agents/` à la racine du repo git
3. Copier le `CLAUDE.md` (instructions globales) à la racine du repo git
4. Copier le template et créer `project-context.md` à la racine du repo git
5. Créer la structure `docs/` et `src/` si absentes

**Ensuite :** remplir `project-context.md` → invoquer `@orchestrator` pour lancer le projet complet.

### Scénario B — Projet existant (code déjà en place)

Ouvrir une session Claude Code **sur le projet existant** et dire :

> "Installe l'équipe Gradient Agents depuis `/chemin/vers/Agent-Team` dans ce projet. C'est un projet existant, ne rien écraser."

Claude Code va :
1. **Détecter la racine du repo git** via `git rev-parse --show-toplevel` — c'est là que `.claude/agents/` DOIT être installé, PAS dans un sous-dossier du repo
2. Copier les 18 agents dans `.claude/agents/` **à la racine du repo git** (crée le dossier s'il n'existe pas, ne touche pas aux agents déjà présents)
3. **Fusionner** le `CLAUDE.md` Gradient Agents avec le `CLAUDE.md` existant **à la racine du repo git** (ajouter les instructions en fin de fichier, ne pas écraser)
4. Copier le template dans `templates/` et créer `project-context.md` à la racine du repo git
5. **Ne pas toucher** à `src/`, `docs/`, `.replit`, `.github/`, `package.json` ni à aucun fichier existant

> **ATTENTION — Piège fréquent :** si le projet est un sous-dossier d'un repo git parent (ex : `monorepo/mon-projet/`), les agents DOIVENT être installés à la racine du repo git (`monorepo/.claude/agents/`), PAS dans le sous-dossier. Claude Code cherche `.claude/agents/` uniquement à la racine du repo git détectée par `git rev-parse --show-toplevel`.

**Différences clés sur un projet existant :**

| Aspect | Nouveau projet | Projet existant |
|---|---|---|
| `CLAUDE.md` | Copié tel quel | **Fusionné** — les instructions Gradient sont ajoutées au CLAUDE.md existant |
| `.claude/agents/` | Créé de zéro | Agents ajoutés sans écraser les agents custom déjà présents |
| `src/` | Créé vide | **Pas touché** — le code existant est préservé |
| `docs/` | Créé vide | **Pas touché** — les agents créeront leurs sous-dossiers au fur et à mesure |
| `project-context.md` | Template vierge | Template vierge — **mais il faut documenter l'existant** (stack, décisions déjà prises, code en place) |
| `package.json` | N'existe pas encore | **Pas touché** — les agents respectent les dépendances existantes |

**Ensuite :** remplir `project-context.md` en documentant ce qui existe déjà (stack actuelle, architecture, conventions de code, décisions passées) → invoquer l'agent adapté à la tâche ciblée.

**Important :** sur un projet existant, le premier réflexe n'est généralement pas `@orchestrator` (qui planifie un projet complet), mais l'agent spécifique au besoin : `@fullstack` pour du code, `@qa` pour des tests, `@seo` pour du référencement, etc.

### Variante — Si le repo Agent-Team n'est pas cloné localement

> "Clone `<url-du-repo-agent-team>` dans /tmp et installe l'équipe Gradient Agents dans ce projet. C'est un [nouveau projet / projet existant]."

### Méthode manuelle — Copier les fichiers à la main

Si tu préfères ne pas passer par Claude Code :

```bash
# 0. Se placer à la racine du repo git (IMPORTANT)
cd $(git rev-parse --show-toplevel)

# 1. Cloner le repo Agent-Team
git clone <url-agent-team> /tmp/Agent-Team

# 2. Copier les agents (à la RACINE du repo git, pas dans un sous-dossier)
mkdir -p .claude/agents
cp /tmp/Agent-Team/.claude/agents/*.md .claude/agents/

# 3. CLAUDE.md
#    → Nouveau projet : copier directement
cp /tmp/Agent-Team/CLAUDE.md ./CLAUDE.md
#    → Projet existant : ajouter en fin de fichier
cat /tmp/Agent-Team/CLAUDE.md >> ./CLAUDE.md

# 4. Template et project-context
mkdir -p templates
cp /tmp/Agent-Team/templates/project-context.md templates/
cp templates/project-context.md ./project-context.md
# → Remplir project-context.md avant de lancer un agent
```

### Structure résultante

```
ton-projet/
├── .claude/
│   └── agents/          ← les 18 agents Gradient
├── templates/
│   └── project-context.md  ← template vierge (référence)
├── project-context.md      ← contexte rempli pour CE projet
├── CLAUDE.md               ← instructions Gradient (seul ou fusionné avec l'existant)
├── docs/                   ← livrables des agents (créés au fur et à mesure)
└── src/                    ← code existant ou à créer
```

### Invocation des agents dans Claude Code

Dans une session Claude Code sur ton projet :

- **Via le menu** : taper `/` puis sélectionner l'agent dans la liste
- **Dans le prompt** : mentionner `@orchestrator`, `@fullstack`, `@design`, etc.
- **Directement** : demander une tâche et Claude routera vers le bon agent si le CLAUDE.md est présent

### Mise à jour des agents

Si l'équipe Gradient Agents évolue dans ce repo source, re-copier les fichiers `.claude/agents/*.md` dans les projets cibles. Le `project-context.md` de chaque projet reste intact — il est spécifique à chaque projet. Pour le `CLAUDE.md`, vérifier les diff avant de re-fusionner.

## Comment utiliser les agents

Les agents sont dans `.claude/agents/`. Chaque agent est un expert autonome.
Pour toute demande complexe ou multi-domaine : invoquer @orchestrator en premier.
Pour une demande ciblée : invoquer directement l'agent concerné.

## Ordre de priorité des agents par type de demande

| Type de demande | Agent principal | Agents secondaires |
|---|---|---|
| Nouveau projet complet | orchestrator | tous |
| Stratégie / positionnement | creative-strategy | product-manager |
| Code / développement | fullstack | qa, infrastructure, ia |
| Interface visuelle | design | ux |
| Parcours utilisateur | ux | design, copywriter |
| Contenu / texte | copywriter | seo, geo |
| Référencement | seo | geo, copywriter |
| Visibilité IA | geo | seo |
| Performance / déploiement | infrastructure | fullstack |
| Intégration LLM / IA | ia | fullstack, infrastructure |
| Analytics / mesure | data-analyst | product-manager |
| Acquisition / croissance | growth | social, data-analyst |
| Réseaux sociaux | social | copywriter, creative-strategy |
| Tests / qualité / non-régression | qa | fullstack, infrastructure |
| Revue croisée / cohérence | reviewer | orchestrator |
| Juridique / conformité | legal | — |
| Roadmap / backlog | product-manager | creative-strategy |
| Création d'agents spécialisés | agent-factory | ia, orchestrator |

## Convention d'appel

- `@orchestrator` : planification multi-agents
- `@fullstack` : écriture de code React, Next.js, Expo, API
- `@qa` : tests unitaires, E2E, intégration, pipeline CI/CD, audit qualité
- `@design` : UI, design system, composants visuels
- `@ux` : parcours, wireframes, conversion
- `@copywriter` : textes, landing pages, emails
- `@seo` : référencement technique et éditorial
- `@geo` : optimisation pour les LLM et moteurs génératifs
- `@ia` : intégrations LLM, choix de modèles, pipelines IA
- `@infrastructure` : configuration Replit, performance, CI/CD, monitoring post-launch
- `@creative-strategy` : positionnement, personas, plateforme de marque
- `@product-manager` : specs, roadmap, backlog
- `@data-analyst` : KPIs, tracking, analytics
- `@growth` : acquisition, funnel, PLG
- `@social` : stratégie et contenu réseaux sociaux
- `@reviewer` : revue croisée, cohérence inter-agents, validation finale
- `@legal` : RGPD, CGU, conformité
- `@agent-factory` : création d'agents spécialisés sur mesure pour le projet

## Convention de chemin des livrables

Tous les livrables des agents sont sauvegardés dans le dossier `docs/` à la racine, organisés par agent :

```
docs/
├── strategy/          ← @creative-strategy : brand-platform.md, personas.md, creative-brief.md, competitive-benchmark.md
├── product/           ← @product-manager : product-vision.md, roadmap.md, functional-specs.md, backlog.md
├── analytics/         ← @data-analyst : kpi-framework.md, tracking-plan.md, dashboard-specs.md
├── ux/                ← @ux : user-flows.md, wireframes.md, ux-audit.md, onboarding-flow.md
├── design/            ← @design : design-system.md, design-tokens.json, component-library.md
├── copy/              ← @copywriter : brand-voice.md, landing-page-copy.md, email-sequences.md, ux-writing-guide.md
├── seo/               ← @seo : seo-strategy.md, keyword-map.md, metadata-templates.md
├── geo/               ← @geo : geo-strategy.md, content-restructuring.md, llm-content-templates.md
├── growth/            ← @growth : growth-strategy.md, acquisition-plan.md, funnel-audit.md
├── social/            ← @social : social-strategy.md, editorial-calendar.md, content-templates.md
├── legal/             ← @legal : legal-audit.md, cgu-draft.md, privacy-policy.md, rgpd-checklist.md
├── infra/             ← @infrastructure : infrastructure.md, performance-audit.md, security-checklist.md
├── ia/                ← @ia : ai-architecture.md, model-selection.md, prompt-library.md
├── qa/                ← @qa : qa-strategy.md, TESTING.md
└── reviews/           ← @reviewer : cross-review-report.md, consistency-audit.md
```

Les fichiers de synthèse de l'orchestrateur (`project-synthesis.md`, `orchestration-plan.md`) sont à la racine de `docs/`.
Les fichiers de code (@fullstack, @qa pipelines, @infrastructure configs) vont dans `src/` selon la structure projet standard.

**Exceptions de chemin** : certains agents ne produisent pas dans `docs/` :
- `@agent-factory` → ses livrables sont les fichiers agents eux-mêmes dans `.claude/agents/` (+ modifications de `CLAUDE.md` et `orchestrator.md`)
- `@orchestrator` → `docs/orchestration-plan.md` et `docs/project-synthesis.md` à la racine de `docs/` (pas dans un sous-dossier)

**Règle** : chaque agent DOIT utiliser le chemin correspondant à son dossier. Tout livrable hors de cette arborescence sera rejeté par le @reviewer (sauf les exceptions documentées ci-dessus).

## Règle absolue numéro 2 — Zéro invention de données

**Ne JAMAIS inventer, deviner ou fabriquer une donnée manquante.** Si un chiffre, un fait, une métrique, un benchmark, un nom, un prix ou toute autre information factuelle n'est pas disponible (ni dans project-context.md, ni dans les livrables existants, ni trouvable via WebSearch), l'agent DOIT :

1. **Signaler explicitement** la donnée manquante : "Je n'ai pas cette information : [donnée]"
2. **Demander à l'utilisateur** de la fournir avant de continuer
3. **Ne JAMAIS combler le vide** avec une estimation, une moyenne sectorielle inventée, ou un "exemple" présenté comme un fait

### Cas des hypothèses de travail (assumptions)

Dans certains cas, avancer nécessite de poser une hypothèse. C'est acceptable **uniquement si** :
- L'agent **demande l'autorisation explicite** avant de poser l'hypothèse
- L'hypothèse est **clairement marquée** comme telle dans le livrable : `[HYPOTHÈSE : ...]`
- L'agent propose **2-3 options** pour l'hypothèse et demande laquelle retenir
- Le livrable liste toutes les hypothèses en fin de document dans un bloc dédié "Hypothèses à valider"

**Pourquoi cette règle est absolue :** un raisonnement construit sur des données fausses produit des décisions fausses. Mieux vaut un livrable incomplet avec des trous signalés qu'un livrable complet avec des données inventées.

### Exemples concrets

- **INTERDIT** : "Le taux de conversion moyen dans ce secteur est de 3.2%" (sans source)
- **OBLIGATOIRE** : "Je n'ai pas le taux de conversion de référence pour ce secteur. Peux-tu me le fournir, ou veux-tu que je recherche un benchmark via WebSearch ?"
- **ACCEPTABLE** (avec autorisation) : "[HYPOTHÈSE : taux de conversion estimé à 2-4% — à valider avec données réelles]"

## Règle absolue numéro 3 — Gestion des timeouts

Claude Code a une limite de temps par réponse. Un agent qui essaie de tout produire en une seule passe **sera coupé en plein travail** et le livrable sera perdu. Cette règle s'applique à TOUS les agents.

### Principes anti-timeout

1. **Un fichier = un appel Write/Edit.** Ne jamais essayer d'écrire plusieurs fichiers dans le même bloc de texte. Écrire le fichier 1, puis le fichier 2, puis le fichier 3.
2. **Découper les gros livrables.** Si un fichier dépasse ~150 lignes, l'écrire en plusieurs Edit successifs (section par section) plutôt qu'un seul Write monolithique.
3. **Prioriser le contenu critique.** Toujours écrire d'abord les sections essentielles du livrable. Si un timeout survient, l'essentiel est sauvegardé.
4. **Sauvegarder au fur et à mesure.** Utiliser Write pour créer le fichier avec la structure + les premières sections, puis Edit pour ajouter les sections suivantes. Ne jamais accumuler du contenu en mémoire sans l'écrire.
5. **Signaler les livrables multi-fichiers.** Si la mission demande plus de 3 fichiers, annoncer l'ordre de production et produire un fichier à la fois.

### Pour l'orchestrateur spécifiquement

- **Ne JAMAIS lancer plus de 3 sous-agents (Task) dans un même message.** Lancer 2-3 Task, attendre leurs résultats, puis lancer les suivants.
- **Découper l'exécution par phase.** Terminer une phase complète (Task + vérification + enrichissement project-context) avant de passer à la suivante.
- **Préférer 3 messages courts à 1 message géant.** Chaque message devrait : lancer les Task → lire les résultats → décider de la suite.

### Pour les agents producteurs de contenu (copywriter, creative-strategy, seo, geo, legal)

- Écrire d'abord la structure/le plan du fichier (titres + résumés), puis remplir section par section via Edit.
- Ne jamais rédiger un document complet de >100 lignes en un seul Write.

### Pour les agents code (fullstack, qa, infrastructure)

- Un composant/fichier par appel Write. Ne jamais écrire 5 fichiers d'un coup.
- Commencer par les fichiers fondation (types, config, utils) avant les fichiers dépendants (composants, pages).

### En cas de timeout détecté

Si un agent a été interrompu par un timeout :
1. Vérifier ce qui a été sauvegardé (Glob + Read sur les fichiers du dossier de l'agent)
2. Reprendre là où le travail s'est arrêté — ne PAS repartir de zéro
3. Terminer les sections manquantes via Edit sur les fichiers existants

## Règles communes à tous les agents

1. Travailler exclusivement en français (sauf code et noms techniques)
2. Lire `project-context.md` avant toute production
3. **Lire le tableau "Historique des interventions agents"** dans `project-context.md` — comprendre qui est intervenu avant, quelles décisions ont été prises, et surtout POURQUOI (colonne "Pourquoi / Alternatives écartées"). Ne jamais produire un livrable qui contredit une décision passée sans le signaler explicitement.
4. Zéro output générique — chaque livrable est taillé pour ce projet précis
5. Objectif constant : faire de ce projet le numéro 1 de son secteur
6. Bloquer et signaler si le contexte est insuffisant
7. Terminer chaque livrable par un bloc Handoff standardisé
8. En mode révision : justifier chaque changement, ne pas tout réécrire
9. **Après chaque livrable** : mettre à jour le tableau "Historique des interventions agents" dans `project-context.md` avec : agent, date, fichiers produits, décisions clés, **et justification des choix (pourquoi cette décision, quelles alternatives écartées)**
10. **Respecter les règles anti-timeout** (voir Règle absolue numéro 3) — découper les livrables, sauvegarder au fur et à mesure, ne jamais accumuler sans écrire

## Protocole de test du framework

Pour valider que les agents fonctionnent correctement ensemble, utiliser ce protocole sur un projet fictif ou réel :

### Test unitaire (1 agent)
1. Remplir `project-context.md` avec un cas concret
2. Invoquer un agent isolé (ex : `@creative-strategy`)
3. Vérifier : lit-il bien project-context.md ? Refuse-t-il si champs manquants ? Le livrable est-il spécifique au projet ?

### Test d'intégration (2-3 agents en chaîne)
1. Lancer `@creative-strategy` → vérifier le handoff
2. Lancer `@copywriter` → vérifie-t-il le brand-platform de creative-strategy ?
3. Lancer `@design` → vérifie-t-il les wireframes UX ET le brand-platform ?
4. Vérifier : les livrables sont-ils cohérents entre eux ? Pas de contradictions ?

### Test E2E (orchestration complète)
1. Invoquer `@orchestrator` sur un projet complet
2. Vérifier : les phases s'exécutent-elles dans le bon ordre ? Les agents parallélisables sont-ils lancés ensemble ?
3. Invoquer `@reviewer` en fin de chaîne → le rapport détecte-t-il des incohérences ?

### Checklist de validation post-test
- [ ] Chaque agent a lu project-context.md avant de produire
- [ ] Aucun agent n'a inventé de données (vérifier les chiffres, benchmarks, tarifs)
- [ ] Les hypothèses sont marquées `[HYPOTHÈSE : ...]`
- [ ] Le tableau "Historique des interventions agents" est mis à jour par chaque agent
- [ ] Le tableau "Performance des agents" est rempli
- [ ] Tous les livrables sont dans le bon dossier `docs/[agent]/`
- [ ] Le handoff de chaque agent pointe vers le bon destinataire

## Journal de setup — Mémoire projet

### Session du 2026-03-21 — Setup initial du framework Gradient Agents

**Ce qui a été fait :**

1. **18 agents créés** dans `.claude/agents/` — chacun avec une structure homogène :
   - Identité (persona expert avec années d'expérience spécifiques)
   - Domaines de compétence détaillés
   - Protocole d'entrée obligatoire (lecture project-context.md, champs critiques)
   - Calibration obligatoire (lecture des livrables des agents amont, recherches web)
   - Gestion des timeouts (règles anti-coupure)
   - Protocole d'escalade (quand passer la main)
   - Mode révision (comment améliorer sans tout réécrire)
   - Auto-évaluation (questions génériques + spécifiques)
   - Protocole de fin de livrable (mise à jour historique)
   - Handoff standardisé

2. **Agents disponibles :** orchestrator, fullstack, qa, design, ux, copywriter, seo, geo, ia, infrastructure, creative-strategy, product-manager, data-analyst, growth, social, reviewer, legal, agent-factory

3. **Template project-context.md** créé dans `templates/` — à remplir avant chaque nouveau projet

4. **CLAUDE.md** (ce fichier) — instructions globales, convention d'appel, chemins des livrables, règles anti-timeout

**Décisions de conception :**
- Modèle claude-opus-4-6 pour tous les agents (qualité maximale sur les livrables stratégiques)
- Orchestrateur limité à 3 sous-agents par message (anti-timeout)
- Chaque agent a des champs critiques spécifiques dans project-context.md — refuse de travailler si manquants
- Convention de chemins stricte (`docs/[agent]/`) vérifiée par @reviewer
- Langue : français pour tout sauf code et termes techniques

**Point d'attention pour les sessions futures :**
- Le framework est prêt, aucun projet n'a encore été lancé dessus
- Premier test réel = premier `project-context.md` rempli + invocation de `@orchestrator`
- Si un agent timeout, vérifier ses fichiers (Glob + Read) et reprendre via Edit, ne pas relancer de zéro

### Session du 2026-03-22 — Enrichissements et audit qualité

**Ce qui a été fait :**

1. **Règle absolue numéro 2 — Zéro invention de données** : ajoutée au CLAUDE.md et aux 18 agents. Les agents doivent signaler les données manquantes, demander l'autorisation avant de poser des hypothèses, et marquer `[HYPOTHÈSE : ...]`. @orchestrator vérifie que les sous-agents n'inventent pas. @reviewer flague NO-GO tout chiffre sans source.

2. **Enrichissement des agents** (cas d'usage manquants) :
   - @growth : rétention, churn, pricing & packaging, expansion revenue
   - @data-analyst : roadmap CRO, analyse rétention cohortes, attribution
   - @product-manager : recherche utilisateur, pricing, feedback loops
   - @copywriter : help center, knowledge base, changelog
   - @fullstack : API publique RESTful, webhooks, SDK client

3. **Tableau de performance des agents** ajouté au template project-context.md (complétude, cohérence, actionnabilité, messages, spécificité 1-5)

4. **Audit complet par @ia** — note moyenne 8.47/10. Rapport dans `docs/ia/agent-audit-report.md`

5. **Implémentation des 7 recommandations de l'audit** :
   - P0-1 : Calibrations croisées complétées (13 agents — chaque agent lit désormais les livrables de ses prédécesseurs)
   - P0-2 : Auto-évaluations uniformisées à 5 questions minimum (6 agents complétés : @ux, @design, @seo, @geo, @social, @legal)
   - P1-3 : WebSearch ajouté dans calibration (@seo, @geo, @social, @reviewer, @infrastructure)
   - P1-4 : Champs critiques corrigés (@product-manager : +modèle économique, @data-analyst : budget analytics, @legal : pays, données sensibles, IA générative)
   - P2-5 : Budget temps/complexité ajouté à @orchestrator (estimation légère/moyenne/lourde avant lancement)
   - P2-6 : @infrastructure renforcé (CI/CD avancé, backup/DR, stratégie cache)
   - P2-7 : Protocole de test du framework ajouté au CLAUDE.md (test unitaire, intégration, E2E)

6. **Fix installation** : instructions corrigées pour installer `.claude/agents/` à la racine du repo git (pas dans un sous-dossier). Piège monorepo documenté.

**Décisions prises :**
- Enrichir les agents existants plutôt que créer de nouveaux agents (éviter la complexité)
- La règle anti-invention est la plus importante du framework — un livrable incomplet vaut mieux qu'un livrable faux
- Les calibrations croisées sont le levier #1 de cohérence inter-agents

### Session du 2026-03-22 — Ajout de @agent-factory

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
