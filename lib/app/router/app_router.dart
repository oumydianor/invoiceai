import 'package:go_router/go_router.dart';
import 'package:invoiceai/app/router/app_routes.dart';
import 'package:invoiceai/features/authentication/presentation/pages/foundation_page.dart';
import 'package:invoiceai/features/invoicing/presentation/pages/client_portal_page.dart';
import 'package:invoiceai/features/invoicing/presentation/pages/clients_page.dart';
import 'package:invoiceai/features/invoicing/presentation/pages/company_profile_page.dart';
import 'package:invoiceai/features/invoicing/presentation/pages/create_invoice_page.dart';
import 'package:invoiceai/features/invoicing/presentation/pages/dashboard_page.dart';
import 'package:invoiceai/features/invoicing/presentation/pages/invoices_page.dart';
import 'package:invoiceai/features/invoicing/presentation/widgets/demo_shell.dart';

abstract final class AppRouter {
  static GoRouter create() => GoRouter(
    initialLocation: AppRoutes.dashboard,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            DemoShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.dashboard,
                builder: (context, state) => const DashboardPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.invoices,
                builder: (context, state) => const InvoicesPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.clients,
                builder: (context, state) => const ClientsPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.clientPortal,
                builder: (context, state) => const ClientPortalPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.company,
                builder: (context, state) => const CompanyProfilePage(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.createInvoice,
        builder: (context, state) => const CreateInvoicePage(),
      ),
      GoRoute(
        path: AppRoutes.launch,
        builder: (context, state) =>
            const FoundationPage(destination: FoundationDestination.launch),
      ),
      GoRoute(
        path: AppRoutes.authentication,
        builder: (context, state) => const FoundationPage(
          destination: FoundationDestination.authentication,
        ),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) =>
            const FoundationPage(destination: FoundationDestination.login),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) =>
            const FoundationPage(destination: FoundationDestination.register),
      ),
      GoRoute(
        path: AppRoutes.phone,
        builder: (context, state) =>
            const FoundationPage(destination: FoundationDestination.phone),
      ),
      GoRoute(
        path: AppRoutes.otp,
        builder: (context, state) =>
            const FoundationPage(destination: FoundationDestination.otp),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (context, state) => const FoundationPage(
          destination: FoundationDestination.forgotPassword,
        ),
      ),
      GoRoute(
        path: AppRoutes.emailVerification,
        builder: (context, state) => const FoundationPage(
          destination: FoundationDestination.emailVerification,
        ),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) =>
            const FoundationPage(destination: FoundationDestination.home),
      ),
      GoRoute(
        path: AppRoutes.profile,
        builder: (context, state) =>
            const FoundationPage(destination: FoundationDestination.profile),
      ),
    ],
    errorBuilder: (context, state) =>
        const FoundationPage(destination: FoundationDestination.notFound),
  );
}
