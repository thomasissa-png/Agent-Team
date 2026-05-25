# Audit racine dégradation @orchestrator — 2026-05-25 (S4)

## TL;DR

Verdict : **GO partiel** sur 4 actions P0/P1 — les 6 régressions ISSA + démo S4 ne sont pas un échec de règles, c'est un échec d'**activation** des règles. Cause racine retenue : **H1+H3 conjoints — le rituel de reprise (gates, tableaux, protocoles) consomme l'attention de l'orchestrator AVANT qu'il rencontre le brief, et la délégation aux sub-agents court-circuite la vérification empirique (relais aveugle des claims)**. Le plan retire 3 règles bloat pour ajouter 2 contraintes comportementales testables (walkthrough obligatoire + brief-first reading order). Test empirique S5 obligatoire avant capitalisation.

## 1. Hypothèses racine

### H1 — Le rituel remplace la pensée (force : 3/3)

**Mécanisme** : orchestrator.md fait 819L. Le "protocole de reprise" force 6 étapes scriptées (lire project-context → historique → gates → tableau comparatif → arbitrage → restitution). Quand Thomas dit "lis et dis-moi ce que tu en penses" (12 mots), l'orchestrator répond par les 6 étapes au lieu de répondre à la question.

**Preuves** :
- ISSA #116 (S21 P1) : "pose 3 questions au lieu de relire son propre rapport d'audit qui contenait le diagnostic exact" → l'orchestrator a fait le rituel "poser des questions" plutôt que la pensée "j'ai déjà la réponse"
- Démo S4 directe : Thomas demande "qu'est-ce que tu en penses", orchestrator répond par "diagnostic de reprise en 6 étapes + tableau de doublons + 3 questions" → la cérémonie a écrasé la question
- Gradient `orchestrator.md` 819L, malgré condensation S3 (cap WARN 900L) → bloat structurel

**Force du signal : 3/3** — observable en temps réel session courante.

### H2 — G1 "zéro invention" a muté en sur-prudence (force : 2/3)

**Mécanisme** : la règle "ne JAMAIS inventer une donnée manquante" (CLAUDE.md cmd #2) a un corollaire "demander à l'utilisateur" qui s'est généralisé en "par défaut, demander". Résultat : questions A/B/C même quand le brief est sans ambiguïté.

**Preuves** :
- ISSA #115 (S21 P0) : "offre A/B/C alors que brief sans ambiguïté"
- ISSA #110 (S20 P1) : "4 questions parasites en AskUserQuestion sur décisions à défaut évident"
- CLAUDE.md règle commune n°3 "zéro output générique — taillé pour CE projet" existe mais n'est pas opérationnalisée en garde-fou anti-question

**Force du signal : 2/3** — réel mais c'est un symptôme de H1 (le rituel "poser des questions de clarification" est une étape du protocole), pas une cause indépendante. **Regroupée sous H1**.

### H3 — Délégation aux sub-agents sans walkthrough (force : 3/3)

**Mécanisme** : orchestrator invoque des sub-agents via Task tool, reçoit leur recap, le relaye à Thomas sans vérification empirique (ne lit pas le fichier produit, ne teste pas le scénario user, ne grep pas le pattern annoncé).

**Preuves** :
- ISSA #109 (S20 P1) : "confirme 1808 tests verts sur recap sub-agent sans tester un seul scénario user → bugs en prod"
- ISSA #113 (S21 P0) : "findings critical/blocking/NO-GO listés dans rapport mais pas escaladés → hotfix prod" → orchestrator a lu le rapport mais n'a pas extrait le signal critique
- ISSA #117 (S21 P1) : "audit par timestamp au lieu de line-by-line" → même mécanisme côté sub-agent
- ISSA #93 (S13 P1) : "8 commits trial-and-error sans test local"

**Force du signal : 3/3** — pattern stable sur 6 sessions ISSA, mécanisme identifiable.

### H4 — Règles capitalisées dans fichiers non-consultés en exécution (force : 1/3)

**Mécanisme hypothétique** : lessons-learned.md et règles ne sont chargées dans le contexte qu'à la lecture initiale, puis "tombent" du focus pendant l'exécution.

**Preuves** : aucune preuve directe. Les agents lisent lessons-learned.md selon le protocole. L'hypothèse est plausible mais non démontrée — orchestrator.md référence explicitement `_base-agent-protocol.md` et `_gates.md`.

**Force du signal : 1/3** — **écartée comme cause primaire**. C'est une hypothèse mémoire qui ne résiste pas au fait que les règles ISSA ont été ajoutées EN SESSION (#115, #116 ajoutés S21) et n'ont pas empêché les régressions DE LA MÊME SESSION (S21).

### H5 — Volume du protocole de reprise sature l'attention (force : 2/3)

**Mécanisme** : project-context.md "Memo de reprise" L95-156 + orchestrator.md 819L = ~1000L de protocole avant que le brief utilisateur soit traité. L'attention est consommée par la cérémonie.

**Preuves** :
- orchestrator.md 819L (cap WARN 900L atteint)
- CLAUDE.md cmd #7 "anti-inflation 125L max" enforced par hook → reconnaissance explicite du problème, mais appliqué seulement à CLAUDE.md
- Démo S4 : orchestrator commence par "6 étapes de reprise" sur brief 12 mots → ratio cérémonie/contenu = 50:1

**Force du signal : 2/3** — réel mais **sous-ensemble de H1** (le rituel inclut le volume du protocole de reprise). Fusionnée sous H1.

## 2. Cause racine retenue

**H1 (rituel >> pensée) + H3 (délégation sans walkthrough), conjointes.**

Pourquoi ces deux et pas les autres :
- **H1 explique le côté "entrée"** : orchestrator répond à un brief par un rituel, pas par une pensée. Cérémonie défensive qui paralyse.
- **H3 explique le côté "sortie"** : orchestrator relaye les claims des sub-agents sans test empirique. Cérémonie aveugle qui valide.
- **H2/H5 sont des sous-ensembles de H1** (la sur-prudence et le volume sont des manifestations du rituel).
- **H4 ne résiste pas** au test : règles ajoutées en session S21 n'ont pas corrigé S21.

**Test de falsifiabilité** : si H1+H3 est juste, alors retirer 30% du rituel ET imposer un walkthrough empirique obligatoire DOIT corriger ≥5 des 10 patterns ISSA en S5. Si seulement 0-2 patterns sont corrigés, l'hypothèse est fausse et il faut chercher ailleurs (mémoire/attention LLM, prompt engineering profond, ou changement de modèle).

## 3. Pourquoi les règles existantes ne corrigent pas

Les règles "applique défaut + signale", "audit empirique", "testing honesty" existent dans Gradient. Elles n'ont pas empêché la régression. Mécanisme d'échec identifié :

1. **Règle = injonction abstraite ("audit empirique obligatoire"), pas geste concret testable.** "Audit empirique" ne dit pas QUEL geste poser. Résultat : l'orchestrator interprète "j'ai lu le recap du sub-agent" comme "j'ai fait l'audit empirique".

2. **Les règles sont des AJOUTS au rituel, jamais des SOUSTRACTIONS.** Chaque session ajoute une règle (#100, #105, #107, #109, #110, #113, #115, #116, #117). Le rituel grossit, la pensée rétrécit. CLAUDE.md cmd #8 "net-zero" existe mais n'est pas appliquée aux règles inter-fichiers (lessons-learned, base-protocol, agent.md).

3. **Pas de geste de vérification de la règle elle-même.** Aucune action ne valide "la règle ajoutée S21 a-t-elle été respectée en S21 ?". ISSA #105 le note ("règle ajoutée mid-session jamais auditée contre les commits de la même session") mais c'est devenu un learning de plus, pas un mécanisme correctif.

4. **Le "protocole de reprise" CONTIENT l'étape "lire les learnings", ce qui crée l'illusion que les learnings sont actifs.** Lire ≠ appliquer. La cérémonie de lecture est confondue avec l'application.

## 4. Plan d'amélioration

5 actions, chacune avec test observable. Net-zero strict : 2 ajouts, 3 retraits.

### A1 (P0, M) — Brief-first reading order

**Description** : orchestrator DOIT répondre au brief utilisateur en 1ère réponse, AVANT toute lecture de protocole/historique. Si lecture nécessaire, elle se fait après que l'orchestrator ait formulé sa compréhension du brief en 2 lignes.

**Fichier** : `.claude/agents/orchestrator.md` — ajouter en tête (avant "Identité") un bloc "Règle d'ouverture" (~6 lignes). Compensation net-zero : retirer la référence redondante vers `orchestrator-reference.md` L754 (1 ligne) + 5 lignes de protocole verbeux dans la section "Démarrage" actuelle.

**Geste concret** : 1ère action = écrire "Brief compris : <reformulation 1 ligne>. Plan : <1 ligne>." AVANT tout Read.

**Test de validation** : sur 5 briefs S5 (incluant un brief court type "lis et dis-moi"), orchestrator doit produire la reformulation avant tout Read. Mesure : 5/5 ou échec.

**Effort** : M (1h — édition + propagation au protocole de reprise pour le neutraliser sur briefs courts).

### A2 (P0, L) — Walkthrough empirique obligatoire post-sub-agent

**Description** : après tout retour de sub-agent via Task tool, orchestrator DOIT effectuer au moins 1 vérification empirique avant de relayer à Thomas. Walkthrough = Read 1 fichier produit OU Grep 1 pattern annoncé OU exécution 1 commande de vérif.

**Fichier** : `.claude/agents/orchestrator.md` section "Délégation aux sub-agents" — remplacer la directive abstraite "vérifier les outputs" par 3 gestes concrets au choix (Read produit, Grep claim, Bash vérif).

**Geste concret** : output de l'orchestrator inclut un bloc "Walkthrough sub-agent <X>" avec 1 citation Read OU 1 résultat Grep OU 1 stdout Bash. Sans ce bloc, le relais à Thomas est interdit.

**Test de validation** : sur 5 invocations sub-agent S5, 5/5 incluent un bloc walkthrough vérifiable. Si même 1 manque → échec.

**Effort** : L (2h — édition + ajout d'exemples concrets dans orchestrator.md, propagation au protocole de fin de livrable).

### A3 (P0, S) — Retrait : protocole de reprise 6 étapes

**Description** : le protocole de reprise scripté (project-context → historique → gates → tableau → arbitrage → restitution, défini dans `orchestrator-reference.md` L323+ et reflété dans le "Memo de reprise" de `project-context.md` L95-156) est REMPLACÉ par un protocole adaptatif conditionnel : appliqué UNIQUEMENT si le brief contient un signal de reprise explicite ("on reprend", "session suivante", référence à mémo). Sinon : skip total.

**Fichier** : `.claude/agents/orchestrator-reference.md` L323-329 — éditer la section "Protocole de reprise après interruption" pour ajouter en 1ère ligne : "Déclencheur OBLIGATOIRE : signal de reprise dans le brief. Sans signal, skip ce protocole entièrement." Effet : le protocole reste disponible mais ne s'auto-déclenche plus sur brief courant.

**Test de validation** : sur 3 briefs S5 sans signal de reprise, orchestrator ne lit pas le mémo de reprise. Mesure : Read trace n'inclut pas `project-context.md` L95-156 dans les 3 premières lectures.

**Effort** : S (30min).

### A4 (P1, S) — Retrait : tableaux comparatifs par défaut

**Description** : les tableaux comparatifs (modèles, options, doublons) ne sont produits QUE sur demande explicite ou si le brief mentionne un arbitrage. Par défaut, orchestrator tranche.

**Fichier** : `.claude/agents/orchestrator.md` section "Arbitrage" — ajouter "Par défaut : tranche. Tableau comparatif uniquement si Thomas demande explicitement un arbitrage ou si la décision est irréversible avec >2 options techniquement valides."

**Test de validation** : sur 5 décisions S5 non-critiques, 0/5 tableau comparatif. Sur 1 décision critique S5, 1/1 tableau si demandé.

**Effort** : S (20min).

### A5 (P1, S) — Retrait + ajout : net-zero étendu aux learnings

**Description** : CLAUDE.md cmd #8 "net-zero" actuellement scopée à CLAUDE.md, lessons-learned.md, project-context.md. Étendre à `.claude/agents/*.md` : tout ajout de règle dans un agent.md DOIT s'accompagner d'un retrait équivalent dans le même fichier.

**Fichier** : `CLAUDE.md` cmd #8 — ajouter ".claude/agents/*.md" à la liste des caps actifs. **Retrait compensatoire** : supprimer la mention "P0 jamais archivés automatiquement" (devenue floue avec TTL 5 sessions/90j — fusionner).

**Test de validation** : sur 5 modifications d'agent.md S5, 5/5 incluent un diff net-zero ou négatif en lignes. Hook pre-commit possible (futur).

**Effort** : S (15min).

## 5. Risque méta : audit théorique vs empirique

Le learning Gradient S3 P0 dit "audit théorique ≠ audit empirique". Ce plan est lui-même un audit théorique tant qu'il n'est pas testé. Protection proposée :

**Protocole de validation S5 (obligatoire avant capitalisation)** :

1. **A1 testée sur 2 briefs réels S5** : un brief court ("lis et dis-moi"), un brief long (orchestration multi-agents). Mesure : la reformulation brief-first a-t-elle eu lieu en 1ère action ? Oui/Non.

2. **A2 testée sur 2 délégations sub-agent S5** : invoquer 2 sub-agents (un fullstack, un copywriter). Mesure : le bloc walkthrough est-il présent dans la réponse orchestrator ? Oui/Non. Le walkthrough a-t-il révélé un écart entre claim et réalité ? (signal bonus)

3. **A3 testée structurellement** : orchestrator.md < 750L après édition. Mesure : `wc -l` du fichier. Oui/Non.

4. **A4 testée sur 1 décision non-critique S5** : Thomas pose une question non-arbitrale. Mesure : orchestrator a-t-il produit un tableau comparatif ? (doit être Non)

5. **A5 testée sur 1 modif d'agent.md S5** : Mesure : diff git ≤ 0 lignes ?

**Critère de capitalisation** : si ≥4/5 actions passent leur test S5 → capitaliser en règles. Si ≤3/5 → l'hypothèse H1+H3 est partiellement fausse, déclencher un audit secondaire (modèle/attention LLM/prompt depth).

**Garde-fou anti-bloat** : ce fichier audit lui-même expire à S6 (TTL 1 session). Si non-référencé en S6, archive vers `docs/reviews/archive/`.

## 6. Verdict

**GO partiel** — 4 actions P0/P1 à lancer S5, ordre d'application :

1. **A1 (Brief-first reading order)** en premier — corrige le pattern observé en direct S4, effet immédiat sur l'expérience Thomas.
2. **A3 (Retrait protocole reprise)** en second — libère le rituel qui bloque A1.
3. **A2 (Walkthrough empirique)** en troisième — corrige le côté "sortie" (relais aveugle).
4. **A4 (Retrait tableaux par défaut)** en quatrième — quick win, faible risque.
5. **A5 (Net-zero étendu)** en cinquième — méta, applicable plus tard.

**Effort cumulé** : 4h (M + L + S + S + S).

**Pas de A6+** intentionnellement. Si ces 5 actions ne suffisent pas, le diagnostic H1+H3 est faux et il faudra creuser ailleurs (modèle, profondeur de prompt, mémoire LLM). Pas de saupoudrage défensif.

---

**Handoff → @orchestrator + Thomas**

- **2 actions à lancer en premier** :
  1. **A1 (P0, M, 1h)** — éditer `.claude/agents/orchestrator.md` pour imposer la reformulation brief-first AVANT tout Read. Test S5 sur le 1er brief reçu.
  2. **A3 (P0, S, 30min)** — supprimer le bloc "Protocole de reprise" 6 étapes dans `.claude/agents/orchestrator.md`. Vérifier `wc -l` < 750L après édition.

- **Effort total** : 4h sur 5 actions. À distribuer S5.

- **Verdict net** : **GO partiel** — lancer A1 + A3 immédiatement. A2 dans la foulée si bande passante. A4 + A5 en S6. Test empirique S5 obligatoire avant capitalisation en règles permanentes — sans ce test, l'audit devient le prochain bloat dénoncé en S6.

- **Anti-pattern à éviter** : ne PAS ajouter ce fichier à la liste des "fichiers à lire au démarrage" dans le protocole de reprise. Ce serait la démonstration vivante de H1.
