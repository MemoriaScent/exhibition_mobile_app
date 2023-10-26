import 'package:flutter/material.dart';

class VerticalWithText extends StatefulWidget {
  const VerticalWithText({
    super.key,
    this.child,
    this.label,
  });

  final Widget? child;
  final String? label;

  @override
  State<VerticalWithText> createState() => _VerticalWithTextState();
}

class _VerticalWithTextState extends State<VerticalWithText> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RotatedBox(
          quarterTurns: -1,
          child: widget.child,
        ),
        Text(widget.label ?? ""),
      ],
    );
  }
}
