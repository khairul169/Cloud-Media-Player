import 'package:audio_service/audio_service.dart';
import 'package:cmp/screens/Home.dart';
import 'package:cmp/services/MediaPlayer.dart';
import 'package:cmp/services/MediaPlayerService.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
    MediaPlayerService.init();
  }

  void initAudioPlayer() async {
    await MediaPlayerService.init();
    MediaPlayerService.setRepeatMode(AudioRepeatMode.All);
  }

  @override
  void dispose() {
    MediaPlayerService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var home = HomeScreen();
    return !kIsWeb ? AudioServiceWidget(child: home) : home;
  }
}
