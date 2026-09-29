# Installer l'équipe Gradient Agents dans un projet

Ce repo est le **repo source** de l'équipe Gradient Agents. L'installation et la mise à jour passent par deux scripts testés de bout en bout : `install.sh` et `update.sh`. Toujours les lancer **à la racine du repo git du projet** (`cd "$(git rev-parse --show-toplevel)"`), jamais dans un sous-dossier : Claude Code ne cherche `.claude/agents/` qu'à la racine.

## Ce qui est installé

| Fichier | Rôle | Mise à jour |
|---|---|---|
| `.claude/agents/*.md` | 19 agents + protocoles partagés (`_*.md`, pas des agents) | Écrasé |
| `.claude/settings.json` | Permissions pré-approuvées (sans elles, les sous-agents ne peuvent pas écrire) | Écrasé |
| `.claude/founder-preferences.md` | Préférences fondateur et **stack par défaut** (Cloudflare, Umami, VPS en renfort), lecture seule | Écrasé |
| `.claude/prompts-library.html` | Bibliothèque des prompts, cherchée par le protocole d'orchestration | Écrasé |
| `CLAUDE.md` | Règles globales entre les marqueurs `GRADIENT-AGENTS-START/END` | Section Gradient remplacée, contenu custom préservé |
| `update.sh` | Script de mise à jour (se met à jour lui-même) | Écrasé |
| `.githooks/` + `core.hooksPath` | Garde-fou taille de CLAUDE.md | Écrasé |
| `project-context.md` | Modèle vide à remplir (prompt « Définir mon projet ») | **Jamais touché** s'il existe |

Jamais touchés : `docs/` (livrables), `src/` (code), `package.json`, agents custom (noms différents des 19).

## Scénario A : nouveau projet

```bash
git init   # si le dossier n'est pas encore un repo git
curl -fsSL https://raw.githubusercontent.com/thomasissa-png/Agent-Team/main/install.sh | bash
```

Ensuite : lancer le prompt « Définir mon projet » du site (section Démarrage), puis décrire le besoin (« lance mon projet ») : le routage vers les agents est automatique.

## Scénario B : projet existant

Même commande. Le script ne touche ni à `docs/`, ni à `src/`, ni à un `project-context.md` existant, et fusionne `CLAUDE.md` (section Gradient ajoutée entre marqueurs, contenu existant préservé). Si `.claude/agents/` contient déjà les agents Gradient, c'est une **mise à jour** (scénario C), pas une installation.

Ensuite : remplir `project-context.md` en documentant l'existant (stack, architecture, conventions, décisions passées), puis décrire le besoin.

## Scénario C : mise à jour

Toujours récupérer le dernier `update.sh` avant de le lancer : un ancien `update.sh` local peut ne pas savoir se mettre à jour lui-même.

```bash
curl -fsSL https://raw.githubusercontent.com/thomasissa-png/Agent-Team/main/update.sh -o update.sh && chmod +x update.sh
bash update.sh --all        # tout mettre à jour
bash update.sh              # agent par agent (interactif)
bash update.sh --rollback   # restaurer les agents d'avant la dernière mise à jour
```

Le script sauvegarde les agents dans `.claude/agents/.backup/`, retire les fichiers framework obsolètes (`moi.md`, `orchestrator-reference.md`, `orchestrator.md`), synchronise tout le tableau ci-dessus et réactive les hooks. Ne jamais le lancer dans le repo source Agent-Team lui-même.

**Après la mise à jour** : comparer `project-context.md` au modèle (`templates/project-context.md` du repo source) et remplir les nouveaux champs éventuels.

## Méthode manuelle (secours, sans les scripts)

```bash
cd "$(git rev-parse --show-toplevel)"
git clone --depth 1 https://github.com/thomasissa-png/Agent-Team -b main /tmp/Agent-Team
mkdir -p .claude/agents .githooks
cp /tmp/Agent-Team/.claude/agents/*.md .claude/agents/
rm -f .claude/agents/moi.md .claude/agents/orchestrator-reference.md .claude/agents/orchestrator.md
cp /tmp/Agent-Team/.claude/settings.json .claude/settings.json
cp /tmp/Agent-Team/docs/founder-preferences.md .claude/founder-preferences.md
cp /tmp/Agent-Team/index.html .claude/prompts-library.html
cp /tmp/Agent-Team/update.sh ./update.sh && chmod +x update.sh
cp /tmp/Agent-Team/.githooks/* .githooks/ && chmod +x .githooks/* && git config core.hooksPath .githooks
[ -f project-context.md ] || cp /tmp/Agent-Team/templates/project-context.md ./project-context.md
# CLAUDE.md : nouveau projet → copier ; existant → remplacer uniquement le bloc GRADIENT-AGENTS-START/END
# (ou l'ajouter en fin de fichier s'il n'y a pas encore de marqueurs)
```

## Structure résultante

```
ton-projet/
├── .claude/
│   ├── agents/                 ← 19 agents + protocoles partagés (_*.md)
│   ├── settings.json           ← permissions pré-approuvées
│   ├── founder-preferences.md  ← préférences + stack par défaut (lecture seule)
│   └── prompts-library.html    ← bibliothèque des 91 prompts
├── .githooks/                  ← garde-fou CLAUDE.md
├── CLAUDE.md                   ← règles Gradient (seules ou fusionnées)
├── project-context.md          ← contexte de CE projet
├── update.sh
├── docs/                       ← livrables des agents
└── src/                        ← code
```

## Invocation des agents

- **Par défaut** : décrire la tâche en langage naturel, Claude route vers le bon agent (CLAUDE.md requis)
- **Override** : mentionner `@fullstack`, `@design`, etc. pour forcer un agent
- **Menu** : taper `/agents` pour voir la liste
