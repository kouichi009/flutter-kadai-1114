import 'package:flutter/material.dart';
import 'package:instagram_flutter02/models/post.dart';
import 'package:instagram_flutter02/models/user_model.dart';
import 'package:instagram_flutter02/services/api/post_service.dart';
import 'package:instagram_flutter02/utilities/constants.dart';

class PostListProvider extends ChangeNotifier {
  List<Post>? _posts = [];
  List<UserModel>? _userModels = [];
  int _documentLimit = 5;
  bool _hasMore = true;
  dynamic _lastDocument = null;
  String? _postType;

  bool get hasMore => _hasMore;
  List<Post>? get posts => _posts;
  List<UserModel>? get userModels => _userModels;
  String? get postType => _postType;

  void init() {
    _posts = [];
    _userModels = [];
    _hasMore = true;
    _lastDocument = null;
    _postType = null;
  }

  void getQueryTimeline() async {
    final values = await PostService.queryTimeline(
        _documentLimit, _lastDocument, _hasMore);
    _lastDocument = values['lastDocument'];
    _posts = [..._posts!, ...values['posts']];
    _userModels = [..._userModels!, ...values['userModels']];
    _hasMore = values['hasMore'];

    notifyListeners();
  }

  queryUserPosts(uid) async {
    List<Post> posts = await PostService.queryUserPosts(uid);
    _posts = posts;
    _postType = MYPOSTS;
    notifyListeners();
  }

  queryLikedPosts(uid) async {
    List<Post> posts = await PostService.queryLikedPosts(uid);
    _posts = posts;
    _postType = FAV;
    notifyListeners();
  }

  updatePost({
    int? index,
    Post? post,
  }) {
    if (_posts == null) return;
    if (post?.isReadMore != null) _posts![index!].isReadMore = post?.isReadMore;
    if (post?.likes != null) _posts![index!].likes = post?.likes;
    if (post?.likeCount != null) _posts![index!].likeCount = post?.likeCount;
  }

  void toggleReadMore(
    int? index,
    Post? post,
  ) {
    bool isReadMore = false;
    if (post?.isReadMore == true) {
      isReadMore = true;
    }
    isReadMore = !isReadMore;
    post?.isReadMore = isReadMore;
    updatePost(index: index, post: post);
    notifyListeners();
  }

  void toggleLike(
      {PostListProvider? postListProvider,
      int? index,
      Post? post,
      String? currentUid}) async {
    bool isLiked = false;
    isLiked = post?.likes?[currentUid] == true;

    if (isLiked) {
      await PostService.unLikePost(currentUid, post);
      post?.likeCount = post.likeCount! - 1;
      post?.likes![currentUid!] = false;
    } else if (!isLiked) {
      await PostService.likePost(currentUid, post);
      post?.likeCount = post.likeCount! + 1;
      post?.likes![currentUid!] = true;
    }

    updatePost(index: index, post: post!);

    notifyListeners();
  }

  deletePost({int? index}) async {
    await PostService.deletePost(_posts?[index!]);
    _posts?.removeAt(index!);
    notifyListeners();
  }
}
