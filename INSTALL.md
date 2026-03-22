# Installer l'équipe Gradient Agents dans un projet

Ce repo est le **repo source** de l'équipe Gradient Agents. Pour utiliser l'équipe dans un projet existant :

## Scénario A — Nouveau projet (pas encore de code)

Ouvrir une session Claude Code **sur le dossier du nouveau projet** et dire :

> "Installe l'équipe Gradient Agents depuis `/chemin/vers/Agent-Team` dans ce projet. C'est un nouveau projet."

Claude Code va :
1. **Détecter la racine du repo git** via `git rev-parse --show-toplevel` — installer `.claude/agents/` là, pas dans un sous-dossier
2. Copier les 19 agents dans `.claude/agents/` à la racine du repo git
3. Copier le `CLAUDE.md` (instructions globales) à la racine du repo git
4. Copier le template et créer `project-context.md` à la racine du repo git
5. Créer la structure `docs/` et `src/` si absentes

**Ensuite :** remplir `project-context.md` → invoquer `@orchestrator` pour lancer le projet complet.

## Scénario B — Projet existant (code déjà en place)

Ouvrir une session Claude Code **sur le projet existant** et dire :

> "Installe l'équipe Gradient Agents depuis `/chemin/vers/Agent-Team` dans ce projet. C'est un projet existant, ne rien écraser."

Claude Code va :
1. **Détecter la racine du repo git** via `git rev-parse --show-toplevel` — c'est là que `.claude/agents/` DOIT être installé, PAS dans un sous-dossier du repo
2. Copier les 19 agents dans `.claude/agents/` **à la racine du repo git** (crée le dossier s'il n'existe pas, ne touche pas aux agents déjà présents)
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

## Variante — Si le repo Agent-Team n'est pas cloné localement

> "Clone `<url-du-repo-agent-team>` dans /tmp et installe l'équipe Gradient Agents dans ce projet. C'est un [nouveau projet / projet existant]."

## Méthode manuelle — Copier les fichiers à la main

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

## Structure résultante

```
ton-projet/
├── .claude/
│   └── agents/          ← les 19 agents Gradient
├── templates/
│   └── project-context.md  ← template vierge (référence)
├── project-context.md      ← contexte rempli pour CE projet
├── CLAUDE.md               ← instructions Gradient (seul ou fusionné avec l'existant)
├── docs/                   ← livrables des agents (créés au fur et à mesure)
└── src/                    ← code existant ou à créer
```

## Invocation des agents dans Claude Code

Dans une session Claude Code sur ton projet :

- **Via le menu** : taper `/` puis sélectionner l'agent dans la liste
- **Dans le prompt** : mentionner `@orchestrator`, `@fullstack`, `@design`, etc.
- **Directement** : demander une tâche et Claude routera vers le bon agent si le CLAUDE.md est présent

## Mise à jour des agents

Si l'équipe Gradient Agents évolue dans ce repo source, re-copier les fichiers `.claude/agents/*.md` dans les projets cibles. Le `project-context.md` de chaque projet reste intact — il est spécifique à chaque projet. Pour le `CLAUDE.md`, vérifier les diff avant de re-fusionner.
