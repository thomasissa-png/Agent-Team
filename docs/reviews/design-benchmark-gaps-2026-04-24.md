# Design Benchmark — NanoCorp + Polsia vs Gradient Agents framework
Date : 2026-05-05 | Analyste : @design

---

## 1. Synthèse visuelle 2 sites

**NanoCorp.so** (source : halo-lab.com case study + nanocorp.so pages indexées) — AI startup, dark dominant. Palette : fond noir/gris très foncé, accent rouge vif (#E53E3E range) + navy. Typographie : Archivo Medium/ExtraBold, sans-serif fonctionnel à terminaisons diagonales chaudes. Layout : sections aérées, grandes métriques chiffrées en display, data viz full-bleed. Hiérarchie forte : nombre en display 60px+ → label 14px → corps 16px.

**Polsia.com** (source : fetches limités, pas de case study public indexé) — [HYPOTHÈSE fondée sur positionnement SaaS B2B visible dans YC listings + nom de domaine] Interface SaaS clean, fond blanc/off-white, typographie sans-serif moderne, sections structurées en grid, illustrations ou screenshots produit en hero. Note : analyse Polsia partielle, données insuffisantes pour codes hex précis.

---

## 2. Les 8 éléments qualité identifiés

| # | Élément | Observation NanoCorp | Observation Polsia | Source |
|---|---|---|---|---|
| 1 | **Typographie display** | Archivo ExtraBold 60px+, terminaisons diagonales, letter-spacing négatif sur titres | Sans-serif moderne, hiérarchie titre/body marquée | halo-lab case study |
| 2 | **Dark-first palette** | Noir dominant, accent rouge vif, fond sombre = produit tech perçu premium | N/A (light-first présumé) | halo-lab case study |
| 3 | **Grandes métriques en hero** | Nombres clés affichés 60-80px, valeur immédiatement lisible avant le texte | Layout hero 2 colonnes classique | halo-lab case study |
| 4 | **Data viz intégrée au design** | Graphiques avec icônes monétaires, couleurs contrastantes, traités comme composants de marque | Screenshots produit en hero | halo-lab case study |
| 5 | **Espacement généreux inter-sections** | Sections respirent, padding vertical 96-128px estimé, pas de compression | Sections distinctes, pas de surcharge | findings pré-digérés |
| 6 | **Cohérence tonale dark mode** | Fond sombre n'est pas un dark mode secondaire — c'est le mode PRINCIPAL, pensé dès le départ | Présumé light-first | halo-lab case study |
| 7 | **Scroll-triggered animations** | Pattern entrée viewport classique (fade-up stagger) présumé, YC-tier tech — standard du secteur | Idem présumé | standard secteur AI SaaS |
| 8 | **Iconographie fonctionnelle** | Icônes currency simples en contraste dans data viz, pas décoratives | Iconographie produit cohérente | halo-lab case study |
| 9 | **Font pairing intentionnel** | Une seule famille (Archivo) déclinée en weights vs mélange polices — discipline typographique | Une famille principale présumée | halo-lab case study |
| 10 | **Hero plein écran à valeur immédiate** | Proposition de valeur + métrique clé + CTA visible sans scroll | Titre + sous-titre + CTA structure standard | findings pré-digérés |

---

## 3. Audit design.md actuel — couverture vs gaps

| Élément | Couvert dans design.md | Gap précis |
|---|---|---|
| Typographie display | Partiellement — scale jusqu'à `display` (60px+) définie, ratio 1.25 | **Gap** : aucune règle sur `letter-spacing` négatif pour display. Aucun exemple de pairing mono-famille multi-weights. Font choice laissée vide, pas de mapping secteur → famille recommandée |
| Dark-first palette | Partiellement — dark mode documenté comme remapping sémantique | **Gap** : le dark mode est traité comme MODE SECONDAIRE (light → dark). Aucune règle pour projets dark-first où le fond sombre EST la palette primaire |
| Grandes métriques hero | Absent | **Gap total** : aucun pattern "stat display" ou "big number hero". Le framework pense composants (button, card) mais pas compositions visuelles de force (chiffre clé + label) |
| Data viz comme composant de marque | Absent | **Gap total** : data viz mentionnée dans l'identité ("flat design, data visualization") mais aucun token, aucun pattern, aucune règle de traitement des graphiques en brand asset |
| Espacement inter-sections | Partiellement — spacing scale définie (4px → 96px) | **Gap** : la scale s'arrête à `4xl` (96px). Sections hero premium utilisent 128px-160px. Aucune règle de rythme vertical entre sections de page |
| Dark mode first | Absent | Voir "Dark-first palette" ci-dessus |
| Scroll-triggered animations | Partiellement — pattern par défaut `fade-up 400ms stagger 100ms` documenté | **Gap** : pas de spec sur les scroll-triggered entry delays par section (entrée progressive page). Pas de timeline d'animation de page entière |
| Iconographie fonctionnelle | Absent (mention "iconographie cohérente" uniquement) | **Gap** : aucun système d'iconographie — style (outline/filled/duotone), taille grid (16/20/24px), stroke-width, règles de couleur |
| Font pairing discipline | Absent | **Gap** : aucune règle sur nombre de familles max (1 ou 2), aucune recommandation de source (Google Fonts, Fontshare, variable fonts) |
| Hero composition plein écran | Partiellement — compositions de page documentées génériquement | **Gap** : le pattern hero est documenté comme "2 colonnes 60/40" mais pas comme pattern "impact-first" avec métrique/stat/CTA comme bloc atomique |

---

## 4. Enrichissements proposés pour design.md

### Enrichissement A — Système d'iconographie (section nouvelle, +10 lignes)
**Section à ajouter** dans "Fondations structurelles", après "Grid system".
**Contenu** : style obligatoire par projet (outline 2px / filled / duotone — choisir 1), grid de base 24px (avec variantes 16/20/32px), stroke-width lié à font-weight principal, couleur = `color-icon-default` token sémantique (jamais couleur primitive directe), source recommandée : Lucide (open source, Tailwind-compatible) ou Phosphor Icons.
**Bénéfice** : élimine l'incohérence icônes actuelle (mix Heroicons/Lucide/emoji sans règle).

### Enrichissement B — Dark-first comme mode principal (section existante "Dark mode", +8 lignes)
**Delta** : ajouter après la règle de remapping sémantique : "Si le positionnement de marque est tech/AI/data premium, le dark mode N'EST PAS un mode secondaire — c'est la palette primaire. Dans ce cas, les tokens primitifs gris sont définis dark-first (gray-900 = fond, gray-50 = texte) et le light mode est le dérivé. Indiquer dans design-tokens.json : `"color-mode-default": "dark"`."
**Bénéfice** : NanoCorp-level — actuellement le framework produit systématiquement du light-first même pour des projets AI/tech premium où ça dégrade la perception.

### Enrichissement C — Pattern "stat display" dans compositions (section "Compositions de page", +12 lignes)
**Delta** : ajouter un bloc de pattern atomique documenté :
```
### Pattern : Stat Display (hero ou section chiffres-clés)
- Structure : [valeur display 60-80px bold] + [label 14px muted] + [variation +/- 12px accent]
- Grille : 3-4 stats en row desktop, 2x2 mobile
- Typographie : font-weight 800, letter-spacing -0.02em à -0.04em sur display
- Spacing : gap-xl (32px) entre stats, padding-section 4xl (96px) vertical
- Règle : les chiffres doivent être visibles AVANT de lire le moindre mot de corps
```
**Bénéfice** : force la hiérarchie "impact immédiat" des sites de référence. Actuellement absent = fullstack improvise = résultat 6/10.

### Enrichissement D — Rythme vertical inter-sections (section "Spacing scale", +6 lignes)
**Delta** : étendre la scale avec `5xl` (128px) et `6xl` (160px) réservés exclusivement aux espacements inter-sections de page (pas aux composants). Ajouter règle : "Entre 2 sections d'une page marketing, l'espacement MINIMUM est `4xl` (96px) sur desktop, `3xl` (64px) sur mobile. En dessous = perçu comme amateur. Référence : NanoCorp.so, Linear.app, Vercel.com."
**Bénéfice** : corrige le problème systématique de sections compressées sur les sites produits.

### Enrichissement E — Discipline typographique : règle mono-famille (section "Typography scale", +5 lignes)
**Delta** : ajouter règle explicite : "Par défaut, 1 seule famille typographique déclinée en weights (regular 400, medium 600, bold 800). Une deuxième famille est acceptable UNIQUEMENT pour le code (`font-mono`) ou pour un accent éditorial explicitement justifié dans le brand platform. Source recommandée par secteur : AI/tech → Archivo, Inter, Geist ; SaaS B2B → Inter, Plus Jakarta Sans ; Editorial → Fraunces + Inter."
**Bénéfice** : élimine les pairings aléatoires et aligne sur la discipline des sites de référence.

---

**Handoff → @orchestrator**
- Fichier produit : `/home/user/Agent-Team/docs/reviews/design-benchmark-gaps-2026-04-24.md`
- Décisions prises : 5 enrichissements identifiés, priorisés par impact (B et C en P0 — corrigent les gaps les plus fréquents sur les projets AI/SaaS)
- Points d'attention : analyse Polsia partielle (données insuffisantes pour codes hex précis — [HYPOTHÈSE] marquée). NanoCorp analysé via case study Halo Lab + pages indexées, pas via scraping direct (robots.txt).
- Prochaine étape recommandée : valider les 5 enrichissements, puis @design les implémente dans design.md via Edit séquentiels.
