import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:loading_animations/loading_animations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:date_format/date_format.dart';

class StudentPage extends StatefulWidget {
  @override
  _StudentPageState createState() => _StudentPageState();
}

DateTime todayDate = DateTime.now();
String givenDate = formatDate(todayDate, [yyyy, '년 ', mm, '월 ', dd, '일']);
User user = FirebaseAuth.instance.currentUser!;

Stream<DocumentSnapshot> student = FirebaseFirestore.instance
    .collection('HILS')
    .doc(
        '0l56kbyKRsSMKSTptihedzTFwaC2') //FirebaseAuth.instance.currentUser!.uid
    .snapshots();

// teacher: 0l56kbyKRsSMKSTptihedzTFwaC2
// student: OItT9gC2wKg1EPRbHlBtR3lBBes2

_launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

//
// void showContentDialog(context, data) {
//   showDialog(
//       context: context,
//       barrierDismissible: true,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Center(child: Text("생활기록부 URL")),
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               Text("URL: " + data['생활기록부']),
//               SizedBox(height: 10),
//               Text("Time: " + data['time']),
//               SizedBox(height: 10),
//               Row(
//                 children: [
//                   Text("Priority: "),
//                   if (data['priority'] == 1)
//                     Icon(Icons.circle, color: Colors.red),
//                   if (data['priority'] == 2)
//                     Icon(Icons.circle, color: Colors.blue),
//                   if (data['priority'] == 3)
//                     Icon(Icons.circle, color: Colors.green),
//                 ],
//               ),
//               SizedBox(height: 10),
//               Text("Content: " + data['content']),
//             ],
//           ),
//           actions: <Widget>[
//             FlatButton(
//               child: new Text("삭제"),
//               onPressed: () {
//                 deleteToDo(data);
//                 Navigator.pop(context);
//               },
//             ),
//             FlatButton(
//               child: new Text("수정"),
//               onPressed: () {
//                 Navigator.pop(context);
//                 addContentDialog(context, data);
//               },
//             ),
//           ],
//         );
//       });
// }
TextEditingController _studentRecordURL = TextEditingController();

getRecordLink(String stuUID) async {
  var collection = FirebaseFirestore.instance.collection('HILS');
  var docSnapshot = await collection.doc(stuUID).get();
  String link = "";
  if (docSnapshot.exists) {
    var data = docSnapshot.data();
    link = await data?['record'];
    _studentRecordURL = TextEditingController(text: link);
  } else {
    _studentRecordURL = TextEditingController();
  }
}

updateRecordURL(String stuUID, TextEditingController record) async {
  var stuDoc = FirebaseFirestore.instance.collection('HILS').doc(stuUID);
  return stuDoc.set({"record": record.text}, SetOptions(merge: true));
}

class _StudentPageState extends State<StudentPage> {
  var _selectedStu;
  var _selectedUid = "initial UID";
  @override
  Widget build(BuildContext context) {
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
          int _isTeacher = data!["status"];

          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: data["status"] == 0
                  ? Text(data["name"] + " " + data['birth'],
                      style: TextStyle(color: Colors.black, fontSize: 17))
                  : Text(data["name"] + " 코치",
                      style: TextStyle(color: Colors.black, fontSize: 17)),
              backgroundColor: Colors.white,
              elevation: 0,
            ),
            body:
                _isTeacher == 1 ? Teacher(data: data) : StudentSide(data: data),
          );
        });
  }
}

class Teacher extends StatefulWidget {
  var data;

  Teacher({required this.data});
  @override
  _TeacherState createState() => _TeacherState();
}

class _TeacherState extends State<Teacher> {
  var _selectedStu;
  var _selectedUid = "initial UID";

  @override
  Widget build(BuildContext context) {
    var data = widget.data;
    List<String> studentKeys = widget.data["students"].keys.toList();

    return Container(
      margin: const EdgeInsets.fromLTRB(30, 0, 30, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          DropdownButton<String>(
            // Initial Value
            value: _selectedStu,
            hint: Text("Select Students"),

            // Down Arrow Icon
            icon: const Icon(Icons.keyboard_arrow_down),

            // Array list of items
            items: studentKeys.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            // After selecting the desired option,it will
            // change button value to selected value
            onChanged: (value) {
              setState(() {
                _selectedStu = value;

                _selectedUid = data["students"][value];
                getRecordLink(_selectedUid);
                print(_selectedStu + " " + _selectedUid);
              });
            },
          ),
          SizedBox(height: 50),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => null,
                child: Text('출결 현황'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.transparent,
                ),
              ),
              ElevatedButton(
                onPressed: () => null,
                child: Text('학생 일지'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.transparent,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Center(
                            child: Text(
                              "생활기록부",
                            ),
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              TextField(
                                maxLines: null,
                                controller: _studentRecordURL,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Enter URL',
                                ),
                              ),
                              Row(
                                children: [
                                  TextButton(
                                      onPressed: () => updateRecordURL(
                                          _selectedUid, _studentRecordURL),
                                      child: Text("save")),
                                  TextButton(
                                      onPressed: () {
                                        _studentRecordURL.clear();
                                        updateRecordURL(
                                            _selectedUid, _studentRecordURL);
                                      },
                                      child: Text("delete")),
                                  TextButton(
                                      onPressed: () {
                                        _launchURL(_studentRecordURL.text);
                                      },
                                      child: Text("보기")),
                                ],
                              )
                            ],
                          ),
                        );
                      });
                },
                child: const Text('생활기록부'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.transparent,
                ),
              ),
            ],
          ),
          SizedBox(height: 50),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => null,
                child: Text('진단평가 성적'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.transparent,
                ),
              ),
              ElevatedButton(
                onPressed: () => null,
                child: Text('모의고사 성적'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.transparent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 80),
          Row(
            children: [
              Text(givenDate),
            ],
          ),
          const SizedBox(height: 30),
          TextField(
            decoration: const InputDecoration(
                border: OutlineInputBorder(), hintText: 'Teacher\'s Commment'),
          ),
          const SizedBox(height: 80),
          TextField(
            decoration: const InputDecoration(
                border: OutlineInputBorder(), hintText: 'My Comment'),
          ),
        ],
      ),
    );
  }
}

class StudentSide extends StatefulWidget {
  var data;
  StudentSide({required this.data});
  @override
  _StudentSideState createState() => _StudentSideState();
}

class _StudentSideState extends State<StudentSide> {
  @override
  Widget build(BuildContext context) {
    var data = widget.data;

    return Container(
      margin: const EdgeInsets.fromLTRB(30, 0, 30, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 50),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => null,
                child: Text('출결 현황'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.transparent,
                ),
              ),
              ElevatedButton(
                onPressed: () => null,
                child: Text('학생 일지'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.transparent,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  _launchURL(data!['record']);
                },
                child: const Text('생활기록부'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.transparent,
                ),
              ),
            ],
          ),
          SizedBox(height: 50),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => null,
                child: Text('진단평가 성적'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.transparent,
                ),
              ),
              ElevatedButton(
                onPressed: () => null,
                child: Text('모의고사 성적'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.transparent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 80),
          Row(
            children: [
              Text(givenDate),
            ],
          ),
          const SizedBox(height: 30),
          TextField(
            decoration: const InputDecoration(
                border: OutlineInputBorder(), hintText: 'Teacher\'s Commment'),
          ),
          const SizedBox(height: 80),
          TextField(
            decoration: const InputDecoration(
                border: OutlineInputBorder(), hintText: 'My Comment'),
          ),
        ],
      ),
    );
  }
}
