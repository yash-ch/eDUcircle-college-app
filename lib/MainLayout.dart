import 'package:educircle/screens/clubsPage.dart';
import 'package:educircle/screens/homePage.dart';
import 'package:educircle/screens/navDrawer.dart';
import 'package:educircle/screens/resourcesPage.dart';
import 'package:educircle/utils/firebaseData.dart';
import 'package:educircle/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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

//for HomePage images links
List topBannerImageLinks = [];
List topBannerWebsiteLinks = [];
bool isTopBannerDataLoaded = false;
bool isEventsDataLoaded = false;

//for HomePage images links
List todaysEventsImageLinks = [];
List todaysEventsWebsiteLinks = [];

//for HomePage images links
List weekEventsImageLinks = [];
List weekEventsWebsiteLinks = [];

//for HomePage images links
List upcomingEventsImageLinks = [];
List upcomingEventsWebsiteLinks = [];

//for news tab
List newsImageLinks = [];
List newsHeadlines = [];
List newsWebsiteLinks = [];
List newsPublishDate = [];

//for share dialog
String sharingText = "";

class _MainLayoutState extends State<MainLayout> {
  int _selectedTabIndex = 0;

  @override
  void initState() {
    svgLinkDic();
    loadingEvents();
    loadingNews();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget _tab = Resources();
    List<Widget> _topButtons = <Widget>[Offstage()];

    switch (_selectedTabIndex) {
      case 0:
        {
          _tab = HomePage();
          
        }
        break;
      case 1:
        {
          _tab = ClubsPage();
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
        elevation: 0.0,
        backgroundColor:
            Get.isDarkMode ? darkBackgroundColor : lightBackgroundColor,
        title: _topBarName.elementAt(_selectedTabIndex),
        actions: _topButtons,
      ),
      body: _tab,
      // AnimatedSwitcher(
      //     duration: const Duration(milliseconds: 500), child: _tab),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor:
            Get.isDarkMode ? darkBackgroundColor : lightBackgroundColor,
        items: _bottomNavigationBar,
        currentIndex: _selectedTabIndex,
        selectedItemColor: selectedIconColor,
        onTap: _onBottomTabTapped,
      ),
      drawer: NavDrawer(),
    );
  }

  List<Widget> _topBarName = <Widget>[
    Text(
      "Duline",
      style: Get.isDarkMode ? DarkAppBarTextStyle : LightAppBarTextStyle,
    ),
    Text(
      "Clubs",
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
    try {
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
    } catch (e) {}
  }

  Future<void> loadingEvents() async {
    List rawTopBannerData = await FirebaseData().eventsData("top_banners");

    for (var item in rawTopBannerData) {
      topBannerImageLinks.add(item["image_link"]);
      topBannerWebsiteLinks.add(item["link"]);
    }

    setState(() {
      isTopBannerDataLoaded = true;
    });

    String todaysDate =
        (DateFormat("dd MM yy").format(DateTime.now())).toString();
    List rawTodaysEventsData = await FirebaseData().eventsData("all_events");

    for (var item in rawTodaysEventsData) {
      if (item["event_date"] == todaysDate) {
        todaysEventsImageLinks.add(item["image_link"]);
        todaysEventsWebsiteLinks.add(item["link"]);
      }
      if (item["event_date"].toString().split(" ")[1] ==
              todaysDate.split(" ")[1] &&
          item["event_date"].toString().split(" ")[2] ==
              todaysDate.split(" ")[2]) {
        if (int.parse(item["event_date"].toString().split(" ")[0]) >
                int.parse(todaysDate.split(" ")[0]) &&
            int.parse(item["event_date"].toString().split(" ")[0]) <
                int.parse(todaysDate.split(" ")[0]) + 7) {
          weekEventsImageLinks.add(item["image_link"]);
          weekEventsWebsiteLinks.add(item["link"]);
        } else if (int.parse(item["event_date"].toString().split(" ")[0]) >=
            int.parse(todaysDate.split(" ")[0]) + 7) {
          upcomingEventsImageLinks.add(item["image_link"]);
          upcomingEventsWebsiteLinks.add(item["link"]);
        }
      }
    }
    setState(() {
      isEventsDataLoaded = true;
    });
  }

  Future<void> loadingNews() async {
    List rawNewsData = await FirebaseData().newsData(true);

    for (var item in rawNewsData) {
      newsImageLinks.add(item["image_link"]);
      newsWebsiteLinks.add(item["link"]);
      newsHeadlines.add(item["name"]);
      newsPublishDate.add(item["publish_date"]);
    }
    setState(() {});

    //for downloading whole data
    List rawAllNewsData = await FirebaseData().newsData(true);
    List tempNewsHeadlines = [];
    List tempNewsImageLinks = [];
    List tempNewsWebsiteLinks = [];
    List tempNewsPublishDate = [];

    for (var item in rawAllNewsData) {
      tempNewsImageLinks.add(item["image_link"]);
      tempNewsWebsiteLinks.add(item["link"]);
      tempNewsHeadlines.add(item["name"]);
      tempNewsPublishDate.add(item["publish_date"]);
    }
    setState(() {
      newsHeadlines = tempNewsHeadlines;
      newsImageLinks = tempNewsImageLinks;
      newsWebsiteLinks = tempNewsWebsiteLinks;
      newsPublishDate = tempNewsPublishDate;
    });
  }
}
