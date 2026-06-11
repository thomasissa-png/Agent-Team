<!-- Version: 2026-06-11T00:00 — @ia — Audit qualité exhaustif des 20 prompts système d'agents (S5) -->
# Audit qualité exhaustif — 20 prompts système d'agents

> **Agent** : @ia — **Session** : S5 — **Date** : 2026-06-11
> **Périmètre** : 20 fichiers `.claude/agents/*.md` (hors `_base-agent-protocol.md` + `_gates.md`, lus comme références)
> **Méthode** : frontmatter + redondance + taille/valeur + obsolescence + actionnabilité + contradictions inter-agents
> **Source de vérité gates** : `_gates.md` = **9 gates** (G1, G3, G5, G7, G12, G13, G15, G17 + G_PROOF)

---

## TL;DR (verdict global)

La cure S4 a vidé `_gates.md` de 32 → 9 gates **sans propager aux consommateurs**. Résultat : **47 références à des gates supprimées** (G21, G26, G27, G31, G32, GP1-GP10, GC1-GC10, G19-G30, G33+) subsistent dans 10 agents, dont les deux gardiens qualité (`reviewer.md` + `_base-agent-protocol.md`). Le système est en **incohérence source-de-vérité ↔ exécutant** : le reviewer prétend exécuter "32 gates G1-G32" qui n'existent plus. C'est un **P0 bloquant** qui invalide partiellement la cure S4.

Hors gates, le ratio signal/bruit reste **bon** sur les 11 agents Sonnet (140-260L, spécifiques). Le bloat résiduel se concentre sur orchestrator (749L), agent-factory (444L), fullstack (423L).

---

## Tableau de synthèse (20 agents)

| Agent | L | Modèle | Frontmatter | Gates obsolètes | Bloat | Verdict |
|---|---|---|---|---|---|---|
| orchestrator | 749 | Opus OK | OK | GP/GC ×11 | OUI | P0 |
| agent-factory | 444 | Opus OK | OK | GP/GC ×3 | partiel | P1 |
| fullstack | 423 | Opus OK | OK | G26/G31 ×3 | partiel | P1 |
| elon | 402 | Opus OK | OK | non | non | OK |
| reviewer | 380 | Opus OK | OK | G1-G32/GP/GC ×9 | OUI | P0 |
| product-manager | 355 | Sonnet OK | OK | G21/G27 ×5 | partiel | P1 |
| qa | 338 | Opus OK | OK | G26/G27/G31 ×6 | partiel | P1 |
| ia | 285 | Opus OK | OK | non (1 faux pos) | non | OK |
| design | 260 | Sonnet OK | OK | G27/G28 ×1 | non | P2 |
| ux | 240 | Sonnet OK | OK | GP/GC ×2 | non | P2 |
| sales-enablement | 240 | Sonnet OK | v1.0 + commentaire HTML | non | non | P2 |
| seo | 205 | Sonnet OK | OK | non | non | OK |
| copywriter | 200 | Sonnet OK | OK | non | non | OK |
| social | 197 | Sonnet OK | OK | non | non | OK |
| infrastructure | 195 | Opus OK | OK | non | non | OK |
| geo | 190 | Sonnet OK | OK | non | non | OK |
| creative-strategy | 178 | Sonnet OK | OK | non | non | OK |
| growth | 160 | Sonnet OK | OK | non | non | OK |
| data-analyst | 148 | Sonnet OK | OK | non | non | OK |
| legal | 140 | Sonnet OK | OK | non | non | OK |

**Frontmatter** : 20/20 ont name/description/model/version. Modèles 100% alignés CLAUDE.md (8 Opus, 12 Sonnet — note : CLAUDE.md dit "11 Sonnet" mais sales-enablement porte à 12 ; voir P2-9). Versions cohérentes (2.0/2.1) sauf sales-enablement (v1.0 + commentaire HTML résiduel ligne 1).

---

## Détail par agent

### Critiques (P0/P1)

**reviewer.md (380L) — P0.** L'agent qui EXÉCUTE les gates est le plus incohérent du système. Références mortes :
- L158/L231/L264/L266 : "32 gates G1-G32" → n'existent plus (9 gates).
- L158/L266/L322 : GP1-GP10 + GC1-GC10 → supprimées S4.
- L155-163 : "Scoring persona/B2B 9+7 dimensions 1-10 seuil 9/10" + "score dérivé (gates PASS/applicables)×10" → tout le scoring numérique a été remplacé par PASS/FAIL binaire.
- L151 : "Gates light : G1, G3, G5, G6, G7, G12, G13, G15, G17, G19, G20, G24, G26" → G6/G19/G20/G24/G26 n'existent plus.
- L76 : "promotion en gates permanentes (G33+)" → numérotation morte.
- L68 : "layout par section (G27) et images (G28)".
- Impact : un reviewer qui suit son propre prompt produit un rapport avec 23 gates fantômes. **Le gardien qualité est cassé.**

**orchestrator.md (749L) — P0 (gates) + bloat.** 11 références GP1-GP10/GC1-GC10 (L390-391, L435, L458, L471-472, L480-481, L515-517) renvoyant à "_gates.md section Gates testeur-persona" — **cette section n'existe plus dans `_gates.md`**. L'orchestrator instruit donc d'exécuter des gates introuvables. Bloat : 749L reste le plus gros fichier (S4 l'a réduit de 831→749 mais la cible 400L n'est pas atteinte). WARN cap 900 levé mais marge à surveiller. Le bloc Phases testeurs 2c/2d/5b a été retiré du compteur S4 MAIS les renvois GP/GC dans le corps de l'orchestrator subsistent (cure incomplète).

**agent-factory.md (444L) — P1.** L103-112 + L328 : instruit de créer des agents testeurs avec "gates GP1-GP10/GC1-GC10 définies dans CLAUDE.md" — or CLAUDE.md ne les définit plus (cure S4). Le template de création d'agents testeurs produira donc des agents pointant vers des gates fantômes : **l'obsolescence se propagerait aux futurs agents générés**. 444L : la section testeurs (≈40L) peut être condensée. Frontmatter/redondance OK.

**fullstack.md (423L) — P1.** L313/L406/L421 : références G26 (conformité visuelle) et G31 (favicon) supprimées S4 (G31/G32 sont devenus "checks recommandés" hors gates). Le savoir technique (favicon coverage, boucle visuelle) reste valable — seul le **tag de gate** est mort. Correction : remplacer "gate G26/G31" par "check recommandé". Bloat modéré : section "écran par écran" (L327+) verbeuse mais à forte valeur. Replit correctement marqué "(legacy)" partout (L149/L158/L179/L421) — conforme priorité CF.

**product-manager.md (355L) — P1.** 5 références G21 (5 états UI) et G27 (matrice traçabilité) — L69/L116/L139/L143/L175/L289. Le contenu (5 états UI, scénarios persona) est de grande valeur ; seuls les tags de gate sont morts. L175 mentionne aussi "validation @moi" → **@moi supprimé S4** (référence morte critique).

**qa.md (338L) — P1.** 6 références G26/G27/G31 (L98/L138/L141/L152/L154/L163/L323). Idem : matrice de traçabilité, pipeline pre-deploy, favicon check = bon contenu, tags morts. Replit correctement marqué legacy (L98). Pattern A/B (S3) bien intégré.

### Sains (OK)

**elon.md (402L) — OK.** Aucune gate obsolète, aucun @moi, aucun scoring résiduel. 402L justifiés : méthode first-principles dense et spécifique. Verdicts GO/NO-GO basés valeur persona (conforme cmd 5). Ratio signal/bruit excellent.

**ia.md (285L) — OK.** Aucune gate obsolète. L77-78 "4/5" = échelle qualité interne du tableau de sélection modèle (légitime, pas un scoring de gate). L162 : "pgvector Neon futurs / Postgres Replit legacy" = conforme priorité CF. Protocole migration modèle (6 étapes) + alias -latest minor-family présents. Self-cohérent.

**infrastructure.md (195L) — OK.** Modèle de propreté Replit : "legacy/fallback" explicite partout (L26/L38/L64-89/L142-146), CF priorité (L27/L38/L141). Aucune gate morte. L145 "non-Cloudflare" correctement formulé (bug S4 corrigé).

**seo/copywriter/social/geo/creative-strategy/growth/data-analyst/legal (140-205L) — OK.** Spécifiques, hérités proprement du protocole via "Le protocole standard s'applique (voir _base-agent-protocol.md)". Aucune redondance lourde, aucune gate morte. Ratio signal/bruit optimal. Ce sont les agents qui ont le mieux survécu à la cure.

### P2 (mineurs)

**design.md (260L) — P2.** 1 référence G27/G28 (L68 via héritage protocole) — mineur. Sinon sain, tokens backoffice cohérents.

**ux.md (240L) — P2.** L204-205 : "Gates GP1-GP10/GC1-GC10 dans CLAUDE.md" (×2) → fantômes. L83 ">= 8/10" = seuil HEART/NPS métier légitime (pas un scoring de gate). Contenu testeurs à reformuler ou retirer.

**sales-enablement.md (240L) — P2.** Seul agent avec **commentaire HTML résiduel ligne 1** (`<!-- Version: ... Création initiale -->`) AVANT le frontmatter YAML — incohérent avec les 19 autres. Version 1.0 (jamais itéré). Aucune gate morte. Cosmétique.

---

## Redondance avec CLAUDE.md / _base-agent-protocol.md

**Bonne nouvelle** : 134 renvois "voir _base-agent-protocol.md / voir CLAUDE.md" répartis sur les 21 fichiers → l'héritage est globalement respecté, peu de duplication brute des règles communes (anti-timeout, handoff, anti-invention, protocole d'entrée). La cure S4 a bien fait ce travail sur les agents Sonnet.

**Résidu** : reviewer.md duplique encore la logique de scoring (L155-163) qui n'a plus de source — ce n'est pas de la redondance mais de l'**obsolescence active**. ~25 lignes à retirer.

---

## Contradictions inter-agents (chaînages producteur→consommateur)

1. **`_gates.md` (9 gates) ↔ reviewer/orchestrator/protocol (32 gates + GP/GC)** : contradiction frontale. La source dit 9, les exécutants disent 32. **C'est LA contradiction structurante du système post-cure.**
2. **agent-factory → CLAUDE.md** : agent-factory dit "GP/GC définies dans CLAUDE.md", CLAUDE.md ne les définit plus. Chaînage cassé.
3. **product-manager → @moi** : PM L175 attend "validation @moi", agent supprimé. Chaînage cassé.
4. **fullstack/qa → G26 baselines** : les deux référencent la gate G26 pour les screenshots `tests/screenshots/` — le contenu est cohérent entre eux (bon chaînage) mais le tag G26 est mort des deux côtés (incohérence avec `_gates.md`).

Chaînages SAINS vérifiés : ux→fullstack (ux-review.md/ux-writing-guide.md), creative-strategy/PM→agent-factory (specs recommandation agents), ia→fullstack (src/lib/ai/).

---

## Synthèse — Top 10 problèmes priorisés

| # | Prio | Problème | Fichier:ligne | Lignes économisables / action |
|---|---|---|---|---|
| 1 | **P0** | reviewer.md référence "32 gates G1-G32" + scoring 1-10 supprimés | reviewer.md L155-163, L231, L264-277, L322 | ~30L à réécrire sur les 9 gates PASS/FAIL |
| 2 | **P0** | GP1-GP10/GC1-GC10 introuvables dans `_gates.md` mais invoqués | orchestrator.md L390-517 (×11), ux.md L204-205, agent-factory L103-112 | Décider : ré-ajouter section testeurs dans `_gates.md` OU retirer 47 réfs |
| 3 | **P0** | `_base-agent-protocol.md` mappe gates mortes (G19/G21/G24/G26/GC) | _base-agent-protocol.md L62, L260-266 | ~8L à corriger (gardien hérité par tous) |
| 4 | **P1** | agent-factory propage GP/GC aux futurs agents testeurs générés | agent-factory.md L103-112, L328 | Corriger le template avant prochaine génération |
| 5 | **P1** | product-manager attend "validation @moi" (agent supprimé S4) | product-manager.md L175 | 1L — retirer @moi |
| 6 | **P1** | Tags G21/G27 morts dans PM (5×) — contenu sain, tag faux | product-manager.md L69-289 | Remplacer "Gate G21/G27" par "obligatoire" |
| 7 | **P1** | Tags G26/G27/G31 morts dans qa (6×) | qa.md L98-323 | Remplacer par "check obligatoire/recommandé" |
| 8 | **P1** | Tags G26/G31 morts dans fullstack (3×) | fullstack.md L313, L406, L421 | "check recommandé" |
| 9 | **P2** | sales-enablement : commentaire HTML avant frontmatter + v1.0 | sales-enablement.md L1 | Retirer ligne 1, harmoniser |
| 10 | **P2** | orchestrator 749L > cible 400L (bloat résiduel post-cure) | orchestrator.md global | DEFER D11 Phases 2-3, ~150-300L compressibles |

**Total lignes obsolètes à corriger** : ~47 références gates + ~30L scoring reviewer + 2 réfs @moi ≈ **80 lignes de dette d'obsolescence** sur le système.

---

## Avis global franc

La cure S4 (-843L) a réussi sur la **forme** (héritage du protocole propre, 12/20 agents sains, ratio signal/bruit excellent sur tous les Sonnet) mais **échoué sur la propagation**. Vider `_gates.md` de 32→9 gates était la bonne décision ; ne pas avoir mis à jour les 3 fichiers qui **exécutent** ces gates (reviewer, orchestrator, _base-agent-protocol) est exactement le pattern "fais à moitié, vérifies rien" que Thomas dénonçait en S4 — appliqué à la cure elle-même. Le mémo S4 anticipait ce risque ("la cure S4 est largement THÉORIQUE tant qu'elle n'a pas été éprouvée") : **l'épreuve révèle une cure incomplète**, pas un échec de conception.

Reste-t-il du bloat ? **Marginalement.** Seul orchestrator (749L) est clairement au-dessus de sa cible. agent-factory/fullstack (423-444L) sont denses mais à forte valeur — pas du bloat, de la spécificité. Les 14 agents ≤ 285L sont calibrés. Le vrai problème n'est pas le **volume** mais la **cohérence** : 80 lignes de dette d'obsolescence concentrées sur les gardiens qualité empoisonnent un système par ailleurs sain.

**Le ratio signal/bruit est bon (≈85%)** mais la dette est mal placée : elle touche les agents qui arbitrent (reviewer, orchestrator). Un système où le juge applique une grille périmée note faux. **Priorité absolue S5 : trancher la question GP/GC (réintégrer dans `_gates.md` OU purger les 47 réfs), puis aligner reviewer sur les 9 gates.** Tant que ce n'est pas fait, tout verdict GO/NO-GO du reviewer est suspect.

Décision recommandée (à arbitrer par Thomas) : les gates testeurs GP/GC apportaient une vraie valeur (évaluation VALEUR perçue vs conformité technique). Si elles sont volontairement supprimées, purger 47 réfs. Si elles doivent vivre, les **réintégrer dans `_gates.md`** comme bloc dédié — ne pas les laisser en limbes référencées-mais-non-définies.

---

**Handoff → @orchestrator**
- **Fichier produit** : `/home/user/Agent-Team/docs/reviews/ia-agents-quality-audit-2026-06-11.md`
- **Décisions / constats** : frontmatter 20/20 OK, modèles 100% alignés CLAUDE.md. P0 = 47 réfs gates supprimées (GP/GC/G19-G32) dans 10 agents dont reviewer+orchestrator+_base-protocol. 12/20 agents sains. Bloat résiduel orchestrator seul.
- **Points d'attention** :
  - **Décision requise Thomas** : GP1-GP10/GC1-GC10 → réintégrer dans `_gates.md` OU purger 47 réfs. Bloquant pour fiabiliser le reviewer.
  - Corriger reviewer.md (32→9 gates, retirer scoring 1-10) AVANT toute prochaine review (gardien cassé).
  - Corriger product-manager.md L175 (@moi supprimé).
  - agent-factory.md template testeurs propage l'obsolescence aux futurs agents — corriger avant prochaine génération.
  - Hors périmètre @ia : ces corrections sont des éditions de prompts, pas du code `src/lib/ai/`. Routage : @orchestrator dispatche ou @reviewer/@agent-factory s'auto-corrigent.

---

**Vérifié :**
```bash
# 1. _gates.md ne contient bien que 9 gates (G1/G3/G5/G7/G12/G13/G15/G17/G_PROOF)
grep -oE 'G_PROOF|G1[0-9]?|G3|G5|G7' .claude/agents/_gates.md | sort -u
# → G1 G12 G13 G15 G17 G3 G5 G7 G_PROOF (aucun G18-G32)

# 2. Compter les réfs à gates supprimées dans les agents (P0)
grep -rEn 'G21|G26|G27|G28|G31|G32|GP[0-9]|GC[0-9]|G19|G24|G33' .claude/agents/*.md | grep -v _gates.md | wc -l
# → 47 occurrences sur 10 fichiers

# 3. Réfs @moi résiduelles (agent supprimé S4)
grep -rn '@moi\|validation @moi' .claude/agents/product-manager.md
# → product-manager.md:175 validation @moi
```
