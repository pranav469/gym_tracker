import 'package:sqflite/sqflite.dart';

import '../../../../core/service/user_profile_db_helper.dart';
import '../models/user_profile_model.dart';

abstract class UserProfileLocalDataSource {
  Future<void> saveProfile(UserProfileModel profile);
  Future<UserProfileModel?> getProfile();
}

class UserProfileLocalDataSourceImpl
    implements UserProfileLocalDataSource {

  final Database db;

  UserProfileLocalDataSourceImpl(this.db);

  @override
  Future<void> saveProfile(UserProfileModel profile) async {
    await UserProfileDbHelper.saveProfile(
      db,
      profile.toMap(),
    );
  }

  @override
  Future<UserProfileModel?> getProfile() async {
    print('..REACHED HERE..');
    final data = await UserProfileDbHelper.getProfile(db);
    print('DATA IS $data');

    if (data == null) return null;

    return UserProfileModel.fromMap(data);
  }
}