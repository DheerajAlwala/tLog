import 'package:cloud_firestore/cloud_firestore.dart';
import 'static_components.dart';


class CrudMethods {

  Future<void> addData(blogData) async {

    var doc=cUser.blogCollection.doc();
    blogData["documentId"]=doc.id;
    doc.set(blogData).catchError((e){
        print("error"+e);
      });
      DocumentSnapshot ds=await cUser.userRef.get();


        if(ds.data()['blogs']==null){
        cUser.userRef.update({"blogs":[doc.id]});
        }

      else{

        var list=List.from(ds.data()['blogs']);
         list.add(doc.id);
         cUser.userRef.update({'blogs':list});
      }

  }

  getAllData() async {
    cUser.blogCollection=FirebaseFirestore.instance.collection('blogs');
    return cUser.blogCollection.snapshots();
  }

  Future<Map<String, dynamic>> getData(documentId) async{
    var temp=await cUser.blogCollection.doc(documentId).get();
    Map<String,dynamic> map=temp.data();
    print(map);
    return map;
  }

  updateData(updatedMap,documentId) async{
    var doc=cUser.blogCollection.doc(documentId);
    doc.update(updatedMap).catchError((e){
      print(e);
    });
   }

  deleteData(documentId) async{
        cUser.blogCollection.doc(documentId).delete();
        DocumentSnapshot ds=await cUser.userRef.get();
        var v=List.from(ds.data()['blogs']);
        v.remove(documentId);
        cUser.userRef.update({"blogs":v});
        print('deleted '+documentId.toString()+'succesfully');
  }

}
