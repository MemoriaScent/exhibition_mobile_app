import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_app_01/models/cartridge_data.dart';
import 'package:test_app_01/models/cartridges.dart';

class CartridgeController extends GetxController {
  final cartridges = Cartridges(data: []).obs;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    var dataString = prefs.getString("data");
    if (dataString == null) {
      return;
    }

    final decode = jsonDecode(dataString);
    List<CartridgeData> d = decode is List<CartridgeData> ? decode : [];

    cartridges.update((instance) {
      instance?.data.clear();
      for (CartridgeData i in d) {
        instance?.data.add(i);
      }
    });
  }

  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> dumps = [];
    for (int index = 0; index < cartridges().data.length; index++) {
      dumps.add(jsonEncode(cartridges().data[index]));
    }
    await prefs.setStringList("data", dumps);
  }

  void reset() {
    cartridges.update((instance) {
      instance?.data.clear();
    });
  }

  void addCartridge(CartridgeData data) {
    cartridges.update((instance) {
      if (data.drops < data.minDrops) {
        data.drops = data.minDrops;
      }
      instance?.data.add(data);
    });
  }

  void updateCartridge(int index, CartridgeData data) {
    cartridges.update((instance) {
      instance?.data[index] = data;
      if (instance!.data[index].drops < instance.data[index].minDrops) {
        instance.data[index].drops = instance.data[index].minDrops;
      }
    });
  }

  void removeCartridge(int index) {
    cartridges.update((instance) {
      instance?.data.removeAt(index);
    });
  }

  int sumOfDrops() {
    int result = 0;
    for (int index = 0; index < length(); index++) {
      result += cartridges().data[index].drops;
    }
    return result;
  }

  int length() {
    return cartridges.value.data.length;
  }

  CartridgeData index(int index) {
    return cartridges.value.data[index];
  }

  void reorder(int prev, int next) {
    if (prev < 0) {
      prev = 0;
    }
    if (next >= length()) {
      next = length() - 1;
    }

    cartridges.update((instance) {
      CartridgeData temp = instance!.data[prev];
      instance.data[prev] = instance.data[next];
      instance.data[next] = temp;
    });
  }
}