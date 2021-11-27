import 'dart:io';
import 'package:bit_by_bit/helperWidgets/appBar.dart';
import 'package:bit_by_bit/providers/profileProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as storage;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({Key? key}) : super(key: key);

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final picker = ImagePicker();
  late File _imageFile;
  bool isSelected = false;
  TextEditingController productNameController = TextEditingController();

  final FirebaseAuth auth = FirebaseAuth.instance;

  Future pickImage(ImageSource imageSource) async {
    try {
      final pickedFile = await picker.pickImage(
        source: imageSource,
        imageQuality: 50,
      );
      if (pickedFile != null) {
        setState(() {
          isSelected = true;
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {}
  }

  Future uploadProfile() async {
    try {
      buildShowDialog(context);
      final ref = storage.FirebaseStorage.instance
          .ref()
          .child("profileImage")
          .child(auth.currentUser!.uid);

      final result = await ref.putFile(_imageFile);
      final url = await result.ref.getDownloadURL();
      Provider.of<ProfileProvider>(context, listen: false)
          .updateProfileUrl(url, auth.currentUser!.uid);
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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: customAppBar("Edit Profile", Color(0xff28292E)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: isSelected
                  ? Image.file(_imageFile)
                  : const Center(child: Text("No Image selected!")),
              margin: const EdgeInsets.only(bottom: 10),
              decoration: const BoxDecoration(
                color: Colors.grey,
              ),
              height: size.height * 0.4,
              width: double.infinity,
            ),
            TextFormField(
                style: TextStyle(color: Colors.white),
                controller: productNameController,
                obscureText: true,
                validator: (value) {
                  return value == null || value.isEmpty
                      ? "Enter a Password"
                      : value.length < 6
                      ? "Length should be more than 6"
                      : null;
                },
                decoration: buildInputDecoration("Password"))
            ,
            buildTextButton(
              "Upload Profile",
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
            if (text == "Camera") {
              pickImage(ImageSource.camera);
            } else if (text == "Gallery") {
              pickImage(ImageSource.gallery);
            } else if (text == "Upload Profile") {
              uploadProfile();
            }
          },
          child: Text(
            text,
            style: TextStyle(
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
