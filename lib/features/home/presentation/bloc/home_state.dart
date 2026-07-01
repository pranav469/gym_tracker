import '../../../registration/domain/entities/user_profile.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final UserProfile profile;

  HomeLoaded(this.profile);
}

class HomeError extends HomeState {
  final String message;

  HomeError(this.message);
}