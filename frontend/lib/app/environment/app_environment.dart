enum AppEnvironment {
  development,
  staging,
  production;

  static AppEnvironment fromDefine() {
    const value = String.fromEnvironment(
      'APP_ENV',
      defaultValue: 'development',
    );
    return AppEnvironment.values.firstWhere(
      (environment) => environment.name == value,
      orElse: () => AppEnvironment.development,
    );
  }
}

class EnvironmentConfig {
  const EnvironmentConfig({
    required this.environment,
    required this.useFirebaseEmulators,
    required this.analyticsEnabled,
    required this.crashlyticsEnabled,
    required this.appCheckEnabled,
  });

  factory EnvironmentConfig.forEnvironment(AppEnvironment environment) {
    const useEmulators = bool.fromEnvironment('USE_FIREBASE_EMULATORS');
    return EnvironmentConfig(
      environment: environment,
      useFirebaseEmulators:
          environment == AppEnvironment.development && useEmulators,
      analyticsEnabled: environment != AppEnvironment.development,
      crashlyticsEnabled: environment != AppEnvironment.development,
      appCheckEnabled: environment != AppEnvironment.development,
    );
  }

  final AppEnvironment environment;
  final bool useFirebaseEmulators;
  final bool analyticsEnabled;
  final bool crashlyticsEnabled;
  final bool appCheckEnabled;

  bool get isDevelopment => environment == AppEnvironment.development;
}
