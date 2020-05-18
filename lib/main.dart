import 'package:audio_service/audio_service.dart';
import 'package:cmp/services/AudioPlayerTask.dart';
import 'package:flutter/material.dart';
import 'package:cmp/screens/Home.dart';

class App extends StatelessWidget {
  void onAudioService() {
    AudioPlayerTask.startService();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cloud Music Player',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AudioServiceWidget(child: Builder(builder: (context) {
        onAudioService();
        return Home();
      })),
      debugShowCheckedModeBanner: false,
    );
  }
}

void main() {
  runApp(App());
}
