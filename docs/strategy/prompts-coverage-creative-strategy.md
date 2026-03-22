# Analyse de couverture — Bibliothèque de 39 prompts
## Angle : stratégie de marque, positionnement, conception créative

**Date** : 2026-03-22
**Analyste** : @creative-strategy
**Source** : `index.html` — constante PROMPTS, 39 prompts, 7 catégories, phases 0 à 5
**Audits existants lus** : `docs/reviews/elon-prompts-audit.md` (6.5/10, angle power user multi-projets) + `docs/reviews/prompts-audit-orchestrator.md` (39/39 exécutables, angle coordination agents)

**Ce que ces audits ne couvrent pas** : ils ont vérifié que les prompts s'exécutent bien. Ils n'ont pas vérifié que la séquence produit une marque solide. Ce sont deux questions différentes. Un prompt peut être parfaitement exécutable et produire un livrable stratégiquement creux. C'est ce que j'analyse ici.

---

## Résumé exécutif

La bibliothèque couvre correctement l'identité de marque en surface (plateforme, personas, brand voice). Elle couvre bien la production (copy, design, code). Elle ne couvre pas l'espace intermédiaire — les décisions de marque qui transforment une identité en outil de vente : proposition de valeur structurée, messaging par canal, naming, territoire verbal, storytelling de fondation. Un projet lancé avec ces 39 prompts aura une marque cohérente. Il n'aura pas forcément une marque puissante.

**Score couverture stratégie de marque : 5.5/10**

---

## 1. Ce qui est bien couvert

### 1.1 La plateforme de marque de base (prompt #5)

Le prompt "Positionnement & plateforme de marque" est solide. Il demande : benchmark concurrentiel via WebSearch, positionnement (territoire, promesse, preuve, ton), personas avec jobs-to-be-done et objections, brief créatif. C'est le minimum viable d'une stratégie de marque. Il est correctement placé en Phase 0, avant tout le reste.

Point positif notable : le benchmark concurrentiel est intégré dans le même prompt, pas dissocié. C'est juste — le positionnement ne se construit pas dans le vide, il se construit contre un paysage concurrentiel identifié.

### 1.2 Les personas (intégrés au prompt #5)

Les personas sont produits en même temps que la brand platform. La demande de "jobs-to-be-done et objections" est pertinente — c'est la différence entre un persona décoratif et un persona utile pour la conversion.

### 1.3 La brand voice (prompt #12)

Le prompt demande : ton, registre, vocabulaire autorisé/interdit, exemples par contexte. Il inclut l'UX writing. C'est un bon périmètre. La dépendance sur brand-platform.md est explicite.

### 1.4 L'articulation brand ↔ copy (prompts #12 → #13)

La chaîne brand-voice → landing page est en place. Le copywriter lit la brand voice avant de rédiger. C'est cohérent.

### 1.5 Le pivot de marque (prompt #4 "Pivoter")

Le pivot repositionne en partant de @creative-strategy et met à jour brand-platform.md. La notification des agents aval (copywriter, design, ux) n'est pas explicite dans le prompt mais le protocole de révision agent-side le prévoit. Acceptable.

---

## 2. Ce qui manque — avec impact sur le succès

### 2.1 La proposition de valeur structurée

**Absence : critique**

La "promesse unique" dans project-context.md est un champ texte libre. La brand platform produit par le prompt #5 construit un positionnement (territoire, promesse, preuve, ton). Mais il manque une étape : la **proposition de valeur structurée** — la formulation qui répond précisément à "pourquoi vous, pourquoi maintenant, pourquoi pas le concurrent".

La différence entre une promesse de marque et une proposition de valeur :
- Promesse de marque : "Nous rendons l'analytics accessible aux PME"
- Proposition de valeur : "Les PME qui utilisent [Produit] réduisent leur temps de reporting de 4h à 20min — sans avoir besoin d'un data analyst"

La première inspire. La seconde convainc. La bibliothèque produit la première. Elle ne produit pas la seconde de façon structurée. La proposition de valeur est le document qui atterrit sur la landing page, dans les pitchs, dans les cold emails — c'est la couche entre la marque et la vente.

Aucun des 39 prompts ne demande explicitement de produire ce document, avec sa structure (problème → solution → preuve → résultat → pour qui → pourquoi maintenant).

### 2.2 La messaging matrix

**Absence : majeure**

La brand voice guide le ton. Mais elle ne dit pas *quoi* dire à chaque persona, sur chaque canal, à chaque étape du funnel. La **messaging matrix** est la grille qui croise : persona × canal × étape funnel × message clé.

Sans elle, le copywriter écrit une landing page générale. Avec elle, il écrit des messages calibrés sur le décideur (pas l'utilisateur), au moment où il évalue (pas où il découvre), sur LinkedIn (pas sur la landing).

Le prompt #22 (acquisition complète) inclut des "copies par canal" mais c'est une production tardive, en Phase 4. La messaging matrix devrait exister en Phase 0-1, avant que le copywriter rédige quoi que ce soit. Actuellement, elle n'est produite par personne.

### 2.3 Le naming

**Absence : modérée (dépend du stade)**

Pour les projets en phase Idée, le naming est une décision fondatrice. Aucun prompt ne couvre le naming : processus de génération, critères d'évaluation (mémorabilité, disponibilité domaine/marque, connotations culturelles, prononçabilité internationale), shortlist, validation.

L'agent @creative-strategy a cette compétence. Elle n'est pas exposée dans la bibliothèque. Résultat : les fondateurs choisissent un nom avant de lancer les agents, et personne ne le remet en question même si ce nom est problématique.

### 2.4 Le territoire verbal et l'identité verbale

**Absence : majeure**

La brand voice couvre le *comment parler* (ton, registre). Elle ne couvre pas le *quoi dire* de façon systématique : les formulations propriétaires, le lexique de marque, les métaphores fondatrices, les phrases signature, les claims.

L'**identité verbale** — l'équivalent verbal du design system — est absente. Le design system existe (prompt #11) et produit des tokens réutilisables. L'identité verbale n'a pas d'équivalent.

Conséquence concrète : le copywriter produit des textes cohérents en ton, mais pas forcément distincts en vocabulaire. Il n'y a pas de territoire sémantique propriétaire qui rende la marque reconnaissable même sans son logo.

### 2.5 Le storytelling de fondation

**Absence : modérée**

Le manifeste de marque est mentionné dans la brand platform, mais il n'existe pas de prompt dédié à construire le **storytelling de fondation** : l'histoire d'origine (pourquoi ce projet existe, quel problème personnel a motivé le fondateur), la tension narrative (ce que le marché fait mal / ce que la marque refuse de faire comme les autres), la vision à 10 ans.

Ce storytelling est ce qui permet aux early adopters de s'identifier, aux journalistes d'écrire sur le projet, aux investisseurs de comprendre la vision. Il alimente le contenu social, la page "About", les pitchs. Il n'est produit par aucun prompt.

### 2.6 La segmentation et la priorisation des personas

**Absence : modérée**

Le prompt #5 produit des "personas détaillés". Mais pour les projets multi-persona (B2B avec décideur + utilisateur final, ou marketplace avec deux côtés), il manque un prompt de **priorisation explicite** : qui est le persona primaire pour le positionnement ? Qui est secondaire ? Quand les messages divergent entre eux, qui prime ?

Le protocole agent-side de @creative-strategy prévoit ce cas ("Si multi-persona... identifier le persona principal"). Mais ce n'est pas exposé dans la bibliothèque — un utilisateur ne sait pas que cette question existe ni comment la poser.

### 2.7 La validation du positionnement

**Absence : mineure mais significative**

Le processus actuel est : brief projet → benchmark → positionnement. Il n'y a pas de prompt de **validation du positionnement** avant de l'industrialiser. Questions que ce prompt devrait couvrir : est-ce que la promesse est différenciante ? Est-ce qu'elle est crédible ? Est-ce qu'elle est pertinente pour le persona ? Est-ce qu'elle est défendable dans 3 ans ?

Aujourd'hui, le positionnement est produit et immédiatement consommé par les agents aval. Il n'y a pas de checkpoint critique avant que le copywriter s'en empare.

---

## 3. Ordre des prompts — analyse du parcours stratégique

### 3.1 Ce qui est juste dans l'ordre actuel

- Prompt #5 (positionnement) avant #12 (brand voice) : correct
- Brand voice avant landing page (#13) : correct
- Stratégie avant conception UX (#10) : correct
- Brand platform avant design system (#11) : correct

L'ordre de dépendance est globalement respecté.

### 3.2 Ce qui pose problème dans le séquencement

**Problème 1 : le gap Phase 0 → Phase 1**

Entre la brand platform (fin Phase 0) et les wireframes + brand voice (Phase 1), il n'y a rien. Ce gap devrait contenir : proposition de valeur structurée, messaging matrix, validation du positionnement. Ces documents seraient les inputs de Phase 1. Sans eux, le copywriter part de la brand voice sans savoir *quoi* dire, et l'UX designer part des personas sans savoir *quel message* chaque écran doit porter.

**Problème 2 : la landing page avant la messaging matrix**

Le prompt #13 (landing page) est en Phase 1. Il se base sur brand-voice et personas. Mais une landing page efficace n'est pas construite sur le ton et les personas — elle est construite sur la proposition de valeur et les messages clés par segment. Cette dépendance manquante explique pourquoi on peut produire une landing page "correcte en forme mais faible en fond".

**Problème 3 : le brief créatif arrive trop tôt**

Le prompt #5 produit le brief créatif en même temps que la brand platform, avant même que les wireframes et la brand voice soient produits. Un brief créatif qui guide le design et le copy devrait être finalisé *après* avoir validé le positionnement et construit la messaging matrix — pas simultanément.

---

## 4. Moments critiques non couverts

Récapitulatif des moments stratégiques qui n'ont pas de prompt correspondant :

| Moment stratégique | Impact sur le succès | Couvert ? |
|---|---|---|
| Structurer la proposition de valeur (problème → solution → preuve → résultat) | Critique — c'est le moteur de la conversion | Non |
| Construire la messaging matrix (persona × canal × funnel) | Majeur — évite les messages génériques | Non |
| Nommer le projet (si stade Idée) | Modéré — fondateur décide seul sans cadre | Non |
| Construire l'identité verbale (lexique propriétaire, claims, phrases signature) | Majeur — différenciation verbale durable | Non |
| Rédiger le storytelling de fondation (histoire d'origine, tension narrative, vision) | Modéré — nourrit contenu, PR, pitch | Non |
| Valider le positionnement avant industrialisation | Modéré — checkpoint avant de tout construire dessus | Non |
| Prioriser les personas quand il y en a plusieurs | Modéré — évite les messages qui essaient de plaire à tous | Non (implicite dans #5) |

---

## 5. Prompts recommandés à ajouter

### Prompt A — Proposition de valeur

**Titre** : Structurer la proposition de valeur
**Phase** : Phase 0 (après le positionnement, avant la conception)
**Agents** : @creative-strategy
**Quand** : Après brand-platform.md — avant de rédiger quoi que ce soit
**Description** : Traduit le positionnement en proposition de valeur opérationnelle. Structure : problème documenté (douleur quantifiée du persona), solution différenciante (mécanisme unique), preuve (ce qui rend crédible), résultat (ce que le persona obtient concrètement), pour qui (critères de qualification), pourquoi maintenant (urgence ou opportunité). Livrable : `docs/strategy/value-proposition.md`

**Pourquoi c'est le manque le plus critique** : la proposition de valeur est le document pivot entre la stratégie et la vente. Tous les autres agents s'en servent — le copywriter pour la landing, le growth pour les canaux, le social pour les accroches. Sans elle, chaque agent réinterprète le positionnement à sa façon.

---

### Prompt B — Messaging matrix

**Titre** : Construire la messaging matrix
**Phase** : Phase 0-1 (après la proposition de valeur)
**Agents** : @creative-strategy, @copywriter
**Quand** : Après value-proposition.md et personas.md, avant la landing page et les wireframes
**Description** : Grille qui croise persona × canal × étape funnel × message clé × objection à lever. Pour chaque combinaison : le message principal, les preuves associées, le vocabulaire à utiliser, ce qu'il ne faut pas dire. Livrable : `docs/strategy/messaging-matrix.md`

**Pourquoi maintenant et pas en Phase 4** : la messaging matrix devrait précéder le copy et le design, pas les suivre. Elle est l'input du copywriter, pas son output.

---

### Prompt C — Identité verbale

**Titre** : Définir l'identité verbale
**Phase** : Phase 1 (après brand voice, avant landing page)
**Agents** : @creative-strategy, @copywriter
**Quand** : Après brand-voice.md — quand le ton est défini mais avant de produire tout le contenu
**Description** : Construit le territoire verbal propriétaire de la marque : lexique de marque (les mots que la marque s'approprie et qui lui sont associés dans l'esprit du persona), formulations bannies (ce que la marque refuse de dire car tous les concurrents le disent), phrases signature (1-2 formulations mémorables qui cristallisent la promesse), métaphores fondatrices (l'image mentale que la marque veut créer). Livrable : `docs/strategy/verbal-identity.md` + enrichissement de `docs/copy/brand-voice.md`

---

### Prompt D — Storytelling de fondation

**Titre** : Écrire le storytelling de fondation
**Phase** : Phase 0-1
**Agents** : @creative-strategy, @copywriter
**Quand** : Après brand-platform.md — utilisable pour la page About, les pitchs, le contenu social
**Description** : Construit la narration fondatrice du projet : histoire d'origine (pourquoi ce problème, pourquoi maintenant, pourquoi cette équipe), tension narrative (ce que le marché fait de façon inacceptable / la rupture que la marque incarne), vision à 3-5 ans (où va la marque, quel monde elle veut construire), manifeste (déclaration d'intention qui fait fuir les mauvais clients et attire les bons). Livrable : `docs/strategy/brand-story.md`

---

### Prompt E — Naming (optionnel, stade Idée/MVP)

**Titre** : Trouver et valider le nom
**Phase** : Phase 0 (avant toute production)
**Agents** : @creative-strategy, @legal
**Quand** : Stade Idée ou MVP uniquement — si le nom n'est pas encore fixé
**Description** : Génère 10-15 options de noms selon les critères de la marque (territoire, ton, persona). Évalue chaque option sur : mémorabilité, disponibilité domaine .com/.fr, disponibilité marque INPI, connotations culturelles, prononçabilité internationale, pertinence avec le positionnement. Produit une shortlist de 3 avec recommandation. @legal valide la disponibilité des marques. Livrable : `docs/strategy/naming.md`

---

## 6. Recommandation sur le séquencement

Si les prompts A et B ci-dessus sont ajoutés, le séquencement Phase 0 → Phase 1 devrait être :

```
Phase 0 :
  1. project-context.md (prompt #1 existant)
  2. Positionnement & brand platform (prompt #5 existant)
  3. [NOUVEAU] Proposition de valeur (prompt A)
  4. [NOUVEAU] Messaging matrix (prompt B)
  5. Vision produit & roadmap (#6 existant) — peut se faire en parallèle de A et B
  6. KPIs & tracking (#7 existant)

Phase 1 :
  7. Brand voice (#12 existant) — enrichie par la messaging matrix
  8. [NOUVEAU] Identité verbale (prompt C) — après brand voice
  9. Parcours UX (#10 existant) — les messages de chaque écran sont maintenant définis
  10. Landing page (#13 existant) — le copywriter a maintenant une messaging matrix
```

Ce réordonnancement n'invalide aucun prompt existant. Il comble le gap entre la stratégie et la conception.

---

## 7. Ce que je ne recommande pas de changer

Les audits @elon et @orchestrator ont traité l'ordre des prompts existants, les redondances, et la qualité d'exécution. Je ne reviens pas dessus. Mon analyse porte sur les manques conceptuels, pas sur la mécanique.

Je ne recommande pas non plus d'alourdir le prompt #5 avec tout ce qui manque. La séparation entre brand platform (identité) et proposition de valeur (outil de vente) est saine — ce sont deux exercices différents qui requièrent deux types de pensée différents.

---

## 8. Auto-évaluation — checklist livrable

□ Le positionnement occupe-t-il un espace libre identifié dans le benchmark ? — Non applicable (audit d'un framework, pas d'un projet client)
□ Chaque persona a-t-il des objections documentées ? — Non applicable
□ Le brief créatif contient-il les éléments requis ? — Non applicable
□ La promesse de marque est-elle différenciante ET crédible ? — Non applicable
□ Le benchmark identifie-t-il ce que TOUS les concurrents font ? — Oui (les audits précédents ont été lus et référencés — aucune contradiction introduite)

Questions spécifiques à cette mission :
□ Les manques sont-ils documentés avec leur impact sur le succès ? Oui
□ Les prompts recommandés ont-ils un titre, des agents, une phase et une description ? Oui
□ L'analyse évite-t-elle de dupliquer ce que @elon et @orchestrator ont déjà couvert ? Oui
□ Les recommandations sont-elles tranchées (pas de "peut-être", "envisager") ? Oui

---

**Handoff → utilisateur** (intervention directe, pas via orchestrator)

Fichiers produits :
- `/home/user/Agent-Team/docs/strategy/prompts-coverage-creative-strategy.md`

Décisions prises / constats :
- Score couverture stratégie de marque : 5.5/10
- Manque critique identifié : proposition de valeur structurée (aucun des 39 prompts ne la produit)
- Manque majeur : messaging matrix (produite en Phase 4 au lieu de Phase 0)
- Manque majeur : identité verbale (la brand voice couvre le ton, pas le territoire sémantique)
- Séquencement Phase 0→Phase 1 : gap documenté avec solution proposée

Points d'attention pour la suite :
- Si un prompt A (proposition de valeur) est ajouté, tous les prompts Phase 1 qui lisent brand-platform.md devraient aussi lire value-proposition.md (#10 UX, #12 brand voice, #13 landing page)
- Le prompt #5 (brand platform) est solide — ne pas le réécrire, lui ajouter un livrable aval
- Si le naming (prompt E) est ajouté, le placer impérativement avant toute production (@legal doit valider la disponibilité avant qu'on construise une identité sur un nom potentiellement problématique)
