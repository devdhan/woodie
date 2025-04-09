import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('chatbot.db');
    return _database!;
  }

  static Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 3, onCreate: _createDB);
  }

  static Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE qa(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        question TEXT,
        answer TEXT
      )
    ''');

    // Insert default Q&A pairs
    await db.insert('qa', {
      'question': 'what is the battery life?',
      'answer': 'The battery lasts up to 18 hours on a single charge.',
    });
    await db.insert('qa', {
      'question': 'what car is available?',
      'answer': 'Just Toyota Camry is available now',
    });
    await db.insert('qa', {
      'question': 'what colors are available?',
      'answer': 'It is available in black, white, silver, and red.',
    });
    await db.insert('qa', {
      'question': 'what is the mileage?',
      'answer': 'It offers a mileage of approximately 18 km/l.',
    });
    await db.insert('qa', {
      'question': 'what is the engine capacity?',
      'answer': 'The engine capacity is 2.0L for this model.',
    });
    await db.insert('qa', {
      'question': 'how many seats does it have?',
      'answer': 'It has 5 comfortable seats.',
    });
    await db.insert('qa', {
      'question': 'does it have automatic transmission?',
      'answer': 'Yes, this model supports automatic transmission.',
    });
  }

  static Future<String?> getAnswer(String question) async {
    final db = await database;
    final result = await db.query(
      'qa',
      where: 'LOWER(question) = ?',
      whereArgs: [question.toLowerCase()],
    );
    if (result.isNotEmpty) {
      return result.first['answer'] as String;
    }
    return "Sorry, I don't understand that question.";
  }

  static Future<void> deleteAllData() async {
    final db = await database;
    await db.delete('qa');
  }

  static Future<void> deleteDatabaseFile() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'chatbot.db');
    await databaseFactory.deleteDatabase(path);
  }

  static Future<void> resetDatabase() async {
    await deleteDatabaseFile();
    _database = await _initDB('chatbot.db');
  }
}
