import 'package:duline/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class NavScreen extends StatefulWidget {
  final String screenName;
  const NavScreen({Key? key, required this.screenName}) : super(key: key);

  @override
  _NavScreenState createState() => _NavScreenState();
}

class _NavScreenState extends State<NavScreen> {
  bool _isDataLoaded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor:
            Get.isDarkMode ? darkBackgroundColor : lightBackgroundColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor:
              Get.isDarkMode ? darkBackgroundColor : lightBackgroundColor,
          title: Text(
            widget.screenName,
            style: Get.isDarkMode ? DarkAppBarTextStyle : LightAppBarTextStyle,
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded,
                color: Get.isDarkMode ? Colors.white : Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: _isDataLoaded
            ? Container()
            : Center(
                child: CircularProgressIndicator(
                color: selectedIconColor,
                strokeWidth: 4.0,
              )));
  }

  Widget about(){
    return Container();
  }
}
