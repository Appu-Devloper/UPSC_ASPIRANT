import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart'; // For modern icons
import 'package:upsc_aspirant/Screens/result_screen.dart';
import '../Models/quiz_view_model.dart';
import '../Providers/language_provider.dart';

class QuizScreen extends StatelessWidget {
  final String category;

  QuizScreen({required this.category});

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    return ChangeNotifierProvider(
      create: (_) => QuizViewModel()..generateQuestion(category, languageProvider.currentLanguage),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: (){Navigator.pop(context);},
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          ),
          backgroundColor: Colors.deepPurple,
          title: Text(
            'Quiz - $category',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: Consumer<QuizViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Colors.deepPurple),
                    SizedBox(height: 20),
                    Text("Fetching question...", style: GoogleFonts.poppins(fontSize: 16)),
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
                      style: GoogleFonts.poppins(fontSize: 18, color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 15),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () => viewModel.generateQuestion(category, languageProvider.currentLanguage),
                      child: Text("Retry", style: GoogleFonts.poppins(fontSize: 16, color: Colors.white)),
                    ),
                  ],
                ),
              );
            }

            return Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF4A148C), Color(0xFF7B1FA2)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Question Box
                          Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            elevation: 5,
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Text(
                                viewModel.question,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),

                          // Animated Answer Options
                          ...viewModel.options.asMap().entries.map((entry) {
                            int index = entry.key;
                            String option = entry.value;

                            Color buttonColor = Colors.white;
                            if (viewModel.selectedAnswer != null) {
                              if (index == viewModel.correctIndex) {
                                buttonColor = Colors.greenAccent; // Correct answer
                              } else if (index == viewModel.selectedAnswer) {
                                buttonColor = Colors.redAccent; // Wrong answer
                              }
                            }

                            return AnimatedContainer(
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                              margin: EdgeInsets.symmetric(vertical: 8),
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: buttonColor,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(color: Colors.black26, blurRadius: 5, offset: Offset(2, 3)),
                                ],
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  if (viewModel.selectedAnswer == null) {
                                    viewModel.checkAnswer(index);
                                  }
                                },
                                child: Text(
                                  option,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black),
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),

                  // Bottom Controls (Next & Stop)
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                      boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5, offset: Offset(0, -3))],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Stop Button
                        IconButton(
                          icon: Icon(LucideIcons.stopCircle, color: Colors.red, size: 40),
                          onPressed: () {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ResultsPage(category: "",answered: viewModel.correctAnswers, total: viewModel.totalQuestions,)));
                          },
                        ),

                        // Score Display
                        Text(
                          "${viewModel.correctAnswers} / ${viewModel.totalQuestions}",
                          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
                        ),

                        // Next Button
                        IconButton(
                          icon: Icon(LucideIcons.arrowRightCircle, color: Colors.blue, size: 40),
                          onPressed: () => viewModel.generateQuestion(category, languageProvider.currentLanguage),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
