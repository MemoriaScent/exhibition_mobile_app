import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_app_01/controller/cartridge_controller.dart';
import 'package:test_app_01/controller/configuration_controller.dart';
import 'package:test_app_01/layouts/main_layout.dart';

void main() {
  runApp(const TDFZTestApp());
}

class TDFZTestApp extends StatelessWidget {
  const TDFZTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ConfigurationController());
    Get.put(CartridgeController());

    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MainLayout(),
    );
  }
}
