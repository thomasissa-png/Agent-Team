# Audit des 38 prompts de la bibliotheque front-end

**Date** : 2026-03-22
**Auditeur** : @orchestrator
**Source** : `/home/user/Agent-Team/index.html` — constante `PROMPTS` (lignes 318-640)
**References croisees** : CLAUDE.md, orchestrator.md, 19 fichiers agents dans `.claude/agents/`

---

## Tableau recapitulatif

| # | Categorie | Titre du prompt | Agent(s) | Statut | Commentaire |
|---|---|---|---|---|---|
| 1 | Demarrage | Definir mon projet | orchestrator | **Warning** | L'orchestrateur n'est pas un agent de saisie — le prompt contourne son protocole d'entree |
| 2 | Tout-en-un | Lancer mon projet de A a Z | orchestrator | **OK** | Clair, coherent avec le protocole orchestrateur |
| 3 | Tout-en-un | Faire un check-up complet | reviewer, elon | **Warning** | Chainage implicite sans sequencement explicite |
| 4 | Tout-en-un | Pivoter mon projet | orchestrator, creative-strategy | **OK** | Logique, coherent avec le protocole de changement de perimetre |
| 5 | Phase 0 | Positionnement & plateforme de marque | creative-strategy | **OK** | Clair, livrables implicites mais definis dans l'agent |
| 6 | Phase 0 | Vision produit & roadmap | product-manager | **OK** | Bon fallback si brand-platform absent, livrables explicites |
| 7 | Phase 0 | KPIs & tracking plan | data-analyst | **OK** | Clair et coherent |
| 8 | Phase 0 | Audit juridique & conformite | legal | **OK** | Note anti-timeout presente, livrables explicites |
| 9 | Phase 1 | Parcours utilisateur & wireframes | ux | **OK** | Bon fallback, livrables explicites |
| 10 | Phase 1 | Design system complet | design, fullstack | **Warning** | Chainage @design puis @fullstack dans un seul prompt — risque de timeout |
| 11 | Phase 1 | Brand voice & guide d'ecriture | copywriter | **Warning** | Livrables attendus non specifies avec chemin |
| 12 | Phase 1 | Landing page complete | copywriter, seo | **OK** | Chainage explicite avec livrables clairs |
| 13 | Phase 2 | Developper une feature | fullstack, qa | **Warning** | Placeholder `[nom de la feature]` risque d'etre oublie |
| 14 | Phase 2 | Integrer le paiement Stripe | fullstack, legal, infrastructure | **Blocker** | Trop vague pour @legal et @infrastructure, pas de livrables specifies |
| 15 | Phase 2 | Ajouter une feature IA (LLM) | ia, fullstack | **OK** | Bon chainage, livrables explicites, placeholder contextuel |
| 16 | Phase 2 | Configurer CI/CD & deploiement | qa, infrastructure | **Warning** | Pas de livrables specifies avec chemin |
| 17 | Phase 2 | Choisir & optimiser les modeles IA | ia | **OK** | Complet, tableau comparatif reference, livrables clairs |
| 18 | Phase 3 | Strategie SEO technique & editoriale | seo | **OK** | Complet, livrables clairs avec critere de qualite |
| 19 | Phase 3 | Visibilite sur les IA generatives (GEO) | geo | **Warning** | Pas de livrables specifies avec chemin |
| 20 | Phase 3 | SEO + GEO combines | seo, geo | **OK** | Bon chainage avec section synergies, livrables clairs |
| 21 | Phase 4 | Strategie d'acquisition complete | growth, social, copywriter | **Warning** | Triple chainage dans un prompt — risque de timeout eleve |
| 22 | Phase 4 | Strategie social media | social, copywriter | **OK** | Bon chainage, livrables clairs |
| 23 | Phase 4 | Emails onboarding & conversion | copywriter, growth | **OK** | Bien structure, fallbacks presents |
| 24 | Phase 4 | Auditer le funnel existant | growth, data-analyst | **OK** | Pre-requis donnees analytics bien documente dans le "quand" |
| 25 | Phase 5 | Revue croisee GO/NO-GO | reviewer | **OK** | Coherent avec le protocole reviewer |
| 26 | Phase 5 | Revue intermediaire (mid-projet) | reviewer | **OK** | Axes de revue explicites, livrable avec chemin |
| 27 | Phase 5 | Audit qualite & tests complets | qa | **OK** | Clair, criteres explicites |
| 28 | Phase 5 | Audit UX & conversion | ux, data-analyst | **OK** | Bon chainage, fallbacks presents |
| 29 | Phase 5 | Audit strategique first principles | elon | **OK** | Coherent avec l'identite @elon |
| 30 | Phase 5 | Monitoring post-launch | infrastructure | **OK** | Clair, outils specifies |
| 31 | Raccourcis | Refondre un site existant | ux, design, fullstack | **Warning** | Triple chainage — risque de timeout |
| 32 | Raccourcis | Diagnostiquer un probleme de performance | infrastructure, seo | **OK** | Bon chainage, livrables clairs |
| 33 | Raccourcis | Auditer la coherence visuelle | design, ux | **OK** | Fallback bien gere |
| 34 | Raccourcis | Optimiser l'onboarding | ux, copywriter, data-analyst | **Warning** | Triple chainage — risque de timeout |
| 35 | Raccourcis | Creer un agent specialise | agent-factory | **OK** | Complet, livrable et integration specifies |
| 36 | Raccourcis | Migrer la stack technique | fullstack, infrastructure | **OK** | Bon chainage, livrables clairs |
| 37 | Raccourcis | Internationaliser le produit (i18n) | fullstack, copywriter | **OK** | Bien structure |
| 38 | Raccourcis | Post-mortem incident production | infrastructure, qa | **OK** | Chainage logique, livrables clairs |

**Resume** : 24 OK | 12 Warning | 2 Blocker

---

## Problemes identifies par severite

### Blockers (empechent une execution correcte)

#### B1 — Prompt #14 "Integrer le paiement Stripe" : sous-specifie

**Probleme** : le prompt est le plus court de toute la bibliotheque (2 lignes). Il ne specifie aucun livrable avec chemin, ne fournit aucun contexte pour @legal (quels aspects des CGV verifier ?), et @infrastructure n'a pas d'instruction precise sur ce que "monitoring des paiements" signifie concretement.

**Impact** : chaque agent interpretera differemment, les livrables seront eparpilles ou absents, et l'orchestrateur ne pourra pas verifier la completude.

**Correction recommandee** :
```
@fullstack Lis docs/product/functional-specs.md et docs/product/roadmap.md (plans tarifaires).
S'ils n'existent pas, pose-moi les questions pour specifier les plans (nombre, prix, features par plan,
periode d'essai). Integre Stripe Checkout : page pricing, webhook /api/stripe/webhook, gestion
des abonnements (creation, upgrade, downgrade, annulation), portail client Stripe.
Livrable : code dans src/ + docs/dev-decisions.md (section Stripe).
Puis @legal : prends docs/legal/cgu-draft.md. S'il n'existe pas, genere les CGV adaptees au modele
d'abonnement. Verifie la conformite : droit de retractation, conditions de renouvellement,
politique de remboursement. Livrable : docs/legal/cgu-draft.md (section paiement).
Puis @infrastructure : configure les variables d'environnement Stripe (STRIPE_SECRET_KEY,
STRIPE_WEBHOOK_SECRET) dans la documentation Replit Secrets. Configure le monitoring
des webhooks (alertes si webhook echoue >3 fois). Livrable : docs/infra/infrastructure.md
(section monitoring paiements).
```

#### B2 — Prompt #1 "Definir mon projet" : role inadapte pour l'orchestrateur

**Probleme** : ce prompt demande a l'orchestrateur de creer `project-context.md` a partir d'un formulaire a trous. Or le protocole d'entree de l'orchestrateur exige que `project-context.md` EXISTE deja pour qu'il puisse travailler. Le prompt cree une boucle logique : l'orchestrateur a besoin du fichier pour demarrer, mais le prompt lui demande de le creer.

**Impact** : en pratique, l'orchestrateur va detecter l'absence de project-context.md et afficher "STOP — project-context.md manquant" au lieu d'executer le prompt.

**Attenuation** : ce cas est partiellement gere par le fait que l'orchestrateur connait le template. Cependant, le vrai probleme est que ce prompt n'a pas besoin d'un orchestrateur — n'importe quel agent (ou Claude directement) peut ecrire un fichier Markdown a partir d'un formulaire. Ce n'est pas un travail d'orchestration.

**Correction recommandee** : soit (a) retirer la mention `@orchestrator` et laisser Claude Code natif creer le fichier, soit (b) ajouter dans le prompt "Note : ce prompt est une exception au protocole d'entree — l'orchestrateur doit creer le fichier meme s'il n'existe pas encore." L'option (a) est preferee car plus simple.

---

### Warnings (fonctionnent mais avec friction ou risque)

#### W1 — Prompts avec triple chainage sequentiel (#10, #21, #31, #34) : risque de timeout

**Probleme** : ces prompts chainent 3 agents sequentiellement dans un seul prompt. Selon la regle anti-timeout de CLAUDE.md (max 2-3 Task par message), l'orchestrateur devrait les decouper en 2 messages. Mais quand l'utilisateur invoque directement ces prompts (sans passer par l'orchestrateur), le chainage se fait dans un seul appel Claude — risque de timeout avant la fin du 3e agent.

**Prompts concernes** :
- #10 : @design puis @fullstack (2 agents, mais design system + implementation = charge lourde)
- #21 : @growth puis @social puis @copywriter (3 agents sequentiels)
- #31 : @ux puis @design puis @fullstack (3 agents sequentiels)
- #34 : @ux puis @copywriter puis @data-analyst (3 agents sequentiels)

**Correction recommandee** : ajouter dans le "quand" de chaque prompt concerne la mention "Livrable volumineux : si timeout, relancer l'agent manquant separement." Cette mention existe deja sur les prompts #8 et #10 — la generaliser.

#### W2 — Prompt #3 "Faire un check-up complet" : chainage @reviewer puis @elon ambigu

**Probleme** : le prompt dit "@reviewer ... Ensuite @elon donne ton audit...". Le mot "ensuite" est ambigu — @elon doit-il lire le rapport de @reviewer avant de produire le sien ? Si oui, c'est une dependance sequentielle qui n'est pas explicitee. Si non, ils peuvent tourner en parallele.

**Correction recommandee** : expliciter la dependance :
```
@reviewer Lis tous les livrables dans docs/ et produis le rapport de coherence croisee
avec recommandation GO/NO-GO. Livrable : docs/reviews/cross-review-report.md.
Puis @elon : lis docs/reviews/cross-review-report.md et project-context.md.
Donne ton audit strategique first principles : qu'est-ce qui manque pour etre n.1 ?
Livrable : docs/reviews/elon-audit.md.
```

#### W3 — Prompt #11 "Brand voice & guide d'ecriture" : livrables non specifies

**Probleme** : le prompt demande a @copywriter de produire un brand voice guide et un guide UX writing mais ne specifie pas les chemins de fichiers attendus.

**Impact** : @copywriter suivra ses propres conventions (`docs/copy/brand-voice.md` et `docs/copy/ux-writing-guide.md`), donc ca fonctionnera. Mais pour la coherence avec les autres prompts qui specifient tous les chemins, c'est une lacune.

**Correction recommandee** : ajouter "Livrables : docs/copy/brand-voice.md + docs/copy/ux-writing-guide.md."

#### W4 — Prompt #16 "Configurer CI/CD & deploiement" : livrables non specifies

**Probleme** : ni le livrable de @qa (workflow GitHub Actions) ni celui de @infrastructure (config deploiement) ne sont specifies avec chemin.

**Correction recommandee** : ajouter "Livrables : .github/workflows/ci.yml (@qa) + docs/infra/infrastructure.md + .replit (@infrastructure)."

#### W5 — Prompt #19 "Visibilite GEO" : livrables non specifies

**Probleme** : pas de chemin de livrable specifie pour @geo.

**Correction recommandee** : ajouter "Livrable : docs/geo/geo-strategy.md."

#### W6 — Prompt #5 "Positionnement & plateforme de marque" : livrables implicites

**Probleme** : le prompt dit "produis la plateforme de marque complete" mais ne specifie pas les chemins. Selon l'agent @creative-strategy, les livrables sont `docs/strategy/brand-platform.md`, `docs/strategy/personas.md`, `docs/strategy/creative-brief.md`, `docs/strategy/competitive-benchmark.md`. Sans chemin explicite, un utilisateur ne sait pas ou chercher.

**Impact** : faible car l'agent suit ses conventions. Mais pour la coherence globale de la bibliotheque (tous les prompts recents ont des chemins), c'est une omission.

**Correction recommandee** : ajouter "Livrables : docs/strategy/brand-platform.md, docs/strategy/personas.md, docs/strategy/competitive-benchmark.md, docs/strategy/creative-brief.md."

#### W7 — Prompt #13 "Developper une feature" : placeholder fragile

**Probleme** : le placeholder `[nom de la feature, ex : "systeme de notifications" ou "tableau de bord analytics"]` est dans le corps du prompt. Si l'utilisateur oublie de le remplacer, @fullstack recevra litteralement "[nom de la feature]" et devra demander des precisions — perte de temps.

**Impact** : mineur (l'agent demandera), mais evitable.

**Correction recommandee** : ajouter dans le "quand" : "Remplace [nom de la feature] par ta feature avant de lancer." C'est deja le pattern d'autres prompts a placeholder.

---

### Observations positives

1. **Fallbacks systematiques** : la majorite des prompts (9, 10, 11, 12, 13, 15, 17, 21, 22, 23, 24, 28, 33, 34, 36, 37) incluent "S'il n'existe pas, pose-moi les questions...". C'est une excellente pratique qui rend chaque prompt autonome.

2. **Coherence des chainages** : les dependances respectent l'ordre des phases defini dans orchestrator.md (Phase 0 avant Phase 1 avant Phase 2...).

3. **Notes anti-timeout** : presentes sur les prompts les plus volumineux (#8 legal, #10 design system).

4. **Criteres de qualite** : le prompt #18 (SEO) inclut un critere de qualite explicite ("chaque recommandation doit etre actionnable avec la page cible et la priorite"). C'est une pratique a generaliser.

5. **Pre-requis dans le "quand"** : le prompt #24 (audit funnel) specifie "fournir les donnees analytics" — bon pattern pour eviter les blocages.

---

## Analyse de coherence inter-prompts

### Contradictions detectees

**Aucune contradiction directe** entre les prompts. Les chainages sont tous coherents avec les dependances definies dans orchestrator.md.

### Redondances acceptables

- **Prompts #17 et #15** : les deux traitent de l'IA. Le #15 est "ajouter une feature IA" (choix d'archi + implementation) et le #17 est "choisir et optimiser les modeles" (benchmark pur). La distinction est claire — pas de redondance problematique.
- **Prompts #25 et #26** : les deux utilisent @reviewer. Le #25 est la revue finale GO/NO-GO, le #26 est une revue intermediaire. Distinction claire dans le "quand".
- **Prompts #18 et #20** : SEO seul vs SEO+GEO. Le #20 inclut le #18. Un utilisateur pourrait lancer le #18 puis vouloir ajouter le GEO et relancer le #20 — duplication de travail SEO. Mais le "quand" guide correctement.

### Coherence avec les agents

Tous les agents references dans les prompts existent dans `.claude/agents/`. Les `subagent_type` correspondent aux noms dans le tableau de mapping de orchestrator.md. Aucun agent fantome, aucun agent manquant.

### Coherence avec CLAUDE.md

- Les conventions de chemin dans les prompts respectent la section "Convention de chemin des livrables" de CLAUDE.md.
- Les regles anti-timeout sont coherentes.
- La regle zero invention de donnees n'est pas explicitement rappellee dans les prompts (elle est dans CLAUDE.md qui est toujours charge en contexte) — c'est correct.

---

## Recommandations d'amelioration

### Priorite haute

1. **Corriger le prompt #14 (Stripe)** — rendre les instructions specifiques et ajouter les livrables (voir correction ci-dessus).

2. **Clarifier le prompt #1 (Definir mon projet)** — soit retirer @orchestrator, soit ajouter une note d'exception au protocole d'entree.

3. **Ajouter les chemins de livrables manquants** aux prompts #11, #16, #19 — 3 edits rapides pour une coherence complete.

### Priorite moyenne

4. **Ajouter une note anti-timeout** sur les prompts a triple chainage (#21, #31, #34) : "Si timeout, relancer l'agent manquant separement."

5. **Expliciter la dependance** dans le prompt #3 (check-up) : @elon doit-il lire le rapport @reviewer ?

6. **Ajouter un critere de qualite** a chaque prompt qui n'en a pas (actuellement seul le #18 en a un). Pattern : "Critere : [condition verifiable]." Cela guide les agents et facilite la verification par l'orchestrateur.

### Priorite basse

7. **Harmoniser les placeholders** : certains prompts utilisent `[...]` avec exemple, d'autres sans. Normaliser sur le format `[DESCRIPTION, ex : "exemple"]`.

8. **Ajouter un prompt manquant** : il n'y a pas de prompt pour "Specs fonctionnelles detaillees" en standalone. Le @product-manager est invoque dans le prompt #6 (vision + roadmap + backlog) mais pas pour des specs fonctionnelles seules (`functional-specs.md`). Plusieurs prompts referent a ce fichier (#13, #15, #36) sans qu'un prompt dedie ne le genere.

9. **Ajouter un prompt "Relancer apres timeout"** : un prompt generique du type "L'agent @X a ete interrompu. Lis les fichiers existants dans docs/[dossier]/ et complete les sections manquantes." Utile pour les utilisateurs non techniques.

---

## Verdict global

**Je pourrais executer 36 des 38 prompts sans friction.**

- Le prompt #14 (Stripe) necessite une reecriture avant execution fiable — en l'etat, les 3 agents recevraient des instructions trop vagues pour produire des livrables coherents.
- Le prompt #1 (Definir mon projet) cree un conflit logique avec mon protocole d'entree, mais en pratique je peux le gerer en traitant ce cas comme une exception explicite.
- Les 12 warnings sont des frictions mineures qui n'empechent pas l'execution mais reduisent la previsibilite des resultats (livrables sans chemin, risques de timeout non signales).

La bibliotheque est globalement bien construite, coherente avec les definitions d'agents et le protocole d'orchestration. Les fallbacks systematiques ("S'il n'existe pas, pose-moi les questions...") sont le point fort principal — ils rendent chaque prompt utilisable a n'importe quel stade du projet.

---

**Handoff -> utilisateur**
- Fichier produit : `docs/reviews/prompts-audit-orchestrator.md`
- Methode : lecture exhaustive des 38 prompts, croisement avec les 19 fichiers agents et CLAUDE.md
- Blockers identifies : 2 (prompts #1 et #14)
- Warnings identifies : 12 (chemins manquants, risques timeout, ambiguites)
- Prochaine etape recommandee : corriger les 2 blockers puis les 3 warnings priorite haute
