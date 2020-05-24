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
    return Material(
      color: color ?? Colors.transparent,
      borderRadius: BorderRadius.circular(size / 2.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(size / 2.0),
        onTap: onPress,
        child: ActionButtonIcon(
          icon: icon,
          iconSize: iconSize,
          iconColor: iconColor,
          size: size,
        ),
      ),
    );
  }
}

class ActionButtonIcon extends StatelessWidget {
  final IconData icon;
  final double size;
  final double iconSize;
  final Color iconColor;

  const ActionButtonIcon({
    Key key,
    @required this.icon,
    this.size = 48,
    this.iconSize = 20,
    this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      child: Icon(
        icon,
        size: iconSize,
        color: iconColor,
      ),
    );
  }
}
