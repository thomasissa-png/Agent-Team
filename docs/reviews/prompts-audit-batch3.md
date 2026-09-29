# Audit des prompts — index.html lignes 1260-1653

**Auditeur** : @ia | **Date** : 2026-04-02 | **Scope** : 9 prompts (Phase 1 fin + Phase 2 début)

| # | Prompt | Agent(s) | Clarte /5 | Completude /5 | Robustesse /5 | Verdict | Note |
|---|---|---|---|---|---|---|---|
| 1 | Landing page complete | copywriter, seo, geo | 5 | 5 | 4 | SOLIDE | Très structure (Schwartz, AIDA, PAS, BAB). Anti-bullshit bien cadre. Risque : la longueur du prompt peut pousser l'agent au timeout sur les projets avec brand-voice + personas a générer |
| 2 | Direction artistique | design, creative-strategy | 5 | 5 | 4 | SOLIDE | 8 critères par direction, impact perf inclus. Risque mineur : "2-3 directions" peut devenir générique au 5eme projet si les références WebSearch se repetent |
| 3 | Interactions et états composants | design, ux, fullstack | 5 | 5 | 5 | SOLIDE | Tableau 9 états par composant, motion guide, backoffice inclus. Prompt le plus robuste du batch |
| 4 | Design responsive complet | design, ux, fullstack, infrastructure | 4 | 5 | 4 | SOLIDE | 12 points couverts, budget perf mobile. Clarte legerement reduite par la densité (4 agents, 12 sous-sections). Risque : @infrastructure recoit peu de contexte spécifique |
| 5 | Onboarding utilisateur gamifie | ux, design, copywriter, data-analyst | 5 | 5 | 4 | SOLIDE | Conviction-first, progressive profiling, reengagement. Risque : "gamification si cohérent avec la marque" est subjectif — critère flou au 5eme projet |
| 6 | Système de notifications | ux, design, fullstack | 5 | 5 | 5 | SOLIDE | Matrice type x canal x urgence, quiet hours, schema DB, SSE. Prompt exemplaire en completude technique |
| 7 | Développer une feature | fullstack, qa, data-analyst | 4 | 5 | 3 | A Améliorer | Placeholder [nom de la feature] est signale mais le prompt reste générique par nature — la qualité dépend entierement de ce que l'utilisateur met dans les crochets. Pas de guard-rail si la description est vague ("améliorer le dashboard") |
| 8 | Integrer Stripe | fullstack, legal, infrastructure | 5 | 5 | 5 | SOLIDE | Edge cases couverts (carte expiree, proration, idempotence). E2E obligatoire. Prompt prêt pour la prod |
| 9 | Feature IA (LLM) | ia, fullstack, legal | 4 | 4 | 3 | A Améliorer | Placeholder [decrire la feature] même risque que #7. Tableau comparatif exige mais sans seuils de qualité minimum. Manque : budget tokens cap explicite, eval strategy (pourtant obligatoire dans le protocole @ia) |
| 10 | CI/CD & déploiement | qa, infrastructure | 5 | 5 | 4 | SOLIDE | Testing Trophy, Playwright Healer, contract testing. Risque mineur : Playwright Agents/Healer suppose une version recente — pas de fallback si indisponible |
| 11 | Choisir & optimiser modèles IA | ia, legal, ux | 4 | 4 | 3 | A Améliorer | Manque eval-strategy.md (obligatoire protocole @ia). Manque prompt-library.md. Le prompt demande un tableau mais pas de test cases sur les outputs. ROI demande sans template de calcul |
| 12 | Setup initial projet | fullstack, infrastructure, legal | 5 | 5 | 5 | SOLIDE | Le plus complet du batch : 10 sous-sections, persistance Replit, migrations idempotentes, favicon. Anti-timeout bien gere via "un fichier par Write" |

## Synthese

- **SOLIDE** : 9/12 prompts (75%)
- **A Améliorer** : 3/12 prompts (#7, #9, #11)
- **PROBLEMATIQUE** : 0/12

## Corrections prioritaires

1. **#7 et #9** : ajouter un guard-rail si le placeholder est vague — ex: "Si la description fait moins de 20 mots, pose 3 questions de clarification avant de coder"
2. **#9** : ajouter explicitement la production de eval-strategy.md et prompt-library.md (obligatoires selon le protocole @ia)
3. **#11** : aligner avec le protocole @ia complet — ajouter template ROI, eval-strategy, prompt-library, cap tokens par loader

---
**Handoff → @orchestrator**
- Fichier produit : `/home/user/Agent-Team/docs/reviews/prompts-audit-batch3.md`
- Décisions : 9 prompts solides, 3 a améliorer (placeholders sans guard-rail, protocole @ia incomplet sur #9 et #11)
- Points d'attention : les prompts #9 et #11 ne respectent pas le protocole complet de l'agent @ia (eval-strategy, prompt-library manquants)
