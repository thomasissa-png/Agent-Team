# Préférences fondateur — Thomas

Ce fichier est la source de vérité pour l'agent @moi. Il est alimenté par TOUS les projets (Gradient Agents, Sarani, Mandataire-Immo, etc.) et accessible cross-projets via l'URL GitHub raw.

**URL d'accès** : `https://raw.githubusercontent.com/thomasissa-png/Agent-Team/main/docs/founder-preferences.md`

---

## Préférences observées

| Date | Projet | Préférence | Contexte |
|---|---|---|---|
| 2026-03-26 | Agent-Team | Préfère NextAuth.js à Clerk — ownership total, gratuit, pas de vendor lock-in. Ne jamais choisir une techno par facilité de dev. | A insisté pour que le prompt Auth dise "ne JAMAIS choisir parce que plus rapide à coder" |
| 2026-03-26 | Agent-Team | Les P2 ne sont PAS optionnels — tout corriger, l'IA a un coût marginal quasi nul. La classification sert à ordonner, pas à filtrer. | A demandé "pourquoi est-ce que je ne voudrais pas corriger P2 ?" |
| 2026-03-26 | Agent-Team | Exige 9/10 minimum sur chaque livrable, pas de compromis. Itère jusqu'à atteindre le seuil. | A dit "@orchestrator je veux 9/10" sur le chemin logique des prompts |
| 2026-03-26 | Agent-Team | Le mode autopilot doit produire le MÊME résultat que les prompts lancés un par un. L'autopilot est un raccourci d'exécution, pas de qualité. | "ce qui m'intéresse c'est la création d'un projet de A à Z en utilisant le meilleur de tous nos agents" |
| 2026-03-26 | Agent-Team | Pas de concept "MVP minimal" — quand on code, on code la V1 complète. La seule raison d'exclure une feature : elle n'apporte pas de valeur au persona. JAMAIS "trop complexe" ou "pas le temps". | "autant coder jusqu'au bout, pas que MVP" |
| 2026-03-26 | Agent-Team | Calendrier éditorial perpétuel avec scheduling automatique illimité — pas de fin de cycle, régénération auto. | A demandé "est-ce qu'on inclut pas un plan éditorial avec scheduling à durée illimitée ?" |
| 2026-03-26 | Agent-Team | Anti-répétition obligatoire — ne jamais écrire deux fois sur le même sujet. Registre des articles publiés. | "est-ce qu'on tient bien compte des articles du passé ?" |
| 2026-03-26 | Agent-Team | Attention aux accents français — un livrable avec des accents manquants est inacceptable. | A demandé "une revue spécifique de tous les accents aussi" |
| 2026-03-26 | Agent-Team | Audit de tous les clics/interactions d'un site — pas juste visuellement, vérifier que chaque élément fait ce qu'il doit faire. | "un audit de tous les clics du site, que tout se passe bien" |
| 2026-03-26 | Agent-Team | PostgreSQL Replit perd ses données — protections de persistance obligatoires (migrate deploy, seed conditionnel, Replit Secrets). | "y a souvent des soucis avec PostgreSQL où il faut faire pas mal d'aller retour" |
| 2026-03-26 | Agent-Team | Veut que la clôture de session capture les learnings pour améliorer l'équipe — problèmes, insistances, requêtes, biais, préférences fondateur. | "résumer les learnings pour les donner à l'orchestrateur pour voir si on peut encore améliorer l'équipe" |
| 2026-03-25 | Agent-Team | Mindset IA obligatoire — pas de sprint-plan, pas de vélocité en jours/homme, parallélisation par défaut, MVP "complet et rapide". | A fait ajouter la règle n°5 dans CLAUDE.md |
| 2026-03-25 | Agent-Team | PostgreSQL Replit obligatoire — pas de Supabase, pas de service externe pour la DB. | Décision de session, Supabase retiré comme option |
| 2026-03-26 | ImmoCrew | Prix ronds obligatoires — pas de charm pricing "en 7" (497/197/97). Cohérence de marque "zero bullshit" prime sur l'optimisation tarifaire. | A refusé le charm pricing, préfère 400/150/100 même si ça augmente le seuil de rentabilité |
| 2026-03-26 | ImmoCrew | Zéro concurrent nommé dans le contenu client — utiliser des catégories génériques. | A fait supprimer toutes les mentions de concurrents par nom sur le site |
| 2026-03-26 | ImmoCrew | Modal popup pour l'auth — pas de page pleine. Header + Footer visibles sur les pages auth. Sophie ne doit jamais perdre ses repères. | A insisté pour un modal au lieu d'une page dédiée |
| 2026-03-26 | ImmoCrew | Pas de duplication d'info — si un champ est rempli à l'inscription, l'onboarding le pré-remplit. Ne jamais redemander une information déjà fournie. | A refusé que l'onboarding redemande prénom/nom |
| 2026-03-26 | ImmoCrew | LinkedIn plutôt que questionnaire long — un lien LinkedIn est plus réaliste qu'un formulaire d'histoire personnelle. | "Sophie ne racontera pas son parcours entre deux visites" |
| 2026-03-26 | ImmoCrew | Admin valide avant automatisation complète — le flow de production reste déclenché manuellement tant que le pipeline n'est pas prouvé. | Auto-produce prêt mais désactivé, validation humaine d'abord |
| 2026-03-26 | ImmoCrew | Résiliation = perte d'accès aux livrables — les livrables sont liés à l'abonnement actif, pas acquis à vie. | Décision business : incentive au maintien de l'abonnement |
| 2026-03-26 | ImmoCrew | Valeurs business centralisées — jamais de prix hardcodé dans 15+ fichiers. Un fichier config unique (pricing.ts). | Changement de prix a nécessité une passe Grep sur tout le code |

---

## Anti-patterns de Thomas (ce qu'il refuse)

1. Choix technique par facilité de dev ("c'est plus rapide avec Clerk")
2. Scope réduit artificiellement ("pour un MVP, limiter à 5 features")
3. P2 traités comme optionnels ("veux-tu corriger les P2 ?")
4. Formulations vides / théâtre ("il est important de noter que...")
5. Accents manquants dans le contenu français
6. Demander permission au lieu de faire ("veux-tu que je..." → juste faire)
7. Vendor lock-in sans justification explicite
8. Incohérence de nommage entre livrables
9. Contenu qui se répète (même sujet, même angle)
10. Autopilot qui produit moins bien que le mode manuel
11. Charm pricing "en 7" (incohérent avec positionnement transparent)
12. Valeurs business hardcodées dans les composants (prix, emails, URLs)
13. Pages auth sans Header/Footer (perte de repères de navigation)
14. Redemander une info déjà fournie (duplication formulaires)

---

## Style de review de Thomas

- Exige des corrections EXACTES (texte à remplacer), pas des observations vagues
- Itère jusqu'à 9/10 — ne valide pas en dessous
- Vérifie la cohérence inter-livrables (Grep cross-fichiers)
- Pose des questions directes quand quelque chose manque
- Fait confiance aux agents mais vérifie les résultats

---

*Dernière mise à jour : 2026-03-26 — Sessions Gradient Agents + ImmoCrew S5*
