// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'FayFacture';

  @override
  String get foundationTitle => 'Application foundation';

  @override
  String get foundationReady => 'The Flutter structure is ready.';

  @override
  String get firebaseReady => 'Firebase is configured for this platform.';

  @override
  String get firebasePending =>
      'Firebase configuration for this platform still needs to be completed.';

  @override
  String environmentLabel(String environment) {
    return 'Environment: $environment';
  }

  @override
  String get login => 'Sign in';

  @override
  String get register => 'Register';

  @override
  String get phoneAuthentication => 'Phone authentication';

  @override
  String get otpVerification => 'Code verification';

  @override
  String get forgotPassword => 'Forgot password';

  @override
  String get emailVerification => 'Email verification';

  @override
  String get home => 'Home';

  @override
  String get profile => 'Profile';

  @override
  String get pageNotFound => 'Page not found';

  @override
  String get backToStart => 'Back to start';

  @override
  String get nextPhaseMessage =>
      'This screen will be connected to the authentication module.';

  @override
  String openPage(String page) {
    return 'Open $page';
  }
}
