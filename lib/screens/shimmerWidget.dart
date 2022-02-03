import 'package:duline/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerSkeleton extends StatelessWidget {
  final double height;
  final double width;
  final EdgeInsets margin;
  const ShimmerSkeleton(
      {Key? key,
      required this.height,
      required this.width,
      required this.margin})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Shimmer.fromColors(
        baseColor: Get.isDarkMode ? offBlackColor : Colors.black,
        highlightColor:  Get.isDarkMode? Colors.grey[700] as Color : Colors.grey[500] as Color,
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
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
