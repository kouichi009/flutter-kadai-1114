import 'package:flutter/material.dart';
import 'package:instagram_flutter02/common_widgets/custom_cached_image.dart';
import 'package:instagram_flutter02/models/post.dart';
import 'package:instagram_flutter02/models/user_model.dart';
import 'package:instagram_flutter02/providers/post_list_provider.dart';
import 'package:instagram_flutter02/providers/profile_provider.dart';
import 'package:instagram_flutter02/screens/post_detail_screen.dart';
import 'package:instagram_flutter02/services/api/auth_service.dart';
import 'package:instagram_flutter02/utilities/constants.dart';
import 'package:provider/provider.dart';

class PostGridView extends StatelessWidget {
  String? currentUid;
  PostListProvider? postListProvider;

  PostGridView({this.currentUid, this.postListProvider});

  BuildContext? _context;

  ProfileProvider? _profileProvider;

  @override
  Widget build(BuildContext context) {
    _context = context;

    return buildProfilePosts();
  }

  buildProfilePosts() {
    List<GridTile> gridTiles = [];

    postListProvider?.posts?.asMap().forEach((int index, Post post) {
      gridTiles.add(GridTile(child: PostTile(index, post)));
    });
    return GridView.count(
      crossAxisCount: 2,
      childAspectRatio: 1.0,
      mainAxisSpacing: 1.5,
      crossAxisSpacing: 1.5,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: gridTiles,
    );
  }

  goToDetailPost(index, post) async {
    UserModel userModel = await AuthService.getUser(post.uid);
    Navigator.push(
      _context!,
      MaterialPageRoute(
        builder: (context) =>
            PostDetailScreen(post: post, userModel: userModel, index: index),
      ),
    );
  }

  PostTile(index, post) {
    return GestureDetector(
      onTap: () => goToDetailPost(index, post),
      child: customCachedImage(post.photoUrl),
    );
  }
}
