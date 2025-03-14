// database_helper.dart
import 'dart:async';
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  // Singleton instance
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  // Getter that returns the same database instance
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize the database
  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'appData.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  // Create the tables when the database is first created
  Future _onCreate(Database db, int version) async {
    // Table for storing chat messages (optional)
    await db.execute('''
      CREATE TABLE chat_messages (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        message TEXT,
        isUser INTEGER,    -- 1 for user, 0 for bot
        timestamp TEXT
      )
    ''');
    // Table for storing user health data
    await db.execute('''
      CREATE TABLE user_health_data (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        metric TEXT,       -- e.g., "blood_pressure", "heart_rate", "weight"
        value REAL,
        timestamp TEXT
      )
    ''');
  }

  // Insert a chat message (if needed)
  Future<int> insertChatMessage(Map<String, dynamic> chatMessage) async {
    Database db = await database;
    return await db.insert('chat_messages', chatMessage);
  }

  // Insert a health data record
  Future<int> insertHealthData(Map<String, dynamic> healthData) async {
    Database db = await database;
    return await db.insert('user_health_data', healthData);
  }

  // Fetch all chat messages (optional)
  Future<List<Map<String, dynamic>>> fetchAllChatMessages() async {
    Database db = await database;
    return await db.query('chat_messages', orderBy: "timestamp ASC");
  }

  // Fetch all health data records
  Future<List<Map<String, dynamic>>> fetchAllHealthData() async {
    Database db = await database;
    return await db.query('user_health_data', orderBy: "timestamp ASC");
  }
}


// // database_helper.dart
// import 'dart:async';
// import 'dart:io';
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';
// import 'package:path_provider/path_provider.dart';

// class DatabaseHelper {
//   static final DatabaseHelper _instance = DatabaseHelper._internal();
//   factory DatabaseHelper() => _instance;
//   DatabaseHelper._internal();

//   static Database? _database;

//   Future<Database> get database async {
//     if (_database != null) return _database!;
//     _database = await _initDatabase();
//     return _database!;
//   }

//   Future<Database> _initDatabase() async {
//     Directory documentsDirectory = await getApplicationDocumentsDirectory();
//     String path = join(documentsDirectory.path, 'appData.db');
//     return await openDatabase(
//       path,
//       version: 1,
//       onCreate: _onCreate,
//     );
//   }

//   Future _onCreate(Database db, int version) async {
//     // Create a table for chat messages
//     await db.execute('''
//       CREATE TABLE chat_messages (
//         id INTEGER PRIMARY KEY AUTOINCREMENT,
//         message TEXT,
//         isUser INTEGER,    -- 1 for user, 0 for bot
//         timestamp TEXT
//       )
//     ''');
//   }

//   Future<int> insertChatMessage(Map<String, dynamic> chatMessage) async {
//     Database db = await database;
//     return await db.insert('chat_messages', chatMessage);
//   }

//   Future<List<Map<String, dynamic>>> fetchAllChatMessages() async {
//     Database db = await database;
//     return await db.query('chat_messages', orderBy: "timestamp ASC");
//   }
// }
