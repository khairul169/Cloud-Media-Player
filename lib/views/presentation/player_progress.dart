import 'package:cmp/public/utils.dart';
import 'package:flutter/material.dart';

class PlayerProgress extends StatelessWidget {
  final int duration;
  final int position;

  const PlayerProgress({
    Key key,
    this.duration,
    this.position,
  }) : super(key: key);

  double getProgress() {
    return (duration != null && duration != 0) ? (position / duration) : null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                Utils.timeToString(position ~/ 1000),
                style: Theme.of(context).textTheme.subtitle1,
              ),
              Text(
                Utils.timeToString(duration ~/ 1000),
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ],
          ),
          SizedBox(height: 16),
          LinearProgressIndicator(value: getProgress()),
        ],
      ),
    );
  }
}
