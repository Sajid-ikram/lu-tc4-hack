
import 'package:bit_by_bit/Screens/product/add_product.dart';
import 'package:bit_by_bit/providers/authentication.dart';
import 'package:bit_by_bit/providers/fav_notification_provider.dart';
import 'package:bit_by_bit/providers/fav_provider.dart';
import 'package:bit_by_bit/providers/product_provider.dart';
import 'package:bit_by_bit/providers/profile_provider.dart';
import 'package:bit_by_bit/providers/warning.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'Screens/Favourite/fav_screen.dart';
import 'Screens/Home/home.dart';
import 'Screens/Home/home_controller.dart';
import 'Screens/login/signIn_and_login.dart';
import 'Screens/product/product_detail_page.dart';
import 'Screens/profile/profile.dart';
import 'Screens/profile/select_image.dart';
import 'helperWidgets/email_and_home_screen.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Authentication()),
        ChangeNotifierProvider(create: (_) => Warning()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => HomeController()),
        ChangeNotifierProvider(create: (_) => FavProvider()),
        ChangeNotifierProvider(create: (_) => FavNotificationProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(

          textTheme: GoogleFonts.poppinsTextTheme(
            Theme.of(context).textTheme,
          ),
          primarySwatch: Colors.blueGrey,
          scaffoldBackgroundColor: const Color(0xff28292E),
        ),
        home: FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Exception(
              massage: "An Error occur",
            );
          }

          if (snapshot.connectionState == ConnectionState.done) {
            return const MiddleOfHomeAndSignIn();
          }

          return const Exception(
            massage: "Loading",
          );
        },
      ),
        routes: {
          "profile": (ctx) => const Profile(),
          "selectImage": (ctx) => const SelectImage(),
          "productDetailPage": (ctx) => const ProductDetailPage(),
          "cartPage": (ctx) => const FavScreen(),
          "AddProduct": (ctx) => const AddProduct(),
        },
      ),
    );
  }
}

class Exception extends StatelessWidget {
  const Exception({Key? key, required this.massage}) : super(key: key);
  final String massage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: massage == "Error"
            ? const Text("An error occur")
            : const CircularProgressIndicator(),
      ),
    );
  }
}

class MiddleOfHomeAndSignIn extends StatefulWidget {
  const MiddleOfHomeAndSignIn({Key? key}) : super(key: key);

  @override
  _MiddleOfHomeAndSignInState createState() => _MiddleOfHomeAndSignInState();
}

class _MiddleOfHomeAndSignInState extends State<MiddleOfHomeAndSignIn> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: Provider.of<Authentication>(context).authStateChange,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xffFCCFA8)),
          );
        }
        if(snapshot.data != null && snapshot.data!.emailVerified){
          return const Home();
        }
        return snapshot.data == null ? SignInAndSignUp() : const VerificationAndHomeScreen();
      },
    );
  }
}



