import 'dart:io';

import 'package:flutter/material.dart';

class CameraProvider extends ChangeNotifier {
  bool _isLoading = false;
  File? _file;

  get isLoading => _isLoading;
  get file => _file;

  void updateIsLoding(bool boolean) {
    _isLoading = boolean;
    notifyListeners();
  }

  void setFile(File? file) {
    _file = file;
    notifyListeners();
  }
}
