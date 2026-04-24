# Audit — Prompt TTL project-context.md + Étape 0 P3 sanity check

Date : 2026-04-24 | Commit : 3cb427d | Auditeur : @ia | Cible : index.html lignes 3492-3536 (Change 1) + 3652-3662 (Change 2)

## 1. Verdict global

**GO CONDITIONNEL** — Les deux changements sont structurellement solides. 3 patches mineurs requis (ambiguïtés d'exemption, commande Grep sous-spécifiée, condition skip mode hotfix à formaliser). Aucun blocker, déployable après patches.

## 2. Notes par angle

| # | Angle | Note | Justification |
|---|---|---|---|
| 1 | Logique DRY-RUN | 9/10 | Séparation étapes 1/2/3 explicite, "aucune écriture" affirmé Étape 2, feu vert utilisateur formalisé (Continue/Exempt/Skip). Seul risque résiduel : Étape 1 ne précise pas "read-only". |
| 2 | Exemptions | 6/10 | "Learnings P0" : critère clair (colonne Sévérité). "Décisions fondatrices" et "préférences fondateur" : flous. Edge case décision S2 obsolète en S20 NON traité — exemption semble permanente, aucun mécanisme de re-qualification. |
| 3 | Commandes techniques | 7/10 | wc -l OK. "Grep (^## )" sous-spécifié pour un agent (manque --count, --line-number, ou fichier cible explicite). wc -l "hors memo+historique" est un calcul, pas une commande — ambigu. |
| 4 | Étape 0 P3 systématique | 8/10 | BLOQUANT uniquement sur CLAUDE.md (125), le reste déclenche audit sans bloquer. "Skip audit" en mode hotfix est pragmatique MAIS non défini — qu'est-ce qu'un hotfix ? Risque interprétation agent. |
| 5 | Cohérence cross-prompt | 9/10 | 125/80/250 cohérents entre CLAUDE.md cmd n°8, Étape 5d P2, Étape 0 P3, nouveau prompt TTL. Founder-prefs 150/180 cohérent P3 seul (pas dans cmd n°8 — OK car soft cap). |

## 3. Patches identifiés

**Patch A — Exemptions (angle 2, ligne 3515)**
Avant : Exemptions proposées : learnings P0, décisions structurelles fondatrices, préférences fondateur inscrites dans project-context.md (à ne JAMAIS archiver, même si anciennes)
Après : Exemptions proposées : (a) learnings P0 identifiés par colonne Sévérité=P0, (b) décisions fondatrices = décisions marquées [FONDATRICE] ou référencées dans > 3 entrées historique postérieures, (c) préférences fondateur listées dans docs/founder-preferences.md. Re-qualification : une décision fondatrice devenue obsolète (contredite par décision plus récente) DOIT être archivée avec note "obsolète depuis session [N]" — non exemptée.

**Patch B — Commande Grep (angle 3, ligne 3499)**
Avant : Identifier les sections via Grep (^## ) : lister chaque section avec sa taille approximative
Après : Identifier les sections via Bash : grep -n "^## " project-context.md. Pour chaque section, calculer la taille en soustrayant les numéros de ligne consécutifs (ligne section N+1 moins ligne section N).

**Patch C — Mode hotfix défini (angle 4, ligne 3660)**
Avant : L utilisateur peut dire "Skip audit" si mode hotfix (à tracer dans la clôture) mais le WARNING reste dans le mémo.
Après : L utilisateur peut dire "Skip audit" UNIQUEMENT en mode hotfix, défini comme : (a) bug bloquant prod à corriger < 30 min, (b) session explicitement déclarée "hotfix" dans le prompt initial. Hors de ces 2 cas, le skip est refusé. WARNING tracé dans mémo clôture avec raison.

**Patch D — Étape 1 read-only explicite (angle 1, ligne 3497)**
Avant : Étape 1 — Mesure et diagnostic :
Après : Étape 1 — Mesure et diagnostic (READ-ONLY, aucun Write ni Edit autorisé) :

## 4. Risques bloquants

Aucun risque bloquant. Risques mineurs :
- **Risque fonctionnel** : sans Patch A, un agent peut exempter à tort une décision ancienne obsolète, annulant le bénéfice du TTL sur les projets long-courrier (Versi 21+ sessions cité explicitement).
- **Risque opérationnel** : sans Patch C, risque que "Skip audit" devienne le réflexe paresseux à chaque session, neutralisant Étape 0.
- **Risque cohérence** : aucun. Les caps sont alignés partout (125/80/250 vérifiés dans CLAUDE.md cmd n°8 + Étape 5d + Étape 0 + prompt TTL).

---
**Handoff → @orchestrator**
- Fichier produit : /home/user/Agent-Team/docs/reviews/ia-prompt-ttl-audit-2026-04-17.md
- Décision : GO CONDITIONNEL, 4 patches (A, B, C, D) à appliquer dans index.html avant déploiement
- Points d'attention : Patch A (exemptions) et Patch C (mode hotfix) sont les 2 patches à vraie valeur — B et D sont cosmétiques mais recommandés. Aucun sous-agent lancé, aucune modification d'index.html effectuée.
---
