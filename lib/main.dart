import 'package:bit_by_bit/view/signin/signin_login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.rubikTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: Scaffold(
        body: FutureBuilder(
          // Initialize FlutterFire:
          future: _initialization,
          builder: (context, snapshot) {
            // Check for errors
            if (snapshot.hasError) {
              return const Center(child: Text("Error !!!!"));
            }

            // Once complete, show your application
            if (snapshot.connectionState == ConnectionState.done) {
              return const SignInSignUp();
            }

            // Otherwise, show something whilst waiting for initialization to complete
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.amberAccent,
              ),
            );
          },
        ),
      ),
    );
  }
}
