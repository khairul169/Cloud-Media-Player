import 'package:async_redux/async_redux.dart';
import 'package:cmp/actions/playback.dart';
import 'package:cmp/models/media.dart';
import 'package:cmp/models/playlist.dart';
import 'package:cmp/services/offline_media_service.dart';
import 'package:cmp/views/presentation/circle_progress.dart';
import 'package:cmp/views/presentation/media_list_item.dart';
import 'package:flutter/material.dart';

class MediaListView extends StatelessWidget {
  final List<Media> items;
  final Function(int index) onDelete;
  final Function(int index) onUpdate;

  MediaListView({this.items, this.onDelete, this.onUpdate});

  void onStartMedia(BuildContext context, int index) {
    // Play media
    var playlist = Playlist(items: items);
    StoreProvider.dispatch(context, SetPlaylist(playlist, playId: index));
  }

  Future<void> onDownload(int index) async {
    var media = items[index];
    await Future.delayed(Duration(milliseconds: 500));

    if (!media.local) {
      await OfflineMediaService.download(media);
    } else {
      await OfflineMediaService.remove(media);
    }

    // Update media list
    if (onUpdate != null) onUpdate(index);
  }

  @override
  Widget build(BuildContext context) {
    if (items == null) {
      return SizedBox(
        height: 200,
        child: Center(child: CircleProgress(size: 48)),
      );
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: buildMediaListItem,
    );
  }

  Widget buildMediaListItem(BuildContext context, int index) {
    return MediaListItem(
      item: items[index],
      onPress: () {
        onStartMedia(context, index);
      },
      onMenu: () {
        showItemMenu(context, index);
      },
    );
  }

  void showItemMenu(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Wrap(children: getItemMenu(ctx, index)),
    );
  }

  List<Widget> getItemMenu(BuildContext ctx, int index) {
    Media item = items[index];
    return [
      ListTile(
        leading: Icon(Icons.favorite_border),
        title: Text('Mark Favorite'),
        onTap: () {
          Navigator.pop(ctx);
        },
      ),
      ListTile(
        leading: Icon(Icons.file_download),
        title: Text(item.local ? 'Remove Downloaded' : 'Download Media'),
        onTap: () {
          onDownload(index);
          Navigator.pop(ctx);
        },
      ),
      ListTile(
        leading: Icon(Icons.delete_outline),
        title: Text('Delete'),
        onTap: () {
          if (onDelete != null) onDelete(index);
          Navigator.pop(ctx);
        },
      ),
    ];
  }
}
