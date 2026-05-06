# Cause racine @fullstack 16x — Avis Elon (first principles)

**Date** : 2026-05-06 | **Auteur** : @elon | **Mode** : Challenge / first principles
**Contexte** : Pattern signalé en clôture S2 — @fullstack invoqué 16 fois sur Versi (13 jours) ET 16 fois sur Marrant (51 jours) indépendamment. @qa investigue en parallèle l'angle process/triggers. Mon angle : est-ce qu'on s'attaque au bon problème ?

> AVIS CONSULTATIF — Pas une directive. Thomas et @orchestrator décident.

---

## 1. Reformulation du problème (first principles)

### Définir « invocation @fullstack »
Une invocation = un round-trip Task au sens framework (entrée dans le tableau "Historique des interventions agents"). Ce n'est PAS un commit, ni un message intra-agent. C'est un appel orchestrateur → agent. Une invocation peut produire 1 fichier ou 30, 1 feature ou 0 (correction d'un bug). **L'unité est trompeuse.**

### Le vrai dénominateur
On compare 16 invocations à QUOI ? Trois métriques candidates :
- (a) **Features livrées** : si 16 invocations = 16 features, c'est sain.
- (b) **Bugs corrigés** : si 16 invocations = 16 fois le même bug, c'est broken.
- (c) **Écrans codés** : si 16 invocations = 30 écrans, c'est hyper-productif. Si 16 = 4 écrans, c'est du sur-place.

**On n'a pas ce dénominateur dans le tableau.** Le pattern "16x" est un signal sans signal de référence. C'est comme regarder le compteur kilométrique sans regarder la quantité d'essence brûlée.

### Reformulation du KPI
KPI North Star Gradient = **projets/semaine pour Thomas (dev indie solo)**. Ce qui compte n'est pas "minimiser le nombre d'invocations @fullstack". Ce qui compte est : **temps total de session humaine de Thomas pour atteindre V1 production**. Une invocation @fullstack autonome (Thomas est aux toilettes) coûte 0 minute Thomas. Une invocation @fullstack avec aller-retour humain coûte 30 minutes.

**Le bon KPI n'est pas le compteur d'invocations, c'est la friction humaine par feature livrée.**

---

## 2. Verdict

### Combinaison D + E (dominante D), avec C en facteur aggravant. A et B écartés.

- **D — Mindset humain résiduel : 70% du problème.** "V1 complète en une cascade" est une hypothèse implicite calquée sur le mode équipe humaine (sprint = livraison). Avec une équipe IA, **la cascade n'est pas un événement, c'est un processus continu**. 16 invocations sur 51 jours = ~1 par 3 jours = working as intended pour un projet long-courrier en mode itératif IA.
- **E — Faux signal partiel : 20% du problème.** Le compteur d'invocations brut sans dénominateur (features/bugs/écrans) est un mauvais proxy. Sur Marrant 51 jours, 16 passes c'est probablement sain. Sur Versi 13 jours, c'est plus suspect mais pas encore un diagnostic.
- **C — Cascade design/UX qui ne livre pas assez tôt : 10% du facteur aggravant.** Quand @design/@ux finalisent en Phase 2 alors que @fullstack a déjà codé en Phase 1 sur des wireframes provisoires, @fullstack revient. C'est un vrai problème mais c'est un problème d'ordre d'orchestration, pas de granularité d'agent.

### Pourquoi pas A (process/triggers de @qa)
L'hypothèse @qa "il manque un trigger reality check" présume que 16 invocations est un bug. Si le pattern n'est pas un bug, ajouter un trigger ne fait que rajouter de la friction sans réduire le vrai gap (temps Thomas par feature livrée). **Patcher orchestrator + qa.md sans avoir confirmé que 16 = pathologique = ajouter un process pour traiter un symptôme imaginaire.** L'algorithme SpaceX étape 1 : remettre en question l'exigence avant de la fixer. Ici l'exigence "réduire le nombre d'invocations" n'a pas été questionnée.

### Pourquoi pas B (split @fullstack en 2 agents)
Tentation classique de management humain : "ça déborde, on coupe en deux". Faux en IA. Le coût de coordination entre frontend-only et backend-only sur Next.js (server actions, API routes co-localisées avec les pages) est supérieur au coût de garder un agent unifié. Tesla a constamment **fusionné** des équipes (battery + powertrain + thermal) plutôt que les séparer, parce que les abstractions modernes croisent les couches. Splitter @fullstack créerait un handoff supplémentaire = +1 round-trip = +friction Thomas. **Mauvaise direction.**

### Pourquoi pas E pur
On ne peut pas juste dire "tout va bien". Il y a un signal réel sur Versi (16 en 13 jours = 1.2/jour, c'est dense). Mais le signal n'est pas "trop d'invocations", c'est "scope Phase 0 mal cadré" déjà identifié dans le baseline doc (G3 + A2 — Vitrine vs Funnel). Le compteur d'invocations capture la **conséquence** d'un Phase 0 incomplet, pas la cause.

---

## 3. Recommandation stratégique

### Verdict GO/NO-GO investigation profonde
**NO-GO sur l'investigation "réduire le nombre d'invocations @fullstack".** C'est traiter un thermomètre comme une fièvre.

**GO sur deux investigations différentes** :
1. **Calibrer M7 sur le bon dénominateur.** Avant de seuiller "3 invocations", mesurer **invocations @fullstack par feature livrée par projet**. Si Versi a 16 invocations pour 30 features, c'est sain. Si 16 pour 4 features, c'est cassé. Aujourd'hui, M7 alerte sur du bruit.
2. **Resserrer Phase 0 (déjà identifié, A2 du baseline doc).** Le vrai upstream est là. Vitrine vs Funnel + scope V1 cadré = -50% des passes correctives @fullstack en aval.

### Le piège à éviter
**Ne pas patcher orchestrator.md ni qa.md** pour ajouter un trigger "reality check si @fullstack > N invocations". Ça va frustrer l'orchestrateur sur des projets longue durée comme Marrant qui n'ont pas de problème réel. Mindset humain = sprint borné = compteur. Mindset IA = flux continu = on regarde le throughput pas le compteur.

---

## 4. Implication framework (1 changement, pas 10)

**Un seul changement structurel recommandé** : remplacer le compteur brut "N invocations agent" par un ratio dans `scripts/perf-trend.sh` (M7 actuelle).

```
M7_corrigée = invocations_agent / (features_livrées_par_projet)
seuil WARNING = ratio > p75 historique (à calibrer sur 6 projets baseline)
```

Cela demande :
- Une métrique "features livrées" exposée dans project-context.md (peut être : nb d'écrans live, nb de user stories cochées, nb de gates G validés).
- Une révision du seuil M7 actuel ">3" déjà signalé comme arbitraire dans la liste DEFER S2 point 7.

**Pas de changement de mindset à imposer aux agents** : ce qui change c'est le tableau de bord du framework, pas le comportement des agents. Si M7 n'alerte plus à tort, l'orchestrateur n'introduit pas de friction artificielle.

### Implication pour @qa (investigation parallèle)
Si @qa propose un trigger reality check, le scope **doit** être : "vérifier scope Phase 0 si on observe N invocations @fullstack SANS livrable feature associé". Pas "si @fullstack > N invocations". La nuance est tout.

---

## 5. Risque de fausse alerte (scénario E)

Si je me trompe et que verdict E (faux signal) est dominant à 100% :
- Coût de l'inaction = zéro. On garde le framework actuel, M7 reste bruyant mais inoffensif tant que personne n'agit dessus.
- Coût d'un patch process = élevé. Chaque trigger ajouté = friction permanente sur tous les projets futurs, y compris ceux qui n'ont pas le problème.

**Asymmetric risk en faveur de l'attente.** Mieux vaut mesurer 1 ou 2 projets de plus avec le ratio corrigé avant de bouger une ligne d'orchestration.

DevRefs (lancement imminent) est le bon test contrôlé. Si DevRefs atteint V1 avec @fullstack > 10 invocations ET features livrées proportionnelles, le pattern Versi/Marrant est confirmé comme working as intended. Si @fullstack tourne en rond sur les mêmes bugs, alors l'hypothèse A de @qa devient pertinente.

---

## 6. Pre-mortem 12 mois

**Scénario d'échec si on patche maintenant** : Thomas ajoute un trigger M7 dans orchestrator.md. Sur les 5 projets suivants, l'orchestrateur fait des reality checks systématiques qui interrompent @fullstack en plein flow. Time-to-V1 augmente de 20%. Thomas finit par désactiver le trigger ou ignorer les alertes. Coût : +200 lignes de protocole pour un net négatif.

**Scénario d'échec si on ne fait rien** : Versi/Marrant restent les seuls 2 projets avec ce pattern. Aucun autre projet ne le reproduit. M7 alerte de temps en temps mais Thomas l'ignore correctement. Coût : zéro. Le bruit M7 finit par être désactivé naturellement à la prochaine session de cleanup.

Le second scénario est strictement préférable.

---

## 7. Hypothèses à valider

- [HYPOTHÈSE A] : Marrant 16 invocations / 51 jours = working as intended (1 passe / 3 jours sur projet long-courrier). À confirmer en lisant les entrées historique Marrant : sont-elles des features distinctes ou des corrections du même bug ?
- [HYPOTHÈSE B] : Versi 16 invocations / 13 jours = symptôme de Phase 0 mal cadré (3 entités), pas de @fullstack défaillant. À confirmer en croisant avec le scope Phase 0 Versi documenté.
- [HYPOTHÈSE C] : Le ratio invocations/features sur Sarani (s6-s18, 18+ sessions) est probablement plus élevé que Versi/Marrant — si vrai, ça confirme que le compteur brut est un mauvais signal.

---

## 8. Ce que je ne tranche pas (frontière agents)

- L'implémentation concrète du ratio M7 corrigé dans `scripts/perf-trend.sh` → @infrastructure.
- Le format d'exposition "features livrées" dans project-context.md → @product-manager + @orchestrator.
- Le protocole de reality check (si Thomas décide d'en ajouter un malgré tout) → @qa (déjà en cours).

---

**Handoff → @orchestrator**
- Fichier produit : `/home/user/Agent-Team/docs/reviews/elon-fullstack-overinvocation-rootcause-2026-05-06.md`
- Verdict : NO-GO sur "réduire les invocations @fullstack". Le pattern 16x est probablement working as intended (D+E) avec un facteur aggravant Phase 0 (C, déjà couvert par A2 du baseline doc).
- Recommandation unique : remplacer M7 compteur brut par ratio invocations/features livrées. Ne PAS ajouter de trigger reality check générique sur le compteur brut.
- À coordonner avec investigation @qa : si @qa propose un trigger, le conditionner sur l'absence de features livrées, pas sur le compteur seul.
- Hypothèses à valider avant tout patch : voir section 7. Idéalement, attendre les données DevRefs avant tout changement d'orchestration.
- Rappel : ces recommandations sont des AVIS. Thomas décide. Si Thomas préfère patcher préventivement, c'est son call — mon avis est que c'est prématuré.
---
