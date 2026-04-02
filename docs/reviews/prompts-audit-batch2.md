# Audit prompts index.html — lignes 907-1259 (batch 2)

Date : 2026-04-02 | Agent : @ia | Scope : 10 prompts Phase 0 (fin) + Phase 1 (debut)

| # | Prompt | Agent(s) | Clarte /5 | Completude /5 | Robustesse /5 | Verdict | Note |
|---|--------|----------|-----------|---------------|---------------|---------|------|
| 1 | Positionnement & plateforme de marque | creative-strategy, data-analyst | 5 | 5 | 4 | SOLIDE | Prompt le plus complet du framework. Risque : longueur excessive (25+ instructions) peut diluer l'attention de l'agent sur les derniers points. La section "Agents specialises recommandes" en fin de prompt est souvent ignoree au 5e projet. |
| 2 | Vision produit & roadmap | product-manager, data-analyst | 4 | 4 | 4 | SOLIDE | Discovery Protocol + Assumption Mapping sont demandes ici ET dans le prompt 5 (specs). Duplication = risque d'incoherence entre les deux versions produites. Preciser "si deja produit, ne pas regenerer". |
| 3 | KPIs & tracking plan | data-analyst, fullstack | 5 | 5 | 4 | SOLIDE | Tres actionnable. Le chainage @fullstack en fin est bien cadre. Risque mineur : "Privacy by design" reste generique sans reference au pays/juridiction du projet. |
| 4 | Audit juridique & conformite | legal, infrastructure | 4 | 4 | 3 | A AMELIORER | Prompt couvre FR/EU mais manque de routing par pays. Un projet US/UK declenchera des hallucinations sur RGPD/CNIL sans instruction de filtrage. Ajouter : "Adapter au pays de project-context.md, ignorer les reglementations non applicables." |
| 5 | Specs fonctionnelles detaillees | product-manager, qa | 5 | 5 | 3 | A AMELIORER | Prompt massif (50+ lignes). Anti-timeout present mais insuffisant : la checklist finale (25+ parcours) est irealiste en une passe. Robustesse faible : au 5e projet l'agent produit des specs de plus en plus generiques pour tenir le volume. Decouper en 2 prompts (specs core + specs edge cases). |
| 6 | Valider la demande avant de construire | growth, creative-strategy, data-analyst | 4 | 4 | 4 | SOLIDE | Bon chainage 3 agents. Le critere go/no-go chiffre (>5%, >10%) est un bon ancrage. Manque : que faire si WebSearch ne retourne pas de volumes de recherche (niche B2B). Ajouter fallback qualitatif. |
| 7 | Construire la messaging matrix | creative-strategy, copywriter | 4 | 4 | 4 | SOLIDE | Bien structure. "Dans les mots du persona, pas du marketeur" est une excellente directive anti-generique. Le nombre de cases (5 canaux x 5 etapes x N personas) peut exploser — manque un cap explicite. |
| 8 | Strategie de pricing complete | product-manager, data-analyst, growth, legal | 4 | 5 | 4 | SOLIDE | 4 agents chaines — complet. Risque : le chainage sequentiel de 4 agents est le plus long du framework, timeout probable. La section "avancee" (points 7-10) devrait etre conditionnelle ("si multi-segments" est dit mais pas enforce). |
| 9 | Definir le scope V1 | product-manager, fullstack | 5 | 4 | 3 | A AMELIORER | Le mindset "V1 complete, pas MVP" est repete 3 fois — signe que l'agent resiste. Robustesse faible : au 5e projet, les agents incluent TOUT sans discrimination, produisant des V1 a 30+ features sans hierarchie. Manque : un critere de valeur minimum par feature (ex: "impacte >10% des sessions persona"). |
| 10 | Vision long terme et moat | elon, product-manager, creative-strategy | 4 | 5 | 4 | SOLIDE | Grille moat /10 bien structuree. 3 agents chaines avec des missions distinctes. Risque mineur : la notation /10 par dimension tend a converger vers 5-7 sur tous les projets (biais de moyenne). Forcer des notes extremes (0-3 ou 8-10) serait plus discriminant. |
| 11 | Parcours utilisateur & wireframes | ux, data-analyst | 4 | 5 | 3 | A AMELIORER | Surcharge d'instructions : Nielsen 10 + HEART + cognitive walkthrough + mobile UX + form UX + accessibilite. Aucun agent ne peut executer tout ca en une passe sans degradation. Prioriser 3 frameworks max ou decouper en 2 prompts (flows + audit UX). |
| 12 | Design system complet | design, fullstack | 5 | 5 | 4 | SOLIDE | Tres complet. Architecture tokens 3 tiers bien expliquee. Numerotation cassee (deux "5.", deux "6.") — corriger. Le chainage @fullstack pour implementation directe est risque : le design system n'est pas encore valide quand l'implementation demarre. |
| 13 | Brand voice & identite verbale | copywriter, creative-strategy, geo | 5 | 5 | 4 | SOLIDE | Excellent. "Zéro fausse promesse" et "anti-temoignage fictif" sont des garde-fous critiques. Le chainage @geo en fin est une bonne integration cross-agents. Risque mineur : "10-15 mots proprietaires" est arbitraire et peut forcer des termes artificiels. |

## Synthese

- **SOLIDE** : 9/13 prompts (69%)
- **A AMELIORER** : 4/13 prompts (31%) — #4 (juridique sans routing pays), #5 (specs trop massif), #9 (V1 sans filtre valeur), #11 (UX surcharge)
- **PROBLEMATIQUE** : 0/13

**Pattern recurrent** : les prompts les plus longs (>40 lignes) ont la robustesse la plus faible. La surcharge d'instructions degrade la qualite au fil des projets. Recommandation : cap a 30 lignes par prompt, decouper au-dela.
