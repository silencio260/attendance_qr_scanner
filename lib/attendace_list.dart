import 'package:flutter/material.dart';

class AttandaceList extends StatefulWidget {
  List students;
  AttandaceList({Key key, @required this.students}) : super(key: key);

  @override
  _AttandaceListState createState() => _AttandaceListState(students);
}

class _AttandaceListState extends State<AttandaceList> {
  List students;
  _AttandaceListState(this.students);

  var attendace = ['ooo', '111', '111', '111', '111'];

  _addStudent(String value) {
    bool repeatValue = false;
    for (int i = 0; i < attendace.length; i++) {
      if (attendace[i] == value) {
        repeatValue = true;
        break;
      }
    }
    setState(() {
      if (repeatValue == false) {
        attendace.add(value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return students.length < 1
        ? Text("No Attendace Here")
        : ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: students.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                elevation: 1,
                child: ListTile(
                  leading: const Icon(Icons.list),
                  title: Text(students[index]),
                ),
              );
            });
  }
}
