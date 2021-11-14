import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SelectImageDialog {
  static selectImage(context) {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text("Create Post"),
          children: <Widget>[
            SimpleDialogOption(
                child: Text("Photo with Camera"),
                onPressed: () => handleImage(context, 'camera')),
            SimpleDialogOption(
                child: Text("Image from Gallery"),
                onPressed: () => handleImage(context, 'gallery')),
            SimpleDialogOption(
              child: Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            )
          ],
        );
      },
    );
  }

  static handleImage(context, type) async {
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
    return imageTemporary;
    // setState(() {
    //   this.file = imageTemporary;
    // });
  }

  // @override
  // Widget build(BuildContext context) {
  //   return selectImage(context);
  // }
}
