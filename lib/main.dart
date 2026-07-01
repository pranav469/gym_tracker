import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gyn_tracking/features/home/presentation/bloc/home_bloc.dart';
import 'package:gyn_tracking/main_screen.dart';
import 'core/di/injection.dart';
import 'features/registration/data/data_sources/user_profile_local_datasource.dart';
import 'features/registration/data/repositories/user_profile_repository_impl.dart';
import 'features/registration/domain/usecases/save_user_profile_usecase.dart';
import 'features/registration/presentation/bloc/registration_bloc.dart';
import 'features/registration/presentation/pages/reg_page_step_one.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<RegistrationBloc>(),
        ),
      ],
      child: MaterialApp(
          title: 'Gym Tracking App',
         // debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          ),
        debugShowCheckedModeBanner: false,
        home: MainScreen(),
      ),
    );
  }
}
    // return MaterialApp(
    //   title: 'Gym Tracking App',
    //   debugShowCheckedModeBanner: false,
    //   theme: ThemeData(
    //     colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    //   ),
    //   home: RegPageStepOne(),
    // );
//   }
// }
