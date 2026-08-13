import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:invoiceai/app/environment/app_environment.dart';
import 'package:invoiceai/core/logging/app_logger.dart';
import 'package:invoiceai/firebase_options.dart';

enum FirebaseSetupStatus { ready, missingWebConfiguration, failed }

class FirebaseBootstrapState {
  const FirebaseBootstrapState(this.status, {this.message});

  final FirebaseSetupStatus status;
  final String? message;

  bool get isReady => status == FirebaseSetupStatus.ready;
}

abstract final class FirebaseBootstrap {
  static Future<FirebaseBootstrapState> initialize({
    required EnvironmentConfig config,
    required AppLogger logger,
  }) async {
    try {
      if (Firebase.apps.isEmpty) {
        if (kIsWeb) {
          final options = DefaultFirebaseOptions.webFromEnvironment;
          if (options == null) {
            return const FirebaseBootstrapState(
              FirebaseSetupStatus.missingWebConfiguration,
              message: 'Missing Firebase Web build definitions.',
            );
          }
          await Firebase.initializeApp(options: options);
        } else {
          await Firebase.initializeApp();
        }
      }

      if (config.useFirebaseEmulators) {
        await _connectToEmulators(logger);
      }

      await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(
        config.analyticsEnabled,
      );

      if (!kIsWeb) {
        await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(
          config.crashlyticsEnabled,
        );
        _installCrashHandlers(config);
      }

      return const FirebaseBootstrapState(FirebaseSetupStatus.ready);
    } on Object catch (error, stackTrace) {
      logger.error('Firebase initialization failed', error, stackTrace);
      return FirebaseBootstrapState(
        FirebaseSetupStatus.failed,
        message: error.runtimeType.toString(),
      );
    }
  }

  static Future<void> _connectToEmulators(AppLogger logger) async {
    const overrideHost = String.fromEnvironment('FIREBASE_EMULATOR_HOST');
    final host = overrideHost.isNotEmpty
        ? overrideHost
        : kIsWeb || defaultTargetPlatform == TargetPlatform.iOS
        ? 'localhost'
        : '10.0.2.2';

    await FirebaseAuth.instance.useAuthEmulator(host, 9099);
    FirebaseFirestore.instance.useFirestoreEmulator(host, 8080);
    await FirebaseStorage.instance.useStorageEmulator(host, 9199);
    logger.debug('Firebase emulators enabled on $host.');
  }

  static void _installCrashHandlers(EnvironmentConfig config) {
    if (!config.crashlyticsEnabled) return;
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    PlatformDispatcher.instance.onError = (error, stackTrace) {
      FirebaseCrashlytics.instance.recordError(error, stackTrace, fatal: true);
      return true;
    };
  }
}
