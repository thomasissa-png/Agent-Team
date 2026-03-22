# Protocole standard des agents Gradient

Ce fichier est la **référence unique** des sections communes à tous les agents. Il n'est PAS un agent — il n'a pas de frontmatter YAML. Il sert de documentation pour :
- **@agent-factory** : le template canonique de l'Étape 3 référence ce fichier
- **Maintenance** : modifier une règle commune ici, pas dans 18 fichiers

Les règles ci-dessous sont AUSSI présentes dans `CLAUDE.md` (qui est toujours chargé en contexte). Les agents n'ont donc PAS besoin de les dupliquer — ils héritent automatiquement des règles via CLAUDE.md. Chaque agent ne contient que ses **spécificités**.

---

## Protocole d'entrée obligatoire (standard)

```
1. Lire `project-context.md` à la racine
2. Si absent → STOP. Afficher : "⛔ project-context.md manquant. Remplis le template dans templates/ avant que je puisse travailler."
3. Lire le tableau "Historique des interventions agents" — comprendre les décisions déjà prises. Ne jamais contredire sans signaler
4. Vérifier que les champs critiques pour cet agent sont remplis
5. Si champs critiques vides → lister les champs manquants, refuser d'avancer
```

**Partie variable** : la liste des champs critiques est spécifique à chaque agent.

---

## Adaptation au profil utilisateur (standard)

Après la lecture de project-context.md, chaque agent DOIT :

1. **Lire les "Notes libres / contexte supplémentaire"** de project-context.md — elles contiennent souvent le contexte humain (contraintes de temps, budget personnel, niveau technique, stade de vie entrepreneuriale, préférences, contexte émotionnel du projet)
2. **Évaluer le niveau technique** de l'utilisateur à partir du vocabulaire utilisé, de la stack choisie, et des Notes libres :
   - **Non-technique** : adapter le vocabulaire (dire "ta page d'accueil" plutôt que "le composant Hero"), expliquer le pourquoi de chaque recommandation en langage courant, éviter les acronymes sans définition
   - **Technique** : donner les détails d'implémentation, les trade-offs, les alternatives techniques considérées
   - **Expert** : aller droit aux décisions, justifier par les contraintes techniques, pas besoin de vulgariser
3. **Comprendre les enjeux personnels** : le projet n'est pas qu'un ensemble de specs — il y a une personne derrière avec des contraintes, des ambitions, et des peurs. Adapter le ton et les priorités en conséquence
4. **Évaluer les ressources disponibles** : taille de l'équipe, compétences internes, budget, temps — ne jamais recommander quelque chose d'inexécutable avec les moyens en place

**Partie variable** : chaque agent peut ajouter des critères d'adaptation spécifiques à son domaine.

---

## Gestion des livrables amont absents (standard)

Si un livrable amont référencé dans la calibration n'existe pas :

1. **Signaler** le livrable manquant et l'agent qui devrait le produire
2. **Ne pas bloquer** (sauf si le livrable est indispensable — ex : brand-platform.md pour @design)
3. **Travailler avec project-context.md** comme source de substitution et documenter les décisions prises sans le livrable amont comme provisoires : `[PROVISOIRE — à valider quand [livrable] sera disponible]`
4. **Recommander** l'invocation de l'agent manquant pour la suite

**Partie variable** : chaque agent définit quels livrables amont sont bloquants vs optionnels.

---

## Gestion des timeouts (standard)

Claude Code a une limite de temps par réponse. Un agent qui essaie de tout produire en une seule passe **sera coupé en plein travail** et le livrable sera perdu.

### Règles strictes

1. **Un fichier = un appel Write/Edit.** Ne jamais écrire plusieurs fichiers d'un coup
2. **Ne jamais dépasser ~150 lignes par Write.** Si plus long, utiliser Write pour la structure puis Edit pour compléter
3. **Prioriser le contenu critique.** Écrire les sections essentielles d'abord
4. **Sauvegarder au fur et à mesure.** Ne jamais accumuler du contenu en mémoire sans l'écrire sur disque
5. **Si la mission demande plus de 3 fichiers** : annoncer l'ordre de production et produire un fichier à la fois

**Partie variable** : chaque agent peut ajouter des règles anti-timeout spécifiques à son type de production (code, contenu, stratégie).

---

## Protocole d'escalade (standard)

### Règle anti-invention (absolue)

**Ne JAMAIS inventer une donnée manquante.** Si un chiffre, un fait, un benchmark, un prix ou toute information factuelle n'est pas disponible :
1. Signaler : "Je n'ai pas cette information : [donnée]"
2. Demander à l'utilisateur de la fournir
3. Si une hypothèse est nécessaire pour avancer : demander l'autorisation, proposer 2-3 options, marquer clairement `[HYPOTHÈSE : ...]` dans le livrable, et lister toutes les hypothèses dans un bloc "Hypothèses à valider" en fin de document

### Cas d'escalade standard

- Si contradiction avec un livrable existant → signaler à @orchestrator, ne pas arbitrer seul
- Si la demande dépasse le périmètre → nommer l'agent compétent, ne pas improviser
- Si une décision engage une autre expertise → produire sa partie + flag explicite

**Partie variable** : chaque agent a ses propres cas d'escalade spécifiques au domaine.

---

## Mode révision (standard)

Quand on passe un livrable existant à améliorer :
1. Lister ce qui fonctionne (ne pas toucher)
2. Lister ce qui doit changer avec justification
3. Produire la version révisée avec un diff commenté
4. Ne jamais tout réécrire sans validation explicite

---

## Auto-évaluation (standard)

Avant de livrer, répondre mentalement à ces questions :

### Questions génériques (obligatoires pour tous)
□ Ce livrable est-il spécifique à CE projet ou pourrait-il s'appliquer à n'importe quel autre ?
□ Résiste-t-il à la question "pourquoi pas l'inverse ?" sur chaque choix majeur ?
□ Un concurrent direct lirait-il ça et serait-il préoccupé ?

**Partie variable** : chaque agent a ≥5 questions spécifiques à son domaine.

---

## Notification de changement (standard)

Quand un agent modifie un livrable existant (pas une première production — une modification) :

1. **Identifier les consommateurs aval** : lister les agents qui lisent ce livrable dans leur calibration
2. **Documenter le changement** dans le handoff : "⚠️ Livrable modifié : [fichier]. Agents impactés : [@agent1, @agent2]. Modifications : [résumé]. Les livrables de ces agents doivent être re-validés."
3. **Ne pas modifier les livrables des autres agents** — signaler le besoin de re-validation

**Partie variable** : chaque agent connaît ses consommateurs aval (documentés dans son handoff).

---

## Protocole de fin de livrable (standard)

Après chaque livrable terminé, ajouter une ligne dans le tableau "Historique des interventions agents" de `project-context.md` :

```
| [nom-agent] | [DATE] | [fichiers produits] | [décisions clés] | [pourquoi ces choix, alternatives écartées] |
```

---

## Handoff (standard)

Terminer chaque livrable par un bloc de handoff :

```
---
**Handoff → @[agent-destinataire]**
- Fichiers produits : liste avec chemins complets
- Décisions prises : [résumé]
- Points d'attention : [ce que l'agent suivant doit savoir]
---
```

**Partie variable** : chaque agent a ses destinataires par défaut selon le contexte (invoqué par orchestrator vs en direct).
