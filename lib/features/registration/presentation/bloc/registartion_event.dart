import '../../domain/entities/user_profile.dart';

abstract class RegistrationEvent {}

class SaveProfileEvent extends RegistrationEvent {
  final UserProfile profile;

  SaveProfileEvent(this.profile);
}