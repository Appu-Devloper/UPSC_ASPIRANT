import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart'; // For icons
import '../Models/quiz_view_model.dart';
import '../Providers/language_provider.dart';

class QuizScreen extends StatelessWidget {
  final String category;

  QuizScreen({required this.category});

  @override
  Widget build(BuildContext context) {
       final languageProvider = Provider.of<LanguageProvider>(context);
    return ChangeNotifierProvider(
      create: (_) => QuizViewModel()..generateQuestion(category,languageProvider.currentLanguage),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Quiz - $category',
            style: GoogleFonts.lora(fontWeight: FontWeight.bold),
          ),
        ),
        body: Consumer<QuizViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 20),
                    Text(
                      "Fetching question...",
                      style: GoogleFonts.lora(fontSize: 16),
                    ),
                  ],
                ),
              );
            }
if (viewModel.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      viewModel.errorMessage,
                      style: GoogleFonts.lora(fontSize: 18, color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () => viewModel.generateQuestion(category,languageProvider.currentLanguage),
                      child: Text("Retry", style: GoogleFonts.lora()),
                    ),
                  ],
                ),
              );
            }

            return Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          viewModel.question,
                          style: GoogleFonts.lora(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 20),
                        ...viewModel.options.asMap().entries.map((entry) {
                          int index = entry.key;
                          String option = entry.value;

                          Color buttonColor = Colors.white; // Default color
                          if (viewModel.selectedAnswer != null) {
                            if (index == viewModel.correctIndex) {
                              buttonColor = Colors.green; // Correct answer (always green)
                            } else if (index == viewModel.selectedAnswer) {
                              buttonColor = Colors.red; // Wrong answer (red)
                            }
                          }

                          return GestureDetector(
                            onTap: () {
                              if (viewModel.selectedAnswer == null) {
                                viewModel.checkAnswer(index);
                              }
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 8),
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: buttonColor,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.black, width: 2),
                              ),
                              child: Text(
                                option,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.lora(fontSize: 18,fontWeight: FontWeight.w600),
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
                Container(
                  color: Colors.grey[200],
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Stop Button
                      IconButton(
                        icon: Icon(LucideIcons.stopCircle, color: Colors.red, size: 40),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),

                      // Score Display
                      Text(
                        "${viewModel.correctAnswers} / ${viewModel.totalQuestions}",
                        style: GoogleFonts.lora(fontSize: 18, fontWeight: FontWeight.bold),
                      ),

                      // Next Button
                      IconButton(
                        icon: Icon(LucideIcons.arrowRightCircle, color: Colors.blue, size: 40),
                        onPressed: () => viewModel.generateQuestion(category,languageProvider.currentLanguage),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
