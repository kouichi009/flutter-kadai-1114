import 'package:flutter/material.dart';
import 'package:instagram_flutter02/providers/like_read_notifier_provider.dart';

class LikeButton extends StatelessWidget {
  final LikeReadNotifierProvider? likeReadNotifierProvider;

  const LikeButton({
    Key? key,
    this.likeReadNotifierProvider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      style: TextButton.styleFrom(
          primary: likeReadNotifierProvider!.isLiked
              ? Colors.blueAccent.shade700
              : Colors.black),
      icon: Icon(
          likeReadNotifierProvider!.isLiked
              ? Icons.favorite
              : Icons.favorite_border,
          size: 35.0,
          color: Colors.pink),
      label: Text(
        likeReadNotifierProvider!.likeCount.toString(),
        style: TextStyle(fontSize: 16.0, color: Colors.black),
      ),
      onPressed: likeReadNotifierProvider!.toggleLike,
    );
  }
}
