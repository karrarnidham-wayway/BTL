import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/localization/app_localizations.dart';
import '../../shared/models/user_model.dart';
import '../auth/auth_provider.dart';
import '../store/product_list_screen.dart';
import '../store/admin/store_admin_dashboard.dart';
import '../pt/athlete_dashboard_screen.dart';
import '../pt/admin/pt_admin_dashboard.dart';
import '../settings/settings_screen.dart';

/// Kullanıcının rolüne göre farklı sekmeler gösteren ana kabuk.
/// Bu, "admin ve kullanıcı ekranlarının net şekilde ayrılması" gereksinimini
/// tek bir router karmaşası yaratmadan, temiz biçimde karşılar.
class HomeShell extends ConsumerStatefulWidget {
  const HomeShell({super.key});

  @override
  ConsumerState<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends ConsumerState<HomeShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;
    if (user == null) return const SizedBox.shrink();

    final tabs = _tabsForRole(context, user.role);

    return Scaffold(
      body: tabs[_index].screen,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        items: tabs
            .map((tab) => BottomNavigationBarItem(icon: Icon(tab.icon), label: tab.label))
            .toList(),
      ),
    );
  }

  List<_TabItem> _tabsForRole(BuildContext context, UserRole role) {
    switch (role) {
      case UserRole.customer:
        return [
          _TabItem(context.t('store'), Icons.storefront, const ProductListScreen()),
          _TabItem(context.t('notifications'), Icons.notifications, const _PlaceholderScreen('Bildirimler')),
          _TabItem(context.t('profile'), Icons.person, const SettingsScreen()),
        ];
      case UserRole.athlete:
        return [
          _TabItem(context.t('my_panel'), Icons.fitness_center, const AthleteDashboardScreen()),
          _TabItem(context.t('notifications'), Icons.notifications, const _PlaceholderScreen('Bildirimler')),
          _TabItem(context.t('profile'), Icons.person, const SettingsScreen()),
        ];
      case UserRole.storeAdmin:
        return [
          _TabItem(context.t('store'), Icons.storefront, const StoreAdminDashboard()),
          _TabItem(context.t('profile'), Icons.person, const SettingsScreen()),
        ];
      case UserRole.ptAdmin:
        return [
          _TabItem(context.t('my_panel'), Icons.groups, const PtAdminDashboard()),
          _TabItem(context.t('profile'), Icons.person, const SettingsScreen()),
        ];
      case UserRole.superAdmin:
        return [
          _TabItem('Store', Icons.storefront, const StoreAdminDashboard()),
          _TabItem('PT', Icons.groups, const PtAdminDashboard()),
          _TabItem(context.t('profile'), Icons.person, const SettingsScreen()),
        ];
    }
  }
}

class _TabItem {
  final String label;
  final IconData icon;
  final Widget screen;
  _TabItem(this.label, this.icon, this.screen);
}

class _PlaceholderScreen extends StatelessWidget {
  final String title;
  const _PlaceholderScreen(this.title);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text('$title — yakında')),
    );
  }
}
