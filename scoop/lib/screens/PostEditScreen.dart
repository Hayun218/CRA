import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoop/screens/PostAddScreen.dart';

class PostEditScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  final String id;

  const PostEditScreen({
    required this.data,
    required this.id,
  });

  @override
  _PostEditState createState() => _PostEditState();
}

class _PostEditState extends State<PostEditScreen>{
  final formKey = GlobalKey<FormState>();
  CollectionReference notice = FirebaseFirestore.instance.collection('notice');

  Future<void> editPost() async {
    return notice.doc(widget.id).update({
      'title': title, //포스트 제목
      'author': widget.data['author'], //현재 유저 (user?.uid)
      'content': content, //포스트 내용
      'category': category, //카테고리 필요할까??
    }).then((value) => print("업로드 성공"))
    .catchError((error) => print("문제가 발생했습니다: $error"));
  }

  String title = '';
  String coach = '';
  String content = '';
  String category = '';

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
          "포스트 수정",
          style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w700)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Form(
        key: formKey,
        child: Column(
          children: [
            renderPostAddField(
              label: '제목', 
              value: widget.data['title'],
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
            renderPostAddField(
              label: '내용', 
              value: widget.data['content'],
              lineNum: 8,
              onSaved: (val) {
                setState(() {
                  content = val;
                });
              }, 
              validator: (val) {
                if (val.length < 1) {
                  return '내용을 입력해주세요';
                }

                return null;
              },
            ),
            renderPostAddField(
              label: '카테고리', 
              value: widget.data['category'],
              lineNum: 1,
              onSaved: (val) {
                setState(() {
                  category = val;
                });
              }, 
              validator: (val) {
                if (val.length < 1) {
                  return '카테고리를 입력해주세요';
                }

                return null;
              },
            ),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();
                  editPost();
                  Navigator.pop(context);
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