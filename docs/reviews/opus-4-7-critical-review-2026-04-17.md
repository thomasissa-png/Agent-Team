# Opus 4.7 Impact Analysis — Revue Critique Adversariale

**Date** : 2026-04-17
**Auteur** : @ia (auto-revue adversariale)
**Livrable source** : `docs/reviews/opus-4-7-impact-analysis-2026-04-17.md`

---

## 1. Verdict global

**GO AVEC MODIFICATIONS** — 4 updates sur 7 confirmées, 1 modifiée, 2 retirées.

---

## 2. Tableau des 7 updates Phase 1

| # | Update proposée | Verdict | Justification | Action finale |
|---|---|---|---|---|
| 1.1 | Migrer `model: claude-opus-4-6` vers `claude-opus-4-7` dans 9 agents | **CONFIRMER** | FAIT VERIFIE : les 9 agents ont un champ `model:` explicite dans le frontmatter YAML (ia.md L4, reviewer.md L4, orchestrator.md L4, agent-factory.md L4, design.md L4 est Sonnet). Pricing identique confirmable via Anthropic pricing page. Le changement est un swap de string, zéro risque fonctionnel, zéro coût delta. | `sed` sur les 9 fichiers : `claude-opus-4-6` -> `claude-opus-4-7` |
| 1.2 | Mettre à jour template agent-factory.md | **CONFIRMER** | Corollaire direct de 1.1. Si les agents existants passent en 4.7, le template de création doit refléter le nouveau default. | Modifier le default model dans agent-factory.md |
| 1.3 | Documenter `xhigh` et task budgets dans ia.md | **MODIFIER** | PROBLEME : `xhigh` est un effort level de l'API Claude (paramètre `effort`), pas une feature Claude Code subagent. Les sous-agents invoqués via `Task` dans Claude Code n'exposent PAS de paramètre effort dans le frontmatter YAML. Le paramètre existe dans l'API directe mais sa disponibilité via Claude Code subagent n'est pas documentée. Documenter dans ia.md comme connaissance API est acceptable, mais la recommandation "utiliser xhigh pour @reviewer et @elon par défaut" est TROMPEUSE car inapplicable dans l'architecture actuelle (Task invoque des agents, pas l'API directe). Les task budgets sont en beta et peuvent changer. | Documenter `xhigh` comme feature API dans la grille de sélection de modèle. RETIRER la recommandation de l'appliquer aux sous-agents. Mentionner les task budgets comme [BETA - A SURVEILLER], pas comme recommandation actionnable. |
| 1.4 | Ajouter `/ultrareview` optionnel dans reviewer.md | **RETIRER** | FAIT : `/ultrareview` est un slash command de Claude Code CLI, executable uniquement par l'utilisateur interactif. Un sous-agent invoqué via Task n'a PAS accès aux slash commands -- il n'a accès qu'aux outils listés dans son frontmatter (`tools: [Read, Write, Edit, Glob, Grep, WebSearch]`). Ajouter cette mention dans reviewer.md induit en erreur : l'agent lira "exécuter /ultrareview" et échouera silencieusement ou inventera un comportement. C'est exactement le type de cargo-culting "feature-adoption" que la revue critique doit détecter. Si Thomas veut utiliser /ultrareview, c'est une action UTILISATEUR, pas une action agent. | Ne rien ajouter dans reviewer.md. Si pertinent, documenter dans un guide utilisateur ou dans `docs/founder-preferences.md`. |
| 1.5 | Note vision 2576px dans design.md + reviewer.md | **RETIRER** | RAISONNEMENT FAIBLE : (1) design.md est un agent Sonnet, pas Opus -- il ne bénéficie pas de la vision 2576px d'Opus 4.7. (2) reviewer.md est Opus et lit des screenshots (`Read("tests/screenshots/...")`), mais la résolution des screenshots dépend de la CAPTURE (Playwright viewport), pas du modèle qui les lit. Le modèle lit ce qu'on lui donne. Si Thomas capture en 1280px, Opus 4.7 lira du 1280px, 2576px ou pas. (3) La note "privilégier des screenshots haute résolution" est une instruction à l'OUTIL DE CAPTURE (Playwright config dans qa.md ou fullstack), pas au lecteur. Ajouter cette note dans design.md et reviewer.md est un mauvais placement. | Ne rien ajouter dans design.md ni reviewer.md. Si pertinent, ajouter dans @qa ou @fullstack la config de capture Playwright à haute résolution. |
| 1.6 | Référencer Opus 4.7 dans CLAUDE.md | **CONFIRMER** | CLAUDE.md L94 dit "Opus : orchestrator, agent-factory, ...". Il ne mentionne PAS de version spécifique (pas "Opus 4.6"). Donc il n'y a RIEN A CHANGER. La section Modèles est un routage par tier (Opus vs Sonnet), pas par version exacte. La version est dans le frontmatter de chaque agent. Donc l'update 1.6 est en fait un NO-OP. Pas besoin de modifier CLAUDE.md. Bonus : CLAUDE.md est à 104 lignes. Ajouter une référence à "4.7" gaspillerait du budget lignes pour zéro valeur (règle n7). | Aucune modification de CLAUDE.md. |
| 1.7 | Mettre à jour project-context.md stack technique | **CONFIRMER** | project-context.md doit refléter l'état réel de la stack. Si on migre les agents vers 4.7, la section stack technique doit le mentionner. C'est un changement informatif, low-risk. | Mettre à jour le champ modèle dans project-context.md après migration. |

---

## 3. Erreurs identifiées dans le livrable initial

1. **Erreur sur /ultrareview** : le livrable affirme que `/ultrareview` est "complémentaire, pas doublon" et propose de l'ajouter dans reviewer.md. C'est une erreur d'architecture : les slash commands ne sont pas accessibles aux sous-agents via Task. Le livrable n'a pas vérifié cette contrainte fondamentale.

2. **Erreur sur la vision 2576px placement** : design.md utilise `model: claude-sonnet-4-6`, pas Opus. La note vision 2576px serait placée dans un agent qui n'en bénéficie pas. Le livrable ne fait pas la distinction agent Sonnet vs agent Opus pour cette feature.

3. **Surestimation de xhigh** : le livrable qualifie l'impact de xhigh comme "HAUT" et recommande son utilisation "par défaut pour @reviewer et @elon sur audits exhaustifs". Mais aucune vérification que Task (le mécanisme d'invocation des sous-agents) supporte le paramètre effort. C'est une recommandation non vérifiable dans l'architecture actuelle.

4. **CLAUDE.md L94 ne mentionne pas "4.6"** : le livrable propose de changer "Opus" en "Opus 4.7" à L94, mais la ligne actuelle dit simplement "Opus" sans version. L'update est un no-op présenté comme une action.

5. **Pricing "confirmé"** : le livrable affirme "Pricing inchangé (5$/25$ par 1M tokens)" mais n'a pas fait de WebSearch pour vérifier. La règle ia.md est explicite : "ne jamais se baser sur des prix mémorisés". [HYPOTHESE : le pricing est correct, mais non vérifié par la méthode requise]

---

## 4. Omissions

1. **Sonnet 4.7 existe-t-il ?** Le livrable ne pose pas la question. Si Sonnet 4.7 existe aussi, les 11 agents Sonnet pourraient bénéficier d'un upgrade gratuit similaire. Si Sonnet 4.7 n'existe pas, l'analyse est incomplète car elle ne mentionne pas cette asymétrie.

2. **Hook pre-commit 120 lignes** : le livrable propose de modifier CLAUDE.md (update 1.6) sans vérifier le budget lignes restant (104/120 = 16 lignes de marge). En pratique l'update 1.6 est un no-op (voir section 2), mais le livrable n'a pas fait cette vérification.

3. **System prompt "Fast mode uses Claude Opus 4.6"** : le system prompt de cette session affirme "You are powered by the model named Opus 4.6". Cela signifie que le fast mode de Claude Code est hard-codé sur 4.6. Si Claude Code ne route pas automatiquement vers 4.7 via le frontmatter `model:`, le changement de model ID pourrait être ignoré par le runtime. Le livrable n'aborde pas ce risque.

4. **Absence de plan de test** : le livrable ne propose aucun test post-migration. Comment vérifier que le `model: claude-opus-4-7` dans le frontmatter est effectivement respecté par Claude Code ? Un test simple : invoquer un agent, lui demander quel modèle il utilise, vérifier la réponse.

5. **Impact comportemental "instruction following amélioré"** : le livrable dit "aucun changement" mais Opus 4.7 est décrit comme plus "littéral" dans l'instruction following. Pour un framework avec 283 lignes de ia.md et 377 lignes de reviewer.md, un modèle plus littéral pourrait traiter différemment les instructions ambiguës. Pas un risque bloquant, mais une omission dans l'analyse.

---

## 5. Liste finale des actions à appliquer

| # | Action | Fichier | Delta exact |
|---|---|---|---|
| A1 | Migrer model ID dans 9 agents Opus | `.claude/agents/{orchestrator,agent-factory,reviewer,elon,fullstack,ia,qa,infrastructure,moi}.md` | `model: claude-opus-4-6` -> `model: claude-opus-4-7` |
| A2 | Mettre à jour template agent-factory | `.claude/agents/agent-factory.md` | Modifier le modèle par défaut Opus dans le template de création d'agent |
| A3 | Documenter xhigh en tant que feature API | `.claude/agents/ia.md` section "Optimisation production" | Ajouter 3-4 lignes : "Effort levels API Claude : xhigh disponible pour audits critiques via API directe. Non disponible via Task subagent dans Claude Code. Task budgets : [BETA]." |
| A4 | Mettre à jour project-context.md | `project-context.md` | Mettre à jour la mention du modèle Opus si elle existe dans la section stack |

**Actions retirées (4 updates -> 4 actions nettes) :**
- ~~1.4 /ultrareview dans reviewer.md~~ : slash command, pas accessible aux sous-agents
- ~~1.5 Note vision 2576px dans design.md + reviewer.md~~ : design.md est Sonnet, résolution dépend de la capture pas du modèle lecteur
- ~~1.6 Référencer 4.7 dans CLAUDE.md~~ : CLAUDE.md ne mentionne pas de version, le routage est par tier

---

## 6. Rollback plan

| Action | Rollback | Méthode |
|---|---|---|
| A1 — model ID | `model: claude-opus-4-7` -> `model: claude-opus-4-6` | `sed` inverse sur les 9 fichiers. Opus 4.6 reste disponible (non deprecated). |
| A2 — template | Remettre le default à `claude-opus-4-6` | Edit unique dans agent-factory.md |
| A3 — doc xhigh | Supprimer les 3-4 lignes ajoutées | Edit dans ia.md |
| A4 — project-context | Remettre la mention précédente | Edit unique |

**Indicateurs de rollback** : si après migration un agent produit des outputs dégradés (refuse des instructions précédemment suivies, timeout plus fréquents, outputs plus courts ou plus verbeux), rollback immédiat et investigation.

**Test de validation post-migration** : invoquer 1 agent (ex: @reviewer sur un mini-audit) et vérifier que l'output est conforme. Si régression détectée -> rollback.
