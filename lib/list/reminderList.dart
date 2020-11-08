import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:reminderStarter/calenderPage/calenderScreen.dart';
import 'package:reminderStarter/model/model.dart';
import 'package:reminderStarter/database/sqflite.dart';
import 'package:async/async.dart';
import 'dart:convert';

class reminderList extends StatefulWidget {
  @override
  _reminderListState createState() => _reminderListState();
}

class _reminderListState extends State<reminderList> {
  @override
  void initState() {
    super.initState();
    _showAllListdata(allAlram);
  }

  _deleteData() async {
    setState(() {});

    await DBProvider.db.deleteAllEmployees();

    // wait for 1 second to simulate loading of data
    await Future.delayed(const Duration(seconds: 1));

    setState(() {});
  }

  List<DataRow> _rowList = [];
  List<Map> filtered = [];
  var _value = 1;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color.fromRGBO(12, 26, 42, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(12, 26, 42, 1),
        title: Text('Reminders'),
        centerTitle: true,
        actions: [
          IconButton(
              icon: Icon(Icons.delete, color: Colors.grey[600]),
              onPressed: () {
                _deleteData();
              })
        ],
      ),
      body: SafeArea(
          child: SingleChildScrollView(
              // scrollDirection: Axis.horizontal,
              padding: EdgeInsets.fromLTRB(0, 4, 6, 4),
              child: Column(children: [
                // SizedBox(height:6),/
                SizedBox(
                  height: 2,
                  width: MediaQuery.of(context).size.width,
                  child: Container(color: Colors.black26),
                ),
                // FittedBox( fit: BoxFit.fitHeight,
                // child:
                DataTable(
                  dataRowHeight: 130.0,
                  dividerThickness: 2.7,
                  columns: <DataColumn>[
                    DataColumn(
                        label: Container(
                            alignment: Alignment.centerRight,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(width: 30),
                                Text(
                                  'Filter  ',
                                  style: TextStyle(color: Colors.white),
                                  textScaleFactor: 1.6,
                                ),
                                SizedBox(width: 90),
                                DropdownButton(
                                    dropdownColor: Colors.indigo[900],
                                    iconEnabledColor: Colors.white,
                                    value: _value,
                                    items: [
                                      DropdownMenuItem(
                                        child: Text("All",
                                            style:
                                                TextStyle(color: Colors.white)),
                                        value: 1,
                                      ),
                                      DropdownMenuItem(
                                        child: Text("Once",
                                            style:
                                                TextStyle(color: Colors.white)),
                                        value: 2,
                                      ),
                                      DropdownMenuItem(
                                          child: Text("Dialy",
                                              style: TextStyle(
                                                  color: Colors.white)),
                                          value: 3),
                                      DropdownMenuItem(
                                          child: Text("Weekly",
                                              style: TextStyle(
                                                  color: Colors.white)),
                                          value: 4),
                                      DropdownMenuItem(
                                          child: Text("Monthly",
                                              style: TextStyle(
                                                  color: Colors.white)),
                                          value: 5)
                                    ],
                                    onChanged: (value) {
                                      print(value);
                                      switch (value) {
                                        case 1:
                                          {
                                            filtered.clear();
                                            _showAllListdata(allAlram);
                                          }
                                          break;
                                        case 2:
                                          {
                                            filtered.clear();
                                            for (var item in allAlram) {
                                              if (item['repeatId'] == 1)
                                                filtered.add(item);
                                            }
                                            _showAllListdata(filtered);
                                          }
                                          break;
                                        case 3:
                                          {
                                            filtered.clear();
                                            for (var item in allAlram) {
                                              if (item['repeatId'] == 2)
                                                filtered.add(item);
                                            }
                                            _showAllListdata(filtered);
                                          }

                                          break;
                                        case 4:
                                          {
                                            filtered.clear();
                                            for (var item in allAlram) {
                                              if (item['repeatId'] == 3)
                                                filtered.add(item);
                                            }
                                            _showAllListdata(filtered);
                                          }

                                          break;
                                        case 5:
                                          {
                                            filtered.clear();
                                            for (var item in allAlram) {
                                              if (item['repeatId'] == 4)
                                                filtered.add(item);
                                            }
                                            _showAllListdata(filtered);
                                          }

                                          break;
                                        default:
                                      }
                                      setState(() {
                                        _value = value;
                                      });
                                    }),
                              ],
                            ))),
                  ],
                  rows: _rowList,
                )
                //  ),
              ]))),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.redAccent[600],
        onPressed: () async {
          await Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CalendarScreen()))
              .then((value) {
            print('@@@@@@@@@$value');
            // print(value);
            setState(() {
              _value = 1;
            });
// // DBProvider.db.getAlldata().then((values) {
            var q;
            filtered.clear();
            for (var item in value) {
              q = jsonEncode(item);
              filtered.add(jsonDecode(q));

              // setState(() {
            }
            _showAllListdata(filtered);
            //  }
          });
//               }  );
        },
        tooltip: "add reminder",
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  void _showAllListdata(var allAlram) {
    print('is ermpt allAlram');
    setState(() {
      _rowList.clear();
    });
    if (allAlram.isNotEmpty) {
      setState(() {
        for (int index = 0; index < allAlram.length; index++) {
          _rowList.add(DataRow(cells: <DataCell>[
            //  DataCell( Text(b.toString())),
            DataCell(Container(
              //  height: 630,

              width: 260,
              padding: EdgeInsetsDirectional.only(start: 10, bottom: 2),
              decoration: index.isEven
                  ? BoxDecoration(
                      gradient: LinearGradient(
                          colors: [
                            Colors.indigo[900],
                            Colors.blue[600],
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter),
                      borderRadius: BorderRadius.circular(22),
                    )
                  : BoxDecoration(
                      gradient: LinearGradient(
                          colors: [
                            Colors.pink[600],
                            Colors.orange[400],
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter),
                      borderRadius: BorderRadius.circular(22),
                    ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    allAlram[index]['time'],
                    style: TextStyle(
                        fontFamily: 'avenir',
                        color: CustomColors.primaryTextColor,
                        fontSize: 32),
                  ),
                  allAlram[index]['repeatId'] == 2
                      ? Text(
                          'Every Day from :',
                          style: TextStyle(
                              letterSpacing: 1.1,
                              fontFamily: 'avenir',
                              fontWeight: FontWeight.w300,
                              color: CustomColors.primaryTextColor,
                              fontSize: 20),
                        )
                      : Container(),
                  allAlram[index]['repeatId'] == 3
                      ? Text(
                          'Every  "${allAlram[index]['weekday']}"   from :',
                          style: TextStyle(
                              letterSpacing: 1.1,
                              fontFamily: 'avenir',
                              fontWeight: FontWeight.w300,
                              color: CustomColors.primaryTextColor,
                              fontSize: 20),
                        )
                      : Container(),
                  Text(
                    allAlram[index]['date'],
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontFamily: 'avenir',
                        fontWeight: FontWeight.w300,
                        color: CustomColors.primaryTextColor,
                        fontSize: 20),
                  ),
                  Text(
                    allAlram[index]['description'],
                    style: TextStyle(
                        fontFamily: 'avenir',
                        fontWeight: FontWeight.w300,
                        color: CustomColors.primaryTextColor,
                        fontSize: 16),
                  ),
                ],
              ),
            )),
          ]));
        }
      });
    }
  }
}
