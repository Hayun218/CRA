import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoop/screens/PostAddScreen.dart';
import 'package:path/path.dart' as Path;
import 'package:scoop/api/file_api.dart';

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

  Future<void> editPost(String urlDownload, String fileName) async {
    return notice.doc(widget.id).update({
      'title': title, //포스트 제목
      'author': widget.data['author'], //현재 유저 (user?.uid)
      'content': content, //포스트 내용
      'category': category, //카테고리
      'link': urlDownload,
      'filename': fileName,
    }).then((value) => print("업로드 성공"))
    .catchError((error) => print("문제가 발생했습니다: $error"));
  }

  Future<void> editPostNoFiles() async {
    return notice.doc(widget.id).update({
      'title': title, //포스트 제목
      'author': widget.data['author'], //현재 유저 (user?.uid)
      'content': content, //포스트 내용
      'category': category, //카테고리
      'link': '',
      'filename': '',
    }).then((value) => print("업로드 성공"))
    .catchError((error) => print("문제가 발생했습니다: $error"));
  }

  Future uploadFile() async {
    if (file == null)  return;

    final fileName = Path.basename(file!.path);
    final destination = 'files/$fileName';

    task = FileApi.uploadFile(destination, file!);

    if (task == null) return;

    final snapshot = await task!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();

    editPost(urlDownload, fileName);
  }

  String title = '';
  String coach = '';
  String content = '';
  String category = '';
  File? file;
  UploadTask? task;

  @override
  Widget build(BuildContext context) {
    category = widget.data['category'];
    final fileName = file != null ? Path.basename(file!.path) : '파일 없음';

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
            const Text(
              '카테고리',
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w700,
              ),
            ),
            DropdownButton<String>(
              value: category,
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              style: const TextStyle(color: Colors.black),
              underline: Container(
                height: 2,
                color: Colors.black,
              ),
              onChanged: (String? newValue) {
                setState(() {
                    category = newValue!;
                });
              },
              items: <String>['공지', '홍보/이벤트']
                .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
            ),
            const Text(
              '파일 선택',
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w700,
              ),
            ),
            ElevatedButton(
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.lightBlueAccent)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.attach_file),
                  Text(
                    '파일 선택'
                  ),
                ],
              ),
              onPressed: () {
                selectFile();
              },
            ),
            const SizedBox(height: 8,),
            (fileName == '파일 없음' && widget.data['filename'] != null)?
              Text(widget.data['filename'], style: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold)):
              Text(fileName, style: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold)),
            Container(height: 30.0,),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();
                  // 원래 & 선택된 파일 없을 때
                  if (widget.data['filename'] == null && fileName == '파일 없음') {
                    editPostNoFiles();
                  }
                  // 원래 파일이 있었고 새로 선택된 파일이 없을 때
                  else if (widget.data['filename'] != null && fileName == '파일 없음') {
                    editPost(widget.data['link'], widget.data['filename']);
                  } 
                  // 선택된 파일이 있을 때
                  else {
                    uploadFile();
                  }
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

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result == null) return;
    final path = result.files.single.path!;

    setState(() => file = File(path));
  }
}