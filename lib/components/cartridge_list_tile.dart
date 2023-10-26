import 'package:flutter/material.dart';

class CartridgeListTile extends StatelessWidget {
  const CartridgeListTile({
    super.key,
    required this.title,
    this.onTap,
    this.onLongPress,
  });

  final String title;
  final void Function()? onTap;
  final void Function()? onLongPress;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(title),
        onTap: onTap,
        onLongPress: onLongPress,
      ),
    );
  }
}
