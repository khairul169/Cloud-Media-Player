import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:cmp/screens/Home/Home.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cloud Music Player',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AudioServiceWidget(child: Home()),
      debugShowCheckedModeBanner: false,
    );
  }
}

void main() {
  runApp(App());
}
