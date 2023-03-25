import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zona_hub/src/models/post_model.dart';
import 'package:zona_hub/src/models/tag_model.dart';
import 'package:zona_hub/src/services/tag_service.dart';

enum PostQuery { all, mine, tags, beforeEndDate, active }

final TagService tagService = TagService();

extension QueryDuplication on Query<Post> {
  Query<Post> queryBy(
      {PostQuery query = PostQuery.all, List<Tag> tags = const <Tag>[]}) {
    checkPostQueryParams(query: query, tags: tags);
    switch (query) {
      case PostQuery.all:
        return this;
      case PostQuery.mine:
        return this.where('author', isEqualTo: 'me'); // TODO: implement
      case PostQuery.tags:
        return this.where('tags', //WARNING: the vs code warning is wrong
            arrayContainsAny: tags
                .map((tag) => tagService.getTagDocRefFromId(tag.id!))
                .toList());
      case PostQuery.beforeEndDate:
        return this.where('endDate',
            isGreaterThanOrEqualTo: DateTime.now().toIso8601String());
      case PostQuery.active:
        return this.where('active', isEqualTo: true);
    }
  }
}

void checkPostQueryParams(
    {PostQuery query = PostQuery.beforeEndDate,
    List<Tag> tags = const <Tag>[]}) {
  if (query == PostQuery.tags && tags.isEmpty) {
    throw ArgumentError('Tags cannot be empty when query is PostQuery.tags');
  }
}
