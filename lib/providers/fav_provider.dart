import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class FavProvider extends ChangeNotifier {
  List<int> cartAmounts = [];
  List<bool> didCartAmountsChange = [];
  List<String> cartProductId = [];


  Future<void> deleteFav(int index,User user) async {
    try {
      didCartAmountsChange[index] = false;
      FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .collection("Favourite")
          .doc(cartProductId[index])
          .delete();
      cartAmounts.clear();
      didCartAmountsChange.clear();
      cartProductId.clear();
    } catch (e) {}
  }



  void addProductToFav(QueryDocumentSnapshot product) async {
    try {

      final User? user = FirebaseAuth.instance.currentUser;

      FirebaseFirestore.instance
          .collection("users")
          .doc(user!.uid)
          .collection("Favourite")
          .doc(product.id)
          .set(
        {
          "name": product['name'],
          "price": product['price'],
          "url": product['url'],
          "amount": "1"
        },
      );
    } catch (e) {}
  }
}
