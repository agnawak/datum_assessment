import 'package:flutter/material.dart';
import '../services/quiz_service.dart';
import 'quiz_page.dart';

class CategorySelectionPage extends StatefulWidget {
  const CategorySelectionPage({super.key});
  @override
  State<CategorySelectionPage> createState() => _CategorySelectionPageState();
}

class _CategorySelectionPageState extends State<CategorySelectionPage> {
  late Future<List<Category>> _futureCategories;

  @override
  void initState() {
    super.initState();
    _futureCategories = QuizService().fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Category'),
      ),
      body: FutureBuilder<List<Category>>(
        future: _futureCategories,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No categories found'));
          } else {
            List<Category> categories = snapshot.data!;
            return ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return ListTile(
                  title: Text(category.name),
                  onTap: () {
                    // Navigate to QuizPage with selected category
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QuizPage(category: category),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
