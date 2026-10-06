import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:invoiceai/app/dependency_injection/app_dependencies.dart';
import 'package:invoiceai/app/router/app_routes.dart';
import 'package:invoiceai/app/theme/app_colors.dart';
import 'package:invoiceai/app/theme/app_dimensions.dart';
import 'package:invoiceai/core/responsive/app_breakpoints.dart';
import 'package:invoiceai/core/widgets/responsive_center.dart';
import 'package:invoiceai/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

enum FoundationDestination {
  launch,
  authentication,
  login,
  register,
  phone,
  otp,
  forgotPassword,
  emailVerification,
  home,
  profile,
  notFound,
}

class FoundationPage extends StatelessWidget {
  const FoundationPage({required this.destination, super.key});

  final FoundationDestination destination;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    if (destination == FoundationDestination.login ||
        destination == FoundationDestination.authentication) {
      return const _LoginPage();
    }
    return Scaffold(
      appBar: AppBar(title: Text(localizations.appName)),
      body: ResponsiveCenter(
        maxWidth: destination == FoundationDestination.launch ? 960 : 640,
        child: destination == FoundationDestination.launch
            ? const _LaunchContent()
            : _DestinationContent(destination: destination),
      ),
    );
  }
}

class _LoginPage extends StatefulWidget {
  const _LoginPage();

  @override
  State<_LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<_LoginPage> {
  final _emailController = TextEditingController(text: 'admin@invoiceai.sn');
  final _passwordController = TextEditingController(text: 'invoiceai');
  bool _obscure = true;
  bool _remember = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final showVisual = width >= 820;
    return Scaffold(
      body: Row(
        children: [
          if (showVisual) const Expanded(flex: 5, child: _LoginVisual()),
          Expanded(
            flex: 7,
            child: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(
                    width < 400 ? AppSpacing.large : AppSpacing.xLarge,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 520),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (!showVisual) ...[
                          const _LoginBrand(dark: false),
                          const SizedBox(height: AppSpacing.xxLarge),
                        ],
                        Text(
                          'Connexion à votre compte',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: AppSpacing.small),
                        Text(
                          'Accédez à votre espace pour gérer vos factures.',
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                        ),
                        const SizedBox(height: AppSpacing.xLarge),
                        TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: 'Adresse e-mail',
                            prefixIcon: Icon(Icons.mail_outline_rounded),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.medium),
                        TextField(
                          controller: _passwordController,
                          obscureText: _obscure,
                          decoration: InputDecoration(
                            labelText: 'Mot de passe',
                            prefixIcon: const Icon(Icons.lock_outline_rounded),
                            suffixIcon: IconButton(
                              onPressed: () =>
                                  setState(() => _obscure = !_obscure),
                              icon: Icon(
                                _obscure
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.small),
                        Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: AppSpacing.medium,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Checkbox(
                                  value: _remember,
                                  onChanged: (value) => setState(
                                    () => _remember = value ?? false,
                                  ),
                                ),
                                const Text('Se souvenir de moi'),
                              ],
                            ),
                            TextButton(
                              onPressed: () =>
                                  context.go(AppRoutes.forgotPassword),
                              child: const Text('Mot de passe oublié ?'),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.medium),
                        FilledButton.icon(
                          onPressed: () => context.go(AppRoutes.dashboard),
                          icon: const Icon(Icons.arrow_forward_rounded),
                          label: const Text('Se connecter'),
                        ),
                        const SizedBox(height: AppSpacing.large),
                        Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              'Pas encore de compte ?',
                              style: TextStyle(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                            ),
                            TextButton(
                              onPressed: () => context.go(AppRoutes.register),
                              child: const Text('Créer un compte'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoginVisual extends StatelessWidget {
  const _LoginVisual();

  @override
  Widget build(BuildContext context) => Container(
    color: AppColors.navy,
    padding: const EdgeInsets.all(AppSpacing.xxLarge),
    child: SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _LoginBrand(dark: true),
          const SizedBox(height: AppSpacing.small),
          const Text(
            'Générez vos devis et factures intelligemment.',
            style: TextStyle(color: Color(0xFFB8C3DB), fontSize: 16),
          ),
          const Spacer(),
          Center(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 300,
                  height: 350,
                  decoration: BoxDecoration(
                    color: const Color(0xFF233761),
                    borderRadius: BorderRadius.circular(AppRadii.xLarge),
                  ),
                  child: Center(
                    child: Transform.rotate(
                      angle: -.08,
                      child: Container(
                        width: 180,
                        height: 250,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(AppRadii.medium),
                          boxShadow: const [
                            BoxShadow(color: Colors.black26, blurRadius: 24),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            'FACTURE',
                            style: TextStyle(
                              color: Color(0xFF8792A9),
                              fontWeight: FontWeight.w900,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const Positioned(
                  right: -24,
                  bottom: -24,
                  child: CircleAvatar(
                    radius: 54,
                    backgroundColor: AppColors.primary,
                    child: Icon(
                      Icons.smart_toy_outlined,
                      color: Colors.white,
                      size: 42,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          const Text(
            '© 2026 InvoiceAI · Tous droits réservés',
            style: TextStyle(color: Colors.white54, fontSize: 12),
          ),
        ],
      ),
    ),
  );
}

class _LoginBrand extends StatelessWidget {
  const _LoginBrand({required this.dark});

  final bool dark;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(11),
        ),
        child: const SizedBox(
          width: 38,
          height: 38,
          child: Icon(Icons.auto_awesome_rounded, color: Colors.white),
        ),
      ),
      const SizedBox(width: AppSpacing.small),
      Text(
        'InvoiceAI',
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          color: dark ? Colors.white : null,
          fontWeight: FontWeight.w900,
        ),
      ),
    ],
  );
}

class _LaunchContent extends StatelessWidget {
  const _LaunchContent();

  @override
  Widget build(BuildContext context) {
    final dependencies = context.watch<AppDependencies>();
    final localizations = AppLocalizations.of(context);
    final isCompact = AppBreakpoints.of(context) == WindowSizeClass.compact;
    final destinations = FoundationDestination.values
        .where(
          (destination) =>
              destination != FoundationDestination.launch &&
              destination != FoundationDestination.notFound,
        )
        .toList(growable: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          localizations.foundationTitle,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: AppSpacing.small),
        Text(localizations.foundationReady),
        const SizedBox(height: AppSpacing.large),
        Semantics(
          liveRegion: true,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.large),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    dependencies.firebase.isReady
                        ? Icons.cloud_done_outlined
                        : Icons.cloud_off_outlined,
                  ),
                  const SizedBox(width: AppSpacing.medium),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dependencies.firebase.isReady
                              ? localizations.firebaseReady
                              : localizations.firebasePending,
                        ),
                        const SizedBox(height: AppSpacing.small),
                        Text(
                          localizations.environmentLabel(
                            dependencies.environment.environment.name,
                          ),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.large),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isCompact ? 1 : 2,
            childAspectRatio: isCompact ? 4.5 : 3.6,
            crossAxisSpacing: AppSpacing.medium,
            mainAxisSpacing: AppSpacing.medium,
          ),
          itemCount: destinations.length,
          itemBuilder: (context, index) {
            final destination = destinations[index];
            final label = _label(localizations, destination);
            return OutlinedButton.icon(
              onPressed: () => context.go(_path(destination)),
              icon: const Icon(Icons.arrow_forward),
              label: Text(localizations.openPage(label)),
            );
          },
        ),
      ],
    );
  }
}

class _DestinationContent extends StatelessWidget {
  const _DestinationContent({required this.destination});

  final FoundationDestination destination;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xLarge),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              destination == FoundationDestination.notFound
                  ? Icons.error_outline
                  : Icons.construction_outlined,
              size: AppSizes.minimumTouchTarget,
            ),
            const SizedBox(height: AppSpacing.medium),
            Text(
              _label(localizations, destination),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: AppSpacing.medium),
            Text(
              destination == FoundationDestination.notFound
                  ? localizations.pageNotFound
                  : localizations.nextPhaseMessage,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.large),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.launch),
              child: Text(localizations.backToStart),
            ),
          ],
        ),
      ),
    );
  }
}

String _label(
  AppLocalizations localizations,
  FoundationDestination destination,
) => switch (destination) {
  FoundationDestination.launch => localizations.foundationTitle,
  FoundationDestination.authentication => localizations.login,
  FoundationDestination.login => localizations.login,
  FoundationDestination.register => localizations.register,
  FoundationDestination.phone => localizations.phoneAuthentication,
  FoundationDestination.otp => localizations.otpVerification,
  FoundationDestination.forgotPassword => localizations.forgotPassword,
  FoundationDestination.emailVerification => localizations.emailVerification,
  FoundationDestination.home => localizations.home,
  FoundationDestination.profile => localizations.profile,
  FoundationDestination.notFound => localizations.pageNotFound,
};

String _path(FoundationDestination destination) => switch (destination) {
  FoundationDestination.launch => AppRoutes.launch,
  FoundationDestination.authentication => AppRoutes.authentication,
  FoundationDestination.login => AppRoutes.login,
  FoundationDestination.register => AppRoutes.register,
  FoundationDestination.phone => AppRoutes.phone,
  FoundationDestination.otp => AppRoutes.otp,
  FoundationDestination.forgotPassword => AppRoutes.forgotPassword,
  FoundationDestination.emailVerification => AppRoutes.emailVerification,
  FoundationDestination.home => AppRoutes.home,
  FoundationDestination.profile => AppRoutes.profile,
  FoundationDestination.notFound => '/not-found',
};
