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
  UserModel? _userModel;
  TextEditingController _nameController = TextEditingController();
  int? _radioSelected;
  String? _radioVal;
  File? _file;
  String? _profileImageUrl;
  Map<String, String>? _dateOfBirth;
  bool _isLoading = true;

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
    notifyListeners();
  }

  set file(File? file) {
    _file = file;
    notifyListeners();
  }

  void init(String currentUid) async {
    userModel = await AuthService.getUser(currentUid);
  }

  void initEditPage(String currentUid) async {
    userModel = await AuthService.getUser(currentUid);

    _nameController.text = userModel!.name!;
    _profileImageUrl = userModel!.profileImageUrl;
    _dateOfBirth = {
      'year': userModel!.dateOfBirth!['year'],
      "month": userModel!.dateOfBirth!['month'],
      'day': userModel!.dateOfBirth!['day']
    };
    if (userModel!.gender == FEMALE) {
      _radioSelected = 2;
    } else {
      _radioSelected = 1;
    }
    _profileImageUrl = userModel!.profileImageUrl;
    _radioVal = '';
    _file = null;
    _isLoading = false;
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
    notifyListeners();
  }
}
