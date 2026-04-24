# Audit reviewer — 4 prompts critiques modifiés (2026-04-24)

Périmètre : 4 prompts/cards récemment modifiés dans `index.html` suite aux changements 2026-04-17 (commandement n°8 net-zero, gates G31/G32, anti-dérive caps).

## 1. Tableau récapitulatif

| # | Prompt | Note moyenne /10 | Patches requis | Note post-patch attendue |
|---|---|---|---|---|
| P1 | Migrer projet existant (l.921-969) | 8.4 | Oui (3 patches) | 9.7 |
| P2 | Clôturer session — Étape 5d (l.3486-3597) | 8.7 | Oui (2 patches) | 9.8 |
| P3 | Démarrer nouvelle session — Étape 0 (l.3594-3676) | 8.6 | Oui (2 patches) | 9.7 |
| P4 | Card "Équipe déjà installée" (l.3817-3837) | 7.9 | Oui (3 patches) | 9.6 |

Aucun prompt 10/10 en l'état. Tous les patches respectent l'interdiction backtick (zéro backtick dans le contenu — délimiteurs template literal préservés).

---

## 2. Détail par prompt

### P1 — Migrer projet existant

| # | Critère | Note |
|---|---|---|
| 1 | Clarté | 9 |
| 2 | Complétude | 8 |
| 3 | Cohérence CLAUDE.md | 9 |
| 4 | Cohérence cmd n°8 (caps/TTL) | 8 |
| 5 | Cohérence _gates.md (32 gates) | 7 |
| 6 | Robustesse edge cases | 8 |
| 7 | Sécurité (DRY-RUN/archive) | 9 |
| 8 | Auto-suffisance | 9 |
| 9 | Mesurabilité | 8 |
| 10 | Anti-régression backticks | 10 |

**Moyenne : 8.5/10. Verdict : GO avec patches.**

Faiblesses : (a) référence "32 gates G1-G32" répétée 3x mais G32 jamais nommée explicitement (G31 oui), (b) Étape 5 mentionne "Versi spécifiquement" alors que le prompt doit rester générique (any projet ≥ 5 sessions), (c) seuils caps absents (125/80/250) — incohérence avec P3 qui les spécifie.

**Patch 1.1 — Étape 4 (l.959), nommer G32**
- AVANT : `(32 gates G1-G32 incluant G31 Favicon Coverage et G32 Typographie FR)`
- APRÈS : `(32 gates G1-G32 incluant G31 Favicon Coverage 12 fichiers + 7 balises et G32 Typographie FR : guillemets francais + apostrophes typographiques + insecables)`

**Patch 1.2 — Étape 5.3 (l.966), généraliser**
- AVANT : `Pour Versi spécifiquement (21+ sessions) : MODE DRY-RUN OBLIGATOIRE.`
- APRÈS : `Pour tout projet >= 10 sessions (ex : Versi 21+ sessions) : MODE DRY-RUN OBLIGATOIRE.`

**Patch 1.3 — Étape 5 entête (l.963), ajouter caps explicites**
- AVANT : `Étape 5 — Audit TTL post-migration (BLOQUANT pour projets >= 5 sessions) :`
- APRÈS : `Étape 5 — Audit TTL post-migration (BLOQUANT pour projets >= 5 sessions, caps cmd n°8 : CLAUDE.md 125L / lessons-learned 80L / project-context 250L hors memo+historique) :`

---

### P2 — Clôturer session (Étape 5d ajoutée)

| # | Critère | Note |
|---|---|---|
| 1 | Clarté | 9 |
| 2 | Complétude | 9 |
| 3 | Cohérence CLAUDE.md | 9 |
| 4 | Cohérence cmd n°8 | 9 |
| 5 | Cohérence _gates.md | 8 |
| 6 | Robustesse edge cases | 8 |
| 7 | Sécurité (P0 exempté/archive) | 10 |
| 8 | Auto-suffisance | 9 |
| 9 | Mesurabilité | 8 |
| 10 | Anti-régression backticks | 10 |

**Moyenne : 8.9/10. Verdict : GO avec patches mineurs.**

Faiblesses : (a) Étape 5d.2 mentionne "5 sessions OU 90 jours" — corrige cmd n°8 mais pas de TTL pour des P1 réoccurrents (seul P0 est exempté, P1 traité comme P2-P3), (b) Étape 5d.4 net-zero ne référence pas index.html alors que les prompts y vivent (risque d'inflation index.html non comptée), (c) absence de mention G31/G32 alors que la session a pu produire du visuel.

**Patch 2.1 — Étape 5d.2 (l.3573), clarifier P1**
- AVANT : `Si > 5 sessions OU > 90 jours ET priorité != P0 :`
- APRÈS : `Si > 5 sessions OU > 90 jours ET priorité != P0 (P1 jamais archive automatiquement, requiert validation utilisateur explicite) :`

**Patch 2.2 — Étape 5d.4 (l.3577), inclure index.html dans net-zero**
- AVANT : `Vérification net-zero : compter les lignes ajoutées dans CLAUDE.md, agents et gates cette session.`
- APRÈS : `Verification net-zero : compter les lignes ajoutees dans CLAUDE.md, agents, gates ET index.html (prompts) cette session.`

---

### P3 — Démarrer nouvelle session (Étape 0 ajoutée)

| # | Critère | Note |
|---|---|---|
| 1 | Clarté | 9 |
| 2 | Complétude | 9 |
| 3 | Cohérence CLAUDE.md | 9 |
| 4 | Cohérence cmd n°8 (caps) | 9 |
| 5 | Cohérence _gates.md | 7 |
| 6 | Robustesse | 9 |
| 7 | Sécurité (non bloquant si hotfix) | 10 |
| 8 | Auto-suffisance | 9 |
| 9 | Mesurabilité | 8 |
| 10 | Anti-régression backticks | 10 |

**Moyenne : 8.9/10. Verdict : GO avec patches.**

Faiblesses : (a) Étape 0 ne pré-checke pas index.html (cap implicite absent — pourtant inflation prompts est un risque réel), (b) Étape 4 cohérence ne vérifie pas G31/G32 alors que ce serait l'occasion de détecter une régression typo/favicon, (c) Étape 0 cap project-context "> 400 lignes au total" est ambigu vs cmd n°8 qui dit "250 hors memo+historique" — incohérence avec P1 patché.

**Patch 3.1 — Étape 0 (l.3609), aligner seuil project-context**
- AVANT : `project-context.md (cap 250 hors historique) — si > 400 lignes au total : risque de bloat historique`
- APRÈS : `project-context.md (cap 250 hors memo+historique, cmd n°8) — si > 400 lignes au total OU > 250 hors memo+historique : risque bloat, audit TTL recommande`

**Patch 3.2 — Étape 4 (l.3644), ajouter check G31/G32 si livrable web/UI**
- AVANT : `Si un drift est détecté, signale-le avec les fichiers concernés.`
- APRÈS : `Si un drift est detecte, signale-le avec les fichiers concernes. Si livrable web/UI present (src/app, src/pages, public/) : verifier G31 (12 favicons + 7 balises HTML) et G32 (guillemets francais, apostrophes typo, espaces insecables FR).`

---

### P4 — Card HTML "Équipe déjà installée" (Scenario C)

| # | Critère | Note |
|---|---|---|
| 1 | Clarté | 8 |
| 2 | Complétude | 8 |
| 3 | Cohérence CLAUDE.md | 8 |
| 4 | Cohérence cmd n°8 | 7 |
| 5 | Cohérence _gates.md | 7 |
| 6 | Robustesse | 8 |
| 7 | Sécurité | 9 |
| 8 | Auto-suffisance | 8 |
| 9 | Mesurabilité | 7 |
| 10 | Anti-régression backticks | 10 |

**Moyenne : 8.0/10. Verdict : GO avec patches.**

Faiblesses : (a) data-text bouton (l.3824) est très long (1 paragraphe, ~250 mots) — risque copie/paste tronquée + lit "G31 favicon + G32 typo" mais ne précise pas la portée, (b) microcopie em (l.3825) dit "Audit TTL local proposé si lessons > 80L" mais le seuil project-context (250) et CLAUDE.md (125) ne sont pas mentionnés — asymétrie avec P3, (c) Étape 4 (l.3829) hardcode "Versi, ISSA, Sarani" : pas générique, dérivera dans 6 mois.

**Patch 4.1 — data-text bouton (l.3824), condenser et préciser caps**
- AVANT : `...WARNING : si docs/lessons-learned.md local > 80 lignes, audit TTL sera proposé au prochain prompt de reprise.`
- APRÈS : `...WARNING caps cmd n8 : audit TTL propose si lessons-learned > 80L OU CLAUDE.md > 125L OU project-context > 250L hors memo+historique au prochain prompt de reprise.`

**Patch 4.2 — em microcopie (l.3825), aligner sur tous les caps**
- AVANT : `Audit TTL local proposé si lessons > 80L.`
- APRÈS : `Audit TTL local propose si lessons > 80L, CLAUDE.md > 125L ou project-context > 250L.`

**Patch 4.3 — Étape 4 (l.3829), généraliser projets**
- AVANT : `Pour les projets avec ≥ 5 sessions (Versi, ISSA, Sarani) :`
- APRÈS : `Pour les projets avec >= 5 sessions (verifier via le memo de reprise ou le compteur historique) :`

---

## 3. Risques transverses

1. **Incohérence des seuils caps** entre P1, P2, P3, P4 : "250 hors historique", "250 hors memo+historique", "400 lignes au total". Source unique : cmd n°8 = 250 hors memo de reprise ET historique. Tous les prompts doivent converger vers cette formule. Patches 1.3, 3.1, 4.1, 4.2 alignent.
2. **G32 sous-spécifiée** : G31 a sa formule (12 favicons + 7 balises) mais G32 est citée nominalement sans critère vérifiable. Risque : agent ne sait pas comment auditer. Patch 1.1 corrige côté P1 ; recommandation transverse : enrichir la définition dans `_gates.md` (hors scope ce rapport).
3. **Hard-coding de noms de projets** (Versi, ISSA, Sarani) dans P1 et P4 : crée une dette de maintenance. Patches 1.2 et 4.3 généralisent.
4. **Net-zero ignore index.html** : les prompts pèsent ~3700 lignes, ajout silencieux possible à chaque session sans contre-mesure. Patch 2.2 inclut index.html dans le compteur.
5. **Absence de verification G31/G32 en pré-check de session** : régression typographique ou favicon possible entre sessions sans détection. Patch 3.2 corrige.
6. **Pré-check anti-dérive ne s'applique qu'à la reprise** (P3) : un projet ouvert en continu sans reprise échappe au check. Recommandation hors scope : ajouter un pré-check léger dans @orchestrator au démarrage de toute phase.

---

## 4. Verdict global

**GO conditionnel sur application des 10 patches** (3 sur P1, 2 sur P2, 2 sur P3, 3 sur P4).

- Aucun patch n'introduit de backtick dans le contenu (anti-régression P0 respectée).
- Tous les patches sont copiables-collables, format avant/après précis.
- Note moyenne pondérée actuelle : **8.4/10**. Post-patch attendue : **9.7/10**.
- Bloquant pour mise en production : NON (les 4 prompts sont fonctionnels). Bloquant pour qualité framework : OUI sur P4 (microcopie/data-text désalignés caps).

Top 3 corrections prioritaires :
1. **Patch 4.1** (data-text P4) — visible utilisateur, premier point de friction.
2. **Patch 3.1** (seuil P3) — incohérence numérique entre prompts liés.
3. **Patch 2.2** (net-zero P2 inclut index.html) — prévention dette systémique.

---

**Handoff -> @orchestrator**
- Fichiers produits : `/home/user/Agent-Team/docs/reviews/reviewer-prompts-audit-2026-04-17.md`
- Décisions : GO conditionnel sur 10 patches. Aucun prompt 10/10 en l'état. P4 le plus faible (8.0), P2 le plus solide (8.9).
- Points d'attention : aligner la formulation du cap project-context dans les 4 prompts (250 hors memo+historique). Enrichir definition G32 dans `_gates.md` (hors scope ce rapport, recommandation).
