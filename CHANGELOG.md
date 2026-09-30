# Changelog — Gradient Agents Framework

Historique des modifications du framework. Ce fichier est séparé du CLAUDE.md pour garder les instructions opérationnelles courtes et scannable.

---

## 2026-09-30 (S6 suite) : mise à jour directe des 6 projets équipés + 3 derniers cas

Projets mis à jour par la session (clone, update.sh depuis stable, contrôle, commit, push) : ISSA-Capital, Versi, levantine, TradingApp, Sarani, Mandataire-Immo (Marrant et Tempo : pas d'équipe Gradient). Relevé : 2 protocoles levantine modifiés au milieu (ajouts rangés en blocs PROJECT-RULES), 6 agents maison migrés en 5.5, pre-commit maison ISSA et Versi conservés, orchestrator.md résiduel retiré (Sarani, Mandataire-Immo). Cas corrigés dans les scripts :
1. **Règles maison DANS le bloc Gradient de CLAUDE.md** (levantine : 5 lignes, Mandataire-Immo : 1) : update.sh compare aux lignes de toutes les versions de CLAUDE.md d'Agent-Team et sort du bloc celles qui n'y ont jamais figuré, avec alerte ; pas de doublon au passage suivant.
2. **Husky dans un clone neuf** (core.hooksPath pas encore posé) : plus préempté par .githooks.
3. **Sauvegarde auto-ignorée** : `.claude/gradient-backup/.gitignore` (`*`), même sans .gitignore dans le projet.
Tests installeurs : 31 vérifications (S4b règle dans le bloc, S5b Husky clone neuf).

---

## 2026-09-30 (S6 suite) : premier banc d'essai des agents

Banc PulseBoard (`tests/bench/`) : creative-strategy, copywriter et ia lancés sur le projet de test, contrôle automatique `check-bench.sh` (34/34 PASS) + relecture. Qualité : plateforme de marque sourcée et datée (framework justifié, faits / engagements / preuves à produire séparés) ; landing honnête sans tic IA ni faux témoignage, mais H1 générique et document chargé d'annotations ; architecture IA conforme 5.5 (effort explicite, structured outputs, refus, batch + cache chiffrés). Défauts du framework révélés et corrigés :
1. **8 agents sans Grep** (creative-strategy, design, geo, growth, legal, product-manager, social, ux) alors que le protocole exige des vérifications de gates par Grep → ajouté (versions bumpées, cartes du site), template agent-factory, garde de validation.
2. **Format de version des livrables** avec tirets cadratins (contraire à la règle 12) → séparateur `|`.
3. **Projet de test** sur Replit/Clerk/PostHog → Cloudflare D1, Better Auth, Workers, Umami.
4. **ia.md** : le fallback de refus n'est pas accepté en Batch API → relancer les refus hors batch.
Mode d'emploi et historique du banc dans `tests/bench/README.md`, référencé dans le protocole de test du framework.

---

## 2026-09-30 (S6 suite) : filet de sécurité automatique

1. **Tests des installeurs** : `tests/test-installers.sh` rejoue 12 scénarios réels (installation neuve, équipe déjà là, agents maison seuls, ISSA, Husky, hors git, settings invalide, auto-mise à jour, ancienne équipe avec historique git, second passage stable, rollback) : 28 vérifications, ~10 s, branché dans run-all (étape 4/4). Test de mutation : réintroduire l'écrasement de settings.json fait échouer 2 vérifications.
2. **CI + branche stable** : `.github/workflows/validate.yml` lance run-all à chaque push (historique complet) ; sur main, si tout est vert, le commit est promu sur `stable`. install.sh et update.sh utilisent `stable` en priorité (puis main, master) : un commit cassé sur main n'atteint plus les projets.
3. **Version installée** : `.claude/gradient-version` (branche, commit, date) écrit par install et update ; le prompt de reprise compare au dernier commit de `stable` et signale un framework en retard ; carte MAJ : contrôle en 6 points.
4. **Mémoire** : audit TTL de `lessons-learned.md` (70 → 32 lignes : sessions S3 et antérieures archivées, toutes appliquées ou obsolètes) et 5 leçons S6 ajoutées (agents fantômes, mise à jour destructive, test réel, fichiers non installés, site figé).

---

## 2026-09-29 (S6 suite) : zéro perte locale à la mise à jour (retour Versi)

Versi a perdu une règle ajoutée dans copywriter.md et son pipeline QA du pre-commit (script antérieur aux correctifs, mais deux trous subsistaient) :
1. **Agent modifié hors bloc** : n'est plus remplacé. Si la version locale = une version Gradient d'origine + lignes ajoutées à la fin (vérifié par préfixe exact contre l'historique git), ces lignes sont rangées dans un bloc PROJECT-RULES et l'agent est mis à jour. Sinon l'agent est CONSERVÉ, la nouvelle version attend dans `.claude/gradient-backup/pending/`, alerte + compteur. Carte MAJ : contrôle (4b) aucun agent en attente.
2. **Ancien hook Gradient** : reconnu uniquement s'il est identique octet pour octet à une version passée de `.githooks/pre-commit` (historique git), plus d'heuristique « moins de 20 lignes sans npm/tsc » qui aurait écrasé un pipeline comme `sh scripts/qa.sh`. Même règle dans install.sh.
Testé : copywriter (ajout en fin → bloc), design (insertion au milieu → conservé + en attente), pre-commit Versi préservé, vrai ancien hook remplacé, second passage stable.

---

## 2026-09-29 (S6 suite) : autres failles de même famille (install/update chez les clients)

1. **Agents fantômes (grave)** : Claude Code charge `.claude/agents/` récursivement (doc officielle, vérifiée) et, à noms égaux, n'en garde qu'un selon l'ordre du système de fichiers. La sauvegarde `.claude/agents/.backup/` (ancienne copie de chaque agent) et `_deprecated/` pouvaient donc remplacer les vrais agents. Sauvegarde → `.claude/gradient-backup/`, dépréciés → `.claude/deprecated-agents/`, migration automatique de l'existant, signalement de tout doublon en sous-dossier. agent-factory aligné.
2. **Agents Gradient personnalisés écrasés sans prévenir** (et le prompt de migration conseillait d'écrire dans fullstack.md) : bloc `PROJECT-RULES` en fin d'agent recollé à chaque mise à jour ; modification hors bloc détectée par comparaison à l'historique git d'Agent-Team → remplacement avec avertissement et sauvegarde. Documenté (base protocol, agent-factory, prompt de migration, INSTALL). Garde de validation : aucun marqueur seul dans les fichiers Gradient (bug réel trouvé en test : la doc elle-même déclenchait la détection).
3. **Fichiers obsolètes** : liste figée remplacée par l'historique git (retiré seulement si version Gradient d'origine ; un agent maison n'est jamais touché).
4. **Référence morte** : `docs/checklists/favicon-checklist.md` (citée par design, fullstack, qa) n'était jamais installée → déplacée en `.claude/checklists/`, installée et synchronisée.
5. **Scripts sans terminal** : `read` interactifs (install et update) ne plantent plus sous Claude Code ; install n'est plus bloqué par de simples agents maison et oriente vers update.sh si l'équipe est déjà là.
6. **Divers** : alerte si CLAUDE.md contient une ancienne version Gradient sans marqueurs ; sauvegardes ajoutées au .gitignore du projet ; rollback restaure aussi settings.json ; préférences projet : les copies de globales périmées ne l'emportent plus (règle + détection au démarrage de session) ; références au seul repo Agent-Team étiquetées.
Testé bout en bout sur un historique git réel : ancienne équipe (3 passages, stables), rollback, install avec agents maison seuls, install sur équipe existante, + non-régression ISSA, Husky, ancien hook, hors git.

---

## 2026-09-29 (S6 suite) : mise à jour d'équipe non destructive (retour ISSA Capital)

La session de mise à jour d'ISSA a dû empêcher à la main trois casses causées par nos scripts. Corrigé à la source :
1. **settings.json fusionné, plus écrasé** (install.sh + update.sh) : clés du projet conservées (hooks, env…), permissions Gradient ajoutées en union, sauvegarde dans `.claude/agents/.backup/`. Fusion via node, sinon python ; JSON invalide ou outils absents → fichier du projet intact + `.claude/settings.gradient.json` à fusionner.
2. **Hooks** : le garde-fou devient `.githooks/claude-md-guard.sh` (framework) ; `.githooks/pre-commit` n'est remplacé que s'il porte le marqueur `GRADIENT-HOOK` (ou est l'ancien hook Gradient non modifié). `core.hooksPath` n'est plus forcé si Husky, un autre chemin ou `.git/hooks/pre-commit` existe ; le script indique la ligne d'appel à ajouter. Signalement d'un Husky désactivé par une ancienne mise à jour.
3. **Agents maison** : update.sh signale ceux restés sur un modèle obsolète (liste des modèles courants déduite des agents Gradient, sans ID codé en dur).
4. **Régression de ce matin corrigée** : dans un projet client, les agents lisaient seulement les préférences globales ; ils relisent aussi `docs/founder-preferences.md` du projet, prioritaire en cas de conflit (base protocol, CLAUDE.md, prompts reprise et clôture).
5. **Bug set -e** attrapé en test réel : un `[ -d .husky ] && echo` en fin de fonction arrêtait le script avant la fusion de CLAUDE.md. Testé bout en bout : projet type ISSA, Husky, ancien hook Gradient, installation sur projet existant, hors git, fusion sans node, JSON invalide.

---

## 2026-09-29 (S6 suite) : revue complète des 91 prompts (58 modifiés)

Revue par la session principale des 81 prompts restants (10 déjà revus), même grille que les agents.
1. **Bugs de fond** : GEO « interroger ChatGPT via WebSearch » (impossible) → prompts de test exécutés par l'utilisateur (+ veille concurrentielle) ; optimisation des prompts IA à jour 5.5 (prompt caching correctement défini, plus de temperature, plus de « raisonne étape par étape », structured outputs natifs, fine-tuning seulement si les évals le justifient) ; choix de modèles sans noms de mémoire (GPT-4o retiré) ; `ADD COLUMN IF NOT EXISTS` inexistant sur D1/SQLite (migrations versionnées wrangler, aussi dans fullstack.md) ; autorisation vérifiée dans chaque handler, jamais le seul proxy/middleware (CVE-2025-29927) ; sécurité IA (prompt injection, fuite de system prompt) ; plan de lancement sans sollicitation d'upvotes.
2. **Boucle inter-projets réparée** : la clôture de session dans un projet client écrivait les préférences localement et poussait sur le main du projet client (jamais remontées) → `docs/framework-feedback.md` + prompt « Intégrer des learnings » côté Agent-Team ; perf-trend.sh conditionnel (absent des clients) ; agents custom enregistrés hors du bloc Gradient de CLAUDE.md (sinon effacés par update.sh), aussi dans agent-factory.md (v5.1).
3. **Cohérence avec les agents et préférences** : CTAs selon Vitrine/Funnel (5 prompts), self-fetch = appel direct (127.0.0.1 réservé à Replit), `value-proposition.md` inexistant remplacé par brand-platform, prix ronds (plus de price ending), P2 corrigés et non reportés, RICE sans effort humain, reviewer qui ne corrige pas lui-même, audit ciblé en GO/NO-GO binaire, @reviewer (pas @ia) pour la cohérence framework, stack par défaut (Umami, Workers, Queues/KV, VPS en renfort), accessibilité (EAA), facture électronique, Twitter/X → X.
4. **Chiffres** : stats non sourcées retirées ou marquées ordres de grandeur à recaler (conversion, rétention, abandon par champ, tarifs de diffusion, activation +20 %) ; ouvertures d'emails signalées comme faussées par Apple Mail.
5. **Nouveau garde-fou d'exploitation** (monitoring post-launch) : trace OK/ECHEC + alerte pour tout job planifié, tiré de l'incident du site figé 4 mois.

---

## 2026-09-29 (S6 suite) : 8 agents restants, audit système, prompts échantillonnés, stack et accents

1. **8 agents restants** (7 en v5.1, agent-factory au niveau) : infrastructure (Workers + OpenNext, `next-on-pages` déprécié, TTI retiré, quotas non mémorisés, VPS en renfort, Umami), qa (features IA testées avec LLM mocké, lint explicite en CI), reviewer (états UI alignés PM, contrôles IA et écriture), legal (EAA, avis clients, facture électronique, AI Act à vérifier à date, exemption CNIL), data-analyst (Umami par défaut, instrumentation IA), sales-enablement (preuves réelles, règles CNIL prospection B2B), social (stats sourcées, label contenu IA, algorithmes à reconfirmer). Descriptions fullstack/growth/infrastructure ramenées sous 120 caractères (routage automatique).
2. **Trou système corrigé : préférences et bibliothèque absentes des projets clients.** Le protocole lisait `docs/founder-preferences.md` et Greppait `index.html`, deux fichiers jamais installés : les préférences (tirets, stack) étaient ignorées en silence. install.sh et update.sh posent désormais `.claude/founder-preferences.md` et `.claude/prompts-library.html` ; protocoles et CLAUDE.md pointent dessus. Testé bout en bout.
3. **Stack par défaut explicite** (founder-preferences.md, section dédiée) : Cloudflare, Umami, VPS de Thomas en renfort, auth open source. Préférences périmées retirées ou marquées (PostgreSQL Replit obligatoire, testeurs sur tous les angles, NextAuth). Template project-context, agents et prompts alignés (Umami au lieu de GA4/Plausible/Mixpanel, Workers au lieu de Pages).
4. **Écriture client-facing centralisée** dans `_base-agent-protocol.md` (tirets, tics d'écriture IA, zéro témoignage inventé) au lieu de copywriter.md ; marqueurs de collecte honnêtes (`[À MESURER]`, `[À COLLECTER]`…) reconnus comme non-placeholders ; G13 ajouté au minimum des gates de fin de livrable ; brief-first du protocole aligné sur CLAUDE.md (3 puces).
5. **Accents** : plus de 2 000 corrections (project-context, CHANGELOG, docs, site) par dictionnaire de mots sans ambiguïté + tournures « à » + participes après « été ». Nouvelle garde bloquante dans validate-framework (locale UTF-8, exemples volontaires exclus).
6. **Garde JavaScript du site** : la suite passait au vert avec une bibliothèque cassée (backtick dans un prompt, bug réel attrapé pendant cette session). validate-framework parse désormais le JS de index.html.
7. **10 prompts tirés au sort** : 3 au niveau (reporting investisseurs, specs, définir mon projet après stack), 7 corrigés (check-up : contrôles IA/écriture/stack ; parcours : CTAs selon Vitrine/Funnel au lieu de conviction-first universel ; design system : numérotation cassée + anti-look IA ; revue croisée : le reviewer ne corrige plus lui-même ; checklist lancement : Bing + IndexNow + Umami ; monitoring UX : Umami reste l'outil de stats ; reprise : détection d'une équipe non mise à jour). Termes périmés retirés de toute la bibliothèque.
8. **README et INSTALL réécrits** : 19 agents et leurs vrais modèles, installation par scripts, méthode manuelle complète.

---

## 2026-09-29 (S6 suite) : revue qualité post-5.5 de 11 agents

Revue menée par la session principale (pas déléguée), agent par agent. 10 agents en v5.1, creative-strategy jugé au niveau (inchangé).
1. **ia** : contraintes API génération 5.5 (thinking non désactivable, `tool_choice` forcé et prefill = 400, `stop_reason` refusal + fallback, historique append-only), effort explicite (Opus 5.5 par défaut à medium), ordre des leviers coût (caching → batch → effort → routing mesuré), ROI = éclairage pas veto (cmd 5), prompts sobres, embeddings sans nom de version de mémoire.
2. **geo** : baseline impossible via WebSearch → prompts de test exécutés par l'utilisateur ou `[À MESURER]` ; stats non sourcées retirées (80 %, 47 %, +28 %) ; fausse fraîcheur interdite ; crawlers recherche vs entraînement ; tarifs outils non mémorisés.
3. **seo** : garde-fou « scaled content abuse » sur le pipeline automatique, densité de mots-clés retirée, KPI au-delà du clic (AI Overviews), affirmations Bing douteuses retirées (HTTPS, .edu/.gov).
4. **growth** : canaux composés jugés à 90 jours (plus de contradiction avec SEO/GEO), seuils LTV:CAC = arbitrage entre canaux pas GO/NO-GO, tarifs communiqués non mémorisés. **elon** : unit economics = éclairage (cmd 5), projets actifs lus dans le contexte, pas d'anecdote chiffrée inventée. **product-manager** : 19 agents (pas 20), comportement d'échec + critère qualité obligatoires pour les features IA.
5. **fullstack** : Better Auth par défaut (Auth.js en correctifs de sécurité seulement depuis 09/2025), `proxy.ts` (Next.js 16), LLM en streaming + jobs longs en queue, `ctx.waitUntil` sur Workers. **copywriter** : zéro témoignage inventé même anonymisé (pratique trompeuse), liste anti-signature IA. **design** : directions issues du benchmark au lieu de clichés sectoriels, anti-look IA. **ux** : états propres aux features IA, typo glob corrigée.
6. **Commande pre-commit** : `npx next lint` → `npm run lint` (CLAUDE.md, fullstack, protocoles, 3 prompts du site) : `next lint` a été retiré dans Next.js 16. Prompts auth du site : Better Auth, Lucia (abandonné) retiré.

---

## 2026-09-29 (S6 suite) : migration Sonnet 5.5

1. **Migration Sonnet 5.5** : les 12 agents Sonnet (copywriter, creative-strategy, data-analyst, design, geo, growth, legal, product-manager, sales-enablement, seo, social, ux) passent de `claude-sonnet-5` à `claude-sonnet-5-5` (frontmatters v5.0, cartes index.html v5.0, template agent-factory, whitelist, card MAJ). Garde anti-régression : `claude-sonnet-5` nu et `-latest` rejetés. Toute l'équipe (19 agents) sur la génération 5.5, tiering 7 Opus / 12 Sonnet inchangé.
2. **ia.md** : l'exemple d'alias `claude-sonnet-5-latest` (inexistant) remplacé par la règle « ID publié exact, vérifié dans la doc, jamais construit de mémoire ».
3. Installeurs : aucune référence de modèle, rien à changer. Re-testés (install neuf + mise à jour d'une équipe Sonnet 5).

---

## 2026-09-23 (S6) : migration Opus 5.5 + installeurs fiabilisés

1. **Migration Opus 5.5** : les 7 agents Opus (agent-factory, elon, fullstack, ia, infrastructure, qa, reviewer) passent de `claude-opus-5` à `claude-opus-5-5` (frontmatters v5.0, cartes index.html v5.0, carte Orchestration, template agent-factory, whitelist). Garde anti-régression : `claude-opus-5` nu désormais rejeté comme obsolète. Tiering 7 Opus / 12 Sonnet inchangé.
2. **install.sh v3.2.0** (bugs trouvés par test réel) : le sparse checkout omettait `update.sh` et `.githooks`, donc une nouvelle équipe n'avait ni script de mise à jour ni hooks. Ajoutés, avec activation `core.hooksPath`. Comptage corrigé (19 agents, plus 22 : les `_*.md` sont des protocoles) et résumé qui ne liste plus les protocoles comme agents. Chemins sparse ancrés (plus d'avertissements git).
3. **update.sh** : `update.sh` absent de son propre sparse checkout, donc l'auto-mise à jour ne se déclenchait jamais. Corrigé, ce qui a révélé un 2e bug : `cp` écrasait le script pendant que bash le lisait (exit 127), remplacé par un `mv` atomique. Hooks : plus de plantage si le projet n'est pas un repo git. Tests bout en bout : install neuf, mise à jour d'une ancienne équipe (fichiers obsolètes retirés, qa restauré, update.sh remplacé, hooks réactivés), projet hors git.
4. **Site** : les cartes d'installation (nouveau projet, projet existant) passent par `install.sh` au lieu d'un clone manuel qui n'installait que `.claude/agents/` (ni CLAUDE.md, ni settings, ni update.sh, ni hooks). Prompt « Définir mon projet » adapté au modèle vide posé par l'installation. Prompt de migration : rafraîchit update.sh avant de le lancer.

---

## Session du 2026-06-11 (S5) — Cure "trust the model" : 20 agents + protocole réécrits (v3.0), -2 800L

1. **Audit complet 4 agents parallèles** (@reviewer NO-GO cohérence, @ia agents + prompts, @elon stratégique) — rapports dans `docs/reviews/*-2026-06-11.md`. Constat : la cure S4 avait corrigé les sources de vérité mais pas leurs consommateurs (reviewer.md et _base-agent-protocol.md citaient encore "32 gates G1-G32", @moi mort référencé dans 3 agents, ~47 refs de gates supprimées).
2. **Réécriture des 20 agents en version 3.0** (principe : garder le spécifique au projet et les learnings empiriques, couper le savoir générique qu'un LLM moderne possède déjà — tableaux AIDA/Schwartz, personas décoratifs, sections héritées dupliquées). Agents : ~5 700L → ~1 900L (-67%). Orchestrator 749→217L, agent-factory 444→132L, fullstack 423→118L. Zéro learning cross-projets perdu (self-fetch, SQL idempotent, bottom sheet iOS, Pattern A/B, testing honesty, walkthrough, 10 critères Thomas, etc. tous conservés).
3. **_base-agent-protocol.md réécrit** (470→152L) : aligné 9 gates + G_PROOF, REPLIT_ACTIONS retiré, PVU sur _gates.md, chiffres périmés corrigés.
4. **Corrections de comptes partout** : 20 agents (sales-enablement ajouté aux listes modèles CLAUDE.md et project-context = 12 Sonnet), 94 prompts, 9 gates. INSTALL.md 19→20.
5. **"Un fait = un endroit" outillé** : `tests/validate-framework.sh` vérifie la cohérence des comptes contre les SOT (ls agents / _gates.md / index.html) et détecte les références mortes post-cure (@moi, REPLIT_ACTIONS, G1-G32) dans les fichiers actifs. Whitelist modèles corrigée (Opus 4.8 accepté). `validate-context.sh` tolérant aux accents. Suite `run-all.sh` : 0 erreur.
6. **Cure prompts (94→91, même session)** : audit qualité individuel des 94 prompts (rapport `docs/reviews/prompts-quality-audit-fable-2026-06-11.md`, moyenne 7.5/10) puis application — fusions Onboarding (gamifié + optimiser) et Emailing (séquences + automation), suppression du doublon "SEO + GEO combinés", dégraissage du savoir générique (reporting investisseurs, veille, responsive, API, auth), retrait du boilerplate benchmark ×12 (hérité du protocole), prompt moat en verdicts FORT/FAIBLE/ABSENT. Compteurs 91 propagés (meta, sélecteur, card MAJ, orchestrator, project-context) ; check anti-drift rendu dynamique ; whitelist modèles épurée (opus-4-6 retiré — plus aucune vieille version Claude acceptée).
7. **Routage automatique + orchestrator honnête** : plus besoin de taper `@agent` — CLAUDE.md route automatiquement (la session principale délègue via Task, `@agent` = override). `orchestrator.md` reformulé : pas un 20e agent mais le protocole de coordination de la session principale (les sous-agents ne peuvent pas spawner de sous-agents — la fiction du "chef d'orchestre" séparé est levée). "Zéro production directe" assoupli en "délégation par défaut" avec exceptions explicites (éditions transverses, synthèses, git, demande utilisateur). README + INSTALL alignés.
8. **Orchestrator rétrogradé d'agent à protocole** : `orchestrator.md` → `_orchestration-protocol.md` (frontmatter retiré, préfixe `_` comme `_base-agent-protocol.md`) — il n'est plus enregistré comme 20e agent invocable. La session principale EST l'orchestrator (un sous-agent ne peut pas spawner de sous-agents). Roster honnête : **19 agents spécialisés + 1 protocole de coordination**. CLAUDE.md Modèles 8→7 Opus + ligne protocole ; comptes 20→19 propagés (meta/og/hero/cards index.html, README, INSTALL, project-context) ; chemins mis à jour (agent-factory, perf-trend M5, validation, test-scenarios) ; check anti-drift compte 19 (hors `_*`) dynamiquement. La card MAJ ajoute `rm orchestrator.md` (renommé).
9. **Anti tiret cadratin (—)** : le — est une signature d'écriture IA. Retiré du brand-facing d'index.html (titres, méta/og/twitter, sous-titres, cartes install/sessions), reformulé proprement. Règle gravée comme commandement commun (CLAUDE.md n°12) + question d'auto-éval copywriter + préférence fondateur cross-projets : aucun — dans le site, le copy, les emails, les posts et les livrables clients (pas exigé dans les instructions internes). Garde-fou ajouté à `validate-framework.sh` (brand-facing scanné). Bug compteur '99 prompts' corrigé en 91 + check compteur durci.
10. **Migration Sonnet 5** : les 12 agents Sonnet passent de `claude-sonnet-4-6` à `claude-sonnet-5` (frontmatters, cartes index.html, template agent-factory, exemple d'alias ia.md, whitelist validation). Les 7 agents Opus restent sur `claude-opus-4-8` (version courante). CLAUDE.md section Modèles devient la SOT des IDs (Opus 4.8 / Sonnet 5). Garde anti-régression ajouté à `validate-framework.sh` : refuse toute version Claude obsolète (sonnet-4, opus-4-6/7, claude-3) dans les fichiers actifs. Propagation aux autres projets via `update.sh --all`. Cartes du site resynchronisées (versions = .md : 12 Sonnet en v4.0 suite au bump de modèle, 7 Opus en v3.0), tirets longs retirés des champs role/phase/desc des cartes, carte orchestrator reframée en protocole (le site affichait 20 cartes en annonçant 19 agents). Tiering 7 Opus / 12 Sonnet confirmé inchangé : juste par type de tâche, Sonnet 5 rend les agents Sonnet meilleurs sans re-tiering.
11. **Migration Opus 5** : les 7 agents Opus passent de `claude-opus-4-8` à `claude-opus-5` (frontmatters bumpés en v4.0, cartes index.html en v4.0, template agent-factory, whitelist, carte orchestrator, exemple effort ia.md rendu générique). Combinée à Sonnet 5, toute l'équipe (19 agents) tourne sur la génération 5. CLAUDE.md Modèles = SOT (Opus 5 / Sonnet 5). Garde anti-régression étendu : Opus 4.8 rejeté comme obsolète. Tiering 7 Opus / 12 Sonnet inchangé.
12. **update.sh auto-nettoyage** : le script retire maintenant automatiquement les fichiers framework obsolètes (moi.md, orchestrator-reference.md, orchestrator.md renommé en _orchestration-protocol.md) après la copie des agents, au lieu de les laisser en agents fantômes sur les projets clients. Backup préalable conservé (rollback). La card MAJ ne demande plus de rm manuel. Installeurs et sync d'équipe vérifiés : zéro référence de modèle ou de compte périmée.
13. **Décisions** : GP/GC purgées des phases obligatoires (testeurs = optionnels via @agent-factory, conforme décision S4) ; SOT prompts = index.html (91 après cure prompts).

---

## Session du 2026-03-22 — 20 nouveaux prompts (39→59) post-audits de couverture

**Ce qui a été fait :**

1. **Consolidation de 5 audits de couverture** : @elon (6/10), @creative-strategy (5.5/10), @growth (3/10), @product-manager, @design — identification des prompts manquants avec deduplication croisee
2. **20 nouveaux prompts ajoutés** dans `index.html` (39→59 prompts) :
   - Phase 0 (6) : Valider la demande, Proposition de valeur, Messaging matrix, Pricing, Scope MVP, Storytelling
   - Phase 1 (4) : Direction artistique, Identité verbale, Specs interaction composants, Specs responsive
   - Phase 2 (2) : Setup initial projet, Audit handoff design→code
   - Phase 3 (1) : Stratégie de contenu & calendrier editorial
   - Phase 4 (5) : Plan de lancement, Referral, Retention/churn, PLG, PMF
   - Raccourcis (2) : Feedback & roadmap v2, A/B testing
3. **Standard 9/10 applique** : chaque prompt inclut le pattern d'autonomie ("Lis [fichier]. S'il n'existe pas, pose-moi les questions..."), les chemins de livrables explicites, le chainage multi-agents avec handoffs, et les notes anti-timeout quand pertinent
4. **8 prompts dedupliques** : Naming, Unit economics, Scalabilite technique, Sprint planning, Retrospective, Upsell/expansion, Scale 1K-10K, Prototype interactif — fusionnes ou integres dans les prompts existants/nouveaux
5. **Plan d'orchestration** : `docs/orchestration-plan-new-prompts.md` mis à jour avec la liste consolidee, la méthode de deduplication, et les prompts non retenus avec justification

**Décisions de conception :**
- Priorité aux prompts couvrant les phases manquantes du cycle business (retention, monetisation, validation marche) plutôt qu'a la granularite opérationnelle (sprint planning, retrospective)
- Les prompts de scale (1K→10K) et d'expansion revenue integres dans PMF et PLG plutôt qu'isoles
- Le naming reste geerable via le prompt brand-platform existant (ajout optionnel si demande)

---

## Session du 2026-03-22 — Compaction + @elon + audit 9/10

**Ce qui a été fait :**

1. **Compaction des 19 agents** : sections dupliquées (timeouts, escalade, mode révision, auto-éval, protocole de fin) remplacées par références à `CLAUDE.md` et `_base-agent-protocol.md` → ~900 lignes éliminées
2. **Création de @elon** : agent stratégique incarnant Elon Musk — first principles thinking, audit brutal, scoring sur 10, modes Audit/Conseil/Challenge, communication structurée avec @orchestrator
3. **Dashboard HTML** (`index.html`) : ajout de @agent-factory et @elon (17→19 agents)
4. **Auto-évaluations enrichies** : tous les 19 agents ont maintenant 5+ questions spécifiques
5. **Audit final @elon** : 9/10 sur les 10 dimensions (architecture, qualité agents, calibrations, orchestration, erreurs, tests, doc, versioning, cohérence, impact)

**Décisions de conception :**
- @elon est un agent hors-phase, invocable à tout moment pour auditer le framework ou les projets
- @elon peut émettre des verdicts GO/PIVOT/KILL sur les projets et communiquer à @orchestrator
- Le nombre d'agents reste à 19 (18 opérationnels + @elon advisory) — pas d'inflation

---

## Session du 2026-03-22 — Audit Elon Musk initial + implémentation

**Ce qui a été fait :**

1. **Versioning agents** : ajout de `version: "1.0"` dans le frontmatter des 18 agents
2. **Protocole de base centralisé** : création de `_base-agent-protocol.md` — les sections communes ne sont plus dupliquées dans chaque agent
3. **Calibrations croisées corrigées** : @design←user-flows, @qa←design-tokens+WebSearch, @social←growth-strategy, @fullstack←champs critiques enrichis, @creative-strategy←growth, @data-analyst←growth
4. **Personas renforcés** : opinions fortes ajoutées à @copywriter, @seo, @ia, @social, @geo
5. **CLAUDE.md nettoyé** : journal extrait dans CHANGELOG.md, instructions opérationnelles compactées
6. **Infrastructure de test** : projet-test fictif dans `tests/`, scoring automatique post-livrable
7. **Mécanismes de disruption** : mémoire organisationnelle (`docs/lessons-learned.md`), mode autopilot pour l'orchestrateur
8. **Auto-évaluations enrichies** : @copywriter, @ia, @reviewer portés à 5+ questions spécifiques
9. **Exception chemin livrables** : documentée pour @agent-factory et @orchestrator
10. **@agent-factory v2** : déduplication, sections domaine, mini-templates format, test fonctionnel, garde-fous batch/niche/dépréciation

**Décisions de conception :**
- Les agents héritent des règles communes via CLAUDE.md (toujours en contexte) — pas de duplication
- Le `_base-agent-protocol.md` est une référence, pas un agent exécutable
- Versioning par agent permet de figer une version par projet
- Le journal de setup sort du CLAUDE.md pour garder les instructions ≤200 lignes

---

## Session du 2026-03-22 — Ajout de @agent-factory

**Ce qui a été fait :**

1. **Nouvel agent `@agent-factory`** créé dans `.claude/agents/agent-factory.md` — agent capable de créer des agents spécialisés sur mesure pour chaque projet (architecte, directeur podcast, trader, SFX, etc.)

2. **Processus en 5 étapes** intégré dans l'agent :
   - Recueil du besoin (rôle, mission, livrables, interactions, outils, domaine)
   - Vérification anti-doublon (pas de chevauchement avec agents existants)
   - Construction selon le template canonique exact du framework
   - Intégration dans le framework (CLAUDE.md + orchestrator.md)
   - Validation via checklist de conformité (15 points)

3. **Intégrations** : CLAUDE.md mis à jour (tableau priorité, convention d'appel, compteur 18 agents), orchestrator.md mis à jour (mapping subagent_type)

**Décisions de conception :**
- L'agent-factory lit TOUS les agents existants avant de créer (calibration complète) — évite les doublons
- WebSearch obligatoire si le domaine est inconnu — l'agent ne fabrique jamais un expert sur un domaine qu'il ne comprend pas
- Le template canonique est intégré dans le processus de création, pas dans un fichier séparé — évite la désynchronisation
- L'agent-factory peut aussi modifier des agents existants (mode révision) — pas seulement en créer de nouveaux

---

## Session du 2026-03-22 — Enrichissements et audit qualité

**Ce qui a été fait :**

1. **Règle absolue numéro 2 — Zéro invention de données** : ajoutée au CLAUDE.md et aux 18 agents
2. **Enrichissement des agents** (cas d'usage manquants) :
   - @growth : rétention, churn, pricing & packaging, expansion revenue
   - @data-analyst : roadmap CRO, analyse rétention cohortes, attribution
   - @product-manager : recherche utilisateur, pricing, feedback loops
   - @copywriter : help center, knowledge base, changelog
   - @fullstack : API publique RESTful, webhooks, SDK client
3. **Tableau de performance des agents** ajouté au template project-context.md
4. **Audit complet par @ia** — note moyenne 8.47/10. Rapport dans `docs/ia/agent-audit-report.md`
5. **Implémentation des 7 recommandations de l'audit** (P0-1 à P2-7)
6. **Fix installation** : instructions corrigées pour installer `.claude/agents/` à la racine du repo git

**Décisions prises :**
- Enrichir les agents existants plutôt que créer de nouveaux agents (éviter la complexité)
- La règle anti-invention est la plus importante du framework — un livrable incomplet vaut mieux qu'un livrable faux
- Les calibrations croisées sont le levier #1 de cohérence inter-agents

---

## Session du 2026-03-21 — Setup initial du framework Gradient Agents

**Ce qui a été fait :**

1. **18 agents créés** dans `.claude/agents/` — structure homogène (identité, compétences, protocoles, calibration, handoff)
2. **Agents disponibles :** orchestrator, fullstack, qa, design, ux, copywriter, seo, geo, ia, infrastructure, creative-strategy, product-manager, data-analyst, growth, social, reviewer, legal, agent-factory
3. **Template project-context.md** créé dans `templates/`
4. **CLAUDE.md** — instructions globales, conventions, règles

**Décisions de conception :**
- Modèle claude-opus-4-6 pour tous les agents (qualité maximale)
- Orchestrateur limité à 3 sous-agents par message (anti-timeout)
- Convention de chemins stricte (`docs/[agent]/`) vérifiée par @reviewer
- Langue : français pour tout sauf code et termes techniques
