import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_flutter02/common_widgets/app_header.dart';
import 'package:instagram_flutter02/common_widgets/progress.dart';
import 'package:instagram_flutter02/models/user_model.dart';
import 'package:instagram_flutter02/providers/profile_provider.dart';
import 'package:instagram_flutter02/services/api/auth_service.dart';
import 'package:instagram_flutter02/utilities/constants.dart';
import 'package:instagram_flutter02/utilities/stateful_wrapper.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  ProfileProvider? _profileProvider;

  @override
  void initState() {
    super.initState();
    final authUser = Provider.of<User>(context, listen: false);

    _profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    _profileProvider?..initEditPage(authUser.uid);
  }

  buildProfileHeader() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              CircleAvatar(
                radius: 50.0,
                backgroundColor: Colors.grey,
                backgroundImage: getBackgroundImage(),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(top: 2.0),
                      child: FlatButton(
                        onPressed: () => selectImage(),
                        child: Container(
                          width: 250.0,
                          height: 35.0,
                          child: Text(
                            '????????????',
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

  selectImage() {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text("Create Post"),
          children: <Widget>[
            SimpleDialogOption(
                child: Text("Photo with Camera"),
                onPressed: () => handleImage('camera')),
            SimpleDialogOption(
                child: Text("Image from Gallery"),
                onPressed: () => handleImage('gallery')),
            SimpleDialogOption(
              child: Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            )
          ],
        );
      },
    );
  }

  getBackgroundImage() {
    if (_profileProvider?.file != null) {
      return FileImage(_profileProvider!.file!);
    } else if (_profileProvider?.profileImageUrl != null) {
      return CachedNetworkImageProvider(_profileProvider!.profileImageUrl!);
    }
  }

  handleImage(type) async {
    Navigator.pop(context);
    ImageSource imageSource;
    if (type == 'camera') {
      imageSource = ImageSource.camera;
    } else {
      imageSource = ImageSource.gallery;
    }

    final ImagePicker _picker = ImagePicker();
    // Pick an image
    final XFile? file = await _picker.pickImage(source: imageSource);
    if (file == null) return;
    final imageTemporary = File(file.path);
    _profileProvider?.file = imageTemporary;
  }

  Future<String> uploadImage(imageFile) async {
    final Reference storageRef = FirebaseStorage.instance.ref();
    final storedImage = await storageRef
        .child("post_${_profileProvider?.userModel?.uid}.jpg")
        .putFile(imageFile);
    final String downloadUrl = await storedImage.ref.getDownloadURL();
    return downloadUrl;
  }

  updateProfile() async {
    String? downloadUrl = _profileProvider!.profileImageUrl;
    if (_profileProvider!.file != null) {
      downloadUrl = await uploadImage(_profileProvider!.file);
    }
    String gender = _profileProvider!.radioSelected == 1 ? MALE : FEMALE;
    await usersRef.doc(_profileProvider?.userModel?.uid).update({
      'dateOfBirth': _profileProvider!.dateOfBirth,
      'gender': gender,
      'name': _profileProvider!.nameController!.text,
      'profileImageUrl': downloadUrl,
    });

    UserModel userModel = _profileProvider!.userModel!;
    userModel.dateOfBirth = _profileProvider!.dateOfBirth;
    userModel.gender = gender;
    userModel.name = _profileProvider!.nameController!.text;
    userModel.profileImageUrl = downloadUrl;

    _profileProvider!.userModel = userModel;

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    context.watch<ProfileProvider>();
    return Scaffold(
      appBar: AppHeader(
        isAppTitle: false,
        titleText: '??????????????????????????????',
      ),
      body: (_profileProvider == null || _profileProvider!.isLoading!)
          ? circularProgress()
          : ListView(
              children: <Widget>[
                buildProfileHeader(),
                Container(
                  padding: const EdgeInsets.all(20.0),
                  child: TextField(
                    controller: _profileProvider!.nameController,
                    decoration: InputDecoration(
                      hintText: "?????????????????????????????????",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    var datePicked = await DatePicker.showSimpleDatePicker(
                      context,
                      initialDate: DateTime(1994),
                      firstDate: DateTime(1960),
                      lastDate: DateTime(2020),
                      dateFormat: "dd-MMMM-yyyy",
                      locale: DateTimePickerLocale.jp,
                      looping: true,
                    );
                    _profileProvider?.updateDateOfBirth(datePicked);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(20.0),
                    height: 100.0,
                    // width: MediaQuery.of(context).size.width * 0.8,
                    child: Center(
                        child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                      ),
                      child: Container(
                          child: Center(
                        child: Text(
                            '${_profileProvider!.dateOfBirth!['year']}???${_profileProvider!.dateOfBirth!['month']}???${_profileProvider!.dateOfBirth!['day']}???'),
                      )),
                    )),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('???'),
                    Radio(
                      value: 1,
                      groupValue: _profileProvider!.radioSelected!,
                      activeColor: Colors.blue,
                      onChanged: (value) {
                        _profileProvider?.updateGender(value);
                      },
                    ),
                    Text('???'),
                    Radio(
                      value: 2,
                      groupValue: _profileProvider!.radioSelected!,
                      activeColor: Colors.pink,
                      onChanged: (value) {
                        _profileProvider?.updateGender(value);
                      },
                    )
                  ],
                ),
                Container(
                  padding: EdgeInsets.only(top: 20.0),
                  child: FlatButton(
                    onPressed: () => updateProfile(),
                    child: Container(
                      width: 280.0,
                      height: 40.0,
                      child: Text(
                        '???????????????',
                        style: TextStyle(
                          color: true ? Colors.black : Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: true ? Colors.blue : Colors.blue,
                        border: Border.all(
                          color: true ? Colors.grey : Colors.blue,
                        ),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                  ),
                )
              ],
            ),
    );
  }
}
