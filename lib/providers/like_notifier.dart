import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter02/models/post.dart';

class LikeNotifier extends ChangeNotifier {
  final Post post;
  LikeNotifier(this.post);

  bool _isLiked = false;

  bool get isLiked => _isLiked;

  // void init() {
  //   // if (post.isLiked != null) {
  //   print(post.id);
  //   print(post.caption);
  //   // _isLiked = true;
  //   // }
  // }

  void toggleLike() {
    _isLiked = !_isLiked;
    // FirebaseFirestore.instance
    //     .collection('blogs')
    //     .doc(post.id)
    //     .update({'is_liked': _isLiked});
    notifyListeners();
  }
}
