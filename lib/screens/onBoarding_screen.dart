import 'package:flutter/material.dart';
import 'package:equran/screens/main_screen.dart';
import 'package:equran/constants/constants.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  List<Map<String, dynamic>> onBoardingData = [
    {
      'image': "assets/as.png",
      'title': ' E-Quran',
      'description': 'Welcome To Our App',

    },
    {
      'image':"assets/l.png",
      'title': 'E-Quran',
      'description':
      'This App Purpose is To Give You Better Understanding Of Quran',

    },
    {
      'image': "assets/q.png",
      'title': 'E-Quran',
      'description': 'And Help You Correcting Your Pronunciation Using AI',

    },
  ];

  late PageController pageController; // Define pageController

  @override
  void initState() {
    super.initState();
    pageController = PageController(); // Initialize pageController
  }

  continueMethod() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const MainScreen()),
          (Route<dynamic> route) => false,
    );
  }

  int currentPage = 0;
  onChanged(int index) {
    setState(() {
      currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Constants.kPrimary,
            themebackground.white,
            themebackground.grayish,
            themebackground.greenish,
            themebackground.green,
          ],
          begin: Alignment(0.00, -1.00),
          end: Alignment(0, 1),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          actions: [
            TextButton(
              onPressed: continueMethod,
              child: const Text('Skip', style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        body: Stack(
          children: [
            PageView.builder(
              scrollDirection: Axis.horizontal,
              controller: pageController,
              itemCount: onBoardingData.length,
              onPageChanged: onChanged,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Image.asset(onBoardingData[index]['image']),
                    Text(
                      onBoardingData[index]['title'],
                      style: const TextStyle(color: Colors.black),
                    ),

                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      onBoardingData[index]['description'],
                      style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold,),
                    ),
                    //Image.asset(onBoardingData[index]['image 2']),
                  ],
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  (currentPage == (onBoardingData.length - 1))
                      ? ElevatedButton(
                    onPressed: continueMethod,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown, // Set button color to brown
                    ),
                    child: const Text(
                      'Continue',
                      style: TextStyle(color: Colors.white), // Set text color to white
                    ),
                  )
                      : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ...List<Widget>.generate(onBoardingData.length,
                              (index) {
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              height: 10,
                              width: (index == currentPage) ? 15 : 10,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 5,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: (index == currentPage)
                                    ? themebackground.br
                                    : themebackground.w,
                              ),
                            );
                          }),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
