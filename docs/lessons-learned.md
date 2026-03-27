# Mémoire organisationnelle — Lessons Learned

Ce fichier est la mémoire partagée du framework Gradient Agents. Il capitalise les apprentissages de chaque projet pour que le suivant soit meilleur.

**Responsable** : @orchestrator met à jour ce fichier après chaque projet terminé ou phase majeure.
**Lecture** : tous les agents DEVRAIENT consulter ce fichier dans leur calibration pour bénéficier des apprentissages passés.

---

## Structure par projet

Chaque entrée suit ce format :

```
## [Nom du projet] — [Date]

### Ce qui a bien fonctionné
- [Pattern, décision, agent qui a surperformé, chaîne qui a bien marché]

### Ce qui a mal fonctionné
- [Friction, timeout, livrable refusé par reviewer, chaîne cassée, donnée manquante]

### Améliorations apportées au framework
- [Correction concrète : nouvelle calibration, règle ajoutée, agent enrichi]
```

---

## Session 2026-03-27 — Gradient Agents (enrichissement massif + testeurs persona)

| Session | Date | Catégorie | Sévérité | Description | Correction appliquée | Recommandation framework | Statut |
|---|---|---|---|---|---|---|---|
| 2026-03-27 | 2026-03-27 | problème | P1 | Références "20 gates" / "G1-G20" partout alors qu'il y en a 25 (G1-G25). Les gates G21-G25 risquaient d'être ignorées par le reviewer | Corrigé dans CLAUDE.md, orchestrator.md, reviewer.md, _base-agent-protocol.md | Quand on ajoute des gates, mettre à jour TOUS les compteurs textuels (pas juste les tableaux) | appliqué |
| 2026-03-27 | 2026-03-27 | problème | P1 | "ALERTE JAUNE" résiduelle dans orchestrator.md (self-diagnostic) alors que JAUNE a été supprimée | Remplacé par ALERTE ROUGE | Après suppression d'un concept, Grep le terme dans TOUS les fichiers | appliqué |
| 2026-03-27 | 2026-03-27 | problème | P0 | La calibration par les meilleures références marché est dans _base-agent-protocol.md mais pas renforcée dans 6/8 agents producteurs ni dans 0/11 prompts client-facing | Codifiée dans _base-agent-protocol.md + copywriter.md + ia.md | Propager dans fullstack, design, seo, social, growth, geo + 11 prompts index.html + orchestrator Task | ouvert |
| 2026-03-27 | 2026-03-27 | pattern | P1 | Le pattern @elon valide → @orchestrator applique → @ia audite → @qa vérifie non-régression est très efficace pour les modifications structurelles | Appliqué sur toutes les modifications de cette session | Pattern "validation 4 couches" à capitaliser | appliqué |
| 2026-03-27 | 2026-03-27 | insistance | P0 | Thomas insiste sur les personas des clients de nos personas — comprendre toute la chaîne de valeur, pas juste l'utilisateur direct | Personas clients-de-clients dans creative-strategy + agents testeurs obligatoires Phase 0b + gates GP/GC | Règle permanente : chaque projet B2B/service doit documenter les 2 niveaux de personas | appliqué |
| 2026-03-27 | 2026-03-27 | insistance | P1 | Thomas veut que les seuils d'alerte ne soient pas frustrants — JAUNE trop tôt, forçait des changements de session inutiles | JAUNE supprimé, seule ROUGE à 6 phases / 18 Task producteurs, agents consultation exclus | Les alertes doivent être calibrées sur le coût réel en contexte, pas sur un compteur brut | appliqué |
| 2026-03-27 | 2026-03-27 | préférence fondateur | P1 | [PRÉFÉRENCE FONDATEUR] : Thomas veut que les outputs générés par la plateforme soient au niveau des meilleurs du secteur, pas juste "corrects" | Règle calibration marché dans _base-agent-protocol.md | Les agents producteurs doivent WebSearch les meilleures références avant de produire | appliqué |
| 2026-03-27 | 2026-03-27 | préférence fondateur | P1 | [PRÉFÉRENCE FONDATEUR] : Thomas veut des agents testeurs qui évaluent sur TOUS les angles (copy, design, contenu, pricing, conviction, recommandation, fidélisation) | Gates GP1-GP10 (persona) + GC1-GC10 (client-du-persona) dans CLAUDE.md | Gates structurées, pas des évaluations vagues | appliqué |

## Session 2026-03-26 — Gradient Agents (consolidation framework)

| Session | Date | Catégorie | Sévérité | Description | Correction appliquée | Recommandation framework | Statut |
|---|---|---|---|---|---|---|---|
| 2026-03-26 | 2026-03-26 | problème | P0 | `<script>alert(1)</script>` dans le texte d'un prompt cassait tout le HTML — les prompts disparaissaient | Remplacé par "balises script" / "balises HTML" dans le texte | Règle : ne JAMAIS utiliser de balises `<script>` ou `</script>` dans le contenu des template literals JS | appliqué |
| 2026-03-26 | 2026-03-26 | biais | P0 | Le scoring 1-5 était subjectif, non reproductible (variance ±0.5), et permettait l'inflation | Remplacé par 25 gates binaires PASS/FAIL vérifiables par Grep/Read | Système de gates binaires documenté dans CLAUDE.md comme standard permanent | appliqué |
| 2026-03-26 | 2026-03-26 | biais | P1 | Le concept "MVP" faisait coder moins que nécessaire — biais humain "scope réduit" | Remplacé par V1 complète. Cycle : Idée/V1/Production/Croissance | MVP supprimé du vocabulaire des agents et prompts | appliqué |
| 2026-03-26 | 2026-03-26 | biais | P1 | Les P2 étaient traités comme "nice-to-have" — les agents demandaient "veux-tu corriger les P2 ?" | Règle : tout corriger, la classification sert à ordonner pas à filtrer | Intégré dans orchestrator.md et tous les prompts d'audit | appliqué |
| 2026-03-26 | 2026-03-26 | insistance | P1 | Thomas a insisté pour que l'autopilot produise le MÊME résultat que les prompts un par un | Carte de référence dans orchestrator.md + instruction dans le prompt autopilot | Principe permanent : "l'autopilot est un raccourci d'exécution, pas de qualité" | appliqué |
| 2026-03-26 | 2026-03-26 | insistance | P1 | Thomas a insisté pour un audit chirurgical page par page (les audits macro laissaient passer des bugs) | Prompt "Revue finale page par page" créé — 21 dimensions par page, obligatoire en Phase 5 | Phase 5b obligatoire dans le pipeline orchestrateur | appliqué |
| 2026-03-26 | 2026-03-26 | requête | P1 | Pas de mécanisme d'alerte quand la session devient trop longue | Compteur de session avec ALERTE JAUNE (2 phases/6 agents) et ROUGE (3/10) | Compteur persisté dans orchestration-plan.md + self-diagnostic | appliqué |
| 2026-03-26 | 2026-03-26 | insistance | P1 | PostgreSQL Replit perd ses données après redéploiement — Thomas a signalé le problème | 7 protections dans infrastructure.md + fullstack.md + prompts enrichis | Protections obligatoires : migrate deploy, seed conditionnel, Replit Secrets, health check DB | appliqué |
| 2026-03-26 | 2026-03-26 | pattern | P2 | Le tri-agent (@orchestrator + @ia + @elon) pour analyser un prompt donne des perspectives complémentaires très riches | Appliqué sur le prompt "Lancer de A à Z" avec succès (5.5→9.1/10) | Pattern à réutiliser pour les audits de prompts critiques | appliqué |
| 2026-03-26 | 2026-03-26 | pattern | P2 | Lancer les 8 agents spécialisés en parallèle pour auditer les gates donne un feedback très complet et rapide | Appliqué pour enrichir les gates de 20 à 25 (ajout G21-G25 métier) | Pattern "audit par chaque agent sur son domaine" à capitaliser | appliqué |
| 2026-03-26 | 2026-03-26 | préférence fondateur | P1 | [PRÉFÉRENCE FONDATEUR] : Thomas veut que les sessions de clôture capturent les learnings pour améliorer l'équipe | Étape 5b ajoutée au prompt de clôture avec 8 catégories de learnings | Boucle learnings fermée + founder-preferences.md cross-projets | appliqué |
| 2026-03-26 | 2026-03-26 | préférence fondateur | P1 | [PRÉFÉRENCE FONDATEUR] : Thomas refuse le concept de "9/10" comme seuil — il veut du PASS/FAIL chirurgical | Système de gates binaires implémenté sur proposition @elon | Le scoring numérique est mort. Place aux gates PASS/FAIL. | appliqué |
