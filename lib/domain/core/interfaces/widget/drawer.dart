import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unjabbed_admin/infrastructure/navigation/routes.dart';
import '../../../../infrastructure/dal/util/Global.dart';

Widget drawer(BuildContext context, PageController controller) {
  return Drawer(
    child: Builder(
      builder: (context) {
        return ListView(
          children: <Widget>[
            DrawerHeader(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Admin Panel',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
            ),
            // Divider(
            //   thickness: .5,
            //   color: Colors.black,
            // ),
            ListTile(
              trailing: Icon(
                Icons.person,
                color: Theme.of(context).primaryColor,
              ),
              title: Text('USERS'),
              onTap: () {
                controller.jumpToPage(0);
                Scaffold.of(context).closeDrawer();
              },
            ),
            Divider(
              thickness: .5,
              color: Colors.black,
            ),
            ListTile(
              trailing: Icon(
                Icons.play_arrow,
                color: Theme.of(context).primaryColor,
              ),
              title: Text('VIDEOS'),
              onTap: () {
                controller.jumpToPage(1);
                Scaffold.of(context).closeDrawer();
              },
            ),
            Divider(
              thickness: .5,
              color: Colors.black,
            ),
            ListTile(
              trailing: Icon(
                Icons.format_list_numbered,
                color: Theme.of(context).primaryColor,
              ),
              title: Text('PACKAGES'),
              onTap: () {
                controller.jumpToPage(2);
                Scaffold.of(context).closeDrawer();
              },
            ),
            Divider(
              thickness: .5,
              color: Colors.black,
            ),
            ListTile(
              trailing: Icon(
                Icons.storage,
                color: Theme.of(context).primaryColor,
              ),
              title: Text('ITEM ACCESS'),
              onTap: () {
                controller.jumpToPage(3);
                Scaffold.of(context).closeDrawer();
              },
            ),
            Divider(
              thickness: .5,
              color: Colors.black,
            ),
            ListTile(
              trailing: Icon(
                Icons.lock_open,
                color: Theme.of(context).primaryColor,
              ),
              title: Text('CHANGE ID/PASSWORD'),
              onTap: () {
                controller.jumpToPage(4);
                Scaffold.of(context).closeDrawer();
              },
            ),
            Divider(
              thickness: .5,
              color: Colors.black,
            ),
            ListTile(
              trailing: Icon(
                Icons.verified,
                color: Theme.of(context).primaryColor,
              ),
              title: Text('VERIFY USER'),
              onTap: () {
                controller.jumpToPage(5);
                Scaffold.of(context).closeDrawer();
              },
            ),
            Divider(
              thickness: .5,
              color: Colors.black,
            ),
            ListTile(
              trailing: Icon(
                Icons.error,
                color: Theme.of(context).primaryColor,
              ),
              title: Text('REPORTED USER'),
              onTap: () {
                controller.jumpToPage(6);
                Scaffold.of(context).closeDrawer();
              },
            ),
            Divider(
              thickness: .5,
              color: Colors.black,
            ),
            ListTile(
              trailing: Icon(
                Icons.pause,
                color: Theme.of(context).primaryColor,
              ),
              title: Text('REVIEW USER'),
              onTap: () {
                controller.jumpToPage(7);
                Scaffold.of(context).closeDrawer();
              },
            ),
            // Divider(
            //   thickness: .5,
            //   color: Colors.black,
            // ),
            // ListTile(
            //   trailing: Icon(
            //     Icons.settings,
            //     color: Theme.of(context).primaryColor,
            //   ),
            //   title: Text('SETTINGS'),
            //   onTap: () {
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) => SettingsPage()));
            //   },
            // ),
            Divider(
              thickness: .5,
              color: Colors.black,
            ),
            ListTile(
              trailing: Icon(
                Icons.power_settings_new,
                color: Theme.of(context).primaryColor,
              ),
              title: Text('LOGOUT'),
              onTap: () async {
                Global().alertDialog(context);
              },
            ),
          ],
        );
      }
    ),
  );
}
