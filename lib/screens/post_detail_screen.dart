import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter02/common_widgets/app_header.dart';
import 'package:instagram_flutter02/common_widgets/post_view.dart';
import 'package:instagram_flutter02/models/post.dart';
import 'package:instagram_flutter02/models/user_model.dart';
import 'package:instagram_flutter02/providers/post_list_provider.dart';
import 'package:instagram_flutter02/providers/profile_provider.dart';
import 'package:instagram_flutter02/services/api/post_service.dart';
import 'package:instagram_flutter02/utilities/constants.dart';
import 'package:provider/src/provider.dart';

class PostDetailScreen extends StatelessWidget {
  // const PostDetailScreen({Key? key}) : super(key: key);
  final Post? post;
  final UserModel? userModel;
  final int? index;

  PostDetailScreen({this.post, this.userModel, this.index});

  late ProfileProvider _profileProvider;
  late PostListProvider _postListProvider;

  @override
  Widget build(BuildContext context) {
    final authUser = context.watch<User?>();
    _postListProvider = context.watch<PostListProvider>();

    return Scaffold(
        appBar: AppHeader(
          isAppTitle: false,
          titleText: '詳細ページ',
          actionWidget: authUser?.uid == post?.uid
              ? IconButton(
                  onPressed: () => handleDeletePost(context),
                  icon: Icon(Icons.more_vert),
                )
              : null,
        ),
        body: ListView(
          children: <Widget>[
            PostView(
                userModel: userModel,
                post: post,
                index: index,
                postListProvider: _postListProvider,
                isDetailPage: true),
          ],
        ));
  }

  handleDeletePost(BuildContext parentContext) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            title: Text("Remove this post?"),
            children: <Widget>[
              SimpleDialogOption(
                  onPressed: () {
                    deletePost(context);
                  },
                  child: Text(
                    'Delete',
                    style: TextStyle(color: Colors.red),
                  )),
              SimpleDialogOption(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel')),
            ],
          );
        });
  }

  deletePost(context) async {
    _postListProvider.deletePost(index: index);
    Navigator.pop(context);
    Navigator.pop(context);
  }
}
