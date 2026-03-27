# Contexte Projet -- MarchesFaciles

> Ce fichier est lu par tous les agents avant toute action.
> Remplis chaque champ. Les champs vides bloquent les agents.
> **ATTENTION** : ce fichier peut contenir des informations strategiques (budget, pricing, concurrents). S'assurer que le repo est **prive** si des donnees confidentielles y sont renseignees.
> Derniere mise a jour : 2026-03-27

---

## Identite
- **Nom du projet** : MarchesFaciles
- **URL (si existante)** : Aucune
- **Secteur** : Marches publics francais (commande publique)
- **Stade** : [x] Idee  [ ] V1  [ ] Production  [ ] Croissance
- **Date de debut** : 2026-03-27

---

## Cible
- **Persona principal** : [A DETERMINER PAR L'EQUIPE -- recherche requise. @creative-strategy doit identifier le segment cible prioritaire parmi les entreprises qui repondent aux appels d'offres publics. Qui souffre le plus ? Qui paierait le plus ? Qui est le plus accessible ?]
- **Probleme principal** : Les TPE/PME francaises perdent des marches publics ou n'y repondent pas du tout, parce que la redaction des memoires techniques et dossiers de reponse est complexe, chronophage (des dizaines d'heures par dossier) et necessite une expertise que la plupart n'ont pas en interne. Beaucoup renoncent a des opportunites de chiffre d'affaires significatif par manque de temps ou de competences redactionnelles.
- **Alternative actuelle** : [A DETERMINER PAR L'EQUIPE -- recherche requise. Que font les entreprises aujourd'hui ? Redaction interne ? Cabinets de conseil en marches publics ? Freelances ? Rien du tout (renonciation) ? Quelle est la repartition ?]
- **Persona secondaire** : [A DETERMINER PAR L'EQUIPE -- y a-t-il un deuxieme segment pertinent ?]

---

## Positionnement
- **Promesse unique** : [A DETERMINER PAR L'EQUIPE -- @creative-strategy doit definir le positionnement apres benchmark concurrentiel et analyse des alternatives existantes]
- **Ton de marque** : [A DETERMINER PAR L'EQUIPE -- @creative-strategy]
- **3 mots qui DEFINISSENT la marque** : [A DETERMINER PAR L'EQUIPE]
- **3 mots qui ne DEFINISSENT PAS la marque** : [A DETERMINER PAR L'EQUIPE]
- **Concurrent principal** : [A DETERMINER PAR L'EQUIPE -- @creative-strategy doit realiser un benchmark concurrentiel complet du marche de l'aide a la reponse aux appels d'offres en France : plateformes, logiciels, cabinets, solutions IA]
- **Notre difference cle vs lui** : [A DETERMINER PAR L'EQUIPE -- apres benchmark]

---

## Objectifs
- **Objectif principal a 6 mois** : Valider le product-market fit et generer les premiers revenus recurrents. Avoir des clients payants qui utilisent la plateforme pour repondre a de vrais appels d'offres.
- **KPI North Star** : [A DETERMINER PAR L'EQUIPE -- @data-analyst et @product-manager doivent choisir la metrique unique qui capture la valeur creee. Candidats possibles : nombre de reponses soumises via la plateforme, MRR, taux de marches gagnes par les utilisateurs]
- **Objectif secondaire** : Construire un pipeline d'acquisition organique (SEO/contenu) qui genere des leads qualifies sans budget pub
- **Ce que le succes ressemble a 12 mois** : [A DETERMINER PAR L'EQUIPE -- quantifier apres validation du pricing et de la taille de marche]

---

## Stack technique
- **Frontend** : [x] Next.js  [ ] React  [ ] Expo/React Native  [ ] Autre :
- **Backend** : Next.js API routes
- **Base de donnees** : PostgreSQL (Replit natif)
- **Authentification** : A definir (NextAuth ou Clerk recommandes par le framework)
- **Hebergement** : Replit
- **Outils IA utilises** : Claude API (Anthropic) pour la generation/assistance redactionnelle. Modele et pipeline exact a definir par @ia.
- **Budget IA mensuel (tokens)** : A definir par @ia apres estimation du volume d'usage
- **Volume d'usage IA prevu** : A estimer -- depend du nombre d'utilisateurs et de la frequence de reponse aux AO
- **Latence IA cible** : Streaming obligatoire pour la generation de texte. Cible <5s pour le premier token.
- **Outils d'analytics** : A recommander par @data-analyst

---

## Modele economique et juridique
- **Modele economique** : [x] SaaS  [ ] E-commerce  [ ] Marketplace  [ ] App mobile  [ ] Site vitrine  [ ] API/produit technique  [ ] Media/contenu  [ ] Open source  [ ] Autre :
- **Pricing** : [A DETERMINER PAR L'EQUIPE -- @product-manager doit definir le modele de pricing apres analyse de la willingness-to-pay du segment cible, du cout de la valeur creee (temps economise, taux de reussite), et du benchmark concurrentiel. Questions ouvertes : freemium ou pas ? Abonnement mensuel ou par appel d'offres ? Paliers ?]
- **Pays de commercialisation** : France
- **Donnees sensibles collectees** : [x] Oui -- type : [ ] Sante  [ ] Finance  [ ] Mineurs  [x] Autre : Donnees commerciales des entreprises (chiffres d'affaires, references, documents de reponse aux AO). Potentiellement des donnees financieres si les bilans sont utilises pour les criteres de selection.
- **Utilisation d'IA generative** : [x] Oui -- usage prevu : Generation assistee de memoires techniques, reformulation, structuration des reponses aux cahiers des charges, analyse des DCE (Dossier de Consultation des Entreprises)

---

## Contraintes
- **Budget mensuel infrastructure** : < 500 euros tout compris (infra + IA + outils)
- **Budget mensuel acquisition** : 0 au lancement -- acquisition organique uniquement
- **Budget analytics** : A recommander (idealement gratuit ou < 20 euros/mois)
- **Timeline de lancement** : V1 operationnelle le plus vite possible. Pas de date butoir mais urgence maximale -- chaque semaine sans produit = semaine sans validation marche.
- **Contraintes legales ou sectorielles** : RGPD (donnees entreprises). Reglementation des marches publics (Code de la commande publique). La plateforme ne doit pas generer de fausses references ou fabriquer des informations factuelles sur l'entreprise -- enjeux juridiques forts (faux en marches publics = sanction penale). @legal doit auditer.
- **Ressources disponibles** : [x] Solo -- fondateur + equipe Gradient Agents (100% IA)

---

## Existant (projets en place uniquement)
- **URL du site actuel** : Aucune
- **Comptes sociaux existants** : Aucun
- **Outils analytics en place** : Aucun
- **Contenu existant** : Aucun
- **Historique SEO** : Aucun (domaine pas encore achete)

---

## Questions ouvertes pour l'equipe

> Ces questions DOIVENT etre resolues par les agents via recherche et analyse, pas par intuition.

1. **Qui est le client exact ?** Quel segment de TPE/PME souffre le plus et paierait le plus pour une solution ? (@creative-strategy -- benchmark + personas)
2. **Quelle est la taille du marche ?** Combien d'entreprises repondent aux AO publics en France ? Quel volume annuel ? (@creative-strategy + @data-analyst -- WebSearch obligatoire)
3. **Qui sont les concurrents ?** Solutions existantes (logiciels, cabinets, IA, templates). Forces/faiblesses. Pricing. (@creative-strategy -- benchmark concurrentiel)
4. **Quel pricing ?** Combien les entreprises paient aujourd'hui pour de l'aide sur les AO ? Quel est le ROI d'une reponse gagnee ? (@product-manager -- analyse willingness-to-pay)
5. **Quel scope V1 ?** Quelles fonctionnalites minimum pour creer de la valeur reelle des la premiere utilisation ? (@product-manager -- specs fonctionnelles)
6. **Quel modele de pricing ?** Abonnement, a l'usage, freemium, hybride ? (@product-manager)
7. **Quels risques juridiques ?** Generation de contenu pour des procedures publiques = risques specifiques. (@legal)
8. **Quel canal d'acquisition prioritaire ?** SEO ? LinkedIn ? Partenariats ? Bouche-a-oreille sectoriel ? (@growth + @seo)

---

## Historique des interventions agents

> Ce tableau est le journal de bord du projet. Chaque agent DOIT le completer apres chaque livrable.
> La colonne "Pourquoi" est obligatoire : elle capture le raisonnement, pas juste la decision.
> Tout agent demarrant une session DOIT lire ce tableau pour comprendre les decisions passees et leur justification.

| Agent | Date | Livrable produit | Decisions cles | Pourquoi / Alternatives ecartees |
|-------|------|-----------------|----------------|----------------------------------|
| elon | 2026-03-27 | docs/briefs/marchesfaciles-brief.md | Brief initial sans pre-conclusions. Probleme et direction documentes, persona/pricing/concurrents laisses ouverts pour que l'equipe fasse ses propres recherches. | Le fondateur veut que l'equipe suive le process standard sans biais. Un brief pre-rempli avec des conclusions orienterait les agents vers la confirmation plutot que la decouverte. |

---

## Performance des agents

> Ce tableau mesure la qualite de chaque intervention. Rempli par l'agent apres livraison, valide/corrige par @reviewer.

| Agent | Date | Livrable | Completude | Coherence | Actionnabilite | Messages | Specificite | Notes |
|-------|------|----------|------------|-----------|----------------|----------|-------------|-------|
| | | | | | | | | |

**Legende (echelle 1-5 alignee avec CLAUDE.md) :**
- **Completude** : 1 (sections manquantes) -> 3 (sections principales couvertes) -> 5 (tout rempli, rien a ajouter)
- **Coherence** : 1 (contredit des livrables existants) -> 3 (pas de contradiction) -> 5 (reference explicitement les livrables amont)
- **Actionnabilite** : 1 (trop vague) -> 3 (implementable avec interpretation) -> 5 (directement implementable, zero ambiguite)
- **Messages** : 1 (silencieux sur les manques) -> 3 (a signale certains manques) -> 5 (a signale tous les manques, hypotheses marquees)
- **Specificite** : 1 (generique) -> 3 (partiellement specifique) -> 5 (100% taille pour ce projet)

---

## Notes libres

**Contexte fondateur** : Thomas, fondateur solo, utilise le framework Gradient Agents (equipe 100% IA). Objectif : valider rapidement si MarchesFaciles peut devenir un business rentable. Budget serre (< 500 euros/mois tout compris). Pas d'equipe humaine. Priorite absolue : vitesse de validation du product-market fit.

**Intention strategique** : les marches publics representent ~200 milliards d'euros/an en France. La majorite des TPE/PME n'y repondent pas ou mal. L'hypothese est qu'une plateforme IA peut democratiser l'acces a la commande publique en rendant la redaction des reponses 10x plus rapide et accessible. Si l'hypothese est vraie, le marche est enorme. Si elle est fausse, on veut le savoir vite.

**Contrainte critique** : la generation IA pour des documents a valeur juridique (reponses aux AO) impose une rigueur absolue sur la veracite des informations generees. Zero hallucination sur les references, les chiffres, les certifications. C'est un differenciateur ET un risque.
