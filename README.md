# gradient-agents

Librairie d'agents Claude Code spécialisés, réutilisables dans tous vos projets GitHub.
17 experts français de classe mondiale, coordonnés par un orchestrateur, avec un seul objectif :
faire de chaque projet le numéro 1 de son secteur.

---

## Installation

**Prérequis :** git, curl, Claude Code

```bash
curl -fsSL https://raw.githubusercontent.com/thomasissa-png/gradient-agents/main/install.sh | bash
```

L'installation :

- Crée `.claude/agents/` avec les 17 agents
- Installe `CLAUDE.md` à la racine (navigation automatique pour Claude Code)
- Crée `project-context.md` à remplir avant toute session
- Installe `update.sh` pour les mises à jour futures

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
| @fullstack | Code React, Next.js, Expo, API, Supabase | Opus |
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

**Étape 2 — Lancer l'orchestrateur**

```
@orchestrator je veux lancer [nom du projet], lis project-context.md et planifie
```

L'orchestrateur analyse le projet, détecte automatiquement s'il est nouveau ou existant,
sélectionne les agents nécessaires et génère les instructions dans l'ordre optimal avec
parallélisation quand c'est possible.

**Appel direct d'un agent**

```
@fullstack crée le composant d'authentification avec NextAuth et Supabase
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
