class User {
  final String name;
  final bool isSubscribed;
  final double revenue;
  final double profit;
  final double adSpend;

  const User({
    required this.name,
    required this.isSubscribed,
    this.revenue = 0,
    this.profit = 0,
    this.adSpend = 0,
  });
}