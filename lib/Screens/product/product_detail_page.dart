import 'package:bit_by_bit/providers/profile_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'add_product.dart';

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({Key? key}) : super(key: key);

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  TextEditingController bidPriceController = TextEditingController();

  int bidAmount = 0;

  getProductInfo(DocumentSnapshot a) async {
    DocumentSnapshot productInfo = await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("myBid")
        .doc(a.id)
        .get();
    setState(() {
      bidAmount = int.parse(productInfo["Amount"]);
      isLoading = false;
    });
  }

  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as DocumentSnapshot;
    getProductInfo(args);

    print(bidAmount);
    print("********************");

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Container(
          height: size.height * 1.34,
          width: size.width,
          child: Stack(
            children: [
              Stack(
                children: [
                  Container(
                    height: size.height * 0.6,
                    width: size.width,
                    color: Colors.red,
                    child: Hero(
                      tag: args.id,
                      child: FadeInImage.assetNetwork(
                        fit: BoxFit.cover,
                        placeholder: 'assets/profile.jpg',
                        image: args["url"],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 50,
                    left: 15,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        height: 33,
                        width: 33,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50)),
                        child: Center(
                          child: Icon(
                            Icons.arrow_back,
                            size: 17,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Positioned(
                top: size.height * 0.56,
                child: buildProductInfo(size, args),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container buildProductInfo(Size size, DocumentSnapshot args) {
    return Container(
      height: size.height,
      width: size.width,
      decoration: const BoxDecoration(
        color: Color(0xff28292E),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(args["name"],
                    style: TextStyle(fontSize: 17, color: Colors.white)),
                Text("Minimum Bid : \$${args["price"]}".toString(),
                    style: TextStyle(fontSize: 17, color: Colors.white)),
              ],
            ),
            const Divider(
              thickness: 2,
              color: Colors.white,
              endIndent: 40,
              indent: 40,
              height: 60,
            ),
            Text("Product details : ".toString(),
                style: TextStyle(fontSize: 23, color: Color(0xffFCCFA8))),
            const SizedBox(height: 10),
            Text(args["description"], style: const TextStyle(fontSize: 16, color: Colors.white)),
            if (bidAmount != 0)
            const SizedBox(height: 20),
            if (bidAmount != 0)
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: Colors.blueGrey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10)
                ),

                child: Text("Your past bid was : "+bidAmount.toString(),
                    style: const TextStyle(fontSize: 16, color: Colors.white)),
              ),
            SizedBox(height: 5),
            Consumer<ProfileProvider>(
              builder: (context, provider, child) {
                return provider.role != "Seller"
                    ? buildDescriptionContainer(
                        1, bidPriceController, "Enter Bid amount ...")
                    : const SizedBox();
              },
            ),
            Consumer<ProfileProvider>(
              builder: (context, provider, child) {
                return InkWell(
                  onTap: () {
                    if (bidPriceController.text.isEmpty) {
                      var snackBar = const SnackBar(
                          content: Text('Enter an valid amount'));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } else if (int.parse(bidPriceController.text) <
                        int.parse(args["price"])) {
                      var snackBar = SnackBar(
                          content: Text('Minimum bid is ${args["price"]}'));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } else {
                      try {
                        FirebaseFirestore.instance
                            .collection("products")
                            .doc(args.id)
                            .collection("bid")
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .set(
                          {
                            "Amount": bidPriceController.text,
                            "url": provider.profileUrl,
                            "name": provider.profileName,
                          },
                        );
                        FirebaseFirestore.instance
                            .collection("users")
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .collection("myBid")
                            .doc(args.id)
                            .set(
                          {
                            "Amount": bidPriceController.text,
                            "productUid": args.id,
                          },
                        );
                        Navigator.of(context).pop();
                      } catch (e) {}
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 20),
                    height: 50,
                    width: double.infinity,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Color(0xffFCCFA8),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Text("Bid Now",
                        style: TextStyle(fontSize: 16, color: Colors.black)),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

Container buildDescriptionContainer(
    int line, TextEditingController descriptionController, String text) {
  return Container(
    width: double.infinity,
    height: line == 3 ? 90 : 60,
    child: TextField(
      maxLines: line,
      style: TextStyle(color: Colors.white),
      autofillHints: [AutofillHints.email],
      controller: descriptionController,
      keyboardAppearance: Brightness.light,
      keyboardType: TextInputType.emailAddress,
      decoration: buildInputDecoration(text),
    ),
  );
}
