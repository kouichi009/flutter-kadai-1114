import 'dart:async';

import 'package:flutter/material.dart';
import 'package:instagram_flutter02/models/post.dart';
import 'package:instagram_flutter02/models/user_model.dart';
import 'package:instagram_flutter02/providers/profile_provider.dart';
import 'package:instagram_flutter02/providers/timeline_provider.dart';
import 'package:instagram_flutter02/services/api/post_service.dart';
import 'package:provider/provider.dart';

class LikeReadNotifierProvider extends ChangeNotifier {
  final Post _post;
  final String _currentUid;
  final BuildContext _context;
  final int _index;

  LikeReadNotifierProvider(
      this._post, this._currentUid, this._context, this._index);

  bool _isLiked = false;
  int _likeCount = 0;
  bool _isReadMore = false;
  bool _isShowHeart = false;
  bool isLoading = false;
  late TimelineProvider _timelineProvider;
  late ProfileProvider _profileProvider;

  // bool _isPushingLike = false;
  // bool _isReadMore = false;
  // String _loremIpsum =
  //     'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.';

  bool get isLiked => _isLiked;
  int get likeCount => _likeCount;
  bool get isReadMore => _isReadMore;
  bool get isShowHeart => _isShowHeart;
  ProfileProvider get profileProvider => _profileProvider;

  void init() {
    print(_post.id);
    print(_post.likes?[_currentUid]);
    print(_currentUid);

    _isLiked = _post.likes?[_currentUid] == true;
    _likeCount = _post.likeCount!;
    _timelineProvider = _context.watch<TimelineProvider>();
    _profileProvider = _context.watch<ProfileProvider>();
  }

  void toggleLike() async {
    if (isLoading) return;
    isLoading = true;
    // bool _isLiked = widget.post?.likes[widget.currentUid] == true;
    // if (isPushingLike == false) {
    //   isPushingLike = true;
    if (_isLiked /* && type == 'single'*/) {
      await PostService.unLikePost(_currentUid, _post);
      _likeCount -= 1;
      _isLiked = false;
      // setState(() {
      //   _likeCount -= 1;
      //   _isLiked = false;
      //   // likes[widget.currentUid] = false;
      // });

    } else if (!_isLiked) {
      await PostService.likePost(_currentUid, _post);
      // setState(() {
      _likeCount += 1;
      _isLiked = true;
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
    _isShowHeart = false;
    isLoading = false;

    Map<String, dynamic> _likes = {};
    _likes[_currentUid] = _isLiked;

    _timelineProvider.updatePost(
        index: _index, likes: _likes, likeCount: _likeCount);

    _profileProvider.updatePost(
        index: _index, likes: _likes, likeCount: _likeCount);

    notifyListeners();
  }

  void toggleReadMore() {
    _isReadMore = !_isReadMore;
    print('toggleReadMore@@@@@@@');
    _timelineProvider.updatePost(index: _index, isReadMore: _isReadMore);
    notifyListeners();
  }

  void toggleShowHeart() async {
    if (_isLiked) return;
    _isShowHeart = true;
    notifyListeners();
    toggleLike();
  }
}
