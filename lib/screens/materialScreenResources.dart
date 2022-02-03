import 'package:duline/screens/resourcesPage.dart';
import 'package:duline/utils/firebaseData.dart';
import 'package:duline/utils/listViewBuilders.dart';
import 'package:duline/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class MaterialScreen extends StatefulWidget {
  final String materialType;
  final String subjectName;
  final String sujectType; //core, AECC , GE
  const MaterialScreen(
      {Key? key,
      required this.materialType,
      required this.subjectName,
      required this.sujectType})
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
      body: !isMaterialLoad
          ? Center(
              child: CircularProgressIndicator(
              color: selectedIconColor,
              strokeWidth: 4.0,
            ))
          : Column(
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
                          child: Center(
                            child: Text(
                              "Sorry, no ${widget.materialType} availabe.",
                            ),
                          ),
                        )
                      : fullWidthListViewBuilder(
                          context,
                          itemsNameList,
                          itemsUpdatedOnList,
                          itemsLinkList,
                          widget.materialType,
                          "material"),
                ),
              ],
            ),
    );
  }

  Future<void> _loadData() async {
    try {
      switch (widget.sujectType) {
        case "core":
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
          break;
        case "AECC":
          List materialData = await FirebaseData().aeccOrGEData(
              semester, "AECC", widget.materialType, widget.subjectName);
          for (var item in materialData) {
            itemsIdList.add(item["id"]);
            itemsLinkList.add(item["link"]);
            itemsNameList.add(item["name"]);
            itemsUpdatedOnList.add(item["updatedOn"]);
          }
          setState(() {
            isMaterialLoad = true;
          });
          break;
        case "GE":
          List materialData = await FirebaseData().aeccOrGEData(
              semester, "GE", widget.materialType, widget.subjectName);
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
    } catch (e) {}
  }
}
