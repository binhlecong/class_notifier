import 'package:class_notifier/database/db_helper.dart';
import 'package:class_notifier/models/classroom.dart';
import 'package:class_notifier/widgets/classroomcard.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'classroompage.dart';

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
      resizeToAvoidBottomInset: false,
      body: Column(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.lightGreen,
                  offset: Offset(0.0, 2.0),
                  blurRadius: 5.0,
                ),
              ],
            ),
            child:  ClipRRect(
              borderRadius: BorderRadius.circular(30.0),
              child: Lottie.asset('assets/happy-study.json', fit: BoxFit.cover,),
            )
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 40.0),
            child: Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.qr_code),
                  iconSize: 30.0,
                  color: Colors.black,
                    onPressed: (){
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
                  }
                ),
              ],
            ),
          ),
          /*Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Welcome to our app',
                    style: TextStyle(
                      color: Colors.lightGreen,
                      fontSize: 36.0,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                    ),
                  )
                ],
              ),
            ),
          ),*/
          /*Positioned(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Welcome to our app',
                    style: TextStyle(
                      color: Colors.lightGreen,
                      fontSize: 36.0,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                    ),
                  )
                ],
              ),
          ),*/
          Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: FutureBuilder<List<Classroom>>(
                      initialData: const [],
                      future: _dbHelper.getClassrooms(),
                      builder: (context, snapshot) {
                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Stack(
                              children: <Widget> [
                                Container(
                                  margin: EdgeInsets.fromLTRB(40.0, 5.0, 20.0, 5.0),
                                  height: 180,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    gradient:
                                      LinearGradient(
                                          colors: [Colors.green, Colors.yellow],
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight
                                      ),
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            "Name of Class",
                                            style: TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.w600
                                            ),
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.delete),
                                            onPressed: () {
                                              //TODO: Add delete function
                                            },
                                          ),
                                        ],
                                      ),
                                      Text(
                                        "Date",
                                        style: TextStyle(
                                          color: Colors.grey
                                        ),
                                      ),
                                      SizedBox(width: 10.0),
                                      Container(
                                        width: 70.0,
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).accentColor,
                                          borderRadius:  BorderRadius.circular(10.0),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          "Mon"
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  )
                ],
              )
            ],
          ),
          Positioned(
            bottom: 24.0,
            right: 0.0,
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
}
