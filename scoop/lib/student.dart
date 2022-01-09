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
        'OItT9gC2wKg1EPRbHlBtR3lBBes2') //FirebaseAuth.instance.currentUser!.uid
    .snapshots();

_launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

class _StudentPageState extends State<StudentPage> {
  final TextEditingController _studentRecordURL = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("HayunPark (990218)",
            style: TextStyle(color: Colors.black, fontSize: 17)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: StreamBuilder<DocumentSnapshot>(
          stream: student,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            if (!snapshot.hasData) {
              return LoadingFlipping.circle();
            }

            return Container(
              margin: const EdgeInsets.all(40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
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
                          if (snapshot.data!['status'] == 0) {
                            _launchURL(snapshot.data!['생활기록부']);
                          } else {
                            TextField(
                              controller: _studentRecordURL,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Enter URL',
                              ),
                            );
                          }
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
                        border: OutlineInputBorder(),
                        hintText: 'Teacher\'s Commment'),
                  ),
                  const SizedBox(height: 80),
                  TextField(
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), hintText: 'My Comment'),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
