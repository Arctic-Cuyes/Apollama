import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zona_hub/src/models/report_type_model.dart';

class ReportTypeService {
  final CollectionReference reportTypesRef =
      FirebaseFirestore.instance.collection('reportTypes');

  Stream<List<ReportType>> getReportTypes() {
    return reportTypesRef.snapshots().asyncMap((snapshot) async {
      final reportTypes = await Future.wait(snapshot.docs.map((doc) async {
        final reportType =
            ReportType.fromJson(doc.data() as Map<String, dynamic>);
        reportType.id = doc.id;
        return reportType;
      }));
      return reportTypes;
    });
  }

  Future<void> createReportType(ReportType reportType) async {
    await reportTypesRef.add(reportType.toJson());
  }

  Future<void> updateReportType(ReportType reportType) async {
    await reportTypesRef.doc(reportType.id).update(reportType.toJson());
  }

  Future<void> deleteReportTypeById(String id) async {
    await reportTypesRef.doc(id).delete();
  }

  Future<ReportType> getReportTypeDataFromDocRef(
      DocumentReference reportTypeRef) async {
    DocumentSnapshot reportTypeSnapshot = await reportTypeRef.get();
    return ReportType.fromJson(
        reportTypeSnapshot.data() as Map<String, dynamic>);
  }
}
