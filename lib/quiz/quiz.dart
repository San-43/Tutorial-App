import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tutorial_app/quiz/questions_screen.dart';
import 'package:tutorial_app/quiz/results_screen.dart';
import '../screens/auth/welcome_screen.dart';
import '../widgets/user_Avatar.dart';
import 'data/questions.dart';
import 'home_page.dart';

class Quiz extends StatefulWidget {
  const Quiz({super.key});

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
    if (selectedAnswer.length == questions.length) {
      setState(() {
        activeScreen = 'results_screen';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    User user = FirebaseAuth.instance.currentUser!;
    final String? userName = FirebaseAuth.instance.currentUser!.displayName;

    Widget screenWidget = HomePage(switchScreen);

    if (activeScreen == 'questions_screen') {
      screenWidget = QuestionsScreen(onSelectAnswer: chooseAnswer);
    } else if (activeScreen == 'results_screen') {
      screenWidget = ResultsScreen(switchScreen, chosenAnswers: selectedAnswer);
    }

  late final BoxDecoration gradientDecoration;

    gradientDecoration = BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Theme.of(context).colorScheme.primary,
          Theme.of(context).colorScheme.secondary
        ],
      ),
    );

    return MaterialApp(
      home: Scaffold(
        // Make AppBar transparent and apply gradient via flexibleSpace
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text('Welcome $userName, you are in!', style: const TextStyle(color: Colors.white)),
          flexibleSpace: Container(decoration: gradientDecoration),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => WelcomeScreen()),
                  );
                },
                borderRadius: BorderRadius.circular(10),
                child: userAvatar(user.photoURL),
              ),
            )
          ],
        ),
        body: Container(
          constraints: const BoxConstraints.expand(),
          decoration: gradientDecoration,
          child: screenWidget,
        ),
      ),
    );
  }
}
