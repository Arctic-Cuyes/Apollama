import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zona_hub/src/models/report_type_model.dart';
import 'package:zona_hub/src/models/utils/json_document_reference.dart';

class Report {
  Report({
    this.id,
    required this.type,
  });
  Report.fromJson(Map<String, dynamic> json)
      : this(
            id: json['id'] as String? ?? '',
            type: JsonDocumentReference(
              (json['type'] as DocumentReference<Map<String, dynamic>>).path,
            ).toDocumentReference());
  late String? id;
  final DocumentReference<Map<String, dynamic>> type;
  late ReportType typeData;

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'type': type,
    };
  }
}
