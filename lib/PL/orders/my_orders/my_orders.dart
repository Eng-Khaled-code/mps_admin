import 'package:finalmpsadmin/PL/orders/main_orders/order_about_missing.dart';
import 'package:finalmpsadmin/PL/orders/main_orders/order_about_my_be_missied.dart';
import 'package:finalmpsadmin/PL/utilites/widgets/background_image.dart';
import 'package:flutter/material.dart';

class MyOrdersPage extends StatefulWidget {
  _MyOrdersPageState createState() => _MyOrdersPageState();
}

List<String> choices = ["الكل", "إنتظار", "مقبول", "مرفوض"];

class _MyOrdersPageState extends State<MyOrdersPage> {
  String selectedItem = choices[0];

  int currentPage = 0;

  var _pages;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    _pages = [
      OrdersAboutMissing(responsibility: selectedItem),
      OrdersAboutMayBeMissed(responsibility: selectedItem),
    ];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Text("انت مسئول عن هذه الطلبات",),
          actions: [
            Center(child: Text(selectedItem, style: TextStyle(color: Colors.white, fontSize: 12))),
            popUpMenuWidget(),
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
          selectedItemColor: Colors.pink,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.group), label: "المفقودين"),
            BottomNavigationBarItem(
                icon: Icon(Icons.group), label: "المشكوك في ضياعهم"),
          ],
        ),
      ),
    );
  }

   popUpMenuWidget() {
    return PopupMenuButton(
        icon: Icon(Icons.arrow_drop_down),
        elevation: 3.2,
        initialValue: selectedItem,
        tooltip: 'فرز بواسطة',
        onSelected: (String choice) {
          setState(() {
            selectedItem = choice;
          });
        },
        itemBuilder: (BuildContext context) {
          return choices.map((String choice) {
            return PopupMenuItem(
              value: choice,
              child: Text(
                choice,
                style: TextStyle(fontSize: 12),
              ),
            );
          }).toList();
        });
  }
}
