import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zona_hub/src/models/tag_model.dart';

class TagService {
  final tagRef = FirebaseFirestore.instance
      .collection('tags')
      .withConverter<Tag>(
          fromFirestore: (snapshots, _) =>
              Tag.fromJson(snapshots.data() as Map<String, dynamic>),
          toFirestore: (tag, _) => tag.toJson());

  Stream<List<Tag>> getTags() {
    return tagRef.snapshots().asyncMap((snapshot) async {
      final tags = await Future.wait(snapshot.docs.map((doc) async {
        final tag = doc.data();
        tag.id = doc.id;
        return tag;
      }));
      return tags;
    });
  }

  Future<void> createTag(Tag tag) async {
    await tagRef.add(tag);
  }

  Future<void> updateTag(Tag tag) async {
    await tagRef.doc(tag.id).update(tag.toJson());
  }

  Future<void> deleteTagById(String id) async {
    await tagRef.doc(id).delete();
  }

  DocumentReference getTagDocRefFromId(String id) {
    return tagRef.doc(id);
  }

  Future<Tag> getTagFromId(String id) async {
    DocumentSnapshot doc = await tagRef.doc(id).get();
    Tag fetched = doc.data() as Tag;
    fetched.id = doc.reference.id;
    return fetched;
  }

  Future<Tag> getTagDataFromDocRef(DocumentReference tagRef) async {
    DocumentSnapshot tagSnapshot = await tagRef.get();
    return Tag.fromJson(tagSnapshot.data() as Map<String, dynamic>);
  }

  Future<List<Tag>> getTagsFromDocRefList(
      List<DocumentReference> tagRefs) async {
    List<Tag> tags = [];
    for (DocumentReference tagRef in tagRefs) {
      Tag tag = await getTagDataFromDocRef(tagRef);
      tags.add(tag);
    }
    return tags;
  }
}
