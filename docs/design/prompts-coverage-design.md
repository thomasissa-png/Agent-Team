# Analyse de couverture — Bibliothèque de prompts (39 prompts)
## Perspective : @design — Directeur artistique digital

> Note préliminaire : project-context.md est absent à la racine. Cette analyse porte sur le framework lui-même (audit interne), pas sur un projet client. Le protocole d'entrée obligatoire ne s'applique pas ici dans sa forme standard — mais ce constat doit être signalé.

---

## 1. Ce qui est bien couvert

### Le design system comme livrable terminal
Le prompt "Design system complet" (Phase 1) est solide. Il enchaîne @design → @fullstack, couvre les tokens (couleurs, typographies, espacements, ombres), les composants de base, le dark mode et WCAG 2.2 AA. Le handoff vers `design-tokens.json` + implémentation CSS/Tailwind est explicite. C'est le bon niveau de détail pour ce type de prompt.

### L'audit de cohérence visuelle
Le prompt "Auditer la cohérence visuelle" (Raccourcis) est pertinent : il cite les tokens de référence, les contrastes WCAG 2.2 AA, et enchaîne avec @ux pour vérifier la hiérarchie visuelle des CTAs. Un vrai prompt d'audit, pas une vague vérification.

### La refonte de site existant
Le prompt "Refondre un site existant" (Raccourcis) couvre la chaîne UX → design → fullstack avec migration progressive. Le design system existant est lu avant de proposer un nouveau. Logique.

### L'ancrage UX avant le design
Le design system est conditionné à la lecture de `docs/ux/wireframes.md` avant de commencer. C'est la bonne séquence : la forme suit la fonction. Ce point non négociable est respecté dans la structure du prompt.

---

## 2. Ce qui manque — avec impact sur le succès du projet

### 2.1 Direction artistique et moodboard [MANQUE CRITIQUE]

**Ce qui manque :** aucun prompt ne couvre la phase de direction artistique en amont du design system. Actuellement, @design reçoit les wireframes et produit directement les tokens. Mais entre "wireframes textuels" et "design-tokens.json", il manque une étape décisive : définir l'ambiance visuelle, la direction artistique, les références d'inspiration.

**Impact :** sans moodboard validé, le design system peut être techniquement correct mais visuellement faux pour la marque. Le designer et le client/équipe n'ont pas d'accord sur "à quoi ça ressemble" avant de coder. C'est la source numéro 1 de refonte visuelle à mi-chemin.

**Ce que devrait faire ce prompt :** @design produit un brief visuel (3 directions artistiques avec références, palette candidate, typographie candidate) avant de figer les tokens. @creative-strategy valide l'alignement avec la brand platform.

---

### 2.2 Prototypage interactif et validation avant code [MANQUE CRITIQUE]

**Ce qui manque :** le parcours saute de "wireframes textuels ASCII" (Phase 1 UX) directement à "implémentation composants React" (Phase 2 fullstack). Il n'existe aucun prompt pour valider les interactions, les transitions d'état, et les micro-interactions avant de coder.

**Impact :** les développeurs codent des composants dont les états hover/focus/disabled/loading/error n'ont jamais été définis. Résultat : incohérences visuelles entre composants, états manquants découverts en QA, et corrections coûteuses en fin de sprint.

**Ce que devrait faire ce prompt :** @design produit les specs d'interaction pour les composants critiques (boutons, formulaires, modals, navigation) avec tous leurs états. Ce n'est pas du Figma — c'est un tableau texte : composant × état × comportement visuel.

---

### 2.3 Handoff design → développement [MANQUE MAJEUR]

**Ce qui manque :** le prompt "Design system complet" demande à @fullstack d'implémenter les tokens, mais il n'existe pas de prompt dédié au handoff. Pas de specs de redline, pas de vérification que le code implémenté correspond au design défini, pas de boucle de validation visuelle.

**Impact :** les développeurs interprètent les tokens. "Spacing-4" devient 16px dans un fichier et 14px dans un autre. Les radius sont approximatifs. Le design system existe sur papier mais pas dans le produit. C'est la dette design la plus courante.

**Ce que devrait faire ce prompt :** @design audite le code produit par @fullstack contre les specs du design-tokens.json. Rapport d'écarts avec criticité (bloquant / majeur / mineur). Décision de merge ou correction avant merge.

---

### 2.4 Responsive design et breakpoints [MANQUE MAJEUR]

**Ce qui manque :** aucun prompt ne couvre les specs responsive. Le design system mentionne le dark mode mais pas les breakpoints, les adaptations mobiles des composants, les typographies fluides, ou les grilles responsive.

**Impact :** les composants sont designés desktop-first sans spécification des comportements mobiles. Le développeur invente la version mobile. Les breakpoints divergent entre composants. Sur mobile — souvent 60-70% du trafic — l'expérience est sous-optimale.

**Ce que devrait faire ce prompt :** @design produit les specs responsive pour les composants critiques (navigation, cards, formulaires, tableaux) avec les breakpoints Tailwind (sm/md/lg/xl) et les adaptations de comportement (ex : navigation hamburger, cards en colonne, etc.).

---

### 2.5 Iconographie et illustration [MANQUE MINEUR mais visible]

**Ce qui manque :** aucun prompt ne couvre le système d'icônes (choix de la librairie, style, taille, couleur, usage) ni les illustrations (style, cohérence, usage éditorial vs fonctionnel).

**Impact :** les développeurs choisissent leurs icônes au fil de l'eau (Heroicons ici, Lucide là, emoji ailleurs). L'illustration est absente ou incohérente. Le produit vieillit visuellement plus vite que prévu.

**Ce que devrait faire ce prompt :** @design définit le système d'icônes (librairie, variants, taille, couleurs autorisées) et le guide d'illustration si le projet en a besoin. Intégré dans le design system, pas en annexe.

---

### 2.6 Motion design et transitions [MANQUE MINEUR]

**Ce qui manque :** aucune mention des animations, transitions entre états, ou feedback visuels dans les prompts design.

**Impact :** les animations sont soit absentes (produit perçu comme "froid"), soit sur-codées par le développeur avec des durées et des courbes d'accélération incohérentes.

**Ce que devrait faire ce prompt :** @design produit un guide de motion minimal : durées (100ms / 200ms / 300ms), courbes d'accélération (ease-in / ease-out / spring), règles d'usage (quand animer, quand ne pas animer). Intégré dans les tokens comme `animation-duration` et `animation-easing`.

---

### 2.7 Trou entre conception et implémentation mobile [MANQUE MAJEUR si Expo/React Native]

**Ce qui manque :** le prompt "Design system complet" mentionne NativeWind pour Expo dans la description de l'agent @design, mais aucun prompt ne couvre l'adaptation du design system web vers mobile natif. Les tokens web (px, rem, CSS variables) ne fonctionnent pas tels quels en React Native.

**Impact :** sur un projet cross-platform web + mobile, le design system est créé pour le web et "porté" au mobile de manière artisanale. Le langage visuel diverge entre les deux plateformes.

**Ce que devrait faire ce prompt :** @design produit les specs d'adaptation mobile (unités dp vs px, composants natifs vs custom, comportements plateforme iOS vs Android) et @fullstack les implémente avec NativeWind.

---

## 3. Prompts recommandés à ajouter

### Prompt A — Direction artistique & moodboard
**Titre :** Définir la direction artistique
**Phase :** Phase 1 — Conception (avant "Design system complet")
**Agents :** @design, @creative-strategy
**Quand :** Après la brand platform, avant de produire les tokens
**Description :** @design produit 2-3 directions artistiques sous forme de brief visuel textuel (ambiance, références sectorielles, palette candidate avec codes hex, typographie candidate avec source et usage). @creative-strategy valide l'alignement avec le positionnement de marque. La direction retenue est documentée dans `docs/design/art-direction.md` et devient le cadre contraignant du design system. Sans ce livrable, les tokens sont optionnels — avec lui, ils sont la traduction d'une décision validée.

---

### Prompt B — Specs d'interaction et états des composants
**Titre :** Spécifier les interactions et états des composants
**Phase :** Phase 1 — Conception (entre "Design system complet" et "Développer une feature")
**Agents :** @design, @ux
**Quand :** Après le design system, avant l'implémentation des composants
**Description :** @design produit les specs d'état pour chaque composant prioritaire : default, hover, focus, active, disabled, loading, error, success, empty state. Format tableau : composant × état × comportement visuel (couleur, opacité, cursor, animation). @ux valide que les états reflètent les parcours utilisateur définis dans les wireframes. Livrable : `docs/design/component-states.md`. Ce fichier est lu par @fullstack avant de coder chaque composant.

---

### Prompt C — Audit visual design → code (handoff check)
**Titre :** Vérifier l'implémentation du design system
**Phase :** Phase 2 — Développement (après "Développer une feature")
**Agents :** @design, @qa
**Quand :** Après implémentation des premiers composants, avant merge en main
**Description :** @design audite le code produit par @fullstack contre `docs/design/design-tokens.json`. Vérifie : tokens utilisés (pas de valeurs hardcodées), contrastes WCAG 2.2 AA en clair et dark mode, états des composants implémentés (hover/focus/disabled/error). Rapport d'écarts avec criticité (bloquant / majeur / mineur). Livrable : `docs/design/visual-audit.md`. @qa crée les tests de régression visuelle (snapshots) sur les composants validés pour prévenir les régressions futures.

---

### Prompt D — Specs responsive et breakpoints
**Titre :** Définir les specs responsive
**Phase :** Phase 1 — Conception (intégré ou en complément du design system)
**Agents :** @design, @ux
**Quand :** Après le design system desktop, avant l'implémentation
**Description :** @design produit les specs responsive pour les composants critiques (navigation, grille, cards, formulaires, tableaux, modals). Format : composant × breakpoint × comportement. Breakpoints Tailwind : mobile (<640px), sm (640px), md (768px), lg (1024px), xl (1280px). Inclut les adaptations typographiques (clamp() ou palier fixe) et les règles de densité d'information (ce qui se cache, ce qui se réorganise, ce qui reste). Livrable : section "Responsive" dans `docs/design/design-system.md`. @ux valide que les adaptations mobiles respectent les parcours utilisateur prioritaires.

---

## 4. Synthèse — Couverture du parcours design

| Étape du parcours design | Couverture actuelle | Impact si absent |
|---|---|---|
| Brief visuel / moodboard | Absente | Refonte à mi-chemin |
| Direction artistique validée | Absente | Design system sans ancrage marque |
| Wireframes UX | Couverte (@ux) | — |
| Design system (tokens + composants) | Couverte (@design) | — |
| Specs d'interaction et états | Absente | États manquants en production |
| Responsive / breakpoints | Absente | Mauvaise expérience mobile |
| Iconographie | Absente | Incohérence visuelle |
| Handoff design → dev | Partielle (trop implicite) | Tokens non respectés en code |
| Audit implémentation vs design | Absente | Dette design invisible |
| Motion design | Absente | Animations incohérentes |
| Adaptation mobile native (Expo) | Absente | Divergence web/mobile |
| Audit de cohérence visuelle | Couverte (@design) | — |

**Verdict :** sur 12 étapes du parcours design complet, 3 sont couvertes, 1 est partiellement couverte, et 8 sont absentes. La bibliothèque couvre le design system comme artefact de sortie, mais pas le processus qui permet d'arriver à un design system juste, validé, et réellement implémenté. Le risque principal : produire des tokens parfaits sur papier qui ne survivent pas au premier sprint de développement.

---

## 5. Priorité d'ajout recommandée

1. **Prompt A — Direction artistique** (critique — évite les refontes)
2. **Prompt C — Audit handoff** (critique — ferme la boucle design/code)
3. **Prompt B — Specs d'interaction** (majeur — évite les états manquants)
4. **Prompt D — Responsive specs** (majeur — mobile = 60-70% du trafic)

Les prompts iconographie et motion design peuvent être intégrés dans le prompt "Design system complet" existant plutôt que créés séparément, pour ne pas fragmenter davantage la Phase 1.

---

*Livrable produit par @design — 2026-03-22*
*Chemin : docs/design/prompts-coverage-design.md*
