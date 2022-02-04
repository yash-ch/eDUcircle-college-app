import 'package:duline/MainLayout.dart';
import 'package:duline/screens/navScreens.dart';
import 'package:duline/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:share_plus/share_plus.dart';

import 'listViewBuilders.dart';

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Drawer(
        child: ListView(
          // Remove padding
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text('Duline'),
              accountEmail: Text('dulineapp@gmail.com'),
              currentAccountPicture: CircleAvatar(
                child: ClipOval(
                    child: Image.asset(
                  "assets/images/duline.png",
                  fit: BoxFit.cover,
                  width: 90,
                  height: 90,
                )),
              ),
              decoration: BoxDecoration(
                  color: Get.isDarkMode ? Colors.black45 : selectedIconColor),
            ),
            ListTile(
              leading: Icon(Icons.share),
              title: Text('Share'),
              onTap: () {
                Share.share(sharingText);
              },
            ),
            ListTile(
              leading: Icon(Icons.edit),
              title: Text('Contact'),
              onTap: () {
                launchURL(contactFormUrl);
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.description),
              title: Text('About'),
              onTap: () {
                Navigator.push(
                    context,
                    PageRouteBuilder(
                        pageBuilder:
                            (BuildContext context, animation1, animation2) {
                          return NavScreen(screenName: "About");
                        },
                        transitionsBuilder: transitionEffectForNavigator()));
              },
            ),
            Divider(),
            ListTile(
              title: Text('Exit'),
              leading: Icon(Icons.exit_to_app),
              onTap: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }
}
