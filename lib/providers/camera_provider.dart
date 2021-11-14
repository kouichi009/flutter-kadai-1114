import 'dart:io';

import 'package:flutter/material.dart';

class CameraProvider extends ChangeNotifier {
  // dynamic? _lastDocument = null;

  // bool _hasMore = true;
  // bool get hasMore => _hasMore;
  // List<Post> get posts => _posts;
  // List<UserModel> get userModels => _userModels;

  bool _isLoading = false;
  File? _file;

  get isLoading => _isLoading;
  get file => _file;

  void init() {
    // getQueryTimeline();
    // Map<String, dynamic> values = await PostService.queryTimeline(
    //     _documentLimit, _lastDocument, _hasMore);
    // _lastDocument = values['lastDocument'];
    // _posts = [..._posts, ...values['posts']];
    // _userModels = [..._userModels, ...values['userModels']];
    // _hasMore = values['hasMore'];
    // // 'userModels': userModels,
    // // 'hasMore': hasMore,
    // // 'lastDocument': lastDocument,
    // notifyListeners();
  }

  void updateIsLoding(bool boolean) {
    _isLoading = boolean;
    notifyListeners();
  }

  void setFile(File? file) {
    _file = file;
    notifyListeners();
  }

  // void getQueryTimeline() async {
  //   // _lastDocument = lastDocument;
  //   final values = await PostService.queryTimeline(
  //       _documentLimit, _lastDocument, _hasMore);
  //   print(values);
  //   _lastDocument = values['lastDocument'];
  //   _posts = [..._posts, ...values['posts']];
  //   _userModels = [..._userModels, ...values['userModels']];
  //   _hasMore = values['hasMore'];
  //   // 'userModels': userModels,
  //   // 'hasMore': hasMore,
  //   // 'lastDocument': lastDocument,
  //   print('getQueryTimeline()@@@@@@@@@@@@@@@@@@: ${_posts.length}');
  //   for (var i = 0; i < _posts.length; i++) {
  //     bool? isLiked = _posts[i].isLiked;
  //     Map? likes = _posts[i].likes;
  //     String? id = _posts[i].id;
  //     bool? isReadMore = _posts[i].isReadMore;
  //     print('${i}番目: $isLiked, $likes, $id, $isReadMore');
  //     // if (post.id == widget.posts![i].id) {
  //     //   widget.posts!.removeAt(i);
  //     // }
  //   }
  //   notifyListeners();
  // }

}
