# Actions manuelles

## À faire

| Plateforme | Console et chemin | Valeur attendue | Raison | Vérification | Risque |
|---|---|---|---|---|---|
| Toutes | Firebase Console > Authentication > Sign-in method | E-mail, Téléphone et Google activés | Autoriser les méthodes demandées | Tests avec émulateur puis projet réel | Connexion impossible |
| Android | Firebase > Paramètres > Application Android | Package `com.fayfacture.app` et empreintes SHA-1/SHA-256 | Google Auth, téléphone et App Check | OAuth présent dans un nouveau JSON | Google Sign-In échoue |
| iOS | Firebase > Paramètres > Application iOS | Bundle `com.fayfacture.app`, client OAuth et URL scheme | Google Sign-In iOS | `CLIENT_ID` et `REVERSED_CLIENT_ID` présents | Google Sign-In échoue |
| Web | Firebase > Paramètres > Ajouter/Sélectionner application Web | App ID, authDomain, API key, sender ID | Initialiser Firebase Web | État Firebase « prêt » dans l’application | Auth Web indisponible |
| Web | Authentication > Settings > Authorized domains | Domaines de dev/staging/production | OAuth, téléphone et liens profonds | Connexion depuis chaque domaine | Flux bloqués |
| Android | Google Play Console > App integrity | Play Integrity associé | App Check | Requêtes valides dans les métriques | Abus ou blocage après enforcement |
| iOS | Apple Developer/Xcode > Signing & Capabilities | APNs, Push Notifications et Background Modes si requis | FCM | Notification sur appareil réel | Notifications absentes |
| Toutes | Firebase > App Check | Providers enregistrés, enforcement différé | Protection backend | Métriques valides avant enforcement | Clients légitimes bloqués |
| Toutes | Firestore Database / Storage | Instances et localisation validées | Stockage des profils et médias | Tests des règles Emulator Suite | Fuite ou blocage de données |
| Serveur | Firebase > Functions / Google Cloud Billing | Région, plan et secrets validés | Fonctions TypeScript | Test callable et trigger | Déploiement impossible |
| iOS | App Store Connect / décision produit | Option équivalente conforme à la règle 4.8 | Conformité avec Google Login | Revue de conformité avant soumission | Rejet App Store |

## En cours

- Intégration locale des fichiers Firebase Android et iOS.

## Terminé

- Identifiants Android/iOS alignés sur `com.fayfacture.app`.
- Fichiers Firebase natifs ajoutés au projet.

## Bloqué

- Firebase Web : configuration d’application Web non fournie.
- Google OAuth Android/iOS : aucun client OAuth dans les fichiers reçus.
- Build iOS : nécessite macOS et Xcode.
