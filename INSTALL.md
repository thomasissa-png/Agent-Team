# Installer l'équipe Gradient Agents dans un projet

Ce repo est le **repo source** de l'équipe Gradient Agents. Pour utiliser l'équipe dans un projet existant :

## Scénario A — Nouveau projet (pas encore de code)

Ouvrir une session Claude Code **sur le dossier du nouveau projet** et dire :

> "Installe l'équipe Gradient Agents depuis `/chemin/vers/Agent-Team` dans ce projet. C'est un nouveau projet."

Claude Code va :
1. **Détecter la racine du repo git** via `git rev-parse --show-toplevel` — installer `.claude/agents/` là, pas dans un sous-dossier
2. Copier les 19 agents dans `.claude/agents/` à la racine du repo git
3. Copier `.claude/settings.json` (permissions pré-approuvées pour les agents) — **indispensable** pour que les sous-agents puissent écrire des fichiers
4. Copier le `CLAUDE.md` (instructions globales) à la racine du repo git
5. Copier le template et créer `project-context.md` à la racine du repo git
6. Créer la structure `docs/` et `src/` si absentes

**Ensuite :** remplir `project-context.md` → invoquer `@orchestrator` pour lancer le projet complet.

## Scénario B — Projet existant (code déjà en place)

Ouvrir une session Claude Code **sur le projet existant** et dire :

> "Installe l'équipe Gradient Agents depuis `/chemin/vers/Agent-Team` dans ce projet. C'est un projet existant, ne rien écraser."

Claude Code va :
1. **Détecter la racine du repo git** via `git rev-parse --show-toplevel` — c'est là que `.claude/agents/` DOIT être installé, PAS dans un sous-dossier du repo
2. Copier les 19 agents dans `.claude/agents/` **à la racine du repo git** (crée le dossier s'il n'existe pas, ne touche pas aux agents déjà présents)
3. Copier `.claude/settings.json` (permissions pré-approuvées) — **fusionner** avec le `settings.json` existant s'il y en a un (ajouter les permissions manquantes, ne pas écraser les permissions existantes)
4. **Fusionner** le `CLAUDE.md` Gradient Agents avec le `CLAUDE.md` existant **à la racine du repo git** (ajouter les instructions en fin de fichier, ne pas écraser)
5. Copier le template dans `templates/` et créer `project-context.md` à la racine du repo git
6. **Ne pas toucher** à `src/`, `docs/`, `.replit`, `.github/`, `package.json` ni à aucun fichier existant

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

## Scénario C — Mise à jour (l'équipe est déjà installée)

L'équipe Gradient Agents évolue régulièrement. Pour mettre à jour les agents dans un projet où ils sont déjà installés :

Ouvrir une session Claude Code **sur le projet cible** et dire :

> "Mets à jour l'équipe Gradient Agents depuis `https://github.com/thomasissa-png/Agent-Team` `-b claude/improve-frontend-prompts-BdBIK`. Clone dans /tmp, écrase les agents dans `.claude/agents/` et le `CLAUDE.md`, mais ne touche pas à `project-context.md`, `docs/`, `src/` ni au code existant."

Claude Code va :
1. Cloner la dernière version du repo Agent-Team dans `/tmp`
2. **Écraser** tous les fichiers `.claude/agents/*.md` avec les versions à jour
3. **Mettre à jour** `.claude/settings.json` (ajouter les nouvelles permissions, préserver les permissions custom)
4. **Remplacer** le `CLAUDE.md` par la nouvelle version (ou fusionner si le projet a un `CLAUDE.md` custom)
5. **Mettre à jour** le template dans `templates/project-context.md` (le template de référence, pas le vôtre)
6. **Ne PAS toucher** à `project-context.md` (historique du projet), `docs/` (livrables), `src/` (code), `package.json`

> **Ce qui est préservé :** tout ce qui est spécifique à votre projet — `project-context.md`, les livrables dans `docs/`, le code dans `src/`, les agents custom que vous avez créés (s'ils ont un nom différent des agents Gradient).

> **Ce qui est écrasé :** les 19 agents Gradient (prompts améliorés), `.claude/settings.json` (permissions mises à jour), `CLAUDE.md` (nouvelles règles), le template `project-context.md`.

**Alternative rapide** — si `update.sh` est présent dans le projet (installé automatiquement) :

```bash
bash update.sh        # mise à jour interactive (agent par agent)
bash update.sh --all  # mise à jour de tous les agents sans confirmation
bash update.sh --rollback  # annuler la dernière mise à jour
```

Le script `update.sh` met à jour les agents, `settings.json`, et le `CLAUDE.md` (fusion intelligente avec marqueurs `<!-- GRADIENT-AGENTS-START/END -->`). Il ne touche jamais à `project-context.md`, `docs/` ni `src/`.

**Après la mise à jour :** vérifier que `project-context.md` est toujours compatible avec le nouveau template. Si de nouveaux champs ont été ajoutés au template, les remplir dans votre `project-context.md`.

### Méthode manuelle

```bash
# 0. Se placer à la racine du repo git du projet cible
cd $(git rev-parse --show-toplevel)

# 1. Récupérer la dernière version
git clone https://github.com/thomasissa-png/Agent-Team -b claude/improve-frontend-prompts-BdBIK /tmp/Agent-Team 2>/dev/null || \
  (cd /tmp/Agent-Team && git pull)

# 2. Écraser les agents
cp /tmp/Agent-Team/.claude/agents/*.md .claude/agents/

# 2b. Mettre à jour les permissions (settings.json)
cp /tmp/Agent-Team/.claude/settings.json .claude/settings.json

# 3. Mettre à jour CLAUDE.md
#    → Si CLAUDE.md est celui de Gradient (non fusionné) :
cp /tmp/Agent-Team/CLAUDE.md ./CLAUDE.md
#    → Si CLAUDE.md a été fusionné avec des instructions custom :
#    Remplacer manuellement la section Gradient Agents

# 4. Mettre à jour le template (pas votre project-context.md !)
cp /tmp/Agent-Team/templates/project-context.md templates/

# 5. Vérifier les nouveaux champs du template
diff templates/project-context.md project-context.md
```

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

# 2b. Copier les permissions (INDISPENSABLE pour que les agents puissent écrire)
cp /tmp/Agent-Team/.claude/settings.json .claude/settings.json

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
│   ├── agents/          ← les 19 agents Gradient
│   └── settings.json    ← permissions pré-approuvées (Write, Edit, Bash, etc.)
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

Voir **Scénario C** ci-dessus pour la procédure complète (prompt à copier, méthode manuelle, ce qui est préservé vs écrasé).
