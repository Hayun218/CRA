import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoop/screens/Drawer.dart';
import 'package:scoop/screens/Post.dart';
import 'package:scoop/screens/PostAddScreen.dart';

class Notice extends StatefulWidget {
  const Notice({Key? key}) : super(key: key);

  @override
  _NoticeState createState() => _NoticeState();
}

class _NoticeState extends State<Notice> {
  Query<Map<String, dynamic>> post = FirebaseFirestore.instance.collection('notice');

  String category = '공지';
  String query = '';

  String messageTitle = "Empty";
  String notificationAlert = "alert";

  final controller = TextEditingController();
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
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
          "게시판",
          style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w700)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: 
        StreamBuilder<QuerySnapshot>(
        stream: (controller.text != '' && controller.text != null)?
          post.where('category', isEqualTo: category)
          .where('title', isGreaterThanOrEqualTo: query)
          .where('title', isLessThan: query.substring(0, query.length-1)+String.fromCharCode(query.codeUnitAt(query.length-1)+1))
          .orderBy('title')
          .orderBy('date', descending: true)
          .snapshots():
          post.orderBy('date', descending: true).where('category', isEqualTo: category).snapshots(),
        builder: 
          (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('Error Ocurred'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData) {
              return const Center(child: Text('일치하는 글이 없습니다'),);
            }
          
            return 
            Column(
              children: [
                Row(
                  children: <Widget>[
                    Expanded(child: 
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: TextField(
                          controller: controller,
                          decoration: InputDecoration(
                            isDense: true,
                            focusColor: Colors.lightBlueAccent,
                            prefixIcon: Icon(Icons.search, color: Colors.black,),
                            border: OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: Icon(Icons.clear, color: controller.text.isNotEmpty ? Colors.black : Colors.transparent,),
                              onPressed: () {
                                setState(() {
                                  query = '';
                                });
                                controller.clear();
                              },
                            ),
                          ),
                        ), 
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            query = controller.text;
                          });
                        }, 
                        style: ElevatedButton.styleFrom(
                          primary: Colors.lightBlueAccent,
                        ),
                        child: const Text(
                          '찾기',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                DropdownButton<String>(
                  value: category,
                  icon: const Icon(Icons.arrow_downward),
                  elevation: 16,
                  style: const TextStyle(color: Colors.black, fontSize: 16.0, ),
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
                Expanded(child: 
                  ListView(
                    children: snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                      return ListTile(
                        title: Row(children: [
                          Text(data['title']),
                          Text(
                            '   ' + data['date'],
                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w300),
                          ),
                        ]),
                        subtitle: Text(data['content'], overflow: TextOverflow.ellipsis),
                        onTap: () {
                          Navigator.push(
                            context, 
                            MaterialPageRoute(builder: (context) => Post(
                              data: data,
                              id: document.id,
                            )),
                          );
                        },
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
            MaterialPageRoute(builder: (context) => const PostAddScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
      drawer: defaultDrawer(context: context),
    );
  }
}