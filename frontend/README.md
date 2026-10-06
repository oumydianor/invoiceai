# FayFacture

Prototype Flutter Android, iOS et Web inspiré d’un cahier des charges de facturation intelligente. Il montre comment transformer une description en langage naturel en brouillon de facture, puis organiser les clients, les statuts et les indicateurs d’activité.

Le projet est volontairement original et autonome : les données métier restent en mémoire afin de pouvoir parcourir le code et tester l’interface sans compte, serveur ni clé d’API.

## Parcours de démonstration

- Tableau de bord responsive avec revenus, montants à encaisser, alertes et activité récente.
- Création assistée depuis une phrase en français.
- Vérification et correction du client, des quantités et des prix avant création.
- Liste filtrable des factures et changement de statut vers « Payée ».
- Fiches clients avec coordonnées, nombre de factures et chiffre encaissé.
- Profil entreprise et préférences de notification.
- Navigation adaptée au mobile, à la tablette et au Web.

Exemple à tester dans l’assistant :

> J’ai livré 3 sacs de riz à Aminata Diallo, 15 000 FCFA chacun, plus transport 5 000 FCFA.

Le parseur local extrait le client, une ligne « Sacs de riz » et le transport. Dans une application réelle, le contrat `InvoiceDraftParser` peut être remplacé par un service d’IA côté serveur, sans exposer de clé dans l’application Flutter.

## Organisation utile à étudier

```text
lib/
  app/                         navigation, thème, démarrage et dépendances
  core/                        services et composants transverses
  features/
    invoicing/
      domain/                  modèles Invoice, Client et InvoiceLine
      application/             transformation du texte en brouillon
      presentation/
        state/                 données de démonstration et mutations
        pages/                 dashboard, factures, clients, entreprise
        widgets/               shell responsive et composants partagés
```

La séparation `domain / application / presentation` aide à remplacer progressivement les données locales par Firebase, une API Laravel ou tout autre backend.

## Lancer le projet

Prérequis : Flutter 3.44 ou une version compatible avec Dart 3.12.

```powershell
flutter pub get
flutter gen-l10n
flutter run -t lib/main_development.dart
```

Pour le Web :

```powershell
flutter run -d chrome -t lib/main_development.dart
```

La configuration Firebase Web est facultative pour la démonstration. Les valeurs disponibles sont documentées dans `.env.example` et peuvent être passées avec `--dart-define` lorsque vous connecterez l’authentification.

## Vérifier la qualité

```powershell
dart format --set-exit-if-changed .
flutter analyze
flutter test
flutter build web
```

## Ce qui est simulé

- L’analyse « IA » utilise un parseur déterministe local.
- Les données sont réinitialisées à chaque redémarrage.
- Les boutons PDF, e-mail, logo et ajout de client sont des points d’extension.
- L’authentification Firebase et le profil Firestore ne sont pas encore reliés aux écrans de démonstration.

## Pour aller vers un MVP réel

1. Persister `clients`, `invoices` et `invoice_items` dans Firestore ou dans une API.
2. Appeler le modèle d’IA depuis un backend sécurisé et valider un JSON strict.
3. Générer le PDF côté serveur ou avec un service Dart dédié.
4. Déplacer l’envoi d’e-mail dans une file de tâches backend.
5. Ajouter les règles d’isolation par entreprise, les tests d’intégration et la journalisation.

Consultez aussi [l’architecture](docs/ARCHITECTURE.md), [la configuration Firebase](docs/FIREBASE_SETUP.md) et [les actions manuelles](docs/MANUAL_ACTIONS.md).
