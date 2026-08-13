import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:invoiceai/app/app.dart';
import 'package:invoiceai/app/dependency_injection/app_dependencies.dart';
import 'package:invoiceai/app/environment/app_environment.dart';
import 'package:invoiceai/app/router/app_router.dart';
import 'package:invoiceai/core/logging/app_logger.dart';
import 'package:invoiceai/core/services/firebase_bootstrap.dart';
import 'package:invoiceai/features/invoicing/presentation/state/demo_store.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('shows the demo dashboard without requiring real Firebase', (
    tester,
  ) async {
    final dependencies = AppDependencies(
      environment: EnvironmentConfig.forEnvironment(AppEnvironment.development),
      logger: const DebugAppLogger(enabled: false),
      firebase: const FirebaseBootstrapState(
        FirebaseSetupStatus.missingWebConfiguration,
      ),
    );

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<AppDependencies>.value(value: dependencies),
          ChangeNotifierProvider(create: (_) => DemoStore.seeded()),
        ],
        child: InvoiceAiApp(router: AppRouter.create()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Bonjour, Awa 👋'), findsOneWidget);
    expect(find.text('Revenus encaissés'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('keeps the client experience usable on a 320px screen', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 740);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final dependencies = AppDependencies(
      environment: EnvironmentConfig.forEnvironment(AppEnvironment.development),
      logger: const DebugAppLogger(enabled: false),
      firebase: const FirebaseBootstrapState(
        FirebaseSetupStatus.missingWebConfiguration,
      ),
    );

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<AppDependencies>.value(value: dependencies),
          ChangeNotifierProvider(create: (_) => DemoStore.seeded()),
        ],
        child: InvoiceAiApp(router: AppRouter.create()),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byType(NavigationDestination).at(3));
    await tester.pumpAndSettle();

    expect(find.text('ESPACE CLIENT'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
