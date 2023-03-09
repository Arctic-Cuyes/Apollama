class Community {
  Community({
    required this.id,
    required this.name,
    required this.description,
  });

  Community.fromJson(Map<String, Object?> json)
      : this(
          id: json['id']! as String,
          name: json['name']! as String,
          description: json['description']! as String,
        );

  final String id;
  final String name;
  final String description;

  Map<String, Object> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }
}
