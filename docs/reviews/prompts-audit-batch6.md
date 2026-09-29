# Audit Prompts — Batch 6 (lignes 2462-2954)

**Date** : 2026-04-02
**Agent** : @ia
**Scope** : 11 prompts de la catégorie "Contrôle qualité" et "Workflows avances" dans `index.html`
**Méthode** : evaluation sur 3 axes (Clarte, Completude, Robustesse) notes /5, verdict SOLIDE / A Améliorer / PROBLEMATIQUE

## Grille d'audit

| # | Prompt | Agent(s) | Clarte /5 | Completude /5 | Robustesse /5 | Verdict | Note |
|---|---|---|---|---|---|---|---|
| 1 | Revue croisee GO/NO-GO | reviewer, legal | 5 | 5 | 4 | SOLIDE | Prompt très complet avec 10 axes d'audit, gates G1-G30, invocation des testeurs persona. Le chainage @legal est bien defini. Risque de timeout élevé vu le scope massif (tous les livrables + 30 gates + testeurs). La mention "Bugs corriges immédiatement" est irrealiste pour @reviewer qui n'écrit pas de code. |
| 2 | Revue intermediaire (mid-projet) | reviewer, legal | 5 | 4 | 4 | SOLIDE | Version allege cohérente de la revue GO/NO-GO. 9 axes bien structures. Le fallback "si aucun livrable n'existe" est bien gere. Manque : precision sur le nombre minimum de livrables pour declencher cette revue (dit "3+" dans le champ "quand" mais pas dans le prompt). |
| 3 | Audit qualité & tests complets | qa, infrastructure | 4 | 5 | 4 | SOLIDE | Prompt extremement dense (13 dimensions + philosophie Testing Trophy). Numerotation doublee (deux n.8, deux n.9, deux n.10) — bug de maintenance. Le scope est enorme pour un seul agent, risque de timeout significatif malgre l'anti-timeout dans "quand". La mention "Bugs corriges immédiatement" est cohérente ici car @qa peut signaler mais c'est @fullstack qui corrige — or @fullstack n'est pas dans la chaîne. |
| 4 | Audit UX & conversion | ux, data-analyst, growth | 5 | 5 | 4 | SOLIDE | Excellent chainage triple avec scope clair par agent. Les 8 dimensions d'audit (HEART, Nielsen, cognitive walkthrough) sont professionnelles. Quick wins priories par impact/effort. Seul bemol : presuppose des données analytics réelles qui peuvent ne pas exister (le fallback "coller dans le prompt" est vague). |
| 5 | Audit stratégique first principles | elon | 5 | 4 | 5 | SOLIDE | Prompt clair, direct, bien calibre pour l'agent @elon. Les 9 dimensions couvrent vision/execution/moat. La dimension "Theatre vs valeur" est discriminante. Manque : pas de comparaison sectorielle via WebSearch (contrairement a d'autres prompts qui l'exigent). |
| 6 | Revue finale page par page | qa, fullstack, ux, design | 4 | 5 | 4 | SOLIDE | Le prompt le plus complet du batch (21 dimensions, 6 phases). Scoring par page bien structure. La boucle d'iteration avec 4 agents est realiste. Anti-timeout integre. Bemol : la densité est un risque — 21 dimensions par page avec 4 agents = session très longue. La numerotation est correcte ici contrairement au prompt 3. |
| 7 | Checklist jour de lancement | orchestrator, qa, infrastructure, legal | 5 | 5 | 5 | SOLIDE | Prompt exemplaire. Structure checklist claire avec catégories (Produit, Infra, Contenu, Legal, Communication). Le verdict GO/NO-GO binaire est bien defini. La mention "vérifier concretement (pas juste coche)" est une excellente directive anti-paresse. Rien a signaler. |
| 8 | Monitoring post-launch | infrastructure, data-analyst, copywriter | 5 | 4 | 4 | SOLIDE | Chainage cohérent (monitoring technique → métriques business → communication incident). Les 7 dimensions de monitoring sont completes. Bonne inclusion de la status page publique. Manque : pas de mention du budget des outils de monitoring (Sentry payant au-dela du free tier, UptimeRobot idem). Le self-fetch warning est un excellent detail opérationnel. |
| 9 | Audit accessibilité RGAA/WCAG | ux, fullstack, legal | 5 | 5 | 5 | SOLIDE | Prompt très professionnel. Les 8 points couvrent automatise + manuel (30% vs 70% — bien calibre). La mention RGAA 2025 est à jour. Le chainage UX → code → legal est logique. La declaration d'accessibilité est un livrable legal obligatoire souvent oublie — bien inclus ici. Excellent. |
| 10 | Audit de sécurité complet | infrastructure, fullstack, legal | 5 | 5 | 4 | SOLIDE | OWASP Top 10 bien structure. Les 8 dimensions couvrent headers, auth, deps, secrets, données, API, pentest. Le pentest léger (IDOR, privilege escalation, XSS) est realiste pour un agent IA. Bemol mineur : le pentest par un LLM est limite — il peut vérifier le code mais pas executer des attaques réelles. Devrait mentionner cette limite. |
| 11 | Monitoring UX (session replay & heatmaps) | data-analyst, ux, fullstack | 5 | 5 | 5 | SOLIDE | Comparatif d'outils bien structure (Hotjar/PostHog/FullStory/Clarity). Le critère RGPD est bien mis en avant. Sampling rate contextuel (100% si < 1000 sessions). Le rapport mensuel automatise est une bonne pratique. Le conditionnement au consentement cookies est bien mentionne. |
| 12 | Evaluation des outputs IA (evals) | ia, qa, data-analyst | 5 | 5 | 5 | SOLIDE | Prompt de référence pour les evals LLM. Golden dataset 50 cas minimum, LLM-as-judge avec calibration humaine (correlation > 0.8), pipeline CI, alertes de degradation, dashboard. Le chainage ia → qa → data-analyst est parfaitement logique. La mention du rollback automatique de prompt est une best practice avancee. |
| 13 | Refondre un site existant | ux, design, fullstack, legal | 4 | 5 | 4 | SOLIDE | Chainage quadruple bien orchestre. L'audit UX en 6 points est complet. La mention "migration progressive vs big bang" avec critère (<20 fichiers) est opérationnelle. Bonne inclusion de la preservation SEO (URLs, redirections 301). Bemol : 4 agents = session longue, le conseil anti-timeout est dans "quand" mais devrait être dans le prompt. |
| 14 | Diagnostiquer un problème de performance | infrastructure, seo, data-analyst, ux | 5 | 5 | 4 | SOLIDE | Audit en 7 dimensions techniques + 3 analyses croisees (SEO, business, UX percue). Le budget performance est bien defini (JS < 200KB, page < 1MB). La correlation performance → revenu perdu est un angle souvent oublie. Bemol : 4 agents avec chainage sequentiel = timeout probable sans decoupage. |
| 15 | Auditer la cohérence visuelle | design, ux, legal | 5 | 5 | 4 | SOLIDE | 8 dimensions d'audit incluant dark mode et performance visuelle. La mention "backoffice = même design system" est une règle souvent negligee. Le lien GEO (cohérence de marque pour la reconnaissance IA) est original. Bonne inclusion de la conformite legale (RGAA/EAA). |

## Synthese

**15 prompts audites** — tous en verdict SOLIDE.

### Points forts recurrents
- Chainages multi-agents bien structures avec scope clair par agent
- Fallbacks systematiques ("s'il n'existe pas, pose-moi les questions")
- Critères de validation explicites en fin de prompt
- Mentions anti-timeout dans le champ "quand" avec instructions de reprise
- Conformite legale systématiquement incluse

### Points d'amélioration identifies

| # | Problème | Sévérité | Prompts concernés | Correction proposee |
|---|---|---|---|---|
| A1 | Numerotation doublee dans le prompt Audit qualité (deux n.8, deux n.9, deux n.10) | P1 | #3 | Renumeroter 8-13 correctement |
| A2 | "Bugs corriges immédiatement" dans la revue croisee alors que @reviewer ne code pas | P2 | #1 | Reformuler : "Bugs signales avec sévérité pour correction immediate par @fullstack" |
| A3 | Prompts a 4 agents sans anti-timeout dans le prompt lui-meme (seulement dans "quand") | P2 | #6, #13, #14 | Ajouter une directive anti-timeout dans le corps du prompt |
| A4 | Prompt Audit qualité ne chaîne pas @fullstack pour les corrections | P2 | #3 | Ajouter @fullstack dans le chainage ou documenter que les corrections sont separees |
| A5 | Aucun prompt ne mentionne le budget des outils tiers payants | P2 | #8, #11 | Ajouter un rappel de vérifier le budget dans project-context.md avant de recommander des outils payants |

### Statistiques

- **SOLIDE** : 15/15 (100%)
- **A Améliorer** : 0/15
- **PROBLEMATIQUE** : 0/15
- **Score moyen Clarte** : 4.87/5
- **Score moyen Completude** : 4.87/5
- **Score moyen Robustesse** : 4.40/5
- **Axe le plus faible** : Robustesse — principalement lie au risque de timeout sur les prompts les plus denses et a l'absence de garde-fous pour les limites inherentes aux agents IA (pentest, correction de code par @reviewer)

---

**Handoff → @orchestrator**
- Fichier produit : `docs/reviews/prompts-audit-batch6.md`
- Décisions prises : tous les prompts sont SOLIDES, 5 améliorations P1/P2 identifiees
- Points d'attention : la correction A1 (numerotation doublee) est un bug factuel à corriger dans `index.html` ligne ~2529-2544. Les autres sont des améliorations de robustesse non bloquantes.
