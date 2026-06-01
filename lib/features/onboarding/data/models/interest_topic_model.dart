import '../../domain/entities/interest_topic.dart';

class InterestTopicModel {
  const InterestTopicModel({
    required this.key,
    required this.label,
  });

  final String key;
  final String label;

  factory InterestTopicModel.fromJson(Map<String, dynamic> json) {
    return InterestTopicModel(
      key: json['key'] as String,
      label: json['label'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'label': label,
    };
  }

  InterestTopic toEntity() {
    return InterestTopic.values.firstWhere(
      (t) => t.name == key,
      orElse: () => InterestTopic.userInterface,
    );
  }

  factory InterestTopicModel.fromEntity(InterestTopic entity) {
    return InterestTopicModel(
      key: entity.name,
      label: entity.label,
    );
  }
}
