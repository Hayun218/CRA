import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoop/page_view.dart';

class PhotoPage extends StatefulWidget {
  @override
  _PhotoState createState() => _PhotoState();
}

class _PhotoState extends State<PhotoPage> {
  final Stream<QuerySnapshot> _photoStream = FirebaseFirestore.instance.collection('photo').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "사진",
          style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w700)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
      stream: _photoStream,
      builder: 
        (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error Ocurred');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading ...");
          }
        
          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
              return ListTile(
                title: Text(data['title']),
                subtitle: Text(data['link']),
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context, 
            MaterialPageRoute(builder: (context) => PhotoAdd()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class PhotoAdd extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Text(
          "사진 추가",
          style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w700)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Form(child: TextField()),
    );
  }
}