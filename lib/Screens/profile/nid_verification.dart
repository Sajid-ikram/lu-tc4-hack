import 'dart:io';
import 'package:bit_by_bit/helperWidgets/appBar.dart';
import 'package:bit_by_bit/providers/product_provider.dart';
import 'package:bit_by_bit/providers/profile_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as storage;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class NIDVerification extends StatefulWidget {
  const NIDVerification({Key? key}) : super(key: key);

  @override
  _NIDVerificationState createState() => _NIDVerificationState();
}

class _NIDVerificationState extends State<NIDVerification> {
  final picker = ImagePicker();
  late File _imageFile1;
  late File _imageFile2;
  bool isSelected1 = false;
  bool isSelected2 = false;
  bool isAvailable = false;

  final FirebaseAuth auth = FirebaseAuth.instance;

  Future pickImage1(ImageSource imageSource) async {
    try {
      final pickedFile = await picker.pickImage(
        source: imageSource,
        imageQuality: 50,
      );
      if (pickedFile != null) {
        setState(() {
          isSelected1 = true;
          _imageFile1 = File(pickedFile.path);
        });
      }
    } catch (e) {}
  }

  Future pickImage2(ImageSource imageSource) async {
    try {
      final pickedFile = await picker.pickImage(
        source: imageSource,
        imageQuality: 50,
      );
      if (pickedFile != null) {
        setState(() {
          isSelected2 = true;
          _imageFile2 = File(pickedFile.path);
        });
      }
    } catch (e) {}
  }

  Future uploadProduct() async {
    try {
      buildShowDialog(context);

      final ref1 = storage.FirebaseStorage.instance
          .ref()
          .child("NIDImages/${DateTime.now()}" + "image1");

      final ref2 = storage.FirebaseStorage.instance
          .ref()
          .child("NIDImages/${DateTime.now()}" + "image2");

      final result1 = await ref1.putFile(_imageFile1);
      final result2 = await ref2.putFile(_imageFile2);
      final url1 = await result1.ref.getDownloadURL();
      final url2 = await result2.ref.getDownloadURL();

      FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update(
        {
          "nid1": url1,
          "nid2": url2,
          "nidNumber": nidController.text,
        },
      );

      Navigator.of(context, rootNavigator: true).pop();
      Navigator.pop(context);
    } catch (e) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  buildShowDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(color: Color(0xffFCCFA8)),
        );
      },
    );
  }

  TextEditingController nidController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    var pro = Provider.of<ProfileProvider>(context, listen: false);

    if (pro.nid1.isNotEmpty) {
      isAvailable = true;
      nidController.text = pro.nidNumber;
    }

    return Scaffold(
      appBar: customAppBar("Edit Profile", Color(0xff28292E)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: isSelected1
                  ? Image.file(_imageFile1)
                  : Center(
                      child: TextButton(
                        onPressed: () {
                          pickImage1(ImageSource.gallery);
                        },
                        child: Container(
                          width: size.width * 0.4,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(20)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.upload,
                                color: Colors.black,
                                size: 18,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                "Select Image",
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.6)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey,
                image: DecorationImage(
                  image: NetworkImage(isAvailable
                      ? pro.nid1
                      : "https://htmlcolorcodes.com/assets/images/colors/light-gray-color-solid-background-1920x1080.png"),
                ),
              ),
              height: size.height * 0.3,
              width: double.infinity,
            ),
            Container(
              child: isSelected2
                  ? Image.file(_imageFile2)
                  : Center(
                      child: TextButton(
                        onPressed: () {
                          pickImage2(ImageSource.gallery);
                        },
                        child: Container(
                          width: size.width * 0.4,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(20)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.upload,
                                color: Colors.black,
                                size: 18,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                "Select Image",
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.6)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey,
                image: DecorationImage(
                  image: NetworkImage(isAvailable
                      ? pro.nid2
                      : "https://htmlcolorcodes.com/assets/images/colors/light-gray-color-solid-background-1920x1080.png"),
                ),
              ),
              height: size.height * 0.3,
              width: double.infinity,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: buildDescriptionContainer(
                  1, nidController, "Enter NID number"),
            ),
            buildTextButton(
              "Upload NID",

            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextButton(String text) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: SizedBox(
        width: double.infinity,
        child: TextButton(
          onPressed: () {
            uploadProduct();
            Navigator.of(context).pop();
          },
          child: Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          style: ButtonStyle(
            side: MaterialStateProperty.all(
              BorderSide(
                color: Color(0xffFCCFA8),
              ),
            ),
            padding:
                MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 20)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

InputDecoration buildInputDecoration(String text) {
  return InputDecoration(
    filled: true,
    fillColor: Color(0xff444444),
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Colors.transparent,
        )),
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Colors.transparent,
        )),
    errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Colors.transparent,
        )),
    focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: Colors.transparent,
        )),
    hintText: text,
    hintStyle: GoogleFonts.poppins(color: Colors.white),
  );
}

Widget buildTitleText(String text, double size, double height) {
  return Container(
    alignment: Alignment.centerLeft,
    width: 220,
    child: Text(
      text,
      style: GoogleFonts.poppins(color: Color(0xffFCCFA8), fontSize: size),
    ),
  );
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
