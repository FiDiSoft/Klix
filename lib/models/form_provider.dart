import 'package:flutter/widgets.dart';

class FormProvider with ChangeNotifier {
  bool _isEdit = true;

  bool get isEdit => _isEdit;

  set isEdit(bool isEdit) {
    _isEdit = isEdit;
    notifyListeners();
  }
}
