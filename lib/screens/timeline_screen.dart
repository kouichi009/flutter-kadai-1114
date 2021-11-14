import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter02/common_widgets/app_header.dart';
import 'package:instagram_flutter02/common_widgets/post_view.dart';
import 'package:instagram_flutter02/models/post.dart';
import 'package:instagram_flutter02/providers/like_read_notifier_provider.dart';
import 'package:provider/provider.dart';
import 'package:instagram_flutter02/providers/bottom_navigation_bar_provider.dart';
import 'package:instagram_flutter02/providers/post_list_provider.dart';

class TimelineScreen extends StatefulWidget {
  const TimelineScreen({Key? key}) : super(key: key);

  @override
  _TimelineScreenState createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<PostListProvider>(context, listen: false)..init();
    Provider.of<PostListProvider>(context, listen: false).getQueryTimeline();
    print('aaaa!!!!!!!!!!!!!!');
  }

  refresh(PostListProvider? _postListProvider) async {
    _postListProvider?.init();

    Provider.of<PostListProvider>(context, listen: false).getQueryTimeline();
  }

  Widget _buildDisplayPosts(PostListProvider? _postListProvider) {
    return NotificationListener(
      onNotification: (dynamic _onScrollNotification) {
        if (_onScrollNotification is ScrollEndNotification) {
          final before = _onScrollNotification.metrics.extentBefore;
          final max = _onScrollNotification.metrics.maxScrollExtent;
          if (before == max) {
            _postListProvider?.getQueryTimeline();
            return true;
          }
          return false;
        }
        return false;
      },
      child: Column(children: [
        Expanded(
          child: _postListProvider?.posts?.length == 0
              ? Center(
                  child: Text('No Data...'),
                )
              : ListView.builder(
                  itemCount: _postListProvider?.posts?.length,
                  itemBuilder: (context, index) {
                    // Post? pos = _postListProvider?.posts?[index];
                    // print(pos);
                    // parentContext.watch<LikeReadNotifierProvider>()
                    //   ..init(pos, currentUid, parentContext, index);

                    return new GestureDetector(
                      //You need to make my child interactive
                      onTap: () => null,
                      child: PostView(
                          userModel: _postListProvider?.userModels?[index],
                          post: _postListProvider?.posts?[index],
                          index: index,
                          postListProvider: _postListProvider,
                          isDetailPage: false),
                    );
                  },
                ),
        ),
        // _isLoading
        //     ? Container(
        //         width: MediaQuery.of(context).size.width,
        //         padding: EdgeInsets.all(5),
        //         color: Colors.yellowAccent,
        //         child: Text(
        //           'Loading',
        //           textAlign: TextAlign.center,
        //           style: TextStyle(
        //             fontWeight: FontWeight.bold,
        //           ),
        //         ),
        //       )
        //     : Container()
      ]),
    );
  }

  logout() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    PostListProvider? _postListProvider =
        Provider.of<PostListProvider>(context);
    return Scaffold(
        appBar: AppHeader(
            isAppTitle: false,
            titleText: 'タイムラインページ',
            actionWidget: IconButton(
                icon: Icon(Icons.check_circle_outline, color: Colors.black),
                onPressed: () => logout())),
        body: RefreshIndicator(
            onRefresh: () => refresh(_postListProvider),
            child: _buildDisplayPosts(_postListProvider)));
  }
}
