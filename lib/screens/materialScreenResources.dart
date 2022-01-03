import 'package:educircle/screens/resources.dart';
import 'package:educircle/utils/firebaseData.dart';
import 'package:educircle/utils/listViewBuilders.dart';
import 'package:educircle/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class MaterialScreen extends StatefulWidget {
  final String materialType;
  final String subjectName;

  const MaterialScreen(
      {Key? key, required this.materialType, required this.subjectName})
      : super(key: key);

  @override
  _MaterialScreenState createState() => _MaterialScreenState();
}

class _MaterialScreenState extends State<MaterialScreen> {
  bool isMaterialLoad = false;

  List itemsNameList = [];
  List itemsLinkList = [];
  List itemsIdList = [];
  List itemsUpdatedOnList = [];

  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return !isMaterialLoad
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
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 10.0, 0, 10.0),
                  child: Text(widget.subjectName,
                      style: Get.isDarkMode
                          ? darkModeLightTextStyle
                          : lightModeLightTextStyle),
                ),
                Expanded(
                  child: itemsIdList.isEmpty
                      ? Container(
                          height: double.maxFinite,
                          width: double.maxFinite,
                          child: Text(
                            "Sorry, no ${widget.materialType} availabe.",
                            style: TextStyle(fontSize: LargeTextSize),
                          ),
                        )
                      : fullWidthListViewBuilder(context, itemsNameList,
                          itemsUpdatedOnList, widget.materialType, "material"),
                ),
              ],
            ),
          );
  }

  Future<void> loadData() async {
    List materialData = await FirebaseData()
        .materialData(widget.materialType, widget.subjectName, semester);
    for (var item in materialData) {
      itemsIdList.add(item["id"]);
      itemsLinkList.add(item["link"]);
      itemsNameList.add(item["name"]);
      itemsUpdatedOnList.add(item["updatedOn"]);
    }
    setState(() {
      isMaterialLoad = true;
    });
  }
}
