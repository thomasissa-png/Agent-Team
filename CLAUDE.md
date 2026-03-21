# Gradient Agents — Instructions globales

## Règle absolue numéro 1

Avant toute action dans ce projet, lire `project-context.md` à la racine.
S'il est absent : s'arrêter, afficher le template et demander à l'utilisateur de le remplir.
Ne jamais commencer un travail sans contexte projet validé.

## Installer l'équipe dans un autre projet

Ce repo est le **repo source** de l'équipe Gradient Agents. Pour utiliser l'équipe dans un projet existant :

### Méthode rapide — copier les fichiers

Depuis la racine de ton autre projet :

```bash
# 1. Cloner le repo Agent-Team (ou le référencer si déjà cloné)
git clone <url-agent-team> /tmp/Agent-Team

# 2. Copier les agents dans ton projet
mkdir -p .claude/agents
cp /tmp/Agent-Team/.claude/agents/*.md .claude/agents/

# 3. Copier le CLAUDE.md (instructions globales)
cp /tmp/Agent-Team/CLAUDE.md ./CLAUDE.md

# 4. Copier le template de contexte projet
mkdir -p templates
cp /tmp/Agent-Team/templates/project-context.md templates/

# 5. Créer le project-context.md à la racine et le remplir
cp templates/project-context.md ./project-context.md
# → Ouvrir project-context.md et remplir TOUS les champs avant de lancer un agent
```

### Structure résultante dans ton projet

```
ton-projet/
├── .claude/
│   └── agents/          ← les 17 agents copiés
├── templates/
│   └── project-context.md  ← template vierge (référence)
├── project-context.md      ← contexte rempli pour CE projet
├── CLAUDE.md               ← instructions globales (ce fichier)
├── docs/                   ← sera créé par les agents (livrables)
└── src/                    ← ton code existant
```

### Premier lancement

1. **Remplir `project-context.md`** — c'est obligatoire, aucun agent ne travaillera sans
2. **Invoquer `@orchestrator`** pour un projet complet, ou un agent spécifique pour une tâche ciblée
3. Les agents créeront automatiquement leurs dossiers dans `docs/` au fur et à mesure

### Invocation des agents dans Claude Code

Dans une session Claude Code sur ton projet, utiliser la syntaxe d'invocation d'agent :

- **Via le menu** : taper `/` puis sélectionner l'agent dans la liste
- **Dans le prompt** : mentionner `@orchestrator`, `@fullstack`, `@design`, etc.
- **Directement** : demander une tâche et Claude routera vers le bon agent si le CLAUDE.md est présent

### Mise à jour des agents

Si l'équipe Gradient Agents évolue dans ce repo source, re-copier les fichiers `.claude/agents/*.md` et le `CLAUDE.md` dans les projets cibles. Le `project-context.md` de chaque projet reste intact — il est spécifique à chaque projet.

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

**Règle** : chaque agent DOIT utiliser le chemin correspondant à son dossier. Tout livrable hors de cette arborescence sera rejeté par le @reviewer.

## Règle absolue numéro 2 — Gestion des timeouts

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
10. **Respecter les règles anti-timeout** (voir Règle absolue numéro 2) — découper les livrables, sauvegarder au fur et à mesure, ne jamais accumuler sans écrire

## Journal de setup — Mémoire projet

### Session du 2026-03-21 — Setup initial du framework Gradient Agents

**Ce qui a été fait :**

1. **17 agents créés** dans `.claude/agents/` — chacun avec une structure homogène :
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

2. **Agents disponibles :** orchestrator, fullstack, qa, design, ux, copywriter, seo, geo, ia, infrastructure, creative-strategy, product-manager, data-analyst, growth, social, reviewer, legal

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
