import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class ProductProvider extends ChangeNotifier {
  /*void getUserInfo(String id) async {
    DocumentSnapshot userInfo =
    await FirebaseFirestore.instance.collection('users').doc(id).get();
    profileUrl = userInfo["url"];
    profileName = userInfo["name"];
    role = userInfo["role"];
    notifyListeners();
  }
*/

  Future addProductUrl({
    required String name,
    required String description,
    required String price,
    required String category,
    required String url,
  }) async {
    try {
      FirebaseFirestore.instance.collection("products").doc().set(
        {
          "name": name,
          "description": description,
          "price": price,
          "category": category,
          "url": url,
        },
      );
      print("=========================111");
      notifyListeners();
    } catch (e) {
      print("=========================222");
    }
  }
}
