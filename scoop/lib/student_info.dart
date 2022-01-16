import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StudentInfoPage extends StatefulWidget {
  const StudentInfoPage({Key? key}) : super(key: key);

  @override
  _StudentInfoState createState() => _StudentInfoState();
}

class _StudentInfoState extends State<StudentInfoPage> {
  final Stream<DocumentSnapshot> _studentStream = FirebaseFirestore.instance.collection('HILS').doc('student_DB').snapshots();
  CollectionReference student = FirebaseFirestore.instance.collection('student');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        title: const Text(
          "학생정보관리",
          style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w700)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: 
      StreamBuilder<DocumentSnapshot>(
        stream: _studentStream,
        builder: 
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text('Error Ocurred');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text("Loading ...");
            }

            var doc = snapshot.data;
            return Text(doc!["student"][1]["name"]);
          }
        ),
        floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightBlueAccent,
        onPressed: () {
          Navigator.push(
            context, 
            MaterialPageRoute(builder: (context) => const StudentAddScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class StudentAddScreen extends StatefulWidget {
  const StudentAddScreen({Key? key}) : super(key: key);

  @override
  _StudentAddState createState() => _StudentAddState();
}

class _StudentAddState extends State<StudentAddScreen>{
  final formKey = GlobalKey<FormState>();

  String name = '';
  String birthdate = '';
  String teacher = '';

  DocumentReference student = FirebaseFirestore.instance.collection('HILS').doc('student_DB');

  Future<void> addStudent() {
    var map = new Map<String, dynamic>();
    map['name'] = name;
    map['birthdate'] = birthdate;
    map['teacher'] = teacher;
    return student.set({
      "student": FieldValue.arrayUnion([map])
    }, SetOptions(merge: true)).then((value) => print("업로드 성공"))
    .catchError((error) => print("문제가 발생했습니다: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        title: const Text(
          "사진 추가",
          style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w700)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Form(
        key: formKey,
        child: Column(
          children: [
            renderTextFormField(
              label: '학생 이름', 
              onSaved: (val) {
                setState(() {
                  name = val;
                });
              }, 
              validator: (val) {
                if (val.length < 1) {
                  return '이름을 입력해주세요';
                }

                return null;
              },
            ),
            renderTextFormField(
              label: '생년월일 (YY/MM/DD)', 
              onSaved: (val) {
                setState(() {
                  birthdate = val;
                });
              }, 
              validator: (val) {
                if (val.length < 1) {
                  return '생년월일을 입력해주세요';
                }

                return null;
              },
            ),
            // 여기는 select로 바꿔도 될듯
            renderTextFormField(
              label: '담당 선생님 이름', 
              onSaved: (val) {
                setState(() {
                  teacher = val;
                });
              }, 
              validator: (val) {
                if (val.length < 1) {
                  return '담당 선생님을 입력해주세요';
                }

                return null;
              },
            ),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();
                  addStudent();
                  Navigator.pop(context);
                }
              },
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.lightBlueAccent)),
              child: const Text(
                '업로드',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

renderTextFormField({
    required String label,
    required FormFieldSetter onSaved,
    required FormFieldValidator validator,
  }) {

    return Column(
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        TextFormField(
          onSaved: onSaved,
          validator: validator,
        ),
        Container(height: 16.0),
      ],
    );
  }