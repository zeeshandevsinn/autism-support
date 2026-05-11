

import 'package:flutter/material.dart';

class PasswordProvider with ChangeNotifier {
  bool isHidden = true;

  void toggleVisibility() {
   
    isHidden = !isHidden;
    notifyListeners();
  }
}