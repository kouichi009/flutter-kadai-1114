import 'package:flutter/material.dart';
import 'package:instagram_flutter02/models/post.dart';
import 'package:instagram_flutter02/providers/like_read_notifier_provider.dart';

class LikeButton extends StatelessWidget {
  final LikeReadNotifierProvider? likeReadNotifierProvider;
  final int? index;
  final Post? post;
  final String? currentUid;

  const LikeButton(
      {Key? key,
      this.likeReadNotifierProvider,
      this.index,
      this.post,
      this.currentUid})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isLiked = false;
    print(post?.likes?[currentUid]);
    if (post?.likes?[currentUid] == true) {
      isLiked = true;
    } else {
      isLiked = false;
    }
    return TextButton.icon(
      style: TextButton.styleFrom(
          primary: isLiked ? Colors.blueAccent.shade700 : Colors.black),
      icon: Icon(isLiked ? Icons.favorite : Icons.favorite_border,
          size: 35.0, color: Colors.pink),
      label: Text(
        post!.likeCount.toString(),
        style: TextStyle(fontSize: 16.0, color: Colors.black),
      ),
      onPressed: () => toggleLike(),
    );
  }

  toggleLike() {
    likeReadNotifierProvider!.toggleLike(index!, post!);
  }
}
