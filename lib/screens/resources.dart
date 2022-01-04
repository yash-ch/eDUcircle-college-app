import 'package:educircle/MainLayout.dart';
import 'package:educircle/utils/appState.dart';
import 'package:educircle/utils/firebaseData.dart';
import 'package:educircle/utils/listViewBuilders.dart';
import 'package:educircle/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import 'package:get/route_manager.dart';

// Map svgLinkMap = Map<String, String>();
List subjectList = [];
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
    // FirebaseData().try1();
    // FirebaseData().subjectOfCourse("B.Sc. (H) Physics", 1);
    // FirebaseData().materialData("Books", "Mathematics Foundation for Electronics", 1);
    // FirebaseData().addingCollection();
    subjectListInit();
    super.initState();
  }

  // List courseList = [
  //   "B.Sc. (H) Computer Science",
  //   "B.Sc. (H) Electronics",
  //   "B.Sc. (H) Mathematics",
  //   "B.Sc. (H) Physics",
  //   "B.Sc. (H) Chemistry",
  //   "B.Sc. Mathematical Science",
  //   "B.Sc. Physical Sciences (CS)",
  //   "B.Sc. Physical Sciences (Chemistry)",
  //   "B.Sc. Life Sciences",
  //   "B.Com (H)",
  //   "B.A. Programme",
  //   "B.A. (H) English",
  //   "B.Sc. (H) Zoology",
  //   "Bachelor in Management Studies",
  // ];

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
    double widthOfDevice = MediaQuery.of(context).size.width;
    return isLoading
        ? Center(
            child: CircularProgressIndicator(
            color: selectedIconColor,
            strokeWidth: 4.0,
          ))
        : SingleChildScrollView(
            physics: ScrollPhysics(),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 10.0, 0, 10.0),
                    child: Text("Courses",
                        style: Get.isDarkMode
                            ? darkModeLightTextStyle
                            : lightModeLightTextStyle),
                  ),
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
                              onTap: () {
                                showMaterialRadioPicker(
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
                              onTap: () {
                                showMaterialRadioPicker(
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
      subjectList = await FirebaseData().subjectOfCourse(courseName, semester);
      setState(() {
        isSubjectListPresent = true;
      });
    } catch (e) {}
  }
}
