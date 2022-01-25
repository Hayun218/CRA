import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
          Container(height: 10,),
          IntrinsicHeight(
            child: Row( 
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(widget.data['author'], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w300)),
                const VerticalDivider( thickness: 1, color: Colors.grey, ),
                Text(widget.data['date'], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w300)),
              ],
            ),
          ),
          Container(height: 10,),
          const Divider( thickness: 1, color: Colors.grey,),
          Container(height: 10,),
          Text(widget.data['content']),
        ],
      ), 
    );
  }
}