import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class ProductProvider extends ChangeNotifier {
  String profileUrl = '';
  String profileName = '';
  String role = '';

  void getUserInfo(String id) async {
    DocumentSnapshot userInfo =
    await FirebaseFirestore.instance.collection('users').doc(id).get();
    profileUrl = userInfo["url"];
    profileName = userInfo["name"];
    role = userInfo["role"];
    notifyListeners();
  }



  Future updateProfileUrl(String url, String uid) async {


    try{
      FirebaseFirestore.instance.collection("users").doc(uid).update(
        {"url": url},
      );
      profileUrl = url;
      notifyListeners();
    }catch(e){

    }
  }
}
