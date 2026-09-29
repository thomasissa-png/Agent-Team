# Audit technique — @agent-factory

**Auditeur** : @ia
**Date** : 2026-03-22
**Fichier audite** : `.claude/agents/agent-factory.md`
**Méthode** : comparaison structurelle avec 4 agents de référence (@ia, @fullstack, @creative-strategy, @reviewer) + vérification de conformite CLAUDE.md

---

## Note globale : 8.4 / 10

| Critère | Note | Poids |
|---|---|---|
| Qualité du persona | 8 / 10 | 20% |
| Template canonique embarque | 9 / 10 | 25% |
| Prompt engineering | 8.5 / 10 | 25% |
| Robustesse (cas limites) | 8 / 10 | 15% |
| Calibration croisee | 8.5 / 10 | 15% |

---

## Detail par critère

### 1. Qualité du persona — 8 / 10

Le persona est credible : "Architecte de systèmes multi-agents, 10 ans, 50+ agents deployes dans des contextes varies". Les accomplissements sont concrets et le ton est directif ("Son obsession : chaque agent doit être assez bon pour qu'on oublie qu'il est artificiel").

**Points positifs :**
- L'expérience couvre des domaines varies (finance, sante, médias, education, e-commerce), ce qui est cohérent avec la mission de créer des agents dans n'importe quel domaine.
- La phrase finale donne une direction comportementale claire.

**Points a améliorer :**
- Le persona est legerement générique compare a ceux des agents existants. @creative-strategy a "18 ans en agences parisiennes et londoniennes", @fullstack a "contributeur open source shadcn/ui et Expo", @reviewer a "12 en audit de cabinets de conseil". Le persona de @agent-factory manque d'un ancrage similaire (ex: quel framework multi-agents ? quel contexte organisationnel ?).
- Il serait plus credible avec une référence a un cadre methodologique spécifique (ex: "a formalise un framework de création d'agents adopte par X équipes" ou "a standardise la production d'agents dans un contexte enterprise").

### 2. Template canonique embarque — 9 / 10

C'est le point le plus critique de cet agent : le template dans l'Étape 3 est le moule dans lequel tous les futurs agents seront coules.

**Vérification section par section vs agents existants :**

| Section | Present dans le template | Fidele aux agents réels | Commentaire |
|---|---|---|---|
| Frontmatter YAML | Oui | Oui | name, description, model, tools — correct |
| Identité | Oui | Oui | Instructions claires ("3-5 phrases, credible") |
| Domaines de competence | Oui | Oui | Mentionne les sous-sections ### |
| Protocole d'entree | Oui | Oui | Les 5 étapes sont presentes |
| Champs critiques | Oui | Oui | Placeholder correct |
| Calibration obligatoire | Oui | Oui | Instructions génériques mais adaptables |
| Gestion des timeouts | Oui | Oui | 5 règles strictes presentes |
| Protocole d'escalade | Oui | Oui | Règle anti-invention incluse |
| Mode revision | Oui | Oui | 4 étapes standard |
| Auto-evaluation générique | Oui | Oui | 3 questions standard |
| Auto-evaluation spécifique | Oui | **Partiellement** | Le template dit "3-5 questions" mais ne donne que le placeholder `□ [3-5 questions spécifiques]`. Les agents réels ont exactement 3 a 5 questions formulees. Un LLM pourrait produire des questions trop vagues sans exemples. |
| Protocole de fin | Oui | Oui | Format tableau correct |
| Livrables types | Oui | Oui | Placeholder adaptatif |
| Chemin obligatoire | Oui | Oui | `docs/[dossier-agent]/` |
| Handoff | Oui | Oui | Structure complete |

**Section manquante identifiee :**
- Certains agents ont des sections spécifiques a leur domaine qui ne sont pas dans le template canonique. Par exemple, @fullstack a "Conventions obligatoires" (nommage, structure de projet, principes de code) et @reviewer a "Protocole de revue croisee" et "Format du rapport de revue". Le template ne prevoit pas de section libre pour ce type de contenu spécifique au domaine. Il faudrait un placeholder du type `## [Sections spécifiques au domaine]` entre les domaines de competence et le protocole d'entree.

### 3. Prompt engineering — 8.5 / 10

Les instructions sont claires et sequentielles. Le processus en 5 étapes (Recueil du besoin, Vérification anti-doublon, Construction, Integration framework, Validation) est bien structure et non ambigu.

**Points forts :**
- L'Étape 1 pose 6 questions precises avec des exemples concrets entre parentheses. Un LLM sait exactement quoi demander.
- L'Étape 2 (anti-doublon) a une logique de décision claire : chevauchement partiel = 2 options, chevauchement total = stop.
- L'Étape 5 (validation) est une checklist de 15 points couvrant tous les aspects structurels.

**Points a améliorer :**
- L'Étape 4 (integration framework) demande de mettre à jour `CLAUDE.md` et `orchestrator.md`, mais ne donne pas d'exemples de format pour ces mises à jour. L'agent sait QUOI mettre à jour mais pas exactement COMMENT (quel format de ligne dans le tableau de CLAUDE.md, quel format dans le mapping de l'orchestrator). Risque de formats inconsistants.
- Il manque une instruction sur le **nommage** de l'agent : le `name` en kebab-case est mentionne dans la checklist mais pas dans l'Étape 1. L'agent pourrait oublier de demander ou de deriver le nom.

### 4. Robustesse (cas limites) — 8 / 10

**Cas geres :**
- Domaine inconnu : WebSearch pour se calibrer (calibration point 4 + escalade)
- Chevauchement avec agent existant : protocole clair en Étape 2
- Demande hors perimetre : escalade vers l'agent competent
- Modification d'agent existant (vs création) : Mode revision specifie
- Agent trop large : les questions de l'Étape 1 forcent à définir un perimetre précis

**Cas non geres ou insuffisamment geres :**
- **Agent trop niche** : si l'utilisateur demande un agent ultra-specifique qui ne sera utilise qu'une fois, il n'y a pas de garde-fou pour recommander une alternative (ex: enrichir un agent existant avec une section, ou simplement utiliser un prompt system ad hoc au lieu de créer un agent formel).
- **Création en batch** : si on demande de créer 5 agents d'un coup, la section timeout mentionne "un agent par cycle" mais il n'y a pas de stratégie pour prioriser l'ordre de création (quels agents créer en premier ? ceux qui sont amont dans la chaîne).
- **Suppression/deprecation** : l'agent sait créer et modifier, mais pas deprecier ou supprimer un agent existant devenu obsolete après la création d'un nouveau.

### 5. Calibration croisee — 8.5 / 10

**Sources lues avant production :**
1. TOUS les agents existants (Glob + Read) — excellent, c'est le minimum pour détecter les doublons
2. CLAUDE.md — comprendre les conventions globales
3. `docs/orchestration-plan.md` — comprendre le plan en cours
4. WebSearch pour les domaines inconnus
5. `docs/product/functional-specs.md` et `docs/strategy/brand-platform.md` — cohérence stratégie

C'est une calibration solide, superieure a celle de la plupart des agents existants.

**Point a améliorer :**
- Il ne lit pas `docs/ia/ai-architecture.md` ni les choix de modèle existants. Si un projet a déjà des contraintes IA (budget tokens, modèle impose), l'agent-factory pourrait créer un agent avec des tools ou des besoins incompatibles. Ce n'est pas critique mais ce serait une calibration plus complete.

---

## Points forts (3)

1. **Processus en 5 étapes structure et complet.** La sequence Recueil > Anti-doublon > Construction > Integration > Validation est un pipeline robuste qui couvre le cycle de vie complet d'un agent. La checklist de validation en Étape 5 avec 15 points est particulierement utile comme filet de sécurité.

2. **Template canonique très fidele.** Sur 15 sections vérifiées, 14 sont presentes et conformes aux agents réels. C'est le coeur de l'agent et il fonctionne. Un LLM suivant ce template produira un agent structurellement conforme au framework.

3. **Gestion intelligente des doublons.** L'Étape 2 n'est pas un simple "verifie qu'il n'existe pas déjà". Elle propose une décision a 2 branches (enrichir vs créer avec perimetre delimite) qui evite la proliferation d'agents redondants. C'est une décision de design mure.

## Points faibles / Améliorations suggerees (3)

1. **Le template ne prevoit pas de sections spécifiques au domaine.** Les agents réels ont souvent des sections uniques (Conventions obligatoires pour @fullstack, Protocole de revue croisee pour @reviewer, Format du rapport pour @reviewer). Le template devrait inclure un placeholder explicite `## [Sections spécifiques au domaine — adapter selon le rôle]` avec une note indiquant que cette section est le lieu pour les protocoles, formats de livrables, conventions et procedures propres au domaine de l'agent. Sans cela, les agents produits risquent d'être structurellement corrects mais fonctionnellement pauvres.

2. **L'Étape 4 (integration framework) manque de formats concrets.** L'agent sait qu'il doit ajouter une ligne dans le tableau CLAUDE.md et dans le mapping orchestrator, mais sans voir un exemple du format exact, il risque de produire des entrees inconsistantes. Ajouter un mini-template pour chaque mise à jour (ex: `| Type de demande | [nom-agent] | [agents secondaires] |` pour le tableau CLAUDE.md).

3. **Duplication de sections.** Les sections "Gestion des timeouts" et "Protocole d'escalade" apparaissent deux fois dans le fichier : une fois dans le template canonique (Étape 3) et une fois comme règles propres de l'agent-factory. Cela alourdit le fichier (299 lignes) et cree un risque de desynchronisation si l'une est modifiee sans l'autre. Les règles propres devraient être fusionnees avec une référence au template, ou le template devrait être dans un fichier separe.

---

## Verdict

**L'agent est prêt pour la production**, avec des reserves mineures.

Les fondations sont solides : le processus de création est complet, le template canonique est fidele, la détection de doublons est bien pensee, et la calibration croisee est parmi les meilleures du framework. Les 3 améliorations suggerees sont des optimisations qui amelioreraient la qualité des agents produits mais ne bloquent pas l'utilisation immediate.

**Recommandation** : deployer en l'état, puis iterer après les 2-3 premiers agents créés pour valider empiriquement que le template produit des agents de qualité equivalente aux 17 existants. Appliquer l'amélioration 1 (sections spécifiques au domaine) en priorité car c'est la plus impactante sur la qualité des agents générés.

---

**Handoff -> @orchestrator**
- Fichiers produits : `docs/reviews/audit-agent-factory-ia.md`
- Décisions prises : note 8.4/10, verdict GO avec reserves mineures
- Points d'attention : 3 améliorations suggerees (sections domaine dans template, formats concrets pour Étape 4, deduplication des sections). L'amélioration 1 est prioritaire.
