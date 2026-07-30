import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/models/user_model.dart';
import 'athlete_management_screen.dart';

final ptAthletesProvider = FutureProvider<List<UserModel>>((ref) async {
  final response = await ApiClient.instance.client.get('/pt/athletes');
  final List data = response.data as List;
  return data.map((json) => UserModel.fromJson(json)).toList();
});

/// PT Admin sadece kendisine atanmış sporcuları görür — bu filtreleme
/// backend'de `pt_admin_id = current_user.id` koşuluyla uygulanır (RBAC).
class PtAdminDashboard extends ConsumerWidget {
  const PtAdminDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final athletesAsync = ref.watch(ptAthletesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Sporcularım')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Yeni sporcu ekleme formu (hesap + temel profil oluşturma)
        },
        icon: const Icon(Icons.person_add),
        label: const Text('Sporcu Ekle'),
      ),
      body: athletesAsync.when(
        data: (athletes) => ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: athletes.length,
          itemBuilder: (context, i) {
            final athlete = athletes[i];
            return Card(
              child: ListTile(
                leading: const CircleAvatar(backgroundColor: AppColors.gold, child: Icon(Icons.person, color: Colors.black)),
                title: Text(athlete.fullName),
                subtitle: Text('@${athlete.username}'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => AthleteManagementScreen(athlete: athlete)),
                ),
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Hata: $e')),
      ),
    );
  }
}
