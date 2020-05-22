import 'package:async_redux/async_redux.dart';
import 'package:cmp/states/app_state.dart';
import 'package:cmp/views/screens/main_screen.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  final Store reduxStore;

  App({this.reduxStore});

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: reduxStore,
      child: MaterialApp(
        title: 'Cloud Music Player',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MainScreen(),
        debugShowCheckedModeBanner: false,
      ),
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
