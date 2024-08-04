import 'package:flutter/material.dart';
import '../components/my_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MyButton_Start(
              onTap: () {
                Navigator.pushNamed(context, '/quizCategoryPage');
              },
            ),
            const SizedBox(height: 20),
            MyButton(
              onTap: () {
                Navigator.pushNamed(context, '/quizHistoryPage');
              },
            ),
          ],
        ),
      ),
    );
  }
}
