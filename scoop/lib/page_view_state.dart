import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:scoop/photos.dart';

import 'dashboard.dart';
import 'student.dart';
import 'student_info.dart';

enum PageState {
  dashboard,
  photos,
  student,
  // ignore: constant_identifier_names
  student_info,
}

final controller = PageController(
  initialPage: 0,
);
int pageChanged = 0;

class PageControll {
  void pageController(int pageNum) {
    controller.jumpToPage(pageNum);
  }
}

class HighlightPage extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  const HighlightPage({
    required this.pageState,
    required this.pageFlow,
    required this.signOut,
  });

  final PageState pageState;
  final Function(int index) pageFlow;
  final Function() signOut;

  @override
  State<HighlightPage> createState() => _HighlightPageState();
}

class _HighlightPageState extends State<HighlightPage> {
  BottomAppBar appBar(BuildContext context) {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            onPressed: () => controller.jumpToPage(0),
            icon: Icon(widget.pageState == PageState.dashboard
                ? Icons.home
                : Icons.home_outlined),
          ),
          IconButton(
            onPressed: () => controller.jumpToPage(1),
            icon: Icon(widget.pageState == PageState.student
                ? Icons.fact_check
                : Icons.fact_check_outlined),
          ),
          IconButton(
            onPressed: () => controller.jumpToPage(2),
            icon: Icon(widget.pageState == PageState.photos
                ? Icons.photo_camera
                : Icons.photo_camera_outlined),
          ),
          IconButton(
            onPressed: () => controller.jumpToPage(3),
            icon: Icon(widget.pageState == PageState.student_info
                ? Icons.settings
                : Icons.settings_outlined),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.lightBlueAccent,
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      bottomNavigationBar: appBar(context),
      body: PageView(
        controller: controller,
        onPageChanged: (index) {
          setState(() {
            pageChanged = index;
          });
          widget.pageFlow(index);
        },
        children: [
          DashboardPage(),
          StudentPage(),
          PhotoPage(),
          StudentInfoPage(),
        ],
      ),
    );
  }
}
