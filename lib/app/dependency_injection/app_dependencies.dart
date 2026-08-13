import 'package:invoiceai/app/environment/app_environment.dart';
import 'package:invoiceai/core/logging/app_logger.dart';
import 'package:invoiceai/core/services/firebase_bootstrap.dart';

class AppDependencies {
  const AppDependencies({
    required this.environment,
    required this.logger,
    required this.firebase,
  });

  final EnvironmentConfig environment;
  final AppLogger logger;
  final FirebaseBootstrapState firebase;
}
