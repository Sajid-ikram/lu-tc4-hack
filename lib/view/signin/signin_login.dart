import 'package:bit_by_bit/view/signin/text_helper.dart';
import 'package:flutter/material.dart';

import 'build_button.dart';

class SignInSignUp extends StatefulWidget {
  const SignInSignUp({Key? key}) : super(key: key);

  @override
  State<SignInSignUp> createState() => _SignInSignUpState();
}

class _SignInSignUpState extends State<SignInSignUp> {
  int index = 0;

  Widget signIn(Size size) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome Back",
              style: TextStyle(
                fontSize: size.height * 0.031,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: size.height * 0.013),
            const Text(
              "Sign in to your account",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 30),
            textField(Icons.email_outlined, "Phone Number", Colors.white, ""),
            const SizedBox(height: 20),
            InkWell(
              onTap: () {},
              child: Container(
                color: Colors.green,
                height: 50,
                width: double.infinity,
                child:
                    buildButton(Icons.cancel, "Login", 22, size, Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  "Don't have an account? ",
                  style: TextStyle(fontSize: 15, color: Colors.grey),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      index = 1;
                    });
                  },
                  child: const Text(
                    "Sign UP",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


  Widget signUp(Size size) {
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Create Account!",
              style: TextStyle(
                  fontSize: size.height * 0.031,
                  fontWeight: FontWeight.bold,
                  color: Colors.black.withOpacity(0.6)),
            ),
            SizedBox(height: size.height * 0.013),
            Text(
              "Quickly create account",
              style: TextStyle(
                color: Colors.black.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 30),
            textField(Icons.email_outlined, "First Name", Colors.white, ""),
            textField(Icons.phone_outlined, "Last Name", Colors.white, ""),
            textField(Icons.lock_outlined, "Phone Number", Colors.white, ""),
            const SizedBox(height: 10),
            InkWell(
              onTap: () {

              },
              child: Container(
                color: Colors.green,
                height: 50,
                width: double.infinity,
                child:
                buildButton(Icons.cancel, "SignUp", 21, size, Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  "Already have an account? ",
                  style: TextStyle(fontSize: 15, color: Colors.grey),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      index = 0;
                    });
                  },
                  child: const Text(
                    "Sign In",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<String> names = ["LogIn", "SignUp"];
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraint) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraint.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Expanded(
                          //fit: FlexFit.loose,
                          //height: size.height * 0.6,
                          child: Container(
                            padding: EdgeInsets.fromLTRB(
                                20, size.height * 0.09, 20, 0),
                            color: const Color(0xffffe6e6),
                            child: Image.asset(
                              "assets/intro.png",
                              fit: BoxFit.scaleDown,
                            ),
                          ),
                        ),
                        index == 0 ? signIn(size) : signUp(size),
                        const SizedBox(height: 30)
                      ],
                    ),
                    const Align(
                      alignment: Alignment.center,
                      heightFactor: 6,
                      child: Text(
                        "Sign In",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      heightFactor: 2.66,
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            //index = 1;
                          });
                        },
                        icon: const Icon(Icons.arrow_back_rounded),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
