import 'package:zona_hub/src/models/report_type_model.dart';

class Report {
  Report({
    required this.id,
    required this.type,
  });
  Report.fromJson(Map<String, Object?> json)
      : this(
          id: json['id']! as String,
          type: json['type']! as ReportType,
        );
  final String id;
  final ReportType type;

  Map<String, Object> toJson() {
    return {
      'id': id,
      'type': type,
    };
  }
}
