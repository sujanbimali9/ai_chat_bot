import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class Pref {
  static late Box _box;
  static Future<void> initialize() async {
    Hive.defaultDirectory = (await getApplicationDocumentsDirectory()).path;
    _box = Hive.box(name: 'myData');
  }

  static bool get showOnBoarding =>
      _box.get('showOnBoardnig', defaultValue: true);
  static set showOnBoarding(bool value) => _box.put('showOnBoardnig', value);
}
