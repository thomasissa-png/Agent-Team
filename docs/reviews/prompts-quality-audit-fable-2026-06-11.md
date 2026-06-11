<!-- Version: 2026-06-11 — audit qualité individuel des 94 prompts, rendu par le modèle exécutant (Fable) — complément de l'audit de conformité S5 -->
# Audit QUALITÉ des 94 prompts — jugement individuel

**Différence avec l'audit de conformité S5** : ici on ne vérifie pas que les références sont justes, on juge si chaque prompt est BON — clarté de mission, autonomie, vérifiabilité des critères, ratio signal/bruit, risque de timeout, redondance inter-prompts. Juge : le modèle qui exécute ces prompts.

**Verdict global : 7.5/10 de moyenne. La bibliothèque est le meilleur actif du framework — meilleure que les agents ne l'étaient avant la cure.** Mais elle souffre, en version atténuée, de la même maladie : sur-spécification du savoir générique, boilerplate répété, et 6 paires de doublons partiels.

---

## Barème

Chaque prompt jugé sur 5 axes : Mission claire (livrable + chemin précis) / Autonomie (fallback si fichiers absents) / Critères binaires vérifiables / Signal-bruit (spécifique au framework vs savoir LLM générique) / Faisabilité en une session.

## Notes par catégorie

| Catégorie | Note moy. | Jugement |
|---|---|---|
| Démarrage (2) | 9.5 | "Définir mon projet" est le gold standard de la bibliothèque : formulaire à trous + seuils de qualité par champ + suite recommandée. |
| Tout-en-un (3) | 8.5 | Solides post-fix S5. L'autopilot reste long (12 renforcements + 20 learnings inline) mais c'est le prix assumé de la parité qualité. |
| Phase 0 (10) | 7.5 | Très bons sur stratégie/specs/pricing. "Vision long terme et moat" est le maillon faible (notes /10 partout = résidu scoring, recoupe l'audit @elon). |
| Phase 1 (9) | 8 | Wireframes, design system, DA : excellents. "Design responsive" sur-spécifié (12 points dont 8 de savoir LLM standard). |
| Phase 2 (15) | 8 | Le cœur dur. Setup, Stripe, feature, debug : excellents avec learnings réels. "API design" et "Auth" contiennent ~40% de savoir générique (bcrypt vs MD5, conventions REST — je sais déjà). |
| Phase 3 (4) | 7.5 | SEO et contenu perpétuel très bons. **"SEO + GEO combinés" = doublon quasi pur** des 2 prompts qu'il enchaîne — sa seule valeur ajoutée est la section "Synergies". |
| Phase 4 (10) | 7 | La catégorie la plus inégale. PLG, PMF, referral, churn : tendus et excellents. **"Emails onboarding" vs "Emailing automation" : ~70% de recouvrement.** "Marketing automation" : le plus ambitieux et le plus précis de la bibliothèque (content_registry, crons idempotents, LLM-as-judge) mais 95 lignes = risque réel de timeout en exécution. |
| Phase 5 (10) | 8.5 | La meilleure catégorie. **"Crash test" est la meilleure pièce de toute la bibliothèque** (Phase 2b vérification des résultats réels, 2c challenge du workflow, 2d challenge du contenu — aucun framework public ne fait ça). "Stress test" (32 scénarios : timezone, extensions, memory leaks, version mismatch) : original et empirique. |
| Workflows avancés (14) | 6.5 | La catégorie la plus faible. **"Reporting investisseurs" (5/10) : ~60% de définitions MBA** (formules MRR/LTV/CAC que tout LLM connaît), critères mous. **"Veille concurrentielle" (6/10)** : liste d'outils générique. Refonte, perf, i18n, post-mortem : bons. |
| Sessions (3) | 9 | Machinerie de continuité complète et originale (sanity checks, gate learnings, verdict V1, net-zero). Rien d'équivalent ailleurs. |

## Top 5 / Flop 5

**Top** : 1. Audit réel crash test (10) · 2. Définir mon projet (10) · 3. Revue finale page par page (9.5) · 4. Clôture de session (9) · 5. Stress test production (9).
**Flop** : 1. Reporting investisseurs (5) · 2. Veille concurrentielle (6) · 3. SEO+GEO combinés (6 — doublon) · 4. Vision long terme/moat (6.5 — scoring résiduel + recoupe @elon) · 5. Design responsive (6.5 — savoir générique).

## Constats systémiques

1. **Boilerplate benchmark répété ~20×** : "recherche via WebSearch 2-3 exemples réels… pour les dépasser, pas juste les égaler. Documente les références" — mot pour mot dans ~20 prompts, alors que la calibration marché est déjà héritée de `_base-agent-protocol.md` par tous les agents. ~60 lignes supprimables sans perte.
2. **Sur-spécification générique dans ~15 prompts** : même maladie que les agents pré-cure (définitions de frameworks, conventions standard). Moins grave qu'un agent (coût ponctuel, pas récurrent) mais ça dilue l'attention sur les vraies instructions.
3. **6 paires de doublons partiels** : Onboarding gamifié ↔ Optimiser l'onboarding (~60%) ; Emails onboarding ↔ Emailing automation (~70%) ; SEO+GEO combinés ↔ SEO + GEO séparés (~85%) ; Choisir les modèles IA ↔ Feature IA ↔ Fine-tuning (tableau comparatif ×3) ; Performance budget ↔ Diagnostic performance (préventif/curatif, OK mais checklists jumelles) ; 4 niveaux d'audit qualité (tests complets / page par page / crash test / stress test — frontières documentées, mais le choix repose sur le sélecteur).
4. **Critères de validation : ~70% binaires, ~30% mous** ("compréhensible en < 5 secondes", "justifié par la valeur perçue" — invérifiables par Grep/test).
5. **Risque timeout sur 6-8 prompts multi-livrables** (4 fichiers + 3-4 agents chaînés) malgré les notes anti-timeout — Positionnement (4 fichiers), Audit juridique (4), Marketing automation, Refonte (4 agents).

## Recommandation — "cure prompts" légère (décision fondateur requise : change le chiffre public "94 prompts")

- **MERGE (6→3)** : Onboarding gamifié + Optimiser l'onboarding → 1 prompt à deux modes (concevoir/auditer) ; Emails onboarding + Emailing automation → 1 ; supprimer SEO+GEO combinés (remplacé par une ligne "lancez les deux" dans chacun).
- **TRIM (~10 prompts)** : retirer le boilerplate benchmark (hérité du protocole), dégraisser Reporting investisseurs / Veille concurrentielle / Design responsive / API design / Auth de leur savoir générique (-30 à -50% chacun).
- **FIX** : Vision long terme/moat — remplacer les notes /10 par des verdicts, le re-périmétrer comme complément explicite de l'audit @elon.
- **KEEP intégral** : Démarrage, Sessions, Phase 5, Tout-en-un, et tous les prompts à learnings empiriques.
- Résultat estimé : 94 → ~90 prompts, -300 à -400 lignes, zéro perte de capacité.

---
**Handoff → utilisateur (Thomas)**
- Fichiers produits : ce rapport
- Décision requise : appliquer la cure prompts (MERGE/TRIM/FIX ci-dessus) — impacte le compteur public "94 prompts" de la card et des meta tags
- Points d'attention : le script anti-drift recalcule automatiquement le compteur si la cure est appliquée

**Vérifié :**
```
grep -c 'prompt:`' index.html                      # 94 prompts jugés
grep -c "pour les dépasser, pas juste les égaler" index.html   # ~20 occurrences du boilerplate benchmark
```
