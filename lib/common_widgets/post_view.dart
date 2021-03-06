import 'package:animator/animator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter02/common_widgets/custom_cached_image.dart';
import 'package:instagram_flutter02/common_widgets/like_button.dart';
import 'package:instagram_flutter02/models/post.dart';
import 'package:instagram_flutter02/models/user_model.dart';
import 'package:instagram_flutter02/providers/post_list_provider.dart';
import 'package:instagram_flutter02/screens/post_detail_screen.dart';
import 'package:instagram_flutter02/utilities/constants.dart';
import 'package:instagram_flutter02/utilities/themes.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// LikeReadNotifierProvider? _reUseLikeReadNotifierProvider;

class PostView extends StatelessWidget {
  final UserModel? userModel;
  final Post? post;
  final int? index;
  String? _currentUid;
  PostListProvider? postListProvider;
  final bool? isDetailPage;
  // LikeReadNotifierProvider? parentLikeReadNotifierProvider;

  PostView(
      {this.userModel,
      this.post,
      this.index,
      this.postListProvider,
      this.isDetailPage});

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

  Widget buildText(PostListProvider? postListProvider) {
    int? maxLines;
    TextOverflow? overflow;
    IconData? iconType;
    if (isDetailPage!) {
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
          onTap: () => postListProvider?.toggleReadMore(index, post),
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
    final authUser = parentContext.watch<User?>();
    _currentUid = authUser?.uid;

    return postTile(context);
  }

  doubleTap() {
    if (post?.likes?[_currentUid] == true) return;
    toggleLike();
  }

  toggleLike() {
    postListProvider!.toggleLike(
        postListProvider: postListProvider,
        index: index,
        post: post,
        currentUid: _currentUid);
  }

  Widget postTile(BuildContext context) {
    return InkWell(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          GestureDetector(
            onDoubleTap: () => doubleTap(),
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                customCachedImage(post!.photoUrl!),
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
                          child: buildText(postListProvider),
                        ),
                        Row(
                          children: <Widget>[
                            LikeButton(
                                postListProvider: postListProvider,
                                index: index,
                                post: post,
                                currentUid: _currentUid),
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
        if (isDetailPage!) return;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PostDetailScreen(
                post: post, userModel: userModel, index: index),
          ),
        );
      },
    );
  }
}
