import 'package:duline/utils/firebaseData.dart';
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
  Map data = {};

  @override
  void initState() {
    _loadData();
    super.initState();
  }

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
            ? about()
            : Center(
                child: CircularProgressIndicator(
                color: selectedIconColor,
                strokeWidth: 4.0,
              )));
  }

  Widget about() {
    return Container(
      width: widthOrHeightOfDevice(context)["width"],
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: ListView.builder(
          itemCount: data.length,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data[(index + 1).toString()].toString().split("_ ")[0],
                  style: TextStyle(
                      fontSize: MediumTextSize, fontWeight: FontWeight.w600),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 8.0, 0.0, 16.0),
                  child: Text(data[(index + 1).toString()].toString().split("_ ")[1]),
                )
              ],
            );
          }),
    );
  }

  Future<void> _loadData() async {
    data = await FirebaseData().otherData("about");   
    setState(() {
      _isDataLoaded = true;
    });
  }
}
