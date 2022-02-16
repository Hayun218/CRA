import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scoop/notification.dart';
import 'package:scoop/student_info.dart';

defaultDrawer({
  required BuildContext context,
}) {
  final User? user = FirebaseAuth.instance.currentUser;
  return Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.lightBlueAccent,
              ),
              child: Text(user!.uid),
            ),
            ListTile(
              title: const Text('로그아웃'),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
              },
            ),
            ListTile(
              title: const Text('알림설정'),
              onTap: () {
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => const NotiPage()),
                );
              },
            ),
            ListTile(
              title: const Text('학생정보관리'),
              onTap: () {
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => const StudentInfoPage()),
                );
              },
            ),
          ],
        ),
      );
} 