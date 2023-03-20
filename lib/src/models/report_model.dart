import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zona_hub/src/models/report_type_model.dart';
import 'package:zona_hub/src/utils/json_document_reference.dart';
import 'package:zona_hub/src/models/user_model.dart';

class Report {
  Report({
    this.id,
    this.author,
    required this.type,
    this.createdAt,
  });
  Report.fromJson(Map<String, dynamic> json)
      : this(
            id: json['id'] as String? ?? '',
            type: JsonDocumentReference(
              (json['type'] as DocumentReference<Map<String, dynamic>>).path,
            ).toDocumentReference(),
            createdAt: json['createdAt'] as DateTime? ?? DateTime.now(),
            author: JsonDocumentReference(
                    (json['author'] as DocumentReference<Map<String, dynamic>>)
                        .path)
                .toDocumentReference());
  late String? id;
  final DocumentReference<Map<String, dynamic>> type;
  late ReportType typeData;
  final DocumentReference<Map<String, dynamic>>? author;
  late UserModel? authorData;
  late DateTime? createdAt;

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'author': author,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }
}
