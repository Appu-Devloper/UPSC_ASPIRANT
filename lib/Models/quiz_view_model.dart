import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

const apiKey = 'AIzaSyD2KvzGG_sXau7L-UREoJSupOqRYgWt3Hk'; // Replace with your actual API key

class QuizViewModel extends ChangeNotifier {
  late GenerativeModel _model;
  String question = "";
  List<String> options = [];
  String? correctAnswer;
  int correctIndex = -1;
  int? selectedAnswer;
  bool isLoading = true;
  bool hasError = false;
  String errorMessage = "";

  int correctAnswers = 0;
  int totalQuestions = 0;

  static final Map<String, Set<String>> _categoryQuestions = {};

  QuizViewModel() {
    _model = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: apiKey,
      generationConfig: GenerationConfig(
        temperature: 0.9,
        topP: 0.9,
        topK: 50,
        maxOutputTokens: 250,
      ),
    );
  }

  Future<void> generateQuestion(String category,String language) async {
    isLoading = true;
    hasError = false;
    errorMessage = "";
    selectedAnswer = null; // Reset selected answer
    notifyListeners();

    _categoryQuestions.putIfAbsent(category, () => {});

    String prompt = """
      Generate a unique multiple-choice quiz question for Indian $category. 
      The question must NOT repeat any of the following: ${_categoryQuestions[category]!.join(", ")}. 
      Provide the question, four options, and the correct answer index in a structured JSON format. 
      STRICT JSON format only: 
      {
        "question": "...",
        "options": ["...", "...", "...", "..."],
        "answer": <index>
      }. 
      Do NOT include explanations or extra text. and in language should be $language
      """;

    try {
      final response = await _model.generateContent([Content.text(prompt)]).timeout(Duration(seconds: 20));

      if (response.text != null) {
        final jsonText = _extractJson(response.text!);
        final parsedResponse = _parseResponse(jsonText);

        if (_categoryQuestions[category]!.contains(parsedResponse['question'])) {
          log("Duplicate question detected for $category. Regenerating...");
          await generateQuestion(category, language);
          return;
        }

        _categoryQuestions[category]!.add(parsedResponse['question']);

        question = parsedResponse['question'];
        options = parsedResponse['options'];
        correctAnswer = parsedResponse['answer'];
        correctIndex = options.indexOf(correctAnswer!);
        totalQuestions++;
        isLoading = false;
      } else {
        throw Exception("Response text is null");
      }
    } catch (e) {
      log("Error: $e");
      hasError = true;

      if (e.toString().contains("503")) {
        errorMessage = "Server is overloaded. Please try again later.";
      } else {
        errorMessage = "Failed to load question. Please check your connection.";
      }

      question = errorMessage;
      options = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void checkAnswer(int selectedIndex) {
    if (selectedAnswer != null) return;

    selectedAnswer = selectedIndex;

    if (selectedIndex == correctIndex) {
      correctAnswers++;
    }

    notifyListeners();
  }

  String _extractJson(String responseText) {
    try {
      responseText = responseText.trim();
      int startIndex = responseText.indexOf('{');
      int endIndex = responseText.lastIndexOf('}');

      if (startIndex != -1 && endIndex != -1) {
        return responseText.substring(startIndex, endIndex + 1);
      } else {
        throw FormatException("No JSON found in response");
      }
    } catch (e) {
      log("Error extracting JSON: $e");
      return '{}';
    }
  }

  Map<String, dynamic> _parseResponse(String responseText) {
    try {
      final Map<String, dynamic> parsed = jsonDecode(responseText);

      List<String> optionsList = List<String>.from(parsed['options'] ?? ["Option 1", "Option 2", "Option 3", "Option 4"]);
      int answerIndex = parsed['answer'] ?? 0;

      if (answerIndex < 0 || answerIndex >= optionsList.length) {
        answerIndex = 0;
      }

      return {
        'question': parsed['question'] ?? "Question not found",
        'options': optionsList,
        'answer': optionsList[answerIndex]
      };
    } catch (e) {
      log("Error parsing JSON: $e");
      return {
        'question': "Failed to parse question",
        'options': ["Option 1", "Option 2", "Option 3", "Option 4"],
        'answer': "Option 1"
      };
    }
  }
}
