import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    debugPrint("Splash screen started");
    Timer(Duration(seconds: 4), finished);
  }

  void finished() {
    debugPrint("finished");
    createDB();
    Navigator.pushReplacementNamed(this.context, "/home");
    //_showErrorDialogue(context);
  }

  createDB() async {
    // Get a location using getDatabasesPath
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'hwm.db');
    // open the database
    Database database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      // When creating the db, create the table
      await db.execute(
          'CREATE TABLE Favourite (wish_id INTEGER PRIMARY KEY autoincrement, prod_id INTEGER, title TEXT, image TEXT, price INTEGER, date_added TEXT)');
      await db.execute(
          'CREATE TABLE SearchHistory (search_id INTEGER PRIMARY KEY autoincrement, title TEXT, date_added TEXT)');
    });
    print("database $database");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/images/splash.jpg",
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }
}
