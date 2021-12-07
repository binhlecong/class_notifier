import 'package:class_notifier/database/db_helper.dart';
import 'package:class_notifier/models/classroom.dart';
import 'package:class_notifier/screens/scan_qr.dart';
import 'package:class_notifier/widgets/classroomcard.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'classroompage.dart';
import 'package:class_notifier/styles/colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kGreen50,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Column(
            children: <Widget>[
              Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30.0),
                        bottomRight: Radius.circular(30.0),
                      ),
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0.0, 2.0),
                          blurRadius: 5.0,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(30.0),
                        bottomRight: Radius.circular(30.0),
                      ),
                      child: Lottie.asset(
                        'assets/happy-study.json',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 40.0),
                    child: Row(
                      children: <Widget>[
                        IconButton(
                            icon: const Icon(Icons.qr_code),
                            iconSize: 30.0,
                            color: Colors.black,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ScanPage(),
                                ),
                              ).then((value) {
                                setState(() {});
                              });
                            }),
                      ],
                    ),
                  ),
                ],
              ),
              _buildList(),
            ],
          ),
          Positioned(
            bottom: 24.0,
            right: 24.0,
            child: FloatingActionButton(
              child: const Icon(
                Icons.add,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ClassroomPage(
                      classroom: null,
                    ),
                  ),
                ).then((value) {
                  setState(() {});
                });
              },
            ),
          )
        ],
      ),
    );
  }

  Expanded _buildList() {
    return Expanded(
      child: FutureBuilder<List<Classroom>>(
        initialData: const [],
        future: _dbHelper.getClassrooms(),
        builder: (context, snapshot) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (BuildContext context, int index) {
              if (snapshot.hasData) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ClassroomPage(
                          classroom: snapshot.data![index],
                        ),
                      ),
                    ).then((value) => setState(() {}));
                  },
                  child: ClassroomCard(classroom: snapshot.data![index]),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          );
        },
      ),
    );
  }
}
