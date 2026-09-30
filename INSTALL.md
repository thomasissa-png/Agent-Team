# Installer l'équipe Gradient Agents dans un projet

Ce repo est le **repo source** de l'équipe Gradient Agents. L'installation et la mise à jour passent par deux scripts testés de bout en bout (`tests/test-installers.sh`, 28 vérifications lancées par la CI à chaque push) : `install.sh` et `update.sh`. Ils récupèrent la branche `stable`, que la CI ne fait avancer que si tous les tests passent (à défaut `main`). Toujours les lancer **à la racine du repo git du projet** (`cd "$(git rev-parse --show-toplevel)"`), jamais dans un sous-dossier : Claude Code ne cherche `.claude/agents/` qu'à la racine.

## Ce qui est installé

| Fichier | Rôle | Mise à jour |
|---|---|---|
| `.claude/agents/*.md` | 19 agents + protocoles partagés (`_*.md`, pas des agents) | Remplacé en recollant le bloc `PROJECT-RULES` ; ajouts en fin de fichier rangés en bloc ; agent modifié ailleurs conservé (mise à jour en attente) ; agents maison jamais touchés |
| `.claude/settings.json` | Permissions pré-approuvées (sans elles, les sous-agents ne peuvent pas écrire) | **Fusionné** : réglages du projet (hooks, env, permissions) conservés, permissions Gradient ajoutées, sauvegarde dans `.claude/gradient-backup/` |
| `.claude/founder-preferences.md` | Préférences fondateur et **stack par défaut** (Cloudflare, Umami, VPS en renfort), lecture seule | Écrasé |
| `.claude/prompts-library.html` | Bibliothèque des prompts, cherchée par le protocole d'orchestration | Écrasé |
| `.claude/checklists/` | Checklists citées par les agents (favicon…) | Écrasé |
| `CLAUDE.md` | Règles globales entre les marqueurs `GRADIENT-AGENTS-START/END` | Section Gradient remplacée, contenu custom préservé ; une ligne propre au projet écrite DANS le bloc (absente de toute version Gradient) est déplacée hors du bloc, avec alerte |
| `update.sh` | Script de mise à jour (se met à jour lui-même) | Écrasé |
| `.githooks/claude-md-guard.sh` | Garde-fou taille de CLAUDE.md | Écrasé |
| `.githooks/pre-commit` + `core.hooksPath` | Appel du garde-fou | Remplacé seulement s'il porte le marqueur `GRADIENT-HOOK` ; un hook propre au projet, Husky ou `.git/hooks` ne sont jamais écrasés (le script indique la ligne d'appel à ajouter) |
| `.claude/gradient-version` | Version installée (branche, commit, date), lue au démarrage de session pour détecter un framework en retard | Réécrit |
| `project-context.md` | Modèle vide à remplir (prompt « Définir mon projet ») | **Jamais touché** s'il existe |

Jamais touchés : `docs/` (livrables, et `docs/founder-preferences.md` du projet : ses préférences propres, prioritaires sur les globales), `src/` (code), `package.json`, agents maison (update.sh signale ceux restés sur un modèle obsolète).

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

Le script sauvegarde agents et settings dans `.claude/gradient-backup/` (hors de `.claude/agents/`, que Claude Code charge récursivement ; une ancienne sauvegarde `.claude/agents/.backup/` est déplacée automatiquement), préserve le bloc `PROJECT-RULES` de chaque agent (règles propres au projet, voir `_base-agent-protocol.md`), range automatiquement en bloc les lignes ajoutées en fin d'agent, et si un agent Gradient a été modifié ailleurs le conserve tel quel (nouvelle version en attente dans `.claude/gradient-backup/pending/`) : aucune modification locale n'est jamais perdue ; retire les fichiers Gradient disparus en amont (jamais un agent maison), signale les doublons et les agents maison sur un vieux modèle, synchronise le tableau ci-dessus et réactive les hooks. Ne jamais le lancer dans le repo source Agent-Team lui-même.

**Après la mise à jour** : comparer `project-context.md` au modèle (`templates/project-context.md` du repo source) et remplir les nouveaux champs éventuels.

## Méthode manuelle (secours, sans les scripts)

```bash
cd "$(git rev-parse --show-toplevel)"
git clone --depth 1 https://github.com/thomasissa-png/Agent-Team -b main /tmp/Agent-Team
mkdir -p .claude/agents .githooks
cp /tmp/Agent-Team/.claude/agents/*.md .claude/agents/
rm -f .claude/agents/moi.md .claude/agents/orchestrator-reference.md .claude/agents/orchestrator.md
[ -f .claude/settings.json ] || cp /tmp/Agent-Team/.claude/settings.json .claude/settings.json   # sinon fusionner à la main
cp /tmp/Agent-Team/docs/founder-preferences.md .claude/founder-preferences.md
cp /tmp/Agent-Team/index.html .claude/prompts-library.html
cp /tmp/Agent-Team/update.sh ./update.sh && chmod +x update.sh
cp /tmp/Agent-Team/.githooks/claude-md-guard.sh .githooks/ && chmod +x .githooks/claude-md-guard.sh
# pre-commit : si vous en avez déjà un (ou Husky), ajoutez-y « sh .githooks/claude-md-guard.sh || exit 1 » ;
# sinon : cp /tmp/Agent-Team/.githooks/pre-commit .githooks/ && git config core.hooksPath .githooks
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
