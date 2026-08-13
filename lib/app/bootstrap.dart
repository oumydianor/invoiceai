import 'package:flutter/widgets.dart';
import 'package:invoiceai/app/app.dart';
import 'package:invoiceai/app/dependency_injection/app_dependencies.dart';
import 'package:invoiceai/app/environment/app_environment.dart';
import 'package:invoiceai/app/router/app_router.dart';
import 'package:invoiceai/core/logging/app_logger.dart';
import 'package:invoiceai/core/services/firebase_bootstrap.dart';
import 'package:invoiceai/features/invoicing/presentation/state/demo_store.dart';
import 'package:provider/provider.dart';

Future<void> bootstrapApp(AppEnvironment environment) async {
  WidgetsFlutterBinding.ensureInitialized();

  final config = EnvironmentConfig.forEnvironment(environment);
  final logger = DebugAppLogger(enabled: config.isDevelopment);
  final firebase = await FirebaseBootstrap.initialize(
    config: config,
    logger: logger,
  );
  final dependencies = AppDependencies(
    environment: config,
    logger: logger,
    firebase: firebase,
  );

  runApp(
    MultiProvider(
      providers: [
        Provider<AppDependencies>.value(value: dependencies),
        ChangeNotifierProvider(create: (_) => DemoStore.seeded()),
      ],
      child: InvoiceAiApp(router: AppRouter.create()),
    ),
  );
}
