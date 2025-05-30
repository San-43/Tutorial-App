import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tutorial_app/firestore/user_firestore_service.dart';
import 'package:tutorial_app/quiz/questions_screen.dart';
import 'package:tutorial_app/quiz/results_screen.dart';
import 'package:tutorial_app/screens/profile_details.dart';
import '../widgets/user_Avatar.dart';
import 'data/questions.dart';
import 'home_page.dart';

class Quiz extends StatefulWidget {
  const Quiz({super.key, required this.progress});
  final int progress;

  @override
  State<Quiz> createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
  List<String> selectedAnswer = [];

  String activeScreen = 'home_page';

  void switchScreen() {
    setState(() {
      selectedAnswer = [];
      activeScreen = 'questions_screen';
    });
  }

  void chooseAnswer(String answer) {
    selectedAnswer.add(answer);
    if (selectedAnswer.length == questions[widget.progress]!.length) {
      setState(() {
        activeScreen = 'results_screen';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    String? userName = user?.displayName;
    String? userImage = user?.photoURL;

    Widget screenWidget = HomePage(switchScreen);

    if (activeScreen == 'questions_screen') {
      screenWidget = QuestionsScreen(onSelectAnswer: chooseAnswer, progress: widget.progress,);
    } else if (activeScreen == 'results_screen') {
      screenWidget = ResultsScreen(switchScreen, chosenAnswers: selectedAnswer, progress: widget.progress,);
    }

    late final BoxDecoration gradientDecoration;

    gradientDecoration = BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Theme.of(context).colorScheme.primary,
          Theme.of(context).colorScheme.secondary,
        ],
      ),
    );

    return FutureBuilder<int>(
      future: UserFirestoreService().getProgress(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        return MaterialApp(
          home: Scaffold(
            // Make AppBar transparent and apply gradient via flexibleSpace
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 1,
              title: Text(
                'Welcome $userName, you are in!',
                style: const TextStyle(color: Colors.white),
              ),
              flexibleSpace: Container(decoration: gradientDecoration),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: PopupMenuButton<String>(
                    position: PopupMenuPosition.under,
                    offset: const Offset(0, 8),
                    onSelected: (value) async {
                      if (value == 'logout') {
                        await FirebaseAuth.instance.signOut();
                        Navigator.of(context).pop();
                      } else if (value == 'profile') {
                        await Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => ProfileDetailScreen()),
                        );
                        setState(() {
                          userImage = user?.photoURL;
                        });
                      }
                    },
                    itemBuilder:
                        (context) => [
                          const PopupMenuItem(
                            value: 'profile',
                            child: Text('Ver perfil'),
                          ),
                          const PopupMenuItem(value: 'about', child: Text('About')),
                          const PopupMenuItem(
                            value: 'logout',
                            child: Text('Cerrar sesión'),
                          ),
                        ],
                    child: userAvatar(userImage),
                  ),
                ),
              ],
            ),
            body: Container(
              constraints: const BoxConstraints.expand(),
              decoration: gradientDecoration,
              child: screenWidget,
            ),
          ),
        );
      },
    );
  }
}
