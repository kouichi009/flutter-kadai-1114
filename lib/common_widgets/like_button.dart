import 'package:flutter/material.dart';
import 'package:instagram_flutter02/models/post.dart';
import 'package:instagram_flutter02/providers/like_read_notifier_provider.dart';
import 'package:instagram_flutter02/providers/post_list_provider.dart';

class LikeButton extends StatelessWidget {
  final PostListProvider? postListProvider;
  final int? index;
  final Post? post;
  final String? currentUid;

  const LikeButton(
      {this.postListProvider, this.index, this.post, this.currentUid});

  @override
  Widget build(BuildContext context) {
    print(currentUid);
    // print(post?.likes?[currentUid]);
    bool isLiked = false;
    if (post?.likes?[currentUid] == true) {
      isLiked = true;
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
    postListProvider!.toggleLike(
        postListProvider: postListProvider,
        index: index,
        post: post,
        currentUid: currentUid);
  }
}
