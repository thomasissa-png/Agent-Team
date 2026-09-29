# Audit de cohérence — Integration des learnings Mandataire-Immo

**Date** : 2026-03-26
**Agent** : @ia (audit ponctuel)
**Fichiers audites** :
- `.claude/agents/_base-agent-protocol.md` (lignes 178, 196-215)
- `.claude/agents/orchestrator.md` (lignes 64-66, 216-217, 514-515)
- `index.html` (prompt "Integrer des learnings d'un autre projet")
- `CLAUDE.md` (référence)

---

## 1. Contradictions avec les règles existantes (CLAUDE.md n1-5, n11-12)

**Verdict : OK**

Aucune contradiction détectée.

- **Règle n2 (zéro invention)** : le nouveau protocole anti-placeholder est **complementaire**, pas contradictoire. La règle n2 interdit d'inventer des données ; le protocole anti-placeholder interdit de laisser des trous non remplis. La passerelle entre les deux est correctement documentee dans `_base-agent-protocol.md` ligne 203 : "Si la donnée réelle n'est pas disponible, convertir en hypothèse marquee `[Hypothèse : ...]` conformement a la règle anti-invention". C'est cohérent.
- **Règle n3 (anti-timeout)** : la vérification Grep en fin de livrable ajoute un coût minime en tokens/temps. Pas de risque de timeout.
- **Règle n5 (mindset IA)** : la vérification par vrais outputs est alignee — l'IA peut générer un exemple rapidement, ce n'est pas un processus humain lent.
- **Règle n11 (qualité 9/10)** : les nouveaux critères renforcent cet objectif sans le contredire.

---

## 2. Doublons

**Verdict : Problème MINEUR**

Il existe une **répétition deliberee** (pas un doublon accidentel) des patterns de placeholder a rechercher entre 3 emplacements :

| Emplacement | Patterns listes |
|---|---|
| `_base-agent-protocol.md` ligne 178 (auto-eval) | `[PLACEHOLDER]`, `[A REMPLIR]`, `[TODO]`, `[NOM]`, `[EXEMPLE]`, `[XX]` |
| `_base-agent-protocol.md` ligne 201 (Grep) | `[A REMPLIR`, `[PLACEHOLDER`, `[TODO`, `[NOM`, `[EXEMPLE`, `[XX`, `[VOTRE`, `[INSER`, `[REMPLACER` |
| `orchestrator.md` ligne 216 (VERIFY) | `[A REMPLIR`, `[PLACEHOLDER`, `[TODO`, `[NOM`, `[XX`, `[VOTRE`, `[INSER` |
| `orchestrator.md` ligne 514 (tableau) | `[PLACEHOLDER]`, `[A REMPLIR]`, `[TODO]`, `[NOM]`, `[XX]` |

**Problème** : les listes de patterns ne sont pas identiques entre les emplacements. Manquent dans certaines listes :
- `orchestrator.md` ligne 216 : manque `[EXEMPLE` et `[REMPLACER`
- `orchestrator.md` ligne 514 : manque `[EXEMPLE]`, `[VOTRE]`, `[INSER]`, `[REMPLACER]`
- `_base-agent-protocol.md` ligne 178 : manque `[VOTRE]`, `[INSER]`, `[REMPLACER]`

**Impact** : faible. La liste la plus exhaustive est dans `_base-agent-protocol.md` ligne 201 (la référence pour le Grep effectif). Les autres sont des rappels. Mais l'incohérence pourrait créer de la confusion.

**Correction recommandee** :
- Uniformiser la liste courte (auto-eval et tableau orchestrateur) sur les 6 patterns les plus courants : `[PLACEHOLDER]`, `[A REMPLIR]`, `[TODO]`, `[NOM]`, `[XX]`, `[VOTRE]`
- Garder la liste longue uniquement dans la section Grep de `_base-agent-protocol.md` (la référence opérationnelle)
- Ajouter dans les listes courtes une mention : "(liste complete dans le protocole de fin de livrable)"

---

## 3. Cohérence terminologique

**Verdict : OK**

Terminologie cohérente a travers les fichiers :
- "placeholder" utilise partout (jamais "a remplir" comme synonyme autonome — toujours `[A REMPLIR]` comme pattern)
- "vrais outputs" utilise dans les 2 fichiers (`_base-agent-protocol.md` et `orchestrator.md`) — pas de variation "résultats réels" ou "outputs concrets"
- "anti-placeholder" utilise comme qualificatif de la vérification dans les 2 fichiers
- "double perspective client/prospect" n'apparait que dans `orchestrator.md` (VERIFY), ce qui est correct car c'est une specification de l'orchestrateur, pas une règle générique

---

## 4. Chaîne de responsabilite

**Verdict : OK**

La chaîne est claire et non contradictoire :

| Vérification | Responsable principal | Moment | Référence |
|---|---|---|---|
| Auto-eval anti-placeholder | Agent producteur | Avant livraison | `_base-agent-protocol.md` l.178 |
| Grep anti-placeholder | Agent producteur | Fin de livrable | `_base-agent-protocol.md` l.198-205 |
| Vérification vrais outputs | Agent producteur | Fin de livrable | `_base-agent-protocol.md` l.207-213 |
| VERIFY anti-placeholder | Orchestrateur | Après reception | `orchestrator.md` l.216 |
| VERIFY vrais outputs | Orchestrateur | Après reception | `orchestrator.md` l.217 |
| Critère n10 (tableau) | Orchestrateur (scoring) | Étape 6 | `orchestrator.md` l.514 |
| Critère n11 (tableau) | Orchestrateur + @ia | Étape 6 | `orchestrator.md` l.515 |

**Observation** : il y a un double contrôle voulu (agent fait le Grep en sortie, orchestrateur refait en entree). C'est un pattern defense-en-profondeur correct, pas un doublon problematique.

Le critère n11 mentionne "@ia" comme agent a relancer en cas d'échec. C'est correct pour les prompts LLM mais cree une dépendance : @ia doit être invocable en standalone pour tester un prompt même quand il n'est pas dans la chaîne d'orchestration initiale. Ce cas est déjà couvert par le fonctionnement standard des agents.

---

## 5. Impact sur les prompts frontend (index.html)

**Verdict : OK AVEC NUANCE**

Le prompt "Integrer des learnings d'un autre projet" (ligne 734) contient un placeholder volontaire :

```
Source des learnings : [COLLE ICI le texte, le lien GitHub, ou le chemin du fichier contenant les learnings]
```

Ce `[COLLE ICI ...]` est **un placeholder d'instruction utilisateur**, pas un placeholder de livrable. Il est destine a être remplace par l'utilisateur avant envoi. Ce n'est pas une violation de la règle anti-placeholder.

Les autres prompts de `index.html` contiennent egalement des placeholders d'instruction (`[NOM]`, `[SECTEUR]`, `[DIFFERENCE]` dans le prompt de setup). Même logique : placeholders utilisateur, pas placeholders de livrable.

**Nuance** : la règle anti-placeholder de `_base-agent-protocol.md` concerne les **livrables produits par les agents**, pas les prompts utilisateur. La distinction est implicite mais pourrait beneficier d'une mention explicite. La ligne 205 de `_base-agent-protocol.md` a déjà une exception pour `[Hypothèse : ...]` et `[PROVISOIRE — ...]`. On pourrait ajouter que les templates de prompts utilisateur sont egalement exclus — mais en pratique, les agents ne Grep-ent pas `index.html` comme un livrable, donc le risque est nul.

---

## 6. Vérification supplementaire : la section "qualité des inputs" (orchestrator.md l.64-73)

**Verdict : OK**

Cette section est un ajout de bon sens qui :
- Renforce la règle n1 de CLAUDE.md (contexte obligatoire) sans la contredire
- S'insere logiquement après la section d'enrichissement du project-context (l.56-62)
- Fournit des signaux concrets de project-context insuffisant — aide opérationnelle, pas juste une injonction
- Ne duplique rien d'existant (les règles existantes disaient "vérifier les champs critiques" mais ne donnaient pas de critères qualitatifs sur le contenu des champs)

---

## Score global de cohérence

**8.5 / 10**

**Points forts :**
- Integration propre sans contradiction avec les règles existantes
- Chaîne de responsabilite claire (agent producteur puis orchestrateur)
- Terminologie cohérente entre les fichiers
- Le prompt frontend respecte les nouvelles règles
- La section "qualité des inputs" comble un vrai manque opérationnel

**Points à corriger :**
- (-1.0) Listes de patterns placeholder non uniformes entre les 4 emplacements — source potentielle de confusion lors de la maintenance
- (-0.5) Absence de mention explicite que les placeholders d'instruction utilisateur (dans les prompts frontend) sont exclus de la règle anti-placeholder — risque theorique faible mais rigueur incomplete

**Corrections prioritaires :**
1. Uniformiser les listes de patterns : liste longue (9 patterns) dans `_base-agent-protocol.md` l.201, liste courte (6 patterns + renvoi) dans les 3 autres emplacements
2. Ajouter a `_base-agent-protocol.md` l.205 : "Les placeholders d'instruction dans les templates de prompts utilisateur (`index.html`, `templates/`) sont egalement exclus — ils sont destines a être remplis par l'utilisateur, pas par l'agent."
