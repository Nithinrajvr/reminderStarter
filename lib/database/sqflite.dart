import 'dart:convert';
import 'dart:io';
//import 'package:dlicense_codemagic/src/models/employee_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:reminderStarter/model/model.dart';

class DBProvider {
  static Database _database;
  static final DBProvider db = DBProvider._();
  DBProvider._();
  Future<Database> get database async {
    // If database exists, return database
    if (_database != null) return _database;

    // If database don't exists, create one
    _database = await initDB();
    return _database;
  }

  // Create the database and the Employee table
  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'reminder_Data_table.db');

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE Datatable('
          'id INTEGER INTEGER NOT NULL,'
          'repeatId INTEGER NOT NULL,'
          'date TEXT,'
          'time TEXT,'
          'fromDate TEXT,'
          'toDate TEXT,'
          'description TEXT,'
          'weekday TEXT'
          ')');
    });
  }

  int countryId;
  int id;
  String stateName;
  // Insert employee on database
  insert(ReminderClass data) async {
    final db = await database;
    final res = await db.insert('Datatable', data.toJson());
    return res;
  }

  // Delete all employees
  Future<int> deleteAllEmployees() async {
    final db = await database;
    final resa = await db.rawDelete('DELETE FROM Datatable');

    return resa;
  }

  Future<List<ReminderClass>> getAlldata() async {
    final db = await database;
    allAlram = await db.rawQuery("SELECT * FROM DATATABLE");
    print(allAlram);
    print('*****************************');
    List<ReminderClass> list = allAlram.isNotEmpty
        ? allAlram.map((c) => ReminderClass.fromJson(c)).toList()
        : [];
    return list;
  }
}
