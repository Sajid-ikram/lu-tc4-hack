import 'package:bit_by_bit/helperWidgets/appBar.dart';
import 'package:bit_by_bit/providers/profile_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var pro = Provider.of<ProfileProvider>(context, listen: false);

    if (pro.profileName.isNotEmpty) {
      nameController.text = pro.profileName;
      phoneController.text = pro.phone;
    }
    return Scaffold(
      appBar: customAppBar("Edit Profile", Color(0xff343A40)),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              style: TextStyle(color: Colors.white),
              autofillHints: [AutofillHints.email],
              controller: nameController,
              keyboardAppearance: Brightness.light,
              keyboardType: TextInputType.emailAddress,
              decoration: buildInputDecoration("Name"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              style: TextStyle(color: Colors.white),
              autofillHints: [AutofillHints.email],
              controller: phoneController,
              keyboardAppearance: Brightness.light,
              keyboardType: TextInputType.emailAddress,
              decoration: buildInputDecoration("Phone Number"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  FirebaseFirestore.instance
                      .collection("users")
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .update(
                    {
                      "name": nameController.text,
                      "phone": phoneController.text,
                    },
                  );
                  Navigator.of(context).pop();
                },
                child: const Text(
                  "Update Profile",
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
          )
        ],
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
    hintStyle: GoogleFonts.poppins(color: Colors.grey),
  );
}


