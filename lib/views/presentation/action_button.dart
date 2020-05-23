import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final IconData icon;
  final double size;
  final double iconSize;
  final Color color;
  final Color iconColor;
  final VoidCallback onPress;

  const ActionButton({
    Key key,
    @required this.icon,
    this.size = 48,
    this.iconSize = 20,
    this.color,
    this.iconColor,
    @required this.onPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(size / 2.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(size / 2.0),
        onTap: onPress,
        child: Container(
          width: size,
          height: size,
          color: color,
          child: Icon(
            icon,
            size: iconSize,
            color: iconColor,
          ),
        ),
      ),
    );
  }
}
