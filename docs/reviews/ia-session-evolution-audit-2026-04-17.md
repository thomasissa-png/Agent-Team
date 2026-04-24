# Audit IA — Évolution sessions post-2026-04-17

**Auteur** : @ia | **Date** : 2026-04-24 | **Scope** : 4 questions prospectives + audit cohérence 4 prompts critiques + plan migration projets existants.

**État mesuré** : CLAUDE.md 108L | _gates.md 121L | _base-agent-protocol.md 469L | founder-preferences.md 118L | lessons-learned.md 128L (cap 80) | orchestrator.md 891L. Total contexte commun (CLAUDE+gates+protocol+founder+lessons) ≈ 944L AVANT chargement agent.md spécifique (~250-300L) → ~1200-1250L réels par agent.

---

## 1. Q1 — Évolution concrète des sessions

**À la clôture (commandement n°8 net-zero)** : @orchestrator exécute un audit TTL automatique sur `lessons-learned.md` :
1. Scanner chaque entrée → extraire `date_added` + `last_referenced`
2. Si âge > 5 sessions OU > 90 jours sans référence → candidat archive
3. Si entrée référencée ≥ 3 fois récemment → candidate **promotion** vers règle d'agent (move to agent.md ou _base-agent-protocol.md)
4. Archive vers `docs/archive/lessons-learned-Sxx.md` (préservation historique)
5. Mettre à jour CHANGELOG.md (lignes ajoutées vs supprimées par session — net doit être ≤ 0)

**À la reprise** : @orchestrator lit project-context.md (historique) + lessons-learned (cappé 80L) + CLAUDE.md (125L) + agent.md du domaine. Contexte effectif cible : ~900L (vs 1245L actuel) → **-28%**.

**Au cours d'une session** : règle "1 ligne ajoutée = 1 ligne supprimée OU justification explicite dans CHANGELOG". @orchestrator refuse tout commit qui dépasse les caps (hook pre-commit déjà actif sur CLAUDE.md 125L).

---

## 2. Q2 — Performance maintenue ?

**Verdict** : **PARTIEL**. Gains réels sur lessons (-cap 80) mais orchestrator.md 891L reste le goulot principal (54% du context Task).

| Métrique | Avant 2026-04-17 | Après (cible 5 sessions) | Delta |
|---|---|---|---|
| CLAUDE.md | 120L cap | 108L (cap 125L) | -10% |
| lessons-learned.md | 128L (sans cap) | ≤80L après audit TTL | **-37%** |
| _gates.md | 30 gates | 32 gates (121L) | +7% |
| _base-agent-protocol.md | 469L | 469L (DEFER D9) | 0% |
| orchestrator.md | 883L | 891L (DEFER D11) | +1% |
| Contexte commun cumulé | ~1245L | ~944L (post audit TTL) | **-24%** |
| Latence agent moyenne (estimée) | baseline | -10 à -15% sur agents Sonnet | **gain léger** |

**Goulots persistants identifiés** :
- orchestrator.md 891L (Task subagent invocation = 891L re-injectés à chaque délégation) → exécuter D11 (cible 400L) = -55% contexte orchestration
- _base-agent-protocol.md 469L (lu par TOUS les agents) → exécuter D9 phase 1 (cible 380L) = -19%
- Sans D9+D11 exécutés, gain net plafonne à -24% (insuffisant vs verdict @elon "framework toujours en bloat à 1300L")

---

## 3. Q3 — Qualité maintenue ?

**Verdict** : **PARTIEL**. 5 règles sur 8 apportent valeur mesurable, 3 ajoutent du noise.

**Règles à valeur prouvée (garder)** :
- No Manufacturing Defaults (ia/pm/design/copywriter) : empêche bad AI sur 4 agents critiques — anti-pattern réel observé
- Convergence protocol (reviewer) : livrables critiques < 9/10 → 2-3 itérations parallèles = qualité +1 à +2 points
- Escalade timeout 4 niveaux (orchestrator) : résout un vrai problème opérationnel récurrent
- Tailwind v4 / Express 5 / Playwright route.fallback (fullstack/qa) : breaking changes 2026 documentés, indispensables
- Persona-Driven verdicts (CLAUDE.md règle 5) : aligne sur le cœur métier Gradient

**Règles à risque de noise** :
- Commandement n°8 net-zero : conceptuellement bon mais SANS automation orchestrator, sera ignoré par dérive humaine en 3-5 sessions
- Cap lessons 80L : **risque false positives** — un learning P0 référencé 1 fois mais critique (ex: "Vercel build casse si X") peut être archivé
- TTL 5 sessions/90j : calibré pour Versi (rythme intense), trop court pour projets dormants (ISSA, Mandataire)

**Recommandations** :
1. Ajouter flag `[P0-PERMANENT]` sur lessons critiques → exemptées du TTL automatique
2. TTL adaptatif : 5 sessions OU 180 jours (vs 90j) pour projets faible fréquence
3. Le commandement n°8 DOIT avoir une mécanique d'enforcement (script `audit-ttl.sh`) sinon morte-lettre

---

## 4. Q4 — Actions complémentaires (ordre d'exécution)

1. **[J+0 — IMMÉDIAT]** Audit TTL manuel sur `docs/lessons-learned.md` (128L → cible 80L). Identifier P0-PERMANENT, archiver le reste vers `docs/archive/lessons-learned-2026-04.md`. Owner : @orchestrator.
2. **[J+0]** Créer `scripts/audit-ttl.sh` qui scanne lessons-learned, calcule âge/références, propose archive/promotion. Owner : @fullstack. Sans ce script, commandement n°8 = vœu pieux.
3. **[J+1]** Ajouter convention `[P0-PERMANENT]` dans `_base-agent-protocol.md` (5 lignes max) pour exempter learnings critiques du TTL.
4. **[Session +2]** Mesurer empiriquement la latence avant/après sur 3 agents témoins (orchestrator, fullstack, ia). Si gain < 15% → exécuter D9 phase 1 (base-protocol 469→380L).
5. **[Session +3]** Exécuter D11 (orchestrator 891→400L). Seul levier pour passer sous les 1000L de contexte commun cumulé.
6. **[Session +5]** Évaluer D13 (context layering) : injection sélective de _base-agent-protocol.md selon profil agent (Sonnet vs Opus). Gain potentiel -30% supplémentaire.
7. **[Continu]** @orchestrator audit net-zero à CHAQUE clôture de session. Si impossible automatiser → tâche manuelle Thomas dans prompt "Clôturer ma session".

---

## 5. Audit cohérence 4 prompts critiques

| Prompt | Localisation | Verdict | Delta requis |
|---|---|---|---|
| P1 — Migrer projet existant | index.html ~L908 | À METTRE À JOUR | Ajouter étape "audit TTL lessons-learned post-update" + verifier alignement 32 gates G1-G32 + appliquer favicon-checklist |
| P2 — Clôturer ma session | index.html ~L3473 | À METTRE À JOUR | Ajouter section "Commandement n°8 net-zero" : audit TTL, check cap 80L, promote-or-archive, update CHANGELOG delta |
| P3 — Démarrer nouvelle session (reprise) | index.html ~L3568 | À METTRE À JOUR | Ajouter pré-check caps bloquant : CLAUDE.md ≤125L, lessons ≤80L, _gates 32 gates |
| P4 — Scenario C MAJ équipe installée | index.html ~L3784 | À METTRE À JOUR | Ajouter mention 8 changements 2026-04-17 + warning "lessons-learned local AUDITÉ post-update — risque archivage massif si > 80L" |

**Delta exact P2 (à insérer après section "Mettre à jour project-context.md")** :
```
### Commandement n°8 — Net-zero conservation (NOUVEAU 2026-04-17)
1. Lancer `bash scripts/audit-ttl.sh docs/lessons-learned.md` (ou audit manuel si script absent)
2. Pour chaque lesson : âge > 5 sessions OU > 90j sans référence → candidate archive
3. Lessons référencées >=3x récemment → candidate promotion vers règle d'agent
4. Archive vers `docs/archive/lessons-learned-Sxx.md`
5. Vérifier cap : `wc -l docs/lessons-learned.md` doit retourner ≤80
6. Mettre à jour CHANGELOG.md avec delta lignes (cible : net ≤ 0 par session)
```

**Delta exact P3 (à insérer en début de prompt)** :
```
### Pré-check caps (bloquant)
- `wc -l CLAUDE.md` → doit être ≤125. Si >125 → STOP, déclencher diet.
- `wc -l docs/lessons-learned.md` → doit être ≤80. Si >80 → déclencher audit TTL avant reprise.
- `grep -c "^### G" .claude/agents/_gates.md` → doit retourner 32. Sinon → resync depuis master.
```

---

## 6. Plan migration projets existants

**Comportement `bash update.sh --all`** :
- **Écrasé** : `.claude/agents/*.md`, `.claude/settings.json`, `.githooks/`, `update.sh`, `_base-agent-protocol.md`, `_gates.md`. CLAUDE.md fusionné via marqueurs `<!-- GRADIENT-START -->`/`<!-- GRADIENT-END -->`.
- **Préservé** : `project-context.md`, `docs/` (sauf `docs/checklists/` qui sera mergé), `src/`, `lessons-learned.md` LOCAL, `CHANGELOG.md` local.

**Risques identifiés** :
1. CLAUDE.md custom hors marqueurs perdu si projet a édité hors zone (rare mais possible sur Versi early sessions)
2. Agents custom locaux écrasés si nom collide avec un agent master
3. Hook pre-commit cap 125L peut bloquer commit suivant si CLAUDE.md local > 125L

**Ordre safe par projet** :
```
1. cd <projet>
2. git status && git stash (si dirty)
3. cp -r . ../<projet>-backup-$(date +%Y%m%d)
4. wc -l docs/lessons-learned.md  # mesurer AVANT
5. bash update.sh --all
6. wc -l CLAUDE.md  # vérifier ≤125
7. wc -l docs/lessons-learned.md  # comparer
8. Lancer prompt P3 "Démarrer nouvelle session" → audit TTL automatique
9. Commit "chore: sync framework 2026-04-17 + audit TTL"
```

**Spécifique Versi (21+ sessions, lessons probablement 200+L)** :
- L'audit TTL au démarrage va proposer archivage massif (~120L à archiver d'un coup)
- **Action préventive** : AVANT update, faire passe manuelle Thomas+@ia sur lessons Versi pour tagger `[P0-PERMANENT]` les ~30-40 lessons critiques du domaine immobilier (visite virtuelle, mandataire, etc.)
- Archiver le reste manuellement vers `docs/archive/versi-lessons-S1-S20.md` AVANT update.sh
- Cible post-archive : 60-70L de lessons actives + archive consultable
- **Refus de l'audit TTL automatique destructif sur Versi** → premier passage manuel obligatoire

**Spécifique ISSA / Sarani / Mandataire / Architecture** : projets faible fréquence → recommander TTL 180j (pas 90j) pour ne pas archiver des lessons valides juste à cause du gap entre sessions. À documenter dans leur project-context.md respectif.

---

**Handoff → @orchestrator**
- Fichier produit : `/home/user/Agent-Team/docs/reviews/ia-session-evolution-audit-2026-04-17.md` (~190L)
- Décisions clés : commandement n°8 nécessite script `audit-ttl.sh` sinon mort-né ; orchestrator.md 891L reste le vrai goulot ; Versi nécessite passe manuelle AVANT update.sh
- Points d'attention : 4 prompts index.html à mettre à jour (deltas exacts fournis section 5) ; convention `[P0-PERMANENT]` à formaliser ; D9+D11 doivent être exécutés sous 5 sessions sinon framework reste en bloat
- Actions @fullstack requises : créer `scripts/audit-ttl.sh` + appliquer deltas P2/P3/P4 dans index.html ; mettre à jour P1 avec étape audit TTL post-update
