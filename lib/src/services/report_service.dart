import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zona_hub/src/models/report_model.dart';
import 'package:zona_hub/src/services/Auth/auth_service.dart';
import 'package:zona_hub/src/services/report_type_service.dart';
import 'package:zona_hub/src/services/user_service.dart';

class ReportService {
  final String postId;
  late CollectionReference<Report> reportsRef;
  final AuthService authService = AuthService();

  ReportService({required this.postId}) {
    reportsRef = FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('reports')
        .withConverter<Report>(
          fromFirestore: (snapshots, _) =>
              Report.fromJson(snapshots.data() as Map<String, dynamic>),
          toFirestore: (report, _) => report.toJson(),
        );
  }

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
        report.authorData =
            await userService.getUserDataFromDocRef(report.author!);

        report.authorData!.id = report.author!.id;
        return report;
      }));
      return reports;
    });
  }

  // create report and set the author to the current user
  Future<void> createReport(Report report) async {
    final user = await authService.getCurrentUser();
    report.author = user.toDocumentReference();
    await reportsRef.add(report);
  }

  Future<Report> getReportById(String id) async {
    final report = await reportsRef.doc(id).get();
    return report.data()!;
  }
}
