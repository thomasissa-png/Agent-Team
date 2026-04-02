# Audit des prompts — Batch 7 (lignes 2955-3300)

**Date** : 2026-04-02
**Agent** : @ia
**Scope** : 9 prompts de `index.html` (lignes 2955 a 3300) — prompts operationnels avances et sessions
**Methode** : evaluation Clarte (instructions sans ambiguite), Completude (couverture des cas, fallbacks, conformite), Robustesse (gestion erreur, timeout, reprise)

## Grille d'evaluation

| # | Prompt | Agent(s) | Clarte /5 | Completude /5 | Robustesse /5 | Verdict | Note |
|---|--------|----------|-----------|---------------|---------------|---------|------|
| 1 | Optimiser l'onboarding | ux, copywriter, data-analyst, legal | 5 | 5 | 4 | SOLIDE | Chaine 4 agents avec fallback docs manquants. Time-to-value < 3 min bien cadre. Progressive disclosure documente. RGPD couvert. Seul point : pas de seuil de retry si un agent timeout en milieu de chaine. |
| 2 | Creer un agent specialise | agent-factory | 4 | 5 | 4 | SOLIDE | Protocole complet en 7 etapes. Verification de doublon avant creation (bon). Dimensions transversales incluses. Placeholders [domaine] et [contexte] signales dans le "quand". Duplication du bloc livrables (lignes 2992-2994 et 2998-3000) = bruit mais sans impact fonctionnel. |
| 3 | Migrer la stack technique | fullstack, infrastructure, qa, data-analyst | 5 | 5 | 5 | SOLIDE | Excellente couverture : SEO/URLs, tracking, rollback par etape, migration modele IA (protocole dedie). Plan progressif, pas de big bang. Critere de validation precis. Conseil de nommage de session et commande de reprise inclus. |
| 4 | Internationaliser le produit (i18n) | fullstack, copywriter, seo, legal | 5 | 5 | 4 | SOLIDE | Couvre technique (routing, lazy loading), contenu (adaptation culturelle, longueur texte), SEO (hreflang, x-default), legal (obligations par marche), GEO (contenu citable par LLM). Manque mineur : pas de mention du testing des traductions (QA linguistique ou automated checks sur les fichiers JSON). |
| 5 | Post-mortem incident production | infrastructure, qa, copywriter, data-analyst | 5 | 5 | 4 | SOLIDE | Analyse "5 pourquoi" pour la root cause — bon pattern. Communication incident couverte (status page, email, social). Geste commercial mentionne. Manque : pas de mention de SLA ou d'obligation contractuelle de notification (si applicable). |
| 6 | Collecter le feedback et planifier la v2 | product-manager, data-analyst, ux, legal | 5 | 5 | 5 | SOLIDE | Excellent cadrage : sources de feedback exhaustives (in-app, interviews, support, analytics), RICE avec Confidence basee sur donnees reelles. Quick wins separes. Items exclus documentes. Garde-fou "pas inventer de feedback" explicite. |
| 7 | Structurer les A/B tests de conversion | growth, data-analyst, fullstack, legal | 5 | 5 | 5 | SOLIDE | Protocole statistique complet (puissance 80%, significativite 95%, taille echantillon). Anti-patterns documentes. Garde-fous (KPI secondaire). Feature flags avec sticky sessions. Conformite RGPD du tracking. Un des meilleurs prompts du dashboard. |
| 8 | Reporting investisseurs | data-analyst, product-manager | 5 | 5 | 4 | SOLIDE | Metriques SaaS/marketplace/transactionnel couvertes. Template 1 page pour les investisseurs — pragmatique. Narrative produit separee des metriques. Conformite (pas de metriques trompeuses, projections identifiees). Manque mineur : pas de mention de frequence de mise a jour recommandee (mensuel implicite mais pas explicite dans les criteres). |
| 9 | Cloture de session | orchestrator | 5 | 5 | 5 | SOLIDE | Le prompt le plus complet du dashboard. 6 etapes + 5b/5c. Propagation check obligatoire. Learnings avec tableau 11 colonnes, deduplication, expiration P2. Synchronisation cross-projets via GitHub raw URLs. Memo de reprise avec commande de relance. Exemplaire. |

## Synthese

- **9/9 SOLIDE** — Ce batch est le plus solide audite. Aucun prompt PROBLEMATIQUE ni A AMELIORER.
- **Score moyen** : Clarte 4.9 / Completude 5.0 / Robustesse 4.6
- **Pattern recurrent positif** : chaque prompt inclut (a) fallback si docs manquants, (b) conformite RGPD, (c) criteres de validation binaires, (d) conseil de reprise post-timeout dans le champ "quand".
- **Axe d'amelioration transversal** : la robustesse pourrait etre renforcee par un mecanisme explicite de retry/fallback quand un agent de la chaine timeout (actuellement le "quand" donne un conseil verbal mais pas d'instruction automatique dans le prompt lui-meme).

## Anomalie detectee

**Prompt #2 (Creer un agent specialise)** : le bloc "Livrables" et "Signale a @orchestrator" est duplique (lignes ~2992-2994 et ~2998-3000). Pas d'impact fonctionnel mais cree du bruit et consomme des tokens inutilement. Recommandation : supprimer la premiere occurrence.

---
**Handoff -> @orchestrator**
- Fichier produit : `/home/user/Agent-Team/docs/reviews/prompts-audit-batch7.md`
- Decisions prises : 9 prompts audites, tous SOLIDE, 0 action corrective bloquante
- Points d'attention : duplication dans le prompt "Creer un agent specialise" (nettoyage mineur), mecanisme de retry inter-agents a envisager comme amelioration transversale
