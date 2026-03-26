# Audit de coherence — Integration des learnings Mandataire-Immo

**Date** : 2026-03-26
**Agent** : @ia (audit ponctuel)
**Fichiers audites** :
- `.claude/agents/_base-agent-protocol.md` (lignes 178, 196-215)
- `.claude/agents/orchestrator.md` (lignes 64-66, 216-217, 514-515)
- `index.html` (prompt "Integrer des learnings d'un autre projet")
- `CLAUDE.md` (reference)

---

## 1. Contradictions avec les regles existantes (CLAUDE.md n1-5, n11-12)

**Verdict : OK**

Aucune contradiction detectee.

- **Regle n2 (zero invention)** : le nouveau protocole anti-placeholder est **complementaire**, pas contradictoire. La regle n2 interdit d'inventer des donnees ; le protocole anti-placeholder interdit de laisser des trous non remplis. La passerelle entre les deux est correctement documentee dans `_base-agent-protocol.md` ligne 203 : "Si la donnee reelle n'est pas disponible, convertir en hypothese marquee `[HYPOTHESE : ...]` conformement a la regle anti-invention". C'est coherent.
- **Regle n3 (anti-timeout)** : la verification Grep en fin de livrable ajoute un cout minime en tokens/temps. Pas de risque de timeout.
- **Regle n5 (mindset IA)** : la verification par vrais outputs est alignee — l'IA peut generer un exemple rapidement, ce n'est pas un processus humain lent.
- **Regle n11 (qualite 9/10)** : les nouveaux criteres renforcent cet objectif sans le contredire.

---

## 2. Doublons

**Verdict : PROBLEME MINEUR**

Il existe une **repetition deliberee** (pas un doublon accidentel) des patterns de placeholder a rechercher entre 3 emplacements :

| Emplacement | Patterns listes |
|---|---|
| `_base-agent-protocol.md` ligne 178 (auto-eval) | `[PLACEHOLDER]`, `[A REMPLIR]`, `[TODO]`, `[NOM]`, `[EXEMPLE]`, `[XX]` |
| `_base-agent-protocol.md` ligne 201 (Grep) | `[A REMPLIR`, `[PLACEHOLDER`, `[TODO`, `[NOM`, `[EXEMPLE`, `[XX`, `[VOTRE`, `[INSER`, `[REMPLACER` |
| `orchestrator.md` ligne 216 (VERIFY) | `[A REMPLIR`, `[PLACEHOLDER`, `[TODO`, `[NOM`, `[XX`, `[VOTRE`, `[INSER` |
| `orchestrator.md` ligne 514 (tableau) | `[PLACEHOLDER]`, `[A REMPLIR]`, `[TODO]`, `[NOM]`, `[XX]` |

**Probleme** : les listes de patterns ne sont pas identiques entre les emplacements. Manquent dans certaines listes :
- `orchestrator.md` ligne 216 : manque `[EXEMPLE` et `[REMPLACER`
- `orchestrator.md` ligne 514 : manque `[EXEMPLE]`, `[VOTRE]`, `[INSER]`, `[REMPLACER]`
- `_base-agent-protocol.md` ligne 178 : manque `[VOTRE]`, `[INSER]`, `[REMPLACER]`

**Impact** : faible. La liste la plus exhaustive est dans `_base-agent-protocol.md` ligne 201 (la reference pour le Grep effectif). Les autres sont des rappels. Mais l'incoherence pourrait creer de la confusion.

**Correction recommandee** :
- Uniformiser la liste courte (auto-eval et tableau orchestrateur) sur les 6 patterns les plus courants : `[PLACEHOLDER]`, `[A REMPLIR]`, `[TODO]`, `[NOM]`, `[XX]`, `[VOTRE]`
- Garder la liste longue uniquement dans la section Grep de `_base-agent-protocol.md` (la reference operationnelle)
- Ajouter dans les listes courtes une mention : "(liste complete dans le protocole de fin de livrable)"

---

## 3. Coherence terminologique

**Verdict : OK**

Terminologie coherente a travers les fichiers :
- "placeholder" utilise partout (jamais "a remplir" comme synonyme autonome — toujours `[A REMPLIR]` comme pattern)
- "vrais outputs" utilise dans les 2 fichiers (`_base-agent-protocol.md` et `orchestrator.md`) — pas de variation "resultats reels" ou "outputs concrets"
- "anti-placeholder" utilise comme qualificatif de la verification dans les 2 fichiers
- "double perspective client/prospect" n'apparait que dans `orchestrator.md` (VERIFY), ce qui est correct car c'est une specification de l'orchestrateur, pas une regle generique

---

## 4. Chaine de responsabilite

**Verdict : OK**

La chaine est claire et non contradictoire :

| Verification | Responsable principal | Moment | Reference |
|---|---|---|---|
| Auto-eval anti-placeholder | Agent producteur | Avant livraison | `_base-agent-protocol.md` l.178 |
| Grep anti-placeholder | Agent producteur | Fin de livrable | `_base-agent-protocol.md` l.198-205 |
| Verification vrais outputs | Agent producteur | Fin de livrable | `_base-agent-protocol.md` l.207-213 |
| VERIFY anti-placeholder | Orchestrateur | Apres reception | `orchestrator.md` l.216 |
| VERIFY vrais outputs | Orchestrateur | Apres reception | `orchestrator.md` l.217 |
| Critere n10 (tableau) | Orchestrateur (scoring) | Etape 6 | `orchestrator.md` l.514 |
| Critere n11 (tableau) | Orchestrateur + @ia | Etape 6 | `orchestrator.md` l.515 |

**Observation** : il y a un double controle voulu (agent fait le Grep en sortie, orchestrateur refait en entree). C'est un pattern defense-en-profondeur correct, pas un doublon problematique.

Le critere n11 mentionne "@ia" comme agent a relancer en cas d'echec. C'est correct pour les prompts LLM mais cree une dependance : @ia doit etre invocable en standalone pour tester un prompt meme quand il n'est pas dans la chaine d'orchestration initiale. Ce cas est deja couvert par le fonctionnement standard des agents.

---

## 5. Impact sur les prompts frontend (index.html)

**Verdict : OK AVEC NUANCE**

Le prompt "Integrer des learnings d'un autre projet" (ligne 734) contient un placeholder volontaire :

```
Source des learnings : [COLLE ICI le texte, le lien GitHub, ou le chemin du fichier contenant les learnings]
```

Ce `[COLLE ICI ...]` est **un placeholder d'instruction utilisateur**, pas un placeholder de livrable. Il est destine a etre remplace par l'utilisateur avant envoi. Ce n'est pas une violation de la regle anti-placeholder.

Les autres prompts de `index.html` contiennent egalement des placeholders d'instruction (`[NOM]`, `[SECTEUR]`, `[DIFFERENCE]` dans le prompt de setup). Meme logique : placeholders utilisateur, pas placeholders de livrable.

**Nuance** : la regle anti-placeholder de `_base-agent-protocol.md` concerne les **livrables produits par les agents**, pas les prompts utilisateur. La distinction est implicite mais pourrait beneficier d'une mention explicite. La ligne 205 de `_base-agent-protocol.md` a deja une exception pour `[HYPOTHESE : ...]` et `[PROVISOIRE — ...]`. On pourrait ajouter que les templates de prompts utilisateur sont egalement exclus — mais en pratique, les agents ne Grep-ent pas `index.html` comme un livrable, donc le risque est nul.

---

## 6. Verification supplementaire : la section "qualite des inputs" (orchestrator.md l.64-73)

**Verdict : OK**

Cette section est un ajout de bon sens qui :
- Renforce la regle n1 de CLAUDE.md (contexte obligatoire) sans la contredire
- S'insere logiquement apres la section d'enrichissement du project-context (l.56-62)
- Fournit des signaux concrets de project-context insuffisant — aide operationnelle, pas juste une injonction
- Ne duplique rien d'existant (les regles existantes disaient "verifier les champs critiques" mais ne donnaient pas de criteres qualitatifs sur le contenu des champs)

---

## Score global de coherence

**8.5 / 10**

**Points forts :**
- Integration propre sans contradiction avec les regles existantes
- Chaine de responsabilite claire (agent producteur puis orchestrateur)
- Terminologie coherente entre les fichiers
- Le prompt frontend respecte les nouvelles regles
- La section "qualite des inputs" comble un vrai manque operationnel

**Points a corriger :**
- (-1.0) Listes de patterns placeholder non uniformes entre les 4 emplacements — source potentielle de confusion lors de la maintenance
- (-0.5) Absence de mention explicite que les placeholders d'instruction utilisateur (dans les prompts frontend) sont exclus de la regle anti-placeholder — risque theorique faible mais rigueur incomplete

**Corrections prioritaires :**
1. Uniformiser les listes de patterns : liste longue (9 patterns) dans `_base-agent-protocol.md` l.201, liste courte (6 patterns + renvoi) dans les 3 autres emplacements
2. Ajouter a `_base-agent-protocol.md` l.205 : "Les placeholders d'instruction dans les templates de prompts utilisateur (`index.html`, `templates/`) sont egalement exclus — ils sont destines a etre remplis par l'utilisateur, pas par l'agent."
