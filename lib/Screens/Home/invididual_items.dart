import 'package:bit_by_bit/providers/fav_notification_provider.dart';
import 'package:bit_by_bit/providers/fav_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'home_controller.dart';

class IndividualItems extends StatefulWidget {
  const IndividualItems({Key? key}) : super(key: key);

  @override
  _IndividualItemsState createState() => _IndividualItemsState();
}

class _IndividualItemsState extends State<IndividualItems> {
  @override
  Widget build(BuildContext context) {
    var page = Provider.of<HomeController>(context);

    Stream<QuerySnapshot> user;
    if (page.pageNumber != 3) {

      user = FirebaseFirestore.instance
          .collection("products")
          .where("category", isEqualTo: page.titles[page.pageNumber])
          .snapshots();
    } else {

      user = FirebaseFirestore.instance.collection("products").snapshots();
    }

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      child: StreamBuilder<QuerySnapshot>(
        stream: user,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text("Something went wrong");
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final data = snapshot.data;

          return Consumer<HomeController>(
            builder: (context, provider, child) {
              return GridView.builder(
                physics: const BouncingScrollPhysics(),
                itemBuilder: (ctx, index) {
                  return productCard(data!, index);
                },
                itemCount: data!.size,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3 / 4,
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget productCard(QuerySnapshot<Object?> data, int index) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, "productDetailPage",
            arguments: data.docs[index]);
      },
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Hero(
        tag: data.docs[index].id,
        child: Container(
          // padding: EdgeInsets.all(20),
          margin: EdgeInsets.fromLTRB(0, 10, 15, 10),
          height: MediaQuery.of(context).size.height * 0.4,
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

                    //height: MediaQuery.of(context).size.height * 0.08,
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
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          Text("\$${data.docs[index]["price"].toString()}",
                              style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500)),
                          //SizedBox(height: 5),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: RawMaterialButton(
                      onPressed: () {
                        Provider.of<FavProvider>(context, listen: false)
                            .addProductToFav(data.docs[index]);
                        Provider.of<FavNotificationProvider>(context,
                                listen: false)
                            .checkIsCartEmpty("new");
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Item is added to favourite'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                      elevation: 0,
                      constraints: BoxConstraints(
                        minWidth: 0,
                      ),
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(5),
                      child: Icon(FontAwesomeIcons.heart,
                          size: 16, color: Colors.white),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
