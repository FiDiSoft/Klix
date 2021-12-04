import 'package:kumpulin/db/img_database.dart';
import 'package:kumpulin/models/img.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Check {
  Future<bool> getCheck() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getBool('homeKey') ?? false;
  }

  void setCheck(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('homeKey', value);
  }

  Future<Set<String>> getShared() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getKeys();
  }

  void destroyShared() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Img>? _imgList = await ImgDatabase.instance.index();

    for (var item in _imgList) {
      prefs.remove('${item.id}key');
    }
  }

  // Future<bool> getCheckDetail(int index) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   final db = await ImgDatabase.instance.index();

  //   return prefs.getBool('${db[index].id}key') ?? false;
  // }

  // void setCheckDetail(bool value, int index) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   final db = await ImgDatabase.instance.index();

  //   prefs.setBool('${db[index].id}key', value);
  // }
}
