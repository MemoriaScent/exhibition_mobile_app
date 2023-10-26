import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_app_01/models/configuration.dart';

class ConfigurationController extends GetxController {
  final configuration = Configuration().obs;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    configuration.update((instance) {
      instance?.isLocked = prefs.getBool("isLocked") ?? false;
      instance?.maxDrops = prefs.getInt("maxDrops") ?? 10;
    });
  }

  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isLocked", configuration().isLocked);
    await prefs.setInt("maxDrops", configuration().maxDrops);
  }

  void reset() {
    configuration.update((instance) {
      instance?.isLocked = false;
      instance?.maxDrops = 10;
    });
  }

  void toggleIsLocked() {
    configuration.update((instance) {
      instance?.isLocked = !instance.isLocked;
    });
  }

  void updateMaxDrops(newValue) {
    configuration.update((instance) {
      instance?.maxDrops = newValue;
    });
  }

  void updateScreenIndex(newValue) {
    configuration.update((instance) {
      instance?.screenIndex = newValue;
    });
  }
}
