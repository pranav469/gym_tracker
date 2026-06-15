import 'package:sqflite/sqflite.dart';

class UserProfileDbHelper {
  static const String tableName = 'user_profile';

  /// Create Table
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

  /// Insert Profile
  static Future<int> insertProfile(
      Database db,
      Map<String, dynamic> data,
      ) async {
    return await db.insert(
      tableName,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Get Profile
  static Future<Map<String, dynamic>?> getProfile(Database db) async {
    final result = await db.query(
      tableName,
      limit: 1,
    );

    if (result.isNotEmpty) {
      return result.first;
    }

    return null;
  }

  /// Update Profile
  static Future<int> updateProfile(
      Database db,
      Map<String, dynamic> data,
      ) async {
    return await db.update(
      tableName,
      data,
      where: 'id = ?',
      whereArgs: [data['id']],
    );
  }

  /// Delete Profile
  static Future<int> deleteProfile(Database db, int id) async {
    return await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Check if Profile Exists
  static Future<bool> profileExists(Database db) async {
    final result = await db.query(
      tableName,
      columns: ['id'],
      limit: 1,
    );

    return result.isNotEmpty;
  }

  /// Insert or Update
  static Future<void> saveProfile(
      Database db,
      Map<String, dynamic> data,
      ) async {
    final exists = await profileExists(db);

    if (exists) {
      await updateProfile(db, data);
    } else {
      await insertProfile(db, data);
    }
  }
}