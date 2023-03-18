import 'package:cloud_firestore/cloud_firestore.dart';

class JsonDocumentReference {
  final String path;

  JsonDocumentReference(this.path);

  DocumentReference<Map<String, dynamic>> toDocumentReference() {
    return FirebaseFirestore.instance.doc(path);
  }

  Map<String, dynamic> toJson() => {'path': path};
}
