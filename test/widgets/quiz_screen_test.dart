import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:quiz_engine/quiz_engine.dart';
import 'package:quiz_engine/src/quiz/quiz_screen.dart';
import 'package:quiz_engine_core/quiz_engine_core.dart';

@GenerateNiceMocks([MockSpec<RandomItemPicker>()])
import 'quiz_screen_test.mocks.dart';

void main() {
  late RandomItemPicker randomItemPicker;
  late QuizBloc bloc;

  Future<List<QuestionEntry>> loadCountriesForContinent() async {
    return [
      QuestionEntry(
        type: TextQuestion("Test"),
        otherOptions: {"id": "123", "image": "231"},
      ),
      QuestionEntry(
        type: TextQuestion("Tes2t"),
        otherOptions: {"id": "1223", "image": "2231"},
      ),
    ];
  }

  setUp(() {
    randomItemPicker = MockRandomItemPicker();
    bloc = QuizBloc(() => loadCountriesForContinent(), randomItemPicker);
  });

  testWidgets('Question showing', (WidgetTester tester) async {
    // Given
    final country1 = QuestionEntry(
      type: TextQuestion("Te22st"),
      otherOptions: {"id": "12223", "image": "assets/images/AD.png"},
    );
    final country2 = QuestionEntry(
      type: TextQuestion("Test"),
      otherOptions: {"id": "12223", "image": "assets/images/AD.png"},
    );
    final countries = [country1, country2];
    final randomPickResult = RandomPickResult(countries.first, countries);
    // When
    when(randomItemPicker.pick()).thenReturn(randomPickResult);
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider(
          bloc: bloc,
          child: QuizScreen(title: "Test", gameOverTitle: "Game Over"),
        ),
      ),
    );
    await tester.pump();
    await tester.pump();
    // Then
    final optionButtonFinder = find.byType(OptionButton);
    final imageFinder = find.byType(Image);
    expect(optionButtonFinder, findsNWidgets(countries.length));
    expect(imageFinder, findsOneWidget);
  });

  testWidgets('Quiz over dialog', (WidgetTester tester) async {
    // Given
    final countries = [
      QuestionEntry(
        type: TextQuestion("Test"),
        otherOptions: {"id": "123", "image": "assets/images/AD.png"},
      ),
      QuestionEntry(
        type: TextQuestion("Tes2t"),
        otherOptions: {"id": "1223", "image": "assets/images/AD.png"},
      ),
    ];
    final bloc2 = QuizBloc(() => Future.value(countries), randomItemPicker);
    bloc2.currentQuestion = Question(countries.first, countries);
    // When
    when(randomItemPicker.pick()).thenReturn(null);
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider(
          bloc: bloc2,
          child: QuizScreen(title: "Test", gameOverTitle: "Game Over"),
        ),
      ),
    );
    await tester.pump();
    await tester.pump();
    // Then
    // Wait for game over dialog
    final alertDialogFinder = find.byType(AlertDialog);
    expect(alertDialogFinder, findsOneWidget);
    // Tap alert button
    final alertButtonFinder = find.byType(TextButton);
    expect(alertButtonFinder, findsOneWidget);
    await tester.tap(alertButtonFinder);
    await tester.pump();
    // Check that alert disappear
    final alertDisappearFinder = find.byType(AlertDialog);
    expect(alertDisappearFinder, findsNothing);
  });
}
