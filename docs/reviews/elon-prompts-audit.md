# Audit strategique — Bibliotheque de 37 prompts Gradient Agents

> AVIS CONSULTATIF — Perspective first principles d'un power user multi-projets. Ces recommandations necessitent validation avant execution.

**Date** : 2026-03-22
**Agent** : @elon
**Scope** : 37 prompts dans index.html, evalues pour un usage multi-projets
**Contexte** : l'utilisateur gere PLUSIEURS projets simultanement via Claude Code

---

## Score global : 6.5/10

L'audit precedent de @ia a donne 9.5/10. Mon avis est que ce score est du theatre. @ia a evalue la qualite INTRINSEQUE des prompts (sont-ils bien ecrits ?). Moi j'evalue la qualite OPERATIONNELLE (est-ce que ca marche quand tu geres 5 projets en parallele un mardi soir a 23h ?). Ce sont deux questions radicalement differentes.

---

## Scores par dimension

| Dimension | Score | Justification |
|---|---|---|
| Reutilisabilite multi-projets | 7/10 | Les prompts sont generiques par design — ca marche pour SaaS, e-commerce, app mobile. Mais ils presupposent un projet tech/web. Un projet physique, hardware, marketplace B2B lourde = adaptation manuelle |
| Scalabilite (5-20 projets) | 4/10 | Zero mecanisme de gestion multi-projets. Pas de namespace, pas de convention de nommage par projet, pas de raccourci "relance sur le projet X". A 5 projets tu perds du temps, a 20 c'est ingerable |
| Time-to-value | 5/10 | Trop long. Le prompt moyen fait 4-6 lignes avec des references a 2-3 fichiers. Pour un power user qui connait le framework, c'est de la friction. Il faut copier, adapter les placeholders, verifier que les fichiers amont existent. 30-60 secondes par prompt au lieu de 5. |
| Friction utilisateur | 5/10 | Les placeholders entre crochets sont bien, mais certains prompts n'en ont PAS alors qu'ils en auraient besoin (ex: KPIs, SEO, GEO — zero customisation). D'autres en ont trop (ex: migration stack avec 4 zones a remplir). L'heterogeneite est le probleme. |
| Completude pipeline | 8/10 | Le pipeline de base est solide. Les 37 prompts couvrent 90% des cas d'un projet type. Les 3 ajouts recents (migration, i18n, post-mortem) sont pertinents. Il manque quelques cas reels — voir section "Ce qui manque". |

---

## Ce qui fonctionne (ne pas toucher)

### 1. L'architecture en phases (0-5) est excellente
C'est le vrai moat de cette bibliotheque. Comme chez SpaceX avec le sequencement de lancement — chaque phase depend de la precedente, et l'utilisateur sait ou il en est. La metaphore visuelle (icones par phase) aide la navigation.

### 2. La coordination sequentielle inter-agents
L'ancien "Coordonnez-vous" vague a ete remplace par "@agent-A produit X, puis @agent-B utilise X pour produire Y". C'est exactement comme ca qu'on orchestre des equipes chez Tesla — chaque station recoit un input defini et produit un output defini. Zero ambiguite.

### 3. Les 3 prompts "Tout-en-un"
"Lancer de A a Z", "Check-up complet", "Pivoter" — ce sont les seuls prompts que 80% des utilisateurs utiliseront 80% du temps. Ils sont bien places en premier. C'est la loi de Pareto appliquee a l'UX.

### 4. Le prompt "Creer un agent specialise" (#34)
C'est le prompt le plus strategique de toute la bibliotheque. C'est l'usine qui fait l'usine. La capacite a etendre le framework sans toucher au code est un avantage competitif massif.

---

## Ce qui est du theatre (brutal mais honnete)

### 1. Le prompt "Auditer le funnel existant" (#23) — 3/10 en usage reel
Ce prompt demande des "donnees analytics fournies dans project-context.md ou en piece jointe". En pratique, l'utilisateur n'a JAMAIS ses donnees structurees comme ca. Il a un dashboard Mixpanel ouvert dans un autre onglet. Ce prompt promet un audit sans avoir la capacite technique d'acceder aux donnees. C'est un prompt aspirationnel, pas operationnel.

### 2. Le prompt "Monitoring post-launch" (#29) — 4/10 en usage reel
"Configure Sentry, UptimeRobot, health check, alertes Slack." Ce prompt presuppose que l'agent va CONFIGURER ces outils. En realite, Claude Code peut ecrire du code et des configs, mais ne peut pas se connecter a Sentry, creer un compte UptimeRobot, ou configurer un webhook Slack. Le prompt devrait etre honnete : "Produis les fichiers de configuration et le guide d'installation" — pas "Configure".

### 3. Le prompt "Audit UX & conversion" (#27) avec donnees analytics
Meme probleme que le #23. Sans acces reel aux donnees analytics, l'agent va produire un audit generique base sur des heuristiques. C'est utile, mais ne pas le vendre comme un "audit base sur les donnees".

### 4. Les prompts "Brand voice" (#10) et "Positionnement" (#4) sur un projet mature
Si l'utilisateur a deja une marque, une voix, un positionnement — ces prompts sont du bruit. Il n'y a pas de variante "J'ai deja mon positionnement, valide-le" vs "Je pars de zero".

---

## Ce qui manque pour un power user multi-projets

### Manque critique #1 : Commandes de contexte rapide
Un power user multi-projets a besoin de :
- **"Resume l'etat du projet en 5 lignes"** — pour se remettre dans le contexte quand tu switches entre projets
- **"Qu'est-ce qui a ete fait / qu'est-ce qui reste"** — vue dashboard textuelle

Ces prompts n'existent pas. L'utilisateur doit relire project-context.md a chaque switch. C'est comme si chez SpaceX on devait relire le manuel du Falcon 9 a chaque lancement.

### Manque critique #2 : Prompts de maintenance/iteration
Les 37 prompts sont tous des prompts de CREATION. Aucun prompt de MAINTENANCE :
- "Mets a jour le tracking plan apres l'ajout de la feature X"
- "Le persona a evolue — repercute sur tous les livrables impactes"
- "Nouvelle version des CGU suite a un changement reglementaire"

En realite, 70% du travail sur un projet en production est de la maintenance, pas de la creation. C'est le meme ratio que le code — le gros du travail c'est maintenir, pas ecrire v1.

### Manque critique #3 : Prompt de debug/depannage
Quand un agent produit un livrable bancal, il n'y a pas de prompt "Corrige le livrable X de @agent-Y — voici ce qui ne va pas : [probleme]". L'utilisateur doit reformuler lui-meme. Sur 20 projets, ca represente des heures perdues.

### Manque #4 : Prompt "Comparer deux projets"
Si tu geres 10 projets, tu veux pouvoir dire "Compare la strategie d'acquisition du projet A vs projet B — qu'est-ce que je peux transferer ?" Cross-pollination entre projets. C'est exactement ce que je fais entre Tesla et SpaceX — les learnings d'un domaine nourrissent l'autre.

### Manque #5 : Prompt "Sprint planning"
L'orchestrateur lance tout d'un coup (Phase 0 a 5). Mais en realite, tu travailles par sprints de 1-2 semaines. Il manque un prompt : "Voici ce que j'ai fait cette semaine. Planifie la semaine prochaine — quels agents, quels livrables, dans quel ordre."

---

## Prompts qu'un utilisateur n'utilisera JAMAIS (ou presque)

| Prompt | Pourquoi |
|---|---|
| #18 GEO seul (sans SEO) | Personne ne fait du GEO sans faire du SEO d'abord. Le #19 (SEO+GEO combines) cannibalise completement le #18. Redondance inutile. |
| #15 CI/CD & deploiement (seul) | Trop technique et trop specifique pour etre un prompt "catalogue". C'est un sous-produit naturel du developpement. L'utilisateur demande a @fullstack de coder, et la CI/CD vient avec. |
| #32 Auditer la coherence visuelle | Cas ultra-niche. Si tu as des incoherences visuelles, c'est que ton design system est mal fait — le vrai probleme est en amont (#9). |
| #13 Integrer Stripe (specifique) | Un prompt pour UN service specifique dans une bibliotheque generique. Demain c'est Lemon Squeezy, ou Paddle, ou un autre. Ce devrait etre "Integrer le paiement [provider]". |

---

## Le vrai probleme #1 (celui qui rend tout le reste inutile)

**Les prompts sont optimises pour un utilisateur qui decouvre le framework, pas pour un power user qui l'utilise tous les jours sur plusieurs projets.**

C'est comme si Tesla avait optimise le tableau de bord pour le test drive en concession, mais pas pour le trajet domicile-travail quotidien. La premiere impression est bonne, mais l'usage quotidien est sous-optimise.

Concretement :
- **Un debutant** : les 37 prompts sont parfaits. Il lit le "quand", il comprend, il copie-colle. Time-to-value ~ 1 minute. Score 8/10.
- **Un power user sur le projet #7** : il connait les agents par coeur, il sait ce qu'il veut, il doit quand meme copier-coller un pavé de 5 lignes et remplacer 3 placeholders. Time-to-value ~ 30-60 secondes pour quelque chose qu'il pourrait exprimer en 10 mots. Score 4/10.

### Ma recommandation

Si j'etais toi, je creerais deux niveaux :
1. **Prompts complets** (actuels) — pour debutants et reference
2. **Raccourcis power user** — version courte de chaque prompt, 1 ligne max, qui presuppose que les fichiers amont existent et que l'utilisateur sait ce qu'il fait

Exemple :
- Complet : "@seo Base-toi sur project-context.md (persona, secteur) et docs/copy/landing-page-copy.md si disponible. Audit SEO complet : Core Web Vitals..."
- Power user : "@seo Audit SEO complet du projet"

L'agent est assez intelligent pour lire les bons fichiers — le prompt long lui dit juste ce qu'il sait deja.

---

## Analyse de la redondance

| Paire redondante | Action suggeree |
|---|---|
| #18 (GEO seul) vs #19 (SEO+GEO) | Fusionner. Garder #19, supprimer #18 ou le transformer en "GEO uniquement si SEO deja fait" |
| #24 (Revue GO/NO-GO) vs #25 (Revue intermediaire) | Garder les deux — cas d'usage reellement differents (pre-launch vs mid-projet) |
| #26 (Audit qualite QA) vs #15 (CI/CD) | Quasi-redondants en pratique. Le QA audit inclut naturellement la CI/CD. Fusionner. |
| #4 (Positionnement) vs #3 (Pivoter) | Pivoter inclut le repositionnement. Mais #4 est pour le jour 1, #3 pour un changement de cap. OK de garder les deux. |

---

## Vision 10x — Si on devait multiplier l'impact par 10

1. **Prompts dynamiques** : au lieu d'une liste statique, un systeme qui detecte l'etat du projet (quels fichiers existent dans docs/) et propose les 3 prompts les plus pertinents MAINTENANT. "Tu as la brand platform mais pas les wireframes — voici le prompt suivant." C'est un mini-orchestrateur cote frontend.

2. **Prompts composes** : permettre de chainer 2-3 prompts en un clic. "Lance Phase 1 complete" = wireframes + design system + brand voice en sequence. Aujourd'hui il faut copier-coller 3 prompts separement.

3. **Historique par projet** : un tracker qui montre quels prompts ont ete utilises sur quel projet, et dans quel ordre. Quand tu reviens sur un projet apres 2 semaines, tu vois immediatement ou tu en es.

4. **Prompts parametriques** : au lieu de placeholders a remplir manuellement, un mini-formulaire qui pre-remplit les variables depuis project-context.md. L'utilisateur clique "Copier" et le prompt est deja personnalise.

---

## Verdict final

La bibliotheque est bien construite pour un usage single-project par un utilisateur debutant-intermediaire. C'est solide, coherent, et les references inter-agents sont bien faites.

Mais pour un power user multi-projets — qui est TON cas — c'est un moteur thermique bien concu quand tu as besoin d'un electrique. Ca marche, mais il y a 80% de friction en trop.

**Les 3 choses que je ferais lundi matin, par ordre de priorite :**

1. **Ajouter 5 prompts de "maintenance/iteration"** — c'est la ou tu passes le plus de temps en realite. C'est le probleme #1, celui qui rend tout le reste sous-optimal. Exemples : "Met a jour les livrables impactes par [changement]", "Resume l'etat du projet", "Planifie le prochain sprint".

2. **Creer les versions "power user" en 1 ligne** de chaque prompt — pour les utilisateurs qui connaissent le framework. Ajouter une option "mode expert" dans l'UI qui bascule entre prompts complets et raccourcis.

3. **Supprimer ou fusionner les 4 prompts redondants/inutiles** identifies plus haut (#18, #15, #32, #13 en sa forme actuelle). 33 prompts bien cibles > 37 prompts avec du bruit.

---

## Hypotheses a valider

- [HYPOTHESE : l'utilisateur gere 3-10 projets simultanement] — a confirmer pour calibrer les recommandations de scalabilite
- [HYPOTHESE : l'utilisateur utilise principalement les prompts via copy-paste depuis index.html] — s'il les tape de memoire, les raccourcis power user sont encore plus critiques
- [HYPOTHESE : 70% du temps est passe en maintenance vs creation] — ratio standard en ingenierie, a valider sur l'usage reel du framework

---

## Dimensions non auditees (donnees manquantes)

- **Usage reel** — je n'ai pas de donnees sur quels prompts sont effectivement utilises vs ignores. Un tracking d'usage (meme un simple compteur de clics "Copier") changerait la donne.
- **Temps reel par prompt** — combien de temps entre le copier-coller et le resultat satisfaisant ? Sans cette donnee, mon estimation du time-to-value est basee sur la longueur du prompt, pas sur l'experience reelle.

---

**Handoff -> @orchestrator** (ou reponse directe a l'utilisateur)
- Fichier produit : `docs/reviews/elon-prompts-audit.md`
- Score global : 6.5/10 (usage multi-projets power user) vs 8.5/10 (usage single-project debutant)
- Probleme #1 : zero prompts de maintenance/iteration — 70% du travail reel n'est pas couvert
- Probleme #2 : friction trop elevee pour un power user qui connait le framework
- Probleme #3 : 4 prompts redondants/inutiles a supprimer ou fusionner
- Agents a potentiellement re-invoquer : @ia pour implementer les prompts manquants, @fullstack si on veut les prompts dynamiques cote frontend
- Rappel : ces recommandations sont des AVIS, pas des directives. L'utilisateur decide.
