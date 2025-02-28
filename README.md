# UPSC Quiz App

## Overview
The **UPSC Quiz App** is a Flutter-based quiz application designed to help aspirants prepare for the UPSC exam. The app dynamically generates multiple-choice questions using an AI-based content generation model and allows users to select different categories to test their knowledge.

## Features
- **Dynamic Question Generation**: Uses AI to generate fresh and non-repetitive quiz questions.
- **Category Selection**: Users can choose different categories for their quiz.
- **Animated Answer Feedback**: Displays visual feedback for correct and incorrect answers.
- **Progress Tracking**: Keeps track of correct answers and total questions attempted.
- **Results Page**: Shows a summary of quiz performance.
- **Multilingual Support**: Allows users to switch languages for quiz questions.
- **Offline Cache Management**: Prevents repeated questions within a session.

---

## Folder Structure
```
lib/
│── Models/
│   ├── quiz_view_model.dart
│── Providers/
│   ├── language_provider.dart
│── Screens/
│   ├── category_screen.dart
│   ├── quiz_screen.dart
│   ├── result_screen.dart
│   ├── start_screen.dart
│── main.dart
```
- **Models**: Contains `quiz_view_model.dart`, responsible for managing quiz logic.
- **Providers**: Includes `language_provider.dart` to handle language selection.
- **Screens**: Contains different UI screens (category, quiz, result, start page).
- **main.dart**: Entry point of the Flutter application.

---

## Dependencies
To run this application, install the following dependencies:
```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.0.5
  google_fonts: ^4.0.4
  lucide_icons: ^0.224.0
  google_generative_ai: ^0.1.5
```

---

## How It Works

### 1. **Start Screen (`start_screen.dart`)**
- Displays the quiz instructions.
- Users can proceed to the category selection screen.

### 2. **Category Screen (`category_screen.dart`)**
- Fetches available categories from `LanguageProvider`.
- Allows users to select a category and start a quiz.

### 3. **Quiz Screen (`quiz_screen.dart`)**
- Loads questions dynamically using `QuizViewModel`.
- Displays multiple-choice questions with answer selection.
- Provides visual feedback for correct/incorrect answers.
- Users can navigate to the next question or stop the quiz.

### 4. **Results Screen (`result_screen.dart`)**
- Displays a progress summary after quiz completion.
- Shows total questions answered correctly.

---

## Backend Logic (`quiz_view_model.dart`)
- Uses `google_generative_ai` to generate questions dynamically.
- Ensures no question is repeated within the same session.
- Formats the API response into structured JSON for the app.

#### Example Prompt for AI Model:
```json
{
  "question": "What is the capital of India?",
  "options": ["Mumbai", "Delhi", "Kolkata", "Chennai"],
  "answer": 1
}
```

#### Error Handling:
- If an API call fails, displays a retry option.
- Detects duplicate questions and regenerates them.

---

## How to Run the Project
1. Clone the repository:
   ```sh
   git clone https://github.com/your-repo/upsc_quiz_app.git
   ```
2. Navigate to the project directory:
   ```sh
   cd upsc_quiz_app
   ```
3. Install dependencies:
   ```sh
   flutter pub get
   ```
4. Run the application:
   ```sh
   flutter run
   ```

---

## Future Enhancements
- Add a **Leaderboard** to track user performance.
- Implement **Timed Quizzes**.
- Support **Offline Mode** with local question storage.
- Improve UI with more animations and themes.

---

## License
This project is open-source and free to use.

### Contributors
- **Your Name** - Developer & Maintainer

For issues or feature requests, please open an issue on GitHub.

---

### Screenshots
(Add screenshots here for better visualization)

