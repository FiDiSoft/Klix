import 'package:flutter/foundation.dart';
import 'package:kumpulin/models/img.dart';

class SelectedImgProvider extends ChangeNotifier {
  bool _isSelectable = false;
  List<Img> _listImages = [];

  get listImages => _listImages;
  get isSelectable => _isSelectable;

  set statusSelect(bool status) {
    _isSelectable = status;
    notifyListeners();
  }

  void addAll(List<Img> listImg) {
    _listImages.addAll(listImg);
    notifyListeners();
  }

  void add(Img img) {
    _listImages.add(img);
    notifyListeners();
  }

  void remove(Img img) {
    _listImages.remove(img);
    notifyListeners();
  }

  void removeAll() {
    _listImages.clear();
    notifyListeners();
  }
}
