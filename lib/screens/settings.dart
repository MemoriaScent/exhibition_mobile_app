import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:test_app_01/controller/cartridge_controller.dart';
import 'package:test_app_01/controller/configuration_controller.dart';
import 'package:test_app_01/screens/cartridge_management.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final conf = Get.find<ConfigurationController>();
  final management = Get.find<CartridgeController>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const TitleText(title: "Control"),
          Card(
            child: SwitchListTile(
              title: const Text("Lock user interfaces"),
              value: conf.configuration().isLocked,
              onChanged: (value) {
                setState(() {
                  conf.toggleIsLocked();
                });
              },
              secondary: const Icon(Icons.lock),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.view_list),
              title: const Text("Cartridge Management"),
              onTap: () {
                Get.to(const CartridgeManagement());
              },
            )
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.water_drop),
              title: const Text("Set maximum number of drops"),
              onTap: () {
                int value = conf.configuration().maxDrops;

                Get.defaultDialog(
                  title: "Set Value",
                  content: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
                    return NumberPicker(
                      minValue: 0,
                      maxValue: 50,
                      value: value,
                      onChanged: (newValue) {
                        setState(() {
                          value = newValue;
                        });
                      },
                    );
                  }),
                  textConfirm: "Confirm",
                  onConfirm: () {
                    conf.updateMaxDrops(value);
                    Get.back();
                  },
                  textCancel: "Cancel",
                );
              },
            )
          ),
          const SizedBox(height: 20),
          const TitleText(title: "Reset"),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () async {
                await Get.defaultDialog(
                  title: "Reset",
                  middleText: "Reset all settings",
                  textConfirm: "Confirm",
                  onConfirm: () {
                    conf.reset();
                    management.reset();
                    Get.back();
                  },
                  textCancel: "Cancel",
                );
                setState(() {});
              },
              icon: const Icon(Icons.restart_alt),
              label: const Text("Reset all settings"),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Get.find<ConfigurationController>().save().then((val) {});
                Get.find<CartridgeController>().save().then((val) {});
              },
              icon: const Icon(Icons.save),
              label: const Text("Save"),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Get.find<ConfigurationController>().load().then((val) {});
                Get.find<CartridgeController>().load().then((val) {});
              },
              icon: const Icon(Icons.get_app),
              label: const Text("Load"),
            ),
          ),
        ],
      ),
    );
  }
}

class TitleText extends StatelessWidget {
  const TitleText({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
