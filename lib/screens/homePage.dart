import 'package:educircle/utils/listViewBuilders.dart';
import 'package:educircle/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedEventOrNewsIndex = 0; //0 for Events and 1 for News

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          padding: EdgeInsets.only(bottom: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                child: Container(
                  color: _selectedEventOrNewsIndex == 0
                      ? selectedIconColor
                      : Colors.transparent,
                  padding: const EdgeInsets.all(2.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    child: InkWell(
                      child: Container(
                        color: Get.isDarkMode ? offBlackColor : offWhiteColor,
                        height: 40.0,
                        width: (widthOrHeightOfDevice(context)["width"] / 4),
                        child: Center(
                            child: Text(
                          "Events",
                          style: TextStyle(
                            color: _selectedEventOrNewsIndex == 0
                                ? selectedIconColor
                                : Get.isDarkMode
                                    ? darkModeLightTextColor
                                    : lightModeLightTextColor,
                          ),
                        )),
                      ),
                      onTap: () {
                        setState(() {
                          _selectedEventOrNewsIndex = 0;
                        });
                      },
                    ),
                  ),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                child: Container(
                  color: _selectedEventOrNewsIndex == 1
                      ? selectedIconColor
                      : Colors.transparent,
                  padding: const EdgeInsets.all(2.0),
                  child: InkWell(
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      child: Container(
                        color: Get.isDarkMode ? offBlackColor : offWhiteColor,
                        height: 40.0,
                        width: (widthOrHeightOfDevice(context)["width"] / 4),
                        child: Center(
                            child: Text(
                          "News",
                          style: TextStyle(
                            color: _selectedEventOrNewsIndex == 1
                                ? selectedIconColor
                                : Get.isDarkMode
                                    ? darkModeLightTextColor
                                    : lightModeLightTextColor,
                          ),
                        )),
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        _selectedEventOrNewsIndex = 1;
                      });
                    },
                  ),
                ),
              )
            ],
          ),
        ),
        Expanded(
            child: _selectedEventOrNewsIndex == 0 ? eventsTab() : Offstage()),
      ],
    );
  }

  Widget eventsTab() {
    return SingleChildScrollView(
      physics: ScrollPhysics(),
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 10.0),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                child: Container(
                  color: Get.isDarkMode ? offBlackColor : offWhiteColor,
                  width: widthOrHeightOfDevice(context)["width"] - 32,
                  height: widthOrHeightOfDevice(context)["width"] - 32,
                  child: Row(
                    children: [],
                  ),
                ),
              ),
            ),
            Padding(padding: EdgeInsets.all(5.0)),
            lightTextTitle("Today's Events"),
            Container(
                margin: EdgeInsets.all(10.0),
                height: 200.0,
                child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  child: new ListView(
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      Container(
                        width: 160.0,
                        color: Colors.blue,
                      ),
                      Container(
                        width: 160.0,
                        color: Colors.green,
                      ),
                      Container(
                        width: 160.0,
                        color: Colors.cyan,
                      ),
                      Container(
                        width: 160.0,
                        color: Colors.amber,
                      ),
                    ],
                  ),
                )),
            Padding(padding: EdgeInsets.all(5.0)),
            lightTextTitle("Upcoming Events"),
          ],
        ),
      ),
    );
  }
}
