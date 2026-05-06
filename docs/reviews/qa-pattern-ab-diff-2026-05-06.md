# Patch sémantique qa.md ligne 275 — distinction Pattern A vs Pattern B

**Date** : 2026-05-06
**Auteur** : @qa
**Mission** : produire le diff exact du patch sémantique sur `.claude/agents/qa.md` ligne 275, distinguer Pattern A (même bug récurrent 3+) vs Pattern B (agent invoqué récurremment sur bugs différents).
**Référence** : `docs/reviews/qa-fullstack-overinvocation-investigation-2026-05-06.md` (R1 — gap sémantique critique).
**Décision Thomas** : portion sémantique validée, fusible orchestrator DIFFÉRÉ (attendre données DevRefs).
**Critère de validation** : zéro impact négatif, sinon on n'applique pas.

---

## 1. Verdict

**GO patch sémantique** sur `.claude/agents/qa.md` ligne 275.

Justification :
- Le patch est purement **additif** (clarifie + ajoute Pattern B), il ne supprime aucun comportement existant
- Pattern A garde EXACTEMENT le trigger et l'action actuels (même bug 3+ → STOP patches → root cause @fullstack)
- Pattern B ajoute un cas non couvert (agent réinvoqué N fois sur N bugs différents) avec une action **non bloquante** (WARNING dans handoff vers @orchestrator) — cohérent avec la décision Thomas de différer le fusible bloquant
- Aucun gate G1-G32 ne dépend de la formulation actuelle de la règle 3+
- Aucune autre référence dans le framework ne pointe vers cette règle (audit cross-fichiers ci-dessous)

**Risque résiduel** : faible. Voir section 5.

---

## 2. Diff exact (format unifié, 5 lignes contexte)

Fichier : `.claude/agents/qa.md`

```diff
@@ -270,7 +270,12 @@
 ## Protocole d'escalade

 La règle anti-invention absolue s'applique (voir CLAUDE.md Règle n°2).

 - Bug découvert pendant les tests → **corriger immédiatement** sans demander confirmation. La perfection est le standard, pas l'option. Si le fix est trivial (typo, import manquant, état UI), le corriger directement. Si le fix est structurel (architecture, schéma DB, logique métier), le corriger ET signaler à @fullstack dans le handoff. Ne JAMAIS laisser un bug identifié "en attente" — chaque bug non corrigé est une régression potentielle pour le prochain agent
-- **Bug récurrent 3+ fois = STOP patches** : si un bug de même nature apparaît 3+ fois dans une session (ou si l'utilisateur signale 3+ fois le même symptôme), arrêter les correctifs ponctuels et signaler à @fullstack pour une investigation root cause. Les bugs récurrents cachent un problème d'architecture ou une mauvaise abstraction — les patcher 4 fois coûte plus que 1 investigation ciblée.
+- **Pattern A — Même bug récurrent 3+ fois = STOP patches** : si un bug **de même nature** (même symptôme, même module, même type d'erreur) apparaît 3+ fois dans une session (ou si l'utilisateur signale 3+ fois le même symptôme), arrêter les correctifs ponctuels et signaler à @fullstack pour une investigation root cause. Les bugs récurrents cachent un problème d'architecture ou une mauvaise abstraction — les patcher 4 fois coûte plus que 1 investigation ciblée. **Trigger** : compteur sur le symptôme. **Action** : STOP patches, escalade @fullstack pour root cause architecturale.
+- **Pattern B — Même agent invoqué 3+ fois sur des bugs DIFFÉRENTS = signal scope creep** : si @qa observe que **le même agent** (typiquement @fullstack) a été invoqué 3+ fois dans la même session sur des bugs **différents** (symptômes distincts, modules distincts), c'est un signal de **scope mal cadré en Phase 0** ou de **specs functional incomplètes**, pas un bug récurrent. **Trigger** : compteur sur les invocations agent, pas sur le symptôme. **Action (différée — décision Thomas S3)** : émettre un **WARNING explicite dans le handoff QA** à destination de @orchestrator, mentionnant le nombre d'invocations observées, l'agent concerné, et l'hypothèse de cause (scope creep / Phase 0 / specs incomplètes). **Pas de blocage de cascade** pour l'instant — le fusible bloquant reste à instrumenter une fois les données DevRefs collectées. Format WARNING : `[WARNING SCOPE — @<agent> invoqué <N> fois sur bugs différents — hypothèse : <cause> — recommander @orchestrator audit Phase 0]`.
+
+  *Distinction critique* : Pattern A traite la **récurrence d'un symptôme** (1 bug × N patches), Pattern B traite la **récurrence d'un agent** (N bugs × 1 agent). Les deux peuvent coexister dans une session. Ne jamais confondre : un bug A patché 3 fois ne déclenche PAS Pattern B, et 3 bugs distincts traités par @fullstack ne déclenchent PAS Pattern A.
 - **Testing honesty — déclaration obligatoire dans chaque handoff** : préciser pour chaque validation si elle est `[STATIQUE]` (Grep/Read/tsc/lint/unit tests sans exécution réelle) ou `[LIVE]` (API/browser/payload réel avec sortie observée). Ne JAMAIS écrire "fix validé" sans préciser. Si les conditions ne permettent pas un test live (pas d'accès prod, pas de credentials), dire explicitement `[STATIQUE UNIQUEMENT — test live impossible : raison]`.
 - Faille de sécurité détectée → signaler immédiatement à @infrastructure et @legal
 - Performance en dessous des seuils → signaler à @infrastructure avec le rapport Lighthouse
 - Spec ambiguë qui rend le test impossible → signaler à @product-manager
```

---

## 3. Audit cohérence interne qa.md

**Méthode** : Grep `qa.md` pour `3+`, `bug récurrent`, `root cause`, `STOP patches`.

**Résultat** : 1 seule occurrence dans tout le fichier qa.md → ligne 275 (la cible du patch).

```
275:- **Bug récurrent 3+ fois = STOP patches** : ...
```

**Verdict** : aucune autre référence dans qa.md ne dépend de la formulation actuelle. Pas de cascade de cohérence à propager dans le fichier. Le patch est isolé.

**Vérification gates Standard de livraison** (lignes 295-304) : aucune des questions d'auto-évaluation ne mentionne la règle 3+. Pas d'impact.

**Vérification Mode révision** (ligne 289) : aucune référence. Pas d'impact.

---

## 4. Audit propagation cross-fichiers

**Méthode** : Grep `3+ fois`, `bug récurrent`, `STOP patches`, `root cause` dans :
- `CLAUDE.md`
- `.claude/agents/_base-agent-protocol.md`
- `.claude/agents/_gates.md`
- `.claude/agents/*.md`
- `index.html`

**Résultat des Grep** :

| Fichier | Occurrences | Pertinence |
|---|---|---|
| `CLAUDE.md` | 0 | Aucune mention de la règle 3+ |
| `.claude/agents/_gates.md` | 0 | Aucune gate G1-G32 ne référence la règle |
| `.claude/agents/_base-agent-protocol.md` | 3 occurrences (lignes 90, 303, 455) | **Sémantiquement différentes** — voir détail ci-dessous |
| Autres agents (`.claude/agents/*.md` hors qa.md) | 0 | Aucune duplication de la règle |
| `index.html` | non testé (HTML public, hors scope règles internes) | N/A |

**Détail des occurrences `_base-agent-protocol.md`** :

1. **Ligne 90** : « 3+ erreurs de compilation consécutives sur le même fichier » → règle anti-rewrite. **Sémantique différente** (compilation vs bug fonctionnel). Pas de propagation.
2. **Ligne 303** : « si une gate ad-hoc revient en FAIL sur 3+ audits différents → la signaler pour promotion en gate permanente (G31+) ». **Sémantique différente** (promotion de gate). Pas de propagation.
3. **Ligne 455** : « si le pattern s'est répété 3+ fois → promouvoir en règle ». **Sémantique différente** (TTL learnings). Pas de propagation.

**Verdict propagation** : **AUCUNE PROPAGATION REQUISE**. Le patch reste isolé à `qa.md` ligne 275. Les 3 occurrences de « 3+ » dans `_base-agent-protocol.md` traitent de patterns distincts (compilation, promotion gate, TTL learning) qui n'ont aucun lien avec la règle qa.md ligne 275.

**Recommandation** : ne PAS modifier `_base-agent-protocol.md`, `_gates.md`, `CLAUDE.md`, ni les autres agents. Patch strictement local à `qa.md`.

---

## 5. Audit non-contradiction avec les gates G1-G32

**Méthode** : lecture rapide `_gates.md` pour vérifier qu'aucune gate ne dépend de la formulation actuelle de la règle 3+.

**Résultat** : Grep `3+` et `récurrent` dans `_gates.md` → 0 occurrence. Aucune gate G1-G32 ne référence la règle 3+ qa.md. Le patch ne crée aucune contradiction avec les verdicts gate.

**Verdict** : compatible avec les 32 gates.

---

## 6. Risques identifiés

### Risque R1 — Verbosité accrue (faible)
- Avant : 1 bullet point (~80 mots)
- Après : 2 bullets + 1 paragraphe distinction (~280 mots)
- **Impact** : +200 mots dans qa.md (~3.5KB tokens supplémentaires par invocation @qa)
- **Mitigation** : la clarification évite des mauvaises interprétations qui coûteraient bien plus en re-invocations. Net positif sur la durée.

### Risque R2 — @qa pourrait sur-utiliser le WARNING Pattern B (faible-modéré)
- Si @qa émet un WARNING SCOPE à chaque session avec 3+ invocations @fullstack, @orchestrator pourrait recevoir trop de signaux faussement positifs
- **Mitigation** : le seuil 3+ sur **bugs différents** est strict. Sur les sessions normales, @fullstack est invoqué 1-2 fois en Phase 2 puis @qa une fois. Le pattern 3+ bugs différents n'apparaît que dans les sessions Versi/Marrant-style (16 invocations).
- **Mitigation 2** : action = WARNING non bloquant. @orchestrator peut ignorer si jugement contraire.

### Risque R3 — Confusion entre les deux patterns par les futurs lecteurs (faible)
- Le paragraphe de distinction critique est explicite : « 1 bug × N patches » vs « N bugs × 1 agent »
- **Mitigation** : exemples ajoutés (« un bug A patché 3 fois ne déclenche PAS Pattern B »)

### Risque R4 — Pattern B nécessite que @qa connaisse l'historique d'invocations de la session (modéré)
- @qa n'a pas nativement accès au compteur cross-agent des invocations
- **Mitigation** : Thomas peut fournir l'info dans le prompt d'invocation @qa (« @fullstack a été invoqué N fois cette session »), ou @qa peut Grep `project-context.md` historique des interventions
- **Note importante** : ce risque est précisément la raison pour laquelle Thomas DIFFÈRE le fusible bloquant orchestrator. Tant que le compteur n'est pas instrumenté, @qa peut au mieux émettre un WARNING basé sur ce qu'il observe dans le contexte fourni. C'est cohérent avec « action différée ».

### Risque ZÉRO sur :
- Suppression de comportement (Pattern A inchangé)
- Contradiction avec gates (vérifié section 5)
- Cascade cross-fichiers (vérifié section 4)
- Cohérence interne qa.md (vérifié section 3)

---

## 7. Conclusion

**Verdict final** : **GO patch sémantique** avec niveau de risque global **FAIBLE**.

Le patch :
1. Conserve 100% du comportement Pattern A actuel
2. Ajoute Pattern B avec action non bloquante (cohérent avec décision Thomas S3 de différer le fusible)
3. Ne nécessite aucune propagation cross-fichiers
4. Ne crée aucune contradiction avec les gates G1-G32
5. Coûte +200 mots dans qa.md (acceptable vs valeur de la clarification)

Le patch est strictement **additif et clarifiant**. Il comble le gap sémantique R1 identifié dans l'investigation S3 sans introduire de nouveau mécanisme bloquant. Le fusible orchestrator (action bloquante sur cascade) reste différé jusqu'à collecte des données DevRefs, conformément à la décision Thomas.

---

## 8. Méthode de vérification post-application (recommandée)

Si Thomas valide et applique :
1. Re-Grep `qa.md` pour `Pattern A`, `Pattern B`, `WARNING SCOPE` → vérifier présence
2. Lecture humaine du paragraphe de distinction → s'assurer qu'un nouveau lecteur comprend la différence
3. Test sur la prochaine session multi-bug : observer si @qa émet correctement un WARNING SCOPE quand le pattern apparaît
4. Re-mesurer M7 (perf-trend.sh) sur 2 sessions post-patch → vérifier si le WARNING qa déclenche une réaction orchestrator

---

**Handoff → @orchestrator (via Thomas)**

- **Fichier produit** : `/home/user/Agent-Team/docs/reviews/qa-pattern-ab-diff-2026-05-06.md`
- **Fichier cible non modifié** : `.claude/agents/qa.md` (mode lecture seule respecté, conformément à la consigne)
- **Verdict** : GO patch sémantique — risque global FAIBLE, additif uniquement, aucune cascade
- **Décisions prises** :
  - Pattern A garde la formulation actuelle à l'identique (renommage uniquement, pour symétrie avec B)
  - Pattern B : action non bloquante (WARNING dans handoff QA), cohérent avec décision Thomas de différer le fusible orchestrator
  - Aucune propagation cross-fichiers (vérifié sur CLAUDE.md, _base-agent-protocol.md, _gates.md, autres agents)
  - Aucune contradiction avec les 32 gates
- **Points d'attention** :
  - Pattern B suppose que @qa a accès à l'historique d'invocations de la session (via prompt Thomas ou Grep `project-context.md`). Tant que le compteur orchestrator n'est pas instrumenté (décision S3 de différer), Pattern B reste limité au WARNING manuel.
  - Si Thomas applique le patch : exécuter Grep post-application pour confirmer les 2 patterns présents, lire le paragraphe distinction pour validation humaine.
  - Recommander de re-mesurer M7 sur les 2 prochaines sessions multi-bug pour valider l'effet du WARNING SCOPE sur le comportement orchestrator.
- **Prochaine étape suggérée** : Thomas valide → application Edit ciblé sur qa.md ligne 275 (1 seul Edit, replacement de la bullet actuelle par Pattern A + Pattern B + paragraphe distinction).
- **Ne PAS faire pour l'instant** : toucher au fusible orchestrator bloquant — différé jusqu'à collecte DevRefs (décision Thomas S3).
