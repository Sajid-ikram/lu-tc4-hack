import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class ProductProvider extends ChangeNotifier {


  Future addProductUrl({
    required String name,
    required String description,
    required String price,
    required String category,
    required String url,
    required DateTime date,

  }) async {
    try {
      FirebaseFirestore.instance.collection("products").doc().set(
        {
          "name": name,
          "description": description,
          "price": price,
          "category": category,
          "url": url,
          "bidExpires" : date,
          "ownerUid" : FirebaseAuth.instance.currentUser!.uid,
        },
      );

      notifyListeners();
    } catch (e) {

    }
  }
}
