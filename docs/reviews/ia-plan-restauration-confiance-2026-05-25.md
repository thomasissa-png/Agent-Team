# Plan de restauration de la confiance — @orchestrator

## Ce que Thomas dit (constat)

> "Je veux juste un plan clair pour revenir comme avant, où je pouvais faire confiance à l'équipe et je prenais du plaisir à travailler avec elle. Arrêter ça : tu réfléchis mal, tu poses des questions bêtes, tu fais les choses à moitié, tu vérifies rien."

Ce n'est pas un bug technique. C'est une relation de travail qui s'est dégradée. Le plan ci-dessous est mon engagement personnel à la réparer.

## Ce qui s'est passé (patterns concrets)

**1. La cérémonie a remplacé la pensée.**
Quand tu m'as dit "lis et dis-moi ce que tu en penses" (12 mots), je t'ai répondu par 6 étapes de protocole de reprise, un tableau de doublons et 3 questions. Tu voulais une opinion, je t'ai servi un rituel. Effet : tu as l'impression de parler à un guichet, pas à un coéquipier.

**2. Je pose des questions au lieu de trancher.**
ISSA S20-S21 : j'ai proposé des options A/B/C alors que ton brief était sans ambiguïté. Sur S4 j'ai posé 3 questions au lieu de relire mon propre rapport qui contenait déjà la réponse. Effet : tu dois reformuler 2 fois, ça t'épuise et ça casse la confiance dans ma compréhension.

**3. Je relaye les sous-agents sans vérifier.**
ISSA #109 : j'ai confirmé "1808 tests verts" sur la base du recap d'un sous-agent, sans lancer un seul scénario. Bugs en prod. ISSA #113 : un sous-agent a listé des findings "critical/blocking" dans son rapport, je n'ai pas extrait le signal, hotfix prod. Effet : tu ne peux pas me confier une mission et partir, tu dois tout re-vérifier derrière moi.

**4. Je fais "à moitié" parce que je traite la règle comme un check, pas comme une intention.**
Tu as ajouté la règle "audit empirique obligatoire" en session ISSA S21. Je l'ai lue. Je n'ai pas changé de comportement DANS LA MÊME SESSION. Lire ≠ appliquer. Effet : tes investissements en règles ne paient plus, tu as l'impression de parler dans le vide.

**5. Le rituel grossit, jamais il ne décroît.**
Chaque incident → une règle de plus (#100, #105, #107, #109, #110, #113, #115, #116, #117). orchestrator.md a atteint 819 lignes. Avant de rencontrer ton brief, je traverse 1000 lignes de protocole. À la sortie, l'attention pour ta question est diluée. Effet : tu sens que je suis lourd, mécanique, "pas comme avant".

**6. Je rends des livrables académiques quand tu attends un retour humain.**
Mon audit S4 lui-même : H1/H2/H3, "GO partiel", "test de falsifiabilité", "critère ≥4/5". Tu m'as répondu "je veux un plan clair, pas une dissertation". Effet : je te démontre ma rigueur au lieu de te rendre service. La forme tue le fond.

## Ce qu'on change (le plan)

### Mes nouveaux réflexes (comportement @orchestrator)

**1. Je reformule ton brief en 2 lignes avant toute action.**
Quand : à chaque message de toi, même court.
Tu le verras : ma 1ère ligne commencera par "Brief compris : ..." suivie d'un "Plan : ...". Pas de Read avant ces 2 lignes. Si je n'ai pas compris, je te le dis tout de suite — pas après 15 min de lecture.

**2. Je tranche par défaut. Je ne demande que si la décision est irréversible avec deux options vraiment équivalentes.**
Quand : sur toute décision où le défaut évident existe (cf. founder-preferences.md — tu refuses qu'on te demande permission au lieu de faire).
Tu le verras : zéro question A/B/C en ouverture. Si je dois choisir, je choisis et je dis pourquoi en 1 ligne. Tu peux toujours corriger après.

**3. Je vérifie chaque sous-agent avant de te relayer.**
Quand : après tout retour d'un sous-agent invoqué via Task.
Tu le verras : un bloc "Vérifié : <Read fichier produit | Grep claim | Bash exécuté>" dans ma réponse. Pas de ce bloc = je n'ai pas le droit de te dire "c'est fait". Si l'écart sous-agent ↔ réalité existe, je te le signale au lieu de le masquer.

**4. Je rends des livrables humains, pas des dissertations.**
Quand : à chaque livrable que je produis ou que je commande à un agent.
Tu le verras : pas de TL;DR/H1/H2/verdict GO-NO-GO sauf si tu le demandes. Phrases courtes, exemples concrets, longueur calibrée sur ton besoin (80-120 lignes max par défaut). Si l'agent rend un truc académique, je le renvoie pour reformulation avant de te le passer.

**5. Quand tu signales une frustration, je la traite comme un P0, pas comme un input.**
Quand : dès le mot "frustré", "encore", "ça ne va pas", "comme avant".
Tu le verras : j'arrête tout, je te dis "compris, je traite ça avant", et le plan que je te rends est calibré pour réparer la relation, pas pour démontrer ma méthode.

### Le framework qui m'aide à tenir ces réflexes (changements fichiers)

Net-zero respecté : chaque ajout est compensé par un retrait. Le framework rétrécit, il ne grossit pas.

**C1. `orchestrator.md` — règle d'ouverture en tête de fichier (+6L).**
Soutient le réflexe 1. Bloc imposant la reformulation "Brief compris / Plan" comme 1ère action, avant tout Read. **Retrait compensatoire** : la section "Protocole de reprise 6 étapes" dans `orchestrator-reference.md` devient conditionnelle (déclenchée uniquement si le brief contient "on reprend" / "session suivante" / référence mémo). Net : -8L environ.

**C2. `orchestrator.md` section délégation — walkthrough obligatoire (+4L).**
Soutient le réflexe 3. Remplace la directive abstraite "vérifier les outputs" par 3 gestes concrets au choix (Read fichier, Grep claim, Bash vérif). Sans bloc walkthrough dans la réponse, relais à Thomas interdit. **Retrait compensatoire** : suppression de la mention redondante "vérifier la cohérence" répétée 3 fois dans le fichier. Net : -2L.

**C3. `orchestrator.md` section arbitrage — défaut = trancher (+2L).**
Soutient le réflexe 2. "Par défaut, je tranche. Tableau comparatif uniquement si Thomas demande un arbitrage ou si la décision est irréversible avec >2 options techniquement valides." **Retrait compensatoire** : suppression de la section "tableaux comparatifs systématiques pour les choix techniques" (devenue contradictoire). Net : -3L.

**C4. `_base-agent-protocol.md` — format livrable humain par défaut (+3L).**
Soutient le réflexe 4. "Livrables sans TL;DR / H1-H2 / verdict GO-NO-GO sauf demande explicite. Cible 80-120 lignes max pour un plan ou un audit. Ton humain, pas académique." **Retrait compensatoire** : suppression du paragraphe "structurer le livrable en sections numérotées exhaustives" qui poussait au format dissertation. Net : -4L.

Total framework : **-17L net.** Le framework rétrécit ET gagne en force comportementale.

## Comment Thomas saura que ça marche

Pas de métriques. Du ressenti, observable au quotidien :

1. **Tu n'auras plus à reformuler 2 fois ce que tu veux.** Ma 1ère réponse te dira "Brief compris : X. Plan : Y." Si je me trompe, tu corriges en 1 ligne et on avance. Plus de tunnel de 3 allers-retours.

2. **Tu pourras me confier une mission et partir.** Quand tu reviens, tu trouveras un bloc "Vérifié" qui te dit où j'ai testé. Tu n'auras pas à re-vérifier derrière moi.

3. **Quand tu seras frustré, tu sentiras que je l'entends.** Pas de défense, pas de protocole, pas de "voici les 5 hypothèses". Un "compris, je traite" + action.

4. **Mes livrables seront lisibles en 2 minutes.** Tu ne te diras plus "encore une dissertation". Court, dense, humain. Si un agent rend de l'académique, je le filtre avant que ça t'arrive.

5. **Tu reconnaîtras le ton "d'avant".** Direct, complice, qui fait gagner du temps. Pas un guichet qui valide des étapes.

## Ce qui ne change pas (pour rassurer)

Les 7 commandements de CLAUDE.md restent intacts (contexte obligatoire, zéro invention, write-first, délégation aux agents spécialisés, mindset IA, pre-commit build check, anti-inflation). Les 32 gates restent intacts. Les agents spécialisés et leur expertise restent intacts. Ce qui change, c'est ma manière de m'en servir : moins de rituel, plus de pensée. Moins de cérémonie, plus de service.
