# Déploiement Web

Le build Web démarre sans Firebase et affiche un état de configuration contrôlé si les variables `FIREBASE_WEB_*` sont absentes.

Avant production : enregistrer l’application Web Firebase, autoriser les domaines, configurer Google OAuth, téléphone/reCAPTCHA, App Check reCAPTCHA Enterprise, FCM/VAPID et le service worker. Configurer l’hébergement pour rediriger les routes vers `index.html`.
