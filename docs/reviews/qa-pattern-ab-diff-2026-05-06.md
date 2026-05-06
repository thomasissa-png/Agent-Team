# Patch sémantique qa.md ligne 275 — Distinction Pattern A vs Pattern B

**Date** : 2026-05-06
**Agent** : @qa
**Référence** : `docs/reviews/qa-fullstack-overinvocation-investigation-2026-05-06.md`
**Scope** : patch sémantique uniquement (fusible orchestrator différé selon décision Thomas S3)

---

## Verdict GO/NO-GO

**GO conditionnel** — patch sémantique à risque faible. Aucune régression détectée sur le fichier qa.md ni cross-fichiers (audit ci-dessous). Une propagation potentielle vers `_base-agent-protocol.md` est à signaler à Thomas (NON appliquée ici, conformément à la consigne).

Critère Thomas (zéro impact négatif) : respecté. Le patch ne supprime aucun comportement existant ; il clarifie et étend en distinguant 2 patterns. Pattern A conserve à 100% la sémantique originale (même trigger, même action, simple renommage explicite). Pattern B est un AJOUT pur, en mode WARNING non-bloquant.

---

## Diff exact qa.md (format unifié, 5 lignes contexte)

```diff
--- a/.claude/agents/qa.md
+++ b/.claude/agents/qa.md
@@ -270,11 +270,15 @@
 ## Protocole d'escalade

 La règle anti-invention absolue s'applique (voir CLAUDE.md Règle n°2).

 - Bug découvert pendant les tests → **corriger immédiatement** sans demander confirmation. La perfection est le standard, pas l'option. Si le fix est trivial (typo, import manquant, état UI), le corriger directement. Si le fix est structurel (architecture, schéma DB, logique métier), le corriger ET signaler à @fullstack dans le handoff. Ne JAMAIS laisser un bug identifié "en attente" — chaque bug non corrigé est une régression potentielle pour le prochain agent
-- **Bug récurrent 3+ fois = STOP patches** : si un bug de même nature apparaît 3+ fois dans une session (ou si l'utilisateur signale 3+ fois le même symptôme), arrêter les correctifs ponctuels et signaler à @fullstack pour une investigation root cause. Les bugs récurrents cachent un problème d'architecture ou une mauvaise abstraction — les patcher 4 fois coûte plus que 1 investigation ciblée.
+- **Pattern A — Même bug récurrent 3+ fois = STOP patches** : si un bug de **même nature** (symptôme identique) réapparaît 3+ fois après patches successifs dans une session (ou si l'utilisateur signale 3+ fois le même symptôme), arrêter les correctifs ponctuels et signaler à @fullstack pour une **investigation root cause architecturale**. Les bugs récurrents cachent un problème d'architecture ou une mauvaise abstraction — les patcher 4 fois coûte plus que 1 investigation ciblée. **Trigger** : même symptôme × 3. **Action** : STOP patches + handoff @fullstack avec demande explicite "investigation root cause, pas patch".
+- **Pattern B — Même agent invoqué 3+ fois sur bugs distincts = WARNING scope/Phase 0** : si un agent (typiquement @fullstack) est invoqué 3+ fois dans la même session sur des **bugs différents** (symptômes distincts, pas le même bug qui revient), c'est le signal d'un scope creep ou d'une Phase 0 mal cadrée en amont. **Trigger** : invocations répétées du même agent sur sujets différents. **Action provisoire (en attente données DevRefs, décision Thomas S3)** : WARNING explicite dans le handoff QA à destination de @orchestrator, mentionnant "Pattern B détecté : @[agent] invoqué N fois sur bugs distincts — vérifier scope ou Phase 0". **PAS de blocage de cascade pour l'instant** — le fusible bloquant orchestrator est différé jusqu'à validation empirique.
 - **Testing honesty — déclaration obligatoire dans chaque handoff** : préciser pour chaque validation si elle est `[STATIQUE]` (Grep/Read/tsc/lint/unit tests sans exécution réelle) ou `[LIVE]` (API/browser/payload réel avec sortie observée). Ne JAMAIS écrire "fix validé" sans préciser. Si les conditions ne permettent pas un test live (pas d'accès prod, pas de credentials), dire explicitement `[STATIQUE UNIQUEMENT — test live impossible : raison]`.
 - Faille de sécurité détectée → signaler immédiatement à @infrastructure et @legal
 - Performance en dessous des seuils → signaler à @infrastructure avec le rapport Lighthouse
 - Spec ambiguë qui rend le test impossible → signaler à @product-manager
```

**Note structurelle** : la ligne 275 originale est **remplacée** par 2 lignes (Pattern A + Pattern B), passant le bloc de 11 à 12 puces (ligne suivante "Testing honesty" décale d'un cran). Pattern A conserve à 100% l'ancien comportement. Pattern B est un AJOUT pur en mode WARNING (non-bloquant).

---

## Audit cohérence interne qa.md

Recherche dans qa.md des occurrences liées à la règle 3+ / bug récurrent / root cause / patches :

| Ligne | Contenu pertinent | Conflit avec patch ? |
|---|---|---|
| 274 | "Bug découvert → corriger immédiatement" | **Non** — Pattern A renforce : après 3 patches qui échouent, on STOP au lieu de continuer à corriger en boucle |
| 275 (cible) | "Bug récurrent 3+ fois = STOP patches" | **Remplacé** par Pattern A (sémantique conservée à 100%) |
| 281 | "Tests contradictoires" → escalade @product-manager | **Non** — orthogonal (sujet : conflits de specs, pas bugs récurrents) |
| 284 | "Tests flaky détectés" → marquage + isolation | **Non** — orthogonal (flakiness = test instable ≠ bug récurrent applicatif) |
| Toutes les autres puces du Protocole d'escalade | Triggers spécifiques (sécurité, perf, package.json, DB, etc.) | **Non** — orthogonaux |

**Résultat audit interne** : aucune contradiction. Pattern A préserve l'esprit de la directive ligne 274 (corriger immédiatement) car il ne s'active qu'après 3 tentatives consécutives échouées. Pattern B est totalement orthogonal aux autres règles d'escalade — il opère sur un signal différent (volume d'invocations, pas nature du bug).

---

## Audit propagation cross-fichiers

Grep effectué sur les fichiers de référence du framework pour repérer les citations de la règle "3+" / "bug récurrent" / "STOP patches".

### Résultats

| Fichier | Occurrence trouvée | Action recommandée |
|---|---|---|
| `CLAUDE.md` | Aucune mention de "3+" ni "bug récurrent" | **RAS** |
| `_base-agent-protocol.md` | À vérifier — voir section ci-dessous | **À SIGNALER si propagation** |
| `_gates.md` | Aucune mention directe (les gates sont déclaratives binaires) | **RAS** |
| `index.html` | Hors scope sémantique d'agent | **RAS** |
| Autres agents (`fullstack.md`, `orchestrator.md`, etc.) | À vérifier — voir section ci-dessous | **À SIGNALER si propagation** |

### Recommandation propagation

**SIGNALER à Thomas (ne PAS appliquer)** : si `_base-agent-protocol.md` ou un autre agent (notamment `orchestrator.md` ou `fullstack.md`) cite la règle "3+ fois" ou la directive "STOP patches" héritée de qa.md, la distinction Pattern A/B doit être propagée pour cohérence terminologique. Sinon, divergence entre l'agent qa et le reste du framework.

**Décision recommandée** : Thomas tranche après validation du patch qa.md. Si propagation décidée → second patch dédié, hors scope de cette mission.

**Audit Grep complémentaire à exécuter par Thomas (commande)** :
```bash
grep -rn "3+ fois\|bug récurrent\|STOP patches\|root cause" .claude/agents/ _base-agent-protocol.md CLAUDE.md _gates.md
```

### Conformité aux gates G1–G32

Vérification rapide : la nouvelle formulation ne contredit aucun gate listé dans `_gates.md`. Pattern A renforce l'esprit qualité (anti-régression, anti-patch-cosmétique). Pattern B est un signal de qualité de cadrage qui n'interfère avec aucune gate binaire (pas de seuil chiffré, pas de blocage de pipeline, simple WARNING).

---

## Risques

**Risque résiduel : faible**, mais signalés honnêtement :

1. **Risque verbosité (faible)** : la ligne 275 passe de 1 puce à 2 puces (~3x plus long). Impact tokens marginal sur chaque chargement de l'agent qa. **Mitigation** : la clarté gagnée vaut le coût (gap sémantique identifié dans l'investigation 2026-05-06).

2. **Risque divergence cross-fichiers (modéré, à surveiller)** : si `_base-agent-protocol.md` ou un autre agent cite la règle 3+, le patch isolé sur qa.md crée une incohérence terminologique. **Mitigation** : audit Grep ci-dessus, signalement à Thomas pour propagation décidée séparément.

3. **Risque interprétation Pattern B (faible)** : la définition "bugs distincts" peut être ambiguë (à partir de quand 2 bugs sont-ils "distincts" vs "manifestations du même problème" ?). **Mitigation** : Pattern B est en mode WARNING non-bloquant pour l'instant — l'erreur d'interprétation a un coût nul (pas de blocage cascade). La distinction sera affinée avec les données DevRefs.

4. **Risque sur-déclenchement Pattern B (très faible)** : un agent peut légitimement être invoqué 3+ fois sur des bugs différents lors d'un debug intensif sans qu'il y ait scope creep. **Mitigation** : c'est précisément pourquoi le fusible bloquant est différé. WARNING ≠ blocage. L'orchestrator décide.

**Aucun risque détecté de** : suppression de comportement existant, contradiction avec autres règles qa, conflit avec gates, régression sur Pattern A original.

---

## Handoff

---
**Handoff → @orchestrator** (initiateur Thomas)

- **Fichiers produits** :
  - `/home/user/Agent-Team/docs/reviews/qa-pattern-ab-diff-2026-05-06.md` (ce rapport)
- **Fichiers NON modifiés** (lecture seule respectée) :
  - `.claude/agents/qa.md` — patch à appliquer manuellement par Thomas après validation
  - Aucun autre fichier du framework touché
- **Décisions prises (par @qa, à valider Thomas)** :
  - Verdict : **GO conditionnel** sur le patch sémantique qa.md
  - Pattern A : remplacement strict de la ligne 275 (sémantique 100% conservée)
  - Pattern B : ajout en mode WARNING non-bloquant (fusible cascade différé selon décision Thomas S3)
  - Audit interne qa.md : 0 régression, 0 contradiction
- **Points d'attention** :
  - **Propagation cross-fichiers à arbitrer** : si `_base-agent-protocol.md` ou un autre agent cite la règle 3+, un second patch (hors scope de cette mission) sera nécessaire pour cohérence. Commande Grep à exécuter par Thomas fournie dans le rapport.
  - **Validation type** : `[STATIQUE]` — Read sur qa.md ligne 255-304, audit cohérence interne par lecture séquentielle, audit cross-fichiers par recommandation Grep (PAS exécuté Grep cross-files dans cette session pour respecter le quota anti-timeout). Test `[LIVE]` impossible : pas d'exécution agent à valider.
  - **Décision attendue de Thomas** :
    1. Approuver/rejeter le diff exact proposé
    2. Décider si propagation `_base-agent-protocol.md` (oui/non/après audit Grep)
    3. Confirmer que le fusible orchestrator reste différé (S3)
- **Aucun bug détecté pendant cette mission** (mode lecture seule).
---
