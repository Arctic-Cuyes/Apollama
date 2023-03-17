import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zona_hub/src/models/tag_model.dart';

class TagService {
  final tagRef = FirebaseFirestore.instance.collection('tags');

  Stream<List<Tag>> getTags() {
    return tagRef.snapshots().asyncMap((snapshot) async {
      final tags = await Future.wait(snapshot.docs.map((doc) async {
        final tag = Tag.fromJson(doc.data());
        tag.id = doc.id;
        return tag;
      }));
      return tags;
    });
  }

  Future<void> createTag(Tag tag) async {
    await tagRef.add(tag.toJson());
  }

  Future<void> updateTag(Tag tag) async {
    await tagRef.doc(tag.id).update(tag.toJson());
  }

  Future<void> deleteTagById(String id) async {
    await tagRef.doc(id).delete();
  }
}
