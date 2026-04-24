# Arbitrage @ia — Décisions audits Versi + @elon — 2026-04-17

Mission : trancher 14 décisions sur ratio Qualité/Performance. Verdicts nets, pas de politesse.

---

## 1. Tableau 14 décisions × verdict

| ID | Décision | Verdict | Q/P | Action exacte |
|---|---|---|---|---|
| D1 | Pattern 3 No Manufacturing Defaults → 4 agents | APPLY | HIGH | Ajouter 1 paragraphe (≤6 lignes) dans `@ia`, `@product-manager`, `@design`, `@copywriter` section "Standard de livraison" |
| D2 | Pattern 5 Persona-Driven Verdicts → règle 5 CLAUDE.md | APPLY | HIGH | Étendre règle 5 (1 ligne) : "GO/NO-GO basé valeur persona, pas ROI/payback humains" |
| D3 | Multi-agent audit convergence → @reviewer | APPLY | MEDIUM | Ajouter section "Convergence protocol" dans `reviewer.md` : si 1er audit < 9/10 ou ≥ 1 gate FAIL → 2-3 itérations parallèles agents complémentaires |
| D4 | Patterns techniques 12-15 → @fullstack + @qa | APPLY | HIGH | 4 lignes dans `fullstack.md` (Tailwind v4 préfixe, Canvas clearRect, Express 5 `/{*splat}`) + 1 dans `qa.md` (Playwright `route.fallback()`) |
| D5 | Pattern 9 Fallback timeout ladder → @orchestrator | APPLY | MEDIUM | Section "Escalade timeout" dans `orchestrator.md` : (1) reduce 50%, (2) typist, (3) manual+audit, (4) escalate. 8 lignes |
| D6 | Pattern 7 Typo/m²/ellipsis → G29 ou nouveau gate | APPLY | HIGH | Enrichir G29 dans `_gates.md` (1 ligne) : "m²/…/œ/espaces insécables FR — pas de m2/.../oe". Pas de nouveau gate |
| D7 | Checklist favicons → Option D | APPLY | HIGH | Créer `docs/checklists/favicon-checklist.md` (20 items, déjà rédigé), gate G31 dans `_gates.md`, refs dans `design.md`/`fullstack.md`/`qa.md` |
| D8 | Versi scoring 10/10 → migration PASS/FAIL | APPLY | HIGH | Note à Thomas dans handoff. Pas de modif framework (Versi doit s'aligner) |
| D9 | Diet protocol 467 → 250 (Elon) vs 400 (moi) | APPLY+DEFER | MEDIUM | **Phase 1 immédiate : 467 → 380** (factoriser duplications gates/protocoles, safe). **Phase 2 différée** : audit empirique des sections non-référencées (grep dans agents) → cible 280. Voir §4 |
| D10 | Cap lessons-learned 50 (Elon) vs 100 (moi) | APPLY | HIGH | **Cap dur 80 lignes** dans `_base-agent-protocol.md`. Compromis : permet P0/P1 actifs + headroom 30%. Voir §4 |
| D11 | Audit orchestrator 883 → 400 | DEFER | LOW | Risque régression massif (54% de coupe sur l'agent le plus appelé). Prérequis : grep sections non-utilisées + test empirique sur 1 projet. Voir §4 / Arbitrage C |
| D12 | Commandement n°8 "Conservation of rules" net-zero | APPLY | HIGH | Ajouter commandement 8 dans `CLAUDE.md` (≤4 lignes) : "Pour toute règle ajoutée en fin de session, une obsolète supprimée ou fusionnée. Net-zero par session." Bump cap 120 → 125 |
| D13 | Context layering par agent | DEFER | MEDIUM | Idée puissante mais nécessite refacto architecturale (qui lit quoi). Faire APRÈS D9 phase 1 (mesurer si diet suffit). Critère décision : si après D9 phase 1 + D10, perfs toujours dégradées → APPLY D13 |
| D14 | TTL learnings : 3 sessions (Elon) vs trimestriel (moi) | APPLY | MEDIUM | **Hybride : 5 sessions OU 90 jours** (le plus court des deux). Promote-or-archive. Voir §4 |

**Synthèse** : 10 APPLY, 2 DEFER, 1 APPLY+DEFER (D9 en 2 phases), 0 SKIP. Aucun bas ratio identifié.

---

## 2. Ordre d'application séquentiel

Les APPLY ordonnés par dépendances et risque croissant :

1. **D7** (favicon-checklist + G31) — fichier nouveau, zéro risque, débloque @design/@fullstack/@qa
2. **D6** (G29 typo) — 1 ligne, zéro risque
3. **D2** (règle 5 CLAUDE.md) — 1 ligne, débloque persona-driven verdicts
4. **D12** (commandement 8 net-zero) — 4 lignes CLAUDE.md, prérequis culturel pour D9/D10
5. **D10** (cap lessons-learned 80) — applique le commandement 8 immédiatement
6. **D1** (No Manufacturing Defaults × 4 agents) — 4 paragraphes courts
7. **D4** (patterns techniques) — 5 lignes réparties
8. **D5** (fallback ladder @orchestrator) — 8 lignes
9. **D3** (convergence protocol @reviewer) — section dédiée
10. **D14** (TTL hybride 5 sessions/90j) — formaliser dans `_base-agent-protocol.md`
11. **D9 phase 1** (protocol 467 → 380) — refacto safe par factorisation
12. **D8** (signalement Thomas pour Versi) — note dans handoff
13. **DEFER : D9 phase 2, D11, D13** — après mesure empirique post phase 1

---

## 3. Top 3 quick wins (HIGH ratio, < 30 min chacun)

1. **D7 — Favicon checklist + G31** (~20 min) : checklist déjà rédigée dans audit Versi, copy-paste + créer gate + 3 refs. Impact : ne plus jamais oublier de favicon en prod.
2. **D6 — G29 typo enrichi** (~5 min) : 1 ligne dans `_gates.md`. Impact : standardise typo FR sur tous livrables sans coût récurrent.
3. **D12 — Commandement 8 net-zero** (~10 min) : 4 lignes CLAUDE.md + bump cap 125. Impact : CHANGE le réflexe culturel ajout→ajout en ajout↔suppression. Prérequis pour stopper le bloat à la racine.

---

## 4. Différends résolus avec @elon

**D9 — Diet protocol (250 vs 400) → verdict : 380 phase 1, 280 phase 2 différée.**
@elon a raison sur la direction (protocol obèse à 467), mais 250 d'un coup = risque casser des références d'agents non auditées. Phase 1 chirurgicale : factoriser les duplications gates/protocoles → -87 lignes safe (380). Phase 2 : grep empirique des sections jamais référencées par les agents en 10 dernières sessions → coupe vers 280. Mon 400 initial était trop conservateur ; le 250 d'Elon trop radical sans test empirique. **380 → 280 en 2 temps = meilleur ratio Q/P** (gain immédiat sans risque, gain max après mesure).

**D10 — Cap lessons-learned (50 vs 100) → verdict : 80.**
50 force trop d'archivage prématuré (un P0 récent + 3 P1 actifs = déjà 40+ lignes). 100 laisse respirer le bloat. **80 lignes = compromis ratio Q/P optimal** : couvre ~6-8 learnings actifs avec headroom, force arbitrage signal/bruit sans étrangler. Combiné avec D14 TTL, l'archivage devient automatique pas manuel.

**D14 — TTL (3 sessions vs trimestriel) → verdict : hybride 5 sessions OU 90 jours (le plus court).**
3 sessions trop court pour projets long-cycle (Versi à 21 sessions aurait perdu des learnings encore actifs). Trimestriel trop lent (90 jours = 6+ sessions actives sur projet rapide = bloat). **5 sessions OU 90 jours** capture les deux dynamiques : projets rapides (sessions) ET projets dormants (calendaire). Promote-or-archive automatique, zéro audit manuel récurrent.

---

**Handoff → @orchestrator**
- Fichier produit : `/home/user/Agent-Team/docs/reviews/ia-arbitrage-decisions-2026-04-17.md`
- Décisions : 10 APPLY, 2 DEFER (D11, D13), 1 hybride 2-phases (D9). Ordre séquentiel défini §2.
- Quick wins (~45 min total) : D7 + D6 + D12 — à lancer immédiatement.
- Différends Elon résolus : D9=380→280 en 2 phases, D10=80 lignes, D14=5 sessions OU 90j.
- Points d'attention : D11 (orchestrator diet) et D13 (context layering) DOIVENT attendre mesure empirique post D9 phase 1. Ne pas les lancer prématurément.
- Action @agent-factory recommandée : exécuter ordre §2 étapes 1-12. D9 phase 2 + D11 + D13 = nouvelle invocation après mesure.
