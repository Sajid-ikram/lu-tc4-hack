import 'package:bit_by_bit/Screens/Home/home.dart';
import 'package:bit_by_bit/providers/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class VerificationAndHomeScreen extends StatefulWidget {
  const VerificationAndHomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  _VerificationAndHomeScreenState createState() =>
      _VerificationAndHomeScreenState();
}

class _VerificationAndHomeScreenState extends State<VerificationAndHomeScreen> {
  bool isVerified = false;
  bool isLoading = false;

  Future checkVerification() async {
    setState(() {
      isLoading = true;
    });

    User? user = FirebaseAuth.instance.currentUser;
    await user!.reload();
    user = FirebaseAuth.instance.currentUser;
    isVerified = user!.emailVerified;

    if (!isVerified) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Not verified yet',
            style: TextStyle(color: Colors.black),
            textAlign: TextAlign.center,
          ),
          duration: Duration(seconds: 4),
          backgroundColor: Color(0xffEF4F4F),
        ),
      );
    }

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  sendVerificationLink() {
    final User? user = FirebaseAuth.instance.currentUser;
    user!.sendEmailVerification();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Verification mail sent',
          style: TextStyle(color: Colors.black),
          textAlign: TextAlign.center,
        ),
        duration: Duration(seconds: 1),
        backgroundColor: Color(0xff50CB93),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    return isLoading
        ? const Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: Color(0xffFCCFA8),
              ),
            ),
          )
        : isVerified
            ? Home()
            : _buildScaffold();
  }

  Scaffold _buildScaffold() {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Provider.of<Authentication>(context, listen: false).deleteUser();
          },
        ),
        backgroundColor: Color(0xff28292E),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Verify your email',
              style: TextStyle(
                  color: Color(0xffFCCFA8),
                  fontSize: 26,
                  fontWeight: FontWeight.bold),
            ),
            const Text(
              'A verification link is sent to your email, click in the link to verify your email',
              style: TextStyle(
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(10),
              child: Image.asset("assets/ver.png"),
            )),
            MaterialButton(
              color: Color(0xffFCCFA8),
              minWidth: double.infinity,
              height: 50,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0)),
              child: Text(
                'Check Verification',
                style: GoogleFonts.poppins(color: Colors.black),
              ),
              onPressed: () async {
                checkVerification();
              },
            ),
            TextButton(
              child: Text(
                'Resend mail',
                style: GoogleFonts.poppins(color: Colors.white),
              ),
              onPressed: () async {
                sendVerificationLink();
              },
            ),
            SizedBox(
              height: 25,
            )
          ],
        ),
      ),
    );
  }
}
