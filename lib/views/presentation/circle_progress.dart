import 'package:flutter/material.dart';

class CircleProgress extends StatelessWidget {
  final double size;
  final double width;
  final double value;

  const CircleProgress({
    Key key,
    this.size = 16,
    this.width = 3,
    this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        value: value,
        strokeWidth: width,
      ),
    );
  }
}
