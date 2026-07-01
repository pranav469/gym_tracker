import 'package:bloc/bloc.dart';

import '../../domain/usecases/get_user_profile_usecase.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {

  final GetUserProfileUseCase getUserProfile;

  HomeBloc(this.getUserProfile) : super(HomeInitial()) {

    on<LoadUserProfileEvent>((event, emit) async {

      emit(HomeLoading());

      final profile = await getUserProfile();

      print('PROFILE IS ${profile?.name ?? ''}');

      if (profile == null) {
        emit(HomeError("Profile not found"));
        return;
      }

      emit(HomeLoaded(profile));

    });

  }
}