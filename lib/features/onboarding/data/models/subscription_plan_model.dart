import '../../domain/entities/subscription_plan.dart';

class SubscriptionPlanModel {
  const SubscriptionPlanModel({
    required this.key,
    required this.title,
    required this.price,
    required this.period,
    this.discount,
    this.highlighted = false,
  });

  final String key;
  final String title;
  final String price;
  final String period;
  final String? discount;
  final bool highlighted;

  factory SubscriptionPlanModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlanModel(
      key: json['key'] as String,
      title: json['title'] as String,
      price: json['price'] as String,
      period: json['period'] as String,
      discount: json['discount'] as String?,
      highlighted: json['highlighted'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'title': title,
      'price': price,
      'period': period,
      'discount': discount,
      'highlighted': highlighted,
    };
  }

  SubscriptionPlan toEntity() {
    return SubscriptionPlan.values.firstWhere(
      (p) => p.name == key,
      orElse: () => SubscriptionPlan.yearly,
    );
  }

  factory SubscriptionPlanModel.fromEntity(SubscriptionPlan entity) {
    return SubscriptionPlanModel(
      key: entity.name,
      title: entity.title,
      price: entity.price,
      period: entity.period,
      discount: entity.discount,
      highlighted: entity.highlighted,
    );
  }
}
