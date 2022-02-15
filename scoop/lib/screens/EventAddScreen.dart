import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scoop/screens/PostAddScreen.dart';

class EventAddScreen extends StatefulWidget {
  const EventAddScreen({Key? key}) : super(key: key);

  @override
  _EventAddState createState() => _EventAddState();
}

class _EventAddState extends State<EventAddScreen>{
  final formKey = GlobalKey<FormState>();
  CollectionReference event = FirebaseFirestore.instance.collection('events');

  Future<void> addPost(String urlDownload, String fileName) async {
    return event.add({
      'title': title, //포스트 제목
      'date': DateFormat.yMd().format(DateTime.now()).toString(), //생성 시간 
      'author': coach, //현재 유저 (user?.uid)
      'content': content, //포스트 내용
      'category': category, //카테고리 
      'link': urlDownload,
      'filename': fileName,
    }).then((value) => print("업로드 성공"))
    .catchError((error) => print("문제가 발생했습니다: $error"));
  }

  Future<void> addPostNoFiles() async {
    return event.add({
      'title': title, //포스트 제목
      'date': DateFormat.yMd().format(DateTime.now()).toString(), //생성 시간 
      'author': coach, //현재 유저 (user?.uid)
      'content': content, //포스트 내용
      'category': category, //카테고리 
      'link': '',
      'filename': '',
    }).then((value) => print("업로드 성공"))
    .catchError((error) => print("문제가 발생했습니다: $error"));
  }

  String title = '';
  String coach = '';
  String content = '';
  String category = '공지';

  @override
  Widget build(BuildContext context) {

    return 
    Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        centerTitle: true,
        title: const Text(
          "새 이벤트 추가",
          style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w700)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Form(
        key: formKey,
        child: Column(
          children: [
            renderPostAddField(
              label: '내용', 
              value: '',
              lineNum: 1,
              onSaved: (val) {
                setState(() {
                  title = val;
                });
              }, 
              validator: (val) {
                if (val.length < 1) {
                  return '제목을 입력해주세요';
                }

                return null;
              },
            ),
            const Text(
              '날짜/시간',
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w700,
              ),
            ),
            
            Container(height: 30.0,),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();
                    addPostNoFiles();
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