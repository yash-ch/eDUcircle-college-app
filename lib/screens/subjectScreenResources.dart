import 'package:duline/screens/resourcesPage.dart';
import 'package:duline/utils/appState.dart';
import 'package:duline/utils/firebaseData.dart';
import 'package:duline/utils/listViewBuilders.dart';
import 'package:duline/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_pickers/helpers/show_radio_picker.dart';
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
  int semesterForGE = 0;

  @override
  void initState() {
    if (semester == 2 || semester == 4) {
      semesterForGE = semester - 1;
    }
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
                      Padding(padding: EdgeInsets.only(bottom: 10.0)),
                      subjectMap["AECC"].isNotEmpty
                          ? lightTextTitle("AECC")
                          : Offstage(),
                      subjectMap["AECC"].isNotEmpty
                          ? fullWidthListViewBuilder(
                              context,
                              subjectMap["AECC"],
                              _updatedOnMap["AECC"],
                              subjectMap["AECC"],
                              widget.materialType,
                              "subject AECC")
                          : Offstage(),
                      subjectMap["AECC"].isNotEmpty
                          ? Padding(padding: EdgeInsets.only(bottom: 10.0))
                          : Offstage(),
                      [1, 2, 3, 4].contains(semester)
                          ? subjectMap["GE"].isNotEmpty
                              ? lightTextTitle("Generic Elective")
                              : Offstage()
                          : Offstage(),
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 10.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          child: InkWell(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            onTap: () {
                              showMaterialRadioPicker(
                                  headerColor: Get.isDarkMode
                                      ? Colors.black45
                                      : selectedIconColor,
                                  title: "Select GE",
                                  context: context,
                                  items: subjectMap["GE"],
                                  selectedItem: AppState().getGE(),
                                  onChanged: (value) {
                                    AppState().setGE(value.toString());
                                    setState(() {});
                                  });
                            },
                            child: Container(
                              color: Get.isDarkMode
                                  ? offBlackColor
                                  : offWhiteColor,
                              padding: EdgeInsets.fromLTRB(16.0, 10.0, 16, 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                      width: widthOrHeightOfDevice(
                                              context)["width"] -
                                          200,
                                      child: Text(
                                        AppState().getGE(),
                                        overflow: TextOverflow.fade,
                                      )),
                                  Icon(Icons.arrow_drop_down_outlined)
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      ([1, 2, 3, 4].contains(semester) &&
                              AppState().getGE() != "Select GE")
                          ? fullWidthRoundedRectangleWidget(
                              context,
                              AppState().getGE(),
                              _updatedOnMap["GE"][0],
                              "",
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
              .aeccOrGEData(semesterForGE, "GE", widget.materialType, subject);
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
