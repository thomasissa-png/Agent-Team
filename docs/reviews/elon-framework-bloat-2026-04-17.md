# Framework Bloat Audit — Gradient Agents est-il devenu son propre goulot ?

> AVIS CONSULTATIF — Elon, 2026-04-17. Thomas décide.

## 1. Verdict hypothèse Thomas

**FONDÉE.** Le framework a pris 100% de masse en 30 jours (_base-agent-protocol.md : 250→467 lignes) sans suppression équivalente. C'est l'inverse du principe SpaceX "the best part is no part" : on ajoute des règles en réaction à chaque incident, jamais on n'en retire. Résultat mécanique : chaque agent dépense plus de tokens en "comprendre les règles" qu'en "produire de la valeur". Les learnings ne rendent pas les agents cons — ils les noient.

## 2. Diagnostic 3 angles

**Angle 1 — Delete, delete, delete.** Gradient ne respecte PAS ce principe. En 30 jours : +217 lignes de protocol, +125 lignes de lessons-learned, +118 lignes de founder-prefs. Suppressions : ~zéro documentée. À Tesla quand on a viré 80% du câblage du Model Y, on n'a pas "ajouté une note de service" — on a supprimé les pièces. Ici c'est l'inverse : on empile les post-it jaunes sur le tableau de bord. Cause fondamentale : biais d'ajout (Adams et al., "less is more" bias) + flatterie IA (l'agent qui ajoute une règle "montre qu'il a appris", l'agent qui en supprime une n'est pas récompensé).

**Angle 2 — Signal vs Noise.** 1300 lignes de règles avant de commencer = c'est pas un framework, c'est une bureaucratie. Comparaison : un pilote de chasse F-35 a une checklist pré-vol de ~30 items. Un chirurgien cardiaque : checklist WHO 19 items, qui a réduit la mortalité de 47%. Toyota Production System tient sur 14 principes. Un agent qui doit intégrer 1300 lignes avant d'agir n'est pas mieux calibré — il est dilué. L'attention est une ressource rare même avec 1M de context window. Plus de règles ≠ meilleurs outputs. Courbe en U : au-delà d'un seuil, chaque règle ajoutée dégrade la perf.

**Angle 3 — Framework comme produit de lui-même.** Oui, le framework est devenu narcissique. La North Star "projets lancés/semaine" n'a pas bougé, mais le framework a doublé. Classic scope creep. C'est l'équivalent de PayPal en 2000 quand on a failli se noyer dans les features au lieu d'envoyer de l'argent par email. Chaque gate, chaque learning est plausible individuellement — mais le TOTAL tue la vélocité. Si tu demandes "est-ce que ces 30 gates ont accéléré le dernier lancement ?", la réponse honnête est probablement non.

## 3. Réponses aux 4 questions

**Q-A — Archivage lessons-learned.** Seuil dur : **un learning a 3 sessions pour devenir une règle OU disparaître.** Méthodologie : (1) Si le pattern se répète 3x → promouvoir en règle dans l'agent concerné, SUPPRIMER du lessons-learned. (2) Si pas répété en 3 sessions → archive (`lessons-archive.md`, hors contexte agent). (3) Taille max active : 50 lignes, FIFO. Versi à 21+ sessions non dédupliquées = anti-pattern. Analogie SpaceX : les leçons du Falcon 1 explosion #3 sont devenues des specs de conception du Falcon 9, pas un post-it permanent collé sur chaque ingénieur.

**Q-B — Budget règles framework.** Max acceptable : **500 lignes totales obligatoires par agent** (CLAUDE.md + protocol + agent.md + prefs + lessons actifs). Aujourd'hui ~1300 = 2.6x trop. Justification first principles : un humain expert lit ~250 mots/min en compréhension profonde. 1300 lignes à ~15 mots/ligne = 78 min de "lecture de consignes" avant production. Un LLM ne lit pas en temps humain mais souffre du même phénomène d'attention diluée. Cible : CLAUDE.md 80, protocol 200, agent.md 250 moy (orchestrator à 883 est obèse, objectif 400), prefs 60, lessons actifs 50.

**Q-C — Règle Delete-first.** OUI, obligatoire. Pattern proposé : **"Conservation of rules" — pour chaque règle/learning ajouté en fin de session, une règle/learning obsolète doit être supprimée ou fusionnée.** Ajouter comme 8ème commandement dans CLAUDE.md (le 7 "anti-inflation" est passif, il faut un actif). Bezos one-way/two-way : une règle est une two-way door — si elle n'a pas été déclenchée en 5 sessions, on la ferme. L'historique git garde tout, on ne perd rien.

**Q-D — Versi scoring 10/10 unanime.** **Régression, pas méfiance justifiée.** Le 10/10 unanime est un anti-pattern connu (groupthink + inflation de notes — cf. revues McKinsey 2010s où tout le monde était "exceeds expectations"). Les gates PASS/FAIL sont binaires pour une raison : ils forcent la décision. Si Thomas se méfie des gates binaires, la bonne réponse n'est pas de revenir aux notes continues — c'est d'améliorer les critères des gates. Action : aligner Versi sur PASS/FAIL sous 7 jours. Si un gate fait peur à trancher, c'est qu'il est mal défini, pas que le binaire est mauvais.

## 4. Trois actions CETTE SEMAINE

1. **Diet protocol.** Réduire `_base-agent-protocol.md` de 467 → 250 lignes. Méthode : tout ce qui n'a pas été référencé par un agent en 10 dernières sessions = archive. Deadline : dimanche. (@agent-factory peut exécuter.)
2. **Promote or die.** Purger `lessons-learned.md` projets actifs. Tout learning > 3 sessions : soit promu en règle d'agent, soit archivé. Cible : 50 lignes max actives. Appliquer à Versi en premier (21 sessions à auditer).
3. **Ajouter commandement n°8 "Conservation of rules"** dans CLAUDE.md : "Pour toute règle/learning ajouté, une équivalente doit être supprimée ou fusionnée. Net-zero par session." Et auditer orchestrator.md (883 lignes) pour viser 400. C'est l'agent le plus appelé — chaque ligne qu'il lit coûte sur CHAQUE projet.

---

**Dernière chose.** Le framework n'est pas fait pour impressionner. Il est fait pour shipper. Si dans 30 jours le ratio "lignes de règles / projets lancés" a encore augmenté, le framework bosse contre toi. Mesure-le. Si tu ne peux pas le mesurer, supprime-le.

---
**Handoff → Thomas**
- Fichier produit : `/home/user/Agent-Team/docs/reviews/elon-framework-bloat-2026-04-17.md`
- Verdict : hypothèse FONDÉE, framework en bloat mesurable
- Action #1 priorité : diet `_base-agent-protocol.md` (467→250) cette semaine
- Agent à invoquer pour exécution : @agent-factory (refonte protocol + CLAUDE.md commandement 8)
- Hypothèse à valider en 1h : Grep chaque règle de _base-agent-protocol.md dans les logs de session des 30 derniers jours. Non-référencée = candidat suppression.
- Rappel : AVIS, pas directive. Tu décides.
---
