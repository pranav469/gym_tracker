import 'package:sqflite/sqflite.dart';

class UserProfileDbHelper {
  static const tableName = 'user_profile';

  static Future<void> createTable(Database db) async {
    await db.execute('''
      CREATE TABLE $tableName (
        id INTEGER PRIMARY KEY,
        name TEXT,
        email TEXT,
        age INTEGER,
        gender TEXT,
        height REAL,
        current_weight REAL,
        target_weight REAL,
        goal TEXT,
        activity_level TEXT,
        workout_days INTEGER,
        daily_calorie_target INTEGER,
        daily_protein_target REAL,
        daily_carb_target REAL,
        daily_fat_target REAL,
        daily_water_target REAL
      )
    ''');
  }

  static Future<void> saveProfile(
      Database db,
      Map<String, dynamic> data,
      ) async {
    print('.....');
    await db.insert(
      tableName,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<Map<String, dynamic>?> getProfile(
      Database db,
      ) async {
    print('REACHED WITH DB - $db');
    final result = await db.query(
      tableName,
      limit: 1,
    );
    print('RESULT IS $result');
    print(result.first);

    if (result.isEmpty) return null;

    return result.first;
  }

  static Future<void> deleteProfile(
      Database db,
      ) async {
    await db.delete(tableName);
  }
}