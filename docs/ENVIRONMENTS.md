# Environnements

Points d’entrée : `main_development.dart`, `main_staging.dart` et `main_production.dart`.

- Development : logs techniques, Analytics/Crashlytics/App Check désactivés, émulateurs optionnels.
- Staging : télémétrie activée, configuration Firebase dédiée recommandée.
- Production : télémétrie activée, aucun émulateur et aucun secret dans les logs.

`kDebugMode` n’est pas utilisé comme environnement. La sélection peut aussi se faire avec `--dart-define=APP_ENV=development|staging|production`.
