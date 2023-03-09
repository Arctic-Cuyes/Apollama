class ReportType {
  ReportType({
    required this.id,
    required this.description,
  });

  ReportType.fromJson(Map<String, Object?> json)
      : this(
          id: json['id']! as String,
          description: json['description']! as String,
        );

  final String id;
  final String description;

  Map<String, Object> toJson() {
    return {
      'id': id,
      'description': description,
    };
  }
}
