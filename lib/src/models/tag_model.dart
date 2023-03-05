class Tag {
  Tag({required this.name});
  Tag.fromJson(Map<String, Object?> json)
      : this(
          name: json['name']! as String,
        );
  final String name;

  Map<String, Object> toJson() {
    return {
      'name': name,
    };
  }
}
