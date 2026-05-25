# Le plan pour que le système marche pour Thomas

## Ce que Thomas dit (sa phrase, pas une reformulation)

> "Fais travailler l'équipe pour que j'aie un vrai plan d'un système fonctionnel qui marche pour moi, et itère-le jusqu'à 10/10."

## Ce qui ne marche plus aujourd'hui (en 5 phrases max)

Tu envoies un brief, l'orchestrateur lit 2 100 lignes de protocole avant de te répondre. Quand un livrable revient, il fait 800 lignes, des H1/H2 numérotés, des A/B/C, et tu scrolles sans lire. Quand tu signales un bug, on te demande de confirmer au lieu de corriger. Quand on a corrigé, on dit "fait" sans Grep et tu trouves le mot inchangé. Tu voulais une équipe, on t'a livré un guichet. Tu voulais du plaisir, on t'a livré du process.

## Ce qui ne change pas

- Les 7 commandements de `CLAUDE.md` (le coeur, déjà testé).
- Les agents que tu utilises vraiment : orchestrator, fullstack, reviewer, elon, ia, qa, agent-factory, creative-strategy, copywriter, design, data-analyst.
- La règle brief-first (existe déjà L15-25 orchestrator.md, on l'applique vraiment au lieu de l'ignorer).
- Tes préférences `founder-preferences.md` — source de vérité intouchée.

## Le plan (3 décisions, pas 30 actions)

### Décision 1 — Tailler 671 lignes du protocole, sans débat

**Ce qu'on fait** : on applique la cure @elon chiffrée (chemins + numéros de ligne fournis), pas l'audit @ia plus prudent (-42%). Les chiffres @elon sont actionnables ligne à ligne, @ia donne des cibles globales.
**Concrètement** :
- `orchestrator.md` L97-168 + L274-340 + L378-600 : préambule session counter + boucle Plan→Execute→Verify + 14 phases → supprimé (-459L)
- `_base-agent-protocol.md` L56-68, L178-199, L248-305, L386-445 : calibration, désaccord en doublon, PVU, versioning → supprimé (-200L)
- `_gates.md` : G16, G18, G22, G23, G27-G32 + tout le système GP1-GP10 / GC1-GC10 (déjà documentés comme "indulgents") → 32 gates devient 8 (-90L)
- `orchestrator-reference.md` : fusionné dans `orchestrator.md` (-325L), seul le mapping `subagent_type` survit
- `lessons-learned` : on garde le fichier, on supprime le protocole de propagation P0 (-15L)

**Effort** : M (4-6h, suppression chirurgicale, pas réécriture)
**Tu le verras à** : `wc -l CLAUDE.md _base-agent-protocol.md _gates.md orchestrator.md` divisé par ~2 dès la prochaine session.

### Décision 2 — Brief-first absolu, plus jamais une question avant un livrable

**Ce qu'on fait** : règle dure dans `CLAUDE.md` — l'orchestrateur ouvre TOUTE réponse par "Brief compris : ... / Plan : ..." AVANT tout Read, Grep, Task. Pas de question de cadrage si un défaut évident existe dans `founder-preferences.md`. Pas de menu A/B/C en ouverture.
**Concrètement** :
- Ajouter commandement 0 dans `CLAUDE.md` : "Première ligne de toute réponse = `Brief compris : <reformulation>` + `Plan : <3 puces max>`. Aucune lecture avant."
- Supprimer dans `orchestrator.md` les sections "clarification" / "priorisation 3 variables" / "Variable 1/1b/1c" (L378-479) — on tranche, on ne questionne pas
- Supprimer @moi (proxy fondateur — Thomas est dans la boucle, le proxy est de la masturbation framework). @ia recommandait la suppression. Le livrable @moi de ce matin est utile UNE FOIS, on garde le doc, on supprime l'agent.

**Effort** : S (modification CLAUDE.md + suppression sections orchestrator.md + suppression agent)
**Tu le verras à** : ton prochain brief de 3 mots — réponse en < 30 secondes avec reformulation + plan, zéro question.

### Décision 3 — Preuve par Grep dans chaque livrable, sinon il ne sort pas

**Ce qu'on fait** : chaque agent termine son livrable par un bloc `Vérifié :` qui cite la commande exécutée et son output. Pas de "fait" abstrait. @reviewer rejette automatiquement tout livrable sans bloc Vérifié. C'est le seul gate qui compte (cf. @qa C3 + founder-preferences L60 "vérifier chaque changement après application" + L70 "bugs identifiés = corrigés immédiatement").
**Concrètement** :
- @agent-factory ajoute dans `_base-agent-protocol.md` (section handoff, après ligne "Handoff structuré obligatoire") : "Bloc `Vérifié :` obligatoire. Format : `Read <chemin>` ou `Grep <pattern>` ou `Bash <cmd>` + 3 lignes d'output max."
- @agent-factory réécrit `_gates.md` : 8 gates conservés (G1, G3, G5, G7, G12, G13, G15, G17) + G_PROOF bloquant. Tout le reste supprimé.
- Supprimer Phase 2c/2d/5b (testeur multiples) — un seul reviewer, un seul standard. @qa lui-même ne réclame pas ces testeurs, il réclame le bloc Vérifié (C3). Un reviewer + preuve Grep > 4 testeurs indulgents.

**Effort** : S (1 règle ajoutée, 24 supprimées)
**Tu le verras à** : tu Grep derrière le prochain livrable agent — le mot annoncé "corrigé" est bien corrigé. Tu n'as plus besoin de re-vérifier après 2 sessions.

## Le seul indicateur qui dira si ça a marché

Dans 2 semaines, tu envoies "améliore la landing Sarani" et tu reçois le premier livrable utile en moins de 5 minutes sans avoir répondu à une question de cadrage.

## Ce que je lance dès que tu valides ce plan à 10/10

1. Supprimer dans `orchestrator.md` les lignes L97-168 (préambule session counter + ALERTE ROUGE + self-diagnostic) — résultat : -71L visibles à `wc -l`.
2. Supprimer dans `_gates.md` les gates G16, G18, G22, G23, G27-G32 + tout le bloc GP1-GP10 / GC1-GC10 — résultat : 32 gates devient 8, fichier passe de 121L à ~30L.
3. Supprimer `orchestrator-reference.md` après avoir copié le seul mapping `subagent_type` dans `orchestrator.md` — résultat : -325L, un fichier de moins à maintenir.
4. Supprimer l'agent `@moi` (`.claude/agents/moi.md`) et retirer sa ligne du tableau de routage `CLAUDE.md` — résultat : 22 agents → 21, plus de miroir qui se regarde.
5. Ajouter le commandement 0 "Brief-first absolu" en tête de `CLAUDE.md` (< 5 lignes) et supprimer la règle commune n°10 (`Actions infra dans REPLIT_ACTIONS.md / CLOUDFLARE_ACTIONS.md`) — fusionnée dans les agents @infrastructure et @fullstack, plus besoin de la dupliquer dans CLAUDE.md.

Validation 10/10 = je lance ces 5 actions en parallèle, tu reçois le `wc -l` avant/après en clôture. Pas de validation = on itère sur le plan.
