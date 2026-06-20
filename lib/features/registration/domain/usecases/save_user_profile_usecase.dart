import '../entities/user_profile.dart';
import '../repository/user_profile_repository.dart';

class SaveUserProfileUseCase {
  final UserProfileRepository repository;

  SaveUserProfileUseCase(this.repository);

  Future<void> call(UserProfile profile) {
    return repository.saveProfile(profile);
  }
}