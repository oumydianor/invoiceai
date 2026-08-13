// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'FayFacture';

  @override
  String get foundationTitle => 'Fondation de l’application';

  @override
  String get foundationReady => 'La structure Flutter est prête.';

  @override
  String get firebaseReady => 'Firebase est configuré pour cette plateforme.';

  @override
  String get firebasePending =>
      'La configuration Firebase de cette plateforme reste à terminer.';

  @override
  String environmentLabel(String environment) {
    return 'Environnement : $environment';
  }

  @override
  String get login => 'Connexion';

  @override
  String get register => 'Inscription';

  @override
  String get phoneAuthentication => 'Connexion par téléphone';

  @override
  String get otpVerification => 'Vérification du code';

  @override
  String get forgotPassword => 'Mot de passe oublié';

  @override
  String get emailVerification => 'Vérification de l’adresse e-mail';

  @override
  String get home => 'Accueil';

  @override
  String get profile => 'Profil';

  @override
  String get pageNotFound => 'Page introuvable';

  @override
  String get backToStart => 'Retour au démarrage';

  @override
  String get nextPhaseMessage =>
      'Le comportement de cet écran sera connecté au module d’authentification.';

  @override
  String openPage(String page) {
    return 'Ouvrir $page';
  }
}
