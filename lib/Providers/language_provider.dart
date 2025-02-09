import 'package:flutter/material.dart';

class LanguageProvider extends ChangeNotifier {
  String _currentLanguage = "English"; // Default language

  // Get current language
  String get currentLanguage => _currentLanguage;

  // Toggle between English and Kannada
  void toggleLanguage() {
    _currentLanguage = (_currentLanguage == "English") ? "Kannada" : "English";
    notifyListeners();
  }

  // Get categories based on selected language
  List<String> get categories {
    return _currentLanguage == "English"
        ? [
            'Current Affairs',
            'History',
            'Political Science',
            'General Knowledge',
            'Geography',
            'Grammar',
            'Seating Arrangement',
            'Relationship',
            'Computer Science',
            'Computer',
          ]
        : [
            'ಪ್ರಚಲಿತ ಘಟನೆಗಳು',  // Current Affairs
            'ಇತಿಹಾಸ',        // History
            'ರಾಜಕೀಯ ವಿಜ್ಞಾನ', // Political Science
            'ಸಾಮಾನ್ಯ ಜ್ಞಾನ',   // General Knowledge
            'ಭೂಗೋಳ',        // Geography
            'ವ್ಯಾಕರಣ',       // Grammar
            'ಸೀಟಿಂಗ್ ವ್ಯವಸ್ಥೆ', // Seating Arrangement
            'ಸಂಬಂಧ',        // Relationship
            'ಕಂಪ್ಯೂಟರ್ ಸೈನ್ಸ್', // Computer Science
            'ಕಂಪ್ಯೂಟರ್',      // Computer
          ];
  }
}
