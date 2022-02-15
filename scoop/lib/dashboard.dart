import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:scoop/screens/Drawer.dart';
import 'package:scoop/screens/EventAddScreen.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<DashboardPage> {
  final List<Color> _colorCollection = <Color>[];
  MeetingDataSource? events;
  final databaseReference = FirebaseFirestore.instance;
  String? docId = '';

  @override
  void initState() {
    _initializeEventColor();
    getDataFromFireStore().then((results) {
      SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
        setState(() {});
      });
    });
    super.initState();
  }

  Future<void> deleteEvent(String id) async {
    return databaseReference.collection('events')
           .doc(id).delete()
           .then((value) => print("삭제되었습니다"))
           .catchError((error) => print("문제가 발생했습니다"));                
  }

  void calendarPressed (CalendarLongPressDetails details) {
    final Meeting appointmentDetails = details.appointments![0];

    docId = appointmentDetails.id;

    showDialog(
      context: context, 
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("이벤트를 삭제하시겠습니까?"),
          actions: [
            TextButton(
              child: Text("취소"),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text("삭제"),
              onPressed: () {
                deleteEvent(docId!);
                Navigator.pop(context);
              },
            ),
          ],
        );
      }
    );
  }

  Future<void> getDataFromFireStore() async {
    var snapShotsValue = await databaseReference
    .collection("events")
    .get();

    final Random random = new Random();
    List<Meeting> list = snapShotsValue.docs
    .map((e) => Meeting(
      eventName: e.data()['title'],
      from: DateFormat('dd/MM/yyyy HH:mm:ss').parse(e.data()['startTime']),
      to: DateFormat('dd/MM/yyyy HH:mm:ss').parse(e.data()['endTime']),
      background: _colorCollection[random.nextInt(9)],
      id: e.id,
      isAllDay: false)
    )
    .toList();
    setState(() {
      events = MeetingDataSource(list);
    });
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
          "일정",
          style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w700)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: 
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: SfCalendar(
            view: CalendarView.month,
            firstDayOfWeek: 1,
            initialSelectedDate: DateTime.now(),
            todayHighlightColor: Colors.lightBlueAccent,
            showNavigationArrow: true,
            dataSource: events,
            monthViewSettings: const MonthViewSettings(
              showAgenda: true,
            ),
            onLongPress: calendarPressed,
          ),
        ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightBlueAccent,
        onPressed: () {
          Navigator.push(
            context, 
            MaterialPageRoute(builder: (context) => const EventAddScreen()),
          ).then((value) {
            getDataFromFireStore();
          });
        },
        child: const Icon(Icons.add),
      ),
      drawer: defaultDrawer(context: context),
    );
  }

  void _initializeEventColor() {
    _colorCollection.add(const Color(0xFF0F8644));
    _colorCollection.add(const Color(0xFF8B1FA9));
    _colorCollection.add(const Color(0xFFD20100));
    _colorCollection.add(const Color(0xFFFC571D));
    _colorCollection.add(const Color(0xFF36B37B));
    _colorCollection.add(const Color(0xFF01A1EF));
    _colorCollection.add(const Color(0xFF3D4FB5));
    _colorCollection.add(const Color(0xFFE47C73));
    _colorCollection.add(const Color(0xFF636363));
    _colorCollection.add(const Color(0xFF0A8043));
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }
}

class Meeting {
  String? eventName;
  DateTime? from;
  DateTime? to;
  Color? background;
  bool? isAllDay;
  String id;

  Meeting({this.eventName, this.from, this.to, this.background, this.isAllDay, required this.id});
}