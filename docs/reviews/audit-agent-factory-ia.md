# Audit technique — @agent-factory

**Auditeur** : @ia
**Date** : 2026-03-22
**Fichier audite** : `.claude/agents/agent-factory.md`
**Methode** : comparaison structurelle avec 4 agents de reference (@ia, @fullstack, @creative-strategy, @reviewer) + verification de conformite CLAUDE.md

---

## Note globale : 8.4 / 10

| Critere | Note | Poids |
|---|---|---|
| Qualite du persona | 8 / 10 | 20% |
| Template canonique embarque | 9 / 10 | 25% |
| Prompt engineering | 8.5 / 10 | 25% |
| Robustesse (cas limites) | 8 / 10 | 15% |
| Calibration croisee | 8.5 / 10 | 15% |

---

## Detail par critere

### 1. Qualite du persona — 8 / 10

Le persona est credible : "Architecte de systemes multi-agents, 10 ans, 50+ agents deployes dans des contextes varies". Les accomplissements sont concrets et le ton est directif ("Son obsession : chaque agent doit etre assez bon pour qu'on oublie qu'il est artificiel").

**Points positifs :**
- L'experience couvre des domaines varies (finance, sante, medias, education, e-commerce), ce qui est coherent avec la mission de creer des agents dans n'importe quel domaine.
- La phrase finale donne une direction comportementale claire.

**Points a ameliorer :**
- Le persona est legerement generique compare a ceux des agents existants. @creative-strategy a "18 ans en agences parisiennes et londoniennes", @fullstack a "contributeur open source shadcn/ui et Expo", @reviewer a "12 en audit de cabinets de conseil". Le persona de @agent-factory manque d'un ancrage similaire (ex: quel framework multi-agents ? quel contexte organisationnel ?).
- Il serait plus credible avec une reference a un cadre methodologique specifique (ex: "a formalise un framework de creation d'agents adopte par X equipes" ou "a standardise la production d'agents dans un contexte enterprise").

### 2. Template canonique embarque — 9 / 10

C'est le point le plus critique de cet agent : le template dans l'Etape 3 est le moule dans lequel tous les futurs agents seront coules.

**Verification section par section vs agents existants :**

| Section | Present dans le template | Fidele aux agents reels | Commentaire |
|---|---|---|---|
| Frontmatter YAML | Oui | Oui | name, description, model, tools — correct |
| Identite | Oui | Oui | Instructions claires ("3-5 phrases, credible") |
| Domaines de competence | Oui | Oui | Mentionne les sous-sections ### |
| Protocole d'entree | Oui | Oui | Les 5 etapes sont presentes |
| Champs critiques | Oui | Oui | Placeholder correct |
| Calibration obligatoire | Oui | Oui | Instructions generiques mais adaptables |
| Gestion des timeouts | Oui | Oui | 5 regles strictes presentes |
| Protocole d'escalade | Oui | Oui | Regle anti-invention incluse |
| Mode revision | Oui | Oui | 4 etapes standard |
| Auto-evaluation generique | Oui | Oui | 3 questions standard |
| Auto-evaluation specifique | Oui | **Partiellement** | Le template dit "3-5 questions" mais ne donne que le placeholder `□ [3-5 questions specifiques]`. Les agents reels ont exactement 3 a 5 questions formulees. Un LLM pourrait produire des questions trop vagues sans exemples. |
| Protocole de fin | Oui | Oui | Format tableau correct |
| Livrables types | Oui | Oui | Placeholder adaptatif |
| Chemin obligatoire | Oui | Oui | `docs/[dossier-agent]/` |
| Handoff | Oui | Oui | Structure complete |

**Section manquante identifiee :**
- Certains agents ont des sections specifiques a leur domaine qui ne sont pas dans le template canonique. Par exemple, @fullstack a "Conventions obligatoires" (nommage, structure de projet, principes de code) et @reviewer a "Protocole de revue croisee" et "Format du rapport de revue". Le template ne prevoit pas de section libre pour ce type de contenu specifique au domaine. Il faudrait un placeholder du type `## [Sections specifiques au domaine]` entre les domaines de competence et le protocole d'entree.

### 3. Prompt engineering — 8.5 / 10

Les instructions sont claires et sequentielles. Le processus en 5 etapes (Recueil du besoin, Verification anti-doublon, Construction, Integration framework, Validation) est bien structure et non ambigu.

**Points forts :**
- L'Etape 1 pose 6 questions precises avec des exemples concrets entre parentheses. Un LLM sait exactement quoi demander.
- L'Etape 2 (anti-doublon) a une logique de decision claire : chevauchement partiel = 2 options, chevauchement total = stop.
- L'Etape 5 (validation) est une checklist de 15 points couvrant tous les aspects structurels.

**Points a ameliorer :**
- L'Etape 4 (integration framework) demande de mettre a jour `CLAUDE.md` et `orchestrator.md`, mais ne donne pas d'exemples de format pour ces mises a jour. L'agent sait QUOI mettre a jour mais pas exactement COMMENT (quel format de ligne dans le tableau de CLAUDE.md, quel format dans le mapping de l'orchestrator). Risque de formats inconsistants.
- Il manque une instruction sur le **nommage** de l'agent : le `name` en kebab-case est mentionne dans la checklist mais pas dans l'Etape 1. L'agent pourrait oublier de demander ou de deriver le nom.

### 4. Robustesse (cas limites) — 8 / 10

**Cas geres :**
- Domaine inconnu : WebSearch pour se calibrer (calibration point 4 + escalade)
- Chevauchement avec agent existant : protocole clair en Etape 2
- Demande hors perimetre : escalade vers l'agent competent
- Modification d'agent existant (vs creation) : Mode revision specifie
- Agent trop large : les questions de l'Etape 1 forcent a definir un perimetre precis

**Cas non geres ou insuffisamment geres :**
- **Agent trop niche** : si l'utilisateur demande un agent ultra-specifique qui ne sera utilise qu'une fois, il n'y a pas de garde-fou pour recommander une alternative (ex: enrichir un agent existant avec une section, ou simplement utiliser un prompt system ad hoc au lieu de creer un agent formel).
- **Creation en batch** : si on demande de creer 5 agents d'un coup, la section timeout mentionne "un agent par cycle" mais il n'y a pas de strategie pour prioriser l'ordre de creation (quels agents creer en premier ? ceux qui sont amont dans la chaine).
- **Suppression/deprecation** : l'agent sait creer et modifier, mais pas deprecier ou supprimer un agent existant devenu obsolete apres la creation d'un nouveau.

### 5. Calibration croisee — 8.5 / 10

**Sources lues avant production :**
1. TOUS les agents existants (Glob + Read) — excellent, c'est le minimum pour detecter les doublons
2. CLAUDE.md — comprendre les conventions globales
3. `docs/orchestration-plan.md` — comprendre le plan en cours
4. WebSearch pour les domaines inconnus
5. `docs/product/functional-specs.md` et `docs/strategy/brand-platform.md` — coherence strategie

C'est une calibration solide, superieure a celle de la plupart des agents existants.

**Point a ameliorer :**
- Il ne lit pas `docs/ia/ai-architecture.md` ni les choix de modele existants. Si un projet a deja des contraintes IA (budget tokens, modele impose), l'agent-factory pourrait creer un agent avec des tools ou des besoins incompatibles. Ce n'est pas critique mais ce serait une calibration plus complete.

---

## Points forts (3)

1. **Processus en 5 etapes structure et complet.** La sequence Recueil > Anti-doublon > Construction > Integration > Validation est un pipeline robuste qui couvre le cycle de vie complet d'un agent. La checklist de validation en Etape 5 avec 15 points est particulierement utile comme filet de securite.

2. **Template canonique tres fidele.** Sur 15 sections verifiees, 14 sont presentes et conformes aux agents reels. C'est le coeur de l'agent et il fonctionne. Un LLM suivant ce template produira un agent structurellement conforme au framework.

3. **Gestion intelligente des doublons.** L'Etape 2 n'est pas un simple "verifie qu'il n'existe pas deja". Elle propose une decision a 2 branches (enrichir vs creer avec perimetre delimite) qui evite la proliferation d'agents redondants. C'est une decision de design mure.

## Points faibles / Ameliorations suggerees (3)

1. **Le template ne prevoit pas de sections specifiques au domaine.** Les agents reels ont souvent des sections uniques (Conventions obligatoires pour @fullstack, Protocole de revue croisee pour @reviewer, Format du rapport pour @reviewer). Le template devrait inclure un placeholder explicite `## [Sections specifiques au domaine — adapter selon le role]` avec une note indiquant que cette section est le lieu pour les protocoles, formats de livrables, conventions et procedures propres au domaine de l'agent. Sans cela, les agents produits risquent d'etre structurellement corrects mais fonctionnellement pauvres.

2. **L'Etape 4 (integration framework) manque de formats concrets.** L'agent sait qu'il doit ajouter une ligne dans le tableau CLAUDE.md et dans le mapping orchestrator, mais sans voir un exemple du format exact, il risque de produire des entrees inconsistantes. Ajouter un mini-template pour chaque mise a jour (ex: `| Type de demande | [nom-agent] | [agents secondaires] |` pour le tableau CLAUDE.md).

3. **Duplication de sections.** Les sections "Gestion des timeouts" et "Protocole d'escalade" apparaissent deux fois dans le fichier : une fois dans le template canonique (Etape 3) et une fois comme regles propres de l'agent-factory. Cela alourdit le fichier (299 lignes) et cree un risque de desynchronisation si l'une est modifiee sans l'autre. Les regles propres devraient etre fusionnees avec une reference au template, ou le template devrait etre dans un fichier separe.

---

## Verdict

**L'agent est pret pour la production**, avec des reserves mineures.

Les fondations sont solides : le processus de creation est complet, le template canonique est fidele, la detection de doublons est bien pensee, et la calibration croisee est parmi les meilleures du framework. Les 3 ameliorations suggerees sont des optimisations qui amelioreraient la qualite des agents produits mais ne bloquent pas l'utilisation immediate.

**Recommandation** : deployer en l'etat, puis iterer apres les 2-3 premiers agents crees pour valider empiriquement que le template produit des agents de qualite equivalente aux 17 existants. Appliquer l'amelioration 1 (sections specifiques au domaine) en priorite car c'est la plus impactante sur la qualite des agents generes.

---

**Handoff -> @orchestrator**
- Fichiers produits : `docs/reviews/audit-agent-factory-ia.md`
- Decisions prises : note 8.4/10, verdict GO avec reserves mineures
- Points d'attention : 3 ameliorations suggerees (sections domaine dans template, formats concrets pour Etape 4, deduplication des sections). L'amelioration 1 est prioritaire.
