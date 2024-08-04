import 'package:flutter/material.dart';
import 'pages/login_page.dart';
//import 'pages/quiz_page.dart';
import 'pages/category_page.dart';
import 'pages/history_page.dart';
import 'pages/home_page.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App',
      initialRoute: '/',
      routes: {
        '/': (context) => const SignUpPage(),
        '/homePage': (context) => const HomePage(),
        '/quizCategoryPage': (context) => const CategorySelectionPage(),
        //'/quizPage': (context) => QuizPage(category: category),  // Modify as necessary
        '/quizHistoryPage': (context) => const QuizHistoryPage(),
      },
    );
  }
}
