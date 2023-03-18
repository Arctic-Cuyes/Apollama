class ReportType {
  ReportType({
    this.id,
    required this.description,
  });

  ReportType.fromJson(Map<String, dynamic> json)
      : this(
          id: json['id'] as String? ?? '',
          description: json['description']! as String,
        );

  late String? id;
  final String description;

  Map<String, dynamic> toJson() {
    return {
      'description': description,
    };
  }
}
