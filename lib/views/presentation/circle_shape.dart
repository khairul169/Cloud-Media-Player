import 'package:flutter/material.dart';

class CircleShape extends StatelessWidget {
  final double size;
  final Color color;
  final Widget child;

  CircleShape({
    this.size = 24,
    this.color = Colors.white,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(size / 2.0),
      ),
      child: child,
    );
  }
}
