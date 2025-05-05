import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:tutorial_app/firestore/user_firestore_service.dart';
import 'package:tutorial_app/quiz/questions_summary/questions_summary.dart';
import 'package:tutorial_app/screens/tutorial/tutorial_home.dart';
import 'package:tutorial_app/userPreferences.dart';

import 'data/questions1.dart';

class ResultsScreen extends StatelessWidget {
  ResultsScreen(this.switchScreen, {super.key, required this.chosenAnswers});

  final void Function() switchScreen;
  List<String> chosenAnswers;

  List<Map<String, Object>> getSummaryData() {
    final summary = <Map<String, Object>>[];

    for (int i = 0; i < chosenAnswers.length; i++) {
      summary.add({
        'question_index': i,
        'question': questions[i].text,
        'correct_answer': questions[i].answers[0],
        'user_answer': chosenAnswers[i],
      });
    }

    return summary;
  }

  @override
  Widget build(BuildContext context) {
    final numTotalQuestions = questions.length;
    final numCorrectQuestions =
        getSummaryData().where((data) {
          return data['user_answer'] == data['correct_answer'];
        }).length;

    return SizedBox(
      width: double.infinity,
      child: Container(
        margin: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'You answered $numCorrectQuestions out of $numTotalQuestions questions correctly!',
              style: GoogleFonts.lato(
                color: Color.fromARGB(255, 230, 200, 253),
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            QuestionsSummary(getSummaryData()),
            SizedBox(height: 30),
            TextButton.icon(
              onPressed: () {
                return switchScreen();
              },
              icon: Icon(Icons.refresh, color: Colors.white, size: 24),
              label: Text(
                'Restart Quiz!',
                style: GoogleFonts.lato(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 10),
            TextButton.icon(
              onPressed: () async {
                await UserFirestoreService().updateProgressAndQuiz(progress: 1, quiz: true);

                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => Tutorial()),
                );
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.greenAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30), // Bordes redondeados
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              icon: const Icon(Icons.arrow_forward, color: Colors.white),
              label: Text(
                'Continue',
                style: GoogleFonts.lato(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
