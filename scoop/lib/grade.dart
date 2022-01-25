import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';

class StudentGrades extends StatefulWidget {
  String stuUID;
  StudentGrades({required this.stuUID});
  @override
  _StudentGradesState createState() => _StudentGradesState();
}

int _isStudent = 0;
List<String> testName = [];

Future _getTestName(stuUID) async {
  final userRef = FirebaseFirestore.instance
      .collection('students')
      .doc(stuUID)
      .collection('tests');
  await userRef.get().then((snapshot) {
    snapshot.docs.forEach((doc) {
      testName.add(doc.id);
    });
  });
}

class _StudentGradesState extends State<StudentGrades> {
  @override
  Widget build(BuildContext context) {
    Stream<DocumentSnapshot> student = FirebaseFirestore.instance
        .collection('students')
        .doc(widget.stuUID)
        .snapshots();

    var _selectedTest;

    return StreamBuilder<DocumentSnapshot>(
        stream: student,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (!snapshot.hasData) {
            return LoadingFlipping.circle();
          }

          var data = snapshot.data;
          testName = [];
          _getTestName(widget.stuUID);
          print(testName);

          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              iconTheme: IconThemeData(
                color: Colors.black, //change your color here
              ),
              title: Text(data!["name"] + " " + data!['birth'],
                  style: TextStyle(color: Colors.black, fontSize: 17)),
              backgroundColor: Colors.white,
              elevation: 0,
            ),
            body: Column(
              children: [
                DropdownButton<String>(
                  // Initial Value
                  value: _selectedTest,
                  hint: Text("Select Test"),

                  // Down Arrow Icon
                  icon: const Icon(Icons.keyboard_arrow_down),

                  // Array list of items

                  items: testName.map((String value) {
                    print(testName);
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  // After selecting the desired option,it will
                  // change button value to selected value
                  onChanged: (value) {
                    setState(() {
                      _selectedTest = value;
                    });
                  },
                ),
                Container(
                    alignment: Alignment.bottomRight,
                    margin: EdgeInsets.all(30),
                    child: IconButton(
                        onPressed: () => null, icon: Icon(Icons.add))),
              ],
            ),
          );
        });
  }
}
