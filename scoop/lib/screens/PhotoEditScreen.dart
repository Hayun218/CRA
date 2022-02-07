import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'StudentEditScreen.dart';

class PhotoEditScreen extends StatefulWidget {
  final String title;
  final String link;
  final String id;

  const PhotoEditScreen({
    required this.title, 
    required this.link,
    required this.id,
  });

  @override
  _PhotoEditState createState() => _PhotoEditState();
}

class _PhotoEditState extends State<PhotoEditScreen>{
  final formKey = GlobalKey<FormState>();
  CollectionReference studentInfo = FirebaseFirestore.instance.collection('photo');

  Future<void> editPhoto() async {
    return studentInfo.doc(widget.id).update({
      'title': title,
      'link': link,
    }).then((value) => print("업로드 성공"))
    .catchError((error) => print("문제가 발생했습니다: $error"));
  }

  String title = '';
  String link = '';

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
          "사진 정보 수정",
          style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w700)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Form(
        key: formKey,
        child: Column(
          children: [
            renderTextFormField(
              label: '제목', 
              value: widget.title,
              onSaved: (val) {
                setState(() {
                  title = val;
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
              label: '링크', 
              value: widget.link,
              onSaved: (val) {
                setState(() {
                  link = val;
                });
              }, 
              validator: (val) {
                if (val.length < 1) {
                  return '생년월일을 입력해주세요';
                }

                return null;
              },
            ),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();
                  editPhoto();
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