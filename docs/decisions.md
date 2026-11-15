# Registre des décisions

Ce registre conserve les décisions d'architecture et de périmètre du projet. Une décision ouverte `D-NN` du planning devient une entrée `ADR-NNN` lorsqu'elle est tranchée. Une entrée n'est jamais supprimée : une décision remplacée est marquée « remplacée par ADR-NNN ».

## Format d'une entrée

```text
### ADR-NNN — Titre court
- Date :
- Statut : proposée | acceptée | remplacée par ADR-NNN
- Décideurs :
- Exigences concernées : (identifiants du CDC)
- Contexte :
- Décision :
- Alternatives écartées :
- Conséquences :
- Condition de réexamen : (seuil mesuré ou événement)
```

## Index

| ADR | Titre | Statut | Date |
|---|---|---|---|
| ADR-001 | Analyse des secrets en CI avec gitleaks | proposée | 2026-11-14 |

## Entrées

### ADR-001 — Analyse des secrets en CI avec gitleaks
- Date : 2026-11-14
- Statut : proposée
- Décideurs : développeurs A et B (approbation en revue de PR)
- Exigences concernées : NFR-SEC-03, NFR-QUAL-01
- Contexte : NFR-SEC-03 exige qu'un secret ajouté au dépôt fasse échouer la CI. Le dépôt est public : tout secret commité est immédiatement exposé. Aucun code applicatif n'existe encore, donc seule l'analyse des secrets peut être mise en place ; l'analyse des dépendances viendra avec les premiers manifestes.
- Décision : exécuter gitleaks 8.30.1 (licence MIT, projet maintenu, archive Linux x64 de 8,2 Mo) dans le workflow `secret-scan`, sur les commits de chaque PR vers `main`. Le binaire est téléchargé depuis la publication officielle et vérifié par sa somme SHA-256 épinglée avant exécution. Les secrets détectés sont masqués dans les journaux. Le job `secret-scan` est ajouté aux contrôles obligatoires de `main`.
- Alternatives écartées :
  - Action GitHub tierce de gitleaks : exécute du code externe référencé par une étiquette modifiable, alors que le binaire épinglé par somme de contrôle est vérifiable.
  - trufflehog : licence AGPL-3.0, plus contraignante que MIT pour un dépôt dont la licence reste à choisir (D-07).
  - Analyse native GitHub seule : utile en complément mais ne produit pas de contrôle bloquant propre au dépôt et ne couvre pas les règles ajoutées par l'équipe.
- Conséquences : un faux positif bloque la PR jusqu'à son traitement par une exception ciblée dans le dépôt. La montée de version se fait par PR, avec nouvelle somme SHA-256. Les secrets déjà publiés sur un autre canal ne sont pas détectés.
- Condition de réexamen : nouvelle version corrective de sécurité de gitleaks, faux positif ne pouvant être traité par une exception ciblée, ou passage du dépôt en privé.
