import 'package:flutter/material.dart';
import '../../provider/user_change.dart';
import 'profile_image.dart';

class TopContainer extends StatelessWidget {
  final UserChange? userChange;

  TopContainer({key, this.userChange}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(height: 20.0),
        ImageWidget(userChange: userChange),
        SizedBox(height: 4.0),
        Text("${userChange!.userData!.fName} " +
            "${userChange!.userData!.lName}"),
        Text(
          "${userChange!.userData!.email}",
        ),
      ],
    );
  }
}
