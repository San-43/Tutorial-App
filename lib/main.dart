import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tutorial_app/firestore/user_firestore_service.dart';
import 'package:tutorial_app/quiz/quiz.dart';
import 'package:tutorial_app/screens/auth/welcome_screen.dart';
import 'package:tutorial_app/screens/tutorial/tutorial_home.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tutorial App',
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          surface: Colors.white,
          onSurface: Colors.black,
          primary: Color(0xFF00599C), // Azul fuerte del logo de C++
          onPrimary: Colors.white, // Texto blanco sobre fondo azul
          secondary: Color(0xFF004482), // Un azul más oscuro como secundario
          onSecondary: Colors.white,
          tertiary: Color(
            0xFF87CEFA,
          ), // Azul claro para detalles (tipo skyblue)
          error: Colors.red,
          outline: Color(0xFF333333), // Gris oscuro para bordes
        ),
      ),
      home: AuthGate(),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasData) {
          // hay usuario: checar si ya hizo el quiz
          return FutureBuilder<bool>(
            future: UserFirestoreService().getQuiz(),
            builder: (context, futureSnapshot) {
              if (futureSnapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }
              if (futureSnapshot.data == false) {
                return const Quiz();
              } else {
                return const Tutorial();
              }
            },
          );
        }
        // no hay usuario: mostrar login
        return const WelcomeScreen();
      },
    );
  }
}