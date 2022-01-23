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
  Map _updatedOnMap = {"core": [], "GE": [], "AECC": []};

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
                          subjectMap["core"],
                          _updatedOnMap["core"],
                          subjectMap["core"],
                          widget.materialType,
                          "subject core"),
                      Padding(padding: EdgeInsets.all(5)),
                      lightTextTitle("AECC"),
                      fullWidthListViewBuilder(
                          context,
                          subjectMap["AECC"],
                          _updatedOnMap["AECC"],
                          subjectMap["AECC"],
                          widget.materialType,
                          "subject AECC"),
                      Padding(padding: EdgeInsets.all(5)),
                      [1, 2, 3, 4].contains(semester)
                          ? subjectMap["GE"].isNotEmpty
                              ? lightTextTitle("Generic Elective")
                              : Offstage()
                          : Offstage(),
                      [1, 2, 3, 4].contains(semester)
                          ? fullWidthListViewBuilder(
                              context,
                              subjectMap["GE"],
                              _updatedOnMap["GE"],
                              subjectMap["GE"],
                              widget.materialType,
                              "subject GE")
                          : Offstage(),
                    ],
                  ),
                ),
    );
  }

  Future<void> _loadData() async {
    try {
      for (var subject in subjectMap["core"]) {
        List materialData = await FirebaseData()
            .materialData(widget.materialType, subject, semester);
        List _rawListOfUpdatedOn = [];
        for (var item in materialData) {
          _rawListOfUpdatedOn.add(item["updatedOn"]);
        }
        if (_rawListOfUpdatedOn.isNotEmpty) {
          _rawListOfUpdatedOn.sort();
          _updatedOnMap["core"].add(_rawListOfUpdatedOn.last);
        } else {
          _updatedOnMap["core"].add("No Record");
        }
      }

      for (var subject in subjectMap["AECC"]) {
        List materialData = await FirebaseData()
            .aeccOrGEData(semester, "AECC", widget.materialType, subject);
        List _rawListOfUpdatedOn = [];
        for (var item in materialData) {
          _rawListOfUpdatedOn.add(item["updatedOn"]);
        }
        if (_rawListOfUpdatedOn.isNotEmpty) {
          _rawListOfUpdatedOn.sort();
          _updatedOnMap["AECC"].add(_rawListOfUpdatedOn.last);
        } else {
          _updatedOnMap["AECC"].add("No Record");
        }
      }

      if ([1, 2, 3, 4].contains(semester)) {
        for (var subject in subjectMap["GE"]) {
          List materialData = await FirebaseData()
              .aeccOrGEData(semester, "GE", widget.materialType, subject);
          List _rawListOfUpdatedOn = [];
          for (var item in materialData) {
            _rawListOfUpdatedOn.add(item["updatedOn"]);
          }
          if (_rawListOfUpdatedOn.isNotEmpty) {
            _rawListOfUpdatedOn.sort();
            _updatedOnMap["GE"].add(_rawListOfUpdatedOn.last);
          } else {
            _updatedOnMap["GE"].add("No Record");
          }
        }
      }

      setState(() {
        _isUpdatedOnListLoaded = true;
      });
    } catch (e) {}
  }
}
