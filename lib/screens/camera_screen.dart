import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_flutter02/common_widgets/app_header.dart';
import 'package:instagram_flutter02/common_widgets/progress.dart';
import 'package:instagram_flutter02/providers/bottom_navigation_bar_provider.dart';
import 'package:instagram_flutter02/providers/camera_provider.dart';
import 'package:instagram_flutter02/screens/home_screen.dart';
import 'package:instagram_flutter02/screens/launch_screen.dart';
import 'package:instagram_flutter02/services/api/post_service.dart';
import 'package:uuid/uuid.dart';
import 'package:provider/provider.dart';

class CameraScreen extends StatelessWidget {
  // const CameraScreen({ Key? key }) : super(key: key);
  TextEditingController captionController = TextEditingController();

  String postId = Uuid().v4();
  BuildContext? _context;
  late CameraProvider _cameraProvider;
  late String? currentUid;
  late BottomNavigationBarProvider? _bottomNavigationBar;

  @override
  Widget build(BuildContext context) {
    _context = context;
    _cameraProvider = context.watch<CameraProvider>();
    final User? authUser = context.watch<User?>();
    _bottomNavigationBar = _context!.watch<BottomNavigationBarProvider>();
    currentUid = authUser?.uid;
    return buildUploadForm();
  }

  Scaffold buildUploadForm() {
    return Scaffold(
      appBar: AppHeader(
        isAppTitle: false,
        titleText: '投稿ページ',
      ),
      body: ListView(
        children: <Widget>[
          _cameraProvider.isLoading ? linearProgress() : Text(""),
          GestureDetector(
            onTap: () {
              selectImage();
            },
            child: Container(
              padding: const EdgeInsets.all(5.0),
              height: 220.0,
              // width: MediaQuery.of(context).size.width * 0.8,
              child: Center(
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: (_cameraProvider.file == null)
                      ? (Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                          ),
                          child: Container(
                              child: Center(
                            child: const Text("Containerの枠線"),
                          )),
                        ))
                      : Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.yellow),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: FileImage(_cameraProvider.file),
                              ),
                            ),
                          ),
                        ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.0),
          ),
          Container(
            padding: const EdgeInsets.all(5.0),
            child: TextField(
              maxLines: null,
              controller: captionController,
              decoration: InputDecoration(
                hintText: "ここに本文を入力してください。",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(height: 20.0),
          Container(
            padding: const EdgeInsets.all(35.0),
            height: 130.0,
            child: FlatButton(
              onPressed: _cameraProvider.isLoading ? null : () => upload(),
              color: Colors.orange,
              padding: const EdgeInsets.all(10.0),
              child: Text(
                '投稿',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  selectImage() {
    return showDialog(
      context: _context!,
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

  handleImage(type) async {
    Navigator.pop(_context!);
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
    final File imageTemporary = File(file.path);
    _cameraProvider.setFile(imageTemporary);
  }

  Future<String> uploadImage(imageFile) async {
    final Reference storageRef = FirebaseStorage.instance.ref();
    final storedImage =
        await storageRef.child("post_$postId.jpg").putFile(imageFile);
    final String downloadUrl = await storedImage.ref.getDownloadURL();
    return downloadUrl;
  }

  upload() async {
    print(_cameraProvider);
    _cameraProvider.updateIsLoding(true);

    final downloadUrl = await uploadImage(_cameraProvider.file);
    await PostService.uploadPost(
        postId, currentUid, downloadUrl, captionController.text);
    _cameraProvider.updateIsLoding(false);
    _cameraProvider.setFile(null);

    _bottomNavigationBar!.currentIndex = 0;
    Navigator.pushAndRemoveUntil(
      _context!,
      MaterialPageRoute(builder: (context) => LaunchScreen()),
      (Route<dynamic> route) => false,
    );
  }
}
