class Tag {
  Tag({this.id, required this.name});
  Tag.fromJson(Map<String, dynamic> json)
      : this(
          id: json['id']! as String? ?? '',
          name: json['name']! as String,
        );
  late String? id;
  final String name;

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
    };
  }
}
