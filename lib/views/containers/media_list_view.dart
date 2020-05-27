import 'dart:async';
import 'package:async_redux/async_redux.dart';
import 'package:cmp/actions/playback.dart';
import 'package:cmp/models/media.dart';
import 'package:cmp/models/playlist.dart';
import 'package:cmp/services/media_storage.dart';
import 'package:cmp/views/presentation/circle_shape.dart';
import 'package:cmp/views/presentation/media_list.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MediaListView extends StatefulWidget {
  final List<Media> items;
  final bool shrinkWrap;
  final int maxItems;
  final Function(int index) onDelete;

  MediaListView({
    Key key,
    @required this.items,
    this.shrinkWrap,
    this.maxItems,
    this.onDelete,
  }) : super(key: key);

  @override
  _MediaListViewState createState() => _MediaListViewState();
}

class _MediaListViewState extends State<MediaListView> {
  final _itemsController = StreamController();

  @override
  void dispose() {
    super.dispose();
    _itemsController.close();
  }

  void onStartMedia(BuildContext context, List<Media> list, int index) {
    // Play media
    var playlist = Playlist(items: list);
    StoreProvider.dispatch(context, SetPlaybackList(playlist, playId: index));
  }

  Future<void> onDownload(int index) async {
    var itemList = widget.items;
    var media = itemList[index].copyWith(waiting: true);

    // Set waiting
    itemList[index] = media;
    _itemsController.add(itemList);

    // Wait for bottom sheet closed
    await Future.delayed(Duration(milliseconds: 500));

    if (media.localPath == null) {
      itemList[index] = await MediaStorage.download(media);
    } else {
      itemList[index] = await MediaStorage.remove(media);
    }

    itemList[index] = itemList[index].copyWith(waiting: false);
    _itemsController.add(itemList);
  }

  @override
  Widget build(BuildContext context) {
    // Update stream items
    _itemsController.add(widget.items);

    return StreamBuilder(
      stream: _itemsController.stream,
      initialData: widget.items,
      builder: (_, snapshot) => buildMediaList(context, snapshot.data),
    );
  }

  Widget buildMediaList(BuildContext context, List<Media> items) {
    var maxItems = widget.maxItems;
    var mediaList = maxItems != null && maxItems < items.length
        ? items.sublist(0, maxItems)
        : items;

    return MediaList(
      items: mediaList,
      shrinkWrap: widget.shrinkWrap,
      onPress: (index) {
        onStartMedia(context, items, index);
      },
      onMenu: (index) {
        var item = items[index];
        showModalBottomSheet(
          context: context,
          builder: (ctx) => Wrap(children: buildItemMenu(ctx, item, index)),
        );
      },
    );
  }

  List<Widget> buildItemMenu(BuildContext ctx, Media item, int index) {
    return [
      Container(
        padding: EdgeInsets.fromLTRB(16, 24, 16, 16),
        child: Column(
          children: [
            Center(
              child: CircleShape(
                size: 64,
                child: item.image != null
                    ? Image.network(item.image, fit: BoxFit.cover)
                    : Icon(Icons.music_note),
              ),
            ),
            SizedBox(height: 16),
            Text(
              item.title ?? '',
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.headline6,
            ),
          ],
        ),
      ),
      ListTile(
        leading: Icon(Icons.favorite_border),
        title: Text('Favorite'),
        onTap: () {
          Navigator.pop(ctx);
        },
      ),
      !kIsWeb
          ? ListTile(
              leading: Icon(Icons.file_download),
              title:
                  Text(item.localPath != null ? 'Remove Download' : 'Download'),
              onTap: () {
                onDownload(index);
                Navigator.pop(ctx);
              },
            )
          : Container(),
      widget.onDelete != null
          ? ListTile(
              leading: Icon(Icons.delete_outline),
              title: Text('Delete'),
              onTap: () {
                widget.onDelete(index);
                Navigator.pop(ctx);
              },
            )
          : Container(),
      SizedBox(height: 8),
    ];
  }
}
