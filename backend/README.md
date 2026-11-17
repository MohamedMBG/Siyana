# API Spring Boot

Ce dossier est réservé à l’API REST, aux règles métier et aux migrations PostgreSQL. Le projet Spring Boot n’est pas encore initialisé.

Organiser le code en modules métier sous `src/main/java/ma/siyana/` : `identity`, `assets`, `workorders`, `preventive`, `inventory`, `sync` et `reporting`. Les demandes d’intervention et les ordres de travail restent ensemble dans `workorders`. La synchronisation réutilise les mêmes règles métier que le back-office.

Placer les migrations dans `src/main/resources/db/migration/` et les tests dans `src/test/java/ma/siyana/`.

[Retour au dépôt Siyana](../Readme.md)
