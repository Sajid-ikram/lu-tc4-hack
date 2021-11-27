import 'package:bit_by_bit/providers/fav_notification_provider.dart';
import 'package:bit_by_bit/providers/fav_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class FavScreen extends StatefulWidget {
  const FavScreen({Key? key}) : super(key: key);

  @override
  _FavScreenState createState() => _FavScreenState();
}

class _FavScreenState extends State<FavScreen> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance!.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pro = Provider.of<FavProvider>(context, listen: false);

    final User? user = FirebaseAuth.instance.currentUser;
    final Stream<QuerySnapshot> productsCart = FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .collection("Favourite")
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Color(0xff28292E),
        title: const Text(
          "Favourite",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: productsCart,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.green,
              ),
            );
          }
          final data = snapshot.data;

          for (int i = 0; i < data!.size; i++) {
            pro.cartAmounts.insert(i, int.parse(data.docs[i]["amount"]));
            pro.didCartAmountsChange.add(false);
            pro.cartProductId.add(data.docs[i].id);
          }

          return data.size == 0
              ? emptyCart()
              : GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (ctx, index) {
                    return favProduct(data, index, pro, user);
                  },
                  itemCount: data.size,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 3 / 4,
                  ),
                );
        },
      ),
    );
  }

  Widget emptyCart() {
    return Center(
      child: Text(
        "Empty Favourite",
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget favProduct(
      QuerySnapshot data, int index, FavProvider pro, User user) {
    return Container(
      child: Stack(
        children: [
          Container(
            //padding: EdgeInsets.all(20),
            margin: EdgeInsets.all(10),
            height: MediaQuery.of(context).size.height * 0.3,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(data.docs[index]["url"]),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Stack(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(13),
                        color: Colors.grey.withOpacity(0.7),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(15, 8, 8, 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              data.docs[index]["name"],
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),

                            Text("\$${data.docs[index]["price"].toString()}",
                                style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500)),
                            //SizedBox(height: 5),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 9,
                      child: Container(
                        height: 40,
                        width: 60,
                        decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(10)),
                        child: TextButton(
                          onPressed: () {},
                          child: const Text(
                            "BID",
                            style: TextStyle(
                                color: Color(0xffFCCFA8), fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            right: 10,
            top: 10,
            child: GestureDetector(
              onTap: () {
                Provider.of<FavProvider>(context, listen: false)
                    .deleteFav(index, user);
              },
              child: Container(
                height: 37,
                width: 37,
                margin: EdgeInsets.all(6),
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.5), shape: BoxShape.circle),
                child: Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
