import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class StudentInfoPage extends StatefulWidget {
  const StudentInfoPage({Key? key}) : super(key: key);

  @override
  _StudentInfoState createState() => _StudentInfoState();
}

class _StudentInfoState extends State<StudentInfoPage> {
  CollectionReference studentInfo = FirebaseFirestore.instance.collection('HILS');
  String orderQuery = 'name';

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
                Expanded(child: ListView(
                  children: snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                    return 
                      Row(
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
                                onPressed: () async {
                                  await studentInfo
                                  .doc(document.id).delete()
                                  .then((value) => print("삭제되었습니다"))
                                  .catchError((error) => print("문제가 발생했습니다"));
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                color: Colors.black,
                                onPressed: () async {
                                  await studentInfo
                                  .doc(document.id).delete()
                                  .then((value) => print("삭제되었습니다"))
                                  .catchError((error) => print("문제가 발생했습니다"));
                                },
                              ),
                            ],
                          ),
                        ],
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

class StudentAddScreen extends StatefulWidget {
  const StudentAddScreen({Key? key}) : super(key: key);

  @override
  _StudentAddState createState() => _StudentAddState();
}

class _StudentAddState extends State<StudentAddScreen>{
  final formKey = GlobalKey<FormState>();
  CollectionReference studentInfo = FirebaseFirestore.instance.collection('HILS');

  Future<void> addStudent() async {
    return studentInfo.add({
      'name': name,
      'birth': birth,
      'coach': coach,
      'status': 0,
    }).then((value) => print("업로드 성공"))
    .catchError((error) => print("문제가 발생했습니다: $error"));
  }

  String name = '';
  String birth = '';
  String coach = '';

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