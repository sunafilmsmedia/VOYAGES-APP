# Voyagess Uribe Labreche 🌍✈️

Application web pour **préparer et documenter tes voyages**.

- 🌍 **Accueil** : une planète interactive + bouton « Préparer un voyage »
- 🗺️ **Choix des pays** : un ou plusieurs pays (voyage multi-pays) → le voyage se crée automatiquement
- 📅 **Dates** de départ/retour avec compte à rebours
- 🗺️ **Régions / villes** à visiter par pays
- ♪ **Collections TikTok** : colle tes liens d'idées
- 📸 **Lieux visités** : import de screenshots + note sur 5 étoiles
- 🖼️ **Albums photos** : liens vers tes dossiers Google Drive

Design : fond blanc, accents **bleu & rose**, thème clair/sombre.

## Utilisation

C'est un site **100 % statique** — un seul fichier [`index.html`](index.html), aucune dépendance, aucun build.

- **En local** : ouvre `index.html` dans ton navigateur (double-clic), ou sers le dossier avec `python3 -m http.server`.
- Les données (voyages, screenshots, liens) sont **sauvegardées dans le navigateur** (IndexedDB). Elles restent sur l'appareil utilisé — pas encore de synchro multi-appareils.

## Déploiement

Aucune configuration requise, `index.html` est à la racine :

- **Vercel** : importer le repo → *Deploy* (framework : « Other »).
- **Netlify** : *Add new site* → *Import from Git* → publier (build command vide, publish dir `.`).
- **GitHub Pages** : *Settings → Pages → Deploy from branch → `main` / root*.

## Feuille de route

- [ ] Carte cliquable pays-par-pays (hors-ligne)
- [ ] Budget / dépenses par voyage
- [ ] Checklist / valise
- [ ] Itinéraire jour par jour
- [ ] Compte + synchro multi-appareils
