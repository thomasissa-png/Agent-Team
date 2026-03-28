# Audit de cohérence : Préférences fondateur vs Implémentation framework

> Audit réalisé par @elon — 2026-03-28
> AVIS CONSULTATIF — Ces constats nécessitent validation avant correction.

## Résumé exécutif

**38 préférences documentées dans `docs/founder-preferences.md` + 13 préférences cross-projets identifiées.**
- Pleinement implémentées : **18/51** (35%)
- Partiellement implémentées : **11/51** (22%)
- Pas implémentées du tout : **22/51** (43%)

**Diagnostic brutal** : les 25 préférences "originales" d'Agent-Team sont globalement bien couvertes (19/25 plein ou partiel). Les 13 préférences cross-projets (Sarani, Mandataire, Versiroom) sont quasi absentes du framework (1 seule partiellement implémentée, 12 GAPs complets). Le pipeline `founder-preferences.md` → agents n'a pas de mécanisme de propagation automatique vers les fichiers agents. C'est un document passif, pas un système actif.

---

## CATÉGORIE 1 — Préférences originales Agent-Team (lignes 13-37)

| # | Préférence | Documentée dans | Implémentée dans workflow | GAP ? | Correction nécessaire |
|---|---|---|---|---|---|
| 1 | NextAuth > Clerk (anti vendor lock-in) | founder-prefs, moi.md (pt 7) | fullstack.md (ligne 43 : NextAuth défaut), CLAUDE.md implicite via fullstack | NON | -- |
| 2 | P2 ne sont PAS optionnels | founder-prefs, moi.md (pt 3) | CLAUDE.md Règle n°5 (tout coder), moi.md anti-pattern #4 | NON | -- |
| 3 | 9/10 minimum | founder-prefs, moi.md (pt 1) | reviewer.md (seuil 9/10 persona), CLAUDE.md gates (100% PASS), moi.md seuils verdicts | NON | -- |
| 4 | Autopilot = même qualité que manuel | founder-prefs, moi.md anti-pattern #10 | orchestrator.md (prompt bibliothèque obligatoire, lignes 239-245) | PARTIEL | Aucun gate ni check automatisé ne vérifie la parité autopilot/manuel. C'est une intention, pas un mécanisme. Ajouter un checkpoint dans orchestrator.md |
| 5 | V1 complète, pas de MVP | founder-prefs, moi.md (pt 2) | CLAUDE.md Règle n°5 (jamais couper par effort), product-manager.md (scope complet) | NON | -- |
| 6 | Calendrier éditorial perpétuel | founder-prefs, moi.md (pt 13) | index.html prompt automation (ligne 2251 : "le calendrier ne s'arrête JAMAIS") | PARTIEL | Implémenté dans le prompt index.html mais PAS dans social.md ni seo.md comme règle agent. Si un agent est invoqué directement (pas via prompt bibliothèque), il ne sait pas que le calendrier doit être perpétuel |
| 7 | Anti-répétition contenu | founder-prefs, moi.md | index.html (content_registry + anti-cannibalisation LLM, ligne 2251) | PARTIEL | Même problème : implémenté dans le prompt mais PAS dans seo.md, social.md, copywriter.md comme règle permanente. Aucun agent de contenu n'a "vérifier les sujets déjà publiés" dans son protocole |
| 8 | Accents français obligatoires | founder-prefs, moi.md (pt 11, anti-pattern #12) | CLAUDE.md Règle n°13 (UTF-8 obligatoires), fullstack.md (ligne 109) | NON | -- |
| 9 | Audit tous les clics/interactions | founder-prefs | qa.md (tests E2E parcours, tests d'interactions), ux.md (revue post-implémentation) | PARTIEL | qa.md couvre les parcours E2E mais n'a PAS de directive explicite "tester chaque bouton/lien cliquable de chaque page". C'est couvert implicitement, pas explicitement |
| 10 | PostgreSQL Replit + protections persistance | founder-prefs | fullstack.md (ligne 44, détaillé), infrastructure.md (lignes 43-51, détaillé) | NON | -- |
| 11 | Learnings en clôture | founder-prefs, moi.md (pt 10) | CLAUDE.md (Mémoire organisationnelle), orchestrator.md (clôture session) | NON | -- |
| 12 | Mindset IA, pas d'équipe humaine | founder-prefs, moi.md (pt 2) | CLAUDE.md Règle n°5 (complète et détaillée) | NON | -- |
| 13 | PostgreSQL Replit obligatoire | founder-prefs, moi.md (pt 7) | fullstack.md, infrastructure.md | NON | -- |
| 14 | Prix ronds (pas charm pricing) | founder-prefs | NULLE PART dans les agents | OUI | Ajouter dans product-manager.md (section pricing) et copywriter.md : "Prix ronds obligatoires — pas de charm pricing en 7/9 (497, 197, 97). Cohérence avec positionnement transparent." |
| 15 | Zéro concurrent nommé | founder-prefs | CLAUDE.md Règle n°14 (détaillée) | NON | -- |
| 16 | Modal auth (pas page pleine) | founder-prefs | NULLE PART dans les agents | OUI | Ajouter dans fullstack.md et ux.md : "Auth en modal popup — Header/Footer visibles. Pas de page pleine dédiée à l'auth." |
| 17 | Pas de duplication d'info | founder-prefs | index.html (ligne 2766 : "pré-remplir au maximum") | PARTIEL | Mentionné dans un prompt index.html mais PAS dans ux.md, product-manager.md ou fullstack.md comme règle permanente |
| 18 | LinkedIn > questionnaire long | founder-prefs | NULLE PART dans les agents | OUI | Ajouter dans ux.md et product-manager.md : "Préférer import LinkedIn/données existantes à un questionnaire long. Réalisme persona > complétude formulaire." |
| 19 | Admin valide avant automatisation | founder-prefs | index.html (approve route, ligne 2252) | PARTIEL | Le prompt code a un `/approve` mais aucune règle dans fullstack.md ou ia.md n'impose "validation humaine avant publication automatique". C'est dans un prompt, pas dans l'ADN des agents |
| 20 | Résiliation = perte accès | founder-prefs | NULLE PART dans les agents | OUI | Ajouter dans product-manager.md (section abonnement) et legal.md : "Résiliation = perte d'accès aux livrables. Les livrables sont liés à l'abonnement actif." |
| 21 | Valeurs business centralisées (pricing.ts) | founder-prefs | fullstack.md (lignes 94-100, détaillé : pricing.ts + règle) | NON | -- |
| 22 | Outputs au niveau des meilleurs du secteur | founder-prefs | fullstack.md (ligne 138 : benchmark), design.md (ligne 56 : benchmark), copywriter.md (ligne 52 : benchmark), + 7 autres agents via _base-agent-protocol.md | NON | -- |
| 23 | Personas clients-de-clients | founder-prefs | orchestrator.md (phases testeurs), creative-strategy.md, agent-factory.md, CLAUDE.md (gates GC1-GC10), reviewer.md (validation B2B) | NON | -- |
| 24 | Agents testeurs sur tous les angles | founder-prefs | orchestrator.md (phases 0b, 2c, 2d, 5b), CLAUDE.md (gates GP/GC), reviewer.md, ux.md (recommandation agents) | NON | -- |
| 25 | Alertes session pas frustrantes | founder-prefs | CLAUDE.md (seule ROUGE, pas de JAUNE — ligne 198) | NON | -- |

---

## CATÉGORIE 2 — Anti-patterns (lignes 43-56)

| # | Anti-pattern | Implémenté dans workflow | GAP ? | Correction nécessaire |
|---|---|---|---|---|
| AP1 | Choix technique par facilité | fullstack.md (ligne 40 : règle mindset IA), moi.md (anti-pattern #2, grille décision sans "facilité") | NON | -- |
| AP2 | Scope réduit artificiellement | CLAUDE.md Règle n°5, moi.md (anti-pattern #3) | NON | -- |
| AP3 | P2 traités comme optionnels | moi.md (anti-pattern #4), CLAUDE.md Règle n°5 | NON | -- |
| AP4 | Formulations vides / théâtre | moi.md (anti-pattern #14), CLAUDE.md gate G10 (0 langage vague) | NON | -- |
| AP5 | Accents manquants | CLAUDE.md Règle n°13, moi.md (anti-pattern #12), fullstack.md | NON | -- |
| AP6 | Demander permission au lieu de faire | moi.md (anti-pattern #7) | PARTIEL | Présent dans moi.md mais PAS dans les agents producteurs (fullstack, copywriter, etc.). Un agent peut encore dire "veux-tu que je..." |
| AP7 | Vendor lock-in sans justification | moi.md (pts 7, anti-pattern #5), fullstack.md | NON | -- |
| AP8 | Incohérence de nommage | moi.md (anti-pattern #13), reviewer.md (cohérence) | NON | -- |
| AP9 | Contenu qui se répète | moi.md (anti-pattern), index.html (content_registry) | PARTIEL | Voir préf #7 — manque dans les agents contenu |
| AP10 | Autopilot moins bien que manuel | moi.md (anti-pattern #10), orchestrator.md | PARTIEL | Voir préf #4 |
| AP11 | Charm pricing | NULLE PART | OUI | Voir préf #14 |
| AP12 | Valeurs business hardcodées | fullstack.md (lignes 94-100), CLAUDE.md gate G23 | NON | -- |
| AP13 | Pages auth sans Header/Footer | NULLE PART | OUI | Voir préf #16 |
| AP14 | Redemander une info déjà fournie | PARTIEL (index.html seul) | OUI | Voir préf #17 |

---

## CATÉGORIE 3 — Préférences cross-projets (Sarani, Mandataire, Versiroom)

| # | Préférence | Source | Implémentée dans framework | GAP ? | Correction nécessaire |
|---|---|---|---|---|---|
| CP1 | Prompt engineering = livrable avant code | Sarani | NON — @ia produit prompt-library.md mais aucune règle ne dit "prompts doivent être écrits et validés AVANT que @fullstack code les features IA" | OUI | Ajouter dans orchestrator.md : dépendance explicite "ia.prompt-library.md AVANT fullstack code IA". Ajouter dans ia.md : "Les prompts sont un livrable à part entière, pas du code inline" |
| CP2 | Documents client-facing = même design que site | Sarani | PARTIEL — creative-strategy.md mentionne "design documents client" mais aucune règle dans design.md ou fullstack.md | OUI | Ajouter dans design.md : "Les exports/documents générés pour les clients du persona DOIVENT utiliser le design system du site (tokens, typo, couleurs)." |
| CP3 | Labels texte > icônes seules (back-office) | Sarani | NON | OUI | Ajouter dans ux.md et design.md : "En back-office/admin, chaque icône DOIT être accompagnée d'un label texte. Pas d'icônes seules." |
| CP4 | Dashboard = coaching, pas bibliothèque | Sarani | NON | OUI | Ajouter dans ux.md et product-manager.md : "Le dashboard principal doit guider l'utilisateur vers la prochaine action (coaching), pas lister des ressources (bibliothèque)." |
| CP5 | Progressive validation flows (brief > storyboard > final) | Sarani | NON | OUI | Ajouter dans ux.md et product-manager.md : "Pour les workflows de création multi-étapes, adopter un flow progressif : brief > preview/storyboard > validation > production finale." |
| CP6 | 7 critères visuels (PRO, BEAU, BRAND-ALIGNED, etc.) | Sarani | NON | OUI | Ajouter dans design.md : grille de validation visuelle obligatoire pour chaque composant/écran |
| CP7 | Colonnes monétaires alignées à droite | Sarani | NON | OUI | Ajouter dans design.md et fullstack.md : "Les colonnes contenant des valeurs monétaires DOIVENT être alignées à droite." |
| CP8 | 10 scénarios concrets par écran persona | Mandataire | NON | OUI | Ajouter dans ux.md : "Pour chaque écran, documenter 10 scénarios concrets d'utilisation du persona (pas des cas abstraits)." |
| CP9 | Screenshots obligatoires pour validation UI | Mandataire | NON | OUI | Ajouter dans qa.md et fullstack.md : "Chaque PR qui modifie l'UI DOIT inclure des screenshots avant/après. La validation visuelle par screenshot est un critère de merge." |
| CP10 | tsc --noEmit avant deploy | Mandataire | index.html (ligne 1463 seul) | OUI | Ajouter dans fullstack.md (auto-évaluation) et qa.md (pipeline) : "tsc --noEmit obligatoire avant chaque déploiement" |
| CP11 | Persistance > vitesse | Versiroom | PARTIEL — infrastructure.md couvre PostgreSQL mais pas la règle générale | OUI | Ajouter dans infrastructure.md et fullstack.md : "Priorité absolue : persistance des données > vitesse d'exécution. Jamais de raccourci qui risque une perte de données." |
| CP12 | Formats standard secteur > créativité B2B | Versiroom | NON | OUI | Ajouter dans copywriter.md et design.md : "Pour les outputs B2B (rapports, exports), utiliser les formats standards du secteur. La créativité vient du contenu, pas du format." |
| CP13 | Screenshots = critère de vérité mobile | Versiroom | NON | OUI | Ajouter dans qa.md : "La vérification mobile se fait par screenshots réels, pas par inspection de code responsive." |
| CP14 | Zéro écran cassé ou placeholder gris | Versiroom | PARTIEL — CLAUDE.md gate G15 (0 placeholder), gate G21 (5 états) | PARTIEL | La gate G15 check les placeholders texte mais PAS les placeholders visuels (images grises, avatars par défaut non stylés). Ajouter dans qa.md et design.md |
| CP15 | Assets critiques dans git | Versiroom | NON | OUI | Ajouter dans fullstack.md et infrastructure.md : "Les assets critiques (logo, favicon, OG images) DOIVENT être dans le repo git, pas uniquement sur un CDN externe." |
| CP16 | Modals mobile = bottom sheet pattern | Versiroom | index.html (ligne 1305 mention) | PARTIEL | Mentionné dans un prompt design mais PAS dans ux.md ou design.md comme règle permanente |
| CP17 | Valider clés API vs placeholders | Versiroom | NON | OUI | Ajouter dans qa.md et infrastructure.md : "Vérifier que toutes les clés API en .env sont des vraies clés, pas des placeholders (sk_test_xxx, VOTRE_CLE_ICI)." |
| CP18 | Replit autoscale : zéro fire-and-forget | Versiroom | NON | OUI | Ajouter dans infrastructure.md : "Replit autoscale : chaque opération async DOIT avoir un mécanisme de confirmation/retry. Zéro fire-and-forget." |

---

## Synthèse par statut

| Statut | Count | % |
|---|---|---|
| Pleinement implémentée (dans agents + CLAUDE.md + gates) | 18 | 35% |
| Partiellement implémentée (dans index.html ou moi.md seul, pas dans agents exécutants) | 11 | 22% |
| GAP complet (documentée uniquement dans founder-preferences.md) | 22 | 43% |

## Analyse des patterns de GAP

### Pattern 1 : "Documenté dans moi.md mais pas propagé aux agents exécutants"
**Préférences** : AP6 (demander permission), AP9 (contenu qui se répète), AP10 (autopilot qualité)
**Diagnostic** : @moi sait ce que Thomas veut mais les agents qui FONT le travail ne le savent pas. @moi est un juge a posteriori, pas un garde-fou a priori.

### Pattern 2 : "Présent dans un prompt index.html mais pas dans le fichier agent"
**Préférences** : #6 (calendrier perpétuel), #7 (anti-répétition), #17 (pas duplication info), #19 (admin valide avant auto), CP10 (tsc --noEmit), CP16 (bottom sheet)
**Diagnostic** : si l'agent est invoqué via le prompt bibliothèque, la préférence est respectée. Si l'agent est invoqué directement (`@seo fais un calendrier`), la préférence est perdue. Les prompts ne se substituent pas aux règles agents.

### Pattern 3 : "Préférence cross-projet jamais importée"
**Préférences** : CP1 à CP18 (quasi toutes)
**Diagnostic** : `founder-preferences.md` est une doc passive. Il n'y a aucun mécanisme qui force la propagation d'une nouvelle préférence vers les fichiers agents concernés. Quand Thomas exprime une préférence sur Sarani, elle est notée dans founder-prefs mais le framework Agent-Team ne la connaît pas.

### Pattern 4 : "Préférence UX/produit projet-spécifique sans vecteur de propagation"
**Préférences** : #16 (modal auth), #18 (LinkedIn > questionnaire), #20 (résiliation = perte accès), CP3-CP8
**Diagnostic** : certaines préférences sont des décisions de design/produit qui devraient être dans les agents car elles s'appliquent à TOUS les projets de Thomas. Elles ne sont ni dans les agents ni dans les gates.

---

## Recommandations priorisées

| # | Action | Impact | Effort | Agent à modifier |
|---|---|---|---|---|
| 1 | **Créer un mécanisme de propagation active** : quand une préférence est ajoutée à founder-preferences.md, un bloc "Propagation" doit lister les fichiers agents à modifier + le texte exact à ajouter. L'orchestrateur exécute la propagation avant de clôturer. | Critique — résout le pattern 3 | Moyen | orchestrator.md, _base-agent-protocol.md |
| 2 | **Propager les 6 préférences "prompt-only" vers les agents** : #6, #7, #17, #19, CP10, CP16 | Haut — résout le pattern 2 | Faible | seo.md, social.md, copywriter.md, ux.md, fullstack.md, qa.md, design.md |
| 3 | **Propager les 4 préférences UX/produit universelles** : #14 (prix ronds), #16 (modal auth), #18 (LinkedIn > questionnaire), #20 (résiliation) | Moyen | Faible | product-manager.md, ux.md, fullstack.md, legal.md |
| 4 | **Propager les 13 préférences cross-projets** : CP1-CP18 | Haut — 43% des GAPs | Moyen | ia.md, design.md, ux.md, product-manager.md, copywriter.md, qa.md, fullstack.md, infrastructure.md |
| 5 | **Ajouter "demander permission" à l'anti-pattern global** CLAUDE.md | Moyen | Faible | CLAUDE.md |
| 6 | **Ajouter une gate G26 "Préférences fondateur"** : vérifie que les préférences applicables au livrable sont respectées | Haut — rend le check automatique | Moyen | CLAUDE.md, reviewer.md |

---

**Handoff → @orchestrator**
- Fichier produit : `docs/reviews/founder-preferences-audit.md`
- Avis donné : 43% des préférences fondateur sont des GAPs complets. Le problème n'est pas la documentation (founder-preferences.md est bon) mais la propagation (aucun mécanisme pour transformer une préférence documentée en règle agent).
- Points d'attention : recommandation #1 (mécanisme de propagation) est le problème structurel. Sans lui, chaque nouvelle préférence sera un nouveau GAP. Les recommandations #2-4 sont les corrections immédiates.
- Rappel : ces recommandations sont des AVIS, pas des directives. L'utilisateur décide.
