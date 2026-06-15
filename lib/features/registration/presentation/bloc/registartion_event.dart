abstract class RegistrationEvent {}

class SaveProfileEvent extends RegistrationEvent {
  final UserProfile profile;

  SaveProfileEvent(this.profile);
}