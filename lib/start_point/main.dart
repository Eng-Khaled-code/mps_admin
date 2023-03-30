import 'package:finalmpsadmin/firebase_options.dart';
import 'package:finalmpsadmin/provider/search_change.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:finalmpsadmin/provider/user_change.dart';
import 'package:finalmpsadmin/provider/missed_change.dart';
import 'package:finalmpsadmin/provider/chat_change.dart';
import 'package:finalmpsadmin/provider/notify_change.dart';
import 'package:finalmpsadmin/start_point/screen_controller.dart';
import 'package:provider/provider.dart';
import '../PL/utilites/strings.dart';
import '../PL/utilites/themes/app_thems/dark_them_data.dart';
import '../PL/utilites/themes/app_thems/light_them_data.dart';
import '../provider/theme_change.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserChange.initialize()),
        ChangeNotifierProvider(create: (_) => ChatChange.initialize()),
        ChangeNotifierProvider(create: (_) => MissedChange.initialize()),
        ChangeNotifierProvider(create: (_) => SearchChange.initialize()),
        ChangeNotifierProvider(create: (_) => NotifyChange.initialize()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return   Consumer<ThemeProvider>(
        builder: (context, theme, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: Strings.appName,
          themeMode: theme.themeMode == Strings.darkMode
              ? ThemeMode.dark
              : ThemeMode.light,
          theme: lightThemeData(),
          darkTheme: darkThemeData(),
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: ScreenController(),
          ),
        ));
  }
}
