import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoop/screens/Drawer.dart';
import 'package:scoop/screens/PhotoAddScreen.dart';
import 'package:scoop/screens/PhotoEditScreen.dart';
import 'package:url_launcher/url_launcher.dart';

class PhotoPage extends StatefulWidget {
  const PhotoPage({Key? key}) : super(key: key);

  @override
  _PhotoState createState() => _PhotoState();
}

class _PhotoState extends State<PhotoPage> {
  CollectionReference photo = FirebaseFirestore.instance.collection('photo');

  Future<void> deletePhoto(String id) async {
    return photo
           .doc(id).delete()
           .then((value) => print("삭제되었습니다"))
           .catchError((error) => print("문제가 발생했습니다"));                
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        centerTitle: true,
        title: const Text(
          "사진",
          style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w700)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: 
        StreamBuilder<QuerySnapshot>(
        stream: photo.orderBy('date', descending: true).snapshots(),
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
                  title: Text(data['title']),
                  subtitle: Text(data['date']),
                  onTap: () => showDialog(
                    context: context, 
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("외부 페이지로 이동합니다"),
                        actions: [
                          TextButton(
                            child: Text("취소"),
                            onPressed: () => Navigator.pop(context),
                          ),
                          TextButton(
                            child: Text("이동"),
                            onPressed: () {
                              launch(data['link']);
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      );
                    },
                  ),
                  trailing: 
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      color: Colors.black,
                      onPressed: () {
                        Navigator.push(
                          context, 
                          MaterialPageRoute(builder: (context) => PhotoEditScreen(
                            title: data['title'],
                            link: data['link'],
                            id: document.id,
                          )),
                        );
                      }
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      color: Colors.black,
                      onPressed: () => showDialog(
                        context: context, 
                        builder: (context) => AlertDialog(
                          title: Text("정말 삭제하시겠습니까?"),
                          actions: [
                            TextButton(
                              child: Text("취소"),
                              onPressed: () => Navigator.pop(context),
                            ),
                            TextButton(
                              child: Text("삭제"),
                              onPressed: () {
                                deletePhoto(document.id);
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ]),
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
      drawer: defaultDrawer(context: context),
    );
  }
}