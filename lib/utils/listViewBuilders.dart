import 'package:auto_size_text/auto_size_text.dart';
import 'package:educircle/screens/materialScreenResources.dart';
import 'package:educircle/screens/resources.dart';
import 'package:educircle/screens/subjectScreenResources.dart';
import 'package:educircle/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/route_manager.dart';

import '../MainLayout.dart';

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
            }, transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.linearToEaseOut;

              var tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            }));
      } else {
        Fluttertoast.showToast(
            msg: "Sorry, nothing available for $courseName semester $semester.",
            toastLength: Toast.LENGTH_LONG);
      }
    },
  );
}

//full width used in subject screen and material screen
Widget fullWidthListViewBuilder(dynamic context, List namesList,
    List updatedOnList, String materialType, String whichScreen) {
  return ListView.builder(
      // physics: NeverScrollableScrollPhysics(),
      // shrinkWrap: true,
      itemCount: namesList.length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 10.0),
          child: fullWidthRoundedRectangleWidget(context, namesList[index],
              updatedOnList[index], materialType, whichScreen),
        );
      });
}

Widget fullWidthRoundedRectangleWidget(dynamic context, String title,
    String updatedOn, String materialType, String whichScreen) {
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
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: SmallTextSize)),
                  Text(
                    whichScreen == "material"
                        ? updatedOn
                        : "Last update : 21 December 2021",
                    style:
                        TextStyle(color: darkModeLightTextColor, fontSize: 12),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    ),
    onTap: () {
      Navigator.push(
          context,
          PageRouteBuilder(
              pageBuilder: (BuildContext context, animation1, animation2) {
            return MaterialScreen(
                materialType: materialType, subjectName: title);
          }, transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.linearToEaseOut;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          }));
    },
  );
}
