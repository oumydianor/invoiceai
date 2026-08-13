import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:go_router/go_router.dart';
import 'package:invoiceai/app/router/app_routes.dart';
import 'package:invoiceai/app/theme/app_colors.dart';
import 'package:invoiceai/app/theme/app_dimensions.dart';
import 'package:invoiceai/core/widgets/critical_action_modal.dart';
import 'package:invoiceai/features/invoicing/presentation/state/demo_store.dart';
import 'package:provider/provider.dart';

class DemoShell extends StatefulWidget {
  const DemoShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  static const destinations = [
    _ShellDestination(
      'Accueil',
      Icons.space_dashboard_outlined,
      Icons.space_dashboard_rounded,
    ),
    _ShellDestination(
      'Factures',
      Icons.receipt_long_outlined,
      Icons.receipt_long_rounded,
    ),
    _ShellDestination(
      'Clients',
      Icons.people_outline_rounded,
      Icons.people_rounded,
    ),
    _ShellDestination(
      'Mon espace',
      Icons.account_balance_wallet_outlined,
      Icons.account_balance_wallet_rounded,
    ),
    _ShellDestination(
      'Entreprise',
      Icons.storefront_outlined,
      Icons.storefront_rounded,
    ),
  ];

  @override
  State<DemoShell> createState() => _DemoShellState();
}

class _DemoShellState extends State<DemoShell> {
  bool _navigationVisible = true;
  bool _sidebarExpanded = true;
  bool _sidebarPinned = false;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final useSidebar = width >= 760;
    final canExpandSidebar = width >= 1120;
    final expanded = canExpandSidebar && _sidebarExpanded;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: useSidebar
          ? null
          : AppBar(
              toolbarHeight: 64,
              title: const _Brand(compact: true),
              actions: [
                const _NotificationButton(),
                _ProfileMenu(onReset: _resetDemo, onLogout: _logout),
                const SizedBox(width: AppSpacing.small),
              ],
            ),
      body: Row(
        children: [
          if (useSidebar)
            _DesktopNavigation(
              expanded: expanded,
              pinned: _sidebarPinned,
              currentIndex: widget.navigationShell.currentIndex,
              onSelected: _goToBranch,
              onToggle: canExpandSidebar
                  ? () => setState(() => _sidebarExpanded = !expanded)
                  : null,
              onPin: canExpandSidebar
                  ? () => setState(() => _sidebarPinned = !_sidebarPinned)
                  : null,
              onReset: _resetDemo,
              onLogout: _logout,
            ),
          Expanded(
            child: NotificationListener<UserScrollNotification>(
              onNotification: (notification) {
                _handleScroll(
                  notification.direction,
                  useSidebar,
                  canExpandSidebar,
                );
                return false;
              },
              child: widget.navigationShell,
            ),
          ),
        ],
      ),
      floatingActionButton: widget.navigationShell.currentIndex <= 1
          ? FloatingActionButton.extended(
              onPressed: () => context.go(AppRoutes.createInvoice),
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.auto_awesome_rounded),
              label: Text(width < 390 ? 'Créer' : 'Nouvelle facture'),
            )
          : null,
      bottomNavigationBar: useSidebar
          ? null
          : AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              height: _navigationVisible
                  ? 72 + MediaQuery.paddingOf(context).bottom
                  : 0,
              child: ClipRect(
                child: AnimatedSlide(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutCubic,
                  offset: _navigationVisible ? Offset.zero : const Offset(0, 1),
                  child: NavigationBar(
                    labelBehavior: width < 370
                        ? NavigationDestinationLabelBehavior.onlyShowSelected
                        : NavigationDestinationLabelBehavior.alwaysShow,
                    selectedIndex: widget.navigationShell.currentIndex,
                    onDestinationSelected: _goToBranch,
                    destinations: [
                      for (
                        var index = 0;
                        index < DemoShell.destinations.length;
                        index++
                      )
                        NavigationDestination(
                          icon: Icon(DemoShell.destinations[index].icon),
                          selectedIcon: Icon(
                            DemoShell.destinations[index].selectedIcon,
                          ),
                          label: DemoShell.destinations[index].shortLabel,
                        ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  void _handleScroll(
    ScrollDirection direction,
    bool useSidebar,
    bool canExpandSidebar,
  ) {
    if (direction == ScrollDirection.idle) return;
    if (!useSidebar) {
      final visible = direction == ScrollDirection.forward;
      if (_navigationVisible != visible) {
        setState(() => _navigationVisible = visible);
      }
      return;
    }
    if (!canExpandSidebar || _sidebarPinned) return;
    final expanded = direction == ScrollDirection.forward;
    if (_sidebarExpanded != expanded) {
      setState(() => _sidebarExpanded = expanded);
    }
  }

  void _goToBranch(int index) {
    setState(() => _navigationVisible = true);
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  Future<void> _resetDemo() async {
    final confirmed = await showCriticalActionModal(
      context,
      title: 'Réinitialiser la démonstration ?',
      message:
          'Toutes les modifications locales, les factures créées et les changements de statut seront remplacés par les données de départ.',
      confirmLabel: 'Réinitialiser',
      icon: Icons.restart_alt_rounded,
    );
    if (!confirmed || !mounted) return;
    context.read<DemoStore>().resetDemo();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('La démonstration a été réinitialisée.')),
    );
  }

  Future<void> _logout() async {
    final confirmed = await showCriticalActionModal(
      context,
      title: 'Se déconnecter ?',
      message:
          'Vous devrez vous authentifier à nouveau pour accéder à votre espace.',
      confirmLabel: 'Se déconnecter',
      icon: Icons.logout_rounded,
    );
    if (!confirmed || !mounted) return;
    context.go(AppRoutes.login);
  }
}

class _DesktopNavigation extends StatelessWidget {
  const _DesktopNavigation({
    required this.expanded,
    required this.pinned,
    required this.currentIndex,
    required this.onSelected,
    required this.onReset,
    required this.onLogout,
    this.onToggle,
    this.onPin,
  });

  final bool expanded;
  final bool pinned;
  final int currentIndex;
  final ValueChanged<int> onSelected;
  final VoidCallback? onToggle;
  final VoidCallback? onPin;
  final VoidCallback onReset;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) => AnimatedContainer(
    duration: const Duration(milliseconds: 260),
    curve: Curves.easeOutCubic,
    width: expanded ? 264 : 88,
    decoration: const BoxDecoration(color: AppColors.navy),
    child: SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          12,
          AppSpacing.large,
          12,
          AppSpacing.medium,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(child: _Brand(compact: !expanded, dark: true)),
                if (expanded && onPin != null)
                  IconButton(
                    onPressed: onPin,
                    tooltip: pinned
                        ? 'Libérer la navigation'
                        : 'Épingler la navigation',
                    color: Colors.white60,
                    icon: Icon(
                      pinned ? Icons.push_pin : Icons.push_pin_outlined,
                      size: 19,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.xLarge),
            for (var index = 0; index < DemoShell.destinations.length; index++)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.xSmall),
                child: _NavigationItem(
                  destination: DemoShell.destinations[index],
                  expanded: expanded,
                  selected: currentIndex == index,
                  onTap: () => onSelected(index),
                ),
              ),
            const Spacer(),
            if (expanded)
              _ResetBanner(onTap: onReset)
            else
              IconButton(
                tooltip: 'Réinitialiser la démonstration',
                onPressed: onReset,
                color: Colors.white60,
                icon: const Icon(Icons.restart_alt_rounded),
              ),
            const SizedBox(height: AppSpacing.small),
            _ProfileTile(expanded: expanded, onLogout: onLogout),
            if (onToggle != null) ...[
              const SizedBox(height: AppSpacing.small),
              IconButton(
                onPressed: onToggle,
                tooltip: expanded ? 'Réduire le menu' : 'Déployer le menu',
                color: Colors.white70,
                icon: Icon(
                  expanded
                      ? Icons.keyboard_double_arrow_left
                      : Icons.keyboard_double_arrow_right,
                ),
              ),
            ],
          ],
        ),
      ),
    ),
  );
}

class _NavigationItem extends StatelessWidget {
  const _NavigationItem({
    required this.destination,
    required this.expanded,
    required this.selected,
    required this.onTap,
  });

  final _ShellDestination destination;
  final bool expanded;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Tooltip(
    message: expanded ? '' : destination.label,
    child: Material(
      color: selected ? AppColors.primary : Colors.transparent,
      borderRadius: BorderRadius.circular(AppRadii.medium),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: 50,
          child: Row(
            mainAxisAlignment: expanded
                ? MainAxisAlignment.start
                : MainAxisAlignment.center,
            children: [
              if (expanded) const SizedBox(width: AppSpacing.medium),
              Icon(
                selected ? destination.selectedIcon : destination.icon,
                color: selected ? Colors.white : const Color(0xFFB8C3DB),
              ),
              if (expanded) ...[
                const SizedBox(width: AppSpacing.medium),
                Expanded(
                  child: Text(
                    destination.label,
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                    style: TextStyle(
                      color: selected ? Colors.white : const Color(0xFFB8C3DB),
                      fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.small),
              ],
            ],
          ),
        ),
      ),
    ),
  );
}

class _ResetBanner extends StatelessWidget {
  const _ResetBanner({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.white.withValues(alpha: .07),
    borderRadius: BorderRadius.circular(AppRadii.medium),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadii.medium),
      child: const Padding(
        padding: EdgeInsets.all(AppSpacing.medium),
        child: Row(
          children: [
            Icon(Icons.restart_alt_rounded, color: Colors.white70),
            SizedBox(width: AppSpacing.small),
            Expanded(
              child: Text(
                'Réinitialiser la démo',
                style: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _Brand extends StatelessWidget {
  const _Brand({this.compact = false, this.dark = false});

  final bool compact;
  final bool dark;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: compact
        ? MainAxisAlignment.center
        : MainAxisAlignment.start,
    children: [
      DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(11),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: .3),
              blurRadius: 14,
            ),
          ],
        ),
        child: const SizedBox(
          width: 38,
          height: 38,
          child: Icon(
            Icons.auto_awesome_rounded,
            color: Colors.white,
            size: 21,
          ),
        ),
      ),
      if (!compact) ...[
        const SizedBox(width: 10),
        Flexible(
          child: Text(
            'InvoiceAI',
            maxLines: 1,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: dark ? Colors.white : null,
              fontWeight: FontWeight.w900,
              letterSpacing: -.4,
            ),
          ),
        ),
      ],
    ],
  );
}

class _ProfileTile extends StatelessWidget {
  const _ProfileTile({required this.expanded, required this.onLogout});

  final bool expanded;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onLogout,
    borderRadius: BorderRadius.circular(AppRadii.medium),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.small),
      child: Row(
        mainAxisAlignment: expanded
            ? MainAxisAlignment.start
            : MainAxisAlignment.center,
        children: [
          const _ProfileAvatar(),
          if (expanded) ...[
            const SizedBox(width: AppSpacing.small),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Awa Ndiaye',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    'Administratrice',
                    style: TextStyle(color: Colors.white60, fontSize: 12),
                  ),
                ],
              ),
            ),
            const Icon(Icons.logout_rounded, color: Colors.white54, size: 19),
          ],
        ],
      ),
    ),
  );
}

class _NotificationButton extends StatelessWidget {
  const _NotificationButton();

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      IconButton(
        onPressed: () {},
        icon: const Icon(Icons.notifications_none_rounded),
      ),
      Positioned(
        right: 10,
        top: 10,
        child: Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            color: AppColors.error,
            shape: BoxShape.circle,
          ),
        ),
      ),
    ],
  );
}

class _ProfileMenu extends StatelessWidget {
  const _ProfileMenu({required this.onReset, required this.onLogout});

  final VoidCallback onReset;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) => PopupMenuButton<String>(
    tooltip: 'Compte',
    onSelected: (value) {
      if (value == 'reset') onReset();
      if (value == 'logout') onLogout();
    },
    itemBuilder: (context) => const [
      PopupMenuItem(
        value: 'reset',
        child: ListTile(
          leading: Icon(Icons.restart_alt),
          title: Text('Réinitialiser'),
        ),
      ),
      PopupMenuItem(
        value: 'logout',
        child: ListTile(
          leading: Icon(Icons.logout),
          title: Text('Se déconnecter'),
        ),
      ),
    ],
    child: const Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.small),
      child: _ProfileAvatar(),
    ),
  );
}

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar();

  @override
  Widget build(BuildContext context) => const CircleAvatar(
    radius: 20,
    backgroundColor: Color(0xFFE8ECFF),
    foregroundColor: AppColors.primary,
    child: Text('AN', style: TextStyle(fontWeight: FontWeight.w900)),
  );
}

class _ShellDestination {
  const _ShellDestination(this.label, this.icon, this.selectedIcon);

  final String label;
  final IconData icon;
  final IconData selectedIcon;

  String get shortLabel => switch (label) {
    'Mon espace' => 'Espace',
    'Entreprise' => 'Société',
    _ => label,
  };
}
