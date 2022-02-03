import 'package:duline/MainLayout.dart';
import 'package:duline/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerSkeleton extends StatelessWidget {
  final double height;
  final double width;
  final EdgeInsets margin;
  final double cornerRadius;
  const ShimmerSkeleton(
      {Key? key,
      required this.height,
      required this.width,
      required this.margin,
      required this.cornerRadius})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Shimmer.fromColors(
        baseColor: Get.isDarkMode ? offBlackColor : Colors.black,
        highlightColor: Get.isDarkMode
            ? Colors.grey[800] as Color
            : Colors.grey[500] as Color,
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(cornerRadius)),
          child: Container(
            height: height,
            width: width,
            color: Get.isDarkMode ? offBlackColor : offWhiteColor,
          ),
        ),
      ),
    );
  }
}

//for resources page
Widget shimmerForMaterials(context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      ShimmerSkeleton(
          margin: EdgeInsets.fromLTRB(16.0, 0.0, 0.0, 16.0),
          width: 120,
          height: 30,
          cornerRadius: 20.0),
      Row(
        children: [
          Flexible(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 0.0, 5.0, 0.0),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                child: ShimmerSkeleton(
                    height: 45,
                    width: widthOrHeightOfDevice(context)["width"] - 50,
                    margin: EdgeInsets.all(0),
                    cornerRadius: 20.0),
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.fromLTRB(0.0, 0.0, 16.0, 0.0),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                child: ShimmerSkeleton(
                    height: 45,
                    width: double.maxFinite,
                    margin: EdgeInsets.all(0),
                    cornerRadius: 20.0),
              ),
            ),
          )
        ],
      ),
      Padding(padding: EdgeInsets.all(8.0)),
      ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: 3,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ShimmerSkeleton(
                        height: 100.0,
                        width:
                            (widthOrHeightOfDevice(context)["width"] / 2) - 30,
                        margin: EdgeInsets.all(0.0),
                        cornerRadius: 20.0),
                    SizedBox(
                      width: 20,
                    ),
                    ShimmerSkeleton(
                        height: 100.0,
                        width:
                            (widthOrHeightOfDevice(context)["width"] / 2) - 30,
                        margin: EdgeInsets.all(0.0),
                        cornerRadius: 20.0),
                  ],
                ),
                SizedBox(
                  height: 20,
                )
              ],
            );
          })
    ],
  );
}

//for homepage
Widget eventTextShimmer() {
  return !isEventsDataLoaded
      ? ShimmerSkeleton(
          margin: EdgeInsets.fromLTRB(16.0, 0.0, 0.0, 16.0),
          width: 160,
          height: 40,
          cornerRadius: 20.0)
      : Offstage();
}

//for homepage
Widget eventTabShimmer() {
  return !isEventsDataLoaded
      ? Container(
          margin: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 20.0),
          height: 160.0,
          child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  itemBuilder: (BuildContext context, int index) {
                    return ShimmerSkeleton(
                        height: 160,
                        width: 160,
                        margin: EdgeInsets.only(right: 10.0),
                        cornerRadius: 20.0);
                  })))
      : Offstage();
}
