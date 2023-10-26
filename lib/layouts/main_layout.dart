import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_app_01/controller/cartridge_controller.dart';
import 'package:test_app_01/controller/configuration_controller.dart';
import 'package:test_app_01/screens/control.dart';
import 'package:test_app_01/screens/home.dart';
import 'package:test_app_01/screens/settings.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> with WidgetsBindingObserver {
  List<Widget> screens = [
    const HomeScreen(),
    const ControlScreen(),
    const SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    
    WidgetsBinding.instance.addObserver(this);
    Get.find<ConfigurationController>().load().then((val) {});
    Get.find<CartridgeController>().load().then((val) {});
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    Get.find<ConfigurationController>().save().then((val) {});
    Get.find<CartridgeController>().save().then((val) {});
  }

  @override
  Widget build(BuildContext context) {
    return GetX<ConfigurationController>(
      init: ConfigurationController(),
      builder: (controller) {
        return Scaffold(
          body: SafeArea(
            child: GetX<ConfigurationController>(
              init: ConfigurationController(),
              builder: (controller) {
                return screens[controller.configuration().screenIndex];
              },
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.tune),
                label: "Control",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: "Settings",
              ),
            ],
            currentIndex: controller.configuration().screenIndex,
            onTap: (int index) => setState(() {
              controller.updateScreenIndex(index);
            }),
          ),
        );
      });
    }
  }
