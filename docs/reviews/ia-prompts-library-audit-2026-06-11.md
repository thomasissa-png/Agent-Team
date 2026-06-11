# Audit exhaustif — Bibliothèque de prompts `index.html`

**Agent** : @ia · **Session** : S5 · **Date** : 2026-06-11
**Cible** : `index.html` (4372 lignes) · **Périmètre** : bibliothèque de prompts post-cure S4

---

## 0. Méthode

Audit en 6 axes : comptage réel, cohérence post-cure S4, auto-suffisance, alignement modèles, parité Tout-en-un, UX. Grep structurel sur la structure JS (`const PROMPTS`), échantillonnage de 12 prompts représentatifs, vérification croisée avec `project-context.md` et `_gates.md`.

---

## 1. Comptage réel des prompts

| Source | Valeur | Commentaire |
|---|---|---|
| Meta description (L7) | 94 prompts | Annonce marketing |
| Sélecteur guidé (L592) | 94 prompts | Cohérent |
| Card MAJ (L3789) | 94 prompts | Cohérent |
| **Grep `prompt:` (compteur réel)** | **94** | **Match exact** |
| Grep `titre:` | 0 | Le champ est `title:` (anglais), pas `titre:` |

**Verdict comptage : CONFORME.** Le champ structurant est `title:`/`quand:`/`prompt:`. Le compteur `prompt:` (94) correspond exactement au chiffre annoncé. Aucune sur-annonce ni sous-annonce.

> Note : la mission demandait de Grep `titre:` — le code utilise `title:` (anglais) pour le titre et `quand:`/`prompt:` (français) pour le reste. Mélange FR/EN sur les clés d'objet, sans impact fonctionnel.

---

## 2. Cohérence post-cure S4

**État cible post-S4** : 20 agents, 9 gates, @moi supprimé, testeurs optionnels, 94 prompts, domaine `agents.issa-capital.com`, branche `main`.

| Pattern recherché | Occurrences | Statut |
|---|---|---|
| `@moi` / `moi.md` | L923, L928, L3903 | LÉGITIME (prompt d'audit de cure + card MAJ documentant la suppression) |
| `orchestrator-reference` | L3903 | LÉGITIME (card MAJ : `rm -f`) |
| `32 gates` / `G1-G32` | L923, L928 | LÉGITIME (prompt audit qui cherche les obsolètes à corriger) |
| `REPLIT_ACTIONS` | 0 | CONFORME (retiré) |
| `21 agents` / `19 agents` | 0 | CONFORME |
| `89 prompts` / `91 prompts` | 0 | CONFORME |
| `9 gates` / `gates PASS` | L637, L691, L699, L945, L952, L962, L2542, L3684 | CONFORME (compteur aligné `_gates.md`) |
| `G_PROOF` | L655, L862, L3684 | CONFORME (gate bloquant intégré) |
| `master` | 0 (hors update.sh) | CONFORME (branche `main`) |
| `4.5/5` / `X/5` | 0 | CONFORME (scoring 1-5 supprimé) |

**Verdict cohérence S4 : CONFORME.** Aucune référence obsolète résiduelle hors contexte légitime. Les seuls hits `@moi`/`32 gates` sont DANS le prompt d'audit de cure (L920-962) qui sert justement à détecter ces résidus, et dans la card MAJ qui documente la suppression S4. C'est volontaire et correct.

---

## 3. Auto-suffisance (échantillon 12 prompts)

Échantillon : sélecteur guidé (L590), 3 Tout-en-un (autopilot L634, check-up L688, pivot L832), + prompts par agent (creative-strategy L974, fullstack perf L1842, ia modèles L1585, qa audit L2670, seo L2061, growth L2178, legal L1045, infrastructure L3016).

| Critère vérifié | Constat |
|---|---|
| Invocation agent correcte (@agent ∈ 20) | **PASS** — 344 mentions `@agent`, toutes pointant vers les 20 agents valides |
| Références fichiers valides | **PASS** — `project-context.md`, `docs/...`, `_gates.md`, `templates/project-context.md`, `docs/lessons-learned.md` cohérents |
| Placeholders utilisateur délimités | **PASS** — questions posées à l'utilisateur (sélecteur), pas de placeholder brut à éditer manuellement |
| Backticks imbriqués (bug 8e récurrence) | **PASS** — 0 triple-backtick dans les `prompt:` ; WARNING inline S2 toujours présent (L512-524), mentionne explicitement "8e casse" |
| Auto-suffisance (pas d'édition fichier manuelle) | **PASS** — les prompts créent/lisent les fichiers via les agents ; aucun ne demande à l'utilisateur d'éditer un .md à la main |

**Anomalies écartées (faux positifs)** :
- `@next` (L1846) = `@next/bundle-analyzer` (package npm Next.js), PAS une invocation d'agent. LÉGITIME.
- `@moi` (L3902-3903) = card MAJ qui instruit `rm -f .claude/agents/moi.md` (documente la suppression S4). LÉGITIME et nécessaire.

**Verdict auto-suffisance : CONFORME.** Aucune nouvelle occurrence du bug backtick. WARNING anti-backtick toujours en place. Tous les prompts échantillonnés sont copier-collables et auto-suffisants.

---

## 4. Alignement modèles Opus 4.8 / Sonnet 4.6

| Métrique | Valeur | Statut |
|---|---|---|
| `model:"claude-opus-4-8"` | 8 agents | CONFORME (orchestrator, fullstack, qa, infrastructure, ia, reviewer, agent-factory, elon) |
| `model:"claude-sonnet-4-6"` | 12 agents | CONFORME |
| Total agents | 20 | CONFORME |
| Résidus `4.7` / `4.6` modèle obsolète | 0 | CONFORME |

**Verdict modèles : CONFORME.** Tous les modèles sont à jour (Opus 4.8 + Sonnet 4.6), tags exacts (`claude-opus-4-8`, `claude-sonnet-4-6`), aucun résidu 4.7.

> **Incohérence externe (PAS dans index.html)** : `project-context.md` L33 annonce "11 agents Sonnet 4.6" alors qu'index.html en liste **12** (Grep confirmé : `claude-sonnet-4-6` × 12, sales-enablement v1.0 inclus). Le compteur source de vérité est index.html (12). À corriger dans `project-context.md`, pas dans index.html. → P2.
> Note 2 : `project-context.md` L44 et L47 disent encore "89 prompts" alors que l'état réel et index.html disent "94 prompts". Drift project-context, pas index.html. → P2.

---

## 5. Parité Tout-en-un (autopilot / check-up / pivot)

Les 3 prompts reposent sur la "carte de référence" du protocole orchestrator (section "Prompts de la bibliothèque par phase") pour garantir la parité qualité avec les prompts individuels.

| Prompt | Ligne | Carte de réf | Alignement état post-cure |
|---|---|---|---|
| Lancer A à Z (autopilot) | L634-685 | OUI (L642 : "lis la carte de référence... extrais les instructions détaillées du prompt correspondant") | **PASS** — "9 gates binaires (voir _gates.md)" (L637), G_PROOF (L655), testeurs optionnels (L655), GO finale alignée gates BLOQUANT/REQUIS (L649), checkpoint Phase 0 (L654) |
| Check-up complet | L688-... | OUI (renvoie aux prompts d'audit de la bibliothèque) | **PASS** — "9 gates binaires (voir _gates.md, PASS/FAIL)" (L691, L699), gate learnings P0/P1 (L696) |
| Pivoter | L832-872 | OUI (L851 : "Suis l'ordre de dépendance de ta carte de référence... Phases 0→5") | **PASS** — "100% gates PASS" (L872), capitalise sur les acquis, garde-fou vrai-pivot vs structurel (L839) |

**Cohérence carte de référence** : les 3 prompts citent uniformément "9 gates" + G_PROOF + testeurs optionnels + phases 0→5 — strictement aligné avec l'état post-cure S4 (`_gates.md` = 9 gates G1/G3/G5/G7/G12/G13/G15/G17 + G_PROOF bloquant). Aucun résidu "32 gates", "4.5/5" ou "MVP" dans les 3 prompts.

**Verdict parité Tout-en-un : CONFORME.** La carte de référence est alignée post-cure. Les 3 autopilots préservent le niveau de détail (sections numérotées, critères, livrables) et n'ont PAS dérivé.

---

## 6. UX de la bibliothèque

| Critère | Constat |
|---|---|
| Catégories | 10 (Démarrage, Tout-en-un, Phases 0-5, Workflows avancés, Sessions) |
| Agents référencés | Tous valides (20 agents existants, 0 orphelin @moi) |
| Modèle de carte agent | 20 cartes, modèles à jour |

**10 catégories confirmées** (Grep `category:`) : Démarrage (L527), Tout-en-un (L630), Phase 0 — Stratégie (L967), Phase 1 — Conception (L1220), Phase 2 — Développement (L1517), Phase 3 — Visibilité (L2054), Phase 4 — Acquisition & Croissance (L2171), Phase 5 — Audit & Validation (L2522), Workflows avancés (L3180), Sessions (L3481). Structure claire alignée sur le cycle projet (phases 0→5 + transverses).

**Prompts orphelins** : aucun. Toutes les 344 mentions `@agent` pointent vers les 20 agents existants. Zéro référence à @moi/orchestrator-reference hors card MAJ documentaire. Zéro flux supprimé référencé.

**Doublons** : pas de doublon strict détecté. Les recoupements thématiques (ex : audit présent dans check-up ET Phase 5, perfs dans infra) sont des compositions volontaires (Tout-en-un = orchestration des prompts unitaires), pas des duplications.

**Verdict UX : CONFORME.** Catégorisation claire, 0 orphelin, 0 doublon, navigation cohérente avec le cycle Idée→V1→Production→Croissance.

---

## 7. Synthèse — Top problèmes (P0/P1/P2)

Aucun problème P0 ni P1 dans `index.html`. Les seuls écarts sont des drifts dans `project-context.md` (hors périmètre index.html) et des micro-incohérences cosmétiques.

| # | Sévérité | Problème | Localisation | Action |
|---|---|---|---|---|
| 1 | **P2** | `project-context.md` L33 dit "11 agents Sonnet" — réel = 12 (index.html source de vérité) | project-context.md L33 (PAS index.html) | Corriger project-context : 12 Sonnet |
| 2 | **P2** | `project-context.md` L44/L47 disent "89 prompts" — réel = 94 | project-context.md L44, L47 | Corriger project-context : 94 prompts |
| 3 | **P2** | `project-context.md` L47 dit "32 gates binaires" — réel = 9 (post-cure S4) | project-context.md L47 | Corriger project-context : 9 gates |
| 4 | **P2** | Mélange FR/EN sur les clés d'objet : `title:` (EN) vs `quand:`/`prompt:` (FR) | index.html structure JS | Cosmétique, aucun impact fonctionnel — laisser ou harmoniser `titre:` |
| 5 | **P2** | `project-context.md` L47 mentionne "@moi" via concept carte de référence — @moi supprimé S4 | project-context.md (Notes libres) | Vérifier wording, pas bloquant |
| 6 | **P2** | Card MAJ (L3902) très dense (~400 mots) — risque lisibilité mobile | index.html L3902 | Acceptable (prompt technique de migration), surveiller |

> Note : les points 1-3 et 5 sont des **drifts de `project-context.md` non synchronisés avec la cure S4**. La bibliothèque `index.html` elle-même est à jour ; c'est le doc de contexte qui n'a pas été repropagé après S4. À traiter en session de maintenance project-context (ou via le prompt "audit project-context volumineux").

---

## 8. Verdict global

**La bibliothèque de prompts `index.html` est AU NIVEAU du framework agents post-cure S4. Elle n'a PAS dérivé.**

Synthèse des 6 axes :

| Axe | Verdict |
|---|---|
| 1. Comptage réel (94 prompts) | CONFORME — 94 exact, triple-cohérent |
| 2. Cohérence post-cure S4 | CONFORME — 0 résidu obsolète hors contexte légitime |
| 3. Auto-suffisance | CONFORME — 0 bug backtick, WARNING en place, copier-collable |
| 4. Alignement modèles | CONFORME — Opus 4.8 ×8 + Sonnet 4.6 ×12, tags exacts |
| 5. Parité Tout-en-un | CONFORME — carte de réf alignée 9 gates + G_PROOF |
| 6. UX bibliothèque | CONFORME — 10 catégories, 0 orphelin, 0 doublon |

**Avis franc** : la cure S4 a été propagée à `index.html` avec rigueur. Le bug récurrent des backticks (8 récurrences historiques) est cette fois maîtrisé — WARNING inline présent et 0 nouvelle occurrence. Les 3 prompts Tout-en-un n'ont pas dérivé de leur carte de référence. Les seuls écarts sont des drifts **dans `project-context.md`** (compteurs "89 prompts / 11 Sonnet / 32 gates" non mis à jour post-S4) — c'est le doc de contexte qui traîne, pas la bibliothèque. **Note : la bibliothèque est meilleure que son propre doc de contexte.** Recommandation : resynchroniser `project-context.md` sur l'état réel (94/12/9) en priorité avant de communiquer sur les chiffres.

**Verdict bibliothèque : GO — aucun blocage. 6/6 axes CONFORMES.**

---

## Handoff

---
**Handoff → @orchestrator**
- **Fichier produit** : `/home/user/Agent-Team/docs/reviews/ia-prompts-library-audit-2026-06-11.md`
- **Décisions / constats** :
  - `index.html` = 94 prompts exacts, 20 agents, 9 gates + G_PROOF, modèles Opus 4.8/Sonnet 4.6 à jour. **6/6 axes CONFORMES.**
  - Bug backtick (8e récurrence historique) **non reproduit** — WARNING inline S2 toujours en place (L512-524).
  - 3 prompts Tout-en-un alignés sur la carte de référence post-cure.
- **Points d'attention (3 corrections P2 dans `project-context.md`, PAS index.html)** :
  - L33 : "11 agents Sonnet" → **12**
  - L44/L47 : "89 prompts" → **94**
  - L47 : "32 gates binaires" → **9 gates**
  - Ces drifts viennent d'une non-repropagation post-cure S4. Aucun impact sur la bibliothèque, mais à corriger pour cohérence des chiffres communiqués.
---

## Vérifié

```bash
# 1. Comptage réel des prompts (attendu : 94)
grep -c "prompt:\`" /home/user/Agent-Team/index.html

# 2. Absence de bug backtick dans les prompts (attendu : 0 — seul le WARNING comment matche)
grep -n '```' /home/user/Agent-Team/index.html | grep -v "backtick" | wc -l

# 3. Modèles à jour (attendu : 8 Opus 4.8 + 12 Sonnet 4.6 = 20) ; résidus 4.7 (attendu : 0)
grep -c 'claude-opus-4-8' /home/user/Agent-Team/index.html
grep -c 'claude-sonnet-4-6' /home/user/Agent-Team/index.html
grep -c 'claude-opus-4-7\|claude-sonnet-4-5' /home/user/Agent-Team/index.html
```
