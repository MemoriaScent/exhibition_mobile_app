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
          const TitleText(title: "기기 제어"),
          Card(
            child: SwitchListTile(
              title: const Text("사용자 인터페이스 잠금"),
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
              title: const Text("카트리지 관리"),
              onTap: () {
                Get.to(const CartridgeManagement());
              },
            )
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.water_drop),
              title: const Text("최대 방울 수 설정"),
              onTap: () {
                int value = conf.configuration().maxDrops;

                Get.defaultDialog(
                  title: "설정하기",
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
                  textConfirm: "확인",
                  onConfirm: () {
                    conf.updateMaxDrops(value);
                    Get.back();
                  },
                  textCancel: "취소",
                );
              },
            )
          ),
          const SizedBox(height: 20),
          const TitleText(title: "초기화"),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () async {
                await Get.defaultDialog(
                  title: "초기화",
                  middleText: "초기화 하시겠습니까?",
                  textConfirm: "확인",
                  onConfirm: () {
                    // reset
                    conf.reset();
                    management.reset();
                    // save
                    Get.find<ConfigurationController>().save().then((val) {});
                    Get.find<CartridgeController>().save().then((val) {});
                    // close confirm
                    Get.back();
                  },
                  textCancel: "취소",
                );
                setState(() {});
              },
              icon: const Icon(Icons.restart_alt),
              label: const Text("모든 설정 초기화"),
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
              label: const Text("설정 저장"),
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
              label: const Text("설정 불러오기"),
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
