import 'package:flutter/material.dart';

import '../PL/utilites/strings.dart';
import '../PL/utilites/text_style/text_styles.dart';
import '../PL/utilites/themes/app_colors/dark_colors.dart';
import '../PL/utilites/themes/app_colors/light_colors.dart';
import '../PL/utilites/widgets/app_icon.dart';
class SplashScreen extends StatelessWidget {
  const SplashScreen({key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color backColor =
    Theme.of(context).colorScheme.background == Color(0xff90caf9)
        ? LightColors.startsBackground
        : DarkColors.startsBackground;
    return Scaffold(
        backgroundColor: backColor,
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppIcon(
              size: Size(150, 150),
            ),
            SizedBox(height: 10),
            title(),
            SizedBox(height: 25),
            CircularProgressIndicator(
              color: Colors.white,
            )
          ],
        )));
  }

  Text title() => Text(
        Strings.appName,
        textAlign: TextAlign.center,
        style: TextStyles.title,
      );
}
