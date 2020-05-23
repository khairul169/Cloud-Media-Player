import 'package:async_redux/async_redux.dart';
import 'package:cmp/app.dart';
import 'package:cmp/states/app_state.dart';
import 'package:flutter/material.dart';

void main() {
  var state = AppState.initialState();
  var store = Store<AppState>(initialState: state);

  runApp(App(store: store));
}
