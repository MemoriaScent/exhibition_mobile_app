import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_app_01/models/cartridge_data.dart';
import 'package:test_app_01/models/cartridges.dart';

class CartridgeController extends GetxController {
  final cartridges = Cartridges(data: []).obs;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    var dataString = prefs.getString("cartridge");
    if (dataString == null) {
      return;
    }

    final Map<String, dynamic> decode = jsonDecode(dataString);

    cartridges.update((instance) {
      instance?.data.clear();
      for (Map<String, dynamic> json in decode["data"]) {
        instance?.data.add(CartridgeData.fromJsonMap(json));
      }
    });
  }

  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> encode = {};
    encode["data"] = [];

    for (int index = 0; index < cartridges().data.length; index++) {
      encode["data"].add(cartridges().data[index].toJson());
    }

    await prefs.setString("cartridge", jsonEncode(encode));
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
      instance.data.removeAt(prev);
      instance.data.insert(next, temp);
    });
  }
}