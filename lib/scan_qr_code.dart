import 'dart:developer';
import 'dart:io';

import 'package:attendaceqrscanner/attendace_model.dart';
import 'package:attendaceqrscanner/boxes.dart';
import 'package:attendaceqrscanner/display_all_attendace.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:attendaceqrscanner/attendace_list.dart';

class QRViewExample extends StatefulWidget {
  const QRViewExample({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  Barcode result;
  var ExtractedConent = ValueNotifier('');
  QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  String attendaceName;
  TextEditingController attendaceNameController = new TextEditingController(text: "");

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller.pauseCamera();
    }
    controller.resumeCamera();
  }

  var attendace = [];

  _addStudent(String value) {
    bool repeatValue = false;
    for (int i = 0; i < attendace.length; i++) {
      if (attendace[i] == value) {
        repeatValue = true;
        break;
      }
    }
    setState(() {
      if (repeatValue == false && value != '') {
//        print("-------------------------------------");
//        print(value);
//        print(attendace);
        attendace.add(value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(flex: 2, child: _buildQrView(context)),
          Expanded(
            flex: 1,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
//                  if (result != null)
//                    Text('Barcode Type: ${describeEnum(result.format)}   Data: ${result.code}')
//                  else
//                    const Text('Scan a code'),
                  Text(result == null ? 'Scan a code' : 'Barcode Data: ${result.code}'),
//                  Text(attendace.length < 1
//                      ? "No Value"
//                      : 'Scan ${attendace[attendace.length - 1]}'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                            onPressed: () async {
                              await controller?.toggleFlash();
                              setState(() {});
                            },
                            child: FutureBuilder(
                              future: controller?.getFlashStatus(),
                              builder: (context, snapshot) {
                                return Text('Flash: ${snapshot.data}');
                              },
                            )),
                      ),
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                            onPressed: () async {
                              await controller?.flipCamera();
                              setState(() {});
                            },
                            child: FutureBuilder(
                              future: controller?.getCameraInfo(),
                              builder: (context, snapshot) {
                                if (snapshot.data != null) {
                                  return Text('Camera facing ${describeEnum(snapshot.data)}');
                                } else {
                                  return const Text('loading');
                                }
                              },
                            )),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                          onPressed: () async {
                            await controller?.pauseCamera();
                          },
                          child: const Text('pause', style: TextStyle(fontSize: 20)),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                          onPressed: () async {
                            await controller?.resumeCamera();
                          },
                          child: const Text('resume', style: TextStyle(fontSize: 20)),
                        ),
                      ),
                      Container(child: _SaveAttedance(context))
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              child: AttandaceList(students: attendace),
            ),
          )
        ],
      ),
    );
  }

  Widget _SaveAttedance(BuildContext context) {
    var totalAttendace = attendaceBox.length;
    var nextAttendace = totalAttendace + 1;

    return Container(
      margin: const EdgeInsets.all(8),
      child: ElevatedButton(
        onPressed: () async {
          // _AttandaceName(context);
          setState(() {
            attendaceBox.put('key_${nextAttendace}',
                Attendace(name: 'attendace_${nextAttendace}', attendace: attendace));
          });
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => DisplayAttendaceList(),
          ));
//          Navigator.push(
//            context,
//            MaterialPageRoute(builder: (context) => DisplayAttendaceList()),
//          );
        },
        child: const Text('Save Attendace', style: TextStyle(fontSize: 20)),
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea =
        (MediaQuery.of(context).size.width < 400 || MediaQuery.of(context).size.height < 400)
            ? 150.0
            : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        _addStudent(result.code);
        //ExtractedConent = ValueNotifier<String>(result.code);
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  _ChangeAttendaceName(String name) {
    setState(() {
      attendaceName = name;
    });
    print("------------------------------------------------------------------------------------");
    print(attendaceName);
  }

  String _AttandaceName(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(
                  20.0,
                ),
              ),
            ),
            contentPadding: EdgeInsets.only(
              top: 10.0,
            ),
            title: Text(
              "Enter Course Name",
              style: TextStyle(fontSize: 24.0),
            ),
            content: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: attendaceNameController,
                    onChanged: (text) => {attendaceNameController.text = text},
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade500,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20.0), bottomRight: Radius.circular(20.0)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Colors.white,
                              ),
                              child: Text(
                                "Cancel",
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                _ChangeAttendaceName(attendaceNameController.text);
                                Navigator.of(context).pop();
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Colors.black,
                              ),
                              child: Text(
                                "Confirm",
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
          );
        });
  }
}
