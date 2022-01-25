import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';

class StudentGrades extends StatefulWidget {
  String stuUID;
  StudentGrades({required this.stuUID});
  @override
  _StudentGradesState createState() => _StudentGradesState();
}

class _StudentGradesState extends State<StudentGrades> {
  @override
  Widget build(BuildContext context) {
    Stream<DocumentSnapshot> student = FirebaseFirestore.instance
        .collection('students')
        .doc(widget.stuUID) //FirebaseAuth.instance.currentUser!.uid
        .snapshots();
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
            body: null,
          );
        });
  }
}
