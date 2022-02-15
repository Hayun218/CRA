import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoop/screens/PostEditScreen.dart';
import 'package:url_launcher/url_launcher.dart';

class Post extends StatefulWidget {
  final Map<String, dynamic> data;
  final String id;

  const Post({
    required this.data,
    required this.id,
  });

  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {
  CollectionReference notice = FirebaseFirestore.instance.collection('notice');

  Future<void> deletePost(String id) async {
    return notice
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
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body:
      // 제목 아래 작게 날짜, 글쓴이. 그 옆에는 수정&삭제 아이콘. 아래는 얇은 선으로 구분하고 사진or파일링크, 내용.  
      Column(
        children: [
          Text(
            widget.data['title'],
            style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10,),
          IntrinsicHeight(
            child: Row( 
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => PostEditScreen(
                        data: widget.data,
                        id: widget.id,
                      )),
                    );
                  }
                ),
                Text(widget.data['author'], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w300)),
                const VerticalDivider(thickness: 1, color: Colors.grey),
                Text(widget.data['date'], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w300)),
                IconButton(
                  icon: const Icon(Icons.delete),
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
                            deletePost(widget.id);
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10,),
          Container(height: 1, width: 370, color: Colors.grey),
          const SizedBox(height: 10,),
          if (widget.data['link'].isEmpty) ...[
            SizedBox(
              width: 370,
              child: Text(widget.data['content']),
            ),
          ] else ...[
            Image.network(widget.data['link'], fit: BoxFit.fill,),
            const SizedBox(height: 10,),
            SizedBox(
              width: 370,
              child: Text(widget.data['content']),
            ),
            const SizedBox(height: 10,),
            Row(children: const [
              Icon(Icons.attach_file),
              Text('첨부파일', style: TextStyle(fontWeight: FontWeight.bold)),
            ],),
            ListTile(
              title: Text(widget.data['filename']),
              onTap: () => showDialog(
                context: context, 
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("파일을 다운로드합니다"),
                    actions: [
                      TextButton(
                        child: Text("취소"),
                        onPressed: () => Navigator.pop(context),
                      ),
                      TextButton(
                        child: Text("이동"),
                        onPressed: () {
                          launch(widget.data['link']);
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ],
      ), 
    );
  }
}