import 'package:cached_network_image/cached_network_image.dart';
import 'package:duline/MainLayout.dart';
import 'package:duline/screens/shimmerWidget.dart';
import 'package:duline/utils/firebaseData.dart';
import 'package:duline/utils/listViewBuilders.dart';
import 'package:duline/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/route_manager.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:flutter_carousel_slider/carousel_slider_indicators.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedEventOrNewsIndex = 0; //0 for Events and 1 for News

  //for hiding events and news bar while scrolling down
  ScrollController _scrollViewController = ScrollController();
  bool _showAppbar = true;
  bool isScrollingDown = false;

  @override
  void initState() {
    FirebaseData().otherData("about");
    super.initState();

    //initializing the scroll down controller for the events and news bar
    _scrollViewController = new ScrollController();
    _scrollViewController.addListener(() {
      if (_scrollViewController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (!isScrollingDown) {
          isScrollingDown = true;
          _showAppbar = false;
          setState(() {});
        }
      }

      if (_scrollViewController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (isScrollingDown) {
          isScrollingDown = false;
          _showAppbar = true;
          setState(() {});
        }
      }
    });
  }

  //disposing the scroll down controller for the events and news bar
  @override
  void dispose() {
    _scrollViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          padding: EdgeInsets.only(bottom: 8.0),
          child: AnimatedContainer(
            height: _showAppbar ? 56.0 : 0.0,
            duration: Duration(milliseconds: 200),
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
                        borderRadius: BorderRadius.all(Radius.circular(20)),
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
                      borderRadius: BorderRadius.all(Radius.circular(20)),
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
        ),
        Expanded(
            child: _selectedEventOrNewsIndex == 0 ? eventsTab() : newsTab()),
      ],
    );
  }

  Widget eventsTab() {
    return SingleChildScrollView(
      controller: _scrollViewController,
      physics: ScrollPhysics(),
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 8.0),
              // child: lightTextTitle("Top Events"),
            ),
            Center(
              child: Container(
                  margin: EdgeInsets.fromLTRB(0.0, 0.0, 0, 16.0),
                  width: widthOrHeightOfDevice(context)["width"] - 22,
                  height: widthOrHeightOfDevice(context)["width"] - 22,
                  child: isTopBannerDataLoaded
                      ? CarouselSlider.builder(
                          unlimitedMode: true,
                          enableAutoSlider: true,
                          autoSliderDelay: Duration(seconds: 10),
                          autoSliderTransitionTime: Duration(milliseconds: 300),
                          slideBuilder: (index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 5.0),
                              child: InkWell(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                  child: Container(
                                    child: CachedNetworkImage(
                                      imageUrl: topBannerImageLinks[index],
                                      placeholder: (context, url) =>
                                          ShimmerSkeleton(
                                        cornerRadius: 20.0,
                                        margin: EdgeInsets.fromLTRB(
                                            0.0, 0.0, 0.0, 0.0),
                                        width: widthOrHeightOfDevice(
                                                context)["width"] -
                                            22,
                                        height: widthOrHeightOfDevice(
                                                context)["width"] -
                                            22,
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  launchURL(topBannerWebsiteLinks[index]);
                                },
                              ),
                            );
                          },
                          slideIndicator: CircularSlideIndicator(
                            currentIndicatorColor: selectedIconColor,
                            indicatorBackgroundColor: Colors.white60,
                            padding: EdgeInsets.only(bottom: 32),
                          ),
                          itemCount: topBannerImageLinks.length)
                      : ShimmerSkeleton(
                          cornerRadius: 20.0,
                          margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 16.0),
                          width: widthOrHeightOfDevice(context)["width"] - 22,
                          height: widthOrHeightOfDevice(context)["width"] - 22,
                        )),
            ),
            todaysEventsImageLinks.isNotEmpty
                ? lightTextTitle("Today's Events")
                : eventTextShimmer(),
            todaysEventsImageLinks.isNotEmpty
                ? _eventListView(
                    todaysEventsImageLinks, todaysEventsWebsiteLinks)
                : eventTabShimmer(),
            weekEventsImageLinks.isNotEmpty
                ? lightTextTitle("This Week's Events")
                : eventTextShimmer(),
            weekEventsImageLinks.isNotEmpty
                ? _eventListView(weekEventsImageLinks, weekEventsWebsiteLinks)
                : eventTabShimmer(),
            upcomingEventsImageLinks.isNotEmpty
                ? lightTextTitle("Upcoming Events")
                : eventTextShimmer(),
            upcomingEventsImageLinks.isNotEmpty
                ? _eventListView(
                    upcomingEventsImageLinks, upcomingEventsWebsiteLinks)
                : eventTabShimmer(),
          ],
        ),
      ),
    );
  }

  Widget _eventListView(List _imageLinkList, List _websitesLink) {
    return Container(
        margin: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 20.0),
        height: 160.0,
        child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _imageLinkList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        child: InkWell(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          child: Container(
                            width: 160.0,
                            height: 160.0,
                            child: CachedNetworkImage(
                              imageUrl: _imageLinkList[index],
                              placeholder: (context, url) => ShimmerSkeleton(
                                cornerRadius: 20.0,
                                height: 160,
                                width: 160,
                                margin: EdgeInsets.only(right: 0.0),
                              ),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                              fit: BoxFit.cover,
                            ),
                          ),
                          onTap: () {
                            launchURL(_websitesLink[index]);
                          },
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(right: 10.0)),
                    ],
                  );
                })));
  }

  Widget newsTab() {
    return SingleChildScrollView(
        controller: _scrollViewController,
        physics: ScrollPhysics(),
        child: newsHeadlines.isNotEmpty
            ? _newsTabListView(newsImageLinks, newsWebsiteLinks, newsHeadlines,
                newsPublishDate)
            : Container(
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
                    child: ListView.builder(
                        // itemCount: _imageLinkList.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: 7,
                        itemBuilder: (context, index) {
                          return ShimmerSkeleton(
                            cornerRadius: 20.0,
                            height: 160.0,
                            width: widthOrHeightOfDevice(context)["width"] - 32,
                            margin: EdgeInsets.only(bottom: 16.0),
                          );
                        }))));
  }

  Widget _newsTabListView(List _imageLinkList, List _websitesLink,
      List _newsTitleList, _newPublishDateList) {
    return Container(
        child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
            child: ListView.builder(
              // itemCount: _imageLinkList.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _newsTitleList.length,
              itemBuilder: (context, index) {
                return Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        child: Container(
                          color: Get.isDarkMode ? offBlackColor : offWhiteColor,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      padding: EdgeInsets.fromLTRB(
                                          16.0, 16.0, 10, 10.0),
                                      width: widthOrHeightOfDevice(
                                              context)["width"] -
                                          200,
                                      height: 135.0,
                                      child: Text(
                                        _newsTitleList[index],
                                        style:
                                            TextStyle(fontSize: SmallTextSize),
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: true,
                                        maxLines: 5,
                                      )),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        16.0, 0.0, 0.0, 16.0),
                                    child: Text(
                                      "Publish Date : " +
                                          _newPublishDateList[index]
                                              .toString()
                                              .replaceAll(" ", "/"),
                                      style: TextStyle(
                                          fontSize: 12.0,
                                          color: Get.isDarkMode
                                              ? darkModeLightTextColor
                                              : lightModeLightTextColor),
                                    ),
                                  )
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    0.0, 16.0, 16.0, 16.0),
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                  child: Container(
                                    width: 130.0,
                                    height: 130.0,
                                    child: CachedNetworkImage(
                                      imageUrl: _imageLinkList[index],
                                      placeholder: (context, url) =>
                                          ShimmerSkeleton(
                                        cornerRadius: 20.0,
                                        height: 130.0,
                                        width: 130,
                                        margin: EdgeInsets.only(bottom: 0.0),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      onTap: () {
                        try {
                          Navigator.push(
                              context,
                              PageRouteBuilder(
                                  pageBuilder: (BuildContext context,
                                      animation1, animation2) {
                                    return webViewURLLauncher(
                                        context, _websitesLink[index]);
                                  },
                                  transitionsBuilder:
                                      transitionEffectForNavigator()));
                        } catch (e) {}
                      },
                    ),
                    Padding(padding: EdgeInsets.only(bottom: 16.0)),
                  ],
                );
              },
            )));
  }
}
