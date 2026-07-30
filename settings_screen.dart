import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/localization/app_localizations.dart';
import '../../core/localization/locale_provider.dart';
import '../../core/theme/app_theme.dart';
import '../auth/auth_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;
    final locale = ref.watch(localeProvider);

    return Scaffold(
      appBar: AppBar(title: Text(context.t('profile'))),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          if (user != null)
            Card(
              child: ListTile(
                leading: const CircleAvatar(backgroundColor: AppColors.gold, child: Icon(Icons.person, color: Colors.black)),
                title: Text(user.fullName),
                subtitle: Text('@${user.username}'),
              ),
            ),
          const SizedBox(height: 20),
          Text(context.t('language'), style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'tr', label: Text('Türkçe')),
              ButtonSegment(value: 'ar', label: Text('العربية')),
            ],
            selected: {locale.languageCode},
            onSelectionChanged: (selection) {
              ref.read(localeProvider.notifier).setLocale(selection.first);
            },
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => ref.read(authProvider.notifier).logout(),
            icon: const Icon(Icons.logout),
            label: Text(context.t('logout')),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger, foregroundColor: Colors.white),
          ),
        ],
      ),
    );
  }
}
