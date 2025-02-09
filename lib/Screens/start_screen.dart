
import 'package:flutter/material.dart';

class StartScreen extends StatelessWidget {
  late final String Category;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('UPSC Quiz Instructions')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to the UPSC Quiz!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Instructions:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              '- You will be presented with multiple-choice questions one by one.',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              '- Tap "Next" to move to the next question.',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              '- Tap "Stop" anytime to view your results.',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              '- There is a "Show Answer" button to reveal the AI-generated answer.',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              '- AI-generated answers may not always be accurate.',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red),
            ),
            SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                child: Text('Start Quiz'),
                onPressed: () {
                  // Navigate to quiz screen
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
