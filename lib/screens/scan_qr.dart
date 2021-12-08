import 'dart:convert';
import 'dart:io';

import 'package:class_notifier/models/classroom.dart';
import 'package:class_notifier/screens/classroompage.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  var qrCodeResult = "Scan a code";
  QRViewController? controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Classroom Scan QR Code'),
        centerTitle: true,
      ),
      body: _buildQRScanner(),
    );
  }

  Widget _buildQRScanner() {
    return Column(
      children: <Widget>[
        Expanded(
          flex: 5,
          child: _buildQRView(context),
        ),
      ],
    );
  }

  Widget _buildQRView(BuildContext context) {
    var scanArea = 300.0;
    if (MediaQuery.of(context).size.width < 400 || MediaQuery.of(context).size.height < 400) {
      scanArea = 150.0;
    }
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: Colors.red,
        borderRadius: 10,
        borderLength: 30,
        borderWidth: 10,
        cutOutSize: scanArea,
      ),
    ); 
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    bool scanned = false;
    controller.scannedDataStream.listen((scanData) {
      setState(() async {
        qrCodeResult = scanData.code;
        Map<String, dynamic> result = jsonDecode(qrCodeResult);
        if (result.containsKey('class_notifier')) {
          if (scanned == true) return;
          scanned = true;
          controller.pauseCamera();
          result.remove('class_notifier');
          Classroom classroom = Classroom.fromMap(result);
          dynamic pop = Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ClassroomPage(
                classroom: classroom,
              ),
            ),
          ).then((value) => {
            controller.resumeCamera(),
            scanned = false
          });
          // controller.resumeCamera();
          // scanned = false;
        }
        
      });
    });
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}