import 'package:bit_by_bit/providers/authentication.dart';
import 'package:bit_by_bit/providers/warning.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'error_dialog.dart';

class SignInAndSignUp extends StatefulWidget {
  @override
  _SignInAndSignUpState createState() => _SignInAndSignUpState();
}

class _SignInAndSignUpState extends State<SignInAndSignUp> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  bool isVerified = false;
  bool isLoading = false;
  bool _isSignUp = false;
  final _emailKey = GlobalKey<FormState>();
  final _nameKey = GlobalKey<FormState>();
  final _passKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.clear();
    passwordController.clear();
    nameController.clear();
    otpController.clear();
    super.dispose();
  }

  validate(String dValue) async {
    if (_isSignUp) {
      if (_passKey.currentState!.validate() &&
          _emailKey.currentState!.validate() &&
          _nameKey.currentState!.validate()) {
        buildShowDialog(context);
        Provider.of<Authentication>(context, listen: false)
            .signUp(emailController.text, passwordController.text,
                nameController.text, context,dValue)
            .then((value) async {
          if (value != "Success") {
            Provider.of<Warning>(context, listen: false)
                .showWarning(value, Colors.amber, true);
          } else {
            final User? user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              user.sendEmailVerification();
            }
          }
        });
      }
    } else {
      if (_passKey.currentState!.validate() &&
          _emailKey.currentState!.validate()) {
        buildShowDialog(context);
        Provider.of<Authentication>(context, listen: false)
            .signIn(emailController.text, passwordController.text, context)
            .then(
          (value) {
            if (value != "Success") {
              Provider.of<Warning>(context, listen: false)
                  .showWarning(value, Colors.amber, true);
            }
          },
        );
      }
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
        });
  }
  String dropdownValue = 'Seller';

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: Color(0xFF2B2B2B),
      appBar: AppBar(
        title: Text(
          "Ecommerce",
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Stack(
              children: [
                SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 13),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.20),
                        Form(
                          key: _emailKey,
                          child: TextFormField(
                            style: TextStyle(color: Colors.white),
                            autofillHints: [AutofillHints.email],
                            controller: emailController,
                            validator: (value) {
                              return value == null || value.isEmpty
                                  ? "Enter a Email"
                                  : value.contains('@') &&
                                          value.contains('.com')
                                      ? null
                                      : "Enter a valid email";
                            },
                            keyboardAppearance: Brightness.light,
                            keyboardType: TextInputType.emailAddress,
                            decoration: buildInputDecoration("Email"),
                          ),
                        ),
                        SizedBox(height: 10),
                        if (_isSignUp)
                          Form(
                            key: _nameKey,
                            child: TextFormField(
                              style: TextStyle(color: Colors.white),
                              controller: nameController,
                              validator: (value) {
                                return value == null || value.isEmpty
                                    ? "Enter your name"
                                    : null;
                              },
                              keyboardType: TextInputType.name,
                              decoration: buildInputDecoration("Name"),
                            ),
                          ),
                        if (_isSignUp) SizedBox(height: 10),
                        Form(
                          key: _passKey,
                          child: TextFormField(
                              style: TextStyle(color: Colors.white),
                              controller: passwordController,
                              obscureText: true,
                              validator: (value) {
                                return value == null || value.isEmpty
                                    ? "Enter a Password"
                                    : value.length < 6
                                        ? "Length should be more than 6"
                                        : null;
                              },
                              decoration: buildInputDecoration("Password")),
                        ),
                        if (_isSignUp)
                        Container(
                          height: 65,
                          width: double.infinity,
                          margin: EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                              color: Color(0xff444444),
                              borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width - 40,
                            child: DropdownButton<String>(
                              dropdownColor: Color(0xff444444),
                              isExpanded: true,
                              borderRadius: BorderRadius.circular(12),
                              hint: Text(
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
                                "Seller",
                                "Buyer",
                              ].map<DropdownMenuItem<String>>((String value) {

                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        SizedBox(height: 25),
                        InkWell(
                          onTap: () {
                            validate(dropdownValue);
                          },
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: 18),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Color(0xffFCCFA8),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Text(
                              _isSignUp ? "Sign Up" : "Sign In",
                              style: GoogleFonts.poppins(
                                  fontSize: 16, color: Color(0xff2B2B2B)),
                            ),
                          ),
                        ),
                        SizedBox(height: 25),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              _isSignUp
                                  ? "Already have an account ? "
                                  : "Don't have an account ? ",
                              style: GoogleFonts.poppins(
                                  fontSize: 15, color: Colors.white),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isSignUp = !_isSignUp;
                                });
                              },
                              child: Text(
                                _isSignUp ? "Sign In" : "Sign Up",
                                style: GoogleFonts.poppins(
                                  decoration: TextDecoration.underline,
                                  fontSize: 15,
                                  color: Color(0xffFCCFA8),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 50),
                      ],
                    ),
                  ),
                ),
                ErrorDialog(),
              ],
            ),
    );
  }

  InputDecoration buildInputDecoration(String text) {
    return InputDecoration(
      filled: true,
      fillColor: const Color(0xff444444),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.transparent,
          )),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.transparent,
          )),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
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
}
