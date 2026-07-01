import 'package:get_it/get_it.dart';
import 'package:sqflite/sqflite.dart';

import '../../features/home/domain/usecases/get_user_profile_usecase.dart';
import '../../features/home/presentation/bloc/home_bloc.dart';
import '../../features/registration/data/data_sources/user_profile_local_datasource.dart';
import '../../features/registration/data/repositories/user_profile_repository_impl.dart';
import '../../features/registration/domain/repository/user_profile_repository.dart';
import '../../features/registration/domain/usecases/save_user_profile_usecase.dart';
import '../../features/registration/presentation/bloc/registration_bloc.dart';
import '../database/app_database.dart';

final sl = GetIt.instance;

Future<void> init() async {

  // Database
  final db = await AppDatabase.instance.database;

  sl.registerLazySingleton<Database>(() => db);

  // Data Source
  sl.registerLazySingleton<UserProfileLocalDataSource>(
        () => UserProfileLocalDataSourceImpl(sl()),
  );

  // Repository
  sl.registerLazySingleton<UserProfileRepository>(
        () => UserProfileRepositoryImpl(sl()),
  );

  // Use Case
  sl.registerLazySingleton(
        () => SaveUserProfileUseCase(sl()),
  );

  // Bloc
  sl.registerFactory(
        () => RegistrationBloc(sl()),
  );

  sl.registerLazySingleton(
        () => GetUserProfileUseCase(sl()),
  );

  sl.registerFactory(
        () => HomeBloc(sl()),
  );
}