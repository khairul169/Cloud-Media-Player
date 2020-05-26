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
    return ClipRRect(
      borderRadius: BorderRadius.circular(size / 2.0),
      child: Container(
        width: size,
        height: size,
        color: color,
        child: child,
      ),
    );
  }
}
