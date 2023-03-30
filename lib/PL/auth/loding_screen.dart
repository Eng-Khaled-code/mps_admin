import 'package:flutter/material.dart';

import '../utilites/themes/app_colors/dark_colors.dart';
import '../utilites/themes/app_colors/light_colors.dart';

class LoadingScreen extends StatelessWidget {
  final Color? progressColor;

  LoadingScreen({key,this.progressColor=Colors.white}):super(key: key);

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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: progressColor),
            SizedBox(height: 10),
            Text(
              "إنتظر لحظة...",
            )
          ],
        ),
      ),
    );
  }
}
