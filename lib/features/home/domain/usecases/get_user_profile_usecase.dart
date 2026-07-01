import '../../../registration/domain/entities/user_profile.dart';
import '../../../registration/domain/repository/user_profile_repository.dart';


class GetUserProfileUseCase {
  final UserProfileRepository repository;

  GetUserProfileUseCase(this.repository);

  Future<UserProfile?> call() {
    final data = repository.getProfile();
    print('DD IS ${data}');
    return repository.getProfile();
  }
}