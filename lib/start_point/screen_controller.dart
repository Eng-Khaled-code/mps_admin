import 'package:finalmpsadmin/provider/user_change.dart';
import 'package:finalmpsadmin/start_point/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:finalmpsadmin/PL/home/home_page.dart';
import 'package:provider/provider.dart';

import '../PL/auth/log_in.dart';

class ScreenController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserChange>(context);

    switch (user.status) {
      case Status.Uninitialized:
        return SplashScreen();
      case Status.Authenticating:
      case Status.Unauthenticated:
        return LogIn();
      case Status.Authenticated:
        return HomePage();
      default:
        return SplashScreen();
    }
  }
}
