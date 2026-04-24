# Audit prospectif post-session 2026-04-17 — IA Engineer

**Date** : 2026-04-24
**Auteur** : @ia
**Périmètre** : impact des changements structurels sur sessions futures + cohérence prompts + migration équipes existantes
**Verdict global** : PARTIEL — direction correcte, exécution à compléter (3 actions P0 manquantes)

---

## 1. Q1 — Évolution concrète des sessions

### Workflow attendu (commandement n°8 net-zero)

**À la clôture (par @orchestrator)** :
1. Audit TTL : scanner `lessons-learned.md`, identifier entrées > 5 sessions OU > 90 jours
2. Promote-or-archive : promouvoir en règle agent.md si réoccurrente, sinon archiver dans `lessons-learned-archive.md`
3. Vérifier net-zero : si N lignes ajoutées dans CLAUDE.md/agents → N lignes supprimées ailleurs
4. Vérifier caps : CLAUDE.md ≤ 125, lessons-learned ≤ 80, _gates.md drift sous contrôle

**À la reprise (par @orchestrator)** :
- Lit : project-context.md (~120L) + CHANGELOG dernier bloc (~30L) + lessons-learned (≤ 80L) = **~230L de contexte effectif**
- Ne re-lit PAS : full _base-agent-protocol.md (469L) — chargement à la demande par les sous-agents

**En cours de session** :
- Tout agent qui ajoute une règle DOIT proposer la suppression équivalente (header "NET-ZERO PROPOSAL")
- @reviewer bloque les livrables qui violent net-zero sans justification

### Verdict Q1
Workflow viable MAIS dépend d'une exécution disciplinée par @orchestrator. Le commandement n°8 doit être OPÉRATIONNALISÉ par un script ou un sous-agent dédié — sinon dérive garantie sous 3 sessions.

---

## 2. Q2 — Performance maintenue ?

### Mesures (lignes de contexte chargées par agent)

| Métrique | Avant 2026-04-17 | Après 2026-04-17 | Cible T+5 si net-zero | Delta |
|---|---|---|---|---|
| CLAUDE.md | 100 | 108 | ≤ 125 | +8 |
| _gates.md | 113 | 121 | 121 (cap libre) | +8 |
| lessons-learned.md | 132 (briefing) / **128 mesuré** | 128 | **80** | -48 (audit P0) |
| _base-agent-protocol.md | 467 | 469 | 380 (D9) | +2 actuel |
| orchestrator.md | 883 | 891 | 400 (D11) | +8 actuel |
| founder-preferences.md | 118 | 118 | 118 | 0 |
| **Total contexte commun** | **1809** | **1835** | **1124 (-39%)** | +26 actuel |

### Goulots persistants identifiés
- **orchestrator.md 891L = 48% du contexte commun** — chaque délégation Task paie ce coût
- **_base-agent-protocol.md 469L = 26%** — chargé par tous les agents
- Net-zero seul ne suffit pas : sans D9/D11 exécutés, T+5 = 1865L (régression).

### Verdict Q2
**PARTIEL**. La perf à T+0 est dégradée (+26L net). La cible T+5 (-39%) n'est atteignable QUE si D9 + D11 sont déclenchés ET audit TTL exécuté. Sans ça → bloat continue.

---

## 3. Q3 — Qualité maintenue ?

### Analyse des 8 nouvelles règles

| Règle | Valeur ajoutée | Risque noise | Verdict |
|---|---|---|---|
| Persona-Driven verdicts (cmd 5) | Haute — corrige biais ROI | Faible | KEEP |
| Conservation of rules (cmd 8) | Haute — anti-bloat structurel | Faible | KEEP |
| No Manufacturing Defaults (4 agents Sonnet) | Haute — bloque outputs IA-looking | Moyen (duplication 4x) | KEEP mais factoriser dans _base-agent-protocol |
| G31 Favicon REQUIS | Moyenne — vrai gap 2026 | Faible | KEEP |
| G32 Typographie FR CONDITIONNEL | Moyenne | Faible | KEEP |
| Tailwind v4 / Canvas / Express 5 | Haute — bugs réels | Faible | KEEP |
| Playwright route.fallback() | Haute — bug réel intercepté | Faible | KEEP |
| Convergence protocol reviewer | Haute sur livrables critiques | Coût tokens 2-3x | KEEP avec gating strict (uniquement < 9/10) |

### Risques cap lessons-learned 80L
- **False positive probable** : 132 → 80 = 52 lignes à archiver. Si entrées P0 actives sont dans le lot → régression qualité.
- **Mitigation obligatoire** : audit TTL doit scorer par PRIORITÉ (P0 jamais archivé même si > 90j) avant ARCHIVE.

### TTL 5 sessions / 90 jours
- Calibration acceptable pour learnings P1/P2.
- **Trop court pour P0** : un learning P0 qui ne se redéclenche pas pendant 90j peut être un GARDE-FOU silencieux. Recommandation : exempter P0 du TTL automatique.

### Verdict Q3
**OUI avec 2 corrections** : (a) exempter P0 du TTL automatique, (b) factoriser "No Manufacturing Defaults" dans `_base-agent-protocol.md` pour éviter duplication 4x.

---

## 4. Q4 — Actions complémentaires (priorisées)

| # | Action | Priorité | Exécutant | Trigger |
|---|---|---|---|---|
| 1 | Audit TTL lessons-learned (132 → 80L) avec exemption P0 | **P0** | @orchestrator (manuel cette fois) | Maintenant |
| 2 | Créer sous-agent `@ttl-auditor` pour automatiser cmd 8 net-zero à clôture | **P0** | @agent-factory | Avant prochaine session |
| 3 | Exécuter D9 phase 1 (_base-agent-protocol 469 → 380) | **P0** | @orchestrator + @reviewer | Avant T+3 sessions |
| 4 | Exécuter D11 (orchestrator.md 891 → 400 via extraction modules) | **P1** | @orchestrator | Avant T+5 sessions |
| 5 | Factoriser "No Manufacturing Defaults" dans _base-agent-protocol.md (gain 4x duplication) | **P1** | @reviewer | Prochaine session |
| 6 | Mesure empirique : logger latence Task moyenne sur 5 prochaines sessions | **P1** | @data-analyst | Continu |
| 7 | D13 (context layering : core / on-demand / archive) | **P2** | @orchestrator | T+5 si bloat persiste |

**Décision exécutant cmd 8** : @orchestrator manuel pour les 2 prochaines sessions (validation humaine), puis @ttl-auditor automatique une fois testé.

---

## 5. Audit cohérence 4 prompts critiques

| Prompt | Localisation | Verdict | Delta exact requis |
|---|---|---|---|
| P1 — Migrer projet existant | index.html L921 | **À METTRE À JOUR** | Ajouter étapes : (a) "Audit TTL lessons-learned post-update", (b) "Vérifier 32 gates G1-G32", (c) "Appliquer favicon-checklist.md" |
| P2 — Clôturer session | index.html L3486 | **À METTRE À JOUR** | Ajouter bloc "Commandement 8 net-zero" : audit TTL, promote-or-archive, vérif cap lessons 80L, vérif net-zero CLAUDE.md |
| P3 — Démarrer nouvelle session | index.html L3584 | **À METTRE À JOUR** | Ajouter check : "Vérifier CLAUDE.md ≤ 125L, lessons-learned ≤ 80L. Si dépassement → déclencher audit TTL avant toute action" |
| P4 — Scenario C MAJ équipe | index.html L3795 | **À METTRE À JOUR** | Ajouter mention des 8 changements 2026-04-17 + warning "lessons-learned local sera audité contre cap 80L au prochain run" |

### Delta exact P2 (le plus critique) — bloc à insérer

```
ÉTAPE FINALE — Commandement n°8 (Conservation of rules) :
1. @orchestrator scanne lessons-learned.md
2. Pour chaque entrée > 5 sessions OU > 90 jours ET priorité != P0 :
   - Si réoccurrente (≥ 2 mentions sessions différentes) → promouvoir dans agent.md concerné
   - Sinon → déplacer vers lessons-learned-archive.md
3. Vérifier caps : CLAUDE.md ≤ 125L, lessons-learned ≤ 80L
4. Vérifier net-zero : ajouts cette session ≤ suppressions cette session
5. Si violation → bloquer clôture, demander correction
```

### update.sh
**CONFORME** — clone master, pas d'action requise.

---

## 6. Plan de migration projets existants

### Ce qui sera ÉCRASÉ par `bash update.sh --all`
- `.claude/agents/*.md` (tous les agents)
- `.claude/settings.json`
- `CLAUDE.md` (fusionné via marqueurs `<!-- GRADIENT-MANAGED -->`)
- `.githooks/`
- `update.sh` lui-même
- `_base-agent-protocol.md`, `_gates.md`
- `docs/checklists/favicon-checklist.md` (nouveau)

### Ce qui sera PRÉSERVÉ
- `project-context.md` (jamais touché)
- `docs/` métier (specs, livrables agents)
- `src/` (code app)
- `lessons-learned.md` LOCAL au projet (jamais écrasé)
- `CHANGELOG.md` du projet

### Risques de casse identifiés
1. Projets référençant G1-G30 dans leurs livrables → G31/G32 nouveaux, pas de breakage mais audit recommandé
2. CLAUDE.md fusionné : si marqueurs corrompus → conflit. Backup OBLIGATOIRE avant update.
3. Agents customisés localement → écrasés. Vérifier `git status` avant update.

### Ordre safe pour chaque projet client
```
1. cd /chemin/projet && git status (vérifier clean)
2. git checkout -b backup-pre-2026-04-17 && git push
3. git checkout main
4. bash update.sh --all
5. git diff CLAUDE.md (vérifier fusion correcte)
6. Lancer @orchestrator avec prompt "Audit TTL post-update : scanner lessons-learned.md contre cap 80L, exempter P0, archiver le reste"
7. Tester un agent simple (@copywriter sur tâche test) pour valider
8. Si OK → commit, sinon revert via backup branch
```

### Spécifique Versi (21+ sessions, lessons probablement 200+ lignes)
**Risque** : audit TTL agressif pourrait archiver 120+ lignes d'un coup → perte de mémoire opérationnelle.

**Procédure spécifique Versi** :
1. Backup branch obligatoire AVANT update
2. Lire `lessons-learned.md` actuel et **classer manuellement** par P0/P1/P2 si pas déjà fait
3. Audit TTL en mode DRY-RUN d'abord : @orchestrator produit un diff "voici ce que j'archiverais" SANS exécuter
4. Validation humaine Thomas sur le diff
5. Exécution audit avec exemptions explicites pour entrées critiques projet (référencer numéro session)
6. Archive dans `lessons-learned-archive.md` (jamais delete)
7. Vérifier que les patterns récurrents Versi (auth, paiements, data model) sont promus dans `docs/founder-preferences.md` ou agent.md spécifique avant archivage

**Cible Versi post-audit** : 60-80 lignes actives + archive complète préservée.

---

**Handoff → @orchestrator**
- Fichier produit : `/home/user/Agent-Team/docs/reviews/ia-session-evolution-audit-2026-04-17.md`
- Décisions prises : verdict PARTIEL, 7 actions priorisées, 4 prompts à MAJ avec deltas exacts, procédure Versi sécurisée
- Points d'attention : (1) audit TTL lessons-learned 132→80L à exécuter MAINTENANT avec exemption P0, (2) P2 prompt "Clôturer session" est le plus critique à patcher avant toute prochaine clôture, (3) Versi nécessite procédure DRY-RUN obligatoire
