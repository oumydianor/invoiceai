import 'package:firebase_core/firebase_core.dart';

/// Web Firebase identifiers are supplied at build time because no Web app
/// configuration was included with the native Firebase files.
abstract final class DefaultFirebaseOptions {
  static FirebaseOptions? get webFromEnvironment {
    const apiKey = String.fromEnvironment('FIREBASE_WEB_API_KEY');
    const appId = String.fromEnvironment('FIREBASE_WEB_APP_ID');
    const messagingSenderId = String.fromEnvironment(
      'FIREBASE_WEB_MESSAGING_SENDER_ID',
    );
    const projectId = String.fromEnvironment('FIREBASE_WEB_PROJECT_ID');
    const authDomain = String.fromEnvironment('FIREBASE_WEB_AUTH_DOMAIN');
    const storageBucket = String.fromEnvironment('FIREBASE_WEB_STORAGE_BUCKET');

    if ([
      apiKey,
      appId,
      messagingSenderId,
      projectId,
    ].any((value) => value.isEmpty)) {
      return null;
    }

    return const FirebaseOptions(
      apiKey: apiKey,
      appId: appId,
      messagingSenderId: messagingSenderId,
      projectId: projectId,
      authDomain: authDomain,
      storageBucket: storageBucket,
    );
  }
}
