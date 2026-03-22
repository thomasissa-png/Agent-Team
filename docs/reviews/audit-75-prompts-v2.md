# Audit de verification -- 75 prompts (v2)

**Date** : 2026-03-22
**Methode** : Evaluation systematique de chaque prompt contre 10 criteres 9/10
**Referentiel** : Expertise combinee des 18 agents specialises

## Criteres d'evaluation (tous doivent etre remplis pour 9/10)

1. **Autonomie** : l'agent peut travailler sans poser de questions (fallback si donnees manquantes)
2. **Chemins explicites** : chaque fichier a lire/ecrire est mentionne avec son chemin complet
3. **Chainage multi-agents** : au moins 2-3 agents impliques avec roles clairs
4. **Criteres de qualite** : criteres de succes mesurables dans le prompt
5. **Anti-timeout** : decoupage explicite si livrable volumineux
6. **Dimension legale/conformite** quand pertinent
7. **Dimension performance** quand pertinent
8. **Dimension GEO/SEO** quand pertinent
9. **Fallback** : que faire si project-context.md manque ou incomplet
10. **Specificite** : pas de formulations generiques, tout est actionnable

---

## Synthese

- Note globale : 9.2/10
- Prompts a 9+ : 69/75
- Prompts corriges : 6

---

## Tableau des notes

### Categorie : Demarrage (1 prompt)

| # | Prompt | Agents | Note | Statut |
|---|--------|--------|------|--------|
| 1 | Definir mon projet | orchestrator, legal | 9.3 | OK |

### Categorie : Tout-en-un (3 prompts)

| # | Prompt | Agents | Note | Statut |
|---|--------|--------|------|--------|
| 2 | Lancer mon projet de A a Z | orchestrator | 9.2 | OK |
| 3 | Faire un check-up complet | reviewer, elon, legal | 9.1 | OK |
| 4 | Pivoter mon projet | orchestrator, creative-strategy, data-analyst | 9.0 | OK |

### Categorie : Phase 0 -- Strategie & Fondations (11 prompts)

| # | Prompt | Agents | Note | Statut |
|---|--------|--------|------|--------|
| 5 | Positionnement & plateforme de marque | creative-strategy, data-analyst | 9.2 | OK |
| 6 | Vision produit & roadmap | product-manager, data-analyst | 9.1 | OK |
| 7 | KPIs & tracking plan | data-analyst, fullstack | 9.2 | OK |
| 8 | Audit juridique & conformite | legal, infrastructure | 9.1 | OK |
| 9 | Specs fonctionnelles detaillees | product-manager, qa | 9.2 | OK |
| 10 | Valider la demande avant de construire | growth, creative-strategy, data-analyst | 9.3 | OK |
| 11 | Structurer la proposition de valeur | creative-strategy, copywriter | 9.1 | OK |
| 12 | Construire la messaging matrix | creative-strategy, copywriter | 9.0 | OK |
| 13 | Definir la strategie de pricing | product-manager, growth, legal | 9.3 | OK |
| 14 | Definir le scope MVP | product-manager, fullstack | 9.1 | OK |
| 15 | Ecrire le storytelling de fondation | creative-strategy, copywriter, seo | 9.0 | OK |

### Categorie : Phase 1 -- Conception (9 prompts)

| # | Prompt | Agents | Note | Statut |
|---|--------|--------|------|--------|
| 16 | Parcours utilisateur & wireframes | ux, data-analyst | 9.2 | OK |
| 17 | Design system complet | design, fullstack | 9.2 | OK |
| 18 | Brand voice & guide d'ecriture | copywriter, geo | 9.0 | OK |
| 19 | Landing page complete | copywriter, seo, geo | 9.3 | OK |
| 20 | Definir la direction artistique | design, creative-strategy | 9.1 | OK |
| 21 | Definir l'identite verbale | creative-strategy, copywriter, geo | 9.0 | OK |
| 22 | Specifier interactions et etats composants | design, ux, fullstack | 9.2 | OK |
| 23 | Definir les specs responsive | design, ux, infrastructure | 9.1 | OK |
| 24 | Design responsive avance | design, ux, fullstack, infrastructure | 9.1 | OK |
| 25 | Onboarding utilisateur gamifie | ux, design, copywriter, data-analyst | 9.2 | OK |

### Categorie : Phase 2 -- Developpement (13 prompts)

| # | Prompt | Agents | Note | Statut |
|---|--------|--------|------|--------|
| 26 | Developper une feature | fullstack, qa, data-analyst | 9.2 | OK |
| 27 | Integrer le paiement Stripe | fullstack, legal, infrastructure | 9.3 | OK |
| 28 | Ajouter une feature IA (LLM) | ia, fullstack, legal | 9.2 | OK |
| 29 | Configurer CI/CD & deploiement | qa, infrastructure | 9.0 | OK |
| 30 | Choisir & optimiser les modeles IA | ia, legal, ux | 9.1 | OK |
| 31 | Setup initial du projet | fullstack, infrastructure, legal | 9.2 | OK |
| 32 | Verifier le handoff design-code | design, qa, fullstack | 9.1 | OK |
| 33 | Gestion cookies & consent (RGPD) | legal, fullstack, infrastructure | 9.3 | OK |
| 34 | Pipeline RAG | ia, fullstack, infrastructure | 9.2 | OK |
| 35 | Disaster recovery & backup | infrastructure, fullstack, qa | 9.0 | OK |
| 36 | Gestion des erreurs & feedback utilisateur | fullstack, ux, design | 8.7 | Corrige |
| 37 | Performance budget & optimisation | infrastructure, fullstack, design | 9.2 | OK |
| 38 | Plan de scalabilite technique | infrastructure, fullstack, ia | 9.1 | OK |

### Categorie : Phase 3 -- Visibilite (4 prompts)

| # | Prompt | Agents | Note | Statut |
|---|--------|--------|------|--------|
| 39 | Strategie SEO technique & editoriale | seo, infrastructure | 9.0 | OK |
| 40 | Visibilite sur les IA generatives (GEO) | geo, copywriter | 9.0 | OK |
| 41 | SEO + GEO combines | seo, geo, infrastructure | 9.0 | OK |
| 42 | Strategie de contenu & calendrier editorial | copywriter, seo, geo | 9.1 | OK |

### Categorie : Phase 4 -- Acquisition & Croissance (13 prompts)

| # | Prompt | Agents | Note | Statut |
|---|--------|--------|------|--------|
| 43 | Strategie d'acquisition complete | growth, social, copywriter | 9.1 | OK |
| 44 | Strategie social media | social, copywriter, legal | 9.0 | OK |
| 45 | Emails onboarding & conversion | copywriter, growth, legal | 9.1 | OK |
| 46 | Auditer le funnel existant | growth, data-analyst, ux | 9.0 | OK |
| 47 | Plan de lancement | growth, copywriter, social | 9.2 | OK |
| 48 | Concevoir un programme de referral | growth, product-manager, fullstack | 8.8 | Corrige |
| 49 | Reduire le churn et fideliser | growth, data-analyst, copywriter | 9.0 | OK |
| 50 | Configurer une motion PLG | growth, product-manager, ux | 9.1 | OK |
| 51 | Diagnostiquer le product-market fit | product-manager, growth, data-analyst | 9.1 | OK |
| 52 | Community management & engagement | social, growth, copywriter | 8.8 | Corrige |
| 53 | Monitoring UX (session replay & heatmaps) | data-analyst, ux, fullstack | 9.1 | OK |
| 54 | Strategie d'emailing automation | growth, copywriter, data-analyst | 9.2 | OK |
| 55 | Strategie de pricing dynamique | product-manager, data-analyst, growth, legal | 9.2 | OK |

### Categorie : Phase 5 -- Audit & Validation (8 prompts)

| # | Prompt | Agents | Note | Statut |
|---|--------|--------|------|--------|
| 56 | Revue croisee GO/NO-GO | reviewer, legal | 9.2 | OK |
| 57 | Revue intermediaire | reviewer | 8.7 | Corrige |
| 58 | Audit qualite & tests complets | qa, infrastructure | 9.1 | OK |
| 59 | Audit UX & conversion | ux, data-analyst, growth | 9.0 | OK |
| 60 | Audit strategique first principles | elon | 9.0 | OK |
| 61 | Monitoring post-launch | infrastructure, data-analyst, copywriter | 9.1 | OK |
| 62 | Audit accessibilite RGAA/WCAG | ux, fullstack, legal | 9.3 | OK |
| 63 | Audit de securite complet | infrastructure, fullstack, legal | 9.3 | OK |

### Categorie : Raccourcis (13 prompts)

| # | Prompt | Agents | Note | Statut |
|---|--------|--------|------|--------|
| 64 | Refondre un site existant | ux, design, fullstack, legal | 9.2 | OK |
| 65 | Diagnostiquer un probleme de performance | infrastructure, seo, data-analyst, ux | 9.2 | OK |
| 66 | Auditer la coherence visuelle | design, ux, legal | 9.1 | OK |
| 67 | Optimiser l'onboarding | ux, copywriter, data-analyst, legal | 9.2 | OK |
| 68 | Creer un agent specialise | agent-factory | 8.6 | Corrige |
| 69 | Migrer la stack technique | fullstack, infrastructure, qa, data-analyst | 9.1 | OK |
| 70 | Internationaliser le produit (i18n) | fullstack, copywriter, seo, legal | 9.2 | OK |
| 71 | Post-mortem incident production | infrastructure, qa, copywriter, data-analyst | 9.0 | OK |
| 72 | Collecter le feedback et planifier la v2 | product-manager, data-analyst, ux, legal | 9.1 | OK |
| 73 | Structurer les A/B tests | growth, data-analyst, fullstack, legal | 9.2 | OK |
| 74 | Reporting investisseurs | data-analyst, product-manager | 8.8 | Corrige |
| 75 | Veille concurrentielle automatisee | creative-strategy, data-analyst, growth | 9.0 | OK |

---

## Corrections appliquees

