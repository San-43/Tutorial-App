import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:tutorial_app/firestore/user_firestore_service.dart';
import 'package:tutorial_app/quiz/questions_summary/questions_summary.dart';
import 'package:tutorial_app/screens/tutorial/tutorial_home.dart';

import 'data/questions.dart';

class ResultsScreen extends StatefulWidget {
  ResultsScreen(
    this.switchScreen, {
    super.key,
    required this.chosenAnswers,
    required this.progress,
  });

  final void Function() switchScreen;
  final progress;
  List<String> chosenAnswers;

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  List<Map<String, Object>> getSummaryData() {
    final summary = <Map<String, Object>>[];

    for (int i = 0; i < widget.chosenAnswers.length; i++) {
      summary.add({
        'question_index': i,
        'question': questions[widget.progress]![i].text,
        'correct_answer': questions[widget.progress]![i].answers[0],
        'user_answer': widget.chosenAnswers[i],
      });
    }

    return summary;
  }

  void updateProgress(double results) async {
    if (results >= 60 || widget.progress == 0) {
      try {
        await UserFirestoreService().updateProgressAndQuiz(
          progress: widget.progress + 1,
          quiz: true,
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'No se pudo actualizar el progreso correctamente, por favor inténtelo más tarde',
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final int numTotalQuestions = questions[widget.progress]!.length;
    final int numCorrectQuestions =
        getSummaryData().where((data) {
          return data['user_answer'] == data['correct_answer'];
        }).length;

    final double results =
        (numCorrectQuestions / numTotalQuestions * 100).toDouble();

    updateProgress(results);

    return SizedBox(
      width: double.infinity,
      child: Container(
        margin: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              results >= 60
                  ? 'Aprobaste el quiz con un ${results.toStringAsFixed(1)}% FELICIDADES!'
                  : 'Reprobaste el quiz con un ${results.toStringAsFixed(1)}%, más suerte la próxima vez',
              style: GoogleFonts.lato(
                color:
                    results >= 60
                        ? Color.fromARGB(255, 230, 200, 253)
                        : Colors.redAccent,
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
                return widget.switchScreen();
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
              onPressed: () {
                if (widget.progress > 0) {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => Tutorial()),
                  );
                } else {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => Tutorial()),
                  );
                }
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
