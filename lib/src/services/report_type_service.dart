import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zona_hub/src/models/report_type_model.dart';

class ReportTypeService {
  final reportTypesRef = FirebaseFirestore.instance
      .collection('reportTypes')
      .withConverter<ReportType>(
        fromFirestore: (snapshots, _) =>
            ReportType.fromJson(snapshots.data() as Map<String, dynamic>),
        toFirestore: (reportType, _) => reportType.toJson(),
      );

  Stream<List<ReportType>> getReportTypes() {
    return reportTypesRef.snapshots().asyncMap((snapshot) async {
      final reportTypes = await Future.wait(snapshot.docs.map((doc) async {
        final reportType = doc.data();
        reportType.id = doc.id;
        return reportType;
      }));
      return reportTypes;
    });
  }

  Future<void> createReportType(ReportType reportType) async {
    await reportTypesRef.add(reportType);
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
