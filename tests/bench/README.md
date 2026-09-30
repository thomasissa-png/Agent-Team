# Banc d'essai des agents (PulseBoard)

Mesure si les agents produisent de bons livrables, pas seulement si leurs fichiers sont conformes.
À relancer après toute révision importante des agents ou du protocole commun.

## Lancer

1. Préparer un projet de test hors du repo :
   `mkdir -p <B>/docs/{strategy,copy,ia} && cp tests/project-context-test.md <B>/project-context.md && cp docs/founder-preferences.md <B>/founder-preferences.md`
2. Depuis une session Claude Code sur ce repo, lancer en parallèle les 3 agents (Task) avec les missions ci-dessous. Chaque prompt précise que la racine du projet est `<B>` (et non le repo), qu'il ne faut rien écrire hors de `<B>/docs/`, et inclut la ligne ANTI-TIMEOUT.
   - **creative-strategy** : plateforme de marque dans `docs/strategy/brand-platform.md` (framework justifié, benchmark 3-5 concurrents par WebSearch, espace libre, hiérarchie de messages avec preuves, voice & tone, brief créatif avec exclusions).
   - **copywriter** : copy complet de la landing dans `docs/copy/landing-page-copy.md` (hero, preuve sociale, bénéfices avec preuve, fonctionnement, pricing, FAQ des objections, CTA ; stade Idée : aucun témoignage réel).
   - **ia** : architecture d'une feature IA dans `docs/ia/ai-architecture.md` (résumé hebdomadaire des KPIs rédigé par IA, 500 comptes : modèles, sortie structurée, refus, coûts, évals, UX, RGPD).
3. Contrôle automatique : `bash tests/bench/check-bench.sh <B>` (gates, preuve « Vérifié : », accents ; copy : tirets, tics d'écriture IA, faux témoignages ; ia : modèles actuels et contraintes API 5.5).
4. Relecture humaine : le contrôle automatique mesure la conformité, pas le talent. Lire au moins le positionnement, le hero et la FAQ, et les décisions de l'architecture IA.

## Historique

| Date | Automatique | Constat de relecture | Défauts du framework révélés |
|---|---|---|---|
| 2026-09-30 | 34/34 PASS | Livrables sourcés, sans invention ; plateforme de marque de haut niveau ; landing honnête mais H1 générique et document chargé d'annotations ; architecture IA conforme 5.5 | 8 agents sans Grep ; format de version avec tirets cadratins ; projet de test sur une stack périmée ; fallback de refus non accepté en batch (ajouté à ia.md) |
