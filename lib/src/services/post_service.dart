import 'dart:isolate';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:zona_hub/src/models/post_model.dart';
import 'package:zona_hub/src/models/tag_model.dart';
import 'package:zona_hub/src/models/user_model.dart';
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

  static DocumentReference<Map<String, dynamic>> user = FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid);

  Future<Post> _getPostSettled(DocumentSnapshot<Post> document) async {
    Post post = document.data()!;
    post.authorData = await userService.getUserDataFromDocRef(post.author!);
    post.id = document.id;
    post.authorData!.id = post.author!.id;
    return post;
  }

  Stream<List<Post>> getPosts(
      {PostQuery query = PostQuery.active, List<Tag> tags = const <Tag>[]}) {
    checkPostQueryParams(query: query, tags: tags);

    Stream<List<DocumentSnapshot<Post>>> stream =
        postsRef.queryBy(query: query, tags: tags).snapshots().map((snapshot) {
      return snapshot.docs;
    });

    return stream.asyncMap((List<DocumentSnapshot<Post>> documentList) async {
      List<Post> posts = [];
      for (DocumentSnapshot<Post> document in documentList) {
        Post post = await _getPostSettled(document);
        if (await _thisPostMustBeInactive(post)) continue;
        posts.add(post);
      }
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
            radius: 4,
            field: 'location',
            geopointFrom: (x) => x.location.geopoint);

    return stream.asyncMap((List<DocumentSnapshot<Post>> documentList) async {
      List<Post> posts = [];
      for (DocumentSnapshot<Post> document in documentList) {
        Post post = await _getPostSettled(document);
        UserModel currentUser = await authService.getCurrentUser();
        if (await _thisPostMustBeInactive(post)) continue;
        // if (_thisPostIsAlreadyVoted(post, currentUser)) continue;
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
  Future<void> _setPostInactive(Post post) async {
    await postsRef.doc(post.id).update({'active': false});
  }

  // verify that endDate is after now, if not set the post to inactive
  Future<bool> _thisPostMustBeInactive(Post post) async {
    if (post.endDate.isBefore(DateTime.now()) && post.active) {
      await _setPostInactive(post);
      return true;
    }
    return false;
  }

  // get a list of post by user id
  Stream<List<Post>> getPostsByAuthorId(String authorId) {
    return postsRef
        .where('author',
            isEqualTo:
                FirebaseFirestore.instance.collection('users').doc(authorId))
        .snapshots()
        .asyncMap((snapshot) async {
      final posts = await Future.wait(snapshot.docs.map((doc) async {
        Post post = await _getPostSettled(doc);
        return post;
      }));
      return posts;
    });
  }

  // GET POST BY ID
  Future<Post> getPostById(String id) async {
    final post = await postsRef.doc(id).get();
    return await _getPostSettled(post);
  }

  // up vote a post
  Future<void> upVotePost(String postID) async {
    // get the post
    final post = await getPostById(postID);
    // get the user from the auth service
    final user = await authService.getCurrentUser();
    // verify if the user already up voted the post
    if (post.upVotes!.contains(user.toDocumentReference())) return;
    // verify if the user already down voted the post
    await _ifPostIsDownVotedRemoveDownVote(post, user);
    // add the user to the up votes list
    post.upVotes?.add(user.toDocumentReference());
    // update the post
    await postsRef.doc(post.id).update({'upVotes': post.upVotes});
    // update the user
    await userService.upVotePost(user, post);
  }

  // remove the up vote from a post
  Future<void> removeUpVotePost(String postID) async {
    // get the post
    final post = await getPostById(postID);
    // get the user from the auth service
    final user = await authService.getCurrentUser();
    // verify if the user already up voted the post
    if (!post.upVotes!.contains(user.toDocumentReference())) return;
    // remove the user from the up votes list
    post.upVotes?.remove(user.toDocumentReference());
    // update the post
    await postsRef.doc(post.id).update({'upVotes': post.upVotes});
    // update the user
    await userService.removeUpVotePost(user, post);
  }

  // down vote a post
  Future<void> downVotePost(String postID) async {
    // get the post
    final post = await getPostById(postID);
    // get the user from the auth service
    final user = await authService.getCurrentUser();
    // verify if the user already down voted the post
    if (post.downVotes!.contains(user.toDocumentReference())) return;
    // verify if the user already up voted the post
    await _ifPostIsUpVotedRemoveUpVote(post, user);
    // add the user to the down votes list
    post.downVotes?.add(user.toDocumentReference());
    // update the post
    await postsRef.doc(post.id).update({'downVotes': post.downVotes});
    // update the user
    await userService.downVotePost(user, post);
  }

  // remove the down vote from a post
  Future<void> removeDownVotePost(String postID) async {
    // get the post
    final post = await getPostById(postID);
    // get the user from the auth service
    final user = await authService.getCurrentUser();
    // verify if the user already down voted the post
    if (!post.downVotes!.contains(user.toDocumentReference())) return;
    // remove the user from the down votes list
    post.downVotes?.remove(user.toDocumentReference());
    // update the post
    await postsRef.doc(post.id).update({'downVotes': post.downVotes});
    // update the user
    await userService.removeDownVotePost(user, post);
  }

  Future<void> _ifPostIsUpVotedRemoveUpVote(Post post, UserModel user) async {
    if (post.upVotes!.contains(user.toDocumentReference())) {
      await removeUpVotePost(post.id!);
    }
  }

  Future<void> _ifPostIsDownVotedRemoveDownVote(
      Post post, UserModel user) async {
    if (post.downVotes!.contains(user.toDocumentReference())) {
      await removeDownVotePost(post.id!);
    }
  }

  bool _thisPostIsAlreadyVoted(Post post, UserModel user) {
    if (post.upVotes!.contains(user.toDocumentReference()) ||
        post.downVotes!.contains(user.toDocumentReference())) {
      return true;
    }
    return false;
  }

  static bool ifPostIsAlreadyUpVotedByCurrentUser(Post post)  {
    return post.upVotes!.contains(user);
  }

  static bool ifPostIsAlreadyDownVotedByCurrentUser(Post post)  {
    return post.downVotes!.contains(user);
  }
}
