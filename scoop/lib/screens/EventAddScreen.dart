import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scoop/screens/PostAddScreen.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class EventAddScreen extends StatefulWidget {
  const EventAddScreen({Key? key}) : super(key: key);

  @override
  _EventAddState createState() => _EventAddState();
}

class _EventAddState extends State<EventAddScreen>{
  final formKey = GlobalKey<FormState>();
  CollectionReference event = FirebaseFirestore.instance.collection('events');

  final DateRangePickerController _controller = DateRangePickerController();
  String title = '';
  String selectedDate = '';
  String displayDate = '';
  String startTime = '';
  String endTime = '';

  Future<void> addEvent() async {
    return event.add({
      'title': title, 
      'startTime': selectedDate + ' ' + startTime,
      'endTime': selectedDate + ' ' + endTime,
    }).then((value) => print("업로드 성공"))
    .catchError((error) => print("문제가 발생했습니다: $error"));
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      selectedDate = DateFormat('dd/MM/yyyy').format(args.value).toString();
      displayDate = DateFormat.yMd().format(args.value).toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return 
    Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        centerTitle: true,
        title: const Text(
          "새 이벤트 추가",
          style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w700)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Form(
        key: formKey,
        child: Column(
          children: [
            renderPostAddField(
              label: '내용', 
              value: '',
              lineNum: 1,
              onSaved: (val) {
                setState(() {
                  title = val;
                });
              }, 
              validator: (val) {
                if (val.length < 1) {
                  return '내용을 입력해주세요';
                }

                return null;
              },
            ),
            const Text(
              '날짜/시간',
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w700,
              ),
            ),
            SfDateRangePicker(
              onSelectionChanged: _onSelectionChanged,
              selectionMode: DateRangePickerSelectionMode.single,
              view: DateRangePickerView.month,
              monthViewSettings: const DateRangePickerMonthViewSettings(firstDayOfWeek: 1),
              showNavigationArrow: true,
              controller: _controller,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    DatePicker.showTimePicker(
                      context,
                      showTitleActions: true,
                      currentTime: DateTime.now(),
                      locale: LocaleType.ko,
                      onConfirm: (time) {
                        setState(() {
                          startTime = DateFormat('HH:mm:ss').format(time).toString();
                        });
                      }
                    ); 
                  },
                  child: const Text('시작 시간 선택'),
                ),
                TextButton(
                  onPressed: () {
                    DatePicker.showTimePicker(
                      context,
                      showTitleActions: true,
                      currentTime: DateTime.now(),
                      locale: LocaleType.ko,
                      onConfirm: (time) {
                        setState(() {
                          endTime = DateFormat('HH:mm:ss').format(time).toString();
                        });
                      }
                    ); 
                  },
                  child: const Text('종료 시간 선택'),
                ),
              ],
            ),
            Text('선택된 날짜: $displayDate 시간: $startTime - $endTime'),
            Container(height: 30.0,),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();
                  addEvent();
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