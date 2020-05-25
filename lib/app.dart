import 'package:async_redux/async_redux.dart';
import 'package:cmp/states/app_state.dart';
import 'package:cmp/views/screens/main_screen.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  final Store store;

  App({this.store});

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        title: 'Cloud Music Player',
        theme: getTheme(),
        home: MainScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }

  ThemeData getTheme() {
    var theme = ThemeData.dark();
    var textTheme = theme.primaryTextTheme;

    var primary = Color(0xff222222);
    var primaryLight = Color(0xffdddddd);
    var primaryDark = Color(0xff080808);
    var secondary = Colors.blue;
    var bg = Color(0xff202020);
    var scaffoldBg = Color(0xff161616);

    return theme.copyWith(
      brightness: Brightness.dark,
      primaryColor: primary,
      primaryColorLight: primaryLight,
      primaryColorDark: primaryDark,
      accentColor: secondary,
      backgroundColor: bg,
      scaffoldBackgroundColor: scaffoldBg,
      appBarTheme: AppBarTheme(
        color: scaffoldBg,
        elevation: 0,
        textTheme: TextTheme(
          headline6: textTheme.headline6.copyWith(fontSize: 14),
        ),
      ),
      cardTheme: CardTheme(
        color: primaryDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
        elevation: 0,
        margin: EdgeInsets.all(0),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: bg,
        elevation: 0,
      ),
      textTheme: textTheme.copyWith(
        headline1: textTheme.headline1.copyWith(
          fontSize: 28,
          fontWeight: FontWeight.w300,
          color: textTheme.bodyText1.color,
          letterSpacing: 1,
        ),
        headline5: textTheme.headline5.copyWith(fontSize: 24),
        subtitle2: textTheme.subtitle2.copyWith(
          fontSize: 14,
          color: textTheme.subtitle1.color.withOpacity(0.6),
        ),
      ),
    );
  }
}
