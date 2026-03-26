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
