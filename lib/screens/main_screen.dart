import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:equran/screens/home_screen.dart';
import 'package:equran/screens/qari_screen.dart';
import 'package:equran/screens/speech_screen.dart';
import 'package:equran/screens/user_screen.dart';
import 'package:equran/screens/quran_screen.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectIndex = 0;
  final List<Widget> _widgetlists = [
    const HomeScreen(),
    const QuranScreen(),
          SpeechScreen(),
    const QariListScreen(),
    const UserScreen(),

  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(child:
    Scaffold(
      body: _widgetlists[selectIndex],
        bottomNavigationBar: ConvexAppBar(
            height:68,
          items: [
            const TabItem(icon: Icons.home, title: 'Home'),
            TabItem(icon:Image.asset('assets/Koran.png',color: Colors.white70), title: 'Quran',
                activeIcon: Image.asset('assets/Koran.png', color: Colors.brown)),
            const TabItem(icon: Icons.mic, title: 'Speech'),
            const TabItem(icon: Icons.headphones_rounded,title: 'Audio'),
            const TabItem(icon: Icons.people, title: 'Profile',),
          ],
          initialActiveIndex: 0,
          onTap: updateIndex,
          backgroundColor: Colors.brown,
        ),

    ),

    );
  }

  void updateIndex(index) {
    setState(() {
      selectIndex = index;
    });
  }
}