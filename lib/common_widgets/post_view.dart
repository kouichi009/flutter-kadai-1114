import 'package:animator/animator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter02/common_widgets/custom_cached_image.dart';
import 'package:instagram_flutter02/common_widgets/like_button.dart';
import 'package:instagram_flutter02/models/post.dart';
import 'package:instagram_flutter02/models/user_model.dart';
import 'package:instagram_flutter02/providers/like_read_notifier_provider.dart';
import 'package:instagram_flutter02/screens/post_detail_screen.dart';
import 'package:instagram_flutter02/utilities/constants.dart';
import 'package:instagram_flutter02/utilities/themes.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

LikeReadNotifierProvider? _reUseLikeReadNotifierProvider;

class PostView extends StatelessWidget {
  final UserModel? userModel;
  final Post? post;
  final int? index;
  LikeReadNotifierProvider? parentLikeReadNotifierProvider;

  PostView(
      {this.userModel,
      this.post,
      this.index,
      this.parentLikeReadNotifierProvider});

  ChangeNotifierProvider? changeNotifierProvider;
  bool isDetailPage = false;

  handleLikePost({type, post, postViewProvider, currentUid}) async {
    // final authUser = context.read<User?>();
    postViewProvider.handleLikePost(
        type: type, currentUid: currentUid, post: post);
  }

  goToProfilePage() {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //       builder: (context) => ProfileScreen(uid: widget.post?.uid)),
    // );
  }

  Widget buildText(LikeReadNotifierProvider likeReadNotifierProvider) {
    int? maxLines;
    TextOverflow? overflow;
    IconData? iconType;
    if (isDetailPage) {
      maxLines = null;
      overflow = TextOverflow.visible;
      iconType = null;
    } else if (post!.isReadMore == true) {
      maxLines = null;
      overflow = TextOverflow.visible;
      iconType = Icons.expand_less;
    } else if (post!.isReadMore == null || post!.isReadMore == false) {
      maxLines = 2;
      overflow = TextOverflow.ellipsis;
      iconType = Icons.expand_more;
    }

    return Row(
      children: <Widget>[
        Expanded(
            child: Text(
          post!.caption!,
          maxLines: maxLines,
          overflow: overflow,
          style: TextStyle(fontSize: 16),
        )),
        GestureDetector(
          onTap: () => likeReadNotifierProvider.toggleReadMore(),
          child: Icon(
            iconType,
            size: 35.0,
          ),
        ),
      ],
    );
    // );
  }

  @override
  Widget build(BuildContext context) {
    BuildContext parentContext = context;
    // return Text('Post view!!');
    // PostViewProvider postViewProvider = context.watch<PostViewProvider>();
    final authUser = parentContext.watch<User?>();

    if (parentLikeReadNotifierProvider == null &&
        _reUseLikeReadNotifierProvider != null) {
      parentLikeReadNotifierProvider = _reUseLikeReadNotifierProvider;
    } else if (parentLikeReadNotifierProvider != null) {
      isDetailPage = true;
      return postTile(context, parentLikeReadNotifierProvider!);
    }
    return ChangeNotifierProvider<LikeReadNotifierProvider>(
      create: (context) =>
          LikeReadNotifierProvider(post!, authUser!.uid, parentContext, index!)
            ..init(),
      builder: (context, child) {
        final likeReadNotifierProvider =
            Provider.of<LikeReadNotifierProvider>(context);
        return postTile(context, likeReadNotifierProvider);
      },
    );
  }

  Widget postTile(
      BuildContext context, LikeReadNotifierProvider likeReadNotifierProvider) {
    return InkWell(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        // mainAxisAlignment: MainAxisAlignment.start,

        children: <Widget>[
          // LikeButton(likeNotifier: likeNotifier),

          GestureDetector(
            onDoubleTap: () => likeReadNotifierProvider.toggleShowHeart(),
            // handleLikePost(
            //     type: 'double',
            //     post: post,
            //     // postViewProvider: postViewProvider,
            //     currentUid: authUser?.uid),
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                // height: MediaQuery.of(context).size.width,
                customCachedImage(post!.photoUrl!),
                if (likeReadNotifierProvider.isShowHeart)
                  Animator(
                    duration: Duration(milliseconds: 300),
                    tween: Tween(begin: 0.8, end: 1.4),
                    curve: Curves.elasticOut,
                    cycles: 0,
                    builder: (context, anim, child) => Transform.scale(
                      scale: anim.controller.value,
                      child: Icon(
                        Icons.favorite,
                        size: 80.0,
                        color: Colors.red,
                      ),
                    ),
                  )
              ],
            ),
          ),
          Container(
            child: ListTile(
              leading: GestureDetector(
                onTap: () => goToProfilePage(),
                child: CircleAvatar(
                  backgroundColor: Colors.grey,
                  backgroundImage: CachedNetworkImageProvider(
                    userModel!.profileImageUrl!,
                  ),
                ),
              ),
              title: GestureDetector(
                onTap: () => goToProfilePage(),
                child: Row(
                  children: [
                    Text(
                      userModel!.name!,
                      style: kFontSize18FontWeight600TextStyle,
                    ),
                  ],
                ),
              ),
              trailing: Text(
                DateFormat("yyyy/MM/dd")
                    .format(post!.timestamp!.toDate())
                    .toString(),
                style: TextStyle(fontSize: 16.0, color: Colors.black),
              ),
            ),
          ),

          Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(
                    top: 40.0,
                    left: 20.0,
                  )),
                  Flexible(
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(5.0),
                          child: buildText(likeReadNotifierProvider),
                        ),
                        Row(
                          children: <Widget>[
                            LikeButton(
                                likeReadNotifierProvider:
                                    likeReadNotifierProvider),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      onTap: () async {
        if (isDetailPage) return;
        LikeReadNotifierProvider result = await Navigator.of(context).push(
          // MaterialPageRoute(
          //     builder: (context) => PostDetailScreen(
          //           post: post,
          //           userModel: userModel,
          //           index: index,
          //         )),
          MaterialPageRoute(
            builder: (context) {
              // return BlogPage(blogPost: post);
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
        LikeReadNotifierProvider likeread = result;
        _reUseLikeReadNotifierProvider = likeread;
        print('result: $_reUseLikeReadNotifierProvider!!!!!!@@@@@@@@@@@');
      },
    );
  }
}
