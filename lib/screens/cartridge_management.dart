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
          "Cartridge Management",
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
                  "Base",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                for (int index = 0; index < management.length(); index++)
                if (management.index(index).isBase)
                CartridgeListTile(
                  title: management.index(index).name,
                  onTap: () async {
                    final newData = await showCartridgeDialog(management.index(index));
                    management.updateCartridge(index, newData);
                    setState(() {});
                  },
                  onLongPress: () async {
                    await Get.defaultDialog(
                      title: "Check",
                      middleText: "Really Remove?",
                      textConfirm: "Confirm",
                      onConfirm: () {
                        management.removeCartridge(index);
                        Get.back();
                      },
                      textCancel: "Cancel",
                    );
                    setState(() {});
                  },
                ),
                const SizedBox(height: 30),
                const Text(
                  "Extra",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                for (int index = 0; index < management.length(); index++)
                if (!management.index(index).isBase)
                CartridgeListTile(
                  title: management.index(index).name,
                  onTap: () async {
                    final newData = await showCartridgeDialog(management.index(index));
                    management.updateCartridge(index, newData);
                    setState(() {});
                  },
                  onLongPress: () async {
                    await Get.defaultDialog(
                      title: "Check",
                      middleText: "Really Remove?",
                      textConfirm: "Confirm",
                      onConfirm: () {
                        management.removeCartridge(index);
                        Get.back();
                      },
                      textCancel: "Cancel",
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
          management.addCartridge(data);
          setState(() {});
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

Future<CartridgeData> showCartridgeDialog(CartridgeData data) async {
  final formKey = GlobalKey<FormState>();

  await Get.defaultDialog(
    title: "Cartridge",
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
                const Text("Is Base"),
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
                  return "Please enter something";
                }
                return null;
              },
              decoration: const InputDecoration(
                labelText: "Name",
                hintText: "Cartridge Name",
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
                  return "Please enter something";
                } else if (int.tryParse(value) == null) {
                  return "Please enter the number";
                }
                return null;
              },
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: const InputDecoration(
                labelText: "Min Drops",
                hintText: "Minimum Drops",
                enabledBorder: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      );
    }),
    textConfirm: "Confirm",
    onConfirm: () {
      if (!formKey.currentState!.validate()) {
        return;
      }
      formKey.currentState!.save();
      Get.back();
    },
    textCancel: "Cancel",
  );

  return data;
}
