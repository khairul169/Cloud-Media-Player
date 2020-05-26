import 'dart:async';
import 'package:async_redux/async_redux.dart';
import 'package:cmp/actions/playback.dart';
import 'package:cmp/models/media.dart';
import 'package:cmp/models/playlist.dart';
import 'package:cmp/services/media_storage.dart';
import 'package:cmp/views/presentation/circle_progress.dart';
import 'package:cmp/views/presentation/media_list_item.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MediaListView extends StatefulWidget {
  final List<Media> items;
  final Function(int index) onDelete;

  MediaListView({
    Key key,
    @required this.items,
    @required this.onDelete,
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
    if (widget.items == null) {
      return SizedBox(
        height: 200,
        child: Center(child: CircleProgress(size: 48)),
      );
    }

    if (widget.items.length == 0) {
      return SizedBox(
        height: 48,
        child: Center(child: Text('No Media')),
      );
    }

    // Update stream items
    _itemsController.add(widget.items);

    return StreamBuilder(
      stream: _itemsController.stream,
      initialData: widget.items,
      builder: (_, snapshot) => ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: widget.items.length,
        itemBuilder: (_, i) => buildMediaListItem(context, snapshot.data, i),
      ),
    );
  }

  Widget buildMediaListItem(
    BuildContext context,
    List<Media> items,
    int index,
  ) {
    if (index < 0 || index >= items.length) {
      return Container();
    }

    var item = items[index];
    return MediaListItem(
      item: item,
      onPress: () {
        onStartMedia(context, items, index);
      },
      onMenu: () {
        showItemMenu(context, item, index);
      },
    );
  }

  void showItemMenu(BuildContext context, Media item, int index) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Wrap(
        children: getItemMenu(ctx, item, index),
      ),
    );
  }

  List<Widget> getItemMenu(BuildContext ctx, Media item, int index) {
    return [
      ListTile(
        leading: Icon(Icons.favorite_border),
        title: Text('Mark Favorite'),
        onTap: () {
          Navigator.pop(ctx);
        },
      ),
      !kIsWeb
          ? ListTile(
              leading: Icon(Icons.file_download),
              title: Text(item.localPath != null
                  ? 'Remove Downloaded'
                  : 'Download Media'),
              onTap: () {
                onDownload(index);
                Navigator.pop(ctx);
              },
            )
          : Container(),
      ListTile(
        leading: Icon(Icons.delete_outline),
        title: Text('Delete'),
        onTap: () {
          widget.onDelete(index);
          Navigator.pop(ctx);
        },
      ),
    ];
  }
}
