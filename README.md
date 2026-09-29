# gradient-agents

Une équipe de 19 agents Claude Code spécialisés, réutilisable dans tous vos projets GitHub. Claude coordonne l'équipe lui-même : vous décrivez le besoin, il délègue au bon expert, en parallèle quand c'est possible.

Site et bibliothèque de 91 prompts : https://agents.issa-capital.com

---

## Installation

**Prérequis :** git, curl, Claude Code. À lancer à la racine du repo git du projet.

```bash
curl -fsSL https://raw.githubusercontent.com/thomasissa-png/Agent-Team/main/install.sh | bash
```

Installe les 19 agents, `CLAUDE.md` (fusionné si vous en avez déjà un), les permissions, les préférences fondateur (stack par défaut : Cloudflare, Umami), la bibliothèque de prompts, `update.sh`, les hooks git et un `project-context.md` à remplir. Ne touche jamais à `docs/`, `src/` ni à un `project-context.md` existant.

Détail, projet existant et méthode manuelle : [INSTALL.md](INSTALL.md).

## Mise à jour

```bash
curl -fsSL https://raw.githubusercontent.com/thomasissa-png/Agent-Team/main/update.sh -o update.sh && bash update.sh --all
```

Sauvegarde automatique (`bash update.sh --rollback` pour revenir en arrière). `project-context.md` et vos livrables ne sont jamais écrasés.

---

## Les agents

| Agent | Domaine | Modèle |
|---|---|---|
| @creative-strategy | Positionnement, personas, plateforme de marque | Sonnet 5.5 |
| @product-manager | Vision produit, roadmap, specs fonctionnelles | Sonnet 5.5 |
| @data-analyst | KPIs, plan de tracking (Umami), cohortes, A/B | Sonnet 5.5 |
| @ux | Parcours, wireframes, conversion | Sonnet 5.5 |
| @design | Design system, direction artistique, UI | Sonnet 5.5 |
| @copywriter | Landing, emails, UX writing, voix de marque | Sonnet 5.5 |
| @seo | Référencement Google et Bing | Sonnet 5.5 |
| @geo | Visibilité dans ChatGPT, Claude, Gemini, Perplexity | Sonnet 5.5 |
| @growth | Acquisition, funnel, referral, earned media | Sonnet 5.5 |
| @social | Réseaux sociaux, calendrier éditorial | Sonnet 5.5 |
| @sales-enablement | Propositions, objections, séquences B2B | Sonnet 5.5 |
| @legal | RGPD, CGU, AI Act, accessibilité | Sonnet 5.5 |
| @fullstack | Next.js, React, Expo, API, BDD, Stripe | Opus 5.5 |
| @qa | Tests unitaires, E2E, CI, audit qualité | Opus 5.5 |
| @infrastructure | Cloudflare Workers, CI/CD, sécurité, monitoring | Opus 5.5 |
| @ia | Intégrations LLM, choix de modèles, coûts | Opus 5.5 |
| @reviewer | Revue croisée, verdict GO/NO-GO | Opus 5.5 |
| @elon | Audit stratégique first principles | Opus 5.5 |
| @agent-factory | Création d'agents sur mesure | Opus 5.5 |

La coordination multi-agents n'est pas un agent : c'est un protocole (`.claude/agents/_orchestration-protocol.md`) que la session principale applique.

---

## Démarrage rapide

1. **Remplir `project-context.md`** avec le prompt « Définir mon projet » du site. Obligatoire : sans lui, les agents s'arrêtent.
2. **Décrire le besoin** en langage naturel. Le routage est automatique ; `@agent` force un agent précis.

```
Lance mon projet de A à Z
Fais l'audit SEO technique du site
@qa écris les tests E2E du parcours d'inscription
```

---

## Contribution

1. Éditer `.claude/agents/[agent].md` (frontmatter YAML + sections du template `agent-factory.md`)
2. Lancer `bash tests/run-all.sh` : comptes, modèles, liens, accents, tirets et JavaScript du site sont vérifiés
3. Commit puis push sur `main` : les projets récupèrent le changement via `update.sh`
