class Community {
  Community({
    required this.name,
    required this.description,
  });

  Community.fromJson(Map<String, Object?> json)
      : this(
          name: json['name']! as String,
          description: json['description']! as String,
        );

  final String name;
  final String description;

  Map<String, Object> toJson() {
    return {
      'name': name,
      'description': description,
    };
  }
}
