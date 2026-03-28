# Mémoire organisationnelle — Lessons Learned

Ce fichier est la mémoire partagée du framework Gradient Agents. Il capitalise les apprentissages de chaque projet pour que le suivant soit meilleur.

**Responsable** : @orchestrator met à jour ce fichier après chaque projet terminé ou phase majeure.
**Lecture** : tous les agents DEVRAIENT consulter ce fichier dans leur calibration pour bénéficier des apprentissages passés.

---

## Format du tableau de learnings (v2 — 2026-03-28)

Chaque learning suit ce format à 11 colonnes :

```
| Session | Date | Catégorie | Sévérité | Description | Correction appliquée | Recommandation framework | Cible propagation | Fichiers impactés | Statut correction | Statut propagation |
```

**Colonnes ajoutées en v2** :
- **Cible propagation** : `règle-globale` (CLAUDE.md) / `agent-spécifique` (agents/*.md) / `prompts` (index.html) / `documentation` (docs/) / `founder-prefs` (founder-preferences.md + moi.md) / `aucune` (note pour mémoire)
- **Fichiers impactés** : liste EXACTE des fichiers à modifier pour propager le learning. Pas de vague "les agents concernés" — nommer les fichiers.
- **Statut correction** : `fait` / `en-cours` / `à-faire` — le fix a-t-il été appliqué dans le fichier source ?
- **Statut propagation** : `propagé` / `non-propagé` / `n/a` — le fix a-t-il été propagé dans TOUS les fichiers impactés ?

**Règle** : un learning n'est considéré "terminé" que quand statut correction = `fait` ET statut propagation = `propagé` (ou `n/a` si aucune propagation nécessaire).

**Migration** : les learnings existants (format v1, colonne unique "Statut") sont considérés comme correction=fait, propagation=propagé si Statut=appliqué. Les learnings avec Statut=ouvert sont migrés en correction=fait, propagation=non-propagé.

---

## Session 2026-03-27 — Gradient Agents (enrichissement massif + testeurs persona)

| Session | Date | Catégorie | Sévérité | Description | Correction appliquée | Recommandation framework | Cible propagation | Fichiers impactés | Statut correction | Statut propagation |
|---|---|---|---|---|---|---|---|---|---|---|
| 2026-03-27 | 2026-03-27 | problème | P1 | Références "20 gates" / "G1-G20" partout alors qu'il y en a 25 (G1-G25). Les gates G21-G25 risquaient d'être ignorées par le reviewer | Corrigé dans CLAUDE.md, orchestrator.md, reviewer.md, _base-agent-protocol.md | Quand on ajoute des gates, mettre à jour TOUS les compteurs textuels (pas juste les tableaux) | agent-spécifique | CLAUDE.md, orchestrator.md, reviewer.md, _base-agent-protocol.md | fait | propagé |
| 2026-03-27 | 2026-03-27 | problème | P1 | "ALERTE JAUNE" résiduelle dans orchestrator.md (self-diagnostic) alors que JAUNE a été supprimée | Remplacé par ALERTE ROUGE | Après suppression d'un concept, Grep le terme dans TOUS les fichiers | agent-spécifique | orchestrator.md | fait | propagé |
| 2026-03-27 | 2026-03-27 | problème | P0 | La calibration par les meilleures références marché est dans _base-agent-protocol.md mais pas renforcée dans 6/8 agents producteurs ni dans 0/11 prompts client-facing | Codifiée dans _base-agent-protocol.md + copywriter.md + ia.md | Propagé dans fullstack, design, seo, social, growth, geo (6 agents) + 11 prompts index.html (calibration WebSearch). Session 2026-03-28 | agent-spécifique + prompts | fullstack.md, design.md, seo.md, social.md, growth.md, geo.md, index.html | fait | propagé |
| 2026-03-27 | 2026-03-27 | pattern | P1 | Le pattern @elon valide → @orchestrator applique → @ia audite → @qa vérifie non-régression est très efficace pour les modifications structurelles | Appliqué sur toutes les modifications de cette session | Pattern "validation 4 couches" à capitaliser | aucune | — | fait | n/a |
| 2026-03-27 | 2026-03-27 | insistance | P0 | Thomas insiste sur les personas des clients de nos personas — comprendre toute la chaîne de valeur, pas juste l'utilisateur direct | Personas clients-de-clients dans creative-strategy + agents testeurs obligatoires Phase 0b + gates GP/GC | Règle permanente : chaque projet B2B/service doit documenter les 2 niveaux de personas | règle-globale + agent-spécifique | CLAUDE.md, orchestrator.md, creative-strategy.md, agent-factory.md | fait | propagé |
| 2026-03-27 | 2026-03-27 | insistance | P1 | Thomas veut que les seuils d'alerte ne soient pas frustrants — JAUNE trop tôt, forçait des changements de session inutiles | JAUNE supprimé, seule ROUGE à 6 phases / 18 Task producteurs, agents consultation exclus | Les alertes doivent être calibrées sur le coût réel en contexte, pas sur un compteur brut | agent-spécifique | orchestrator.md, CLAUDE.md | fait | propagé |
| 2026-03-27 | 2026-03-27 | préférence fondateur | P1 | [PRÉFÉRENCE FONDATEUR] : Thomas veut que les outputs générés par la plateforme soient au niveau des meilleurs du secteur, pas juste "corrects" | Règle calibration marché dans _base-agent-protocol.md | Les agents producteurs doivent WebSearch les meilleures références avant de produire | founder-prefs + agent-spécifique | founder-preferences.md, _base-agent-protocol.md, copywriter.md, ia.md | fait | propagé |
| 2026-03-27 | 2026-03-27 | préférence fondateur | P1 | [PRÉFÉRENCE FONDATEUR] : Thomas veut des agents testeurs qui évaluent sur TOUS les angles (copy, design, contenu, pricing, conviction, recommandation, fidélisation) | Gates GP1-GP10 (persona) + GC1-GC10 (client-du-persona) dans CLAUDE.md | Gates structurées, pas des évaluations vagues | founder-prefs + règle-globale | founder-preferences.md, CLAUDE.md, orchestrator.md | fait | propagé |

## Session 2026-03-26 — Gradient Agents (consolidation framework)

| Session | Date | Catégorie | Sévérité | Description | Correction appliquée | Recommandation framework | Cible propagation | Fichiers impactés | Statut correction | Statut propagation |
|---|---|---|---|---|---|---|---|---|---|---|
| 2026-03-26 | 2026-03-26 | problème | P0 | Balises script dans le texte d'un prompt cassait tout le HTML — les prompts disparaissaient | Remplacé par "balises script" / "balises HTML" dans le texte | Règle : ne JAMAIS utiliser de balises script dans le contenu des template literals JS | prompts | index.html | fait | propagé |
| 2026-03-26 | 2026-03-26 | biais | P0 | Le scoring 1-5 était subjectif, non reproductible (variance ±0.5), et permettait l'inflation | Remplacé par 25 gates binaires PASS/FAIL vérifiables par Grep/Read | Système de gates binaires documenté dans CLAUDE.md comme standard permanent | règle-globale | CLAUDE.md, orchestrator.md, reviewer.md | fait | propagé |
| 2026-03-26 | 2026-03-26 | biais | P1 | Le concept "MVP" faisait coder moins que nécessaire — biais humain "scope réduit" | Remplacé par V1 complète. Cycle : Idée/V1/Production/Croissance | MVP supprimé du vocabulaire des agents et prompts | règle-globale + prompts | CLAUDE.md, product-manager.md, index.html | fait | propagé |
| 2026-03-26 | 2026-03-26 | biais | P1 | Les P2 étaient traités comme "nice-to-have" — les agents demandaient "veux-tu corriger les P2 ?" | Règle : tout corriger, la classification sert à ordonner pas à filtrer | Intégré dans orchestrator.md et tous les prompts d'audit | agent-spécifique + prompts | orchestrator.md, index.html | fait | propagé |
| 2026-03-26 | 2026-03-26 | insistance | P1 | Thomas a insisté pour que l'autopilot produise le MÊME résultat que les prompts un par un | Carte de référence dans orchestrator.md + instruction dans le prompt autopilot | Principe permanent : "l'autopilot est un raccourci d'exécution, pas de qualité" | agent-spécifique + prompts | orchestrator.md, index.html | fait | propagé |
| 2026-03-26 | 2026-03-26 | insistance | P1 | Thomas a insisté pour un audit chirurgical page par page (les audits macro laissaient passer des bugs) | Prompt "Revue finale page par page" créé — 21 dimensions par page, obligatoire en Phase 5 | Phase 5b obligatoire dans le pipeline orchestrateur | agent-spécifique + prompts | orchestrator.md, index.html | fait | propagé |
| 2026-03-26 | 2026-03-26 | requête | P1 | Pas de mécanisme d'alerte quand la session devient trop longue | Compteur de session avec ALERTE ROUGE (6 phases/18 Task producteurs) | Compteur persisté dans orchestration-plan.md + self-diagnostic | agent-spécifique | orchestrator.md | fait | propagé |
| 2026-03-26 | 2026-03-26 | insistance | P1 | PostgreSQL Replit perd ses données après redéploiement — Thomas a signalé le problème | 7 protections dans infrastructure.md + fullstack.md + prompts enrichis | Protections obligatoires : migrate deploy, seed conditionnel, Replit Secrets, health check DB | agent-spécifique + prompts | infrastructure.md, fullstack.md, index.html | fait | propagé |
| 2026-03-26 | 2026-03-26 | pattern | P2 | Le tri-agent (@orchestrator + @ia + @elon) pour analyser un prompt donne des perspectives complémentaires très riches | Appliqué sur le prompt "Lancer de A à Z" avec succès (5.5→9.1/10) | Pattern à réutiliser pour les audits de prompts critiques | aucune | — | fait | n/a |
| 2026-03-26 | 2026-03-26 | pattern | P2 | Lancer les 8 agents spécialisés en parallèle pour auditer les gates donne un feedback très complet et rapide | Appliqué pour enrichir les gates de 20 à 25 (ajout G21-G25 métier) | Pattern "audit par chaque agent sur son domaine" à capitaliser | aucune | — | fait | n/a |
| 2026-03-26 | 2026-03-26 | préférence fondateur | P1 | [PRÉFÉRENCE FONDATEUR] : Thomas veut que les sessions de clôture capturent les learnings pour améliorer l'équipe | Étape 5b ajoutée au prompt de clôture avec 8 catégories de learnings | Boucle learnings fermée + founder-preferences.md cross-projets | founder-prefs + prompts | founder-preferences.md, index.html | fait | propagé |
| 2026-03-26 | 2026-03-26 | préférence fondateur | P1 | [PRÉFÉRENCE FONDATEUR] : Thomas refuse le concept de "9/10" comme seuil — il veut du PASS/FAIL chirurgical | Système de gates binaires implémenté sur proposition @elon | Le scoring numérique est mort. Place aux gates PASS/FAIL. | founder-prefs + règle-globale | founder-preferences.md, CLAUDE.md, reviewer.md | fait | propagé |
