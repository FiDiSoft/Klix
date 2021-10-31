import 'package:flutter/widgets.dart';
import 'package:kumpulin/db/img_database.dart';

import 'img.dart';

class ImgProvider with ChangeNotifier {
  late Future<List<Img>> _updateImages = ImgDatabase.instance.index();

  Future<List<Img>> get updateImages => _updateImages;

  set updateImages(Future<List<Img>> value) {
    _updateImages = value;
    notifyListeners();
  }
}
