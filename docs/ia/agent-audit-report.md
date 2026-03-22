# Audit des 17 agents Gradient Agents

> Audit realise par @ia le 2026-03-22
> Methodologie : lecture integrale de chaque fichier agent, evaluation sur 10 criteres standardises, note /10

---

## Grille d'evaluation

| # | Critere | Poids |
|---|---------|-------|
| 1 | Clarte de l'identite | Le persona est-il credible, precis, differenciant ? |
| 2 | Completude des competences | Couvre-t-il bien son domaine sans deborder ? |
| 3 | Protocole d'entree | Champs critiques pertinents et suffisants ? |
| 4 | Calibration | Lit-il les bons livrables amont ? Fait-il les bonnes recherches ? |
| 5 | Gestion des timeouts | Regles anti-coupure adaptees au type d'agent ? |
| 6 | Protocole d'escalade | Sait-il quand passer la main ? A qui ? |
| 7 | Regle anti-invention | Presente et adaptee au contexte ? |
| 8 | Auto-evaluation | Questions specifiques pertinentes et exigeantes ? |
| 9 | Handoff | Format clair, destinataires logiques ? |
| 10 | Livrables | Bien definis, actionnables, dans le bon chemin ? |

---

## 1. @orchestrator

**Note : 9.5/10**

**Points forts :**
- Le plus complet de tous les agents, de loin. 470 lignes de prompt avec une profondeur remarquable : criteres de qualite minimum par champ (tableau Insuffisant/Suffisant), protocole de clarification de la demande, priorisation par stade x KPI x budget, feedback remontant, degradation gracieuse.
- Le mapping `subagent_type` et le format de prompt Task sont parfaitement documentes -- un orchestrateur peut executer sans ambiguite.
- Le protocole d'enrichissement du `project-context.md` apres chaque phase est une decision d'architecture excellente : il garantit que le contexte s'enrichit au fil du projet au lieu de rester statique.

**Points faibles / ameliorations suggerees :**
- Pas de calibration WebSearch. L'orchestrateur ne fait aucune recherche externe pour valider le secteur ou les concurrents avant de lancer les agents. Il delegue totalement cette responsabilite aux sous-agents, ce qui est coherent mais pourrait manquer une vue macro.
- La section "Mode revision" est minimale (4 lignes) compare au reste du fichier. Pour un orchestrateur qui peut recevoir un plan existant a ameliorer, il faudrait un protocole de diff plus precis.
- Manque un mecanisme de budget temps / budget tokens global pour le projet. L'orchestrateur gere les timeouts message par message mais ne planifie pas le cout total d'une orchestration complete.

**Verdict :** Agent phare du framework, d'une maturite exceptionnelle. Les rares manques sont peripheriques.

---

## 2. @fullstack

**Note : 9/10**

**Points forts :**
- Conventions de nommage et structure de projet documentees avec une precision rare -- PascalCase pour composants, camelCase pour hooks, structure `src/` complete. Cela elimine les ambiguites classiques des projets multi-developpeurs.
- Couverture technique large et coherente : App Router, Server Actions, Expo/React Native, Stripe, Supabase, API publique avec webhooks et SDK. Le choix de stack est opinionnaire et assume (shadcn/ui + Radix + Tailwind).
- La calibration lit les bons fichiers amont (design-system, functional-specs, tracking-plan) et signale les manques au lieu de deviner.

**Points faibles / ameliorations suggerees :**
- Pas de section calibration WebSearch. Pour un agent code, c'est moins critique que pour un agent strategie, mais une recherche sur les versions actuelles des librairies (Next.js, shadcn, etc.) eviterait du code obsolete.
- Le chemin des livrables doc est flou : "documentation technique dans `docs/` a la racine (pas dans un sous-dossier agent)". Cela contredit la convention globale du CLAUDE.md ou chaque agent a son dossier. Ou va `dev-decisions.md` exactement ?
- Pas de mention explicite de la gestion des migrations de base de donnees (Prisma migrate) ni des seeds de donnees de test.

**Verdict :** Agent technique solide, bien calibre sur l'ecosysteme Next.js. Le point de friction est le chemin de documentation qui devrait etre clarifie.

---

## 3. @qa

**Note : 8.5/10**

**Points forts :**
- Couverture exhaustive des types de tests : unitaire (Vitest), E2E (Playwright), performance (Lighthouse CI), accessibilite (axe-core), regression visuelle (screenshots). C'est un pipeline de test complet.
- La validation du tracking-plan est une fonctionnalite unique et precieuse : utiliser Grep pour verifier que chaque event du plan est implemente dans le code. Cela cree un pont concret entre @data-analyst et @fullstack.
- Le protocole d'entree lit d'abord les livrables de @fullstack et @product-manager, ce qui est l'ordre correct.

**Points faibles / ameliorations suggerees :**
- Pas de WebSearch dans les tools declares. Un agent QA devrait pouvoir rechercher les versions actuelles des outils (Playwright, Vitest) et les best practices de configuration.
- La calibration ne mentionne pas la lecture du design-system. Les tests de regression visuelle devraient etre calibres sur les tokens de @design (couleurs, spacing) pour detecter les ecarts.
- Le protocole d'escalade envoie les bugs a @fullstack et les failles a @infrastructure, mais ne mentionne pas @ia pour les problemes specifiques aux integrations LLM (hallucinations, timeouts API, qualite des reponses).

**Verdict :** Agent QA methodique et bien structure. Les manques sont des cas limites (tests IA, calibration design) qui pourraient etre ajoutes sans refonte.

---

## 4. @design

**Note : 8/10**

**Points forts :**
- Calibration excellente : lit le brand-platform et les personas, puis fait un benchmark visuel des concurrents via WebSearch pour identifier les codes visuels dominants et les espaces libres. C'est exactement la demarche differenciante attendue.
- Mention explicite de l'accessibilite WCAG 2.2 AA des la conception, pas en post-production. C'est un positionnement fort et correct.
- Les auto-evaluations sont precises : contrastes WCAG, implementabilite en Tailwind CSS sans ambiguite, variants/etats/responsive documentes.

**Points faibles / ameliorations suggerees :**
- L'agent ne lit pas `docs/ux/user-flows.md` ni `docs/ux/wireframes.md` dans sa calibration. C'est un manque significatif : le design DOIT etre calibre sur les wireframes UX. La phrase "Travaille toujours apres UX" est dans l'identite mais pas traduite en protocole de calibration.
- Pas de mention du dark mode dans la calibration ou les auto-evaluations alors qu'il est cite dans les competences et le frontmatter. Un design system avec dark mode devrait verifier les contrastes dans les deux modes.
- Les champs critiques ne demandent pas le champ "Concurrent principal" qui serait utile pour le benchmark visuel.

**Verdict :** Bon agent design avec une approche systeme solide. Le principal manque est l'absence de calibration sur les livrables UX, ce qui risque de creer un design deconnecte des parcours.

---

## 5. @ux

**Note : 8/10**

**Points forts :**
- Identite credible et differenciante : certifiee Nielsen Norman Group, specialiste activation/retention, "a reduit le churn de 35% sur 3 produits". Le persona est ancre dans des resultats mesurables.
- Bonne couverture des patterns SaaS : onboarding, aha moment, empty states, progressive disclosure. C'est le vocabulaire exact d'un Lead UX SaaS.
- La calibration WebSearch sur les patterns UX concurrents et les best practices d'onboarding est bien pensee.

**Points faibles / ameliorations suggerees :**
- Les auto-evaluations specifiques sont un peu courtes (3 questions seulement). Il manque des questions sur l'accessibilite (navigation clavier, screen readers -- mentionnes dans les competences mais absents de l'auto-evaluation) et sur la coherence avec les specs produit.
- La calibration ne mentionne pas la lecture du `docs/strategy/brand-platform.md`. Le parcours UX doit etre coherent avec le positionnement de marque (un outil "premium et sobre" n'a pas le meme onboarding qu'un outil "fun et accessible").
- Pas de mention de delivrables intermediaires ou de prototypage rapide. Un agent UX devrait pouvoir produire un prototype cliquable ou au minimum un flow interactif en Markdown structure.

**Verdict :** Agent UX solide, bien positionne dans la chaine (apres creative-strategy/product-manager, avant design). Manque une calibration sur le brand-platform.

---

## 6. @copywriter

**Note : 8.5/10**

**Points forts :**
- Le protocole de calibration sectorielle est excellent et unique parmi les agents : il impose d'analyser 2-3 concurrents, de definir le registre lexical et le champ lexical dominant AVANT de produire la premiere ligne. Cela garantit un copy ancre dans la realite du secteur.
- Couverture de competences remarquablement large et coherente : conversion, brand voice, UX writing, email sequences, help center, changelog. C'est un agent qui couvre tout le cycle de vie textuel d'un produit, pas seulement la landing page.
- Les champs critiques sont les plus pertinents de tous les agents : "3 mots qui definissent la marque" et "3 mots qui ne definissent PAS la marque" forcent une reflexion de positionnement avant toute production.

**Points faibles / ameliorations suggerees :**
- Pas de calibration sur les livrables amont de @creative-strategy (`docs/strategy/brand-platform.md`, `docs/strategy/personas.md`). L'agent mentionne que le ton de marque doit etre defini, mais ne lit pas explicitement les fichiers de @creative-strategy dans un protocole de calibration structure. C'est un manque significatif car le brand voice DOIT decouler du brand platform.
- Pas de mention de la calibration sur le keyword-map de @seo. Le copy SEO-friendly est cite dans les competences mais aucune lecture de `docs/seo/keyword-map.md` n'est prevue dans le protocole d'entree.
- L'auto-evaluation manque de questions sur la coherence avec le brand platform et sur l'accessibilite du langage (niveau de lecture, inclusivite).

**Verdict :** Agent copywriter solide avec un protocole de calibration sectorielle exemplaire. Le principal manque est l'absence de lecture explicite des livrables de @creative-strategy et @seo dans la calibration.

---

## 7. @seo

**Note : 8/10**

**Points forts :**
- Competences techniques Next.js tres precises : `generateMetadata`, sitemap.xml dynamique, JSON-LD avec les types exacts (Organization, Product, FAQPage, BreadcrumbList, Article). C'est directement actionnable par @fullstack sans interpretation.
- Bonne articulation avec @geo documentee dans l'identite ("travaille en coordination avec @geo pour maximiser la visibilite totale") et dans le protocole d'escalade. Le tandem SEO/GEO est explicitement gere.
- L'auto-evaluation couvre les 3 dimensions essentielles : structured data valides, couverture des 3 intentions de recherche, cocon semantique coherent.

**Points faibles / ameliorations suggerees :**
- Pas de calibration structuree. Contrairement a @creative-strategy qui a un protocole de calibration en 4 etapes, @seo n'a aucune section de calibration. Il manque la lecture de `docs/strategy/brand-platform.md` (pour comprendre le positionnement), de `docs/copy/landing-page-copy.md` (pour optimiser le contenu existant), et une WebSearch sur les mots-cles concurrents.
- Les champs critiques sont minimalistes : "Secteur, Persona principal, Stack technique". Il manque des champs comme l'URL du site (pour l'audit technique), le domaine cible, les concurrents directs, et les objectifs de trafic.
- Pas de mention du SEO programmatique (pages generees dynamiquement) qui est pourtant un levier majeur pour les SaaS Next.js. Les templates de metadata sont mentionnes mais pas la strategie de generation de pages a grande echelle.

**Verdict :** Agent SEO competent techniquement, bien articule avec @geo, mais qui souffre d'un manque de calibration structuree et de champs critiques trop legers pour un travail SEO rigoureux.

---

## 8. @geo

**Note : 7.5/10**

**Points forts :**
- Positionnement unique et pionnier dans le framework. C'est le seul agent dedie au GEO (Generative Engine Optimization), un domaine emergent que la plupart des equipes ignorent encore. L'identite est credible : "4 ans de R&D sur la presence dans les moteurs generatifs".
- Les auto-evaluations specifiques sont precises et differenciantes : claims verifiables et sources, double compatibilite SEO/GEO, entites nommees extractibles par un LLM. Ce sont les bonnes questions pour ce domaine.
- La coordination avec @seo est bien geree dans le protocole d'escalade ("co-arbitrer avec @seo, documenter la resolution"), evitant le risque de cannibalisation entre les deux strategies.

**Points faibles / ameliorations suggerees :**
- Pas de calibration structuree. L'agent n'a aucune section de calibration obligatoire. Il devrait lire `docs/seo/seo-strategy.md` et `docs/seo/keyword-map.md` pour s'aligner sur la strategie SEO existante, et `docs/strategy/brand-platform.md` pour les entites de marque a pousser dans les LLM.
- L'outil Bash est absent des tools declares, mais l'agent n'a pas non plus WebSearch pour tester en temps reel si la marque est citee par les LLM. La WebSearch est declaree mais aucun protocole ne precise comment l'utiliser pour le monitoring des citations (quelles requetes, quels LLM interroger via web).
- Le domaine est si jeune que les "competences" restent en partie theoriques. Les mecanismes de citation de chaque LLM evolvent mensuellement. L'agent devrait avoir un protocole de veille WebSearch obligatoire sur les derniers changements des moteurs generatifs avant chaque intervention.

**Verdict :** Agent innovant qui occupe un creneau strategique crucial, mais qui manque de calibration structuree et de protocoles de veille formalises pour un domaine aussi volatile.

---

## 9. @ia

**Note : 8.5/10**

**Points forts :**
- Couverture technique la plus large du framework : APIs LLM (Claude, Gemini, GPT, Mistral, Llama), generation de medias (images, audio, video), architecture multi-agents, MCP, Vercel AI SDK. C'est un agent qui peut intervenir sur n'importe quel aspect IA d'un projet.
- La calibration est exemplaire et bien sequencee : lire les specs fonctionnelles, lire l'infra, scanner le code existant, puis WebSearch les tarifs actuels. L'instruction "ne jamais se baser sur des prix memorises" est une decision d'ingenierie mature.
- L'auto-evaluation cible les 3 dimensions critiques en production IA : cout documente et compatible budget, fallback prevu, prompt caching optimise. Ce sont exactement les questions qu'un CTO poserait avant de valider un pipeline IA.

**Points faibles / ameliorations suggerees :**
- L'ordre des sections est incoherent : "Gestion des timeouts" apparait AVANT "Protocole d'entree obligatoire" (ligne 48 vs ligne 61). Tous les autres agents ont l'entree en premier. Ce desordre pourrait amener l'agent a ecrire avant d'avoir lu le contexte projet.
- Pas de mention de la securite des API keys et du rate limiting dans les competences ou l'auto-evaluation. Pour un agent qui integre 5+ APIs externes, la gestion des secrets, la rotation des cles, et les strategies de retry/backoff sont critiques.
- Pas de calibration sur `docs/strategy/brand-platform.md` ou `docs/ux/user-flows.md`. Les choix IA (qualite des reponses, latence acceptable, ton du modele) devraient etre calibres sur le positionnement de marque et les parcours utilisateur.

**Verdict :** Agent IA complet et bien calibre sur les aspects cout/performance. Le desordre structurel et l'absence de considerations securite sont les points a corriger en priorite.

---

## 10. @infrastructure

**Note : 9/10**

**Points forts :**
- Le plus complet des agents techniques apres @orchestrator. La section "Contraintes Replit" est une decision d'architecture lucide : elle documente explicitement ce que l'agent ne fait PAS (deploiement) et ce qu'il prepare (compatibilite). C'est rare et precieux dans un framework multi-agents.
- La section "Monitoring post-launch" est remarquablement detaillee : error tracking (Sentry + fallback gratuit), health checks (/api/health), performance continue (Lighthouse CI), alerting avec seuils precis (error rate > 1%, latence P95 > 2s, disponibilite < 99.5%). C'est un plan de monitoring actionnable, pas une liste de voeux pieux.
- La calibration lit les bons fichiers dans le bon ordre : ai-architecture (services a deployer), tracking-plan (env vars analytics), structure src/, et verifie l'existence des configs avant d'ecraser. C'est methodique.

**Points faibles / ameliorations suggerees :**
- WebSearch n'est pas dans les tools declares. Pour un agent infrastructure, c'est un manque : il devrait pouvoir rechercher les tarifs actuels des services (Sentry, BetterStack, Supabase), les limites du free tier Replit, et les meilleures pratiques de configuration Next.js en production.
- L'auto-evaluation a 5 questions (le maximum du framework) mais il manque une question sur les backups et la strategie de disaster recovery. Meme sur Replit, la question "que se passe-t-il si la base de donnees est corrompue ?" merite une reponse documentee.
- Pas de mention de la strategie de cache (Redis, ISR, CDN) dans les auto-evaluations alors que c'est cite dans les competences. Le cache est souvent le levier #1 de performance mais il n'est pas verifie en sortie.

**Verdict :** Agent infrastructure mature et methodique, avec un niveau de detail operationnel rare. L'absence de WebSearch dans les tools et le manque de questions sur le backup/cache sont les seuls angles morts.

---

## 11. @creative-strategy

**Note : 8/10**

**Points forts :**
- Positionnement clair comme "premier agent a invoquer sur un nouveau projet". L'identite est credible et ambitieuse : "18 ans en agences parisiennes et londoniennes, 40+ marques dont 12 devenues leaders de leur categorie". Le persona inspire confiance sur les sujets de marque.
- Le protocole de calibration est le meilleur du framework avec celui de @copywriter : WebSearch 3-5 concurrents, identifier les patterns communs (a eviter), trouver l'espace libre, construire le positionnement dans cet espace. C'est la methodologie exacte d'un planneur strategique senior.
- Les champs critiques sont bien choisis : Secteur, Persona principal, Probleme principal, Alternative actuelle. Ce sont les 4 piliers d'un positionnement, et refuser de travailler sans eux est la bonne decision.

**Points faibles / ameliorations suggerees :**
- Pas de calibration sur les livrables existants d'autres agents. Si @creative-strategy est invoquer apres un premier cycle (revision), il devrait lire `docs/copy/brand-voice.md`, `docs/seo/keyword-map.md`, et `docs/ux/user-flows.md` pour verifier la coherence. La section de calibration ne mentionne que WebSearch, pas de lecture interne.
- Le handoff est vague quand invoquer en direct : "handoff vers l'agent le plus pertinent pour la suite". Les autres agents nomment explicitement 2 destinataires. @creative-strategy devrait cibler @copywriter (pour le brand voice) et @design (pour l'identite visuelle) comme destinataires naturels.
- Pas de mention d'un livrable de "territoire verbal" ou de "do/don't" de marque. Le brand-platform et le creative-brief sont prevus, mais un guide des mots et formulations a utiliser/eviter (distincts du brand-voice de @copywriter) serait utile comme pont entre strategie et execution.

**Verdict :** Agent fondateur bien positionne dans la chaine, avec un protocole de calibration concurrentielle exemplaire. Le manque de lecture de livrables internes et le handoff imprecis sont les axes d'amelioration.

---

## 12. @product-manager

**Note : 8.5/10**

**Points forts :**
- Couverture fonctionnelle exemplaire : vision produit, roadmap horizons 1/2/3, user stories job-to-be-done, priorisation RICE/MoSCoW/ICE chiffree, pricing, feedback loops. C'est un PM complet qui couvre le cycle de vie produit de bout en bout, pas seulement les specs.
- La calibration lit les bons fichiers amont (`brand-platform.md`, `personas.md`) et impose un benchmark concurrentiel WebSearch avant de definir le scope MVP. C'est la methodologie correcte : comprendre le marche avant de specifier.
- Les auto-evaluations sont les plus exigeantes du framework avec 5 questions specifiques qui couvrent les 5 dimensions critiques d'un PM : acceptance criteria testables, priorisation chiffree, scope MVP defendable, recherche utilisateur, pricing benchmark.

**Points faibles / ameliorations suggerees :**
- Les champs critiques sont insuffisants : "Objectif principal a 6 mois, Persona principal, Stack technique". Il manque cruellement le champ "Modele economique" (SaaS, marketplace, freemium, B2C, B2B) qui conditionne toute la strategie produit. La stack technique est moins critique pour un PM que le business model.
- Pas de calibration sur `docs/analytics/kpi-framework.md` ni `docs/growth/growth-strategy.md`. Un PM devrait integrer les contraintes de mesure et d'acquisition dans ses specs, pas les decouvrir apres coup.
- Le handoff en direct cible @data-analyst ou @fullstack, mais omet @ux qui est pourtant le destinataire naturel des specs fonctionnelles pour la conception des parcours. C'est un chainon manquant dans le workflow.

**Verdict :** Agent PM mature et methodique, avec des auto-evaluations exemplaires. Le principal manque est l'absence du modele economique dans les champs critiques et le handoff incomplet vers @ux.

---

## 13. @data-analyst

**Note : 9/10**

**Points forts :**
- Positionnement temporel explicite et pertinent : "Phase 0, immediatement apres product-manager, AVANT le developpement". Cette section "Position dans l'ordre d'intervention" est unique parmi les 17 agents et resout un probleme reel : le tracking pense en retard est du tracking perdu. C'est une decision d'architecture du framework.
- Calibration la plus complete du framework : lit les specs fonctionnelles (pour les events), les user flows (pour le funnel), les personas (pour les KPIs comportementaux), et WebSearch les benchmarks sectoriels. Les 4 sources d'information sont les bonnes, dans le bon ordre.
- Couverture de competences equilibree entre setup (GA4, Mixpanel, PostHog), analyse (cohortes, retention, attribution) et experimentation (A/B, CRO). L'agent couvre le cycle complet : definir quoi mesurer, mesurer, et agir sur les mesures.

**Points faibles / ameliorations suggerees :**
- Les champs critiques demandent "Outils d'analytics" mais ce champ risque d'etre vide au debut d'un projet -- c'est justement a @data-analyst de recommander l'outil. Il serait plus pertinent de demander "Budget analytics" ou "Contraintes techniques" pour faire la recommandation.
- Pas de mention de la conformite RGPD du tracking dans les competences ou l'auto-evaluation. Un plan de tracking qui ne respecte pas le consentement cookie est un plan illegal. La coordination avec @legal sur ce sujet est absente du protocole de calibration.
- Le handoff en direct ne cible que @fullstack. Il manque @growth comme destinataire naturel (les KPIs et le funnel AARRR alimentent directement la strategie growth) et @legal (pour la validation RGPD du tracking).

**Verdict :** Agent data exemplaire avec un positionnement temporel unique et une calibration de reference. L'absence de coordination RGPD avec @legal est le principal angle mort.

---

## 14. @growth

**Note : 8.5/10**

**Points forts :**
- Couverture de competences remarquablement etendue : diagnostic AARRR, acquisition multicanal, PLG, boucles virales, automation, modelisation CAC/LTV, retention, pricing, expansion revenue. C'est un agent growth full-funnel, pas juste un specialiste acquisition.
- La calibration lit les 3 sources les plus pertinentes : product-vision + roadmap (modele economique), kpi-framework (metriques), personas (cibles). Le WebSearch concurrentiel sur les canaux d'acquisition visibles est une etape differenciante.
- Le handoff en direct est le plus riche du framework avec 3 destinataires cibles selon le contexte (@social, @data-analyst, @product-manager). Cela traduit une bonne comprehension du role transversal du growth.

**Points faibles / ameliorations suggerees :**
- Pas de calibration sur `docs/seo/seo-strategy.md` ni `docs/geo/geo-strategy.md`. Le SEO et le GEO sont des canaux d'acquisition majeurs, et l'agent growth devrait lire ces strategies pour eviter de recommander des canaux deja couverts ou de les ignorer.
- Le champ critique "Budget mensuel acquisition" risque de bloquer l'agent sur des projets early-stage ou le budget est 0. L'agent devrait prevoir un mode "zero budget" avec des leviers purement organiques (PLG, referral, community) sans attendre un chiffre.
- Pas de mention de l'Bash tool dans un contexte d'automation growth. L'agent a Bash dans ses tools declares mais aucune instruction sur son usage (scraping, enrichissement de leads, generation de rapports). C'est un outil puissant sous-exploite.

**Verdict :** Agent growth complet et bien calibre, avec un handoff exemplaire. L'absence de coordination avec les agents SEO/GEO et le champ budget potentiellement bloquant sont les axes d'amelioration.

---

## 15. @social

**Note : 7.5/10**

**Points forts :**
- Calibration bien chainee : lit brand-platform, personas ET brand-voice de @copywriter avant de produire. C'est le seul agent a explicitement exiger la coherence avec le brand voice comme prerequis, et a recommander la creation de ce fichier s'il n'existe pas. Cette dependance explicite est une bonne pratique.
- Approche "systeme de contenu, pas posts isoles" dans l'identite, traduite concretement dans les competences : ratio contenu (educatif / preuves sociales / produit / divertissement), calendrier editorial, frequence realiste selon les ressources. C'est une vision structuree.
- L'escalade "si le brand voice n'est pas defini, recommander @copywriter avant de produire" est une regle de garde intelligente qui evite du contenu social incoherent avec la marque.

**Points faibles / ameliorations suggerees :**
- L'agent est le plus court du framework (120 lignes). Les auto-evaluations specifiques ne comptent que 3 questions, ce qui est le minimum. Il manque des questions sur les metriques de performance par plateforme (taux d'engagement cible, croissance followers), la coherence avec la strategie @growth, et la conformite @legal (concours, mentions, droits d'image).
- Pas de WebSearch dans le protocole de calibration. Un agent social devrait imperativement analyser les comptes sociaux des concurrents (frequence, formats, engagement) et les tendances actuelles par plateforme avant de produire une strategie. La WebSearch est dans les tools declares mais aucun protocole ne l'utilise.
- Pas de mention du user-generated content (UGC), des partenariats communautaires, ni du social selling. Pour un SaaS B2B, ces leviers sont souvent plus efficaces que les posts organiques classiques. La couverture de competences est trop orientee B2C/DNVB.

**Verdict :** Agent social fonctionnel avec une bonne calibration sur le brand voice, mais trop leger en auto-evaluation et en protocoles de recherche. Le plus court et le moins approfondi des 17 agents.

---

## 16. @reviewer

**Note : 9/10**

**Points forts :**
- Le protocole de revue croisee est le plus structure du framework : 4 dimensions de coherence (strategique, technique, editoriale, juridique) avec des checklists precises. Chaque paire de livrables a des criteres de verification concrets ("le code de @fullstack respecte-t-il les tokens de @design ?", "la politique de confidentialite est-elle alignee avec le tracking plan ?"). C'est actionnable, pas generique.
- Le protocole de decouverte des livrables est unique et methodique : Glob sur docs/**/*.md, docs/**/*.json, src/**/* et .github/**/, puis croisement avec l'historique des interventions. L'agent detecte les anomalies (agent liste mais fichier absent) au lieu de se fier au contexte verbal.
- La regle anti-invention est renforcee par rapport aux autres agents : le reviewer doit non seulement ne pas inventer, mais aussi verifier activement que les autres agents n'ont pas invente. "Tout chiffre sans source, benchmark sans reference, ou metrique sans justification doit etre flague comme NO-GO." C'est le gardien factuel du framework.

**Points faibles / ameliorations suggerees :**
- Pas de WebSearch dans le protocole de calibration malgre sa presence dans les tools. Un reviewer devrait pouvoir verifier les claims factuels des livrables (tarifs cites, benchmarks sectoriels, reglementation) par des recherches independantes. Sans cela, il ne peut verifier que la coherence interne, pas la veracite externe.
- Le handoff est toujours vers @orchestrator, meme en invocation directe. C'est logique pour le role, mais il manque une option de handoff direct vers l'agent concerne quand une seule contradiction mineure est detectee (eviter un aller-retour inutile via l'orchestrateur).
- Le mode revision ne mentionne pas la gestion de la dette de revue : que faire quand de nouveaux livrables s'accumulent plus vite que les revues ? Un protocole de priorisation (revoir d'abord les livrables structurants puis les executionnels) serait utile.

**Verdict :** Agent gardien exemplaire avec le protocole de verification le plus rigoureux du framework. L'absence de verification factuelle externe via WebSearch est le principal angle mort d'un agent dont la mission est de tout verifier.

---

## 17. @legal

**Note : 8/10**

**Points forts :**
- Le disclaimer "drafts de reference, pas des avis juridiques formels" est une decision de design critique et unique dans le framework. Il protege l'utilisateur et cadre correctement les attentes. C'est la bonne posture pour un agent IA sur un sujet aussi sensible.
- La calibration est parfaitement chainee : lit les specs fonctionnelles (pour adapter les CGU au modele economique), le tracking plan (pour auditer la conformite RGPD), et l'architecture IA (pour evaluer la classification EU AI Act). Les 3 sources sont les points de contact juridiques critiques d'un projet digital.
- L'escalade "si un risque juridique majeur est identifie, bloquer et alerter immediatement" est la bonne posture. C'est le seul agent avec @reviewer qui peut emettre un blocage formel, ce qui est coherent avec la gravite des enjeux juridiques.

**Points faibles / ameliorations suggerees :**
- Les auto-evaluations specifiques sont trop courtes (3 questions). Il manque des questions sur la conformite EU AI Act quand un LLM est integre, la verification des licences open source dans le code, la conformite DORA/NIS2 pour les projets financiers ou critiques, et la couverture des edge cases contractuels (resiliation, litiges, responsabilite).
- Pas de calibration sur `docs/growth/growth-strategy.md` ni `docs/social/social-strategy.md`. Les strategies d'acquisition (referral, scraping, outreach) et les contenus sociaux (concours, UGC, influence) sont des zones juridiques sensibles non couvertes par la calibration actuelle.
- Le champ critique "Contraintes legales ou sectorielles" est vague et risque de rester vide. Des champs plus precis seraient utiles : "Pays de commercialisation", "Donnees sensibles collectees (sante, finance, mineurs)", "Utilisation d'IA generative (oui/non)".

**Verdict :** Agent juridique bien calibre avec un positionnement honnete (drafts, pas avis formels) et une bonne chaine de lecture des livrables techniques. Les auto-evaluations trop courtes et les champs critiques trop vagues limitent sa rigueur.

---

## Tableau recapitulatif

| Agent | Note /10 | Forces | Faiblesses principales |
|-------|----------|--------|----------------------|
| @orchestrator | 9.5 | Profondeur exceptionnelle (470 lignes), enrichissement project-context entre phases, criteres qualite par champ | Pas de WebSearch macro, mode revision minimal, pas de budget tokens global |
| @fullstack | 9.0 | Conventions de nommage precises, stack opinionnaire et coherente, calibration sur les bons fichiers amont | Chemin docs flou (contredit CLAUDE.md), pas de WebSearch versions, pas de gestion migrations DB |
| @qa | 8.5 | Pipeline de test complet (unit/E2E/perf/a11y/visuel), validation tracking-plan unique, bon ordre de lecture | Pas de WebSearch, calibration design manquante, pas d'escalade vers @ia pour les tests LLM |
| @design | 8.0 | Benchmark visuel concurrentiel, accessibilite WCAG 2.2 AA native, auto-evaluations precises | Ne lit pas les wireframes UX, dark mode non verifie, champs critiques incomplets |
| @ux | 8.0 | Persona credible avec resultats mesurables, bons patterns SaaS, WebSearch concurrentielle | Auto-evaluations trop courtes, pas de lecture brand-platform, pas de prototypage |
| @copywriter | 8.5 | Calibration sectorielle exemplaire, couverture cycle de vie textuel complet, champs critiques les plus pertinents | Pas de lecture explicite brand-platform ni keyword-map, auto-evaluation incomplete |
| @seo | 8.0 | SEO technique Next.js tres precis, bonne articulation avec @geo, 3 dimensions d'auto-evaluation | Pas de calibration structuree, champs critiques minimalistes, pas de SEO programmatique |
| @geo | 7.5 | Positionnement unique et pionnier, auto-evaluations differenciantes, coordination @seo bien geree | Pas de calibration structuree, pas de protocole de veille formalise, domaine encore theorique |
| @ia | 8.5 | Couverture technique la plus large, calibration exemplaire et sequencee, auto-evaluation couts/fallback/cache | Ordre des sections incoherent, pas de securite API keys, pas de calibration brand/UX |
| @infrastructure | 9.0 | Monitoring post-launch detaille, contraintes Replit explicites, calibration methodique | Pas de WebSearch dans les tools, pas de backup/disaster recovery, cache non verifie en sortie |
| @creative-strategy | 8.0 | Positionnement "premier agent", calibration concurrentielle exemplaire, champs critiques bien choisis | Pas de lecture de livrables internes, handoff vague, pas de territoire verbal |
| @product-manager | 8.5 | Couverture fonctionnelle PM complete, calibration benchmark concurrentiel, auto-evaluations les plus exigeantes (5Q) | Champ "modele economique" manquant, pas de calibration analytics/growth, handoff sans @ux |
| @data-analyst | 9.0 | Position temporelle explicite unique, calibration la plus complete (4 sources), cycle complet setup/analyse/experimentation | Champ "outils analytics" premature, pas de coordination RGPD avec @legal, handoff sans @growth |
| @growth | 8.5 | Full-funnel (pas juste acquisition), calibration 3 sources pertinentes, handoff le plus riche (3 destinataires) | Pas de calibration SEO/GEO, champ budget potentiellement bloquant, Bash sous-exploite |
| @social | 7.5 | Calibration brand voice bien chainee, approche systeme de contenu, escalade intelligente vers @copywriter | Agent le plus court (120 lignes), auto-evaluations minimales, pas de WebSearch concurrentielle |
| @reviewer | 9.0 | Protocole revue croisee le plus structure (4 dimensions), decouverte livrables methodique, gardien factuel | Pas de verification factuelle externe via WebSearch, handoff toujours via orchestrateur, pas de priorisation dette revue |
| @legal | 8.0 | Disclaimer "drafts pas avis formels", calibration 3 sources juridiques critiques, pouvoir de blocage | Auto-evaluations trop courtes (3Q), pas de calibration growth/social, champs critiques vagues |

---

## Synthese generale

### Note moyenne du framework : 8.47 / 10

Calcul : (9.5 + 9 + 8.5 + 8 + 8 + 8.5 + 8 + 7.5 + 8.5 + 9 + 8 + 8.5 + 9 + 8.5 + 7.5 + 9 + 8) / 17 = 8.47

### Points forts structurels du framework

1. **Homogeneite architecturale remarquable.** Les 17 agents partagent la meme structure (identite, competences, protocole d'entree, calibration, timeouts, escalade, auto-evaluation, handoff). Cette homogeneite reduit la charge cognitive pour l'utilisateur et garantit que chaque agent respecte les memes regles de base. C'est une decision de design qui scale bien.

2. **Chaine de dependances bien pensee.** L'ordre d'intervention est globalement coherent : creative-strategy en premier, puis product-manager, data-analyst, UX, design, fullstack, QA, et reviewer en fin de chaine. Les calibrations croisees (chaque agent lit les livrables de ses predecesseurs) creent un pipeline ou l'information se propage naturellement.

3. **Protocole anti-invention present partout.** Chaque agent a une regle explicite contre l'invention de donnees, avec un mecanisme d'hypotheses balisees. C'est une decision critique pour un framework IA : sans cette regle, les agents fabriqueraient des benchmarks, des tarifs et des metriques, rendant les livrables dangereux.

4. **Gestion des timeouts adaptee par type d'agent.** La regle anti-coupure est declinee differemment pour les agents contenu (structure puis sections), les agents code (fichiers fondation d'abord), et l'orchestrateur (max 3 sous-agents). C'est un signe de maturite operationnelle.

5. **Trois agents se distinguent nettement.** @orchestrator (9.5), @infrastructure (9.0), @data-analyst (9.0) et @reviewer (9.0) sont les piliers du framework. Leur profondeur, leur calibration et leurs protocoles sont exemplaires.

### Faiblesses recurrentes

1. **Calibrations croisees incompletes (13/17 agents concernes).** La faiblesse la plus systematique : la majorite des agents ne lisent pas tous les livrables pertinents de leurs predecesseurs. @design ne lit pas les wireframes de @ux. @copywriter ne lit pas le brand-platform de @creative-strategy. @growth ne lit pas les strategies SEO/GEO. @legal ne lit pas les strategies growth/social. Chaque lien manquant est un risque de contradiction non detectee.

2. **WebSearch sous-exploitee (6/17 agents).** @qa, @fullstack, @geo, @seo n'utilisent pas WebSearch dans leur calibration malgre sa presence dans les tools declares. Pour @seo et @geo en particulier, c'est un manque critique : ces domaines evoluent mensuellement et les bonnes pratiques memorisees deviennent rapidement obsoletes.

3. **Auto-evaluations inegales.** 5 agents ont des auto-evaluations completes (5 questions specifiques) : @product-manager, @data-analyst, @growth, @infrastructure, @reviewer. Les autres ont 3 questions, ce qui est insuffisant pour garantir la qualite du livrable. @social et @legal sont les plus sous-evalues.

4. **Champs critiques parfois mal calibres.** Plusieurs agents demandent des champs qui sont soit prematures (outils analytics pour @data-analyst alors que c'est lui qui devrait recommander), soit trop vagues (contraintes legales pour @legal), soit manquants (modele economique pour @product-manager). Ces champs sont le premier filtre de qualite du framework -- s'ils sont mal definis, tout le reste en souffre.

5. **Handoffs incomplets en mode direct.** Quand les agents sont invoques directement (pas via @orchestrator), certains handoffs omettent des destinataires naturels : @product-manager ne cible pas @ux, @data-analyst ne cible pas @growth, @legal ne cible que @orchestrator. En mode direct, ces chainons manquants cassent le flux de travail.

### Recommandations prioritaires (par ordre d'impact)

**P0 -- Corriger immediatement :**

1. **Completer les calibrations croisees.** Pour chaque agent, ajouter la lecture explicite des livrables de tous les agents dont il depend. Effort : 1h de revue des 17 fichiers. Impact : elimination des contradictions inter-agents.

2. **Uniformiser les auto-evaluations a 5 questions specifiques minimum.** Les agents a 3 questions (@ux, @social, @legal, @design, @seo, @geo) doivent etre completes. Effort : 30min par agent. Impact : qualite de sortie homogene.

**P1 -- Corriger rapidement :**

3. **Ajouter des protocoles WebSearch dans la calibration des agents qui en manquent.** Priorite : @seo (recherche mots-cles), @geo (veille moteurs generatifs), @qa (versions outils), @fullstack (versions librairies). Effort : 15min par agent. Impact : livrables a jour.

4. **Revoir les champs critiques de @product-manager, @data-analyst et @legal.** Ajouter "Modele economique" pour PM, remplacer "Outils analytics" par "Budget analytics" pour data-analyst, preciser les champs de @legal. Effort : 10min. Impact : premier filtre de qualite renforce.

**P2 -- Ameliorer au prochain cycle :**

5. **Ajouter un mecanisme de budget tokens global dans @orchestrator.** L'orchestrateur devrait estimer le cout total d'une orchestration complete et alerter si le budget est depasse. Effort : refonte partielle de l'orchestrateur. Impact : maitrise des couts sur les projets longs.

6. **Creer un agent @devops ou renforcer @infrastructure avec les capacites CI/CD avancees.** L'agent infrastructure est excellent sur le monitoring mais leger sur le deploiement continu, les environnements de staging, et la gestion des secrets. Effort : extension ou nouvel agent. Impact : pipeline de deploiement complet.

7. **Formaliser un protocole de test du framework lui-meme.** Lancer un projet fictif complet (de @creative-strategy a @reviewer) pour identifier les frictions reelles entre agents. Aucun projet n'a encore ete lance sur ce framework -- les faiblesses identifiees dans cet audit sont theoriques. Seul un test en conditions reelles revelera les vrais points de blocage.
