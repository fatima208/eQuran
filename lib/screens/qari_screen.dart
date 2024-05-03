import 'package:flutter/material.dart';
import 'package:equran/constants/constants.dart';

import '../models/qari.dart';
import '../services/api_services.dart';
import '../widgets/qari_custom_tile.dart';
import 'audio_surah_screen.dart';

class QariListScreen extends StatefulWidget {
  const QariListScreen({super.key});

  @override
  _QariListScreenState createState() => _QariListScreenState();
}

class _QariListScreenState extends State<QariListScreen> {
  ApiServices apiServices = ApiServices();
  TextEditingController _searchController = TextEditingController();
  late List<Qari> _qariList = [];

  @override
  void initState() {
    super.initState();
    _getQariList();
  }

  Future<void> _getQariList() async {
    final List<Qari> qariList = await apiServices.getQariList();
    setState(() {
      _qariList = qariList;
    });
  }

  List<Qari> _filteredQariList(String query) {
    return _qariList.where((qari) {
      final qariName = qari.name?.toLowerCase();
      return qariName!.contains(query.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(
              'Qari\'s',
              style: TextStyle(
                color: themebackground.w,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          backgroundColor: themebackground.br,
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/back_image.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black54,
                        blurRadius: 1,
                        spreadRadius: 0.0,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            onChanged: (value) {
                              setState(() {});
                            },
                            decoration: InputDecoration(
                              hintText: 'Search',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            _searchController.clear();
                            setState(() {});
                          },
                          icon: _searchController.text.isEmpty ? Icon(Icons.search) : Icon(Icons.clear),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: _filteredQariList(_searchController.text).length,
                    itemBuilder: (context, index) {
                      final qari = _filteredQariList(_searchController.text)[index];
                      return QariCustomTile(
                        qari: qari,
                        ontap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AudioSurahScreen(qari: qari),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
