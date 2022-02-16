import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scoop/dashboard.dart';
import 'package:scoop/login.dart';
import 'page_view.dart';

import 'first_screen.dart';

class Scoop extends StatelessWidget {
  const Scoop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Scoop',
      home: LoginPage(),
      //home: FirstScreen(),
    );
  }
}
