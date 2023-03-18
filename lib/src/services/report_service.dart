import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zona_hub/src/models/report_model.dart';
import 'package:zona_hub/src/services/report_type_service.dart';
import 'package:zona_hub/src/services/user_service.dart';

class ReportService {
  final reportsRef =
      FirebaseFirestore.instance.collection('reports').withConverter<Report>(
            fromFirestore: (snapshots, _) =>
                Report.fromJson(snapshots.data() as Map<String, dynamic>),
            toFirestore: (report, _) => report.toJson(),
          );
  final reportTypeService = ReportTypeService();
  final userService = UserService();

  Stream<List<Report>> getReports() {
    return reportsRef.snapshots().asyncMap((snapshot) async {
      final reports = await Future.wait(snapshot.docs.map((doc) async {
        final report = doc.data();
        report.id = doc.id;
        report.typeData =
            await reportTypeService.getReportTypeDataFromDocRef(report.type);
        report.typeData.id = report.type.id;
        report.userData = await userService.getUserDataFromDocRef(report.user);

        report.userData!.id = report.user.id;
        return report;
      }));
      return reports;
    });
  }

  Future<void> createReport(Report report) async {
    await reportsRef.add(report);
  }

  Future<void> updateReport(Report report) async {
    await reportsRef.doc(report.id).update(report.toJson());
  }

  Future<void> deleteReportById(String id) async {
    await reportsRef.doc(id).delete();
  }
}
