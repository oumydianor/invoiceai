# Authentification

Méthodes prévues : e-mail/mot de passe, téléphone OTP et Google. La fondation ne les présente pas encore comme fonctionnelles.

Principes : aucun mot de passe, OTP ou jeton dans les logs ; erreurs Firebase traduites ; réauthentification avant suppression ; profil synchronisé dans `/users/{uid}` ; navigation pilotée par l’état de session.

La connexion Google nécessite encore les clients OAuth Android/iOS/Web. Sur iOS, la conformité à la règle Apple 4.8 et l’ajout éventuel de Sign in with Apple doivent être validés.
