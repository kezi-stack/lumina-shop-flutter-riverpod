class Profile {
  const Profile({
    required this.name,
    required this.email,
    required this.initials,
    required this.ordersCount,
    required this.points,
  });

  final String name;
  final String email;
  final String initials;
  final int ordersCount;
  final int points;
}