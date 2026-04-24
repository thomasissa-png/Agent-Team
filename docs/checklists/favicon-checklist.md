# Favicon Checklist universelle — Gradient Agents

Source de vérité cross-projets. Référencée par `@design`, `@fullstack`, `@qa`. Verdict via gate **G31 Favicon Coverage** (`_gates.md`).

Tous les fichiers vont dans `/public/` (Next.js, Vite) ou `/static/` selon le framework. Adapter chemins si custom.

---

## 1. Tableau complet (20 items obligatoires)

| # | Icône | Dimension | Format | Chemin | Balise HTML / config | Plateforme cible |
|---|---|---|---|---|---|---|
| 1 | favicon.ico (legacy) | 16×16 + 32×32 + 48×48 multi-res | ICO | `/favicon.ico` | `<link rel="icon" href="/favicon.ico" sizes="any">` | IE, legacy browsers |
| 2 | favicon SVG (moderne) | vectoriel | SVG | `/favicon.svg` | `<link rel="icon" type="image/svg+xml" href="/favicon.svg">` | Chrome, Firefox, Safari modern |
| 3 | Favicon 16×16 | 16×16 | PNG | `/favicon-16x16.png` | `<link rel="icon" type="image/png" sizes="16x16" href="/favicon-16x16.png">` | Browser tabs |
| 4 | Favicon 32×32 | 32×32 | PNG | `/favicon-32x32.png` | `<link rel="icon" type="image/png" sizes="32x32" href="/favicon-32x32.png">` | Browser tabs retina |
| 5 | Favicon 48×48 | 48×48 | PNG | `/favicon-48x48.png` | `<link rel="icon" type="image/png" sizes="48x48" href="/favicon-48x48.png">` | **Google SERP (minimum requis)** |
| 6 | Favicon 96×96 | 96×96 | PNG | `/favicon-96x96.png` | `<link rel="icon" type="image/png" sizes="96x96" href="/favicon-96x96.png">` | Google Desktop shortcuts |
| 7 | Apple touch icon | 180×180 | PNG (sans transparence) | `/apple-touch-icon.png` | `<link rel="apple-touch-icon" sizes="180x180" href="/apple-touch-icon.png">` | iOS home screen |
| 8 | Android Chrome 192 | 192×192 | PNG | `/android-chrome-192x192.png` | Déclaré dans `site.webmanifest` `icons[]` | Android home screen |
| 9 | Android Chrome 512 | 512×512 | PNG | `/android-chrome-512x512.png` | Déclaré dans `site.webmanifest` `icons[]` | Android splash screen / PWA |
| 10 | Maskable icon | 512×512 (safe zone 409×409 centrée) | PNG | `/maskable-icon-512.png` | `site.webmanifest` `icons[]` avec `"purpose": "maskable"` | Android adaptive icons |
| 11 | MS Tile 70 | 70×70 | PNG | `/mstile-70x70.png` | `browserconfig.xml` | Windows 8/10 small tile |
| 12 | MS Tile 150 | 150×150 | PNG | `/mstile-150x150.png` | `browserconfig.xml` | Windows medium tile (Bing) |
| 13 | MS Tile 310 wide | 310×150 | PNG | `/mstile-310x150.png` | `browserconfig.xml` | Windows wide tile |
| 14 | MS Tile 310 | 310×310 | PNG | `/mstile-310x310.png` | `browserconfig.xml` | Windows large tile |
| 15 | Safari pinned tab | vectoriel monochrome | SVG | `/safari-pinned-tab.svg` | `<link rel="mask-icon" href="/safari-pinned-tab.svg" color="#HEX">` | Safari macOS pinned tabs |
| 16 | Theme color | — | hex | — | `<meta name="theme-color" content="#HEX">` | Mobile browser chrome |
| 17 | MS application tile color | — | hex | — | `<meta name="msapplication-TileColor" content="#HEX">` | Windows tile background |
| 18 | MS browserconfig ref | XML | XML | `/browserconfig.xml` | `<meta name="msapplication-config" content="/browserconfig.xml">` | Windows tiles config |
| 19 | Web manifest | JSON | JSON | `/site.webmanifest` ou `/manifest.json` | `<link rel="manifest" href="/site.webmanifest">` | PWA / Android |
| 20 | OG image (social) | 1200×630 | PNG/JPG | `/og-image.png` | `<meta property="og:image" content="/og-image.png">` + `<meta name="twitter:image" content="/og-image.png">` | Facebook, LinkedIn, Twitter, Slack preview |

---

## 2. Fichier site.webmanifest minimal (à adapter)

```json
{
  "name": "[Nom du projet]",
  "short_name": "[NomCourt]",
  "icons": [
    { "src": "/android-chrome-192x192.png", "sizes": "192x192", "type": "image/png" },
    { "src": "/android-chrome-512x512.png", "sizes": "512x512", "type": "image/png" },
    { "src": "/maskable-icon-512.png", "sizes": "512x512", "type": "image/png", "purpose": "maskable" }
  ],
  "theme_color": "#HEX",
  "background_color": "#HEX",
  "display": "standalone",
  "start_url": "/"
}
```

## 3. Fichier browserconfig.xml minimal (à adapter)

```xml
<?xml version="1.0" encoding="utf-8"?>
<browserconfig>
  <msapplication>
    <tile>
      <square70x70logo src="/mstile-70x70.png"/>
      <square150x150logo src="/mstile-150x150.png"/>
      <wide310x150logo src="/mstile-310x150.png"/>
      <square310x310logo src="/mstile-310x310.png"/>
      <TileColor>#HEX</TileColor>
    </tile>
  </msapplication>
</browserconfig>
```

---

## 4. Vérification automatisable (script bash)

```bash
#!/bin/bash
# Vérifie que les 20 items favicon sont présents
PUB="${1:-public}"
MISS=0
for f in favicon.ico favicon.svg favicon-16x16.png favicon-32x32.png favicon-48x48.png favicon-96x96.png apple-touch-icon.png android-chrome-192x192.png android-chrome-512x512.png maskable-icon-512.png mstile-70x70.png mstile-150x150.png mstile-310x150.png mstile-310x310.png safari-pinned-tab.svg site.webmanifest browserconfig.xml og-image.png; do
  [ -f "$PUB/$f" ] || { echo "MANQUE: $PUB/$f"; MISS=$((MISS+1)); }
done

# Vérifie balises HTML head (adapter chemin index.html)
HTML="${2:-public/index.html}"
for tag in 'rel="icon"' 'apple-touch-icon' 'theme-color' 'manifest' 'og:image' 'twitter:image' 'msapplication-TileColor' 'msapplication-config' 'mask-icon'; do
  grep -q "$tag" "$HTML" || { echo "BALISE MANQUE: $tag dans $HTML"; MISS=$((MISS+1)); }
done

[ $MISS -eq 0 ] && echo "✓ Favicon coverage 20/20 PASS" || echo "✗ Favicon coverage : $MISS items manquants"
```

---

## 5. Génération automatique recommandée

Outils pour générer les 18 fichiers à partir d'un seul SVG source :
- **realfavicongenerator.net** (gratuit, web) — recommandé, génère tous les formats + balises
- **favicon-generator npm** — pour CI/CD
- **sharp + svg2png** (Node.js) — pour intégration custom

Source ideale : SVG carré, marges internes 10%, lisible à 16×16 (test obligatoire avant génération).

---

## 6. Quand utiliser cette checklist

- **Phase 0/1** : @design produit le SVG source + palette theme-color
- **Phase 2** : @fullstack génère les 18 fichiers + intègre les balises HTML head
- **Phase 5 (pre-launch)** : @qa exécute le script §4 → gate G31 PASS/FAIL

---

**Référence** : Standards 2026 (Google Search Central, Apple HIG, Microsoft Edge docs, web.dev PWA).
**Maintenance** : revoir annuellement si Google modifie ses exigences SERP (favicon 48×48 minimum depuis 2022).
