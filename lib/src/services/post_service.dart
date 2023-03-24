import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:zona_hub/src/models/post_model.dart';
import 'package:zona_hub/src/models/tag_model.dart';
import 'package:zona_hub/src/services/Auth/auth_service.dart';
import 'package:zona_hub/src/services/Map/gps_service.dart';
import 'package:zona_hub/src/services/tag_service.dart';
import 'package:zona_hub/src/services/user_service.dart';
import 'package:zona_hub/src/utils/post_query.dart';

class PostService {
  final Geoflutterfire _geo = Geoflutterfire();
  final postsRef = FirebaseFirestore.instance
      .collection('posts')
      .withConverter<Post>(
          fromFirestore: (snapshots, _) =>
              Post.fromJson(snapshots.data() as Map<String, dynamic>),
          toFirestore: (post, _) => post.toJson());
  final UserService userService = UserService();
  final AuthService authService = AuthService();
  final TagService tagService = TagService();
  final GpsService gpsService = GpsService();

  Stream<List<Post>> getPosts(
      {PostQuery query = PostQuery.beforeEndDate,
      List<Tag> tags = const <Tag>[]}) {
    checkPostQueryParams(query: query, tags: tags);
    return postsRef
        .queryBy(query: query, tags: tags)
        .snapshots()
        .asyncMap((snapshot) async {
      final posts = await Future.wait(snapshot.docs.map((doc) async {
        final post = doc.data();
        post.authorData = await userService.getUserDataFromDocRef(post.author!);
        post.id = doc.id;
        post.authorData!.id = post.author!.id;
        return post;
      }));
      return posts;
    });
  }

  Stream<List<Post>> getPostsAround(
      {PostQuery query = PostQuery.active,
      List<Tag> tags = const <Tag>[],
      required Position position}) {
    checkPostQueryParams(query: query, tags: tags);

    GeoFirePoint center =
        _geo.point(latitude: position.latitude, longitude: position.longitude);

    Stream<List<DocumentSnapshot<Post>>> stream = _geo
        .collectionWithConverter(
            collectionRef: postsRef.queryBy(query: query, tags: tags))
        .within(
            center: center,
            radius: 100,
            field: 'location',
            geopointFrom: (x) => x.location.geopoint);

    return stream.asyncMap((List<DocumentSnapshot<Post>> documentList) async {
      List<Post> posts = [];
      for (DocumentSnapshot<Post> document in documentList) {
        Post post = document.data()!;
        post.authorData = await userService.getUserDataFromDocRef(post.author!);
        post.id = document.id;
        post.authorData!.id = post.author!.id;
        if (await thisPostMustBeInactive(post)) continue;
        posts.add(post);
      }
      return posts;
    });
  }

  // create a post and set the author to the current user
  Future<void> createPost(Post post) async {
    final user = await authService.getCurrentUser();
    post.author = user.toDocumentReference();
    // set tags to the document reference of the tag
    post.tags = post.tagsData!.map((tag) => tag.toDocumentReference()).toList();

    await postsRef.add(post);
  }

  // set the post to inactive
  Future<void> setPostInactive(Post post) async {
    await postsRef.doc(post.id).update({'active': false});
  }

  // verify that endDate is after now, if not set the post to inactive
  Future<bool> thisPostMustBeInactive(Post post) async {
    if (post.endDate.isBefore(DateTime.now())) {
      await setPostInactive(post);
      print('Post ${post.id} is inactive');
      return true;
    }
    return false;
  }
}
