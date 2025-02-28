import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ResultsPage extends StatefulWidget {
  final String category;
  final int total;
  final int answered;

  const ResultsPage({super.key, required this.category, required this.total, required this.answered});
  
  @override
  _ResultsPageState createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> with SingleTickerProviderStateMixin {
   int totalQuestions = 0;
   int totalAnswered = 0;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    totalQuestions = widget.total;
    totalAnswered = widget.answered;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..forward();
    
    _animation = Tween<double>(begin: 0, end: totalAnswered / totalQuestions).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  String getFeedbackText(double percentage) {
    if (percentage == 1.0) {
      return "🎉 Excellent! You answered all questions!";
    } else if (percentage >= 0.7) {
      return "👍 Great job! Keep it up!";
    } else if (percentage >= 0.5) {
      return "🙂 Good effort! Try improving!";
    } else {
      return "😕 Keep practicing! You can do better!";
    }
  }

  @override
  Widget build(BuildContext context) {
    double percentage = totalAnswered / totalQuestions;
    
    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF4A00E0), Color(0xFF8E2DE2)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // Close Button at the Top Right
          Positioned(
            top: 40, // Adjust for status bar padding
            right: 20,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(Icons.close, size: 30, color: Colors.white),
            ),
          ),

          // Main Content
          Center(
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              color: Colors.white.withOpacity(0.95), // Adjusted for better contrast
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 25),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Results Summary",
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Circular Progress with Animation
                    AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 150,
                              height: 150,
                              child: CircularProgressIndicator(
                                value: _animation.value,
                                strokeWidth: 12,
                                backgroundColor: Colors.grey.withOpacity(0.2),
                                valueColor: const AlwaysStoppedAnimation<Color>(Colors.greenAccent),
                              ),
                            ),
                            Column(
                              children: [
                                Text(
                                  "${(_animation.value * 100).toInt()}%",
                                  style: GoogleFonts.poppins(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  "$totalAnswered / $totalQuestions",
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),

                    const SizedBox(height: 20),

                    // Feedback Text
                    Text(
                      getFeedbackText(percentage),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
