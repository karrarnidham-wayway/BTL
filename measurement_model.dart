class MeasurementModel {
  final String id;
  final double weightKg;
  final double? armCm;
  final double? neckCm;
  final double? chestCm;
  final double? waistCm;
  final double? bodyFatPercent;
  final DateTime recordedAt;

  MeasurementModel({
    required this.id,
    required this.weightKg,
    this.armCm,
    this.neckCm,
    this.chestCm,
    this.waistCm,
    this.bodyFatPercent,
    required this.recordedAt,
  });

  factory MeasurementModel.fromJson(Map<String, dynamic> json) {
    return MeasurementModel(
      id: json['id'] as String,
      weightKg: (json['weight_kg'] as num).toDouble(),
      armCm: (json['arm_cm'] as num?)?.toDouble(),
      neckCm: (json['neck_cm'] as num?)?.toDouble(),
      chestCm: (json['chest_cm'] as num?)?.toDouble(),
      waistCm: (json['waist_cm'] as num?)?.toDouble(),
      bodyFatPercent: (json['body_fat_percent'] as num?)?.toDouble(),
      recordedAt: DateTime.parse(json['recorded_at'] as String),
    );
  }
}

class TrainingDayModel {
  final int dayOfWeek; // 1-7
  final String muscleGroup;
  final String? description;

  TrainingDayModel({required this.dayOfWeek, required this.muscleGroup, this.description});

  factory TrainingDayModel.fromJson(Map<String, dynamic> json) {
    return TrainingDayModel(
      dayOfWeek: json['day_of_week'] as int,
      muscleGroup: json['muscle_group'] as String,
      description: json['description'] as String?,
    );
  }
}

class PtNoteModel {
  final String id;
  final String content;
  final DateTime createdAt;

  PtNoteModel({required this.id, required this.content, required this.createdAt});

  factory PtNoteModel.fromJson(Map<String, dynamic> json) {
    return PtNoteModel(
      id: json['id'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}
