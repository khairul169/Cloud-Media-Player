import 'package:async_redux/async_redux.dart';
import 'package:audio_service/audio_service.dart';
import 'package:cmp/actions/playback.dart';
import 'package:cmp/services/media_service.dart';
import 'package:cmp/views/screens/home_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void didChangeDependencies() {
    // Initialize media service
    MediaService.init().then((_) {
      StoreProvider.dispatch(context, OnPlayerInit());
    });
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    MediaService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Theme.of(context).scaffoldBackgroundColor,
    ));

    var home = HomeScreen();
    return !kIsWeb ? AudioServiceWidget(child: home) : home;
  }
}
