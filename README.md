# Voyages Uribe Labreche 🌍✈️

Application web pour **préparer et documenter tes voyages**.

- 🌍 **Carte du monde 2D** : glisse pour te déplacer, zoome, clique un ou plusieurs pays → le voyage se crée
- 🗺️ **Carte de chaque pays** avec ses villes cliquables (choisies en **dégradé bleu→rose**)
- 📅 **Dates** de départ/retour avec compte à rebours
- ♪ **Collections TikTok** : colle tes liens d'idées
- 📸 **Lieux visités** : import de screenshots + note sur 5 étoiles
- 🖼️ **Albums photos** : liens vers tes dossiers Google Drive
- 👥 **Comptes + espace partagé** (optionnel, via Supabase) : ta copine crée un voyage, tu le vois — en temps réel

Design : fond blanc, accents **bleu & rose**, thème clair/sombre. Un seul fichier [`index.html`](index.html), aucun build.

## Deux modes

| Mode | Où sont les données | Quand |
|------|---------------------|-------|
| **Local** (par défaut) | Dans le navigateur (IndexedDB), par appareil | Si Supabase n'est pas configuré |
| **Cloud** (comptes + partage) | Dans ta base Supabase, partagé dans l'espace | Dès que tu renseignes tes clés Supabase |

Sans configuration, l'app reste 100 % locale — rien ne change.

## Activer les comptes + le partage (Supabase, gratuit)

1. **Crée un projet** sur [supabase.com](https://supabase.com) (gratuit) → *New project*. Note le mot de passe de la base (pas nécessaire pour l'app).
2. **Base de données** : ouvre *SQL Editor → New query*, colle tout le contenu de [`supabase-setup.sql`](supabase-setup.sql), puis *Run*. (Crée les tables, la sécurité et le temps réel.)
3. **Authentification** : *Authentication → Providers → Email* : laisse **Email** activé. Pour une connexion immédiate sans email de confirmation, va dans *Authentication → Sign In / Providers* (ou *Settings*) et **désactive « Confirm email »**.
4. **Clés** : *Project Settings → API*. Copie **Project URL** et la clé **anon public**.
5. **Renseigne l'app** : dans [`index.html`](index.html), cherche `const SUPABASE_URL` (près du haut du `<script>`) et remplis :
   ```js
   const SUPABASE_URL = "https://xxxx.supabase.co";
   const SUPABASE_ANON_KEY = "eyJhbGci...";   // clé anon (publique, OK dans le code)
   ```
6. **Déploie** (voir plus bas). À l'ouverture, l'app demande de se connecter.

### Utilisation à deux
- Toi : crée un compte → **Créer notre espace** → un **code d'invitation** apparaît (menu 👤 en haut).
- Ta copine : crée son compte → **Rejoindre avec un code** → entre ton code.
- À partir de là, **tous les voyages sont partagés** et se mettent à jour en direct chez l'autre.
- Au premier accès connecté, l'app propose d'**importer** les voyages déjà créés en local.

> La clé `anon` est faite pour être publique : l'accès aux données est protégé côté serveur par les règles de sécurité (RLS) installées par le script SQL — on ne voit que les voyages de son propre espace.

## Déploiement

Site 100 % statique, `index.html` à la racine, aucune configuration de build :

- **Vercel** : *Add New Project* → importer le repo → *Deploy* (Framework = « Other »).
- **Netlify** : *Import from Git* → build command vide, publish dir `.`.
- **GitHub Pages** : *Settings → Pages → Deploy from branch → `main` / root*.

> ℹ️ Le mode Cloud fonctionne sur le **site déployé** (ou en ouvrant le fichier en local), mais **pas dans l'aperçu artifact de Claude** (son bac à sable bloque les appels réseau) — l'aperçu reste en mode local.

## Feuille de route

- [ ] Photos stockées dans Supabase Storage (au lieu de base64) pour les gros albums
- [ ] Budget / dépenses par voyage
- [ ] Checklist / valise
- [ ] Itinéraire jour par jour
