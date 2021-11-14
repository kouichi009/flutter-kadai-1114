import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter02/common_widgets/app_header.dart';
import 'package:instagram_flutter02/common_widgets/post_grid_view.dart';
import 'package:instagram_flutter02/common_widgets/post_view.dart';
import 'package:instagram_flutter02/models/post.dart';
import 'package:instagram_flutter02/models/user_model.dart';
import 'package:instagram_flutter02/providers/profile_provider.dart';
import 'package:instagram_flutter02/screens/edit_profile_screen.dart';
import 'package:instagram_flutter02/screens/home_screen.dart';
import 'package:instagram_flutter02/screens/news_api/news_screen.dart';
import 'package:instagram_flutter02/services/api/post_service.dart';
import 'package:instagram_flutter02/utilities/constants.dart';
import 'package:instagram_flutter02/utilities/themes.dart';
import 'package:instagram_flutter02/utilities/stateful_wrapper.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  String? uid;
  ProfileScreen({this.uid});

  String? currentUid;
  BuildContext? _context;
  ProfileProvider? _profileProvider;
  String postType = '';

  buildProfileHeader() {
    return FutureBuilder(
        future: usersRef.doc(uid).get(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            // return circularProgress();
            return Text('abc');
          }
          UserModel userModel = UserModel.fromDoc(snapshot.data);
          _profileProvider?.userModel = userModel;
          return Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 50.0,
                      backgroundColor: Colors.grey,
                      backgroundImage: CachedNetworkImageProvider(
                          userModel.profileImageUrl!),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text(userModel.name!),
                              Text(
                                  '${userModel.dateOfBirth!['year']}年${userModel.dateOfBirth!['month']}月${userModel.dateOfBirth!['day']}日'),
                              // buildCountColumn("posts", postCount),
                              // buildCountColumn("followers", followerCount),
                              // buildCountColumn("following", followingCount),
                            ],
                          ),
                          if (uid == currentUid)
                            Container(
                              padding: EdgeInsets.only(top: 2.0),
                              child: FlatButton(
                                onPressed: () => goToEditProfile(userModel),
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
        });
  }

  buildPostType() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        IconButton(
          onPressed: () => _profileProvider?.queryUserPosts(uid),
          icon: Icon(Icons.account_circle),
          color: _profileProvider?.postType == MYPOSTS
              ? Theme.of(_context!).primaryColor
              : Colors.grey,
        ),
        IconButton(
          onPressed: () => _profileProvider?.queryLikedPosts(uid),
          icon: Icon(Icons.favorite),
          color: _profileProvider?.postType == FAV
              ? Theme.of(_context!).primaryColor
              : Colors.grey,
        ),
      ],
    );
  }

  goToEditProfile(userModel) async {
    // Navigator.of(_context!).push(
    //   MaterialPageRoute(
    //     builder: (context) {
    //       return ChangeNotifierProvider.value(
    //         value: context.watch<ProfileProvider?>()!..initEditPage(userModel),
    //         child: EditProfileScreen(userModel: userModel),
    //       );
    //     },
    //   ),
    // );

    // _profileProvider!.isLoading = true;
    final result = await Navigator.push(
      _context!,
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(userModel: userModel),
      ),
    );
    print('result: $result');
    if (result == 'updated') {
      _profileProvider?.callNotifiyListners();
    }
  }

  Widget _buildGridPosts() {
    return PostGridView(
        currentUid: currentUid, profileProvider: _profileProvider);
  }

  goToNewsApiPage() {
    Navigator.push(
        _context!, MaterialPageRoute(builder: (context) => NewsScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final authUser = context.watch<User?>();
    currentUid = authUser?.uid;
    // _context = context;
    // _profileProvider = context.watch<ProfileProvider?>();
    return StatefulWrapper(
      onInit: () {
        _context = context;
        _profileProvider = context.watch<ProfileProvider?>();
        _profileProvider?.queryUserPosts(currentUid).then((value) {
          print('Async done');
        });
      },
      child: Scaffold(
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
      ),
    );
  }
}
