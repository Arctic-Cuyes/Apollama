class Tag {
  Tag({required this.id, required this.name});
  Tag.fromJson(Map<String, Object?> json)
      : this(
          id: json['id']! as String,
          name: json['name']! as String,
        );
  final String id;
  final String name;

  Map<String, Object> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
