import 'package:attendaceqrscanner/attendace_model.dart';
import 'package:attendaceqrscanner/boxes.dart';
import 'package:flutter/material.dart';

class DisplayAttendaceList extends StatefulWidget {
  @override
  _DisplayAttendaceListState createState() => _DisplayAttendaceListState();
}

class _DisplayAttendaceListState extends State<DisplayAttendaceList> {
  var listOfAttendace;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All Attendace')),
      body: Container(
        child: _buildDisplayList(context),
      ),
    );
  }

  Widget _buildDisplayList(BuildContext context) {
    if (attendaceBox.length < 1) {
      return Text("No Attendace Here");
    }
    return ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: attendaceBox.length,
        itemBuilder: (BuildContext context, int index) {
          Attendace att = attendaceBox.getAt(index);
          return ListTile(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => SpecificAttendace(
                  name: att.name,
                  attendace: att.attendace,
                ),
              ));
            },
            leading: const Icon(Icons.list),
            title: Text(att.name),
          );
        });
  }
}

class SpecificAttendace extends StatelessWidget {
  SpecificAttendace({this.name, this.attendace});

  var name;
  List attendace;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: _displayAttendace(context),
    );
  }

  Widget _displayAttendace(BuildContext context) {
    if (attendaceBox.length < 1) {
      return Text("No Attendace Here");
    }
    return ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: attendace.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            elevation: 1,
            child: ListTile(
              title: Text(attendace[index]),
            ),
          );
        });
  }
}
