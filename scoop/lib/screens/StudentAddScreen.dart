import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentAddScreen extends StatefulWidget {
  const StudentAddScreen({Key? key}) : super(key: key);

  @override
  _StudentAddState createState() => _StudentAddState();
}

class _StudentAddState extends State<StudentAddScreen>{
  final formKey = GlobalKey<FormState>();
  CollectionReference studentInfo = FirebaseFirestore.instance.collection('students');

  Future<void> addStudent() async {
    return studentInfo.add({
      'name': name,
      'birth': birth,
      'coach': coach,
    }).then((value) => print("업로드 성공"))
    .catchError((error) => print("문제가 발생했습니다: $error"));
  }

  String name = '';
  String birth = '';
  String coach = '';

  @override
  Widget build(BuildContext context) {
    return 
    Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        title: const Text(
          "학생 정보 추가",
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
              value: '',
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
              value: '',
              onSaved: (val) {
                setState(() {
                  birth = val;
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
              value: '',
              onSaved: (val) {
                setState(() {
                  coach = val;
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
    required String value,
  }) {

    return 
    Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
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
          initialValue: value,
        ),
        Container(height: 16.0),
      ],
    )
  );
  }