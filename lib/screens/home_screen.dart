
import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import 'package:equran/constants/constants.dart';
import 'package:equran/models/aya_of_the_day.dart';
import 'package:equran/services/api_services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiServices _apiServices = ApiServices();
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery
        .of(context)
        .size;
    HijriCalendar.setLocal('ar');
    var hijri = HijriCalendar.now();
    var day = DateTime.now();
    var format = DateFormat('EEE, d MMM yyyy');
    var formatted = format.format(day);

    // ...

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/back_image3.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Use Expanded to take the available space
            Expanded(
              child: Center(
                child: Container(
                  width: 350,
                  height: 350,
                  decoration: BoxDecoration(
                    color: Colors.brown.withOpacity(0.2),
                    border: Border.all(
                      width: 20,
                      color: Colors.transparent,
                    ), // Set your border color
                    image: const DecorationImage(
                      image: AssetImage('assets/borders.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child:SingleChildScrollView(
                    child: Column(
                    children: [
                      FutureBuilder<AyaOfTheDay>(
                        future: _apiServices.getAyaOfTheDay(),
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.none:
                              return const Icon(Icons.sync_problem);
                            case ConnectionState.waiting:
                            case ConnectionState.active:
                              return const CircularProgressIndicator();
                            case ConnectionState.done:
                              return Column(
                                children: [
                                  const Text(
                                    "Aya of the Day",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  const Divider(
                                    color: Colors.black,
                                    thickness: 0.5,
                                  ),
                                  Text(
                                    snapshot.data!.arText!,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    snapshot.data!.enTran!,
                                    style: const TextStyle(
                                      color: Colors.black87,
                                      fontSize: 18,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                               );
                          }
                        },
                      ),
                    ],
                  ),),
                ),
              ),
            ),
            Positioned(
              top: 20,
              left: 20,
              child: SizedBox(
                height: size.height * 0.22,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: <InlineSpan>[
                          WidgetSpan(
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                hijri.hDay.toString(),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: themebackground.br,
                                ),
                              ),
                            ),
                          ),
                          WidgetSpan(
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                hijri.longMonthName,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: themebackground.br,
                                ),
                              ),
                            ),
                          ),
                          WidgetSpan(
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                '${hijri.hYear} AH',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: themebackground.br,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      formatted,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: themebackground.br,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}