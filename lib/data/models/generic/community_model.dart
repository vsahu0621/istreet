class Community {
  final int id;
  final String name;
  final String description;

  Community({required this.id, required this.name, required this.description});

  factory Community.fromJson(Map<String, dynamic> json) {
    return Community(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }
}
