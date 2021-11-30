import 'package:flutter/material.dart';

class CheckedProvider with ChangeNotifier {
  bool _isCheckedHome = false;
  bool _isCheckedDetail = false;

  bool get isCheckedHome => _isCheckedHome;

  set isCheckedHome(bool value) {
    _isCheckedHome = value;
    notifyListeners();
  }

  bool get isCheckedDetail => _isCheckedDetail;

  set isCheckedDetail(bool value) {
    _isCheckedDetail = value;
    notifyListeners();
  }
}
