# Audit learnings Versi s21-s25 — 2026-04-17

Mission : analyser 16 patterns Versi + 2 commentaires Thomas (favicons, perfs dégradées). Verdict par pattern, checklist favicons universelle, audit objectif des perfs agents.

---

## 1. Tableau 16 patterns × verdict

| # | Pattern | Verdict | Formulation universelle (si ADAPTER) |
|---|---|---|---|
| 1 | Typist pattern (code exact vs archi) | DÉJÀ dans CLAUDE.md règle 3 (partiellement) | Enrichir : ajouter seuils "brief > 2000 mots ou fichier > 300 lignes = risque timeout" |
| 2 | Multi-agent audit convergence (3 itérations × 5 agents) | ADAPTER | Pour livrables critiques (scoring < 9/10 au 1er audit), 2-3 itérations parallèles d'agents complémentaires jusqu'à convergence GATES PASS stable |
| 3 | No Manufacturing Defaults | GARDER (nouveau) | Si une pré-définition IA manque de confiance ou d'utilité persona → SUPPRIMER plutôt que livrer un défaut médiocre. Bad AI worse than no AI |
| 4 | Meta-Tag SEO Only | ADAPTER | H1 = copywriting (conversion). SEO dans meta title/description + schema.org. Jamais forcer H1 pour keywords |
| 5 | Persona-Driven Verdicts | GARDER (extension règle 5 Mindset IA) | Agents stratégiques basent GO/NO-GO sur VALEUR utilisateur, pas sur contraintes humaines (ROI, payback, effort estimates) |
| 6 | Unanimous 10/10 scoring | ÉCARTER | Framework a migré PASS/FAIL binaire 2026-03-26. Versi doit migrer, pas l'inverse. Signaler à Thomas |
| 7 | Typo/ellipsis/m² standardization | ADAPTER | Gate typographique : m² (pas m2), … (pas ...), œ/æ ligatures, espaces insécables avant : ; ! ? — à ajouter à G29 QA |
| 8 | Orchestrator 2 timeouts = re-audit mandatory | ADAPTER | Si @orchestrator timeout 2× consécutifs sur même phase → pause, audit du plan (découpage trop gros ?) avant reprendre |
| 9 | Fallback timeout ladder (4 étapes) | GARDER | Escalade : (1) reduce scope 50%, (2) typist pattern, (3) manual write + audit, (4) escalate top-level |
| 10 | Favicon 48×48 minimum | GARDER (devient checklist complète — voir section 3) | — |
| 11 | Express 4-batch pattern (9-12 corrections) | ÉCARTER | Spécifique méthode Versi. Framework utilise PASS/FAIL, pas batch de corrections cumulatives |
| 12 | Tailwind v4 custom props collision | ADAPTER | Custom properties Tailwind v4 : préfixer (ex `--app-spacing-md`) pour éviter collision avec classes utilitaires (`max-w-md`). Gate @fullstack |
| 13 | Canvas clearRect explicite | ADAPTER | Ne jamais se reposer sur `canvas.width = X` pour clear. Utiliser `ctx.clearRect(0,0,w,h)` explicite. Gate @fullstack |
| 14 | Playwright route.fallback | ADAPTER | `route.continue()` sans upstream handler = test flaky. Utiliser `route.fallback()`. Gate @qa |
| 15 | Express 5 named route params | ADAPTER | Express 5 : wildcards nommés `/{*splat}` pas `*`. Migration breaking. Gate @fullstack si Express |
| 16 | G27 Traceability Batch 1 | GARDER | Requirements-to-tests mapping DOIT être produit Batch 1 par @qa, pas retroactivement. Vérifier G27 actuel |

**Verdicts agrégés** : 4 GARDER, 9 ADAPTER, 2 ÉCARTER, 1 DÉJÀ intégré.

---

## 2. Top 3 patterns ROI framework max

**#1 — Pattern 3 (No Manufacturing Defaults)** : impact cross-agents massif. À ajouter dans `@ia`, `@product-manager`, `@design`, `@copywriter`. Règle : "Un défaut IA médiocre détruit plus de valeur qu'il n'en crée. Si confiance < seuil → supprimer la feature plutôt que ship un défaut bancal". Justifie suppressions propres.

**#2 — Pattern 5 (Persona-Driven Verdicts)** : corrige un biais humain que les agents reproduisent (ROI/payback comme critère primaire). Extension explicite règle 5 CLAUDE.md. Évite des NO-GO qui devraient être GO.

**#3 — Pattern 2 (Multi-agent audit convergence)** : remplace audit unique par itérations parallèles. ROI : passage de 6-7/10 à 9.3/10 mesuré. À formaliser comme protocole `@reviewer` pour livrables critiques.

---

## 3. Checklist favicons universelle (commentaire 1)

Standards 2026 vérifiés : Google SERP (48×48 min, recommandé multiple de 48), Apple touch-icon 180×180, Android Chrome 192/512, Microsoft Tile, PWA manifest, OG/Twitter social preview.

### Tableau complet (20 items)

| # | Icône | Dimension | Format | Chemin | Balise HTML / config | Plateforme cible |
|---|---|---|---|---|---|---|
| 1 | favicon.ico (legacy) | 16×16 + 32×32 + 48×48 multi-res | ICO | `/favicon.ico` | `<link rel="icon" href="/favicon.ico" sizes="any">` | IE, legacy browsers |
| 2 | favicon SVG (moderne) | vectoriel | SVG | `/favicon.svg` | `<link rel="icon" type="image/svg+xml" href="/favicon.svg">` | Chrome, Firefox, Safari modern |
| 3 | Favicon 16×16 | 16×16 | PNG | `/favicon-16x16.png` | `<link rel="icon" type="image/png" sizes="16x16" href="...">` | Browser tabs |
| 4 | Favicon 32×32 | 32×32 | PNG | `/favicon-32x32.png` | `<link rel="icon" type="image/png" sizes="32x32" href="...">` | Browser tabs retina |
| 5 | Favicon 48×48 | 48×48 | PNG | `/favicon-48x48.png` | `<link rel="icon" type="image/png" sizes="48x48" href="...">` | Google SERP (minimum requis) |
| 6 | Favicon 96×96 | 96×96 | PNG | `/favicon-96x96.png` | `<link rel="icon" type="image/png" sizes="96x96" href="...">` | Google Desktop shortcuts |
| 7 | Apple touch icon | 180×180 | PNG (sans transparence) | `/apple-touch-icon.png` | `<link rel="apple-touch-icon" sizes="180x180" href="...">` | iOS home screen |
| 8 | Android Chrome 192 | 192×192 | PNG | `/android-chrome-192x192.png` | Déclaré dans manifest.json `icons[]` | Android home screen |
| 9 | Android Chrome 512 | 512×512 | PNG | `/android-chrome-512x512.png` | Déclaré dans manifest.json `icons[]` | Android splash screen / PWA |
| 10 | Maskable icon | 512×512 (safe zone 409×409) | PNG | `/maskable-icon-512.png` | manifest.json `icons[]` avec `"purpose": "maskable"` | Android adaptive icons |
| 11 | MS Tile 70 | 70×70 | PNG | `/mstile-70x70.png` | `browserconfig.xml` | Windows 8/10 small tile |
| 12 | MS Tile 150 | 150×150 | PNG | `/mstile-150x150.png` | `browserconfig.xml` | Windows medium tile |
| 13 | MS Tile 310 wide | 310×150 | PNG | `/mstile-310x150.png` | `browserconfig.xml` | Windows wide tile |
| 14 | MS Tile 310 | 310×310 | PNG | `/mstile-310x310.png` | `browserconfig.xml` | Windows large tile |
| 15 | Safari pinned tab | vectoriel monochrome | SVG | `/safari-pinned-tab.svg` | `<link rel="mask-icon" href="..." color="#HEX">` | Safari macOS pinned tabs |
| 16 | Theme color | — | hex | — | `<meta name="theme-color" content="#HEX">` | Mobile browser chrome |
| 17 | MS application tile color | — | hex | — | `<meta name="msapplication-TileColor" content="#HEX">` | Windows tile |
| 18 | MS browserconfig ref | XML | XML | `/browserconfig.xml` | `<meta name="msapplication-config" content="/browserconfig.xml">` | Windows tiles config |
| 19 | Web manifest | JSON | JSON | `/site.webmanifest` ou `/manifest.json` | `<link rel="manifest" href="/site.webmanifest">` | PWA / Android |
| 20 | OG image (social) | 1200×630 | PNG/JPG | `/og-image.png` | `<meta property="og:image" content="...">` + `<meta name="twitter:image" content="...">` | Facebook, LinkedIn, Twitter, Slack preview |

### Vérification automatisable

Grep pattern (à exécuter en pre-commit ou audit @design) :
```bash
# Présence fichiers
for f in favicon.ico favicon.svg favicon-16x16.png favicon-32x32.png favicon-48x48.png favicon-96x96.png apple-touch-icon.png android-chrome-192x192.png android-chrome-512x512.png maskable-icon-512.png mstile-150x150.png safari-pinned-tab.svg site.webmanifest og-image.png browserconfig.xml; do
  [ -f "public/$f" ] || echo "MANQUE: $f"
done
# Présence balises dans HTML head
grep -l 'rel="icon"' public/index.html
grep -l 'apple-touch-icon' public/index.html
grep -l 'theme-color' public/index.html
grep -l 'manifest' public/index.html
grep -l 'og:image' public/index.html
```

### Recommandation placement : Option D (combinaison)

- **Fichier dédié** : `docs/checklists/favicon-checklist.md` (source de vérité, réutilisable multi-projets)
- **Gate binaire** : ajouter **G31 Favicon Coverage** dans `_gates.md` — "20/20 items favicon présents et balisés"
- **Références** : ajouter lien dans `design.md` (section livrables) + `fullstack.md` (section HTML head) + `qa.md` (check pre-launch)

Raison : un fichier-source évite duplication, un gate force la vérification, les références dans 3 agents garantissent qu'aucun n'oublie.

---

## 4. Analyse commentaire 2 — Perfs agents dégradées

### Mesures objectives (aujourd'hui)

| Fichier | Lignes actuelles |
|---|---|
| CLAUDE.md | 104 (cap dur 120) |
| _base-agent-protocol.md | 467 |
| _gates.md | 119 |
| lessons-learned.md | 125 |
| CHANGELOG.md | 129 |
| **Total context commun lu par chaque agent** | **~944 lignes** |

Baseline estimé début framework (avant s21) : CLAUDE.md ~80, protocol ~250, gates ~60, lessons-learned 0-30, CHANGELOG ~40 → ~460 lignes. **Croissance ≈ +100% en ~5 sessions.**

### Verdict : HYPOTHÈSE PARTIELLEMENT FONDÉE

Confirmations objectives :
- **(a) Context bloat : FONDÉ** — doublement du contexte commun. Chaque agent paie ce coût sur chaque invocation.
- **(c) Sur-spécification : FONDÉ** — `_base-agent-protocol.md` à 467 lignes contient gates + protocoles + exceptions + cas particuliers. Densité règles très élevée.
- **(e) Pas de déprécation : FONDÉ** — aucun mécanisme de retrait de learnings. CHANGELOG accumule, lessons-learned accumule.
- **(b) Règles contradictoires : À VÉRIFIER** — pas d'outil de détection aujourd'hui, mais risque structurel réel si learnings cumulés.
- **(d) Noise > signal : PARTIELLEMENT FONDÉ** — lessons-learned.md (125 lignes) n'est pas priorisé P0/P1/P2.

### 3 solutions testables

**Solution 1 — Expiration learnings (TTL)**
Chaque entrée `lessons-learned.md` reçoit une date + niveau (P0/P1/P2). Audit trimestriel : P2 > 90 jours = supprimés, P1 > 180 jours = migrés vers gate ou supprimés, P0 = promus vers CLAUDE.md ou protocol. Test : audit 2026-07-24.

**Solution 2 — Cap dur sur _base-agent-protocol.md**
Cap 400 lignes (vs 467 actuels). Tout ajout = une suppression équivalente. Idem lessons-learned.md cap 100 lignes. Force arbitrage signal/bruit. Test immédiat : réduire protocol de 67 lignes en factorisant les duplications gates/protocoles.

**Solution 3 — Context layering par agent**
Tous les agents ne doivent pas lire tout. Séparer :
- `CLAUDE.md` (universel, 7 commandements) — lu par tous
- `_gates.md` — lu par @reviewer, @qa, @orchestrator uniquement
- `_base-agent-protocol.md` — lu par agents lors du 1er appel d'une session uniquement (cache)
- `lessons-learned.md` — lu par @orchestrator uniquement (qui propage si pertinent)

Test : A/B sur 2 sessions, mesurer latence + qualité.

---

## 5. Recommandations consolidées (ordre prioritaire)

**P0 — Immédiat (cette semaine)**
1. Créer `docs/checklists/favicon-checklist.md` (20 items) + gate **G31 Favicon Coverage** dans `_gates.md`
2. Ajouter références favicon-checklist dans `design.md`, `fullstack.md`, `qa.md`
3. Intégrer **Pattern 3 (No Manufacturing Defaults)** dans `@ia`, `@product-manager`, `@design`, `@copywriter` (1 paragraphe chacun)
4. Étendre règle 5 CLAUDE.md avec **Pattern 5 (Persona-Driven Verdicts)**

**P1 — Sprint suivant**
5. Solution 2 perfs : réduire `_base-agent-protocol.md` de 467 → 400 lignes (factoriser duplications)
6. Ajouter patterns 12-15 (Tailwind v4, Canvas, Playwright, Express 5) dans `@fullstack` et `@qa` comme gates techniques
7. Formaliser **Pattern 2 (Multi-agent audit convergence)** comme protocole `@reviewer` pour livrables scoring < 9/10
8. Ajouter **Pattern 9 (Fallback timeout ladder)** comme section explicite dans `@orchestrator`

**P2 — Trimestriel**
9. Solution 1 perfs : TTL sur lessons-learned.md + audit 2026-07-24
10. Signaler à Thomas : Versi doit migrer scoring 10/10 → PASS/FAIL (framework a évolué)
11. Enrichir G27 Traceability (Pattern 16) : vérifier que requirements-to-tests est bien produit en Batch 1

**À NE PAS FAIRE**
- Ne pas ajouter tout lessons-learned Versi tel quel (inflation garantie)
- Ne pas créer gates G32-G35 "au cas où" (principe : un gate = un risque mesuré)
- Ne pas migrer le framework en "spécialisé Versi" (il reste généraliste)

---

**Handoff → @orchestrator**
- Fichiers produits : `/home/user/Agent-Team/docs/reviews/versi-learnings-audit-2026-04-17.md`
- Décisions prises : 4 patterns GARDER, 9 ADAPTER, 2 ÉCARTER, 1 déjà intégré. Checklist favicon 20 items (placement Option D). Hypothèse perfs dégradées PARTIELLEMENT FONDÉE (context bloat +100%, sur-spécification, absence de TTL confirmés).
- Points d'attention : P0 à lancer cette semaine (favicon-checklist + gate G31 + Pattern 3 + Pattern 5). Cap `_base-agent-protocol.md` à 400 lignes = refacto nécessaire. Versi à aligner sur framework binaire (pas l'inverse).
