import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'quiz_screen.dart';
import '../Models/quiz_view_model.dart';
import '../Providers/language_provider.dart';

class CategoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final quizViewModel = Provider.of<QuizViewModel>(context, listen: false);
    final categories = languageProvider.categories; // Get categories dynamically

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: const Color.fromARGB(255, 122, 92, 43),
            expandedHeight: 300.0,
            floating: false,
            pinned: true,
            actions: [
              // Language Toggle Button
              IconButton(
                icon: Icon(Icons.language, color: Colors.white),
                onPressed: () {
                  languageProvider.toggleLanguage();
                },
              ),

              // Settings Popup Menu Button
              PopupMenuButton<String>(
                icon: Icon(Icons.settings, color: Colors.white),
                onSelected: (String choice) {
                  if (choice == 'Clear Cache') {
                   // quizViewModel.clearAllCache();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Quiz Cache Cleared!")),
                    );
                  }
                },
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem<String>(
                      value: 'Clear Cache',
                      child: Text("Clear Quiz Cache"),
                    ),
                  ];
                },
              ),
            ],
            title: Text(
                'Category',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              
              background: Image.asset(
                'assets/police.jpg',
                fit: BoxFit.fill,
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(10.0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      elevation: 5,
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => QuizScreen(category: categories[index]),
                            ),
                          );
                        },
                        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        title: Text(
                          categories[index],
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        trailing: Icon(Icons.arrow_forward_ios, color: Colors.blueGrey),
                        tileColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                    ),
                  );
                },
                childCount: categories.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
