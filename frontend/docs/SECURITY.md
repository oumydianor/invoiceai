# Sécurité

- Refus par défaut dans les futures règles Firebase.
- Le client ne pourra pas modifier `uid`, `role`, `status` ni les custom claims.
- Les secrets serveur seront gérés avec Firebase Secrets ou Google Cloud Secret Manager.
- Les journaux excluent mots de passe, OTP, jetons OAuth/FCM et données personnelles sensibles.
- App Check sera activé progressivement après observation des métriques.

Les règles et leurs tests Emulator Suite seront ajoutés pendant la phase Sécurité.
