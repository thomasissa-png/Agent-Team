# Audit de cohérence framework post-cure S4 — @reviewer — 2026-06-11 (S5)

## Résumé exécutif (non-technique)
La cure S4 (-843 lignes) a bien nettoyé les gros fichiers (CLAUDE.md, _gates.md, orchestrator.md, index.html), mais elle est restée incomplète : plusieurs fichiers chargés à CHAQUE session par les agents contiennent encore les anciens chiffres (32 gates au lieu de 9, 19/20 agents incohérents, 89 vs 91 prompts) et des références à des choses supprimées (@moi, REPLIT_ACTIONS.md). Concrètement : un agent qui démarre une session lit des consignes contradictoires. Rien ne casse le site en production, mais le framework se ment à lui-même sur son propre état. Verdict : NO-GO tant que les ~12 corrections listées ne sont pas faites — toutes triviales (Edit d'une ligne), aucune refonte.

## Résumé technique
Cohérence partielle : la source de vérité `_gates.md` est correcte (9 gates + G_PROOF) mais ses 3 principaux consommateurs (`reviewer.md`, `_base-agent-protocol.md`) citent encore "32 gates G1-G32". Comptes agents/prompts désynchronisés entre 5 fichiers live. 4 références mortes @moi/REPLIT_ACTIONS dans des fichiers agents actifs. URLs/branches OK (main + agents.issa-capital.com propagés). Verdict global : NO-GO — 3 FAIL BLOQUANT, corrections ligne-à-ligne.

## Périmètre & méthode
- Source de vérité comptes : `ls .claude/agents/*.md` = 22 fichiers → 20 agents (hors `_base-agent-protocol.md`, `_gates.md`)
- Source de vérité gates : `_gates.md` = 9 gates (G1,G3,G5,G7,G12,G13,G15,G17,G_PROOF)
- Historique exclu du verdict : `docs/reviews/**`, `CHANGELOG.md`, `docs/lessons-learned-archive.md`, `project-context-immocrew.md` (figés)
- Méthode : Grep ciblés (comptes, refs mortes, gates, URLs, frontmatter model) + lecture hook + tests/

## Grille de gates ad-hoc (PVU — définies avant évaluation)

| Gate | Vérification | Classe | Verdict | Évidence (fichier:ligne) |
|---|---|---|---|---|
| A1 | Compte agents cohérent partout (=20) | BLOQUANT | FAIL | voir §Comptes |
| A2 | Compte prompts cohérent (89 vs 91) | MAJEUR | FAIL | project-context:44,47 (89) vs orchestrator:179 (91) |
| A3 | Compte gates cohérent (=9, pas 32) | BLOQUANT | FAIL | reviewer.md + _base-agent-protocol.md citent "32 gates G1-G32" |
| A4 | 0 ref morte @moi en fichier agent actif | BLOQUANT | FAIL | product-manager:175, design:112,158, founder-preferences:3 |
| A5 | 0 ref REPLIT_ACTIONS en fichier actif | MAJEUR | FAIL | _base-agent-protocol:226 |
| A6 | 0 ref orchestrator-reference en fichier actif | MINEUR | PASS | aucune en .claude/agents/ live (seulement docs/reviews historiques) |
| A7 | Branche défaut = main partout (pas master) | BLOQUANT | PASS | install.sh:68 / update.sh:71 = `for BRANCH in main master` (main préférée, master fallback). `master` résiduel = CI/CD générique projets CLIENTS (qa.md:98, infrastructure.md:41,46, docs/migrations) — légitime |
| A8 | URL site = agents.issa-capital.com (pas github.io) | MAJEUR | PASS | index.html:11,12,21 og: = agents.issa-capital.com ; 0 github.io live |
| A9 | Frontmatter model aligné + sales-enablement listé | MAJEUR | FAIL | Frontmatter OK (8 Opus / 12 Sonnet = 20) MAIS validate-framework.sh:103 rejette `claude-opus-4-8` + CLAUDE.md listes modèles = 8 Opus / 11 Sonnet (sales-enablement absent) |
| A10 | Hook pre-commit enforce cap 125L CLAUDE.md | MAJEUR | PARTIEL | .githooks/pre-commit enforce SEULEMENT CLAUDE.md 125L. Caps lessons 80L + project-context 250L annoncés (cmd 8) NON enforced par hook |
| A11 | _base-agent-protocol budget contexte à jour | MINEUR | FAIL | _base-agent-protocol:105 « CLAUDE.md (~530 lignes) » alors que CLAUDE.md = 110L. Chiffre périmé pré-cure |
| A12 | tests/validate-*.sh alignés post-cure (pas 32 gates) | MAJEUR | FAIL | validate-framework.sh:103 whitelist modèles = `opus-4-6\|sonnet-4-6\|haiku-4-5` → rejette les 8 agents Opus 4.8 = 8 ERREURS + exit ≠ 0. (Bon point : aucun script ne vérifie "32 gates", donc pas de désalignement gate-count) |

## Détail des findings

### Comptes (A1/A2/A3)
SOT : 20 agents / `_gates.md` = 9 gates. Le nombre de prompts (89 vs 91) n'a pas de SOT claire — à trancher par Thomas.

**Agents :**
- `orchestrator.md:77` : « **Mapping** (19 agents) » → liste 19 noms (orchestrator non compté). À clarifier : 20 agents au total ou 19 spécialistes + orchestrator.
- `product-manager.md:315` : « les 19 agents de base »
- `INSTALL.md:13,29,167` : « les 19 agents »
- `project-context.md:15,19` : « 19 agents » (persona/promesse) vs `:47` « 20 agents » (notes) → **contradiction interne au même fichier**.
- CLAUDE.md routage : 20 entrées (cohérent avec 20 fichiers). Listes modèles CLAUDE.md L33-equiv : 8 Opus + 11 Sonnet = 19 → **sales-enablement absent des listes modèles** (voir A9).

**Gates :**
- `_gates.md` (SOT) : 9 gates. CLAUDE.md:65,106 : « 9 gates » ✓ (corrigé S4).
- `reviewer.md:158,231,264,266` : « 32 gates G1-G32 » + GP1-GP10/GC1-GC10 → **FAIL, le reviewer lui-même est désaligné de sa propre source.**
- `_base-agent-protocol.md:232,256` : « 32 gates binaires G1-G32 » / « filtrer parmi G1-G32 » → **FAIL, lu par tous les agents.**

**Prompts :** project-context:44,47 = 89 ; orchestrator:179 = 91 ; index.html (S4) = 94 (per memo). Trois valeurs différentes → trancher SOT.

### Références mortes (A4/A5)
- `product-manager.md:175` : « validation @moi » dans critères go/no-go → @moi supprimé S4. **FAIL BLOQUANT.**
- `design.md:112` : « @moi choisit la direction artistique » → **FAIL.**
- `design.md:158` : « L'utilisateur ou @moi choisit » → **FAIL.**
- `docs/founder-preferences.md:3` : « source de vérité pour l'agent @moi » → fichier actif (lu cross-projets). **FAIL.**
- `_base-agent-protocol.md:226` : « Documenter l'installation du hook dans `REPLIT_ACTIONS.md` » → **FAIL MAJEUR** (REPLIT_ACTIONS retiré S4 ; règle commune n°10 supprimée).

### Gates supprimées encore référencées (massif — complément A3)
- `orchestrator.md:435,471-516` : GP1-GP10/GC1-GC10 + renvoi vers « _gates.md section Gates testeur-persona » = **section inexistante**.
- `product-manager.md:69,116,139,289` : G21/G27. `qa.md:138,141,154,323` : G26/G27/G31.
- `reviewer.md:67-69,151,168` : G27/G28/G29/G30/G19/G20 + scoring persona/B2B.
- `_base-agent-protocol.md:260-269,331` : tableau PVU citant G4/G8/G10/G16/G18-G24/G26 (supprimées).
- `fullstack.md:313,406` / `design.md:245` / `ux.md:204-205` / `agent-factory.md:111,328` : refs G31/G26/GP/GC résiduelles.

### Branches / URLs (A7/A8) — PASS
- `install.sh:68` / `update.sh:71` : `for BRANCH in main master` (main préférée, master fallback legacy) — défensif, correct.
- `master` résiduel dans qa.md:98, infrastructure.md:41,46, docs/migrations = CI/CD de projets CLIENTS, légitime.
- index.html:11,12,21 : og: = agents.issa-capital.com ; 0 github.io live.

### Scripts de tests (A12) — FAIL
- `tests/validate-framework.sh:103` : whitelist modèles `claude-opus-4-6|claude-sonnet-4-6|claude-haiku-4-5-20251001` → **rejette les 8 agents Opus 4.8** (agent-factory, qa, orchestrator, elon, reviewer, ia, fullstack, infrastructure) = 8 erreurs, exit ≠ 0. `bash tests/run-all.sh` prédit FAIL sur le framework actuel.
- Bon point : aucun script ne vérifie « 32 gates », donc pas de désalignement gate-count dans tests/.

### Budget contexte périmé (A11) — FAIL
- `_base-agent-protocol.md:105` : « CLAUDE.md (~530 lignes) » alors que CLAUDE.md = 110L post-cure.

## Contradictions détectées
| Livrable A | Livrable B | Contradiction | Criticité | Résolution |
|---|---|---|---|---|
| _gates.md (9 gates) | reviewer.md (32 gates G1-G32) | Le reviewer ignore sa propre SOT | BLOQUANT | Réécrire reviewer.md §gates sur 9 gates |
| _gates.md (9 gates) | _base-agent-protocol.md (G1-G32) | Protocole lu par tous désaligné | BLOQUANT | Edit L232/L256 → 9 gates |
| project-context:15,19 (19 agents) | project-context:47 (20 agents) | Contradiction intra-fichier | MAJEUR | Aligner sur 20 |
| Cure S4 (@moi supprimé) | product-manager/design/founder-prefs (@moi) | Refs mortes | BLOQUANT | Retirer/remplacer @moi |

## Angles morts
1. **Décision politique non tranchée** : les Phases testeurs GP/GC ont été retirées en S4 (mémo) mais orchestrator.md/qa.md/agent-factory.md les supposent vivantes. Trancher : réintroduire dans `_gates.md` OU purger les ~47 références.
2. **SOT du compte de prompts absente** : 89 (project-context) vs 91 (orchestrator:179) vs 94 (index.html). Recommandé : SOT = index.html = 94.
3. **Hook pre-commit partiel (A10)** : enforce uniquement le cap CLAUDE.md 125L. Caps lessons-learned 80L et project-context 250L (commandement 8) non enforced — by design (audit TTL manuel), à documenter ou automatiser.
4. **founder-preferences.md:3** se déclare « source de vérité pour l'agent @moi » — fichier cross-projets actif, à reformuler.

## Recommandation

### Top 3 corrections prioritaires
1. **reviewer.md + _base-agent-protocol.md → 9 gates** (A3, A7) : le gardien qualité audite avec une grille fantôme. Réécrire reviewer.md §158/231/264/266 + supprimer scoring persona/B2B ; _base-agent-protocol.md:232,256 + tableau L260-269 → ne garder que G1/G3/G5/G7/G12/G13/G15/G17/G_PROOF.
2. **Purge @moi des fichiers actifs** (A4) : product-manager.md:175, design.md:112,158, founder-preferences.md:3.
3. **Purge GP/GC + renvoi vers section inexistante** (A7) : orchestrator.md L435,471-516 (décision S4 = retrait des testeurs obligatoires).

### Corrections restantes (Edit 1 ligne chacune)
- CLAUDE.md modèles : ajouter sales-enablement à la liste Sonnet (11→12, total 19→20).
- project-context.md:15,19,44,47 : « 20 agents », « 94 prompts », « 9 gates », « 12 Sonnet ».
- INSTALL.md:13,29,167 : 19→20 agents. orchestrator.md:179 : 91→94 prompts.
- _base-agent-protocol.md:226 (REPLIT_ACTIONS), :105 (~530→~110 lignes), :303 (G31+→G_PROOF).
- tests/validate-framework.sh:103 : whitelist → `claude-opus-4-8|claude-sonnet-4-6|claude-haiku-4-5-20251001`.
- product-manager.md:69,116,139,289,315 ; qa.md:138,141,154,323 ; fullstack.md:313,406 ; design.md:245 ; ux.md:204-205 ; agent-factory.md:111,328.

### Verdict : **NO-GO** (cohérence interne)
3 FAIL BLOQUANT (A3, A4 — refs mortes @moi, A7 — gates fantômes). La cure S4 a corrigé les sources de vérité mais n'a pas propagé aux consommateurs. Toutes les corrections sont triviales (Edit ligne à ligne), aucune refonte nécessaire. Le site en production n'est PAS impacté.

---
**Handoff → @orchestrator**
- Fichiers produits : docs/reviews/reviewer-framework-coherence-audit-2026-06-11.md
- Décisions : NO-GO cohérence interne. 3 BLOQUANT, 5 MAJEUR, 2 MINEUR. ~30 corrections ligne-à-ligne listées.
- Points d'attention : trancher GP/GC (réintroduire ou purger) et SOT prompts (=94) AVANT d'appliquer les corrections.

**Vérifié :**
```
grep -c "^| G" .claude/agents/_gates.md
# → 9 (8 gates G + G_PROOF)
grep -rn "32 gates\|G1-G32\|@moi" .claude/agents/*.md docs/founder-preferences.md | grep -v reviews | head -3
# → reviewer.md:158 "32 gates G1-G32", _base-agent-protocol.md:232, product-manager.md:175 "@moi" = FAIL
grep -n "opus-4" tests/validate-framework.sh
# → :103 whitelist claude-opus-4-6 (périmé, agents réels = opus-4-8)
```
---
