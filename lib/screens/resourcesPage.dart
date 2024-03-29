import 'package:duline/MainLayout.dart';
import 'package:duline/screens/shimmerWidget.dart';
import 'package:duline/utils/appState.dart';
import 'package:duline/utils/firebaseData.dart';
import 'package:duline/utils/listViewBuilders.dart';
import 'package:duline/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import 'package:get/route_manager.dart';

Map subjectMap = {"core": [], "GE": <String>[], "AECC": []};
bool isSubjectListPresent = false;

String courseName = "";
int semester = int.parse(AppState().getSemester().toString().substring(9, 10));

class Resources extends StatefulWidget {
  const Resources({Key? key}) : super(key: key);

  @override
  _ResourcesState createState() => _ResourcesState();
}

class _ResourcesState extends State<Resources> {
  @override
  void initState() {
    subjectListInit();
    super.initState();
  }

  List semesterList = [
    "Semester 1",
    "Semester 2",
    "Semester 3",
    "Semester 4",
    "Semester 5",
    "Semester 6"
  ];

  @override
  Widget build(BuildContext context) {
    double widthOfDevice = widthOrHeightOfDevice(context)["width"];
    return isLoading
        ? shimmerForMaterials(context)
        : SingleChildScrollView(
            physics: ScrollPhysics(),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  lightTextTitle("Course"),
                  Row(
                    children: [
                      Flexible(
                        flex: 3,
                        child: Padding(
                          padding:
                              const EdgeInsets.fromLTRB(16.0, 0.0, 5.0, 0.0),
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                            child: InkWell(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              onTap: () {
                                showMaterialRadioPicker(
                                    headerColor: Get.isDarkMode
                                        ? Colors.black45
                                        : selectedIconColor,
                                    title: "Select Course",
                                    context: context,
                                    items: courseList,
                                    selectedItem: AppState().getCourse(),
                                    onChanged: (value) {
                                      AppState().setCourse(value.toString());
                                      subjectListInit();
                                    });
                              },
                              child: Container(
                                color: Get.isDarkMode
                                    ? offBlackColor
                                    : offWhiteColor,
                                padding: EdgeInsets.fromLTRB(16.0, 10.0, 5, 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                        width: widthOfDevice - 200,
                                        child: Text(
                                          AppState().getCourse(),
                                          overflow: TextOverflow.fade,
                                        )),
                                    Icon(Icons.arrow_drop_down_outlined)
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                          flex: 1,
                          child: Container(
                            padding:
                                const EdgeInsets.fromLTRB(0.0, 0.0, 16.0, 0.0),
                            child: InkWell(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              onTap: () {
                                showMaterialRadioPicker(
                                    headerColor: Get.isDarkMode
                                        ? Colors.black45
                                        : selectedIconColor,
                                    title: "Select Semester",
                                    context: context,
                                    items: semesterList,
                                    selectedItem: AppState().getSemester(),
                                    onChanged: (value) {
                                      AppState().setSemester(value.toString());
                                      subjectListInit();
                                    },
                                    maxLongSide: 480.0);
                              },
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                                child: Container(
                                  padding:
                                      EdgeInsets.fromLTRB(10.0, 10.0, 5.0, 10),
                                  color: Get.isDarkMode
                                      ? offBlackColor
                                      : offWhiteColor,
                                  child: Row(
                                    children: [
                                      Text(
                                          "${AppState().getSemester().substring(0, 3)} ${AppState().getSemester().substring(9, 10)}"),
                                      Icon(Icons.arrow_drop_down_outlined)
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ))
                    ],
                  ),
                  Padding(padding: EdgeInsets.all(10)),
                  rectangleListViewBuilder(context, materialTypeList)
                ],
              ),
            ),
          );
  }

  Future<void> subjectListInit() async {
    try {
      courseName = AppState().getCourse();
      semester =
          int.parse(AppState().getSemester().toString().substring(9, 10));
      subjectMap["core"] =
          await FirebaseData().subjectOfCourse(courseName, semester);

      int semesterForAECC = 0;
      if (semester == 2 || semester == 4) {
        semesterForAECC = semester - 1;
      }else{
        semesterForAECC = semester;
      }

      subjectMap["AECC"] =
          await FirebaseData().aeccGESubjects(semesterForAECC, "AECC", false);

      //needed string list in for dialog box in subjectScreenResources so created to raw list to append data
      List rawGESubjectList =
          await FirebaseData().aeccGESubjects(semester, "GE", false);
      List<String> anotherRawGESubjectList = [];
      for (var subject in rawGESubjectList) {
        anotherRawGESubjectList.add(subject);
      }
      subjectMap["GE"] = anotherRawGESubjectList;

      setState(() {
        isSubjectListPresent = true;
      });
    } catch (e) {
      print(e);
    }
  }
}
