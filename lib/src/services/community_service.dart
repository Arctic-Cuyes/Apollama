import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zona_hub/src/models/community_model.dart';

class CommunityService {
  final communitiesRef = FirebaseFirestore.instance
      .collection('communities')
      .withConverter<Community>(
          fromFirestore: (snapshots, _) =>
              Community.fromJson(snapshots.data() as Map<String, dynamic>),
          toFirestore: (community, _) => community.toJson());

  Stream<List<Community>> getCommunities() {
    return communitiesRef.snapshots().asyncMap((snapshot) async {
      final communities = await Future.wait(snapshot.docs.map((doc) async {
        final community = doc.data();
        community.id = doc.id;
        return community;
      }));
      return communities;
    });
  }

  Future<void> createCommunity(Community community) async {
    await communitiesRef.add(community);
  }

  Future<void> updateCommunity(Community community) async {
    await communitiesRef.doc(community.id).update(community.toJson());
  }

  Future<void> deleteCommunityById(String id) async {
    await communitiesRef.doc(id).delete();
  }
}
