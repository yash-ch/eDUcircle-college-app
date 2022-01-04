import 'package:educircle/screens/resources.dart';
import 'package:educircle/utils/listViewBuilders.dart';
import 'package:educircle/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class SubjectScreenResources extends StatefulWidget {
  final String materialType;
  final String courseName;
  final int semester;
  SubjectScreenResources(
      {Key? key,
      required this.materialType,
      required this.courseName,
      required this.semester})
      : super(key: key);
  @override
  _SubjectScreenResourcesState createState() => _SubjectScreenResourcesState();
}

class _SubjectScreenResourcesState extends State<SubjectScreenResources> {
  @override
  Widget build(BuildContext context) {
    // double widthOfDevice = MediaQuery.of(context).size.width;

    return !isSubjectListPresent
        ? Center(
            child: CircularProgressIndicator(
            color: selectedIconColor,
            strokeWidth: 4.0,
          ))
        : Scaffold(
            backgroundColor:
                Get.isDarkMode ? darkBackgroundColor : lightBackgroundColor,
            appBar: AppBar(
              backgroundColor:
                  Get.isDarkMode ? darkBackgroundColor : lightBackgroundColor,
              title: Text(
                widget.materialType,
                style:
                    Get.isDarkMode ? DarkAppBarTextStyle : LightAppBarTextStyle,
              ),
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios_new_rounded,
                    color: Get.isDarkMode ? Colors.white : Colors.black),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 10.0, 0, 10.0),
                  child: Text("Core Subjects",
                      style: Get.isDarkMode
                          ? darkModeLightTextStyle
                          : lightModeLightTextStyle),
                ),
                Expanded(
                  child: fullWidthListViewBuilder(context, subjectList,
                      subjectList, subjectList, widget.materialType, "subject"),
                ),
              ],
            ),
          );
  }
}
