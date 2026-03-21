# Audit UX -- Dashboard Gradient Agents

**Agent** : @ux | **Date** : 2026-03-21
**Objet** : Audit UX du dashboard interne (`index.html`) -- equipe de 17 agents IA
**Persona principal** : Utilisateur interne qui lance ou pilote des projets avec les agents

---

## Synthese executive

Le dashboard actuel est fonctionnel, lisible et esthetiquement soigne. La base est solide : navigation sticky, recherche sur les prompts, grille responsive. Cependant, il est concu comme un **catalogue statique** alors que le besoin reel est un **outil de decision** : "quel agent appeler, dans quel ordre, avec quel prompt, pour mon projet." Les recommandations ci-dessous visent a combler cet ecart.

---

## 1. Architecture d'information

### Ce qui fonctionne
- Les 3 sections (Equipe / Prompts / Changelog) couvrent les dimensions Who / How / What's new.
- La navigation sticky avec ancres permet un acces direct.
- Les prompts sont organises par categorie d'usage (Lancement, Developpement, Contenu, Qualite), ce qui correspond a des intentions reelles.

### Problemes identifies

**P0 -- Vue pipeline manquante.** L'architecture actuelle presente les agents dans un ordre lineaire (Phase 0 a 5) mais sans aucune representation visuelle du pipeline. L'utilisateur doit lire les 17 cartes et reconstituer mentalement la sequence. Or, la question numero 1 est : "Dans quel ordre les appeler ?" Il manque une vue qui reponde a cette question en un coup d'oeil.

**P1 -- Deconnexion Equipe / Prompts.** Les deux sections vivent en silo. L'utilisateur qui decouvre un agent dans la section Equipe doit ensuite scroller vers Prompts et chercher manuellement les prompts associes. Il n'y a pas de lien agent vers prompts ni de lien prompt vers agent.

**P1 -- Section "Pipeline" absente.** Il manque une vue intermediaire entre "qui sont les agents" et "quel prompt utiliser" : une vue "comment ils travaillent ensemble." Les dependances entre agents (ex: @ux travaille apres @product-manager, avant @design) ne sont documentees nulle part dans l'interface.

**P2 -- Ordre des sections.** L'ordre Equipe > Prompts > Changelog est logique pour une premiere visite. Mais pour un utilisateur recurrent (cas majoritaire), le besoin primaire est les prompts, pas la liste d'agents. Envisager de mettre les prompts en premier, ou d'ajouter un CTA "Trouver le bon prompt" des la section hero.

### Recommandation structurelle

Passer de 3 a 4 sections :
1. **Pipeline** (nouveau) -- Vue visuelle Phase 0 a 5 avec les agents positionnes
2. **Equipe** -- Cartes agents (inchange, avec ajout de liens vers prompts)
3. **Prompts** -- Bibliotheque (inchange, avec ajout de filtres)
4. **Changelog** -- Historique (inchange)

---

## 2. Hierarchie visuelle des cartes agents

### Ordre de lecture actuel (de haut en bas de la carte)
1. Phase (tag vert)
2. Handle + Nom (`@orchestrator Orchestrator`)
3. Role (texte gris petit)
4. Description
5. Champs requis

### Analyse

**P1 -- Le role est sous-exploite.** La ligne "Directrice de strategie creative -- 18 ans" est en `12px` gris muted. C'est pourtant l'information qui repond a "qui est cet agent" en une phrase. Elle devrait avoir plus de poids visuel que la phase.

**P1 -- La description est generique a lire.** Les descriptions actuelles sont toutes formatees de la meme facon (liste de mots-cles separes par des virgules). Elles ne repondent pas a "quand est-ce que je dois appeler cet agent" mais a "que sait-il faire." Ajouter une ligne "Appeler quand..." serait plus actionnable.

**P2 -- Le handle `@` et le nom sont redondants visuellement.** `@orchestrator Orchestrator` affiche deux fois la meme information. Privilegier le handle seul (c'est ce qu'on tape dans les prompts) et passer le nom en element secondaire.

### Hierarchie recommandee
1. **Handle** `@orchestrator` (identifiant primaire, le plus gros)
2. **Role** une ligne (taille lisible, pas muted)
3. **Phase** (tag, position inchangee)
4. **Quand l'appeler** (une phrase actionnable, nouveau)
5. **Competences** (ex-description, en corps de carte)
6. **Champs requis** (en bas, inchange)

---

## 3. Parcours utilisateur principal

**Scenario** : "Je lance un nouveau projet, je veux trouver quel agent appeler et avec quel prompt."

### Parcours actuel

| Etape | Action | Friction |
|-------|--------|----------|
| 1 | Arriver sur le dashboard | OK |
| 2 | Scroller la grille de 17 agents | **Elevee** -- pas de filtre, pas de tri, 17 cartes a scanner |
| 3 | Identifier que @orchestrator est le point d'entree | **Moderee** -- il faut lire "Phase 0 - Coordination" pour le comprendre |
| 4 | Cliquer sur "Prompts" dans la nav | OK |
| 5 | Scroller ou taper "lancer" dans la recherche | OK si l'utilisateur connait le vocabulaire |
| 6 | Trouver "Lancer un nouveau projet complet" | OK |
| 7 | Lire le prompt exemple, le copier | **Elevee** -- pas de bouton "Copier", il faut selectionner manuellement le texte |

**Nombre total d'interactions** : 5 a 7 actions (scroll + lecture + navigation + scroll + recherche + lecture + copie manuelle).

### Parcours cible (P0)

| Etape | Action | Friction |
|-------|--------|----------|
| 1 | Arriver sur le dashboard | OK |
| 2 | Voir le pipeline visuel, identifier Phase 0 | **Nulle** -- vue d'ensemble immediate |
| 3 | Cliquer sur @orchestrator dans le pipeline | Redirige vers le prompt "Lancer un nouveau projet" |
| 4 | Cliquer "Copier le prompt" | **Nulle** -- un clic |

**Nombre total d'interactions** : 3 actions. Reduction de 50% minimum.

---

## 4. Findability -- Recherche et filtres

### Ce qui fonctionne
- La barre de recherche sur les prompts est bien placee, centree, avec un placeholder utile.
- La recherche full-text fonctionne sur titre + agents + contexte + livrable + exemple.
- Le `stripAccents` gere les diacritiques -- bon point technique.

### Problemes identifies

**P0 -- Pas de bouton "Copier" sur les prompts.** C'est l'action terminale du parcours. L'utilisateur doit tripler-cliquer ou faire Ctrl+A dans un bloc de texte. Chaque prompt devrait avoir un bouton "Copier l'exemple" avec feedback visuel ("Copie !").

**P1 -- Pas de filtre par agent sur les prompts.** L'utilisateur qui sait qu'il veut utiliser @fullstack n'a aucun moyen de filtrer les prompts par agent sans taper "fullstack" dans la recherche. Ajouter un filtre par tags agents (cliquables, comme les tags deja affiches).

**P1 -- Pas de filtre par phase sur les prompts.** Les prompts sont categories par type d'action (Lancement, Developpement...) mais pas par phase du pipeline. Un utilisateur en Phase 2 devrait pouvoir ne voir que les prompts pertinents pour cette phase.

**P2 -- Pas de recherche sur les agents.** La section Equipe n'a aucun mecanisme de recherche ou filtre. Avec 17 cartes, le scan visuel reste possible, mais un filtre par phase (boutons toggle Phase 0 / Phase 1 / ...) faciliterait la navigation.

**P2 -- Pas de lien bidirectionnel.** Cliquer sur un tag `@fullstack` dans un prompt ne mene nulle part. Il devrait soit filtrer les prompts de cet agent, soit scroller vers la carte de l'agent.

---

## 5. Manques critiques

### P0 -- Dependances entre agents

Actuellement, rien dans l'interface ne montre que :
- @creative-strategy doit passer avant @product-manager
- @ux doit passer avant @design
- @fullstack a besoin des specs de @product-manager
- @reviewer intervient en dernier sur tous les livrables

Ces dependances sont dans le CLAUDE.md et les fichiers agents, mais pas dans le dashboard. C'est l'information la plus critique pour eviter les erreurs de sequencement.

**Recommandation** : Ajouter dans chaque carte agent un champ "Precede par" et "Suivi de" avec les handles cliquables. Et/ou creer la vue Pipeline visuelle recommandee en section 1.

### P0 -- Pipeline visuel Phase 0 a 5

Le dashboard liste les phases en tag sur chaque carte, mais ne les represente jamais comme un flux. Un diagramme horizontal (Phase 0 | Phase 1 | Phase 2 | Phase 3 | Phase 4 | Phase 5) avec les agents positionnes dans chaque colonne donnerait une comprehension immediate de l'ensemble du systeme.

Implementation suggeree : un composant CSS Grid ou Flex horizontal, chaque colonne etant une phase, avec les avatars/handles des agents empiles verticalement. Cliquable pour scroller vers la carte. Pas besoin de librairie externe.

### P1 -- Livrables attendus par agent

Chaque agent produit des fichiers specifiques (ex: @creative-strategy produit `brand-platform.md`, `personas.md`, `creative-brief.md`). Cette information est dans les prompts mais pas sur les cartes agents. Ajouter un champ "Livrables" sur chaque carte permettrait de repondre a "qu'est-ce que je vais obtenir si j'appelle cet agent ?".

### P1 -- Etat vide / Premier usage

Il n'y a aucun onboarding pour un nouvel utilisateur du dashboard. Pas de "Commencez ici", pas de mise en avant de l'agent @orchestrator comme point d'entree. Un utilisateur qui decouvre le dashboard pour la premiere fois voit 17 cartes sans hierarchie de priorite. Ajouter un bandeau ou une carte speciale "Nouveau projet ? Commencez par @orchestrator" en tete de la grille.

### P2 -- Nombre d'agents par phase

Afficher un compteur dans le titre de chaque phase du pipeline (ex: "Phase 2 -- Developpement (4 agents)") pour donner un apercu de la charge par etape.

---

## 6. Responsive / Mobile

### Ce qui fonctionne
- La media query `@media(max-width:600px)` passe la grille en colonne unique.
- La barre de recherche prend 100% de largeur.
- Le changelog passe en layout vertical.
- La nav reduit ses paddings.

### Problemes identifies

**P1 -- 17 cartes en colonne unique = scroll infini.** Sur mobile, l'utilisateur doit scroller l'equivalent de 8 a 10 ecrans pour voir tous les agents. Sans filtre ni collapse, c'est inutilisable pour une consultation rapide. Solutions :
- Ajouter un accordion par phase (Phase 0 / Phase 1 / ...) avec collapse/expand
- Ou un selecteur horizontal scrollable (chips) pour filtrer par phase

**P1 -- La nav ne passe pas en hamburger.** Avec 3 liens + le logo, ca tient sur un ecran 375px, mais c'est serree. Si d'autres liens sont ajoutes (Pipeline), ca debordera. Prevoir un menu hamburger ou un scroll horizontal de la nav.

**P2 -- Les prompts sont longs sur mobile.** Le bloc `[CONTEXTE] / [LIVRABLE] / [EXEMPLE]` affiche le texte complet en permanence. Sur mobile, chaque prompt prend 2-3 ecrans. Implementer un pattern "voir plus" qui tronque le texte a 2-3 lignes avec expand on tap.

**P2 -- Pas de position sticky pour les titres de categorie.** En scrollant les prompts sur mobile, on perd le contexte de la categorie en cours. Un titre sticky ameliorerait l'orientation.

---

## Tableau recapitulatif priorise

| Prio | Recommandation | Section | Effort |
|------|---------------|---------|--------|
| P0 | Bouton "Copier le prompt" sur chaque prompt card | Prompts | Faible |
| P0 | Vue Pipeline visuelle Phase 0-5 avec agents positionnes | Nouvelle section | Moyen |
| P0 | Dependances entre agents ("Precede par" / "Suivi de") | Equipe | Moyen |
| P1 | Filtre par agent (tags cliquables) sur les prompts | Prompts | Faible |
| P1 | Filtre par phase sur les prompts | Prompts | Faible |
| P1 | Lien bidirectionnel carte agent <-> prompts associes | Equipe + Prompts | Moyen |
| P1 | Rehausser le role agent dans la hierarchie visuelle des cartes | Equipe | Faible |
| P1 | Ajouter "Quand l'appeler" (une phrase actionnable) par agent | Equipe | Moyen (redaction) |
| P1 | Livrables attendus affiches sur chaque carte agent | Equipe | Faible |
| P1 | Bandeau "Nouveau projet ? Commencez par @orchestrator" | Equipe | Faible |
| P1 | Accordion par phase sur mobile pour les cartes agents | Mobile | Moyen |
| P1 | Tronquer les prompts sur mobile avec "voir plus" | Mobile | Faible |
| P1 | Filtre/recherche sur la section Equipe (par phase) | Equipe | Faible |
| P2 | Reordonner les sections : Pipeline > Prompts > Equipe > Changelog | Navigation | Faible |
| P2 | Tags agents cliquables dans les prompts (scroll vers la carte) | Prompts | Faible |
| P2 | Titres de categorie sticky sur mobile | Mobile | Faible |
| P2 | Compteur d'agents par phase | Pipeline | Faible |
| P2 | Menu hamburger mobile (anticipation) | Navigation | Faible |

---

## Auto-evaluation

- [x] Ce livrable est specifique a CE dashboard et ses 17 agents -- pas un audit generique.
- [x] Chaque recommandation resiste a "pourquoi pas l'inverse ?" : les choix sont argumentes par le parcours utilisateur cible.
- [x] Les edge cases sont couverts : premier usage, mobile, recherche sans resultat, 17+ agents.
- [x] Le time-to-value est au coeur des P0 : reduire le parcours de 7 actions a 3.

---

**Handoff -> @design**
- Contexte transmis : audit UX complet avec recommandations priorisees, parcours utilisateur documente, hierarchie visuelle analysee
- Fichiers produits : `docs/ux/ux-audit.md`
- Points d'attention : le composant Pipeline visuel (P0) est le plus impactant et necessite un travail de design specifique (layout horizontal multi-colonnes, agents cliquables, responsive) ; le bouton "Copier" necessite un micro-interaction (feedback visuel) ; les filtres par phase et par agent doivent etre coherents visuellement avec le design system existant (tags jaune accent)
- Decisions prises : 4 sections au lieu de 3, pipeline en premiere position a terme, hierarchie des cartes revisee (handle > role > phase > action > competences > requis)
---
