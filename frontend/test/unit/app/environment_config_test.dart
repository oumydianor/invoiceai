import 'package:flutter_test/flutter_test.dart';
import 'package:invoiceai/app/environment/app_environment.dart';

void main() {
  test('development disables production telemetry by default', () {
    final config = EnvironmentConfig.forEnvironment(AppEnvironment.development);

    expect(config.analyticsEnabled, isFalse);
    expect(config.crashlyticsEnabled, isFalse);
    expect(config.appCheckEnabled, isFalse);
  });

  test('production enables production telemetry', () {
    final config = EnvironmentConfig.forEnvironment(AppEnvironment.production);

    expect(config.analyticsEnabled, isTrue);
    expect(config.crashlyticsEnabled, isTrue);
    expect(config.appCheckEnabled, isTrue);
    expect(config.useFirebaseEmulators, isFalse);
  });
}
