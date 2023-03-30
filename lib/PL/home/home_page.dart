import 'package:finalmpsadmin/PL/utilites/helper/helper.dart';
import 'package:finalmpsadmin/PL/utilites/widgets/background_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:finalmpsadmin/PL/orders/main_orders/order_about_missing.dart';
import 'package:finalmpsadmin/PL/orders/main_orders/order_about_my_be_missied.dart';
import 'package:finalmpsadmin/provider/user_change.dart';
import 'package:finalmpsadmin/PL/home/custom_chat.dart';
import 'package:finalmpsadmin/PL/chat/chat_list/chat_list.dart';
import 'package:finalmpsadmin/provider/chat_change.dart';
import 'package:provider/provider.dart';
import '../drawer/drawer.dart';
import '../utilites/widgets/custom_alert_dialog.dart';

class HomePage extends StatefulWidget {
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  var _pages = [
    OrdersAboutMissing(responsibility: "main"),
    OrdersAboutMayBeMissed(responsibility: "main"),
  ];

  int currentPage = 0;

  @override
  Widget build(BuildContext context) {

    ChatChange chatChange = Provider.of<ChatChange>(context);
    UserChange user = Provider.of<UserChange>(context);

    return WillPopScope(
      onWillPop: () async {
        showDialog(
            context: context,
            builder: (context) => CustomAlertDialog(
                  title: "تنبيه",
                  onPress: () {
                    SystemNavigator.pop();
                  },
                  text: "هل تريد الخروج من التطبيق بالفعل",
                ));

        return false;
      },
      child: user.userData == null
          ? Material(child: Center(child: CircularProgressIndicator()))
          :Scaffold(
        appBar: AppBar(
          title: Text(
            "الرئيسية",
          ),
         actions:[
                  chatWidget(
                      context: context,
                      userId: user.userData!.id,
                      chatChange: chatChange)
                ],
        ),
        body: Stack(
          children: <Widget>[
           BackgroundImage(),
            _pages[currentPage],
          ],
        ),

        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentPage,
          onTap: (i) {
            setState(() {
              currentPage = i;
            });
          },
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: true,
          iconSize: 27.0,
          selectedFontSize: 12.0,
          showUnselectedLabels: false,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.group),label: "المفقودين"),
            BottomNavigationBarItem(
                icon: Icon(Icons.group), label: "المشكوك في ضياعهم"),
          ],
        ),
        drawer: MyDrawer(),
      ),
    );
  }

  Widget chatWidget(
      {ChatChange? chatChange, BuildContext? context, String? userId}) {
    return CustomChatNotifyWidget(
        icon: CupertinoIcons.chat_bubble_2,
        onPress: () async{
         await chatChange!.loadMyUsersId(userId);

          Helper().goTo(context:context,to: ChatList(
                        userId: userId,
                      ));

          //await chatChange.updateLastDate(userId: userId);
        },
        count: 0);
    // count: chatChange.getRecentMessagesCount);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    UserChange user = Provider.of<UserChange>(context, listen: false);

    switch (state) {
      case AppLifecycleState.paused:
        user.updateConnectStatus(
            connected: "no");
        break;
      case AppLifecycleState.resumed:
        user.updateConnectStatus(
            connected: "yes");
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.detached:
        user.updateConnectStatus(
            connected: "no");
        break;
    }
  }
}
