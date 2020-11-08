import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_calendar/flutter_clean_calendar.dart';
// import 'package:reminder/list/List.dart';
// import 'package:http/http.dart' as http;
import 'package:reminderStarter/database/sqflite.dart';
import 'package:reminderStarter/model/model.dart';

// import 'package:appdata/src/models/masterdata.dart';
class CalendarScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CalendarScreenState();
  }
}

class _CalendarScreenState extends State<CalendarScreen> {
  String a;
  var sizebox = SizedBox(height: 4);
  TextEditingController _timeController = TextEditingController(text: ''),
      descriptionctr;
  String dateTime;
  bool visibilityclass3 = false;
  DateTime date;
  var formatTime = new DateFormat.jm();
  String niveaulevel = '';
  int nilevel;
  String description, secectedRepet;
  String fromjsondata;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
  bool checkboxValue = false;
  var reminderObj = new ReminderClass();
  int repeatId = 1;
  DateTime _selectedDay = DateTime.now();
  bool _autoValidate = false;
  List<Map> datalist = [];

  Future<int> futuregettrainingdata;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[100],
      appBar: AppBar(backgroundColor: Colors.indigo[900], actions: [
        Center(
          child: Text(
            ' |  ',
            textScaleFactor: 1.8,
          ),
        ),
        GestureDetector(
            child: Center(
              child: Text(
                'Done  ',
                textScaleFactor: 1.4,
              ),
            ),
            onTap: _validateInputs)
      ]),
      key: _scaffoldKey,
      body: SafeArea(
          child: SingleChildScrollView(
              child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Colors.indigo[600],
            Colors.indigo[100],
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        padding: EdgeInsets.all(15.0),
        child: new Form(
            key: _formKey, autovalidate: _autoValidate, child: widgets()),
      ))),
    );
  }

  Widget widgets() {
    return Column(
      children: <Widget>[
        Calendar(
          isExpanded: false,
          hideBottomBar: true,
          startOnMonday: true,
          weekDays: ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"],
          events: _events,
          onDateSelected: (date) => _handleNewDate(date),
          isExpandable: true,
          eventDoneColor: Colors.green,
          selectedColor: Colors.indigo[900],
          todayColor: Colors.green,
          eventColor: Colors.grey,
          dayOfWeekStyle: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w800, fontSize: 11),
          bottomBarTextStyle: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w800, fontSize: 18),
          bottomBarColor: Colors.indigo[600],
        ),
        sizebox,
        _buildEventList(),
      ],
    );
  }

  Widget _buildEventList() {
    return Container(
      // height: 600,
      child: Column(
          children: [remindTime(), sizebox, repit(), sizebox, _description()]),
    );
  }

  Widget remindTime() => TextFormField(
        controller: _timeController,
        readOnly: true,
        validator: (value) => value == '' ? 'field required' : null,
        decoration: const InputDecoration(
            labelStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
            labelText: 'Time',
            hintText: ' Select Time',
            suffixIcon: Icon(Icons.access_alarms)),
        keyboardType: TextInputType.phone,
        onTap: () => _selectTime(context),
        onSaved: (val) => reminderObj.time = _timeController.text.toString(),
        onChanged: (String value) {
          // language.certificateNumber= int.parse(value);
        },
      );
  Widget _description() {
    return TextFormField(
        textAlign: TextAlign.start,
        maxLines: 3,
        controller: descriptionctr,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(3, 4, 60, 4),
          labelText: 'Description',
          labelStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
          fillColor: Colors.white,
        ),
        textInputAction: TextInputAction.done,
        // validator: re,
        onSaved: (val) => reminderObj.description = val);
  }

  Widget repit() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
          hintText: 'Repeat',
          labelStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
          labelText: "Repeat"),
      value: secectedRepet, //  findval(examinarapiId,5), //
      onChanged: (String newValue) => repeatId = repeatId,
      validator: (value) => value == null ? 'field required' : null,
      onSaved: (val) =>
          reminderObj.repeatId = repeatId, //  saveUserData.nationality=val,
      items: repatList.map((item) {
        return new DropdownMenuItem(
          child: new Text(item['value']),
          value: item['value'].toString(),
          onTap: () {
            repeatId = item['id'];
            //     print(examinarapiId);
          },
        );
      }).toList(),
    );
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked =
        await showTimePicker(context: context, initialTime: selectedTime);
    if (picked != null)
      setState(() {
        selectedTime = picked;
        _timeController.text = picked.format(context).toString();
      });
  }

  void _validateInputs() {
    if (_formKey.currentState.validate()) {
//    If all data are correct then save data to out variables
      _formKey.currentState.save();
      shoe();
    } else {
//    If all data are not valid then start auto validation.
      setState(() {
        _autoValidate = true;
      });
    }
  }

  Map<DateTime, List> _events = {};
  void _handleNewDate(date) {
    setState(() {
      _selectedDay = date;
      reminderObj.weekday = DateFormat('EEEE').format(_selectedDay).toString();
      reminderObj.date =
          DateFormat('d MMM yyyy').format(_selectedDay).toString();
    });
  }

  ///////////////////
  shoe() {
    if (reminderObj.repeatId == 4) {
      calculateEndDate(_selectedDay);
      datalist.map((data) {
        DBProvider.db.insert(ReminderClass.fromJson(data));
      }).toList();
    } else {
      if (reminderObj.date.length < 1) _handleNewDate(DateTime.now());
      DBProvider.db.insert(reminderObj);
    }

    DBProvider.db.getAlldata().then((value) => Navigator.pop(context, value));
  }
// ///////////////////////////////

  Future<Null> calculateEndDate(DateTime fromDate) {
    DateTime formatedDate;
    for (int i = fromDate.month; i < 13; i++) {
      formatedDate = DateTime(fromDate.year, i, fromDate.day);
      reminderObj.weekday = DateFormat('EEEE').format(formatedDate).toString();
      reminderObj.date =
          DateFormat('d MMM yyyy').format(formatedDate).toString();
      addToList(reminderObj);
    }
    return null;
  }

  addToList(ReminderClass obj) async {
    String p = jsonEncode(obj);
    datalist.add(jsonDecode(p));
    Future.delayed(Duration(milliseconds: 40));
  }
  ////////////////////////////////////////////////////////////////////////
}
/////////////
