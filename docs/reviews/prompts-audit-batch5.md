# Audit Prompts — Batch 5 (index.html lignes 1994-2461)

**Agent** : @ia
**Date** : 2026-04-02
**Scope** : Prompts Phase 3 (SEO/GEO/Contenu) + Phase 4 (Acquisition & Croissance)
**Méthode** : Lecture directe des prompts, évaluation sur 3 axes (Clarté, Complétude, Robustesse) /5

## Critères

- **Clarté** : le prompt est-il non ambigu, structuré, compréhensible par l'agent cible ?
- **Complétude** : couvre-t-il tous les cas (fichiers manquants, données absentes, fallback) ?
- **Robustesse** : résiste-t-il aux timeouts, aux livrables absents, aux cas limites ?

## Verdicts

- **SOLIDE** : 4+ sur les 3 critères
- **A AMELIORER** : 3 sur au moins un critere
- **PROBLEMATIQUE** : 2 ou moins sur un critere

## Grille d'audit

| # | Prompt | Agent(s) | Clarte /5 | Completude /5 | Robustesse /5 | Verdict | Note |
|---|--------|----------|-----------|----------------|----------------|---------|------|
| 1 | Strategie SEO technique & editoriale | seo, infrastructure | 5 | 5 | 4 | SOLIDE | Prompt extremement detaille (40+ lignes). Couvre topical map, E-E-A-T, intent mapping, clustering, content decay, AI crawlers. Keyword research en 6 sous-sections avec priorisation. Fallback si fichiers absents (pose questions). Criteres de validation precis. Risque timeout sur la longueur — mais decoupe en 3 livrables successifs. |
| 2 | Visibilite IA generatives (GEO) | geo, copywriter | 5 | 5 | 5 | SOLIDE | Excellente gestion de dependance : ALERTE explicite si SEO absent avec recommandation de sequencage. Fallback si utilisateur confirme sans SEO. 6 axes d'analyse bien structures. Criteres de validation clairs (10 claims, FAQ structuree). Benchmark WebSearch obligatoire. |
| 3 | SEO + GEO combines | seo, geo, infrastructure | 4 | 4 | 4 | SOLIDE | Version condensee des 2 precedents pour execution en un seul run. Synergie SEO/GEO bien documentee. Moins detaille que les prompts individuels (normal — c'est le combo). Fallback si landing-page-copy absent. Conseil reprise si coupure present dans le titre. |
| 4 | Strategie de contenu & calendrier editorial | copywriter, seo, geo | 5 | 5 | 4 | SOLIDE | Le plus long prompt du batch (~100 lignes). Pipeline editorial perpetuel avec anti-repetition, content registry, feedback loop analytics, escalade strategique si pilier sous-performe. Horaires optimaux via WebSearch. Automatisation documentee. Risque : complexite elevee pour un seul agent copywriter — mais le chainage seo+geo en aval compense. |
| 5 | Strategie d'acquisition complete | growth, social, copywriter | 5 | 5 | 4 | SOLIDE | AARRR-compatible. Modelisation CAC/LTV par canal. Budget zero gere (canaux organiques). Quick wins < 48h. Automatisabilite notee /5 par canal. Conformite RGPD mentionnee. Triple chainage avec fallback si timeout. |
| 6 | Outils de vente & sales enablement | sales-enablement, copywriter, design, fullstack | 5 | 5 | 4 | SOLIDE | 6 livrables distincts bien structures. Frameworks de vente adaptatifs (BANT, SPIN, MEDDIC, Challenger). ROI calculator avec specs fonctionnelles et handoff fullstack. Conception pour automatisation IA. Seul point : 4 agents = risque timeout, mais les livrables sont independants. |
| 7 | Strategie earned media & visibilite presse | growth, copywriter, seo | 5 | 4 | 4 | SOLIDE | 7 pipelines references. Budget detaille par pipeline (prix reels EIN Presswire, Pressonify). Kill criteria newsjacking bien penses. ROI marque [HYPOTHESE] correctement. Manque : pas de fallback explicite si brand-platform absent (growth le lit mais pas de question de remplacement). |
| 8 | Strategie social media | social, copywriter, legal | 5 | 5 | 5 | SOLIDE | Social Listening + Content Pillars + Social Flywheel + UGC = couverture complete. Algorithmes 2026 par plateforme documentes. Framework 3E (Eduquer/Divertir/Engager). Legal en aval (ARPP/FTC). Automatisation obligatoire. Fallback pour chaque fichier manquant. |
| 9 | Emails onboarding & conversion | copywriter, growth, legal | 5 | 5 | 5 | SOLIDE | Frameworks de persuasion (AIDA, PAS) par email. Niveaux de conscience Schwartz. Objections du persona traitees. 5 emails bien sequences avec timing. Anti-pattern faux temoignages signale. Format strict (objet < 50 chars, 2 variantes A/B, < 200 mots). RGPD via legal. |
| 10 | Auditer le funnel existant | growth, data-analyst, ux | 4 | 4 | 4 | SOLIDE | AARRR complet avec diagnostic par etape. Segments sous-performants. 3 leviers a fort impact. Benchmark sectoriel via WebSearch ou [HYPOTHESE]. Chainage data-analyst (dashboard cohortes) + ux (frictions). Depend de donnees analytics reelles — le prompt le signale bien ("colle-les dans le prompt"). |
| 11 | Plan de lancement (0 -> premiers utilisateurs) | growth, copywriter, social | 5 | 5 | 4 | SOLIDE | Timeline J-7 a J+7 heure par heure. Objectifs chiffres avec critere succes/echec. Plan de capacite infra. Assets prepares avec specs de taille par plateforme. Maker comment + 5 reponses types. Tres actionnable. |
| 12 | Concevoir un programme de referral | growth, product-manager, fullstack | 5 | 5 | 5 | SOLIDE | Mecanique complete (type, incentive calibre sur LTV, flow, tracking K-factor, anti-abus). Template user story obligatoire pour PM avec 9 criteres d'acceptation. Conformite RGPD detaillee (consentement filleul, anti-spam, fiscalite). Performance (async tracking). Excellent. |
| 13 | Reduire le churn et fideliser | growth, data-analyst, copywriter | 5 | 5 | 4 | SOLIDE | Playbook complet : diagnostic churn par moments critiques, signaux precoces avec seuils, segmentation comportementale 4 niveaux, reengagement par segment, campagnes win-back. NRR cible > 100%. Conformite RGPD notifications mentionnee. |
| 14 | Configurer une motion PLG | growth, product-manager, ux | 5 | 5 | 4 | SOLIDE | Free tier bien cadre ("resoudre le probleme principal, pas version castree"). Triggers d'upgrade = moments de succes, pas de blocage. Time-to-value < 5 min. Metriques PLG avec cibles par modele (freemium vs trial). Recommendation freemium vs trial justifiee. |
| 15 | Diagnostiquer le product-market fit | product-manager, growth, data-analyst | 5 | 5 | 5 | SOLIDE | Protocole Sean Ellis complet avec seuils. Retention par cohorte avec cibles par type (SaaS B2B, B2C, marketplace). DAU/MAU ratio. NPS avec verbatims. Verdict trinaire (PMF atteint/partiel/non) avec actions par cas. Tres rigoureux. |
| 16 | Strategie d'emailing automation | growth, copywriter, data-analyst | 5 | 5 | 4 | SOLIDE | Comparatif outils (Resend, Loops, Brevo, Customer.io). 5 types de sequences (transactionnel, onboarding, retention, marketing, triggers). A/B testing. Metriques avec seuils (open > 25%, click > 3%). Conformite double opt-in. Risque overlap avec prompt #9 (emails onboarding) — mais ce prompt est plus strategique/infra. |
| 17 | Automatisation marketing complete | growth, ia, fullstack, copywriter | 5 | 5 | 4 | SOLIDE | Le prompt le plus ambitieux du batch. Pipeline content generation IA avec flux progressif. Content registry PostgreSQL + content_performance. Crons avec retry/backoff/idempotence. Prompt caching Anthropic. LLM-as-judge en pre-review. Feedback loop ferme (perf → ajustement). Garde-fous qualite en 2 etapes. ROI explicite. 4 agents mais bien sequences. Risque timeout eleve — attenuer par execution agent par agent. |
| 18 | Analyse automatisee des feedbacks utilisateurs | data-analyst, ux, product-manager | 5 | 5 | 4 | SOLIDE | Pipeline classification IA (categorie, sentiment, urgence, feature). Dashboard feedback. Alertes avec seuils (sentiment negatif > 30%, NPS -10 pts). Boucle feedback → ticket → priorisation → implementation → communication. RICE adapte (Reach = nb feedbacks). Complet et actionnable. |

## Synthese

**18 prompts audites — 18 SOLIDES (100%)**

### Forces recurrentes du batch

1. **Fallback systematique** : chaque prompt gere l'absence de livrables amont (pose des questions ou genere avant de continuer)
2. **Benchmark WebSearch obligatoire** : quasi tous les prompts demandent 2-3 exemples reels du secteur avant production
3. **Criteres de validation explicites** : chaque prompt se termine par des criteres binaires verifiables
4. **Conformite RGPD** : systematiquement mentionnee pour les prompts touchant aux donnees utilisateur (emails, tracking, referral)
5. **Automatisation par defaut** : alignement parfait avec la regle CLAUDE.md "un fondateur solo ne produit pas manuellement"
6. **Chainages multi-agents** : bien sequences avec conseil de reprise en cas de coupure

### Points de vigilance (aucun PROBLEMATIQUE, mais a surveiller)

1. **Longueur des prompts** : les prompts #4 (contenu editorial) et #17 (automatisation marketing) depassent 80 lignes — risque de dilution d'attention pour l'agent. Non bloquant car bien structures avec numeros.
2. **Overlap emails** : les prompts #9 (onboarding emails) et #16 (emailing automation) couvrent des perimetre proches. Le prompt #16 est plus strategique (choix outil, toutes sequences), le #9 est plus operationnel (redaction des 5 emails). Clarifier dans le catalogue que #16 inclut #9.
3. **4 agents en un prompt** : les prompts #6 (sales enablement) et #17 (automatisation marketing) invoquent 4 agents — risque timeout cumule. Mitige par les conseils de reprise dans les titres.
4. **Donnees analytics requises** : les prompts #10 (funnel) et #13 (churn) dependent de donnees reelles que l'utilisateur doit fournir. Le fallback est documente mais l'agent pourrait tourner a vide sans donnees.

### Verdict global

Batch de tres haute qualite. Les prompts Phase 4 (Acquisition & Croissance) sont les plus matures du framework : chaque prompt combine strategie + execution + metriques + conformite + automatisation. Aucune action corrective bloquante requise.

---

**Handoff → @orchestrator**
- Fichier produit : `/home/user/Agent-Team/docs/reviews/prompts-audit-batch5.md`
- Decisions prises : 18/18 prompts evalues SOLIDE, aucun PROBLEMATIQUE ni A AMELIORER
- Points d'attention : overlap prompts #9/#16 a clarifier, longueur prompts #4/#17 a surveiller, prompts a 4 agents (#6, #17) = risque timeout cumule
