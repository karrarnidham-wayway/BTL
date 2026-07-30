import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../core/localization/app_localizations.dart';
import '../../core/theme/app_theme.dart';
import 'athlete_provider.dart';

/// Sporcunun kendi profilini, haftalık antrenman planını, gelişim
/// grafiğini ve PT notlarını görüntülediği salt-okunur (bilgilendirici)
/// panel. Sporcu bu veriyi düzenleyemez — sadece PT girebilir (RBAC).
class AthleteDashboardScreen extends ConsumerWidget {
  const AthleteDashboardScreen({super.key});

  static const _dayNames = ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final measurementsAsync = ref.watch(myMeasurementsProvider);
    final trainingAsync = ref.watch(myTrainingPlanProvider);
    final notesAsync = ref.watch(myNotesProvider);

    return Scaffold(
      appBar: AppBar(title: Text(context.t('my_panel'))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(context.t('progress'), style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 12),
          measurementsAsync.when(
            data: (measurements) {
              if (measurements.isEmpty) {
                return const Card(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text('Henüz ölçüm kaydı girilmemiş.'),
                  ),
                );
              }
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    height: 200,
                    child: LineChart(
                      LineChartData(
                        gridData: const FlGridData(show: false),
                        titlesData: const FlTitlesData(show: false),
                        borderData: FlBorderData(show: false),
                        lineBarsData: [
                          LineChartBarData(
                            spots: [
                              for (int i = 0; i < measurements.length; i++)
                                FlSpot(i.toDouble(), measurements[i].weightKg),
                            ],
                            isCurved: true,
                            color: AppColors.gold,
                            barWidth: 3,
                            dotData: const FlDotData(show: true),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, st) => Text('Hata: $e'),
          ),
          const SizedBox(height: 24),
          Text(context.t('weekly_training_plan'), style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 12),
          trainingAsync.when(
            data: (plans) => Column(
              children: List.generate(7, (i) {
                final dayPlan = plans.where((p) => p.dayOfWeek == i + 1).toList();
                final label = dayPlan.isNotEmpty ? dayPlan.first.muscleGroup : 'Dinlenme';
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.gold,
                      child: Text(_dayNames[i], style: const TextStyle(color: Colors.black, fontSize: 11)),
                    ),
                    title: Text(label),
                  ),
                );
              }),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, st) => Text('Hata: $e'),
          ),
          const SizedBox(height: 24),
          Text(context.t('pt_notes'), style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 12),
          notesAsync.when(
            data: (notes) => Column(
              children: notes
                  .map((n) => Card(
                        child: ListTile(
                          leading: const Icon(Icons.sticky_note_2, color: AppColors.gold),
                          title: Text(n.content),
                          subtitle: Text('${n.createdAt.day}.${n.createdAt.month}.${n.createdAt.year}'),
                        ),
                      ))
                  .toList(),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, st) => Text('Hata: $e'),
          ),
        ],
      ),
    );
  }
}
