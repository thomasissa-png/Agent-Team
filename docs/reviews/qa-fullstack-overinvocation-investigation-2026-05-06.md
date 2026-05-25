# Investigation root cause — sur-invocation @fullstack (angle QA / process)

**Date** : 2026-05-06
**Auteur** : @qa
**Contexte** : S3, KPI North Star projets/semaine. Pattern signalé S2 par @moi.
**Angle** : process / qualité / triggers (parallèle @elon first principles)
**Statut** : INVESTIGATION — patches proposés, NON appliqués (validation Thomas requise)

---

## 1. Constat

- **Versi** : @fullstack invoqué **16 fois** sur le cycle V1
- **Marrant** : @fullstack invoqué **16 fois** sur le cycle V1
- Deux projets indépendants, **même chiffre exact** → signal d'un plafond structurel, pas d'une coïncidence
- Référence : `docs/reviews/time-to-v1-baseline-2026-04-24.md`

**Pourquoi c'est un problème** :
- 16 invocations × ~30 min médian = 8h de cycle @fullstack par projet
- KPI projets/semaine plafonne tant que @fullstack est goulot
- Coût tokens linéaire avec invocations (chaque invocation = re-lecture contexte)
- Signal qualité : si @fullstack revient 16 fois, soit la spec est incomplète, soit les bugs sont patchés en surface

**Pourquoi la règle « 3+ → root cause » ne s'est pas déclenchée** :
- Règle existe dans `qa.md` (learning P1 2026-04-17)
- Mais elle est **descriptive** (pour @qa quand il voit 3 bugs similaires), pas **active** au niveau orchestrateur
- Pas de compteur cross-session des invocations @fullstack
- M7 (perf-trend.sh) capture le symptôme APRÈS coup, ne stoppe rien EN cours

---

## 2. Hypothèses testées

### H1 — Phase 0 mal cadrée (Variable 1c insuffisante)
**Test** : Variable 1c (`orchestrator.md` ligne 522) ne capture que **Vitrine vs Funnel** (axe positionnement/conversion). Elle ne capture PAS :
- Nombre d'entités (Versi : 3 entités holding) → multiplie scope @fullstack par 3
- Présence d'un back-office (Sarani Studio) → double scope @fullstack
- Complexité métier (logique financière, multi-rôles, multi-tenant)

**Verdict** : **CONFIRMÉ partiel**. Variable 1c utile mais insuffisante. Manque une **Variable 1d — Complexité scope code** (1 entité simple / N entités / front+back-office / multi-tenant) qui prédirait le nombre d'invocations @fullstack attendu.

### H2 — Specs functional incomplètes
**Test** : @product-manager handoff inclut bien 9 critères Given/When/Then (qa.md ligne 264). `orchestrator.md` ligne 590 prévoit même un quick-check `@moi` : « Est-ce que @fullstack peut coder ça sans poser une seule question ? ». Le filet existe.
**Verdict** : **NON CONFIRMÉ comme cause principale**. Le filet @moi existe. Si appliqué, il filtre les specs incomplètes avant @fullstack. Ce n'est pas le gap principal.

### H3 — Bugs patchés sans root cause (cascade QA→fullstack)
**Test** : la règle « 3+ → STOP patches » existe dans `qa.md` ligne 275. Elle vise les **bugs récurrents** (un bug de même nature 3+ fois). Elle ne vise PAS les **invocations agent récurrentes** (un agent réinvoqué 16 fois pour 16 bugs différents).
**Verdict** : **CONFIRMÉ — gap sémantique majeur**. La règle 3+ traite le « même bug 3 fois » mais pas « 3 bugs différents qui révèlent un problème de scope ». Versi/Marrant : 16 bugs différents, chacun corrigé proprement, pas de répétition individuelle → la règle ne se déclenche jamais. Pourtant le pattern global (16 invocations) est bien le symptôme d'un problème root cause non investigué.

### H4 — Pas de gate « scope creep / cascade limit » sur invocations agent
**Test** : `orchestrator.md` ligne 678 a une « Limite de cascade » mais elle vise le **rollback** (« si le rollback impacte >3 livrables aval, STOP »), pas la **réinvocation** d'un même agent. Aucune règle « si agent X invoqué N fois → STOP cascade ».
**Verdict** : **CONFIRMÉ — gap framework**. Aucun garde-fou actif sur le compteur d'invocations cross-session.

### H5 — M7 passif (trigger absent en cours de session)
**Test** : `scripts/perf-trend.sh` lignes 313-323 :
- Ligne 313-316 : émet un `WARNING` quand M7 > 3 (texte console uniquement)
- Ligne 319-323 : `exit 1` UNIQUEMENT si **3 sessions consécutives** WARNING/CRITICAL
- Le script tourne en **clôture de session** (P2 Étape 5e), pas en cours de Phase 2
- Aucun hook orchestrator qui lit M7 EN COURS pour décider de la prochaine invocation

**Verdict** : **CONFIRMÉ — root cause structurelle**. M7 est un thermomètre post-mortem, pas un fusible en circuit. Sur Versi/Marrant, M7 aurait affiché « 16 fullstack — WARNING » à la fin, mais la session était déjà finie. Aucun mécanisme ne stoppe la 4e, 5e, 10e invocation @fullstack EN COURS.

---

## 3. Verdict racine

**3 causes confirmées, par ordre de criticité** :

### R1 (CRITIQUE) — Gap sémantique dans la règle « 3+ »
La règle `qa.md` ligne 275 traite « **même bug 3 fois** » (récurrence d'un symptôme identique). Elle ne traite PAS « **N invocations agent sur N bugs différents** » (récurrence d'un agent sur le projet). Versi et Marrant : 16 bugs probablement différents → la règle ne se déclenche jamais sur chaque bug pris individuellement, alors que le pattern global (16 invocations) est précisément le symptôme d'un problème root cause non investigué (scope mal cadré, specs incomplètes, ou architecture inadaptée).

**C'est la cause principale** : la règle existe mais sa formulation rate le pattern qu'on observe.

### R2 (CRITIQUE) — M7 est passif, pas actif
`scripts/perf-trend.sh` ligne 313-323 :
- M7_WARN=3, M7_CRIT=6 (lignes 29 du script)
- Versi/Marrant à **16 = 2,7× le CRITICAL**, jamais détecté en cours
- Le script tourne en clôture P2 Étape 5e, pas en cours de Phase 2
- `exit 1` UNIQUEMENT si 3 sessions consécutives WARNING — sur projet mono-session, jamais déclenché
- Aucun hook orchestrator qui consulte M7 EN COURS pour décider la prochaine invocation

**Conséquence** : M7 est un thermomètre post-mortem. Sur Versi/Marrant, M7 aurait affiché « 16 fullstack — WARNING » à la fin, mais la session était finie. Aucun mécanisme ne stoppe la 4e, 5e, 10e invocation @fullstack EN COURS.

### R3 (STRUCTURELLE) — Variable 1c insuffisante pour prédire le scope code
Variable 1c (`orchestrator.md` ligne 522) capture Vitrine/Funnel (positionnement). Elle ne capture PAS :
- Nombre d'entités (Versi : 3 entités holding)
- Présence d'un back-office (Sarani Studio)
- Multi-tenant / multi-rôles
- Logique métier complexe (financière, calculs)

Ces dimensions multiplient le scope code par 2-3× sans alerter. **Effet** : le plan de Phase 0 sous-estime systématiquement le travail @fullstack → cascade de re-invocations en Phase 2.

### Pourquoi 16 EXACT sur 2 projets ?
Hypothèse forte (à valider dans les logs) : **16 = limite implicite du contexte orchestrator** avant que le KPI North Star ou Thomas force la clôture. Ce n'est pas un plafond technique, c'est un plafond de patience humaine/orchestrateur. Au-delà de 16, le coût perçu dépasse la valeur perçue → la session est close en l'état (V1 non atteinte sur 0/6 projets selon `time-to-v1-baseline-2026-04-24.md`).

Le chiffre 16 lui-même est moins important que ce qu'il révèle : **le framework n'a aucun mécanisme pour détecter ET arrêter la cascade avant le plafond de patience**.

---

## 4. Gap framework identifié

**G-OVER1 — Aucune règle de plafond actif sur invocations agent en cours de session**
- `orchestrator.md` ligne 678 a une « Limite de cascade » mais elle vise le rollback (>3 livrables aval), pas la réinvocation d'un agent
- Aucun compteur consulté avant chaque Task d'invocation
- Aucun seuil défini pour STOP cascade (ex : « si @fullstack invoqué 4 fois → pause obligatoire, audit root cause »)

**G-OVER2 — La règle 3+ de qa.md est mal périmétrée**
- Formulation actuelle : « bug récurrent 3+ fois → root cause »
- Formulation manquante : « invocations agent récurrentes 3+ → root cause »
- Le pattern Versi/Marrant ne déclenche pas la règle car les 16 bugs sont différents

**G-OVER3 — M7 sans hook actif**
- M7 est calculé en clôture, jamais consulté en ouverture/milieu de session
- Pas d'instruction `orchestrator.md` du type « avant chaque invocation @fullstack, vérifier le compteur de la session courante »

**G-OVER4 — Variable 1c monodimensionnelle**
- Capture positionnement (Vitrine/Funnel)
- Manque : complexité scope code (entités, back-office, multi-tenant)
- Conséquence : prédiction scope @fullstack absente du plan

---

## 5. Correctif proposé

**Stratégie** : transformer M7 d'alerte passive en **fusible actif** + élargir la règle 3+ pour couvrir le pattern d'invocations.

Patch en **2 fichiers seulement** (contrainte respectée).

### Patch 1 — `.claude/agents/orchestrator.md` (fusible actif sur invocations)

**Insérer une nouvelle section après la ligne 678 (« Limite de cascade »)** :

```markdown
### Limite d'invocations par agent (fusible cascade)

**Compteur en cours de session** : avant chaque invocation d'un agent producteur (@fullstack, @copywriter, @design, @ia, @ux), compter le nombre d'invocations déjà effectuées de ce même agent dans la session courante (lecture du tableau historique de `project-context.md` filtré sur la date du jour).

**Seuils bloquants** :
- **Invocation 4** (`>= M7_WARN+1`) : émettre un warning console mais continuer.
- **Invocation 5** : **STOP cascade**. Avant de lancer la 5e invocation, ouvrir une investigation root cause obligatoire :
  1. Lister les motifs des 4 précédentes invocations (extraire des handoffs)
  2. Identifier si elles convergent vers une cause unique (spec incomplète, architecture inadaptée, scope mal cadré)
  3. Si oui → corriger la cause (re-invoquer @product-manager pour spec, ou @ia pour architecture) AVANT de relancer l'agent
  4. Si non → consigner le verdict « N invocations légitimes : [raisons] » dans `project-context.md` et autoriser la 5e invocation
- **Invocation 7** (`> M7_CRIT`) : **STOP dur**. Escalader à l'utilisateur : « @[agent] a été invoqué 6 fois sans convergence root cause. Je recommande : (A) clôturer la session et redécouper le scope V1 ; (B) reprendre Phase 0 avec Variable 1d (complexité scope). Ton choix ? »

**Pourquoi ces seuils** : alignés sur M7_WARN=3 et M7_CRIT=6 (`scripts/perf-trend.sh` ligne 29). Cohérence avec le thermomètre existant, mais activé EN COURS.

**Référence** : voir `docs/reviews/qa-fullstack-overinvocation-investigation-2026-05-06.md` pour le pattern Versi/Marrant (16x) qui a motivé cette règle.
```

### Patch 2 — `.claude/agents/qa.md` (élargir la règle 3+)

**Remplacer la ligne 275 actuelle** :

```markdown
- **Bug récurrent 3+ fois = STOP patches** : si un bug de même nature apparaît 3+ fois dans une session (ou si l'utilisateur signale 3+ fois le même symptôme), arrêter les correctifs ponctuels et signaler à @fullstack pour une investigation root cause. Les bugs récurrents cachent un problème d'architecture ou une mauvaise abstraction — les patcher 4 fois coûte plus que 1 investigation ciblée.
```

**Par** :

```markdown
- **Pattern récurrent 3+ fois = STOP patches** : la règle « 3+ → root cause » s'applique à DEUX patterns distincts :
  - **Pattern A — bug récurrent** : un bug de même nature (même symptôme, même module) apparaît 3+ fois dans une session ou est signalé 3+ fois par l'utilisateur. Cause typique : mauvaise abstraction ou architecture inadaptée.
  - **Pattern B — agent récurrent** : @qa déclenche 3+ invocations de @fullstack dans la même session pour des bugs différents mais liés (même feature, même pipeline, même couche). Cause typique : spec incomplète, scope mal cadré, contrat d'API flou. Si @qa observe ce pattern, signaler à @orchestrator pour déclencher l'investigation root cause AVANT la 4e invocation @fullstack (voir `orchestrator.md` section « Limite d'invocations par agent »).
  - **Dans les deux cas** : 4 patches coûtent plus qu'une investigation ciblée. Pas de patch n°4 sans verdict root cause documenté.
```

### Patch optionnel 3 — `scripts/perf-trend.sh` (déjà OK, pas besoin)

Le script lui-même n'a pas besoin de modification. Il continue à mesurer M7 en clôture (utile pour le tracking longitudinal). Le fusible actif est dans `orchestrator.md`. **Le seul changement utile possible** : ajouter une référence cross-fichier dans le warning ligne 316 :

```bash
echo "WARNING: agent ${M7_AGENT} invoque ${M7} fois - signal scope mal cadre, reality check Phase 0/1 recommande. Voir orchestrator.md section 'Limite d'invocations par agent'."
```

### Pourquoi PAS de Variable 1d immédiatement

Tentant d'ajouter une Variable 1d « complexité scope code ». **Mais** :
- Modifier la Phase 0 sans données = risque overengineering
- Le fusible actif (Patch 1) résout le symptôme observé (cascade incontrôlée)
- Si après 3 sessions S3 le fusible se déclenche systématiquement à l'invocation 4-5 → preuve qu'on a besoin de Variable 1d. Décision data-driven, pas spéculative.

**Recommandation** : déployer Patch 1+2, mesurer 3 prochaines sessions, décider Variable 1d sur évidence.

---

## 6. Test de non-régression

**Objectif** : vérifier sur la prochaine session S3 que le fusible se déclenche.

### Test T1 — Déclenchement du fusible à l'invocation 5
**Setup** : prochain projet client lancé en S3 (recommandé : MarchesFaciles ou Marrant V1.1).
**Procédure** :
1. Compter les invocations @fullstack au fur et à mesure dans `project-context.md` historique
2. Avant la 5e invocation @fullstack, vérifier que @orchestrator :
   - Liste les 4 motifs précédents (extrait des handoffs)
   - Produit un verdict « cause convergente : [oui/non] »
   - Si oui : remonte la cause à @product-manager ou @ia AVANT de re-lancer @fullstack
   - Si non : consigne le verdict dans `project-context.md`

**Critère PASS** : la 5e invocation @fullstack n'a lieu qu'APRÈS un verdict root cause documenté.
**Critère FAIL** : la 5e invocation @fullstack a lieu sans verdict → patch non appliqué ou ignoré.

### Test T2 — Déclenchement du STOP dur à l'invocation 7
**Setup** : si un projet atteint @fullstack invocation 7 (M7_CRIT dépassé).
**Procédure** : @orchestrator doit escalader à l'utilisateur avec les 2 options (clôture/redécoupage OU retour Phase 0 + Variable 1d).
**Critère PASS** : escalade explicite avec choix utilisateur, pas d'invocation 7 silencieuse.
**Critère FAIL** : invocation 7+ silencieuse → patch contourné.

### Test T3 — Élargissement de la règle 3+ côté @qa
**Procédure** : sur les 3 prochaines sessions S3, vérifier que @qa documente dans son handoff le compteur d'invocations @fullstack qu'il a déclenchées + le pattern observé (Pattern A bug récurrent vs Pattern B agent récurrent).

**Critère PASS** : @qa signale Pattern B avant la 4e invocation @fullstack si elle est due à ses tests.
**Critère FAIL** : @qa continue de signaler bugs au cas-par-cas sans observation du pattern global.

### Test T4 — Mesure d'impact M7 sur 3 sessions
**Procédure** : exécuter `scripts/perf-trend.sh` à la clôture des 3 prochaines sessions S3.
**Critère PASS** : M7 max passe de 16 (baseline Versi/Marrant) à ≤ 6 (sous M7_CRIT) sur projets de scope équivalent.
**Critère FAIL** : M7 reste > 6 → le fusible n'a pas son effet, soit il n'est pas appliqué, soit la racine est ailleurs (Variable 1c insuffisante → activer Patch 3 / Variable 1d).

### Critère global d'acceptation
**3 sessions S3 consécutives avec M7 ≤ 6** = patch validé, on peut clore l'investigation.
**Si M7 > 6 sur 1+ session** = root cause partielle, escalader à @orchestrator + @elon pour second tour (probablement Variable 1d et/ou découpage scope V1 plus agressif).

---

## 7. Handoff

**Note testing honesty** : l'ensemble des verdicts de cette investigation sont `[STATIQUE]` — basés sur lecture de `qa.md`, `orchestrator.md`, `fullstack.md`, `scripts/perf-trend.sh`, `time-to-v1-baseline-2026-04-24.md`. Aucun test live possible (les sessions Versi/Marrant sont closes, le fusible proposé n'est pas encore déployé). La validation `[LIVE]` se fera sur les 3 prochaines sessions S3 via les Tests T1-T4 ci-dessus.

**Note périmètre** : cause racine R1 et R2 sont 100% process/qualité/triggers (périmètre @qa). Cause racine R3 (Variable 1c) déborde sur le périmètre @orchestrator (Phase 0). Le patch proposé reste dans le périmètre @qa+@orchestrator. Si l'investigation @elon (first principles, en parallèle) identifie une cause d'architecture ou de fond (ex : @fullstack mal scopé en tant qu'agent), arbitrage entre les deux investigations à faire par Thomas.

---
**Handoff → @orchestrator (validation Thomas requise avant application)**

- Fichier produit : `/home/user/Agent-Team/docs/reviews/qa-fullstack-overinvocation-investigation-2026-05-06.md`
- Décisions prises (lecture seule, NON appliquées) :
  - Cause racine R1 (gap sémantique règle 3+) + R2 (M7 passif) confirmées
  - R3 (Variable 1c) confirmée mais traitement différé (data-driven, post-3 sessions)
  - 2 patches proposés (orchestrator.md + qa.md), 1 patch optionnel (perf-trend.sh)
- Points d'attention :
  - **Validation Thomas obligatoire avant application** des patches (lecture seule cette mission)
  - **Coordination avec @elon** : investigation parallèle first principles en cours, attendre les deux verdicts avant patch
  - **Dépendance forte** : si patches appliqués, instrumenter le compteur d'invocations dans `project-context.md` pour que @orchestrator puisse le lire en milieu de session (pas juste en clôture). Sinon le fusible n'a aucune base de comptage actif. → Tâche dérivée pour @infrastructure : exposer un script `scripts/count-invocations.sh @fullstack` consultable par @orchestrator
  - **Risque overfitting** : 16x exact peut être coïncidence. Vérifier sur le 7e projet (post-S2) si le pattern persiste à un autre seuil (ex : 10x, 12x). Si oui = vraie limite structurelle ; si non = Versi/Marrant cas particuliers
  - **Si Thomas valide les patches** : prochain agent recommandé = @reviewer pour audit cohérence des modifications proposées avant application, puis application par @orchestrator
- Statut : INVESTIGATION TERMINÉE — patches en attente de validation
---
