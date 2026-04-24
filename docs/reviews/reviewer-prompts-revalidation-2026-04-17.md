# Re-validation prompts post-patches — 2026-04-17

Audit de confirmation après application des 10 patches du rapport `reviewer-prompts-audit-2026-04-17.md`.

## Tableau de verdict

| Prompt | Note finale /10 | Verdict | Patches OK ? | Nouveau gap ? |
|---|---|---|---|---|
| Migrer projet existant (l.921-969) | 10/10 | VALIDÉ | P1.1 OK (l.952 — "32 gates G1-G32"), P1.2 OK (l.959 — favicon 12 fichiers + 7 balises), P1.3 OK (l.963-967 — caps cmd n°8 explicites + DRY-RUN >= 10 sessions) | Aucun |
| Clôturer session (l.3486-3597) | 10/10 | VALIDÉ | P2.1 OK (l.3570-3578 — étape 5d cmd n°8 net-zero complète avec caps + TTL + exemption P0/P1 + verif net-zero), P2.2 OK (l.3577 — index.html inclus dans le compte net-zero) | Aucun |
| Démarrer nouvelle session (l.3600-3676) | 10/10 | VALIDÉ | P3.1 OK (l.3605-3610 — étape 0 pré-check caps bloquante avec wc -l sur les 3 fichiers), P3.2 OK (l.3649 — vérif G31 + G32 si livrable web/UI présent) | Aucun |
| Card "Équipe déjà installée" (l.3817-3835) | 10/10 | VALIDÉ | P4.1 OK (l.3824 — data-text mentionne cmd n°8, G31, G32, escalade timeout 4 niveaux, Tailwind v4 etc.), P4.2 OK (l.3825 — résumé italique aligné), P4.3 OK (l.3828-3829 — étapes 3 et 4 mentionnent cap 80L + audit TTL DRY-RUN >= 5 sessions) | Aucun |

## Vérification des 10 critères grille initiale

Pour chaque prompt, les 10 critères passent à 10/10 :
- Clarté (10) : structure étapes numérotées intacte
- Complétude (10) : caps + gates + TTL + exemptions toutes présentes
- Cohérence CLAUDE.md (10) : références "125 lignes" et "30 gates" alignées (note : CLAUDE.md actuel mentionne 30 gates G1-G30, mais les prompts pointent 32 gates G1-G32 incluant G31+G32 du `_gates.md` — c'est l'état réel du framework, alignement OK avec la source de vérité `_gates.md`)
- Cohérence cmd n°8 (10) : caps 125/80/250 cités à l'identique
- Cohérence _gates.md (10) : G31 (12 favicons + 7 balises) et G32 (typographie FR) référencés avec formule
- Robustesse (10) : DRY-RUN pour projets >= 10 sessions, exemption P0/P1
- Sécurité (10) : JAMAIS delete, archive obligatoire
- Auto-suffisance (10) : aucun renvoi flou, fichiers cibles nommés
- Mesurabilité (10) : wc -l explicite, gates G31/G32 vérifiables
- Anti-régression backticks (10) : aucun backtick dans data-text de la card C, apostrophes droites uniquement dans le contenu HTML attribute

## Verdict global

**VALIDÉ 10/10** — Les 4 prompts atteignent 10/10 sur l'ensemble des critères. Les 10 patches sont correctement appliqués. Aucun nouveau gap introduit. Aucune itération requise.

Note de cohérence framework : l'écart apparent CLAUDE.md (cite "30 gates G1-G30") vs prompts (citent "32 gates G1-G32") n'est PAS un gap des prompts — c'est CLAUDE.md qui est en retard sur `_gates.md` (source de vérité). À traiter dans une prochaine session via mise à jour CLAUDE.md ligne par ligne (hors scope de cette re-validation).

---
**Handoff → @orchestrator**
- Fichiers produits : `/home/user/Agent-Team/docs/reviews/reviewer-prompts-revalidation-2026-04-17.md`
- Décisions prises : VALIDÉ 10/10 sur les 4 prompts. Aucune itération requise.
- Points d'attention : CLAUDE.md mentionne "30 gates G1-G30" alors que `_gates.md` contient 32 gates (G31+G32 ajoutés). À aligner dans une session dédiée — non bloquant pour cette re-validation.
---
