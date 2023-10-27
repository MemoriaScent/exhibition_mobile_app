import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:test_app_01/components/cartridge_list_tile.dart';
import 'package:test_app_01/controller/cartridge_controller.dart';
import 'package:test_app_01/models/cartridge_data.dart';
import 'package:test_app_01/screens/cartridge_reorder.dart';

class CartridgeManagement extends StatefulWidget {
  const CartridgeManagement({super.key});

  @override
  State<CartridgeManagement> createState() => _CartridgeManagementState();
}

class _CartridgeManagementState extends State<CartridgeManagement> {
  final management = Get.find<CartridgeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "카트리지 관리",
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await Get.to(const CartridgeReorder());
              setState(() {});
            },
            icon: const Icon(Icons.reorder),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(width: double.infinity),
                const Text(
                  "기조제",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 10),
                for (int index = 0; index < management.length(); index++)
                if (management.index(index).isBase)
                CartridgeListTile(
                  title: management.index(index).name,
                  onTap: () async {
                    final newData = await showCartridgeDialog(management.index(index));
                    if (newData != null) {
                      management.updateCartridge(index, newData);
                    }
                    setState(() {});
                  },
                  onLongPress: () async {
                    await Get.defaultDialog(
                      title: "삭제",
                      middleText: "삭제 하시겠습니까?",
                      textConfirm: "확인",
                      onConfirm: () {
                        management.removeCartridge(index);
                        Get.back();
                      },
                      textCancel: "취소",
                    );
                    setState(() {});
                  },
                ),
                const SizedBox(height: 30),
                const Text(
                  "첨가제",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 10),
                for (int index = 0; index < management.length(); index++)
                if (!management.index(index).isBase)
                CartridgeListTile(
                  title: management.index(index).name,
                  onTap: () async {
                    final newData = await showCartridgeDialog(management.index(index));
                    if (newData != null) {
                      management.updateCartridge(index, newData);
                    }
                    setState(() {});
                  },
                  onLongPress: () async {
                    await Get.defaultDialog(
                      title: "삭제",
                      middleText: "삭제 하시겠습니까?",
                      textConfirm: "확인",
                      onConfirm: () {
                        management.removeCartridge(index);
                        Get.back();
                      },
                      textCancel: "취소",
                    );
                    setState(() {});
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newData = CartridgeData();
          newData.name += " ${management.length()}";
          final data = await showCartridgeDialog(newData);
          if (data != null) {
            management.addCartridge(data);
          }
          setState(() {});
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

Future<CartridgeData?> showCartridgeDialog(CartridgeData argData) async {
  CartridgeData data = CartridgeData.fromJsonMap(argData.toJson());
  final formKey = GlobalKey<FormState>();
  bool isConfirm = false;

  await Get.defaultDialog(
    title: "카트리지",
    content: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
      return Form(
        key: formKey,
        child: Column(
          children: [
            Row(
              children: [
                Checkbox(
                  value: data.isBase,
                  onChanged: (newValue) {
                    setState(() {
                      data.isBase = newValue ?? !data.isBase;
                    });
                  },
                ),
                const Text("기조제 여부"),
              ],
            ),
            const SizedBox(height: 20),
            TextFormField(
              initialValue: data.name,
              onSaved: (value) {
                data.name = value ?? "";
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "내용을 입력해 주세요";
                }
                return null;
              },
              decoration: const InputDecoration(
                labelText: "이름",
                hintText: "향료 이름",
                enabledBorder: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              initialValue: data.minDrops.toString(),
              onSaved: (value) {
                data.minDrops = int.parse(value ?? "0");
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "내용을 입력해 주세요";
                } else if (int.tryParse(value) == null) {
                  return "숫자를 입력해 주세요";
                }
                return null;
              },
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: const InputDecoration(
                labelText: "최소 방울 수",
                hintText: "최소 방울 수",
                enabledBorder: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      );
    }),
    textConfirm: "확인",
    onConfirm: () {
      if (!formKey.currentState!.validate()) {
        return;
      }
      formKey.currentState!.save();
      isConfirm = true;
      Get.back();
    },
    textCancel: "취소",
  );

  return isConfirm ? data : null;
}
