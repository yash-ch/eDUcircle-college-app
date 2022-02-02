import 'package:cached_network_image/cached_network_image.dart';
import 'package:educircle/screens/shimmerWidget.dart';
import 'package:educircle/utils/style.dart';
import 'package:flutter/material.dart';

class ClubsPage extends StatefulWidget {
  const ClubsPage({Key? key}) : super(key: key);

  @override
  _ClubsPageState createState() => _ClubsPageState();
}

class _ClubsPageState extends State<ClubsPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CachedNetworkImage(
                imageUrl:
                    "https://firebasestorage.googleapis.com/v0/b/educircle-dduc.appspot.com/o/images%2Fother%2Funderdevelopment.png?alt=media&token=907c207d-b71d-4266-b58b-24c428a191dd",
                placeholder: (context, url) => ShimmerSkeleton(
                    height: 280, width: double.maxFinite, margin: EdgeInsets.symmetric(horizontal: 50.0)),
                errorWidget: (context, url, error) => Icon(Icons.error),
                fit: BoxFit.cover,
              ),
              Text(
                "Under development, contact the app team if you want to help in development.",
                textAlign: TextAlign.center,
              )
            ],
          )),
    );
  }
}
