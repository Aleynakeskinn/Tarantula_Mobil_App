import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/admin_user.dart'; // Yolunuz projenize göre değişebilir

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();

  static Database? _database;

  DatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('myDatabase.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE adminUsers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL
      )
    ''');
  }

  Future<void> addAdminsDirectly() async {
    final List<AdminUser> admins = [
      AdminUser(email: 'aleynakeskin01@gmail.com', password: '654321'),
      AdminUser(email: 'beyza@gmail.com', password: '123456'),

    ];

    for (var admin in admins) {
      await addAdmin(admin);
    }
  }

  Future<void> addAdmin(AdminUser adminUser) async {
    final db = await database;
    await db.insert('adminUsers', adminUser.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<bool> checkAdminLogin(String email, String password) async {
    final db = await database;

    final maps = await db.query(
      'adminUsers',
      columns: ['email', 'password'],
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    return maps.isNotEmpty;
  }

  Future close() async {
    final db = await database;
    db.close();
  }
}
