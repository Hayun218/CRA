import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoop/page_view.dart';
import 'package:intl/intl.dart';
import 'package:scoop/student_info.dart';
import 'package:url_launcher/url_launcher.dart';

class PhotoPage extends StatefulWidget {
  const PhotoPage({Key? key}) : super(key: key);

  @override
  _PhotoState createState() => _PhotoState();
}

class _PhotoState extends State<PhotoPage> {
  final Stream<QuerySnapshot> _photoStream = FirebaseFirestore.instance.collection('photo').snapshots();
  CollectionReference photo = FirebaseFirestore.instance.collection('photo');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        title: const Text(
          "사진",
          style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w700)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: 
        StreamBuilder<QuerySnapshot>(
        stream: _photoStream,
        builder: 
          (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text('Error Ocurred');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text("Loading ...");
            }
          
            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                return ListTile(
                  title: InkWell(
                    child: Text(data['title']),
                    onTap: () => launch(data['link']),
                  ),
                  subtitle: Text(data['date']),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    color: Colors.black,
                    onPressed: () async {
                      await photo
                            .doc(document.id).delete()
                            .then((value) => print("삭제되었습니다"))
                            .catchError((error) => print("문제가 발생했습니다"));
                    },
                  ),
                );
              }).toList(),
            );
          },
        ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightBlueAccent,
        onPressed: () {
          Navigator.push(
            context, 
            MaterialPageRoute(builder: (context) => const PhotoAddScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.lightBlueAccent,
              ),
              child: Text('XXX님'),
            ),
            ListTile(
              title: const Text('로그아웃'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('알림설정'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('학생정보관리'),
              onTap: () {
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => StudentInfoPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class PhotoAddScreen extends StatefulWidget {
  const PhotoAddScreen({Key? key}) : super(key: key);

  @override
  _PhotoAddState createState() => _PhotoAddState();
}

class _PhotoAddState extends State<PhotoAddScreen>{
  final formKey = GlobalKey<FormState>();

  String title = '';
  String link = '';
  String date = DateFormat.yMd().format(DateTime.now()).toString();

  CollectionReference photo = FirebaseFirestore.instance.collection('photo');

  Future<void> addPhoto() {
    return photo.add({
      'title': title,
      'link': link,
      'date': date,
    }).then((value) => print("업로드 성공"))
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
              label: '제목', 
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
            renderTextFormField(
              label: '링크', 
              onSaved: (val) {
                setState(() {
                  link = val;
                });
              }, 
              validator: (val) {
                if (val.length < 1) {
                  return '링크를 입력해주세요';
                }

                return null;
              },
            ),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();
                  addPhoto();
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