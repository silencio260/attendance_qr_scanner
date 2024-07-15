import 'dart:developer';
import 'dart:io';

import 'package:attendaceqrscanner/attendace_model.dart';
import 'package:attendaceqrscanner/welcome_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:attendaceqrscanner/scan_qr_code.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:attendaceqrscanner/display_all_attendace.dart';

import 'boxes.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(AttendaceAdapter());
  attendaceBox = await Hive.openBox<Attendace>('attendaceBox');
  runApp(MaterialApp(home: WelcomeScreen()));
}

class MyHome extends StatelessWidget {
  const MyHome({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Attendace')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const QRViewExample(),
                  ));
                },
                child: const Text('Scan QR Code'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => DisplayAttendaceList(),
                  ));
                },
                child: const Text('View Attendace List'),
              ),
            ],
          ),
        )
//      body: Container(child: DisplayAttendaceList()),
        );
  }
}
