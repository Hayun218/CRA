import 'package:flutter/material.dart';
import 'package:scoop/student_info.dart';

defaultDrawer({
  required BuildContext context,
}) {
  return Drawer(
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
                  MaterialPageRoute(builder: (context) => const StudentInfoPage()),
                );
              },
            ),
          ],
        ),
      );
} 