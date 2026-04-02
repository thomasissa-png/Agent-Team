# Audit prompts index.html -- lignes 512 a 906

Audit par @ia -- 2026-04-02. Perimetre : 7 prompts (categories Demarrage, Tout-en-un).

## Grille d'evaluation

| # | Prompt | Agent(s) | Clarte /5 | Completude /5 | Robustesse /5 | Verdict | Note |
|---|---|---|---|---|---|---|---|
| 1 | Definir mon projet (obligatoire en premier) | orchestrator | 5 | 5 | 4 | SOLIDE | Prompt le plus structure du lot. Champs bien types avec exemples. Risque mineur : sur le 5e projet les exemples entre crochets deviennent du copier-coller par l'utilisateur. |
| 2 | Quel prompt utiliser ? (guide rapide) | orchestrator | 5 | 4 | 4 | SOLIDE | Clair et bien cadre ("ne lance rien"). Manque : pas de fallback si l'utilisateur repond hors des options A-G. |
| 3 | Reprendre ou j'en etais | orchestrator | 5 | 2 | 5 | PROBLEMATIQUE | Prompt deprecie, redirige vers un autre. Completude 2/5 : ne fait rien lui-meme. Devrait etre supprime ou masque dans l'UI, pas affiche comme un prompt actif. |
| 4 | Lancer mon projet de A a Z | orchestrator | 4 | 5 | 3 | A AMELIORER | Prompt le plus complet (50+ lignes). Risque robustesse : la densite d'instructions (11 renforcements + 11 learnings + multi-sessions) depasse ce qu'un agent peut retenir en un seul contexte. Le point 8 est duplique (deux fois "8."). Sur le 5e projet, les renforcements cross-projets (lignes 644-664) polluent le signal avec des directives trop specifiques a des projets passes. |
| 5 | Faire un check-up complet | orchestrator, reviewer, elon, +8 | 4 | 5 | 4 | SOLIDE | Etapes bien sequencees (0-5). Gate bloquante learnings en pre-requis. Risque : l'etape 2 peut lancer 10+ agents, depassant largement la regle anti-timeout de 3 Task max. Le prompt dit "batch de 2-3" mais la liste de cas est longue -- l'orchestrateur doit bien decouper. |
| 6 | Pivoter mon projet | orchestrator | 4 | 5 | 4 | SOLIDE | Garde-fou pivot vs changement structurel pertinent. Checkpoint validation avant lancement -- bon pattern. Duplication significative avec le prompt #4 (renforcements 1-10 quasi identiques). Factoriser reduirait le cout tokens. |
| 7 | Integrer des learnings d'un autre projet | orchestrator, ia | 5 | 4 | 4 | SOLIDE | Seul prompt qui utilise @ia en sous-agent pour audit de coherence. Bien structure en 3 etapes. Manque : pas de cap sur le volume de learnings ingestibles en une session (risque timeout si 50+ learnings). |

## Synthese

- **5/7 SOLIDE** -- la majorite des prompts sont bien construits et actionnables.
- **1 PROBLEMATIQUE** (#3) -- prompt deprecie encore affiche, a supprimer.
- **1 A AMELIORER** (#4) -- prompt trop dense, point 8 duplique, renforcements cross-projets trop specifiques.

### Problemes transversaux

1. **Duplication des renforcements** : les prompts #4 et #6 partagent ~80% des memes renforcements. Factoriser dans une reference commune (ex: section "renforcements standard" dans orchestrator.md) economiserait ~40 lignes de prompt par appel.
2. **Densite vs retention** : le prompt #4 contient 11 renforcements + 11 learnings cross-projets + gestion multi-sessions. A 50+ lignes, il depasse la capacite de retention fiable d'un agent en une passe. Recommandation : separer les learnings cross-projets dans un fichier reference plutot que les inliner.
3. **Prompt deprecie visible** (#3) : un prompt qui dit "utilisez l'autre" ne devrait pas etre dans la bibliotheque. Pollution du choix utilisateur.
