
import 'package:gyn_tracking/features/registration/presentation/bloc/registartion_event.dart';
import 'package:gyn_tracking/features/registration/presentation/bloc/registartion_state.dart';

class RegistrationBloc
    extends Bloc<RegistrationEvent, RegistrationState> {

  final SaveUserProfileUseCase saveUserProfileUseCase;

  RegistrationBloc(this.saveUserProfileUseCase)
      : super(RegistrationInitial()) {

    on<SaveProfileEvent>((event, emit) async {

      emit(RegistrationLoading());

      try {

        await saveUserProfileUseCase(event.profile);

        emit(RegistrationSuccess());

      } catch (e) {

        emit(RegistrationFailure(e.toString()));

      }
    });
  }
}