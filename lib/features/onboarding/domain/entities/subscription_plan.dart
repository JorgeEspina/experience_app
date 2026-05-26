enum SubscriptionPlan {
  yearly(
    title: 'Yearly',
    price: '€ 94.80',
    period: 'every year',
    discount: '-66% discount',
    highlighted: true,
  ),
  monthly(
    title: 'Monthly',
    price: '€ 10.90',
    period: 'every month',
    discount: '-53% discount',
    highlighted: false,
  ),
  weekly(
    title: 'Weekly',
    price: '€ 5.90',
    period: 'every week',
    discount: null,
    highlighted: false,
  );

  const SubscriptionPlan({
    required this.title,
    required this.price,
    required this.period,
    required this.discount,
    required this.highlighted,
  });

  final String title;
  final String price;
  final String period;
  final String? discount;
  final bool highlighted;
}
