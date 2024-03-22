import 'package:equran/screens/speech_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:equran/screens/quran_screen.dart';
import 'package:equran/screens/signup_screen.dart';
import 'controllers/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:equran/constants/constants.dart';
import 'package:equran/screens/signin_screen.dart';
import 'package:equran/screens/splash_screen.dart';
import 'screens/qari_screen.dart';
import 'screens/jus_screen.dart';
import 'screens/surah_detail.dart';
import 'screens/main_screen.dart';
import 'package:get/get.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    runApp(const MyApp());
  } catch (e) {

    // Print the error message
    print(e.toString());
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'E-Quran',
      theme: ThemeData(
          primarySwatch: Constants.kSwatchColor,
          primaryColor: Constants.kPrimary,
          scaffoldBackgroundColor: Colors.white,
          fontFamily: 'Poppins'
      ),
      home: SplashScreen() ,
      routes: {
        JuzScreen.id:(context)=>JuzScreen(),
        Surahdetail.id:(context)=>const Surahdetail(),
      },
      getPages: [
        GetPage(name: '/', page: () => const SplashScreen()),
        GetPage(name: '/login', page: () => const SignInScreen()),
        GetPage(name: '/register', page: () => const SignUpScreen()),
        GetPage(name: '/main', page: () => const MainScreen()),
      ],
    );
  }
}
