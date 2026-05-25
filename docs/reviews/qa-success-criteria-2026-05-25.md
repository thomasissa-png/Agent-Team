# Critères de succès — un framework qui marche pour Thomas

## Préambule

Ce que je teste : pas la conformité technique, le ressenti. Si Thomas ne sent pas un critère ci-dessous dans une session normale, le framework a échoué — même si les 32 gates sont au vert et que perf-trend.sh dit OK. Un test qui ne peut pas échouer est un test inutile : chaque critère a donc son signal d'échec opposé, formulé pour qu'on ne puisse pas se mentir.

## Les 7 critères

### C1 — La 1ère ligne te dit où je vais
**Tu le verras :** ma toute première ligne de réponse, sur TOUT brief que tu m'envoies (même 3 mots), commencera par "Brief compris : ..." suivie de "Plan : ...". Avant tout Read, tout Grep, toute Task. Si je n'ai pas compris, je te le dis là, pas après 15 minutes de lecture.
**Quand :** dès ton premier message de la session, et à chaque nouveau brief ensuite.
**Signal d'échec :** ma réponse commence par "Je vais lire", "Laisse-moi vérifier", "Avant tout je dois...", ou par un Read direct sans reformulation. Tu te dis "il ne sait pas ce que je veux".

### C2 — Tu n'as pas à reformuler 2 fois
**Tu le verras :** quand tu corriges ma reformulation, je l'intègre et j'avance. Pas de "tu peux préciser ?" derrière. Si ma reformulation est juste, tu ne dis rien — tu valides en silence et on passe à la suite.
**Quand :** dans les 2-3 premiers échanges d'une session.
**Signal d'échec :** tu te retrouves à écrire le même brief sous une autre forme. Tu utilises les mots "non, je veux dire...", "encore une fois...", "comme je disais...". Trois reformulations sur la même demande = framework cassé sur cette session.

### C3 — Tu peux partir et revenir sans re-vérifier mon travail
**Tu le verras :** chaque livrable d'agent qui te revient contient un bloc "Vérifié : [Read X | Grep Y | Bash Z avec sortie]" qui dit exactement où la chose a été testée, en live ou en statique. Pas "tests verts" abstrait — un chemin de fichier, une commande, une sortie. Si tu lances la même commande, tu obtiens le même résultat.
**Quand :** à la livraison de chaque agent (orchestrator inclus quand il consolide).
**Signal d'échec :** tu fais un Grep ou un Read derrière moi et tu trouves un écart entre ce qui est annoncé et ce qui est réel. Ou pire : tu reçois "fait" sans aucun chemin vérifiable. Une seule occurrence = on revient sur le critère.

### C4 — Quand tu signales une frustration, je l'entends au 1er mot
**Tu le verras :** dès que tu écris "frustré", "encore", "comme avant", "ça ne va pas", "tu fais à moitié" — ma réponse est "Compris, je traite ça avant", suivie de l'action. Pas de défense, pas de 5 hypothèses, pas de "voici pourquoi". Action immédiate, explication plus tard si tu la demandes.
**Quand :** dès l'apparition d'un mot d'irritation dans ton message.
**Signal d'échec :** je commence par "Je comprends que...", "Effectivement...", "Plusieurs raisons peuvent expliquer...". Tu sens un agent qui se défend. Tu te dis "il ne m'écoute pas, il se justifie".

### C5 — Mes livrables se lisent en 2 minutes
**Tu le verras :** un plan, un audit, une revue — tous calibrés 80-120 lignes max par défaut. Phrases courtes. Exemples concrets, pas de méta-discours. Pas de TL;DR ni de verdict GO/NO-GO académique sauf si tu l'as demandé. Si un sous-agent rend de l'académique, orchestrator le renvoie avant que ça t'arrive.
**Quand :** à chaque livrable docs/reviews/, docs/qa/, audit ou plan.
**Signal d'échec :** tu ouvres le doc, tu vois un sommaire, des H1/H2/H3 numérotés, des verdicts pondérés, et tu te dis "dissertation". Tu scrolles sans lire. Ou tu fermes le doc et tu redemandes en français.

### C6 — Je tranche au lieu de te servir un menu
**Tu le verras :** zéro question A/B/C en ouverture quand un défaut évident existe (cf. founder-preferences.md). Je choisis, je dis pourquoi en 1 ligne, tu corriges si besoin. Les seules questions que je te pose : décisions irréversibles avec deux options vraiment équivalentes, ou information business que je n'ai pas (tu refuses qu'on invente).
**Quand :** sur toute décision technique, structurelle ou de scope dans une session.
**Signal d'échec :** tu reçois un message qui se termine par 3 questions et 0 décision. Tu dois choisir à ma place sur quelque chose que j'aurais pu trancher. Tu te dis "je gère un junior qui demande la permission de respirer".

### C7 — Le framework rétrécit quand on apprend, il ne grossit pas
**Tu le verras :** à la fin d'une session où on a ajouté une règle, une autre a été supprimée ou fusionnée. CLAUDE.md reste ≤ 125 lignes, lessons-learned.md ≤ 80, project-context.md hors historique ≤ 250. Si quelque chose pèse, on coupe — on ne l'enrobe pas d'une nouvelle exception.
**Quand :** à chaque clôture de session impliquant un learning ou un patch protocole.
**Signal d'échec :** tu ouvres CLAUDE.md ou un .md d'agent et tu te dis "c'est encore plus long que la dernière fois". Le compteur de lignes a augmenté en net sur la session. Ou pire : une règle ajoutée pour réparer un incident reste en place 5 sessions après, sans qu'elle ait évité un seul incident.

## Comment on évite l'auto-tromperie

La tentation va être de cocher "ça marche" parce que la session s'est bien passée. Trois questions pour challenger l'orchestrator à la fin de CHAQUE session :

1. **"Combien de fois j'ai dû reformuler dans cette session ?"** Si la réponse est ≥ 2 sur le même sujet, C1 ou C2 a cassé.
2. **"Sur les livrables que j'ai reçus, combien j'ai vérifiés derrière ?"** Si tu as vérifié et trouvé un écart, C3 a cassé. Si tu n'as pas eu envie de vérifier, c'est bon signe.
3. **"Le compteur de lignes du framework a-t-il monté ou descendu ?"** Si monté sans justification de net-zero, C7 a cassé. À demander à l'orchestrator en clôture, vérifiable en 30 secondes via git diff.

Si l'orchestrator te dit "tout va bien" mais ne peut pas répondre concrètement à ces 3 questions, le framework ne marche pas — il fait semblant.

## Test global

Si à la fin d'une session Thomas peut dire **"j'ai travaillé avec mon équipe, pas avec un guichet — et je n'ai rien eu à re-vérifier"**, le framework marche.
