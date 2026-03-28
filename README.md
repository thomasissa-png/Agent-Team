# gradient-agents

Librairie d'agents Claude Code spécialisés, réutilisables dans tous vos projets GitHub.
17 experts français de classe mondiale, coordonnés par un orchestrateur, avec un seul objectif :
faire de chaque projet le numéro 1 de son secteur.

---

## Installation

**Prérequis :** git, curl, Claude Code

### Scénario A — Nouveau projet (pas encore de code)

```bash
curl -fsSL https://raw.githubusercontent.com/thomasissa-png/Agent-Team/claude/extract-project-context-PK8iz/install.sh | bash
```

Ou dans Claude Code, sur le dossier de votre nouveau projet :

> "Installe l'équipe Gradient Agents depuis `/chemin/vers/Agent-Team` dans ce projet. C'est un nouveau projet."

**Ce qui se passe :**
- `.claude/agents/` est créé avec les 17 agents
- `CLAUDE.md` est copié à la racine
- `project-context.md` (template vierge) est créé à remplir
- `docs/` et `src/` sont créés si absents

### Scénario B — Projet existant (code déjà en place)

Dans Claude Code, sur votre projet existant :

> "Installe l'équipe Gradient Agents depuis `/chemin/vers/Agent-Team` dans ce projet. C'est un projet existant, ne rien écraser."

**Ce qui se passe :**
- Les 17 agents sont ajoutés dans `.claude/agents/` **sans écraser** les agents custom déjà présents
- `CLAUDE.md` est **fusionné** avec le vôtre (ajouté en fin de fichier, pas écrasé)
- `project-context.md` est créé à remplir
- `src/`, `docs/`, `package.json`, `.github/` et tout fichier existant **ne sont pas touchés**

### Différences clés

| | Nouveau projet | Projet existant |
|---|---|---|
| `CLAUDE.md` | Copié tel quel | **Fusionné** avec l'existant |
| `.claude/agents/` | Créé de zéro | Agents ajoutés, custom préservés |
| `src/` | Créé vide | **Pas touché** |
| `docs/` | Créé vide | **Pas touché** |
| `package.json` | N'existe pas encore | **Pas touché** |
| `project-context.md` | Template vierge | Template vierge — **documenter l'existant** |

---

## Agents disponibles

| Agent | Trigger principal | Modèle |
|---|---|---|
| @orchestrator | Planification multi-agents, nouveau projet complet | Opus |
| @creative-strategy | Positionnement, personas, plateforme de marque | Opus |
| @product-manager | Vision produit, roadmap, specs fonctionnelles | Opus |
| @data-analyst | KPIs, tracking, analytics — intervient tôt | Opus |
| @ux | Parcours utilisateur, wireframes, conversion | Opus |
| @design | Design system, UI, composants visuels | Opus |
| @fullstack | Code React, Next.js, Expo, API, PostgreSQL Replit | Opus |
| @qa | Tests unitaires, E2E, intégration, pipeline CI/CD | Opus |
| @infrastructure | Déploiement, performance, CI/CD | Opus |
| @ia | Intégrations LLM, pipelines IA, choix de modèles | Opus |
| @copywriter | Landing pages, emails, UX writing, brand voice | Opus |
| @seo | Référencement technique et éditorial | Opus |
| @geo | Visibilité dans ChatGPT, Gemini, Perplexity | Opus |
| @growth | Acquisition, funnel, PLG, referral | Opus |
| @social | Stratégie réseaux sociaux, calendrier éditorial | Opus |
| @reviewer | Revue croisée, cohérence inter-agents | Opus |
| @legal | RGPD, CGU, conformité, EU AI Act | Opus |

---

## Démarrage rapide

**Étape 1 — Remplir project-context.md**
C'est obligatoire. Tous les agents s'arrêtent si ce fichier est absent ou vide.
Sur un projet existant, documenter la stack actuelle, l'architecture, les conventions et les décisions passées.

**Étape 2 — Choisir le bon point d'entrée**

| Situation | Commencer par |
|---|---|
| Nouveau projet à construire de A à Z | `@orchestrator` — il planifie tout |
| Projet existant, besoin ciblé | L'agent spécifique : `@fullstack`, `@seo`, `@qa`… |
| Projet existant, refonte majeure | `@orchestrator` — mais après avoir documenté l'existant |

**Exemples — Nouveau projet :**

```
@orchestrator je veux lancer [nom du projet], lis project-context.md et planifie
```

**Exemples — Projet existant :**

```
@fullstack crée le composant d'authentification avec NextAuth et PostgreSQL Replit
@design génère le design system complet basé sur brand-platform.md
@seo fais l'audit SEO technique du projet
@qa écris les tests E2E pour le parcours d'inscription
@reviewer vérifie la cohérence entre tous les livrables produits
```

---

## project-context.md

Ce fichier est le contrat entre vous et les agents. Il contient :

- L'identité du projet (nom, secteur, stade)
- Les personas et le problème résolu
- Le positionnement et le ton de marque
- Les objectifs et KPIs
- La stack technique
- Les contraintes (budget, timeline, légales)
- L'historique des interventions agents (mis à jour automatiquement)

Copiez le template depuis `templates/project-context.md` et remplissez tous les champs.
Un champ vide = un agent bloqué.

---

## Mise à jour

```bash
# Mise à jour sélective (confirmation par agent)
bash update.sh

# Mise à jour de tous les agents sans confirmation
bash update.sh --all

# Revenir à la version précédente si problème
bash update.sh --rollback
```

project-context.md n'est jamais écrasé lors des mises à jour.

---

## Contribution

Pour améliorer un agent :

1. Éditer `.claude/agents/[agent].md`
2. Respecter le format : frontmatter YAML + sections obligatoires
3. Commit : `agent([nom]): [description du changement]`
4. Push — les projets existants se mettent à jour via `update.sh`
