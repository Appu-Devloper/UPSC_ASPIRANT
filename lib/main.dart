import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:upsc_aspirant/Screens/start_screen.dart';

import 'Models/quiz_view_model.dart';
import 'Providers/language_provider.dart';
import 'Screens/category_screen.dart';
import 'Screens/quiz_screen.dart';
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LanguageProvider()), // Language state management
        ChangeNotifierProvider(create: (_) => QuizViewModel()), // Quiz logic management
      ],
      child: UPSCQuizApp(),
    ),
  );
}

class UPSCQuizApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false,
      title: 'UPSC Quiz',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: CategoryScreen(),
    );
  }
}
