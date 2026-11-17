# Application Flutter

Ce dossier est réservé à l’application terrain Android. Le projet Flutter n’est pas encore initialisé.

Dans `lib/`, placer le routage et le thème dans `app/`, et les composants et services partagés dans `core/`. Regrouper les écrans, ViewModels et dépôts par fonctionnalité dans `features/`. Prévoir une fonctionnalité `sync/` pour la file d’attente, les reprises d’envoi et les conflits.

Les écrans lisent les données de travail depuis SQLite via leurs dépôts. Un rapport créé hors ligne et son opération en attente sont enregistrés dans la même transaction SQLite.

[Retour au dépôt Siyana](../Readme.md)
