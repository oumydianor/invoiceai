# Configuration Firebase

Projet existant : `invoiceai-1d7fe`. Identifiant Android/iOS : `com.fayfacture.app`.

## Présent dans le dépôt

- `android/app/google-services.json`
- `ios/Runner/GoogleService-Info.plist`
- plugin Google Services Android 4.4.4

Ces fichiers contiennent des identifiants clients publics, pas des secrets administrateur.

## Web

Créer ou sélectionner l’application Web existante dans Firebase Console, puis fournir les valeurs `FIREBASE_WEB_*` avec `--dart-define`. Ne jamais ajouter de clé de service Admin au client.

## Outils à installer

```powershell
npm install -g firebase-tools
dart pub global activate flutterfire_cli
firebase login
flutterfire configure --project=invoiceai-1d7fe
```

La commande `flutterfire configure` devra sélectionner le projet existant, jamais en créer un nouveau. Revalider les fichiers natifs après son exécution.

## Émulateurs

Activer avec `--dart-define=USE_FIREBASE_EMULATORS=true`. Le host peut être remplacé par `FIREBASE_EMULATOR_HOST`.
