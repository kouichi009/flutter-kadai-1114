import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter02/common_widgets/app_header.dart';
import 'package:instagram_flutter02/common_widgets/post_grid_view.dart';
import 'package:instagram_flutter02/common_widgets/post_view.dart';
import 'package:instagram_flutter02/common_widgets/progress.dart';
import 'package:instagram_flutter02/models/post.dart';
import 'package:instagram_flutter02/models/user_model.dart';
import 'package:instagram_flutter02/providers/post_list_provider.dart';
import 'package:instagram_flutter02/providers/profile_provider.dart';
import 'package:instagram_flutter02/screens/edit_profile_screen.dart';
import 'package:instagram_flutter02/screens/home_screen.dart';
import 'package:instagram_flutter02/screens/news_api/news_screen.dart';
import 'package:instagram_flutter02/services/api/post_service.dart';
import 'package:instagram_flutter02/utilities/constants.dart';
import 'package:instagram_flutter02/utilities/themes.dart';
import 'package:instagram_flutter02/utilities/stateful_wrapper.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String currentUid = '';
  PostListProvider? _postListProvider;
  ProfileProvider? _profileProvider;

  @override
  void initState() {
    super.initState();
    final authUser = Provider.of<User>(context, listen: false);
    currentUid = authUser.uid;

    _postListProvider = Provider.of<PostListProvider>(context, listen: false)
      ..init();
    _profileProvider = Provider.of<ProfileProvider>(context, listen: false)
      ..init(currentUid);

    _postListProvider?.queryUserPosts(currentUid);

    print('profileScreen init!!!!!!!!!!!!!!');
  }

  buildProfileHeader() {
    return (_profileProvider == null || _profileProvider?.userModel == null)
        ? circularProgress()
        : Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 50.0,
                      backgroundColor: Colors.grey,
                      backgroundImage: CachedNetworkImageProvider(
                          _profileProvider!.userModel!.profileImageUrl!),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text(_profileProvider!.userModel!.name!),
                              Text(
                                  '${_profileProvider!.userModel!.dateOfBirth!['year']}年${_profileProvider!.userModel!.dateOfBirth!['month']}月${_profileProvider!.userModel!.dateOfBirth!['day']}日'),
                              // buildCountColumn("posts", postCount),
                              // buildCountColumn("followers", followerCount),
                              // buildCountColumn("following", followingCount),
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 2.0),
                            child: FlatButton(
                              onPressed: () =>
                                  goToEditProfile(_profileProvider!.userModel),
                              child: Container(
                                width: 250.0,
                                height: 35.0,
                                child: Text(
                                  'プロフィール編集',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  border: Border.all(
                                    color: Colors.grey,
                                  ),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
  }

  buildPostType() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        IconButton(
          onPressed: () => _postListProvider?.queryUserPosts(currentUid),
          icon: Icon(Icons.account_circle),
          color: _postListProvider?.postType == MYPOSTS
              ? Theme.of(context).primaryColor
              : Colors.grey,
        ),
        IconButton(
          onPressed: () => _postListProvider?.queryLikedPosts(currentUid),
          icon: Icon(Icons.favorite),
          color: _postListProvider?.postType == FAV
              ? Theme.of(context).primaryColor
              : Colors.grey,
        ),
      ],
    );
  }

  goToEditProfile(userModel) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(),
      ),
    );
    print('result: $result');
    if (result == 'updated') {
      // _profileProvider?.callNotifiyListners();
    }
  }

  Widget _buildGridPosts() {
    return PostGridView(
        currentUid: currentUid, postListProvider: _postListProvider);
  }

  goToNewsApiPage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => NewsScreen()));
  }

  @override
  Widget build(BuildContext context) {
    context.watch<PostListProvider>();
    context.watch<ProfileProvider>();

    return Scaffold(
      appBar: AppHeader(
          isAppTitle: false,
          titleText: '${currentUid}',
          actionWidget: IconButton(
              icon: Icon(Icons.check_circle_outline, color: Colors.black),
              onPressed: () => goToNewsApiPage())),
      body: ListView(
        children: <Widget>[
          buildProfileHeader(),
          Divider(),
          buildPostType(),
          _buildGridPosts(),
          // RefreshIndicator(
          //     onRefresh: () => queryPosts(), child: _buildDisplayPosts())
          // PostGridView(posts: []),
        ],
      ),
    );
  }
}
