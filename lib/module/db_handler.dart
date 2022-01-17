import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';
import 'package:sqlite_app/module/employee_module.dart';

//flutter pub add sqflite
//flutter pub add path_provider
class DBHandler {
  DBHandler.init();

  static final DBHandler instance = DBHandler.init();

  Database? _database;
  Future<Database> get database async => _database = await createDB();

  Future<Database> createDB() async {
    Directory docDirectory = await getApplicationDocumentsDirectory();
    String path = join(docDirectory.path, 'employeesDatabase.db');
    // for "join()" you have to explicitly import 'package:path/path.dart';
    return await openDatabase(
      path,
      version: 1,
      onCreate: createDatabase,
    );
  }

  FutureOr<void> createDatabase(Database db, int version) async {
    await db.execute('''
    CREATE TABLE EMPLOYEE ( 
      id INTEGER PRIMARY KEY, 
      name TEXT
    )
    ''');
  }

  Future<List<Employee>> getEmployee() async {
    final db = await instance.database;
    var employees = await db.query('EMPLOYEE'); //table name in SQL
    List<Employee> empList = employees.isNotEmpty
        ? employees.map((e) => Employee.fromMap(e)).toList()
        : [];
    return empList;
  }

  Future<void> insertEmployee(Employee emp) async {
    final db = await instance.database;
    db.insert("EMPLOYEE", emp.toMap());
  }

  Future<void> updateEmp(Employee emp) async {
    Database db = await instance.database;
    await db.update(
      "EMPLOYEE",
      emp.toMap(),
      where: 'id=?', //to prompt the user to enter ID
      whereArgs: [emp.id],
    );
  }

  Future<void> deleteEmp(int empId) async {
    Database db = await instance.database;
    await db.delete('employee', where: 'id=?', whereArgs: [empId]);
  }
}
