import 'package:cached_network_image/cached_network_image.dart';
import 'package:educircle/MainLayout.dart';
import 'package:educircle/utils/firebaseData.dart';
import 'package:educircle/utils/listViewBuilders.dart';
import 'package:educircle/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:flutter_carousel_slider/carousel_slider_indicators.dart';
import 'package:flutter_carousel_slider/carousel_slider_transforms.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedEventOrNewsIndex = 0; //0 for Events and 1 for News

  @override
  void initState() {
    super.initState();
  }

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
                      : Get.isDarkMode
                          ? offBlackColor
                          : offWhiteColor,
                  padding: const EdgeInsets.all(2.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    child: InkWell(
                      child: Container(
                        color: Get.isDarkMode ? offBlackColor : Colors.white,
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
                      : Get.isDarkMode
                          ? offBlackColor
                          : offWhiteColor,
                  padding: const EdgeInsets.all(2.0),
                  child: InkWell(
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      child: Container(
                        color: Get.isDarkMode ? offBlackColor : Colors.white,
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
            Center(
              child: Container(
                margin: EdgeInsets.fromLTRB(0.0, 8.0, 0, 16.0),
                width: widthOrHeightOfDevice(context)["width"] - 32,
                height: widthOrHeightOfDevice(context)["width"] - 32,
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    child: isHomePageDataLoaded
                        ? CarouselSlider.builder(
                            unlimitedMode: true,
                            // enableAutoSlider: true,
                            slideBuilder: (index) {
                              return InkWell(
                                child: Container(
                                  child: Expanded(
                                    child: CachedNetworkImage(
                                      imageUrl: topBannerImageLinks[index],
                                      placeholder: (context, url) => Center(
                                          child: CircularProgressIndicator(
                                        color: selectedIconColor,
                                        strokeWidth: 4.0,
                                      )),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  launchURL(topBannerWebsiteLinks[index]);
                                },
                              );
                            },
                            slideTransform: CubeTransform(),
                            slideIndicator: CircularSlideIndicator(
                              currentIndicatorColor: selectedIconColor,
                              indicatorBackgroundColor: Colors.white60,
                              padding: EdgeInsets.only(bottom: 32),
                            ),
                            itemCount: topBannerImageLinks.length)
                        : Center(
                            child: CircularProgressIndicator(
                            color: selectedIconColor,
                            strokeWidth: 4.0,
                          ))),
              ),
            ),
            lightTextTitle("Today's Events"),
            Container(
                margin: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
                height: 160.0,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  child: new ListView(
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        child: Container(
                          width: 160.0,
                          color: Colors.blue,
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(right: 10.0)),
                      ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        child: Container(
                          width: 160.0,
                          color: Colors.green,
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(right: 10.0)),
                      ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        child: Container(
                          width: 160.0,
                          color: Colors.cyan,
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(right: 10.0)),
                      ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        child: Container(
                          width: 160.0,
                          color: Colors.amber,
                        ),
                      ),
                    ],
                  ),
                )),
            lightTextTitle("This Week's Events"),
            Container(
                margin: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
                height: 160.0,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  child: new ListView(
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        child: Container(
                          width: 160.0,
                          color: Colors.blue,
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(right: 10.0)),
                      ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        child: Container(
                          width: 160.0,
                          color: Colors.green,
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(right: 10.0)),
                      ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        child: Container(
                          width: 160.0,
                          color: Colors.cyan,
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(right: 10.0)),
                      ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        child: Container(
                          width: 160.0,
                          color: Colors.amber,
                        ),
                      ),
                    ],
                  ),
                )),
            lightTextTitle("Upcoming Events"),
            Container(
                margin: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 10.0),
                height: 160.0,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  child: new ListView(
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        child: Container(
                          width: 160.0,
                          color: Colors.blue,
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(right: 10.0)),
                      ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        child: Container(
                          width: 160.0,
                          color: Colors.green,
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(right: 10.0)),
                      ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        child: Container(
                          width: 160.0,
                          color: Colors.cyan,
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(right: 10.0)),
                      ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        child: Container(
                          width: 160.0,
                          color: Colors.amber,
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
