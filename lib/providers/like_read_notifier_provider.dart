import 'dart:async';

import 'package:flutter/material.dart';
import 'package:instagram_flutter02/models/post.dart';
import 'package:instagram_flutter02/models/user_model.dart';
import 'package:instagram_flutter02/providers/post_list_provider.dart';
import 'package:instagram_flutter02/providers/profile_provider.dart';
import 'package:instagram_flutter02/providers/timeline_provider.dart';
import 'package:instagram_flutter02/services/api/post_service.dart';
import 'package:provider/provider.dart';

class LikeReadNotifierProvider extends ChangeNotifier {
  bool isLoading = false;
  late TimelineProvider _timelineProvider;
  late ProfileProvider _profileProvider;

  // bool get isLiked => _isLiked;
  // int get likeCount => _likeCount;
  // bool get isReadMore => _isReadMore;
  // bool get isShowHeart => _isShowHeart;
  // ProfileProvider get profileProvider => _profileProvider;

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
    isLoading = false;

    // Map<String, dynamic> _likes = {};
    // _likes[_currentUid!] = _isLiked;

    postListProvider!.updatePost(index: index, post: post!);

    // _profileProvider.updatePost(
    //     index: _index, likes: _likes, likeCount: _likeCount);

    notifyListeners();
  }

  // void toggleReadMore() {
  //   _isReadMore = !_isReadMore;
  //   print('toggleReadMore@@@@@@@');
  //   _timelineProvider.updatePost(index: _index, post: Post());
  //   notifyListeners();
  // }

  // void toggleShowHeart() async {
  //   if (_isLiked) return;
  //   _isShowHeart = true;
  //   notifyListeners();
  //   toggleLike(0, Post());
  // }
}
