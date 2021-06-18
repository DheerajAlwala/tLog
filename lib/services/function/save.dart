//save
//unsave
import 'package:cloud_firestore/cloud_firestore.dart';
import '../static_components.dart';

  Future<void> saveblog(String documentID) async{

  cUser.userRef.update({'saved_blogs':FieldValue.arrayUnion([documentID])});
  cUser.saved_blogs.add(documentID);

}
Future<void> unsaveblog(String documentID) async{
  cUser.userRef.update({'saved_blogs':FieldValue.arrayRemove([documentID])});
  cUser.saved_blogs.remove(documentID);
}