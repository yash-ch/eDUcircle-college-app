import 'package:educircle/screens/resourcesPage.dart';
import 'package:educircle/utils/firebaseData.dart';
import 'package:educircle/utils/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({Key? key}) : super(key: key);

  @override
  _MainLayoutState createState() => _MainLayoutState();
}

//data to load from firebase
Map svgLinkMap = {};
List materialTypeList = [];
List courseList = [];
bool isLoading = true;

class _MainLayoutState extends State<MainLayout> {
  int _selectedTabIndex = 0;

  @override
  void initState() {
    svgLinkDic();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget _tab = Resources();
    // List<Widget> _topButtons = <Widget>[Text("error")];
    switch (_selectedTabIndex) {
      case 0:
        {
          _tab = Text("Home");
        }
        break;
      case 1:
        {
          Fluttertoast.showToast(msg: "Under development, will be released soon. If you want to help in development then contact the team (contacts in app info).", toastLength: Toast.LENGTH_LONG);
          // _tab = Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [Text("Will be released soon.")]);
          // _topButtons =
        }
        break;
      case 2:
        {
          _tab = Resources();
          // _topButtons = <Widget>[Text("")];
        }
    }
    return Scaffold(
      backgroundColor:
          Get.isDarkMode ? darkBackgroundColor : lightBackgroundColor,
      appBar: AppBar(
        backgroundColor:
            Get.isDarkMode ? darkBackgroundColor : lightBackgroundColor,
        title: _topBarName.elementAt(_selectedTabIndex),
      ),
      body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500), child: _tab),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor:
            Get.isDarkMode ? darkBackgroundColor : lightBackgroundColor,
        items: _bottomNavigationBar,
        currentIndex: _selectedTabIndex,
        selectedItemColor: selectedIconColor,
        onTap: _onBottomTabTapped,
      ),
    );
  }

  List<Widget> _topBarName = <Widget>[
    Text(
      "eDUcircle",
      style: Get.isDarkMode ? DarkAppBarTextStyle : LightAppBarTextStyle,
    ),
    Text(
      // "Clubs",
      "Resources",
      style: Get.isDarkMode ? DarkAppBarTextStyle : LightAppBarTextStyle,
    ),
    Text(
      "Resources",
      style: Get.isDarkMode ? DarkAppBarTextStyle : LightAppBarTextStyle,
    ),
  ];

  List<BottomNavigationBarItem> _bottomNavigationBar = [
    BottomNavigationBarItem(
        icon: Icon(Icons.account_balance_rounded), label: "Home"),
    BottomNavigationBarItem(icon: Icon(Icons.people), label: "Clubs"),
    BottomNavigationBarItem(
        icon: Icon(Icons.menu_book_rounded), label: "Resources")
  ];

  void _onBottomTabTapped(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
  }

  void svgLinkDic() async {
    //firebase data loading

    courseList = await FirebaseData().courses();
    materialTypeList = await FirebaseData().materialType();
    Map svgMap = {};
    for (var item in materialTypeList) {
      String imageName = "";
      for (var item in item.split(" ")) {
        imageName = imageName + "_" + item;
      }
      imageName = imageName.substring(1, imageName.length);
      svgMap[item] = await FirebaseData().svgLink(imageName);
    }
    setState(() {
      svgLinkMap = svgMap;
      isLoading = false;
    });
  }
}
