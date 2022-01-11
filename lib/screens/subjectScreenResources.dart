import 'package:educircle/screens/resourcesPage.dart';
import 'package:educircle/utils/firebaseData.dart';
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
  bool _isUpdatedOnListLoaded = false;
  List _updatedOnList = [];

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
          widget.materialType,
          style: Get.isDarkMode ? DarkAppBarTextStyle : LightAppBarTextStyle,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: Get.isDarkMode ? Colors.white : Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: !isSubjectListPresent
          ? Center(
              child: CircularProgressIndicator(
              color: selectedIconColor,
              strokeWidth: 4.0,
            ))
          : !_isUpdatedOnListLoaded
              ? Center(
                  child: CircularProgressIndicator(
                  color: selectedIconColor,
                  strokeWidth: 4.0,
                ))
              : SingleChildScrollView(
                  physics: ScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      lightTextTitle("Core Subjects"),
                      fullWidthListViewBuilder(
                          context,
                          subjectList,
                          _updatedOnList,
                          subjectList,
                          widget.materialType,
                          "subject"),
                      Padding(padding: EdgeInsets.all(5)),
                      lightTextTitle("AECC"),
                      Padding(padding: EdgeInsets.all(5)),
                      [1, 2, 3, 4].contains(semester)
                          ? lightTextTitle("Generic Elective")
                          : Offstage()
                    ],
                  ),
                ),
    );
  }

  Future<void> _loadData() async {
    try {
      for (var subject in subjectList) {
        List materialData = await FirebaseData()
            .materialData(widget.materialType, subject, semester);
        List _rawListOfUpdatedOn = [];
        for (var item in materialData) {
          _rawListOfUpdatedOn.add(item["updatedOn"]);
        }
        if (_rawListOfUpdatedOn.isNotEmpty) {
          _rawListOfUpdatedOn.sort();
          _updatedOnList.add(_rawListOfUpdatedOn.last);
        } else {
          _updatedOnList.add("No Record");
        }
      }
      setState(() {
        _isUpdatedOnListLoaded = true;
      });
    } catch (e) {}
  }
}
