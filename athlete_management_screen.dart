import 'package:flutter/material.dart';

import '../../../core/network/api_client.dart';
import '../../../shared/models/user_model.dart';

/// PT Admin'in tek bir sporcu için ölçüm girdiği, antrenman/beslenme
/// planını düzenlediği ve not eklediği ekran.
/// Ölçümler append-only'dir: her kayıt yeni bir satır olarak eklenir,
/// böylece gelişim geçmişi asla kaybolmaz.
class AthleteManagementScreen extends StatefulWidget {
  final UserModel athlete;
  const AthleteManagementScreen({super.key, required this.athlete});

  @override
  State<AthleteManagementScreen> createState() => _AthleteManagementScreenState();
}

class _AthleteManagementScreenState extends State<AthleteManagementScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final _weightController = TextEditingController();
  final _armController = TextEditingController();
  final _waistController = TextEditingController();
  final _bodyFatController = TextEditingController();
  final _noteController = TextEditingController();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  Future<void> _saveMeasurement() async {
    setState(() => _isSaving = true);
    try {
      await ApiClient.instance.client.post('/pt/athletes/${widget.athlete.id}/measurements', data: {
        'weight_kg': double.tryParse(_weightController.text),
        'arm_cm': double.tryParse(_armController.text),
        'waist_cm': double.tryParse(_waistController.text),
        'body_fat_percent': double.tryParse(_bodyFatController.text),
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ölçüm kaydedildi ✓')));
        _weightController.clear();
        _armController.clear();
        _waistController.clear();
        _bodyFatController.clear();
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _saveNote() async {
    if (_noteController.text.trim().isEmpty) return;
    await ApiClient.instance.client.post('/pt/athletes/${widget.athlete.id}/notes', data: {
      'content': _noteController.text.trim(),
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Not eklendi ✓')));
      _noteController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.athlete.fullName),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Ölçüm'),
            Tab(text: 'Program'),
            Tab(text: 'Notlar'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMeasurementTab(),
          _buildPlanTab(),
          _buildNotesTab(),
        ],
      ),
    );
  }

  Widget _buildMeasurementTab() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text('Yeni ölçüm kaydı ekle (geçmiş kayıtlar korunur):'),
        const SizedBox(height: 16),
        TextField(controller: _weightController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Kilo (kg)')),
        const SizedBox(height: 12),
        TextField(controller: _armController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Kol (cm)')),
        const SizedBox(height: 12),
        TextField(controller: _waistController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Bel (cm)')),
        const SizedBox(height: 12),
        TextField(controller: _bodyFatController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Yağ Oranı (%)')),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: _isSaving ? null : _saveMeasurement,
          child: _isSaving ? const CircularProgressIndicator() : const Text('Kaydet'),
        ),
      ],
    );
  }

  Widget _buildPlanTab() {
    // NOT: Gerçek uygulamada 7 gün x kas grubu seçici (dropdown) matrisi olur.
    return const Center(child: Text('Haftalık antrenman/beslenme programı düzenleyici — yapım aşamasında'));
  }

  Widget _buildNotesTab() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          TextField(
            controller: _noteController,
            maxLines: 3,
            decoration: const InputDecoration(labelText: 'Yeni not / öneri'),
          ),
          const SizedBox(height: 12),
          ElevatedButton(onPressed: _saveNote, child: const Text('Notu Ekle')),
        ],
      ),
    );
  }
}
