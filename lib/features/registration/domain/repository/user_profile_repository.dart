import '../entities/user_profile.dart';

abstract class UserProfileRepository {
  Future<void> saveProfile(UserProfile profile);
}