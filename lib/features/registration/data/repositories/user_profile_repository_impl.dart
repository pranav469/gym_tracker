import '../../domain/entities/user_profile.dart';
import '../../domain/repository/user_profile_repository.dart';
import '../data_sources/user_profile_local_datasource.dart';
import '../models/user_profile_model.dart';

class UserProfileRepositoryImpl
    implements UserProfileRepository {

  final UserProfileLocalDataSource localDataSource;

  UserProfileRepositoryImpl(this.localDataSource);

  @override
  Future<void> saveProfile(UserProfile profile) async {

    final model = UserProfileModel(
      id: profile.id,
      name: profile.name,
      email: profile.email,
      age: profile.age,
      gender: profile.gender,
      height: profile.height,
      currentWeight: profile.currentWeight,
      targetWeight: profile.targetWeight,
      goal: profile.goal,
      activityLevel: profile.activityLevel,
      workoutDays: profile.workoutDays,
      dailyCalorieTarget: profile.dailyCalorieTarget,
      dailyProteinTarget: profile.dailyProteinTarget,
      dailyCarbTarget: profile.dailyCarbTarget,
      dailyFatTarget: profile.dailyFatTarget,
      dailyWaterTarget: profile.dailyWaterTarget,
    );

    await localDataSource.saveProfile(model);
  }

  @override
  Future<UserProfile?> getProfile() async {
    final data = await localDataSource.getProfile();
    print('DATA I S ${data?.name}');
    return data;
  }
}