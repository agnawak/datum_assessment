import 'package:flutter/material.dart';
import 'package:quiz/components/my_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuizHistoryPage extends StatefulWidget {
  const QuizHistoryPage({super.key});
  @override
  State<QuizHistoryPage> createState() => _QuizHistoryPageState();
}

class _QuizHistoryPageState extends State<QuizHistoryPage> {
  late Future<List<String>> _futureResults;

  @override
  void initState() {
    super.initState();
    _futureResults = _loadQuizResults();
  }

  Future<List<String>> _loadQuizResults() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username') ?? 'Guest';
    final List<String>? results = prefs.getStringList('$username-results');
    return results ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz History'),
      ),
      body: FutureBuilder<List<String>>(
        future: _futureResults,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No results found'));
          } else {
            final results = snapshot.data!;
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: results.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(results[index]),
                      );
                    },
                  ),
                ),
                MyButton_Home(
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/homePage');
                  },
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
