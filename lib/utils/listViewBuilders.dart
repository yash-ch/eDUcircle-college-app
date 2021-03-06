import 'package:duline/screens/materialScreenResources.dart';
import 'package:duline/screens/resourcesPage.dart';
import 'package:duline/screens/shimmerWidget.dart';
import 'package:duline/screens/subjectScreenResources.dart';
import 'package:duline/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/route_manager.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../MainLayout.dart';

Widget rectangleListViewBuilder(dynamic context, List materialTypeList) {
  return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: materialTypeList.length,
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: [
            index % 2 == 0 || index == 0
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      roundedRectangleDepartmentWidget(
                          context, materialTypeList[index]),
                      SizedBox(
                        width: 20,
                      ),
                      materialTypeList.length > index + 1
                          ? roundedRectangleDepartmentWidget(
                              context, materialTypeList[index + 1])
                          : Offstage()
                    ],
                  )
                : Offstage(),
            SizedBox(
              height: 10,
            )
          ],
        );
      });
}

Widget roundedRectangleDepartmentWidget(dynamic context, String materialType) {
  double widthOfBox = (widthOrHeightOfDevice(context)["width"] / 2) - 30;
  return InkWell(
    borderRadius: BorderRadius.all(Radius.circular(20)),
    child: ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(20)),
      child: Container(
        color: Get.isDarkMode ? offBlackColor : offWhiteColor,
        child: SizedBox(
          height: 100.0,
          width: widthOfBox,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                  child: SvgPicture.network(
                svgLinkMap[materialType], //imageName
                color: selectedIconColor,
                width: 35,
                height: 35,
                placeholderBuilder: (context) => ShimmerSkeleton(
                    height: 35,
                    width: 35,
                    margin: EdgeInsets.all(0),
                    cornerRadius: 5.0),
              )),
              SizedBox(width: widthOfBox / 1.8, child: Text(materialType)),
            ],
          ),
        ),
      ),
    ),
    onTap: () {
      if (subjectMap["core"].isNotEmpty) {
        Navigator.push(
            context,
            PageRouteBuilder(
                pageBuilder: (BuildContext context, animation1, animation2) {
                  return SubjectScreenResources(
                    materialType: materialType,
                    courseName: courseName,
                    semester: semester,
                  );
                },
                transitionsBuilder: transitionEffectForNavigator()));
      } else {
        Fluttertoast.showToast(
            msg: "Sorry, nothing available for $courseName semester $semester.",
            toastLength: Toast.LENGTH_LONG);
      }
    },
  );
}

//full width used in subject screen and material screen
Widget fullWidthListViewBuilder(
    dynamic context,
    List namesList,
    List updatedOnList,
    List linkList,
    String materialType,
    String whichScreen) {
  return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: namesList.length,
      itemBuilder: (BuildContext context, int index) {
        // print(index);
        return fullWidthRoundedRectangleWidget(
            context,
            namesList[index],
            "${updatedOnList[index]}",
            linkList[index],
            materialType,
            whichScreen);
      });
}

Widget fullWidthRoundedRectangleWidget(dynamic context, String title,
    String updatedOn, String link, String materialType, String whichScreen) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 10.0),
    child: InkWell(
      borderRadius: BorderRadius.all(Radius.circular(20)),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        child: Container(
          color: Get.isDarkMode ? offBlackColor : offWhiteColor,
          child: SizedBox(
            height: 100.0,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                      child: SvgPicture.network(
                    svgLinkMap[materialType], //imageName
                    color: selectedIconColor,
                    width: 35,
                    height: 35,
                  )),
                ),
                Container(
                  width: 300,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: SmallTextSize)),
                      Text(
                        "Updated On : $updatedOn",
                        style: TextStyle(
                            color: Get.isDarkMode
                                ? darkModeLightTextColor
                                : lightModeLightTextColor,
                            fontSize: 12),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      onTap: () {
        whichScreen == "material"
            ? launchURL(link)
            : Navigator.push(
                context,
                PageRouteBuilder(
                    pageBuilder:
                        (BuildContext context, animation1, animation2) {
                      return MaterialScreen(
                        materialType: materialType,
                        subjectName: title,
                        sujectType: whichScreen.split(" ")[1],
                      );
                    },
                    transitionsBuilder: transitionEffectForNavigator()));
      },
    ),
  );
}

Future<void> launchURL(String url) async {
  if (url != "") {
    if (url.contains("http://") || url.contains("https://")) {
    } else {
      url = "http://" + url;
    }
    if (!await launch(
      url,
      forceSafariVC: false,
      forceWebView: false,
      headers: <String, String>{'my_header_key': 'my_header_value'},
    )) {
      throw 'Could not launch $url';
    }
  } else {
    Fluttertoast.showToast(msg: "Sorry, link is broken.");
  }
}

Widget webViewURLLauncher(context, String url) {
  if (url != "") {
    if (url.contains("http://") || url.contains("https://")) {
    } else {
      url = "https://" + url;
    }
  }
  String titleName = url.replaceAll("https://www.", "");
  titleName = titleName.replaceAll("http://www.", "");
  titleName = titleName.replaceAll(".com", "");
  titleName =
      titleName[0].toUpperCase() + titleName.substring(1, titleName.length);

  return Scaffold(
      backgroundColor:
          Get.isDarkMode ? darkBackgroundColor : lightBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor:
            Get.isDarkMode ? darkBackgroundColor : lightBackgroundColor,
        title: Text(
          titleName,
          style: Get.isDarkMode ? DarkAppBarTextStyle : LightAppBarTextStyle,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: Get.isDarkMode ? Colors.white : Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: WebView(
        initialUrl: url,
        javascriptMode: JavascriptMode.unrestricted,
      ));
}

transitionEffectForNavigator() {
  return (context, animation, secondaryAnimation, child) {
    const begin = Offset(1.0, 0.0);
    const end = Offset.zero;
    const curve = Curves.linearToEaseOut;

    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

    return SlideTransition(
      position: animation.drive(tween),
      child: child,
    );
  };
}

lightTextTitle(String title) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(16.0, 0.0, 0, 10.0),
    child: Text(title,
        style:
            Get.isDarkMode ? darkModeLightTextStyle : lightModeLightTextStyle),
  );
}
