import 'package:cmp/models/media.dart';
import 'package:flutter/material.dart';

class MediaListItem extends StatelessWidget {
  final Media item;
  final VoidCallback onPress;

  const MediaListItem({
    Key key,
    this.item,
    this.onPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onPress,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: SizedBox(
                  width: 64,
                  height: 64,
                  child: Image.network(
                    item.image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(
                width: 16,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(item.title),
                    Text(item.artist),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
