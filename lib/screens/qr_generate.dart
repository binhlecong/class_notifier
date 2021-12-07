import 'dart:convert';

import 'package:class_notifier/models/classroom.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class GeneratePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GeneratePageState();
}

class _GeneratePageState extends State<GeneratePage> {
  String qrData = "https://github.com/tienthanh214/Flutter-Training-DevFest2021";
  final _qrDataFeed = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code Generator'),
        actions: <Widget>[],
      ),
      body: _buildQRGenerator(),
    );
  }

  Widget _buildQRGenerator() {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(18.0),
        children: <Widget>[
          const SizedBox(height: 80.0),
          Column(
            children: <Widget>[
              Text(
                'QR Code Result',
                style: Theme.of(context).textTheme.headline2,
              )
            ],
          ),
          const SizedBox(height: 40.0),
          Center(
            child: QrImage(
              data: qrData,
              size: 320,
              // gapless: false,
              errorStateBuilder: (cxt, err) {
                return const Center(
                  child: Text(
                    "Uh oh! Something went wrong...",
                    textAlign: TextAlign.center,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 40.0),
          TextField(
            controller: _qrDataFeed,
          ),
          Padding(
            padding: EdgeInsets.all(18.0),
            child: ElevatedButton(
              child: const Text('Submit'),
              onPressed: () async { 
                if (_qrDataFeed.text.isEmpty) {
                  setState(() {
                    Classroom room = Classroom.fromParams("Title 1", "Text bro", 30, DateTime.now(), 0, "no", 1);
                    Map mRoom = room.toMap(); mRoom.remove("id");
                    var json = jsonEncode(mRoom);
                    _qrDataFeed.text = json;
                    qrData = _qrDataFeed.text;
                  });
                } else {
                  setState(() {
                    qrData = _qrDataFeed.text;
                    print(qrData.length);
                  });
                }
              },
            )
          )
  
        ],
      ),
    );
  }

  
}