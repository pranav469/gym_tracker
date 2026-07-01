import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../service/user_profile_db_helper.dart';


class AppDatabase {
  AppDatabase._();

  static final AppDatabase instance = AppDatabase._();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(
      await getDatabasesPath(),
      'gym_tracking.db',
    );

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await UserProfileDbHelper.createTable(db);

        // Future tables
        // await WorkoutDbHelper.createTable(db);
        // await ExerciseDbHelper.createTable(db);
        // await MealDbHelper.createTable(db);
      },
    );
  }
}