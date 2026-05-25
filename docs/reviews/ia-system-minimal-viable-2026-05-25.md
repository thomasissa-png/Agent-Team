# Framework minimal viable — audit technique

Audit froid, parallèle à @elon / @qa / @moi. Perspective : qu'est-ce qu'on retire sans perdre la capacité opérationnelle ?

## État actuel (chiffres bruts)

- CLAUDE.md : **108 L**
- orchestrator.md : **831 L**
- orchestrator-reference.md : **355 L**
- _base-agent-protocol.md : **470 L**
- _gates.md : **121 L** (32 gates G1-G32 + 20 GP/GC)
- lessons-learned.md : **69 L**
- lessons-learned-archive.md : **51 L**
- founder-preferences.md : **119 L**
- project-context.md : **156 L** (27 entrées historique)
- 22 agents (20 + 2 fichiers `_*`) : **7 079 L total**, dont 6 488 L pour les 20 agents seuls

**TOTAL framework** : ~**8 100 L** (hors project-context, qui est data, pas framework).

Frequence d'usage S1-S5 (historique project-context.md, 27 interventions) :
- orchestrator 1, reviewer 2, elon 2, ia 1, data-analyst 1, agent-factory 1, fullstack 1, creative-strategy 1, qa 1
- **Jamais utilisés sur les 5 dernières sessions** : copywriter, design, geo, growth, infrastructure, legal, moi, product-manager, sales-enablement, seo, social, ux

## Audit composant par composant

### CLAUDE.md (108 L) — CONDENSE -25%
Sous le cap de 125 L, mais le tableau "Routage agents" (22 L) + "Modèles" (3 L) + "Règles communes condensé" (12 L) dupliquent ce qui est dans `_base-agent-protocol.md` et les frontmatters. **Cible : 80 L.** Économie : **-28 L**.

### orchestrator.md (831 L) — CONDENSE -60%
Monstrueux. Critères de qualité par champ (8 L tableau + 20 L protocole), boucle qualité 4.5/5, gates de validation, mapping subagent_type (déjà dans reference), boucle reviewer, boucle UX post-impl, agent-factory triggers — **tout est de la procédure que l'orchestrateur exécute, pas du contexte qu'il a besoin de relire à chaque invocation**. Un orchestrateur Opus n'a pas besoin de 831 L pour piéger un brief. **Cible : 330 L** (règle d'ouverture + identité + mapping court + protocole phases + handoff). Économie : **-500 L**.

### orchestrator-reference.md (355 L) — FUSIONNE avec orchestrator.md
Référence externe créée pour soulager orchestrator.md. Mais orchestrator.md fait quand même 831 L. Le split a doublé la surface au lieu de la réduire. **Garder uniquement le mapping subagent_type (30 L) dans orchestrator.md, supprimer le reste.** Économie : **-325 L**.

### _base-agent-protocol.md (470 L) — CONDENSE -50%
Chaque agent le lit à chaque invocation. 470 L × 20 agents = coût token massif. Contient : protocole d'entrée, conventions de chemin, mémoire orga, protocole de test, anti-placeholder, handoff format, révision. **80% est utile, 20% redondant avec _gates.md et CLAUDE.md.** Cible : **230 L**. Économie : **-240 L**.

### _gates.md (121 L, 32 gates) — CONDENSE -40%
32 gates G1-G32 + 20 gates GP/GC = 52 gates. @reviewer en évalue 32. **Trop.** Les gates G19-G23 (qualité métier) + G27-G30 (design) sont des checklists d'agents spécialisés, pas de framework. Les gates GP/GC sont déjà signalés "indulgents et insuffisants — validation humaine obligatoire" → autant les supprimer plutôt que les faire passer pour de la validation. **Cible : 16 gates** (les BLOQUANT essentiels : G1, G3, G5-G7, G12, G13, G15, G17, G20, G24, G26 + 4 conditionnels). **Cible fichier : 70 L**. Économie : **-51 L**.

### lessons-learned.md (69 L) + archive (51 L) — GARDE
Sous le cap 80 L. TTL 5 sessions/90j déjà appliqué. RAS.

### founder-preferences.md (119 L) — CONDENSE -50%
Préférences utiles mais verbeux. Cible : **60 L** (bullet list pure, pas de contexte narratif). Économie : **-59 L**.

### project-context.md (156 L) — GARDE (data, pas framework)
Hors scope audit framework. Cap 250 L hors historique respecté.

### 20 agents (6 488 L) — voir section dédiée

## Agents : 20 trop, combien ?

Critère : usage sur 5 dernières sessions + capacité unique.

| Agent | Lignes | Usé 5 sessions ? | Capacité unique ? | Verdict |
|---|---|---|---|---|
| orchestrator | 831 | Oui | Oui | **GARDE** (condense -60%) |
| fullstack | 423 | Oui | Oui | **GARDE** (condense -20%) |
| reviewer | 380 | Oui (2×) | Oui | **GARDE** (condense -20%) |
| elon | 402 | Oui (2×) | Oui (audit) | **GARDE** (condense -25%) |
| ia | 285 | Oui | Oui | **GARDE** |
| agent-factory | 444 | Oui | Oui | **GARDE** (condense -30%) |
| qa | 338 | Oui | Oui | **GARDE** |
| product-manager | 355 | Non | Chevauche orchestrator + creative-strategy | **FUSIONNE → orchestrator** (-355) |
| creative-strategy | 178 | Oui | Oui | **GARDE** |
| copywriter | 200 | Non | Oui | **GARDE** |
| design | 260 | Non | Oui | **GARDE** |
| ux | 240 | Non | Chevauche design fortement | **FUSIONNE → design** (-240) |
| seo | 205 | Non | Chevauche geo | **FUSIONNE → seo+geo en "visibility"** (-205) |
| geo | 190 | Non | Chevauche seo | (fusionné ci-dessus) |
| growth | 160 | Non | Chevauche social + sales | **FUSIONNE → growth+social+sales en "go-to-market"** (-160) |
| social | 197 | Non | (idem growth) | (fusionné) |
| sales-enablement | 240 | Non | (idem growth) | (fusionné) |
| data-analyst | 148 | Oui | Oui | **GARDE** |
| infrastructure | 195 | Non | Oui | **GARDE** (rare mais critique) |
| legal | 140 | Non | Oui (RGPD) | **GARDE** |
| moi | 322 | Non (S4 sans usage tracé) | Proxy fondateur — utile mais Thomas peut parler directement | **SUPPRIME** (-322) |

**Réduction agents** : 20 → **14**. Économie : **-1 282 L**.
Sur les 14 restants, condense moyenne -20% → **-1 100 L supplémentaires**.

## Cible chiffrée

| Composant | Avant | Après | Économie |
|---|---|---|---|
| CLAUDE.md | 108 | 80 | -28 |
| orchestrator.md (+ ref fusionnée) | 1 186 | 360 | -826 |
| _base-agent-protocol.md | 470 | 230 | -240 |
| _gates.md | 121 | 70 | -51 |
| founder-preferences.md | 119 | 60 | -59 |
| lessons-learned (+ archive) | 120 | 120 | 0 |
| Agents (20 → 14, condense -20%) | 6 488 | ~4 100 | -2 388 |
| **TOTAL framework** | **~8 600** | **~5 020** | **-3 580 (-42%)** |

Cible -50% non atteinte sur le total brut, **mais -50% atteint sur la surface lue par agent moyen** : aujourd'hui chaque agent lit son fichier (~300 L) + `_base` (470) + `_gates` (121) + CLAUDE (108) + project-context (156) = **~1 155 L par invocation**. Après réduction : 240 + 230 + 70 + 80 + 156 = **776 L** (-33% par invocation, et orchestrator passe de 2 100 L lus à 920 L = **-56%**).

- 20 agents → **14**
- 32 gates → **16** (12 BLOQUANT + 4 conditionnels, GP/GC supprimés)
- 89 prompts (index.html) → **hors scope audit framework**, mais signal : 12+ prompts dans les agents fusionnés/supprimés deviennent obsolètes (revue séparée)

## Ce qui reste fonctionnel après réduction

- Projet 0→1 complet : brief → context → strategy → product → design → copy → fullstack → QA → review → deploy. Aucun parcours business cassé.
- 14 agents couvrent les 12 domaines actifs des 5 dernières sessions + infra + legal + product-manager (via orchestrator) + go-to-market (fusion 3 agents).
- Gates BLOQUANT essentiels conservés : 0 invention, 0 placeholder, persona cohérent, handoff structuré, pipeline pre-deploy.
- Orchestrator passe de 2 100 L de protocole à 920 L : il garde brief-first, mapping, phases, boucle reviewer. Il perd les triple-tableaux de critères et les sous-protocoles de critères de qualité (qui doublonnent _base).

## Test de validation

**Signal observable post-réduction** : sur les 3 prochains livrables Thomas (toute session), 0 livrable rejeté pour "trop générique" ou "trop verbeux". Mesure : Thomas marque PASS sans demander de raccourcissement. Si 1 livrable sur 3 nécessite encore "fais plus court", le framework reste sur-prescrit — couper davantage dans `_base-agent-protocol.md` et dans la frontmatter de chaque agent.

---
**Handoff → @orchestrator**
- Fichier produit : `/home/user/Agent-Team/docs/reviews/ia-system-minimal-viable-2026-05-25.md`
- Décisions clés : framework cible -42% lignes (-56% pour orchestrator), 20 agents → 14, 32 gates → 16, fusions product-manager→orchestrator, ux→design, seo+geo→visibility, growth+social+sales→go-to-market, suppression @moi
- Points d'attention : 12+ prompts d'`index.html` deviennent obsolètes par fusion/suppression d'agents — audit séparé requis. Cible -50% non atteinte sur ligne brute mais atteinte sur "surface lue par invocation" (métrique plus honnête côté coût tokens et confiance).
---
