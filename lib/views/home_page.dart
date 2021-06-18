import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tlog/services/crud.dart';
import '../main.dart';
import 'blog/blog_create_page.dart';
import 'blog/blog_tile.dart';
import 'nav_drawer.dart';
import 'package:tlog/services/static_components.dart';


class HomePage extends StatefulWidget {




  @override
  _HomePageState createState() => _HomePageState();

}

class _HomePageState extends State<HomePage> {

  CrudMethods crudMethods = new CrudMethods();
  Stream blogsStream;
   bool st=false;
  Widget blogsList() {

    return Container(


        child: StreamBuilder<QuerySnapshot>(
            stream: blogsStream,
            builder: (context, snapshot) {
             
              if (!snapshot.hasData) {
                return Container(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(),
                );
              }

              else{
              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];
                  List like_user_ids=ds.data()["liked_user_ids"];

                  return BlogTile(
                    authorname: ds.data()["authorName"],
                    imgUrl: ds.data()["imgUrl"],
                    title: ds.data()["title"],
                    description: ds.data()["desc"],
                    time: ds.data()["time"],
                    documentId: ds.data()["documentId"],
                    issaved: (cUser.saved_blogs).contains(ds.data()["documentId"]),
                    likecount: ds.data()["likes_count"],
                    isliked: like_user_ids.contains(cUser.uid),
                  );
                },
              );
            
            }
            },
            ),
            );
  }

  @override
  initState()  {
    super.initState();
    crudMethods.getAllData().then((result) {
      setState(() {
        blogsStream = result;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
          Text(
            "T-",
            style: TextStyle(fontSize: 30, color: Colors.blue[900]),
          ),
          Text(
            "log",
            style: TextStyle(fontSize: 25, color: Colors.blue[50]),
          ),],),

         actions:<Widget>[
           RaisedButton(
             elevation: 20.0,
             color:Colors.yellow[100],
             shape: RoundedRectangleBorder(
                 borderRadius: BorderRadius.circular(30.0),
                 side: BorderSide(color: Colors.yellow,width: 2.5)
             ),
             child:Row(
             children: [
               Icon(Icons.add),
               Text("Add post"),
             ],
           ),
             onPressed: () {
               Navigator.push(context,
                   MaterialPageRoute(builder: (context) => CreateBlog()));
             },
           ),

             // child: FloatingActionButton.extended(
             //   backgroundColor: Colors.yellow[600],
             //   onPressed: () {
             //     Navigator.push(context,
             //         MaterialPageRoute(builder: (context) => CreateBlog()));
             //   },
             //   icon: Icon(Icons.add),
             //   label: Text("Add Post"),
             // ),

         ],

      ),
      body: blogsStream!=null?
      blogsList():
          Container(),
      floatingActionButton: Container(
        //padding: EdgeInsets.symmetric(vertical: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
          ],
        ),
      ),
    );
  }
}
