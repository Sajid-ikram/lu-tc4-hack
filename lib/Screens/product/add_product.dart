import 'dart:io';
import 'package:bit_by_bit/helperWidgets/appBar.dart';
import 'package:bit_by_bit/providers/product_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as storage;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({Key? key}) : super(key: key);

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final picker = ImagePicker();
  late File _imageFile;
  bool isSelected = false;

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

  Future uploadProduct() async {
    try {
      buildShowDialog(context);
      /*final ref = storage.FirebaseStorage.instance
          .ref()
          .child(auth.currentUser!.uid);*/

      final ref = storage.FirebaseStorage.instance.ref().child(
          "productImage/${DateTime.now()}");

      final result = await ref.putFile(_imageFile);
      final url = await result.ref.getDownloadURL();
      Provider.of<ProductProvider>(context, listen: false).addProductUrl(
          url: url,
          category: dropdownValue,
          description: descriptionController.text,
          name: productNameController.text,
          price: priceController.text,
          date: selectedDate
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

  String dropdownValue = 'Electronics';
  TextEditingController descriptionController = TextEditingController();
  TextEditingController productNameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);

    return Scaffold(
      appBar: customAppBar("Edit Profile", Color(0xff28292E)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: isSelected
                  ? Image.file(_imageFile)
                  : Center(
                child: TextButton(
                  onPressed: () {
                    pickImage(ImageSource.gallery);
                  },
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
              margin: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Colors.grey,
              ),
              height: size.height * 0.3,
              width: double.infinity,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child:
              buildDescriptionContainer(1, productNameController, "Name"),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: buildDescriptionContainer(
                  3, descriptionController, "Description"),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child:
              buildDescriptionContainer(1, priceController, "Minimum Bid"),
            ),
            Container(
              height: 65,
              width: double.infinity,
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Color(0xff444444),
                  borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: SizedBox(
                width: MediaQuery
                    .of(context)
                    .size
                    .width - 40,
                child: DropdownButton<String>(
                  dropdownColor: Color(0xff444444),
                  isExpanded: true,
                  borderRadius: BorderRadius.circular(12),
                  hint: const Text(
                    "Buyer",
                    style: TextStyle(fontSize: 18),
                  ),
                  value: dropdownValue,
                  icon: const Icon(Icons.arrow_downward),
                  iconSize: 18,
                  elevation: 16,
                  style: const TextStyle(color: Colors.white),
                  underline: const SizedBox(),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue!;
                    });
                  },
                  items: <String>[
                    "Electronics",
                    "Games",
                    "Accessories",
                    "Fashion",
                    "Books",
                    "Grocery",
                    "Health Care",
                    "Sports",
                    "Others",
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Expiration Date : $formattedDate',
                    style: TextStyle(color: Colors.white),
                  ),
                  TextButton(
                    onPressed: () {
                      _selectDate(context);
                    },
                    child: Text('Select date',
                      style: TextStyle(color: Color(0xffFCCFA8)),),
                  ),
                ],
              ),
            ),
            buildTextButton(
              "Upload Product",
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  Widget buildTextButton(String text) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: SizedBox(
        width: double.infinity,
        child: TextButton(
          onPressed: () {
            uploadProduct();
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

Container buildDescriptionContainer(int line,
    TextEditingController descriptionController, String text) {
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
