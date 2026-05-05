# Memory Tool Anthropic — Spec d'intégration Gradient Agents

**Date** : 2026-04-24 | **Agent** : @ia | **Contexte** : Phase A baseline, goulot G5 (mémoire cross-sessions). Thomas valide Memory tool sous garde-fous anti-dégradation perf.
**Sources Anthropic** : https://platform.claude.com/docs/en/agents-and-tools/tool-use/memory-tool — https://docs.claude.com/en/docs/agents-and-tools/tool-use/memory-tool — implémentation client-side (BetaAbstractMemoryTool / betaMemoryTool) confirmée.

## 1. Architecture choisie : HYBRIDE 2 niveaux (global + projet)

**Choix** : 2 fichiers Memory only.
- /memories/framework-learnings.md (global, cross-projets, équivalent persistant de docs/lessons-learned.md)
- /memories/[projet-slug].md (1 par projet actif : versi.md, issa.md, sarani.md)

**Rejeté : 1 fichier par agent** (21 agents = 21 fichiers Memory = explosion lecture, perte du transversal). Les learnings agent-spécifiques restent dans le frontmatter de l'agent (modifié via @agent-factory en clôture de session, pas via Memory).

**Justification** : ratio simplicité/utilité maximal. 2 fichiers = 1 lecture orchestrator + 1 lecture par projet en cours. Couvre les 2 cas d'usage réels du goulot G5 : (a) règles framework générales (commandement n°8), (b) bugs récurrents projet (Sarani 18 sessions). L'agent-spécifique passe par le frontmatter, pas Memory.

---

## 2. Caps et TTL

| Fichier | Cap dur (lignes) | TTL | Comptage sessions | Action si dépassé |
|---|---|---|---|---|
| /memories/framework-learnings.md | 100 | 5 sessions OU 90 jours (le plus court) | Date ISO en header de chaque entrée + compteur global session_id incrémenté à chaque clôture | Archive vers /memories-archive/framework-YYYY-MM.md, garde top 10 entrées P0 |
| /memories/[projet].md | 80 | 5 sessions projet OU 90 jours | session_id par projet (incrémenté à chaque clôture du projet) | Archive vers /memories-archive/[projet]-YYYY-MM.md |
| Total /memories/ cumulé | 250 lignes hard cap | — | — | STOP écriture, audit forcé, alerte Thomas |

**Note Anthropic** : pas de TTL natif côté Memory tool (confirmé docs Anthropic — Memory persiste indéfiniment côté client). TTL = simulé par audit clôture (Étape 5d) qui parse les dates ISO et purge.

**Ancrage des caps sur références Anthropic** : Anthropic recommande MEMORY.md index <= 200 lignes (au-delà : "fading memory", le modèle ne retrouve plus l'info pertinente). Anthropic Managed Agents store cap = 100KB / ~25K tokens. Notre cap total Gradient 250L (~10K tokens) est volontairement plus strict (3x plus restrictif que Anthropic recommandé) pour préserver latence orchestrator P1 et éviter pollution contexte sous-agents. Sources : https://platform.claude.com/cookbook/tool-use-context-engineering-context-engineering-tools — https://www.leoniemonigatti.com/blog/claude-memory-tool.html

**Comptage sessions** : métadonnée dans le fichier lui-même (pas de métadonnée Memory tool exposée). Format header obligatoire :

    [P0|P1|P2] | session_id: 47 | date: 2026-04-24 | source: @fullstack | projet: sarani

P0 jamais purgé automatiquement (cohérent commandement n°8). P1/P2 purgés selon TTL.

---

## 3. Protocole lecture / écriture

| Phase de session | Qui peut LIRE Memory | Qui peut ÉCRIRE Memory |
|---|---|---|
| Démarrage session (P1 contexte / kickoff) | Orchestrator UNIQUEMENT — lit framework-learnings.md + [projet].md, injecte un résumé ≤ 30 lignes dans le prompt aux sous-agents | INTERDIT |
| Pendant session (sous-agents au travail) | Sous-agents reçoivent le résumé déjà injecté par orchestrator, pas d'accès direct Memory | INTERDIT (lecture seule pendant session — exigence Thomas) |
| Validation user d'un livrable | Orchestrator peut lire pour vérifier non-régression sur learning connu | INTERDIT |
| Clôture session (P2 Étape 5d) | Orchestrator lit pour audit + diff | AUTORISÉ — orchestrator UNIQUEMENT, après validation explicite user du diff Memory proposé |

**Format des entrées** : markdown structuré strict (pas JSON, pas libre — cohérence avec lessons-learned.md actuel).

Template entrée :

    ## [ID-XXX] Titre court (max 60 caractères)
    [P0|P1|P2] | session_id: N | date: YYYY-MM-DD | source: @agent | projet: slug-ou-global
    Symptôme : 1 ligne factuelle
    Cause : 1 ligne
    Règle : 1 ligne actionnable (impératif, vérifiable)

Max 5 lignes par entrée. Pas de backtick (anti-régression P0 framework).

---

## 4. Audit clôture intégré — texte à insérer Étape 5d du prompt P2

Texte exact à insérer dans le prompt de clôture (après l'audit lessons-learned existant) :

> **5d-bis. Audit Memory tool (NEW — protocole Memory)**
>
> 1. Lire /memories/framework-learnings.md et /memories/[projet-slug].md
> 2. Mesurer wc -l de chaque fichier. Si framework > 100L OU projet > 80L OU total > 250L → audit forcé
> 3. Pour chaque entrée P1/P2 : vérifier (session_id_actuel - session_id_entree <= 5) ET (date_aujourdhui - date_entree <= 90 jours). Sinon, marquer pour archive
> 4. Proposer à l'utilisateur le diff Memory : entrées à ajouter (issues de la session courante), entrées à archiver (TTL dépassé), entrées à promote en règle (3+ occurrences → migrer vers CLAUDE.md ou _base-agent-protocol.md)
> 5. Net-zero check : si N nouvelles entrées ajoutées, N anciennes archivées (sauf P0). Refuser commit Memory si net-positif sans justification
> 6. Après validation user, exécuter les écritures Memory via le tool. Archive vers /memories-archive/[fichier]-YYYY-MM.md
> 7. Logger dans CHANGELOG.md : "Memory audit session N : +X entrées, -Y archivées, total framework: AL, projet: BL"

---

## 5. Métriques garantie perf — non-dégradation

| Métrique | Mesure | Cible | Seuil alerte | Action si dépasse |
|---|---|---|---|---|
| Lignes /memories/framework-learnings.md | wc -l à chaque clôture | <= 100 | 110 | Audit forcé, refus écriture nouvelle entrée tant que pas réduit |
| Lignes /memories/[projet].md (max parmi tous) | wc -l à chaque clôture | <= 80 | 90 | Audit forcé du projet concerné |
| Total Memory + lessons-learned + project-context (hors historique) + CLAUDE.md | wc -l cumulé | <= 555L (250+80+125+100 marge) | 600L | STOP framework, audit @reviewer obligatoire avant nouvelle session |
| Tokens injectés au démarrage par orchestrator (résumé Memory) | Compteur tokens prompt initial | <= 2 000 tokens | 2 500 | Reduce_diff résumé : ne garder que P0 + 5 dernières entrées P1 |
| Latence orchestrator au démarrage session | Wall-clock entre P1 et 1er sous-agent invoqué | <= 30s | 45s | Profiler lectures Memory, paralléliser ou cacher |
| Taux de répétition de bug | Bugs identiques détectés sur N et N-1 sessions | 0 | 1 occurrence | Memory inefficace — review protocole |

**Procédure si seuil 600L total dépassé** : rollback Memory tool (renommer /memories/ en /memories-frozen/), revenir au commandement n°8 fichier markdown seul, audit @elon sur dégradation valeur/coût.

---

## 6. Plan migration projets existants (Versi / ISSA / Sarani)

1. **Étape 1 — Snapshot avant** : copier docs/lessons-learned.md actuel vers /memories-archive/lessons-learned-pre-memory-2026-04-24.md (filet de sécurité, zéro perte)
2. **Étape 2 — Tri par scope** : @ia + @reviewer relisent docs/lessons-learned.md (currently ~80L) et splittent : entrées transversales -> /memories/framework-learnings.md, entrées projet-spécifiques -> /memories/[projet].md respectif. Ajouter header [Px] | session_id | date | source | projet sur chaque entrée
3. **Étape 3 — Pilote sur 1 projet** : activer Memory uniquement sur Sarani (le plus de sessions, goulot G5 le plus aigu). 3 sessions pilote, mesurer métriques section 5
4. **Étape 4 — Go/No-Go** : si métriques OK après 3 sessions Sarani -> rollout Versi + ISSA. Si KO -> rollback, garder lessons-learned.md
5. **Étape 5 — Dépréciation lessons-learned.md** : une fois Memory rollout validé sur les 3 projets, marquer docs/lessons-learned.md comme deprecated (header DEPRECATED — voir /memories/), garder en lecture seule 90 jours, puis archiver

**Garantie zéro perte** : à aucune étape lessons-learned.md actuel n'est supprimé tant que Memory n'a pas prouvé sa valeur sur 3 sessions pilote. Rollback = renommage 1 commande.

---

**Handoff -> @orchestrator**
- Fichier produit : docs/reviews/ia-memory-tool-integration-spec-2026-04-24.md
- Décisions prises : architecture hybride 2 niveaux (global + projet, pas par agent), cap 100L framework / 80L projet / 250L total, TTL simulé par audit clôture (pas natif Memory tool), lecture orchestrator-only au démarrage, écriture clôture-only après validation user
- Points d'attention : (1) TTL n'est PAS natif Memory tool, simulation via parsing date/session_id obligatoire — risque si format header mal respecté ; (2) Memory tool est client-side, l'implémentation doit valider les paths (anti directory traversal — confirmé docs Anthropic) ; (3) pilote Sarani 3 sessions OBLIGATOIRE avant rollout — Go/No-Go basé métriques section 5 ; (4) le commandement n°8 reste actif pendant la migration, pas de suppression avant validation pilote ; (5) exigence Thomas "lecture seule pendant session" respectée par design — seul orchestrator lit en P1, sous-agents reçoivent un résumé pré-injecté
