import 'package:clone/features/authentication/data/auth_repository.dart';
import 'package:clone/features/authentication/domain/login_cubit.dart';
import 'package:clone/features/authentication/domain/signup_cubit.dart';
import 'package:clone/features/authentication/presentation/screens/login_screen.dart';
import 'package:clone/features/authentication/presentation/screens/signup_screen.dart';
import 'package:clone/features/home/domain/image_repository.dart';
import 'package:clone/features/home/domain/imagecubit.dart';
import 'package:clone/features/home/domain/pagination_cubit.dart';
import 'package:clone/features/home/presentation/screens/create_post_screen.dart';
import 'package:clone/features/home/presentation/screens/home_screen.dart';
import 'package:clone/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/authentication/data/user_repository.dart'; // Import UserRepository

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyD5z4te7eC6gtVEGkYcVoSVHynvnZP_EpA",
        authDomain: "final-db-b8f04.firebaseapp.com",
        projectId: "final-db-b8f04",
        storageBucket: "final-db-b8f04.appspot.com",
        messagingSenderId: "55671412979",
        appId: "1:55671412979:web:94ef1cba52fd4278693f86",
        measurementId: "G-43S010ED77",
        databaseURL: "https://final-db-b8f04-default-rtdb.firebaseio.com",
      ),
    );
    print("Firebase initialized successfully");
  } catch (e) {
    print("Error initializing Firebase: $e");
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SignupCubit(UserRepository()),
        ),
        BlocProvider(
          create: (context) => LoginCubit(AuthRepository()),
        ),
        BlocProvider(
          create: (context) =>
              ImageCubit(FirebaseStorage.instance as ImageRepository),
        ),
        BlocProvider(
          create: (context) => PaginationCubit(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Instagram Clone',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SplashScreen(), // Start with the splash screen
        routes: {
          '/signup': (context) => SignupScreen(),
          '/home': (context) => HomePage(),
          '/login': (context) => LoginScreen(),
          '/post': (context) => CreatePostScreen(
                selectedImages: [],
              ), // Ensure correct case and usage
        },
      ),
    );
  }
}
