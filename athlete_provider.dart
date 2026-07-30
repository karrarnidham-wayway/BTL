import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/api_client.dart';
import '../../shared/models/measurement_model.dart';

final myMeasurementsProvider = FutureProvider<List<MeasurementModel>>((ref) async {
  final response = await ApiClient.instance.client.get('/athlete/me/measurements');
  final List data = response.data as List;
  return data.map((json) => MeasurementModel.fromJson(json)).toList()
    ..sort((a, b) => a.recordedAt.compareTo(b.recordedAt));
});

final myTrainingPlanProvider = FutureProvider<List<TrainingDayModel>>((ref) async {
  final response = await ApiClient.instance.client.get('/athlete/me/training-plan');
  final List data = response.data as List;
  return data.map((json) => TrainingDayModel.fromJson(json)).toList();
});

final myNotesProvider = FutureProvider<List<PtNoteModel>>((ref) async {
  final response = await ApiClient.instance.client.get('/athlete/me/notes');
  final List data = response.data as List;
  return data.map((json) => PtNoteModel.fromJson(json)).toList();
});
