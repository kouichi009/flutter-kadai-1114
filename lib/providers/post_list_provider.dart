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
    // _lastDocument = lastDocument;
    final values = await PostService.queryTimeline(
        _documentLimit, _lastDocument, _hasMore);
    print(values);
    _lastDocument = values['lastDocument'];
    _posts = [..._posts!, ...values['posts']];
    _userModels = [..._userModels!, ...values['userModels']];
    _hasMore = values['hasMore'];
    // 'userModels': userModels,
    // 'hasMore': hasMore,
    // 'lastDocument': lastDocument,
    print('getQueryTimeline()@@@@@@@@@@@@@@@@@@: ${_posts?.length}');
    // for (var i = 0; i < _posts.length; i++) {
    //   bool? isLiked = _posts[i].isLiked;
    //   Map? likes = _posts[i].likes;
    //   String? id = _posts[i].id;
    //   bool? isReadMore = _posts[i].isReadMore;
    //   print('${i}番目: $isLiked, $likes, $id, $isReadMore');
    //   // if (post.id == widget.posts![i].id) {
    //   //   widget.posts!.removeAt(i);
    //   // }
    // }
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
    print(_posts![index!].likes);
    print(_posts![index].likeCount);
    print(index);
    print(_posts![index].isReadMore);
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
    print('toggleReadMore@@@@@@@');
    updatePost(index: index, post: post);
    notifyListeners();
  }

  void toggleLike(
      {PostListProvider? postListProvider,
      int? index,
      Post? post,
      String? currentUid}) async {
    // return;
    bool isLiked = false;
    isLiked = post?.likes?[currentUid] == true;
    // if (isLoading) return;
    // isLoading = true;
    // bool _isLiked = widget.post?.likes[widget.currentUid] == true;
    // if (isPushingLike == false) {
    //   isPushingLike = true;
    if (isLiked) {
      await PostService.unLikePost(currentUid, post);
      post?.likeCount = post.likeCount! - 1;
      post?.likes![currentUid!] = false;

      // setState(() {
      //   _likeCount -= 1;
      //   _isLiked = false;
      //   // likes[widget.currentUid] = false;
      // });

    } else if (!isLiked) {
      await PostService.likePost(currentUid, post);
      // setState(() {
      post?.likeCount = post.likeCount! + 1;
      post?.likes![currentUid!] = true;
      //   if (type == "double") {
      //     showHeart = true;
      //   }
      // });
      // isLoading = false;
      // notifyListeners();
      // if (type == "double") {
      //   Timer(Duration(milliseconds: 500), () {
      //     // setState(() {
      //     //   showHeart = false;
      //     // });
      //   });
      // }
      // notifyListeners();
    }
    // _isShowHeart = false;
    // isLoading = false;

    // Map<String, dynamic> _likes = {};
    // _likes[_currentUid!] = _isLiked;

    // postListProvider!.updatePost(index: index, post: post!);
    updatePost(index: index, post: post!);

    // _profileProvider.updatePost(
    //     index: _index, likes: _likes, likeCount: _likeCount);

    notifyListeners();
  }

  deletePost({int? index}) {
    print(_posts?.length);
    _posts?.removeAt(index!);
    print(_posts?.length);
    notifyListeners();
  }

  // void toggleShowHeart(
  //     {PostListProvider? postListProvider,
  //     int? index,
  //     Post? post,
  //     String? currentUid}) async {
  //   bool isLiked = false;
  //   isLiked = post?.likes?[currentUid] == true;

  //   if (isLiked) return;
  //   _isShowHeart = true;
  //   notifyListeners();
  //   toggleLike(0, Post());
  // }
}
