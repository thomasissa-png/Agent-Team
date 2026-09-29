# Audit de couverture -- Bibliothèque de 39 prompts

> AVIS CONSULTATIF -- Analyse first principles par @elon
> Date : 2026-03-22

## Verdict brutal : 6/10

La bibliothèque couvre bien la phase "construire un produit digital". Elle ne couvre PAS la phase "faire reussir un business". C'est la difference entre assembler une fusee et la faire atterrir sur Mars.

En l'état, ces 39 prompts emmeneront un fondateur de l'idee a un produit lance avec du trafic. Mais ils le laisseront tomber exactement au moment ou 90% des startups meurent : après le lancement, quand il faut retenir, monetiser, scaler et survivre.

---

## Le cycle de vie COMPLET d'un projet (idee -> succès)

Voici chaque étape du parcours réel d'un projet, avec le mapping vers les prompts existants.

### PHASE 0 -- Stratégie & Fondations

| Étape | Prompt existant | Statut |
|---|---|---|
| Définir le projet (context) | "Définir mon projet" | OK |
| Positionnement & marque | "Positionnement & plateforme de marque" | OK |
| Vision produit & roadmap | "Vision produit & roadmap" | OK |
| KPIs & tracking | "KPIs & tracking plan" | OK |
| Specs fonctionnelles | "Specs fonctionnelles detaillees" | OK |
| Audit juridique | "Audit juridique & conformite" | OK |
| **Validation de l'idee / marche** | **MANQUANT** | CRITIQUE |
| **Pricing & monetisation** | **MANQUANT** | CRITIQUE |
| **Analyse concurrentielle approfondie** | Inclus partiellement dans brand-platform | PARTIEL |

**Diagnostic Phase 0 :** Solide sur la stratégie de marque et le produit. TROU BEANT sur la validation marche (est-ce que quelqu'un va payer pour ca ?) et le pricing. Tu construis sans avoir valide que le marche existe. C'est comme concevoir le Cybertruck sans savoir s'il y a des routes.

### PHASE 1 -- Conception

| Étape | Prompt existant | Statut |
|---|---|---|
| Parcours utilisateur & wireframes | "Parcours utilisateur & wireframes" | OK |
| Design system | "Design system complet" | OK |
| Brand voice & guide écriture | "Brand voice & guide d'écriture" | OK |
| Landing page | "Landing page complete" | OK |
| **Prototype / maquettes interactives** | **MANQUANT** | MINEUR |
| **User testing pre-dev** | **MANQUANT** | IMPORTANT |

**Diagnostic Phase 1 :** Bien couverte. Il manque un prompt pour tester les wireframes AVANT de coder. Chez Tesla on ne lance pas la production sans crash tests. Ici on passe du wireframe au code sans validation utilisateur.

### PHASE 2 -- Développement

| Étape | Prompt existant | Statut |
|---|---|---|
| Développer une feature | "Développer une feature" | OK |
| Paiement Stripe | "Integrer le paiement Stripe" | OK |
| Feature IA | "Ajouter une feature IA" | OK |
| CI/CD & déploiement | "Configurer CI/CD & déploiement" | OK |
| Choix modèles IA | "Choisir & optimiser les modèles IA" | OK |
| **Setup initial du projet (scaffold)** | **MANQUANT** | IMPORTANT |
| **Base de données / schema** | **MANQUANT** | IMPORTANT |
| **Authentification** | **MANQUANT** | IMPORTANT |
| **API / backend routes** | **MANQUANT** | IMPORTANT |

**Diagnostic Phase 2 :** "Développer une feature" est générique. Mais il n'y a AUCUN prompt pour le setup initial : créer le projet, définir le schema de base de données, configurer l'authentification. Ce sont les fondations du code. C'est comme avoir un prompt pour installer le moteur d'une fusee mais aucun pour construire la structure.

### PHASE 3 -- Visibilité

| Étape | Prompt existant | Statut |
|---|---|---|
| SEO technique & editorial | "Stratégie SEO" | OK |
| GEO (visibilité IA) | "Visibilité GEO" | OK |
| SEO + GEO combines | "SEO + GEO combines" | OK |
| **Content marketing / blog** | **MANQUANT** | IMPORTANT |
| **Relations presse / PR** | **MANQUANT** | MINEUR |

**Diagnostic Phase 3 :** SEO et GEO sont bien couverts. Mais Zéro prompt pour créer du contenu editorial (articles de blog, guides, lead magnets). Le SEO sans contenu c'est un moteur sans carburant.

### PHASE 4 -- Acquisition & Croissance

| Étape | Prompt existant | Statut |
|---|---|---|
| Stratégie acquisition | "Stratégie d'acquisition complete" | OK |
| Social media | "Stratégie social media" | OK |
| Emails onboarding | "Emails onboarding & conversion" | OK |
| Audit funnel | "Auditer le funnel existant" | OK |
| **Paid ads (Google Ads, Meta Ads)** | **MANQUANT** | IMPORTANT |
| **Referral / viralite** | **MANQUANT** | IMPORTANT |
| **Partnerships / co-marketing** | **MANQUANT** | MINEUR |

**Diagnostic Phase 4 :** Bonne couverture organique. Mais aucun prompt pour le paid acquisition. Pour la plupart des startups, le paid est le levier de croissance #1 en early stage. Et le referral/viralite -- le meilleur ratio CAC/LTV -- est absent.

### PHASE 5 -- Audit & Validation

| Étape | Prompt existant | Statut |
|---|---|---|
| Revue croisee GO/NO-GO | "Revue croisee GO/NO-GO" | OK |
| Revue intermediaire | "Revue intermediaire" | OK |
| Audit qualité & tests | "Audit qualité & tests complets" | OK |
| Audit UX & conversion | "Audit UX & conversion" | OK |
| Audit stratégique | "Audit stratégique first principles" | OK |
| Monitoring post-launch | "Monitoring post-launch" | OK |

**Diagnostic Phase 5 :** La phase la mieux couverte. Rien a redire.

### RACCOURCIS

| Étape | Prompt existant | Statut |
|---|---|---|
| Refondre un site | OK | OK |
| Performance | OK | OK |
| Cohérence visuelle | OK | OK |
| Optimiser onboarding | OK | OK |
| Créer un agent | OK | OK |
| Migrer la stack | OK | OK |
| i18n | OK | OK |
| Post-mortem | OK | OK |

---

## PHASES ENTIERES MANQUANTES

C'est la ou ca fait mal. Voici les phases du cycle de vie d'un business qui n'existent PAS dans la bibliothèque :

### PHASE MANQUANTE : Retention & Engagement (entre Phase 4 et 5)

C'est le trou le plus critique. L'acquisition sans retention c'est remplir un seau perce. Chez Tesla, on ne parle pas juste de ventes -- on parle de "customer lifetime value". Un utilisateur acquis qui churne en 30 jours a un ROI negatif.

Prompts manquants :
- Stratégie de retention (churn analysis, cohortes, engagement loops)
- Notifications & re-engagement (push, in-app, email lifecycle post-onboarding)
- Programme de fidélité / gamification
- Feature discovery (les utilisateurs utilisent-ils toutes les features ?)

### PHASE MANQUANTE : Monetisation & Unit Economics

Tu as un prompt Stripe pour le paiement technique. Mais Zéro pour la stratégie de monetisation : quel pricing ? Quel packaging ? Freemium ou trial ? Upsell path ? C'est comme avoir le terminal de paiement sans savoir quoi mettre sur l'etiquette de prix.

Prompts manquants :
- Stratégie de pricing (modèles, tiers, psychologie des prix)
- Unit economics (CAC, LTV, payback period, marge)
- Optimisation du revenue (upsell, cross-sell, expansion revenue)

### PHASE MANQUANTE : Scale & Operations

Le produit marche, les utilisateurs viennent, ca tient la charge... et après ? Aucun prompt ne couvre ce qui se passe quand on passe de 100 a 10 000 utilisateurs.

Prompts manquants :
- Audit de scalabilite technique (DB, API, cache, CDN)
- Recrutement & team building (qui embaucher en premier ?)
- Process operationnels (support client, SLA, documentation interne)
- Automatisation des operations

### PHASE MANQUANTE : Iteration basee sur les données

Il y a un prompt pour setup le tracking et un pour auditer le funnel. Mais rien entre les deux. Rien pour transformer les données en décisions, en A/B tests, en iterations produit.

Prompts manquants :
- Plan d'A/B testing (quoi tester, hypothèses, protocole)
- Roadmap data-driven (prioriser les features par usage réel)
- Voice of Customer (collecter, analyser, integrer les feedbacks)

---

## Les 10 prompts manquants les plus critiques

Classes par impact sur le succès du projet, du plus critique au moins critique.

| # | Prompt manquant | Pourquoi c'est critique | Agents |
|---|---|---|---|
| 1 | **Validation marche & demand testing** | Tu construis peut-etre un produit que personne ne veut. C'est la cause #1 d'échec des startups. | creative-strategy, growth, data-analyst |
| 2 | **Stratégie de pricing & packaging** | Sans pricing reflechi, tu laisses de l'argent sur la table ou tu fais fuir tes utilisateurs. | product-manager, growth |
| 3 | **Stratégie de retention & anti-churn** | L'acquisition est 5-7x plus chere que la retention. Si tu ne retiens pas, tu brules du cash. | growth, data-analyst, ux |
| 4 | **Setup initial du projet (scaffold + DB + auth)** | Tout dev commence par la. Sans ca, "développer une feature" est suspendu dans le vide. | fullstack, infrastructure |
| 5 | **Stratégie de contenu / content marketing** | Le SEO sans contenu est un squelette sans chair. Le content est le carburant de l'acquisition organique. | copywriter, seo |
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
**Description :** Avant de construire quoi que ce soit, valider que le marche existe. Analyser la demande réelle (volume de recherche, taille marche, willingness-to-pay), identifier les early adopters, concevoir un test de demande (landing page + waitlist, smoke test, interview script). Produire un verdict GO/NO-GO sur la viabilite marche.

### Prompt 2 : Stratégie de pricing & packaging

**Phase :** Phase 0 (après roadmap, avant dev)
**Agents :** product-manager, growth
**Description :** Définir la stratégie de monetisation : modèle (freemium, trial, paywall), nombre de tiers, feature gating par tier, pricing psychologique, analyse de la willingness-to-pay par persona. Benchmarker les concurrents. Produire la grille tarifaire prête a implementer.

### Prompt 3 : Stratégie de retention & anti-churn

**Phase :** Phase 4+ (après lancement)
**Agents :** growth, data-analyst, ux
**Description :** Analyser les cohortes de retention (jour 1, 7, 30). Identifier les moments de churn et leurs causes. Concevoir les engagement loops (notifications, emails lifecycle, feature discovery). Définir les métriques de sante utilisateur. Produire le playbook retention.

### Prompt 4 : Setup initial du projet

**Phase :** Phase 2 (premier prompt de dev)
**Agents :** fullstack, infrastructure
**Description :** Scaffolder le projet complet : structure de fichiers, schema de base de données, configuration auth (Clerk/NextAuth/Supabase Auth), variables d'environnement, middleware, layout de base. Tout ce qu'il faut pour que "développer une feature" ait un socle sur lequel s'appuyer.

### Prompt 5 : Stratégie de contenu & calendrier editorial

**Phase :** Phase 3 (après SEO)
**Agents :** copywriter, seo
**Description :** Définir la stratégie de contenu : piliers thematiques, types de contenu (blog, guides, études de cas, lead magnets), calendrier de publication, distribution. Rediger les 3 premiers articles piliers optimises SEO. Le contenu est le carburant de toute la machine de visibilité.

### Prompt 6 : Plan d'experimentation & A/B testing

**Phase :** Phase 4-5 (produit en production avec trafic)
**Agents :** data-analyst, growth, fullstack
**Description :** Etablir le framework d'experimentation : backlog d'hypothèses priorisees par impact, protocole de test (taille échantillon, duree, métriques), implementation technique des feature flags. Transformer "on pense que" en "on sait que".

### Prompt 7 : Programme de referral & viralite

**Phase :** Phase 4 (après acquisition initiale)
**Agents :** growth, fullstack
**Description :** Concevoir la mécanique de referral : incentive structure (double-sided), parcours d'invitation, tracking des referrals, viralite du produit (k-factor). Implementer le système technique. Tesla a vendu des voitures par referral. Si ca marche pour des voitures a 50K, ca marche pour ton SaaS.

### Prompt 8 : Unit economics & viabilite financière

**Phase :** Phase 0 ou Phase 4 (selon le stade)
**Agents :** data-analyst, growth
**Description :** Calculer les unit economics : CAC par canal, LTV par cohorte, payback period, marge brute, burn rate vs runway. Modeliser 3 scénarios (conservateur, base, optimiste). Répondre a la question : "est-ce que ce business est viable economiquement ?"

### Prompt 9 : Voice of Customer & feedback loops

**Phase :** Phase 4-5 (produit avec utilisateurs)
**Agents :** ux, product-manager, data-analyst
**Description :** Mettre en place la collecte systématique de feedback : in-app surveys (NPS, CSAT), interview scripts, analyse des tickets support, feature request tracking. Transformer les feedbacks en insights actionnables pour la roadmap.

### Prompt 10 : Audit de scalabilite technique

**Phase :** Phase 5 (croissance)
**Agents :** infrastructure, fullstack
**Description :** Stress-tester l'architecture pour 10x le trafic actuel : bottlenecks DB (queries lentes, index manquants), limites API (rate limiting, caching), assets (CDN, compression), coûts infra à l'échelle. Produire le plan de scaling avec les seuils d'alerte.

---

## Synthese structurelle

| Phase projet | Prompts existants | Prompts manquants | Couverture |
|---|---|---|---|
| Phase 0 -- Stratégie | 6 | 2 (validation marche, pricing) | 75% |
| Phase 1 -- Conception | 4 | 1 (user testing) | 80% |
| Phase 2 -- Développement | 5 | 1 (setup initial) | 83% |
| Phase 3 -- Visibilité | 3 | 1 (content marketing) | 75% |
| Phase 4 -- Acquisition | 4 | 2 (paid ads, referral) | 67% |
| Phase 5 -- Audit | 6 | 0 | 100% |
| Retention | 0 | 3 | 0% |
| Monetisation | 0 | 2 | 0% |
| Scale | 0 | 2 | 0% |
| Data-driven iteration | 0 | 2 | 0% |
| **TOTAL** | **39** | **~15 critiques** | **~72%** |

---

## Le mot de la fin

Cette bibliothèque est un excellent moteur de CONSTRUCTION. Elle couvre remarquablement bien la trajectoire "j'ai une idee, je la transforme en produit lance". C'est déjà enorme et c'est mieux que 95% de ce qui existe.

Mais elle s'arrete au lancement. C'est comme si SpaceX avait des procedures pour construire et lancer une Falcon 9, mais rien pour la faire atterrir et la réutiliser. Le lancement c'est 30% du jeu. La retention, la monetisation, l'iteration et le scale c'est les 70% restants.

Les 3 ajouts qui changeraient tout :
1. **Validation marche** (avant de construire) -- éviter de construire un truc que personne ne veut
2. **Retention** (après le lancement) -- garder les utilisateurs qu'on a acquis
3. **Pricing** (stratégie financière) -- s'assurer que le business est viable

Sans ces 3 la, tu as un framework pour construire des produits. Avec ces 3 la, tu as un framework pour construire des BUSINESSES.

---

**Handoff -> utilisateur**
- Fichier produit : `/home/user/Agent-Team/docs/reviews/elon-coverage-audit.md`
- Avis : couverture actuelle 72%, excellent sur la construction, insuffisant sur le business post-lancement
- Points d'attention : les 10 prompts manquants sont listes et specifies, prêts à être créés
- Rappel : ces recommandations sont des AVIS. L'utilisateur decide lesquels créer en priorité.
