import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoop/screens/StudentAddScreen.dart';
import 'package:scoop/screens/StudentEditScreen.dart';


class StudentInfoPage extends StatefulWidget {
  const StudentInfoPage({Key? key}) : super(key: key);

  @override
  _StudentInfoState createState() => _StudentInfoState();
}

class _StudentInfoState extends State<StudentInfoPage> {
  CollectionReference studentInfo = FirebaseFirestore.instance.collection('students');
  String orderQuery = 'name';
  String searchValue = '';

  Future<void> deleteStudent(String id) async {
    return studentInfo
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
          "학생정보관리",
          style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w700)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: 
        StreamBuilder<QuerySnapshot>(
        stream: studentInfo.orderBy(orderQuery).snapshots(),
        builder: 
          (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text('Error Ocurred');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text("Loading ...");
            }
          
            return Column(
              children: <Widget>[
                DropdownButton<String>(
                  value: orderQuery,
                  icon: const Icon(Icons.arrow_downward),
                  elevation: 16,
                  style: const TextStyle(color: Colors.black),
                  underline: Container(
                    height: 2,
                    color: Colors.black,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                        orderQuery = newValue!;
                    });
                  },
                  items: <String>['name', 'birth', 'coach']
                    .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    listTitle(text: "이름"),
                    listTitle(text: "생년월일"),
                    listTitle(text: "담당코치"),
                    Container(width: 110.0,),
                  ],
                ),
                Expanded(child: ListView(
                  children: snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                    var id = document.id;
                    return 
                      SizedBox(
                        height: 30.0,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                          listBox(text: data['name']),
                          listBox(text: data['birth']),
                          listBox(text: data['coach']),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                color: Colors.black,
                                onPressed: () {
                                  Navigator.push(
                                    context, 
                                    MaterialPageRoute(builder: (context) => StudentEditScreen(
                                      initialName: data['name'],
                                      initialBirth: data['birth'],
                                      initialCoach: data['coach'],
                                      docId: id,
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
                                          deleteStudent(document.id);
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  ),
                                ), 
                              ),
                            ],
                          ),
                        ],
                      )
                    );
                  }).toList(),
                ),
              ),  
              ],
            );
          },
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

listBox ({
  required String text,
}) {
  return Container(
    margin: const EdgeInsets.all(0.0),
    padding: const EdgeInsets.all(3.0),
    width: 100.0,
    height: 30.0,
    decoration: 
      BoxDecoration(
        border: Border.all(width: 1.0, color: Colors.black),
      ),
    child: Text(text),
  );
}

listTitle ({
  required String text,
}) {
  return Container(
    margin: const EdgeInsets.all(0.0),
    padding: const EdgeInsets.all(3.0),
    width: 100.0,
    height: 25.0,
    child: Text(text, style: TextStyle(fontWeight: FontWeight.bold),),
  );
}

