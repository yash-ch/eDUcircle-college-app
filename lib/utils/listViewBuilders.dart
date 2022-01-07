import 'package:educircle/screens/materialScreenResources.dart';
import 'package:educircle/screens/resourcesPage.dart';
import 'package:educircle/screens/subjectScreenResources.dart';
import 'package:educircle/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/route_manager.dart';
import 'package:url_launcher/url_launcher.dart';
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
  double widthOfBox = ((MediaQuery.of(context).size.width) / 2) - 30;
  return InkWell(
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
              )),
              SizedBox(width: widthOfBox / 1.8, child: Text(materialType)),
            ],
          ),
        ),
      ),
    ),
    onTap: () {
      if (subjectList.isNotEmpty) {
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
        print(index);
        return Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 10.0),
          child: fullWidthRoundedRectangleWidget(
              context,
              namesList[index],
              "${updatedOnList[index]}",
              linkList[index],
              materialType,
              whichScreen),
        );
      });
}

Widget fullWidthRoundedRectangleWidget(dynamic context, String title,
    String updatedOn, String link, String materialType, String whichScreen) {
  return InkWell(
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
                          color: darkModeLightTextColor, fontSize: 12),
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
                  pageBuilder: (BuildContext context, animation1, animation2) {
                    return MaterialScreen(
                        materialType: materialType, subjectName: title);
                  },
                  transitionsBuilder: transitionEffectForNavigator()));
    },
  );
}

Future<void> launchURL(String url) async {
  if (url != "") {
    if (url.contains("http://") || url.contains("https://")) {
      print(url);
    } else {
      url = "http://" + url;
      print(url);
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
    padding: const EdgeInsets.fromLTRB(16.0, 10.0, 0, 10.0),
    child: Text(title,
        style:
            Get.isDarkMode ? darkModeLightTextStyle : lightModeLightTextStyle),
  );
}
