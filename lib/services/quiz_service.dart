import 'dart:convert';
import 'package:http/http.dart' as http;

class QuizService {
  final String _baseUrl = "https://opentdb.com/api.php";
  final String _categoryUrl = "https://opentdb.com/api_category.php";

  Future<List<Question>> fetchQuestions({int amount = 10, String category = "", String difficulty = "medium"}) async {
    final response = await http.get(
      Uri.parse("$_baseUrl?amount=$amount&category=$category&difficulty=$difficulty&type=multiple"),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<Question> questions = (data['results'] as List).map((q) => Question.fromJson(q)).toList();
      return questions;
    } else {
      throw Exception("Failed to load questions");
    }
  }
  Future<List<Category>> fetchCategories() async {
    final response = await http.get(Uri.parse(_categoryUrl));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<Category> categories = (data['trivia_categories'] as List)
          .map((category) => Category.fromJson(category))
          .toList();
      return categories;
    } else {
      throw Exception("Failed to load categories");
    }
  }
}

class Question {
  final String question;
  final List<String> options;
  final String correctAnswer;
  String? selectedAnswer; // To store the user's selected answer

  Question({
    required this.question,
    required this.options,
    required this.correctAnswer,
    this.selectedAnswer,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    List<String> allOptions = List<String>.from(json['incorrect_answers']);
    allOptions.add(json['correct_answer']);
    allOptions.shuffle();

    return Question(
      question: json['question'],
      options: allOptions,
      correctAnswer: json['correct_answer'],
    );
  }
}

class Category {
  final int id;
  final String name;

  Category({required this.id, required this.name});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
    );
  }
}