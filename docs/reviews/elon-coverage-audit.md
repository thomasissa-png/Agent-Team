# Audit de couverture -- Bibliotheque de 39 prompts

> AVIS CONSULTATIF -- Analyse first principles par @elon
> Date : 2026-03-22

## Verdict brutal : 6/10

La bibliotheque couvre bien la phase "construire un produit digital". Elle ne couvre PAS la phase "faire reussir un business". C'est la difference entre assembler une fusee et la faire atterrir sur Mars.

En l'etat, ces 39 prompts emmeneront un fondateur de l'idee a un produit lance avec du trafic. Mais ils le laisseront tomber exactement au moment ou 90% des startups meurent : apres le lancement, quand il faut retenir, monetiser, scaler et survivre.

---

## Le cycle de vie COMPLET d'un projet (idee -> succes)

Voici chaque etape du parcours reel d'un projet, avec le mapping vers les prompts existants.

### PHASE 0 -- Strategie & Fondations

| Etape | Prompt existant | Statut |
|---|---|---|
| Definir le projet (context) | "Definir mon projet" | OK |
| Positionnement & marque | "Positionnement & plateforme de marque" | OK |
| Vision produit & roadmap | "Vision produit & roadmap" | OK |
| KPIs & tracking | "KPIs & tracking plan" | OK |
| Specs fonctionnelles | "Specs fonctionnelles detaillees" | OK |
| Audit juridique | "Audit juridique & conformite" | OK |
| **Validation de l'idee / marche** | **MANQUANT** | CRITIQUE |
| **Pricing & monetisation** | **MANQUANT** | CRITIQUE |
| **Analyse concurrentielle approfondie** | Inclus partiellement dans brand-platform | PARTIEL |

**Diagnostic Phase 0 :** Solide sur la strategie de marque et le produit. TROU BEANT sur la validation marche (est-ce que quelqu'un va payer pour ca ?) et le pricing. Tu construis sans avoir valide que le marche existe. C'est comme concevoir le Cybertruck sans savoir s'il y a des routes.

### PHASE 1 -- Conception

| Etape | Prompt existant | Statut |
|---|---|---|
| Parcours utilisateur & wireframes | "Parcours utilisateur & wireframes" | OK |
| Design system | "Design system complet" | OK |
| Brand voice & guide ecriture | "Brand voice & guide d'ecriture" | OK |
| Landing page | "Landing page complete" | OK |
| **Prototype / maquettes interactives** | **MANQUANT** | MINEUR |
| **User testing pre-dev** | **MANQUANT** | IMPORTANT |

**Diagnostic Phase 1 :** Bien couverte. Il manque un prompt pour tester les wireframes AVANT de coder. Chez Tesla on ne lance pas la production sans crash tests. Ici on passe du wireframe au code sans validation utilisateur.

### PHASE 2 -- Developpement

| Etape | Prompt existant | Statut |
|---|---|---|
| Developper une feature | "Developper une feature" | OK |
| Paiement Stripe | "Integrer le paiement Stripe" | OK |
| Feature IA | "Ajouter une feature IA" | OK |
| CI/CD & deploiement | "Configurer CI/CD & deploiement" | OK |
| Choix modeles IA | "Choisir & optimiser les modeles IA" | OK |
| **Setup initial du projet (scaffold)** | **MANQUANT** | IMPORTANT |
| **Base de donnees / schema** | **MANQUANT** | IMPORTANT |
| **Authentification** | **MANQUANT** | IMPORTANT |
| **API / backend routes** | **MANQUANT** | IMPORTANT |

**Diagnostic Phase 2 :** "Developper une feature" est generique. Mais il n'y a AUCUN prompt pour le setup initial : creer le projet, definir le schema de base de donnees, configurer l'authentification. Ce sont les fondations du code. C'est comme avoir un prompt pour installer le moteur d'une fusee mais aucun pour construire la structure.

### PHASE 3 -- Visibilite

| Etape | Prompt existant | Statut |
|---|---|---|
| SEO technique & editorial | "Strategie SEO" | OK |
| GEO (visibilite IA) | "Visibilite GEO" | OK |
| SEO + GEO combines | "SEO + GEO combines" | OK |
| **Content marketing / blog** | **MANQUANT** | IMPORTANT |
| **Relations presse / PR** | **MANQUANT** | MINEUR |

**Diagnostic Phase 3 :** SEO et GEO sont bien couverts. Mais ZERO prompt pour creer du contenu editorial (articles de blog, guides, lead magnets). Le SEO sans contenu c'est un moteur sans carburant.

### PHASE 4 -- Acquisition & Croissance

| Etape | Prompt existant | Statut |
|---|---|---|
| Strategie acquisition | "Strategie d'acquisition complete" | OK |
| Social media | "Strategie social media" | OK |
| Emails onboarding | "Emails onboarding & conversion" | OK |
| Audit funnel | "Auditer le funnel existant" | OK |
| **Paid ads (Google Ads, Meta Ads)** | **MANQUANT** | IMPORTANT |
| **Referral / viralite** | **MANQUANT** | IMPORTANT |
| **Partnerships / co-marketing** | **MANQUANT** | MINEUR |

**Diagnostic Phase 4 :** Bonne couverture organique. Mais aucun prompt pour le paid acquisition. Pour la plupart des startups, le paid est le levier de croissance #1 en early stage. Et le referral/viralite -- le meilleur ratio CAC/LTV -- est absent.

### PHASE 5 -- Audit & Validation

| Etape | Prompt existant | Statut |
|---|---|---|
| Revue croisee GO/NO-GO | "Revue croisee GO/NO-GO" | OK |
| Revue intermediaire | "Revue intermediaire" | OK |
| Audit qualite & tests | "Audit qualite & tests complets" | OK |
| Audit UX & conversion | "Audit UX & conversion" | OK |
| Audit strategique | "Audit strategique first principles" | OK |
| Monitoring post-launch | "Monitoring post-launch" | OK |

**Diagnostic Phase 5 :** La phase la mieux couverte. Rien a redire.

### RACCOURCIS

| Etape | Prompt existant | Statut |
|---|---|---|
| Refondre un site | OK | OK |
| Performance | OK | OK |
| Coherence visuelle | OK | OK |
| Optimiser onboarding | OK | OK |
| Creer un agent | OK | OK |
| Migrer la stack | OK | OK |
| i18n | OK | OK |
| Post-mortem | OK | OK |

---

## PHASES ENTIERES MANQUANTES

C'est la ou ca fait mal. Voici les phases du cycle de vie d'un business qui n'existent PAS dans la bibliotheque :

### PHASE MANQUANTE : Retention & Engagement (entre Phase 4 et 5)

C'est le trou le plus critique. L'acquisition sans retention c'est remplir un seau perce. Chez Tesla, on ne parle pas juste de ventes -- on parle de "customer lifetime value". Un utilisateur acquis qui churne en 30 jours a un ROI negatif.

Prompts manquants :
- Strategie de retention (churn analysis, cohortes, engagement loops)
- Notifications & re-engagement (push, in-app, email lifecycle post-onboarding)
- Programme de fidelite / gamification
- Feature discovery (les utilisateurs utilisent-ils toutes les features ?)

### PHASE MANQUANTE : Monetisation & Unit Economics

Tu as un prompt Stripe pour le paiement technique. Mais ZERO pour la strategie de monetisation : quel pricing ? Quel packaging ? Freemium ou trial ? Upsell path ? C'est comme avoir le terminal de paiement sans savoir quoi mettre sur l'etiquette de prix.

Prompts manquants :
- Strategie de pricing (modeles, tiers, psychologie des prix)
- Unit economics (CAC, LTV, payback period, marge)
- Optimisation du revenue (upsell, cross-sell, expansion revenue)

### PHASE MANQUANTE : Scale & Operations

Le produit marche, les utilisateurs viennent, ca tient la charge... et apres ? Aucun prompt ne couvre ce qui se passe quand on passe de 100 a 10 000 utilisateurs.

Prompts manquants :
- Audit de scalabilite technique (DB, API, cache, CDN)
- Recrutement & team building (qui embaucher en premier ?)
- Process operationnels (support client, SLA, documentation interne)
- Automatisation des operations

### PHASE MANQUANTE : Iteration basee sur les donnees

Il y a un prompt pour setup le tracking et un pour auditer le funnel. Mais rien entre les deux. Rien pour transformer les donnees en decisions, en A/B tests, en iterations produit.

Prompts manquants :
- Plan d'A/B testing (quoi tester, hypotheses, protocole)
- Roadmap data-driven (prioriser les features par usage reel)
- Voice of Customer (collecter, analyser, integrer les feedbacks)

---

## Les 10 prompts manquants les plus critiques

Classes par impact sur le succes du projet, du plus critique au moins critique.

| # | Prompt manquant | Pourquoi c'est critique | Agents |
|---|---|---|---|
| 1 | **Validation marche & demand testing** | Tu construis peut-etre un produit que personne ne veut. C'est la cause #1 d'echec des startups. | creative-strategy, growth, data-analyst |
| 2 | **Strategie de pricing & packaging** | Sans pricing reflechi, tu laisses de l'argent sur la table ou tu fais fuir tes utilisateurs. | product-manager, growth |
| 3 | **Strategie de retention & anti-churn** | L'acquisition est 5-7x plus chere que la retention. Si tu ne retiens pas, tu brules du cash. | growth, data-analyst, ux |
| 4 | **Setup initial du projet (scaffold + DB + auth)** | Tout dev commence par la. Sans ca, "developper une feature" est suspendu dans le vide. | fullstack, infrastructure |
| 5 | **Strategie de contenu / content marketing** | Le SEO sans contenu est un squelette sans chair. Le content est le carburant de l'acquisition organique. | copywriter, seo |
| 6 | **Plan d'A/B testing & experimentation** | Sans experimentation, tu iteres a l'aveugle. Les gagnants testent, les perdants devinent. | data-analyst, growth, fullstack |
| 7 | **Programme de referral / viralite** | Le meilleur canal d'acquisition (CAC ~0). Dropbox, Tesla, PayPal -- tous ont scale par le referral. | growth, fullstack |
| 8 | **Unit economics & financial model** | Si tu ne connais pas ton CAC, ta LTV et ton payback period, tu ne sais pas si ton business est viable. | data-analyst, growth |
| 9 | **Voice of Customer (feedback loops)** | Les meilleurs produits sont construits avec les utilisateurs, pas pour eux. | ux, product-manager, data-analyst |
| 10 | **Audit de scalabilite technique** | Ce qui tient a 100 users ne tient pas a 10K. Mieux vaut anticiper que reconstruire en urgence. | infrastructure, fullstack |

---

## Recommandations de nouveaux prompts

### Prompt 1 : Validation marche & demand testing

**Phase :** Phase 0 (avant tout le reste)
**Agents :** creative-strategy, growth, data-analyst
**Description :** Avant de construire quoi que ce soit, valider que le marche existe. Analyser la demande reelle (volume de recherche, taille marche, willingness-to-pay), identifier les early adopters, concevoir un test de demande (landing page + waitlist, smoke test, interview script). Produire un verdict GO/NO-GO sur la viabilite marche.

### Prompt 2 : Strategie de pricing & packaging

**Phase :** Phase 0 (apres roadmap, avant dev)
**Agents :** product-manager, growth
**Description :** Definir la strategie de monetisation : modele (freemium, trial, paywall), nombre de tiers, feature gating par tier, pricing psychologique, analyse de la willingness-to-pay par persona. Benchmarker les concurrents. Produire la grille tarifaire prete a implementer.

### Prompt 3 : Strategie de retention & anti-churn

**Phase :** Phase 4+ (apres lancement)
**Agents :** growth, data-analyst, ux
**Description :** Analyser les cohortes de retention (jour 1, 7, 30). Identifier les moments de churn et leurs causes. Concevoir les engagement loops (notifications, emails lifecycle, feature discovery). Definir les metriques de sante utilisateur. Produire le playbook retention.

### Prompt 4 : Setup initial du projet

**Phase :** Phase 2 (premier prompt de dev)
**Agents :** fullstack, infrastructure
**Description :** Scaffolder le projet complet : structure de fichiers, schema de base de donnees, configuration auth (Clerk/NextAuth/Supabase Auth), variables d'environnement, middleware, layout de base. Tout ce qu'il faut pour que "developper une feature" ait un socle sur lequel s'appuyer.

### Prompt 5 : Strategie de contenu & calendrier editorial

**Phase :** Phase 3 (apres SEO)
**Agents :** copywriter, seo
**Description :** Definir la strategie de contenu : piliers thematiques, types de contenu (blog, guides, etudes de cas, lead magnets), calendrier de publication, distribution. Rediger les 3 premiers articles piliers optimises SEO. Le contenu est le carburant de toute la machine de visibilite.

### Prompt 6 : Plan d'experimentation & A/B testing

**Phase :** Phase 4-5 (produit en production avec trafic)
**Agents :** data-analyst, growth, fullstack
**Description :** Etablir le framework d'experimentation : backlog d'hypotheses priorisees par impact, protocole de test (taille echantillon, duree, metriques), implementation technique des feature flags. Transformer "on pense que" en "on sait que".

### Prompt 7 : Programme de referral & viralite

**Phase :** Phase 4 (apres acquisition initiale)
**Agents :** growth, fullstack
**Description :** Concevoir la mecanique de referral : incentive structure (double-sided), parcours d'invitation, tracking des referrals, viralite du produit (k-factor). Implementer le systeme technique. Tesla a vendu des voitures par referral. Si ca marche pour des voitures a 50K, ca marche pour ton SaaS.

### Prompt 8 : Unit economics & viabilite financiere

**Phase :** Phase 0 ou Phase 4 (selon le stade)
**Agents :** data-analyst, growth
**Description :** Calculer les unit economics : CAC par canal, LTV par cohorte, payback period, marge brute, burn rate vs runway. Modeliser 3 scenarios (conservateur, base, optimiste). Repondre a la question : "est-ce que ce business est viable economiquement ?"

### Prompt 9 : Voice of Customer & feedback loops

**Phase :** Phase 4-5 (produit avec utilisateurs)
**Agents :** ux, product-manager, data-analyst
**Description :** Mettre en place la collecte systematique de feedback : in-app surveys (NPS, CSAT), interview scripts, analyse des tickets support, feature request tracking. Transformer les feedbacks en insights actionnables pour la roadmap.

### Prompt 10 : Audit de scalabilite technique

**Phase :** Phase 5 (croissance)
**Agents :** infrastructure, fullstack
**Description :** Stress-tester l'architecture pour 10x le trafic actuel : bottlenecks DB (queries lentes, index manquants), limites API (rate limiting, caching), assets (CDN, compression), couts infra a l'echelle. Produire le plan de scaling avec les seuils d'alerte.

---

## Synthese structurelle

| Phase projet | Prompts existants | Prompts manquants | Couverture |
|---|---|---|---|
| Phase 0 -- Strategie | 6 | 2 (validation marche, pricing) | 75% |
| Phase 1 -- Conception | 4 | 1 (user testing) | 80% |
| Phase 2 -- Developpement | 5 | 1 (setup initial) | 83% |
| Phase 3 -- Visibilite | 3 | 1 (content marketing) | 75% |
| Phase 4 -- Acquisition | 4 | 2 (paid ads, referral) | 67% |
| Phase 5 -- Audit | 6 | 0 | 100% |
| Retention | 0 | 3 | 0% |
| Monetisation | 0 | 2 | 0% |
| Scale | 0 | 2 | 0% |
| Data-driven iteration | 0 | 2 | 0% |
| **TOTAL** | **39** | **~15 critiques** | **~72%** |

---

## Le mot de la fin

Cette bibliotheque est un excellent moteur de CONSTRUCTION. Elle couvre remarquablement bien la trajectoire "j'ai une idee, je la transforme en produit lance". C'est deja enorme et c'est mieux que 95% de ce qui existe.

Mais elle s'arrete au lancement. C'est comme si SpaceX avait des procedures pour construire et lancer une Falcon 9, mais rien pour la faire atterrir et la reutiliser. Le lancement c'est 30% du jeu. La retention, la monetisation, l'iteration et le scale c'est les 70% restants.

Les 3 ajouts qui changeraient tout :
1. **Validation marche** (avant de construire) -- eviter de construire un truc que personne ne veut
2. **Retention** (apres le lancement) -- garder les utilisateurs qu'on a acquis
3. **Pricing** (strategie financiere) -- s'assurer que le business est viable

Sans ces 3 la, tu as un framework pour construire des produits. Avec ces 3 la, tu as un framework pour construire des BUSINESSES.

---

**Handoff -> utilisateur**
- Fichier produit : `/home/user/Agent-Team/docs/reviews/elon-coverage-audit.md`
- Avis : couverture actuelle 72%, excellent sur la construction, insuffisant sur le business post-lancement
- Points d'attention : les 10 prompts manquants sont listes et specifies, prets a etre crees
- Rappel : ces recommandations sont des AVIS. L'utilisateur decide lesquels creer en priorite.
