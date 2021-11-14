import 'package:flutter/material.dart';
import 'package:instagram_flutter02/common_widgets/custom_cached_image.dart';
import 'package:instagram_flutter02/models/post.dart';
import 'package:instagram_flutter02/models/user_model.dart';
import 'package:instagram_flutter02/providers/like_read_notifier_provider.dart';
import 'package:instagram_flutter02/providers/profile_provider.dart';
import 'package:instagram_flutter02/screens/post_detail_screen.dart';
import 'package:instagram_flutter02/services/api/auth_service.dart';
import 'package:instagram_flutter02/utilities/constants.dart';
import 'package:provider/provider.dart';

class PostGridView extends StatelessWidget {
  String? currentUid;
  ProfileProvider? profileProvider;

  PostGridView({this.currentUid, this.profileProvider});

  BuildContext? _context;

  ProfileProvider? _profileProvider;

  @override
  Widget build(BuildContext context) {
    _context = context;
    // return ChangeNotifierProvider<LikeReadNotifierProvider>(
    //   create: (context) =>
    //       LikeReadNotifierProvider(post!, authUser!.uid, _context, index!)
    //         ..init(),
    //   builder: (context, child) {
    //     final likeReadNotifierProvider =
    //         Provider.of<LikeReadNotifierProvider>(context);
    //     return buildProfilePosts();
    //   },
    // );
    return buildProfilePosts();
    // return ChangeNotifierProvider<ProfileProvider>(
    //   create: (context) => ProfileProvider(),
    //   builder: (context, child) {
    //     // _context = context;
    //     _profileProvider = Provider.of<ProfileProvider>(context);
    //     return buildProfilePosts();
    //   },
    // );
  }

  buildProfilePosts() {
    List<GridTile> gridTiles = [];

    profileProvider?.posts?.asMap().forEach((int index, Post post) {
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

  goToDetailPost(
      index, post, LikeReadNotifierProvider likeReadNotifierProvider) async {
    UserModel userModel = await AuthService.getUser(post.uid);
    Navigator.of(_context!).push(
      MaterialPageRoute(
        builder: (context) {
          return ChangeNotifierProvider.value(
            value: likeReadNotifierProvider,
            child: PostDetailScreen(
              post: post,
              userModel: userModel,
              index: index,
            ),
          );
        },
      ),
    );
  }

  PostTile(index, post) {
    return ChangeNotifierProvider<LikeReadNotifierProvider>(
      create: (context) =>
          LikeReadNotifierProvider(post!, currentUid!, _context!, index!)
            ..init(),
      builder: (context, child) {
        final likeReadNotifierProvider =
            Provider.of<LikeReadNotifierProvider>(context);
        return GestureDetector(
          onTap: () => goToDetailPost(index, post, likeReadNotifierProvider),
          child: customCachedImage(post.photoUrl),
        );
      },
    );
  }
}
