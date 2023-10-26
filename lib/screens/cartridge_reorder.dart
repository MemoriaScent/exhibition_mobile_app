import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_app_01/controller/cartridge_controller.dart';

class CartridgeReorder extends StatefulWidget {
  const CartridgeReorder({super.key});

  @override
  State<CartridgeReorder> createState() => _CartridgeReorderState();
}

class _CartridgeReorderState extends State<CartridgeReorder> {
  final management = Get.find<CartridgeController>();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cartridge Reorder"),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: ReorderableListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return Card(
                key: Key('$index'),
                child: ListTile(
                  title: Text(management.index(index).name),
                  trailing: const Icon(Icons.drag_handle),
                ),
              );
            },
            itemCount: management.length(),
            onReorder: (int prev, int next) {
              setState(() {
                management.reorder(prev, next);
              });
            }
          ),
        ),
      ),
    );
  }
}
