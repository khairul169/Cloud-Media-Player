import 'package:async_redux/async_redux.dart';
import 'package:cmp/screens/Main.dart';
import 'package:cmp/services/AppState.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  final Store reduxStore;

  App({this.reduxStore});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cloud Music Player',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StoreProvider<AppState>(
        store: reduxStore,
        child: MainScreen(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

void main() {
  var state = AppState.initialState();
  var store = Store<AppState>(initialState: state);

  runApp(App(
    reduxStore: store,
  ));
}
