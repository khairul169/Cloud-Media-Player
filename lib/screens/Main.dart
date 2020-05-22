import 'package:async_redux/async_redux.dart';
import 'package:audio_service/audio_service.dart';
import 'package:cmp/actions/PlayerState.dart';
import 'package:cmp/screens/Home.dart';
import 'package:cmp/services/MediaService.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initAudioPlayer();
  }

  void initAudioPlayer() async {
    // Initialize media player service
    await MediaService.init();
    StoreProvider.dispatch(context, OnPlayerInit());
  }

  @override
  void dispose() {
    MediaService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var home = HomeScreen();
    return !kIsWeb ? AudioServiceWidget(child: home) : home;
  }
}
