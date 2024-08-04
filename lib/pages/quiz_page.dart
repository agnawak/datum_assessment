import 'package:flutter/material.dart';
import 'package:quiz/components/my_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/quiz_service.dart';
import 'history_page.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key , required this.category});
  final Category category;

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  late Future<List<Question>> _futureQuestions;
  bool _isSubmitted = false;
  int _score = 0;

  @override
  void initState() {
    super.initState();
    _futureQuestions = QuizService().fetchQuestions(
      amount: 5,
      category: widget.category.id.toString(),
    );
  }

  Future<void> saveQuizResult(String category, int score, int totalQuestions) async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username') ?? 'Guest';

    // Get existing results
    final List<String> results = prefs.getStringList('$username-results') ?? [];

    // Add new result
    final result = '$category:$score/$totalQuestions';
    results.add(result);

    // Save updated results
    await prefs.setStringList('$username-results', results);
  }

  void _submitAnswers(List<Question> questions) {
    int score = 0;
    for (var question in questions) {
      if (question.selectedAnswer == question.correctAnswer) {
        score++;
      }
    }
    setState(() {
      _isSubmitted = true;
      _score = score;
    });

    // Save the result
    saveQuizResult(widget.category.name, score, questions.length);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const QuizHistoryPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz: ${widget.category.name}'),
      ),
      body: FutureBuilder<List<Question>>(
        future: _futureQuestions,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No questions found'));
          } else {
            List<Question> questions = snapshot.data!;
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: questions.length,
                    itemBuilder: (context, index) {
                      final question = questions[index];
                      return Card(
                        margin: const EdgeInsets.all(10),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                question.question,
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10),
                              Column(
                                children: question.options.map((option) {
                                  return RadioListTile<String>(
                                    title: Text(option),
                                    value: option,
                                    groupValue: question.selectedAnswer,
                                    onChanged: _isSubmitted
                                        ? null
                                        : (value) {
                                            setState(() {
                                              question.selectedAnswer = value;
                                            });
                                          },
                                  );
                                }).toList(),
                              ),
                              if (_isSubmitted)
                                Text(
                                  'Correct Answer: ${question.correctAnswer}',
                                  style: TextStyle(
                                    color: question.selectedAnswer == question.correctAnswer
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                if (!_isSubmitted)
                  MyButton_Submit(
                    onTap: () => _submitAnswers(questions),
                  ),
                if (_isSubmitted)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Your Score: $_score/${questions.length}',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
            );
          }
        },
      ),
    );
  }
}
