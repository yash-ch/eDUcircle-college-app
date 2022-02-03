import 'package:cached_network_image/cached_network_image.dart';
import 'package:duline/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:share_plus/share_plus.dart';

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
              
              accountName: Text('eDUcircle'),
              accountEmail: Text('educircleteam@gmail.com'),
              currentAccountPicture: CircleAvatar(
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl:
                        'https://oflutter.com/wp-content/uploads/2021/02/girl-profile.png',
                    fit: BoxFit.cover,
                    width: 90,
                    height: 90,
                  ),
                ),
              ),
              decoration: BoxDecoration(
                color: Get.isDarkMode? Colors.black45 : selectedIconColor
              ),
            ),
            ListTile(
              leading: Icon(Icons.share),
              title: Text('Share'),
              onTap: () {
                Share.share("hey, share this app.");
              },
            ),
            ListTile(
              leading: Icon(Icons.edit),
              title: Text('Suggestions'),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.description),
              title: Text('About'),
              onTap: () => null,
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
