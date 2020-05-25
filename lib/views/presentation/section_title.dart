import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final VoidCallback onMore;

  const SectionTitle({Key key, this.title, this.onMore}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: EdgeInsets.only(left: 16),
            child: Text(title, style: Theme.of(context).textTheme.headline6),
          ),
          (onMore != null)
              ? InkWell(
                  onTap: onMore,
                  child: Container(
                    height: 48,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Center(child: Text('MORE')),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
