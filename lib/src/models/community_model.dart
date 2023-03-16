class Community {
  Community({
    this.id,
    required this.name,
    this.description,
  });

  Community.fromJson(Map<String, dynamic> json)
      : this(
          id: json['id'] as String? ?? '',
          name: json['name']! as String,
          description: json['description'] as String? ?? '',
        );

  late String? id;
  final String name;
  final String? description;

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      if (description != null) 'description': description,
    };
  }
}
