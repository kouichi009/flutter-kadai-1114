import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter02/models/post.dart';
import 'package:instagram_flutter02/models/user_model.dart';
import 'package:instagram_flutter02/services/api/auth_service.dart';
import 'package:instagram_flutter02/services/api/post_service.dart';
import 'package:instagram_flutter02/utilities/constants.dart';
import 'package:provider/provider.dart';

class ProfileProvider extends ChangeNotifier {
  List<Post>? _posts;
  String? _postType;
  UserModel? _userModel;
  TextEditingController _nameController = TextEditingController();
  int? _radioSelected;
  String? _radioVal;
  File? _file;
  String? _profileImageUrl;
  Map<String, String>? _dateOfBirth;
  bool _isLoading = true;

  List<Post>? get posts => _posts;
  String? get postType => _postType;
  TextEditingController? get nameController => _nameController;
  int? get radioSelected => _radioSelected;
  String? get radioVal => _radioVal;
  File? get file => _file;
  String? get profileImageUrl => _profileImageUrl;
  Map<String, String>? get dateOfBirth => _dateOfBirth;
  bool? get isLoading => _isLoading;

  UserModel? get userModel => _userModel;
  set userModel(UserModel? userModel) {
    _userModel = userModel;
  }

  set file(File? file) {
    _file = file;
    notifyListeners();
  }

  void callNotifiyListners() {
    notifyListeners();
  }

  void initEditPage(UserModel userModel0) async {
    UserModel userModel = await AuthService.getUser(userModel0.uid!);

    _nameController.text = userModel.name!;
    _profileImageUrl = userModel.profileImageUrl;
    _dateOfBirth = {
      'year': userModel.dateOfBirth!['year'],
      "month": userModel.dateOfBirth!['month'],
      'day': userModel.dateOfBirth!['day']
    };
    if (userModel.gender == FEMALE) {
      _radioSelected = 2;
    } else {
      _radioSelected = 1;
    }
    _profileImageUrl = userModel.profileImageUrl;
    _radioVal = '';
    _file = null;
    _isLoading = false;
    notifyListeners();
  }

  queryUserPosts(uid) async {
    List<Post> posts = await PostService.queryUserPosts(uid);
    _posts = posts;
    _postType = MYPOSTS;
    notifyListeners();
  }

  queryLikedPosts(uid) async {
    List<Post> posts = await PostService.queryLikedPosts(uid);
    _posts = posts;
    _postType = FAV;
    notifyListeners();
  }

  updatePost({int? index, Map<String, dynamic>? likes, int? likeCount}) {
    if (_posts == null) return;
    print(_posts);
    print(_posts?.length);
    print(_posts?[index!]);
    print(_posts?[index!].isReadMore);
    if (likes != null) posts![index!].likes = likes;
    if (likeCount != null) posts![index!].likeCount = likeCount;
  }

  deletePost({int? index}) {
    print(_posts?.length);
    _posts?.removeAt(index!);
    print(_posts?.length);
    notifyListeners();
  }

  void updateDateOfBirth(DateTime? datePicked) {
    _dateOfBirth!['year'] = datePicked!.year.toString();
    _dateOfBirth!['month'] = datePicked.month.toString();
    _dateOfBirth!['day'] = datePicked.day.toString();
    notifyListeners();
  }

  void updateGender(value) {
    if (value == 1) {
      _radioSelected = 1;
      _radioVal = MALE;
    } else if (value == 2) {
      _radioSelected = 2;
      _radioVal = FEMALE;
    }
    print(value);
    print('updateGender');
    notifyListeners();
  }
}
