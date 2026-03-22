# Audit @agent-factory -- Rapport de l'orchestrateur

**Date** : 2026-03-22
**Auditeur** : @orchestrator
**Fichier audite** : `.claude/agents/agent-factory.md` (299 lignes)

---

## Note globale : 8.4 / 10

| Critere | Note | Poids |
|---|---|---|
| Conformite structurelle | 8 / 10 | 20% |
| Integration framework | 9 / 10 | 20% |
| Clarte du processus | 9 / 10 | 20% |
| Garde-fous | 8 / 10 | 20% |
| Utilite pour l'orchestrateur | 8 / 10 | 20% |

---

## Detail par critere

### 1. Conformite structurelle -- 8 / 10

**Constats positifs :**
- Le frontmatter YAML est valide : name en kebab-case, description sous 120 caracteres, model claude-opus-4-6, tools listes.
- Toutes les sections canoniques sont presentes : Identite, Domaines de competence, Protocole d'entree, Calibration, Gestion des timeouts, Protocole d'escalade, Mode revision, Auto-evaluation, Protocole de fin, Livrables types, Handoff.
- Le persona est credible avec experience chiffree (10 ans, 50+ agents deployes).

**Points de deduction :**
- **Sections dupliquees.** La section "Gestion des timeouts" apparait deux fois (lignes 115-125 et 221-231) et le "Protocole d'escalade" apparait egalement deux fois (lignes 127-139 et 233-245). Les deux premieres occurrences font partie du template d'agent a generer (Etape 3), mais la separation n'est pas assez claire visuellement. Un lecteur rapide confondra les regles du template avec les regles propres a @agent-factory. C'est un risque de confusion reelle.
- **Pas de chemin `docs/` dedie.** L'agent produit des fichiers dans `.claude/agents/` et modifie `CLAUDE.md` / `orchestrator.md`, mais il n'a pas de dossier de livrables dans `docs/`. Ce n'est pas un defaut en soi (ses livrables sont les agents eux-memes), mais la convention CLAUDE.md ne le documente pas. La ligne "Chemin obligatoire : `docs/[dossier-agent]/`" dans le template de l'Etape 3 (ligne 172) fait reference a l'agent cree, pas a @agent-factory lui-meme -- c'est correct mais pourrait etre explicite.

**Comparaison avec les agents de reference :**
- @creative-strategy, @ia, @fullstack : aucun n'a de section dupliquee. La structure est plate et sans ambiguite.
- @agent-factory a une structure plus complexe car il contient un template dans un template. C'est inherent a sa mission, mais la lisibilite en souffre.

### 2. Integration framework -- 9 / 10

**Constats positifs :**
- Present dans le tableau "Ordre de priorite" de CLAUDE.md (ligne 143) : `Création d'agents spécialisés | agent-factory | ia, orchestrator`. Pertinent.
- Present dans la convention d'appel de CLAUDE.md (ligne 164) : `@agent-factory : création d'agents spécialisés sur mesure pour le projet`.
- Present dans le mapping `subagent_type` de orchestrator.md (ligne 84) : `@agent-factory | agent-factory`.
- Le compteur d'agents dans CLAUDE.md a ete mis a jour de 17 a 18 (lignes 22, 37).

**Point de deduction :**
- **Absent de la convention de chemin des livrables** dans CLAUDE.md (lignes 170-187). Le bloc `docs/` ne liste pas de dossier pour @agent-factory. C'est comprehensible (ses livrables ne vont pas dans `docs/`) mais un commentaire explicite serait utile pour eviter qu'un @reviewer ne flag cette absence comme une erreur. Suggestion : ajouter un commentaire sous le bloc `docs/` : `Note : @agent-factory et @orchestrator ne produisent pas dans docs/ — leurs livrables sont respectivement les fichiers agents (.claude/agents/) et les plans d'orchestration (docs/).`

### 3. Clarte du processus -- 9 / 10

**Constats positifs :**
- Le processus en 5 etapes est logique, complet et sequentiel : Recueil du besoin -> Anti-doublon -> Construction -> Integration -> Validation.
- L'etape 1 (recueil) liste 6 questions precises et couvre le perimetre, les interactions, les outils et le domaine. C'est exactement ce dont j'ai besoin pour savoir quoi transmettre a @agent-factory quand je l'invoque.
- L'etape 2 (anti-doublon) est un garde-fou crucial. Le choix de proposer "enrichir vs creer" est mature.
- L'etape 3 (construction) fournit le template canonique complet. Un agent genere par @agent-factory sera structurellement conforme.
- L'etape 4 (integration) couvre les 3 fichiers a modifier : CLAUDE.md, orchestrator.md, dossier docs/.
- L'etape 5 (validation) est une checklist de 15 points. Exhaustive.

**Point de deduction :**
- **Pas de protocole de test post-creation.** L'etape 5 valide la structure du fichier, mais ne prevoit pas un test fonctionnel minimal (ex : "invoquer l'agent avec un cas simple et verifier qu'il produit un livrable conforme"). La checklist du CLAUDE.md mentionne des tests unitaires et d'integration pour les agents, mais @agent-factory ne recommande pas explicitement de les executer apres creation. Suggestion : ajouter une etape 5b "Test minimal" : invoquer l'agent cree sur un cas simple pour valider qu'il fonctionne.

### 4. Garde-fous -- 8 / 10

**Constats positifs :**
- Anti-doublon : verification systematique avant creation (Etape 2).
- Anti-invention : regle presente deux fois (dans le template et dans les regles propres). WebSearch impose si le domaine est inconnu.
- Anti-timeout : regles presentes et adaptees au cas specifique (ecrire l'agent AVANT les mises a jour CLAUDE.md/orchestrator.md).
- Perimetre clair : l'escalade redirige vers l'agent competent si l'utilisateur demande du code au lieu d'un agent.

**Points de deduction :**
- **Pas de garde-fou sur le nombre d'agents.** Rien n'empeche un utilisateur de demander 10 agents d'un coup. @agent-factory devrait avertir au-dela de 3 agents dans une session (risque timeout + complexite d'integration). Suggestion : "Si la demande concerne plus de 3 agents, les creer un par un avec validation entre chaque."
- **Pas de garde-fou sur la qualite du persona.** L'etape 3 fournit le template mais ne donne pas de critere de qualite pour le persona genere. Un persona comme "Expert en X. 10 ans d'experience." passerait la validation structurelle (etape 5, point "persona credible avec experience chiffree") mais serait trop generique. Suggestion : ajouter dans la checklist de validation un critere de specificite du persona : "Le persona mentionne-t-il des accomplissements concrets et mesurables ?"

### 5. Utilite pour l'orchestrateur -- 8 / 10

**Constats positifs :**
- En tant qu'orchestrateur, je sais exactement quand invoquer @agent-factory : quand le projet necessite un agent qui n'existe pas dans les 17 agents standard.
- Le handoff est clair : vers @orchestrator ou vers l'utilisateur. Les fichiers produits et modifies sont listes.
- L'agent s'insere proprement dans la chaine : je peux l'invoquer via Task avec `subagent_type: "agent-factory"` et un prompt contenant le role, la mission et les interactions souhaitees.

**Points de deduction :**
- **Pas de phase d'insertion dans le plan d'orchestration.** L'orchestrateur a des phases 0-5 bien definies. @agent-factory n'est rattache a aucune phase. Quand dois-je l'invoquer dans un projet 0-to-1 ? Avant la Phase 0 (si le projet necessite des agents specifiques des le depart) ? Pendant n'importe quelle phase (a la demande) ? Les deux ? Suggestion : ajouter dans le fichier agent ou dans orchestrator.md une note sur le moment d'invocation : "Peut etre invoque a tout moment, hors phases. L'orchestrateur l'invoque quand il identifie un besoin non couvert par les agents existants."
- **Pas de guidance sur les interactions amont/aval de l'agent cree.** Quand @agent-factory cree un agent, il specifie ses interactions (Etape 1, question 4), mais il ne valide pas que ces interactions sont coherentes avec les agents existants. Par exemple, si le nouvel agent est cense recevoir un input de @ux mais que @ux ne le sait pas, il y a une rupture de chaine. Suggestion : dans l'Etape 4, ajouter une verification : "Si l'agent a des dependances amont, verifier que les agents amont mentionnent dans leur handoff la possibilite de transmettre a ce nouvel agent."

---

## Points forts (3)

1. **Le processus en 5 etapes est complet et operationnel.** De la collecte du besoin a la validation finale, chaque etape est actionnable et ne laisse pas de zone grise. C'est le coeur de l'agent et il est solide.

2. **La verification anti-doublon (Etape 2) est un mecanisme critique bien concu.** Proposer "enrichir l'existant vs creer un nouveau" est la bonne approche pour eviter la proliferation d'agents aux perimetres chevauchants. C'est le genre de garde-fou qui manque souvent dans les systemes multi-agents.

3. **L'integration framework est quasi complete.** CLAUDE.md, orchestrator.md et le mapping subagent_type sont tous mis a jour. C'est rare qu'un nouvel agent soit aussi bien integre des sa creation.

## Points faibles / Ameliorations suggerees (3)

1. **Sections dupliquees (Gestion des timeouts + Protocole d'escalade).** Le fichier contient ces sections a la fois dans le template de l'Etape 3 (pour les agents generes) et en tant que regles propres a @agent-factory. La separation est insuffisante. **Correction suggeree** : soit supprimer les doublons dans le template en les remplacant par `[Copier la section standard depuis un agent existant]`, soit ajouter un separateur visuel clair (`<!-- Template pour les agents generes -->` ... `<!-- Regles propres a @agent-factory -->`).

2. **Pas de test fonctionnel post-creation.** La checklist de validation (Etape 5) verifie la structure mais pas le comportement. Un agent structurellement conforme peut etre fonctionnellement defaillant. **Correction suggeree** : ajouter une Etape 5b qui recommande un test minimal -- invoquer l'agent sur un cas simple et verifier qu'il lit project-context.md, refuse si champs manquants, et produit un fichier dans le bon dossier.

3. **Absence de dossier livrables dans la convention CLAUDE.md.** Les livrables de @agent-factory sont atypiques (fichiers `.claude/agents/` au lieu de `docs/`). C'est correct mais non documente. **Correction suggeree** : ajouter une note dans la convention de chemin de CLAUDE.md expliquant cette exception.

---

## Verdict

**L'agent est pret pour la production**, avec des reserves mineures.

Les 3 ameliorations suggerees sont de priorite P1 (importantes mais non bloquantes). L'agent peut etre utilise immediatement dans son etat actuel. Les sections dupliquees sont le point le plus genant car elles peuvent induire en erreur lors de la generation d'agents, mais le risque est faible si l'utilisateur de @agent-factory est attentif.

**Recommandation** : appliquer les corrections P1 avant le premier usage en production, puis valider avec un test E2E (creer un agent fictif et verifier la chaine complete : creation -> integration CLAUDE.md/orchestrator.md -> invocation -> production d'un livrable).

---

**Handoff -> @agent-factory** (pour corrections) ou **@reviewer** (pour validation croisee)
- Fichiers produits : `docs/reviews/audit-agent-factory-orchestrator.md`
- Decisions prises : agent valide pour production avec 3 ameliorations P1
- Points d'attention : sections dupliquees a clarifier, test post-creation a ajouter, convention de chemin a documenter
