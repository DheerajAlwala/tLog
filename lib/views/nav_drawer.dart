import 'package:tlog/services/auth.dart';
import 'package:tlog/services/static_components.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tlog/views/my_blogs_page.dart';
import 'package:tlog/views/profile_page.dart';
import 'package:tlog/views/settings_page.dart';

import 'blog/blog_create_page.dart';

class NavDrawer extends StatelessWidget {




  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: new ListView(
        padding: new EdgeInsets.all(0.0),
        children: <Widget>[
          new UserAccountsDrawerHeader(

            accountName: new Text(cUser.displayName??"Loading"),
            accountEmail: new Text(cUser.email??"loading"),
            currentAccountPicture: cUser.photoURL==null?Image.asset("assets/tlogicon.png"):Image.network(cUser.photoURL),

          ),
          new ListTile(
            title: new Text("My Profile"),
            trailing: new Icon(Icons.person),
            onTap: () => {
    Navigator.push(context,
    MaterialPageRoute(builder: (context) => profilePage())),


            },
          ),
         Divider(),
         ListTile(
            title: new Text("My blogs"),
            trailing: new Icon(Icons.person),
            onTap: () => {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => myblogs())),

            },
          ),
         Divider(),
          ListTile(
            title: new Text("Settings"),
            trailing: new Icon(Icons.person),
            onTap: () => {
            Navigator.push(context,
            MaterialPageRoute(builder: (context) => settings())),
            },
          ),

         Divider(),
          // new ListTile(
          //   title: new Text("Close"),
          //   trailing: new Icon(Icons.close),
          //   onTap: () => Navigator.of(context).pop(),
          // ),
          new ListTile(

            title: new Text("Sign Out ",style: TextStyle(fontSize: 25),),
           // trailing: new Icon(Icons.close),
            onTap: () => AuthService().signOut(),
          ),
        ],
      ),
    );
  }


}








