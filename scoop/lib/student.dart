import 'package:flutter/material.dart';

class StudentPage extends StatefulWidget {
  @override
  _StudentPageState createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("HayunPark (990218)",
            style: TextStyle(color: Colors.black, fontSize: 17)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        margin: EdgeInsets.all(40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => null,
                  child: Text('학생 일지'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.transparent,
                  ),
                ),
                ElevatedButton(
                  onPressed: () => null,
                  child: Text('학생 일지'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.transparent,
                  ),
                ),
                ElevatedButton(
                  onPressed: () => null,
                  child: Text('학생 일지'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.transparent,
                  ),
                ),
              ],
            ),
            SizedBox(height: 50),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => null,
                  child: Text('학생 일지'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.transparent,
                  ),
                ),
                ElevatedButton(
                  onPressed: () => null,
                  child: Text('학생 일지'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.transparent,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
