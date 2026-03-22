# Audit de la bibliotheque de prompts — Gradient Agents

**Date** : 2026-03-22
**Agent** : @ia
**Scope** : 34 prompts dans index.html, organises en 7 categories
**Methode** : evaluation sur 4 criteres (Clarte, Efficacite, Actionnabilite, Completude) notes sur 10

---

## Note globale de la bibliotheque

**7.6 / 10**

La bibliotheque est solide dans l'ensemble. Les prompts sont bien structures, specifiques au framework, et directement actionnables. Les principales faiblesses : certains prompts multi-agents manquent de precision sur la coordination attendue, et quelques prompts sont trop generiques pour garantir un resultat de qualite sans contexte supplementaire.

---

## Tableau recapitulatif par categorie

| Categorie | Nb prompts | Note moyenne | Commentaire |
|---|---|---|---|
| Tout-en-un | 3 | 8.0 | Bons points d'entree, bien calibres |
| Phase 0 -- Strategie & Fondations | 4 | 7.8 | Solides, le prompt legal se distingue |
| Phase 1 -- Conception | 4 | 7.5 | Le prompt design system est ambitieux, risque de timeout |
| Phase 2 -- Developpement | 5 | 7.6 | Bonne couverture, quelques manques de precision |
| Phase 3 -- Visibilite | 3 | 7.3 | Le prompt SEO+GEO combine manque de structure |
| Phase 4 -- Acquisition & Croissance | 4 | 7.5 | Bonne synergie multi-agents |
| Phase 5 -- Audit & Validation | 6 | 7.8 | Prompts d'audit bien calibres |
| Raccourcis | 5 | 7.4 | Heterogenes, certains trop vagues |

---

## Evaluation detaillee par prompt

### Categorie 1 : Tout-en-un (3 prompts)

#### 1. Lancer mon projet de A a Z
**Agents** : @orchestrator | **Note : 8/10**
Prompt clair, actionnable, reference directe au livrable attendu (orchestration-plan.md). Bon sequencement Phase 0 a 5. Manque : ne precise pas quels fichiers de contexte sont attendus comme pre-requis au-dela de project-context.md.

#### 2. Faire un check-up complet de mon projet
**Agents** : @reviewer, @elon | **Note : 8/10**
Bonne combinaison d'agents complementaires. Le "Ensuite @elon" implique un enchainement sequentiel bien pense. La mention "GO/NO-GO" donne un critere de sortie clair. Leger risque : deux agents dans un seul prompt peut creer de la confusion sur le perimetre de chacun.

#### 3. Pivoter mon projet
**Agents** : @orchestrator, @creative-strategy | **Note : 8/10**
Excellent prompt pour un cas d'usage avance. "Livrables a reprendre vs ceux a garder" est une instruction precise et utile. Presuppose un project-context.md deja mis a jour, ce qui est clairement indique.

### Categorie 2 : Phase 0 -- Strategie & Fondations (4 prompts)

#### 4. Positionnement & plateforme de marque
**Agents** : @creative-strategy | **Note : 8/10**
Prompt complet qui liste les livrables attendus (positionnement, personas, benchmark, brief). La mention "jobs-to-be-done" est un signal de qualite. Actionnable tel quel.

#### 5. Vision produit & roadmap
**Agents** : @product-manager | **Note : 7/10**
Bon prompt avec reference explicite aux fichiers amont (brand-platform.md). La mention "RICE" est precise. Manque : ne precise pas l'horizon temporel souhaite au-dela de "6 mois" -- l'utilisateur pourrait vouloir un autre horizon.

#### 6. KPIs & tracking plan
**Agents** : @data-analyst | **Note : 8/10**
Tres actionnable. AARRR + North Star Metric + "chaque event, sa source, son trigger" sont des instructions suffisamment precises pour un resultat de qualite. Bon prompt.

#### 7. Audit juridique & conformite
**Agents** : @legal | **Note : 8/10**
Le plus complet de la categorie. Liste exhaustive : RGPD, CGU/CGV, IP, AI Act. La mention "adaptes au modele economique" est un signal d'intelligence contextuelle. Seul point : tres ambitieux pour un seul appel -- risque de timeout sur un livrable aussi dense.

### Categorie 3 : Phase 1 -- Conception (4 prompts)

#### 8. Parcours utilisateur & wireframes
**Agents** : @ux | **Note : 7/10**
Bon prompt. "Onboarding, activation, conversion, retention" couvre les parcours essentiels. Manque : ne precise pas le format attendu pour les wireframes (textuels ? Figma ? ASCII ?). Comme l'agent est textuel, cette precision eviterait des attentes deplacees.

#### 9. Design system complet
**Agents** : @design, @fullstack | **Note : 7/10**
Prompt ambitieux qui couvre tokens + composants + accessibilite + implementation. Risque principal : trop de contenu pour un seul appel. La coordination @design -> @fullstack est implicite (l'un produit, l'autre implemente) mais pourrait etre plus explicite. Mention WCAG 2.2 AA est un bon point de precision.

#### 10. Brand voice & guide d'ecriture
**Agents** : @copywriter | **Note : 8/10**
Excellent prompt. "Vocabulaire autorise/interdit" + "exemples par contexte" + guide UX writing detaille (erreurs, empty states, tooltips, CTAs). Tres actionnable et complet.

#### 11. Landing page complete
**Agents** : @copywriter, @seo | **Note : 8/10**
Bonne synergie multi-agents avec repartition claire : @copywriter redige, @seo optimise. "Hero, benefices, social proof, CTA, FAQ" couvre la structure standard. "Calibre le ton sur le persona principal" est une instruction precise.

### Categorie 4 : Phase 2 -- Developpement (5 prompts)

#### 12. Developper une feature
**Agents** : @fullstack, @qa | **Note : 7/10**
Solide. References explicites aux fichiers amont (functional-specs.md, design system, tracking plan). "Couverture >80%" est un critere mesurable. Manque : ne precise pas QUELLE feature developper -- l'utilisateur doit le savoir, mais un placeholder [nom de feature] serait plus clair.

#### 13. Integrer le paiement Stripe
**Agents** : @fullstack, @legal, @infrastructure | **Note : 8/10**
Prompt tres specifique et bien decompose en 3 axes (code, legal, infra). "Webhook /api/stripe/webhook" est un niveau de detail appreciable. Un des rares prompts a couvrir 3 agents avec une repartition nette.

#### 14. Ajouter une feature IA (LLM)
**Agents** : @ia, @fullstack | **Note : 7/10**
Correct mais manque de precision. "Choix du modele (cout/qualite)" est vague -- devrait mentionner le tableau comparatif obligatoire du protocole @ia. "Fallbacks, limites de tokens" sont de bons ajouts. Ne mentionne pas le ROI ni le budget, pourtant essentiels.

#### 15. Configurer CI/CD & deploiement
**Agents** : @qa, @infrastructure | **Note : 8/10**
Prompt technique bien decompose. Lint + type-check + Vitest + Playwright cote @qa. Replit + health check + Sentry + UptimeRobot cote @infrastructure. Specifique et actionnable.

#### 16. Choisir & optimiser les modeles IA
**Agents** : @ia | **Note : 7/10**
Bon prompt mais redondant avec le prompt 14. "Benchmark : qualite de sortie, latence P95, cout par 1000 requetes" est une bonne structure. Manque : ne mentionne pas le tableau comparatif obligatoire du protocole @ia, ni le calcul de ROI.

### Categorie 5 : Phase 3 -- Visibilite (3 prompts)

#### 17. Strategie SEO technique & editoriale
**Agents** : @seo | **Note : 7/10**
Couvre l'essentiel : Core Web Vitals, JSON-LD, maillage, mots-cles. "Keyword map et templates de metadonnees" sont des livrables concrets. Manque : ne precise pas les pages prioritaires a auditer.

#### 18. Visibilite sur les IA generatives (GEO)
**Agents** : @geo | **Note : 8/10**
Excellent prompt. "Entites nommees, claims verifiables, FAQ optimisee pour les citations IA, restructuration LLM-friendly" -- vocabulaire precis et specifique au domaine GEO. Un des meilleurs prompts de la bibliotheque.

#### 19. SEO + GEO combines
**Agents** : @seo, @geo | **Note : 7/10**
L'intention est bonne (synergie SEO+GEO) mais l'instruction "Coordonnez-vous" est trop vague. Les agents ne se coordonnent pas directement -- c'est l'orchestrateur qui gere. Le prompt devrait expliciter comment les deux livrables s'articulent. Risque de redondance avec les prompts 17 et 18.

### Categorie 6 : Phase 4 -- Acquisition & Croissance (4 prompts)

#### 20. Strategie d'acquisition complete
**Agents** : @growth, @social, @copywriter | **Note : 8/10**
Tres bon prompt multi-agents avec repartition claire : @growth (canaux + CAC/LTV), @social (calendrier), @copywriter (copies). "3 canaux prioritaires selon le persona et le budget" est specifique et contraint.

#### 21. Strategie social media
**Agents** : @social, @copywriter | **Note : 7/10**
Correct. "2-3 plateformes prioritaires" est une bonne contrainte. Manque : ne mentionne pas le budget ads/organique, ni le ton de marque a respecter (reference a brand-voice.md serait utile).

#### 22. Emails onboarding & conversion
**Agents** : @copywriter, @growth | **Note : 8/10**
Prompt bien structure. "5 emails : bienvenue, activation, social proof, upgrade, reengagement" est une structure classique et efficace. "Triggers et KPIs par etape" pour @growth est un bon complement.

#### 23. Auditer le funnel existant
**Agents** : @growth, @data-analyst | **Note : 7/10**
Bon prompt d'audit. "AARRR, taux par etape, points de churn, segments sous-performants" couvre l'essentiel. "Dashboard de conversion par cohorte" est un livrable concret. Manque : presuppose des donnees existantes sans preciser comment les fournir aux agents.

### Categorie 7 : Phase 5 -- Audit & Validation (6 prompts)

#### 24. Revue croisee GO/NO-GO
**Agents** : @reviewer | **Note : 9/10**
Le meilleur prompt de la bibliotheque. "Brand voice <-> copy <-> UI, specs <-> code, conformite legale, couverture tracking" liste explicitement les axes de verification croisee. "GO/NO-GO avec blockers" est un format de sortie clair et decisif. Exemplaire.

#### 25. Revue intermediaire (mid-projet)
**Agents** : @reviewer | **Note : 7/10**
Version allegee du prompt 24. Utile mais un peu redondant. "Signale les derives maintenant" est un bon signal d'urgence. Pourrait etre plus precis sur le perimetre de verification attendu.

#### 26. Audit qualite & tests complets
**Agents** : @qa | **Note : 8/10**
Prompt technique solide. "Vitest >80%, E2E Playwright, tracking-plan implemente, Lighthouse CI" sont des criteres mesurables. "Rapport avec blockers" est un format de sortie clair.

#### 27. Audit UX & conversion
**Agents** : @ux, @data-analyst | **Note : 7/10**
Correct. "Onboarding, conversion, retention, friction points, taux d'abandon" est une bonne liste. La repartition @ux/@data-analyst est claire. Manque : ne mentionne pas de reference aux parcours definis dans user-flows.md.

#### 28. Audit strategique first principles
**Agents** : @elon | **Note : 8/10**
Prompt efficace pour un audit disruptif. "Note chaque dimension sur 10 : vision, execution, moat, scalabilite" donne une grille concrete. "Qu'est-ce qui est du theatre ?" est une formulation percutante et pertinente. "Verdict sans filtre" pose le ton.

#### 29. Monitoring post-launch
**Agents** : @infrastructure | **Note : 8/10**
Tres specifique et actionnable. "Sentry, UptimeRobot, health check, alertes Slack" sont des outils concrets. "Error rate >1%, Core Web Vitals degrades" sont des seuils precis. Bon prompt.

### Categorie 8 : Raccourcis (5 prompts)

#### 30. Refondre un site existant
**Agents** : @ux, @design, @fullstack | **Note : 7/10**
Bonne repartition tri-agents : audit UX, refonte design, migration technique. Chaque agent a un perimetre clair. Manque : ne mentionne pas la strategie de migration (big bang vs progressive), qui est critique pour une refonte.

#### 31. Diagnostiquer un probleme de performance
**Agents** : @infrastructure, @seo | **Note : 7/10**
Bon prompt de diagnostic. LCP, CLS, INP + bundle size + requetes API + crawl budget. La combinaison @infrastructure + @seo est pertinente (perf technique + impact SEO). Correct mais pourrait mentionner les outils de mesure attendus.

#### 32. Auditer la coherence visuelle
**Agents** : @design, @ux | **Note : 7/10**
Prompt correct. "Tokens, typographies, espacements, contrastes WCAG 2.2 AA" cote design. "Parcours visuellement guides, CTA hierarchises" cote UX. Un peu leger -- pourrait demander un rapport structure avec captures/exemples.

#### 33. Optimiser l'onboarding
**Agents** : @ux, @copywriter, @data-analyst | **Note : 8/10**
Bon prompt avec un objectif mesurable : "time-to-value <3 min". Bonne repartition : @ux (flux), @copywriter (microcopy), @data-analyst (funnel). Les "moments de succes" sont un concept UX pertinent.

#### 34. Creer un agent specialise
**Agents** : @agent-factory | **Note : 6/10**
Le prompt le plus faible de la bibliotheque. Le placeholder "[domaine]" est necessaire mais le prompt ne donne aucune indication sur le niveau de specialisation attendu, les livrables types, ou la phase d'insertion. L'instruction "respecte le framework" est vague.

---

## Top 5 meilleurs prompts

| Rang | Prompt | Note | Pourquoi |
|---|---|---|---|
| 1 | Revue croisee GO/NO-GO (#24) | 9/10 | Format de sortie clair, axes de verification explicites, critere decisif GO/NO-GO |
| 2 | Audit juridique & conformite (#7) | 8/10 | Exhaustif (RGPD, CGU, IP, AI Act), adapte au modele economique |
| 3 | Visibilite IA generatives (#18) | 8/10 | Vocabulaire GEO precis, livrables concrets, bon niveau de specialisation |
| 4 | Integrer Stripe (#13) | 8/10 | 3 agents bien coordonnes, niveau de detail technique appreciable |
| 5 | Optimiser l'onboarding (#33) | 8/10 | Objectif mesurable (<3 min), bonne synergie tri-agents |

---

## Prompts a ameliorer (note < 7)

### Creer un agent specialise (#34) -- Note : 6/10

**Probleme** : trop generique. Le placeholder [domaine] est insuffisant. L'utilisateur ne sait pas quoi fournir comme contexte pour obtenir un agent de qualite.

**Suggestion d'amelioration** :
```
@agent-factory J'ai besoin d'un agent specialise en [domaine].
Contexte : [decrire le cas d'usage en 2-3 phrases].
Verifie qu'il n'existe pas deja dans l'equipe.
Cree-le avec : identite (role, experience), champs critiques requis,
livrables types, phase d'insertion dans le pipeline,
et coordination avec les agents existants.
```

---

## Recommandations generales

### 1. Ajouter des references aux fichiers amont dans tous les prompts multi-agents

Certains prompts (ex: #21 Strategie social media) n'indiquent pas quels livrables existants consulter. Chaque prompt devrait mentionner les fichiers pre-requis (brand-platform.md, user-flows.md, etc.) pour garantir la coherence.

### 2. Expliciter la coordination inter-agents

L'instruction "Coordonnez-vous" (prompt #19) n'est pas operationnelle dans le framework actuel. Les agents ne communiquent pas directement entre eux. Remplacer par des instructions sequentielles explicites : "@seo produis X. @geo utilise le livrable de @seo pour produire Y."

### 3. Ajouter des placeholders contextuels la ou necessaire

Le prompt #12 "Developper une feature" ne precise pas laquelle. Le prompt #34 ne precise pas le domaine. Ajouter des placeholders clairs entre crochets avec des exemples : [nom de la feature, ex: "systeme de notifications"].

### 4. Mentionner les risques de timeout pour les prompts ambitieux

Les prompts #7 (audit juridique complet) et #9 (design system complet) demandent un volume de production eleve. Ajouter une note "quand" supplementaire : "Si le livrable est coupe, relancer l'agent pour completer les sections manquantes."

### 5. Harmoniser le niveau de precision

Il y a un ecart entre les prompts tres precis (#24 avec ses axes croises, #15 avec ses outils nommes) et les prompts vagues (#34, #19). Viser un niveau de precision uniforme en listant systematiquement : livrables attendus, format de sortie, et criteres de qualite.

### 6. Ajouter 2-3 prompts manquants

La bibliotheque couvre bien le pipeline standard mais il manque :
- **Migration de stack** : @fullstack + @infrastructure pour migrer d'une techno a une autre
- **Internationalisation (i18n)** : @fullstack + @copywriter pour preparer un produit multi-langue
- **Post-mortem incident** : @infrastructure + @qa pour analyser un incident production

---

## Auto-evaluation du livrable

- [x] Le rapport est specifique a cette bibliotheque de prompts (pas generique)
- [x] Aucune donnee inventee -- toutes les notes sont basees sur l'analyse directe des prompts
- [x] Chaque prompt est evalue individuellement avec commentaire
- [x] Les suggestions d'amelioration sont concretes et actionnables

---

**Handoff -> @orchestrator**
- Fichier produit : `docs/ia/prompt-library-audit.md`
- Decisions prises : note globale 7.6/10, 1 prompt sous le seuil de qualite (< 7), 6 recommandations d'amelioration
- Points d'attention : le prompt #34 (agent-factory) necessite une reecriture, la coordination inter-agents dans les prompts multi-agents doit etre clarifiee, 3 prompts manquants identifies (migration, i18n, post-mortem)
