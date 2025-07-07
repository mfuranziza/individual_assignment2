import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:individual_assignment2/ui/bloc/auth_bloc.dart';
import 'package:individual_assignment2/ui/bloc/notes_bloc.dart';
import 'package:individual_assignment2/ui/screens/splash_screen.dart';
import 'package:individual_assignment2/core/theme/app_theme.dart';

import 'data/repositories/auth_repository.dart';
import 'data/repositories/notes_respository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(
          create: (context) => AuthRepository(),
        ),
        RepositoryProvider<NotesRepository>(
          create: (context) => NotesRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(
              authRepository: context.read<AuthRepository>(),
            ),
          ),
          BlocProvider<NotesBloc>(
            create: (context) => NotesBloc(
              notesRepository: context.read<NotesRepository>(),
            ),
          ),
        ],
        child: MaterialApp(
          title: 'Notes App',
          theme: AppTheme.lightTheme,
          debugShowCheckedModeBanner: false,
          home: const SplashScreen(),
        ),
      ),
    );
  }
}
