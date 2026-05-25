<!-- Version: 2026-05-25T00:00 — @elon — Audit first principles framework Gradient Agents -->

# Le framework est obèse. Voici ce que je couperais. — @elon

Thomas, tu veux revenir à un système où tu fais confiance et tu prends du plaisir. Ce n'est pas un problème d'amélioration. C'est un problème de **graisse**. Le framework a accumulé 6 mois de cicatrices (chaque bug → une règle, chaque incident → un gate). Aujourd'hui un agent lit 1300 lignes avant d'écrire un mot. C'est physiquement impossible qu'il reste concentré sur TON brief.

## 1. Si je repartais de zéro — je garderais 25%.

**Ce qui survit (le coeur — ~500 lignes total) :**
- CLAUDE.md condensé à **40 lignes** (les 7 commandements actuels sont déjà denses, mais on coupe la moitié des règles communes en doublon avec _base-agent-protocol)
- Les **19 fiches d'agents**, mais ramenées à **80-120 lignes chacune** (identité + spécificité + handoff). Pas plus.
- Un protocole partagé **unique** à 80 lignes max — write-first, anti-invention, handoff, voilà.
- Les gates : **8 gates max**, pas 32. Persona identique / 0 placeholder / 0 contradiction amont / implémentable / build pass / 5 états UI / WCAG AA / pas copiable. Le reste est de la décoration de réviseur.

**Ce qui meurt (75%) :**
- **orchestrator.md ligne 1–166** : tout le préambule "compteur de session, scope freeze, bug permissions Write, structure d'un message orchestrateur type". C'est du folklore de session. **−166L.**
- **orchestrator.md ligne 274–340** : la boucle Plan→Execute→Verify→Next + Checkpoint @moi + Étape 0b autopilot. Un orchestrateur qui a besoin qu'on lui explique en 70 lignes qu'il faut "vérifier après exécuter" n'est pas un orchestrateur. **−66L.**
- **orchestrator.md ligne 440–600** : tableaux "Variable 1 / 1b / 1c / 2 / 3", Phases 0/0b/1/1b/2/2b/2c/2d/3/4/5/5a-bis/5b. **Quatorze phases pour un projet IA.** SpaceX a 4 étages sur un Falcon Heavy. **−160L.**
- **_base-agent-protocol.md ligne 56–68** (Calibration références marché), **ligne 178–199** (Désaccord utilisateur + Mode révision en doublon dans chaque agent), **ligne 248–305** (PVU — un protocole d'audit *dans* le protocole de base), **ligne 386–445** (Versioning des agents + Convention de chemin + Mémoire organisationnelle + Protocole de test). **~−200L.**
- **_gates.md** : G16 (compteur de mots-clés), G18 (≥1 exemple), G22 (registre tu/vous), G23 (formule+seuil), G27-G30 (architecture tokens 3 tiers, 6 états par composant, pattern de layout explicite), G31 (Favicon Coverage — sérieusement ?), G32 (typographie FR). **24 gates à supprimer. −60L.**
- **Tout le système GP1-GP10 + GC1-GC10** (testeur-persona + testeur-client) : ton propre fichier dit que "un LLM qui simule un persona reste structurellement trop indulgent". Tu as documenté que ça ne marche pas, et tu le gardes quand même. **À jeter. −80L cumulés sur orchestrator + gates + agents.**
- **Phase 2c/2d/5b** (revues testeur multiples + revue finale chirurgicale 21 dimensions par page) : c'est ce que @qa et @reviewer doivent faire. Deux agents qui font le même travail = aucun qui le fait bien.
- **Le mécanisme "lessons-learned → propagation → gate bloquante en reprise"** (orchestrator.md L348-360) : c'est une bureaucratie. Tu accumules des "P0 non-propagés" comme un backlog Jira. **Garde lessons-learned.md à 20 lignes pures, supprime le protocole de propagation. −15L.**
- **@moi en Shadow Mode / Autopilot assisté / Autopilot complet + score de fidélité** : tu as construit un agent qui prédit tes décisions pour que tu puisses corriger l'agent qui prédit tes décisions. C'est un miroir qui se regarde. **À jeter ou réduire à 50L max.**

## 2. Ce qui fait qu'un système marche pour un fondateur indie — 3 choses.

1. **Le système lit le brief AVANT de lire son propre manuel.** Aujourd'hui l'orchestrateur lit project-context.md + lessons-learned.md + founder-preferences.md + son propre prompt (832L) + le base-protocol (470L) + CLAUDE.md (125L) avant de te répondre. Tu lui parles, il fait ses devoirs. Inverse : **brief d'abord, contexte ensuite uniquement si nécessaire.** La règle A1 "brief-first" existe déjà (orchestrator.md L15-25) — applique-la partout et supprime tout ce qui la précède dans le pipeline mental.
2. **Un seul agent = un seul livrable = une seule conversation.** Pas de Phase 0b qui crée des agents qui appellent des agents. Quand tu demandes "améliore ma landing", l'orchestrateur lance @copywriter, point. Pas 14 phases, pas 4 testeurs, pas un Checkpoint @moi entre chaque. **L'utilisateur indie veut un retour, pas un workflow d'agence à 25 personnes.**
3. **Le critère de qualité, c'est toi qui décides en regardant l'output — pas une grille de 32 gates.** Les gates servent le réviseur, pas le fondateur. Un fondateur indie lit l'output et dit "oui" ou "non" en 30 secondes. Si le système te force à lire un rapport de gates pour savoir si c'est bon, le système t'a déjà perdu.

## 3. À disparaître immédiatement (chiffré).

| À supprimer | Fichier(s) | Économie |
|---|---|---|
| Préambule session counter + ALERTE ROUGE + self-diagnostic | orchestrator.md L97-168 | **−71L** |
| Étapes 2 (clarification) + 3 (priorisation 3 variables) + 4 (14 phases) | orchestrator.md L378-600 | **−222L** |
| Phase 0b agents testeur-persona + Gates GP1-GP10 + GC1-GC10 | orchestrator.md L507-568 + _gates.md L91-111 | **−82L** |
| PVU "Protocole d'audit structuré" intégré au protocole de base | _base-agent-protocol.md L248-305 | **−57L** |
| Calibration références marché + Setup pre-commit hook + Notification de changement + Versioning des agents | _base-agent-protocol.md L56-68, 202-226, 309-318, 387-395 | **−60L** |
| Gates G16, G18, G22, G23, G27-G32 | _gates.md L58-89 | **−30L** |
| Tableaux Variable 1/1b/1c + lecture vitrine/funnel en Phase 0 | orchestrator.md L444-479 | **−36L** |
| Boucle Plan→Execute→Verify→Next (sait pas faire ça sans manuel = mauvais agent) | orchestrator.md L274-340 | **−66L** |
| Lessons-learned format 11 colonnes + statut propagation + TTL 5 sessions | docs/lessons-learned.md + protocole propagation orchestrator | **−40L** |
| Section "Bug connu — Permissions Write des subagents" | orchestrator.md L120-126 | **−7L** |

**Total économisé : ~671 lignes** sur ~1900 lignes critiques. **Réduction ~35% en gardant ce qui marche.** Si tu veux les 75% annoncés en Q1, il faut aussi tailler dans les 19 agents (cap dur 120L/agent : la plupart sont à 250-400L aujourd'hui).

## 4. Le framework cible — chiffres.

- **CLAUDE.md** : 40 lignes (5 commandements, pas 8).
- **_base-agent-protocol.md** : 80 lignes (write-first, anti-invention, handoff, désaccord utilisateur, point).
- **_gates.md** : 30 lignes (8 gates, 1 verdict GO/NO-GO, fini).
- **orchestrator.md** : **150 lignes max**. Identité (10L) + règle brief-first (10L) + tool Task (20L) + 4 phases simples sans sous-phases (40L) + handoff (20L) + gestion timeouts (20L) + checkpoint utilisateur après fondations (15L) + clôture (15L). Tout le reste va dans un `orchestrator-playbook.md` que l'orchestrateur consulte UNIQUEMENT en cas d'ambiguïté.
- **19 agents** → **12 agents** : fusionner @ux+@design, @seo+@geo, @growth+@social, et supprimer @moi (proxy d'un humain qui est déjà dans la boucle — c'est de la masturbation framework). Cap dur **120 lignes par agent**.
- **Total framework** : ~2000 lignes au lieu de ~6000+. Un agent peut lire l'intégralité de son protocole en 1 seconde et garder 90% de son contexte pour TON projet.

## Le test simple.

Dans 2 semaines, tu envoies à l'orchestrateur ce message : "améliore la landing Sarani". **Si tu reçois le premier livrable utile en moins de 5 minutes sans avoir répondu à une question de cadrage, le plan a marché.** Si l'orchestrateur te répond par un tableau A/B/C ou un "j'ai besoin de clarifier 4 points avant de lancer la Phase 0b", on a échoué, on coupe encore.

C'est le seul signal qui compte : **le temps entre ton brief et le premier livrable utile**. Aujourd'hui c'est 20-40 minutes avec des questions. Cible : 5 minutes sans question. Ça, c'est revenir à "comme avant".

---

**Handoff → Thomas (décideur)**
- Fichier produit : `docs/reviews/elon-system-cure-2026-05-25.md`
- Avis : framework à réduire de 35% en suppression chirurgicale (671 lignes identifiées avec chemins exacts), pas à "améliorer". Cible Q1 : −60% en taillant aussi dans les 19 agents.
- Décision à prendre : (a) tu lances la cure maintenant via @agent-factory + @reviewer en pair, ou (b) tu fais un essai sur orchestrator.md d'abord pour valider le pattern.
- Rappel : ceci est un AVIS. Tu décides. Mais l'inaction prolonge la dégradation.
---
