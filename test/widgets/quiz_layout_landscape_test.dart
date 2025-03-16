import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_engine/src/quiz/quiz_answers_widget.dart';
import 'package:quiz_engine/src/quiz/quiz_image_widget.dart';
import 'package:quiz_engine/src/quiz/quiz_layout.dart';
import 'package:quiz_engine_core/quiz_engine_core.dart';
import 'package:responsive_builder/responsive_builder.dart';

void main() {

  group('GameLayout', () {
    QuestionEntry mockCountry = QuestionEntry(
        type: TextQuestion("Test"), otherOptions: {"id": "123", "image": "assets/images/AD.png"});
    QuestionState mockQuestionState =
    QuestionState(Question(mockCountry, [mockCountry]), 1, 1);

    testWidgets('displays correctly in landscape orientation',
            (WidgetTester tester) async {
          final sizingInformation = SizingInformation(
            deviceScreenType: DeviceScreenType.mobile,
            refinedSize: RefinedSize.normal,
            screenSize: Size(800, 600),
            localWidgetSize: Size(800, 600),
          );

          await tester.pumpWidget(MaterialApp(
            home: QuizLayout(
              questionState: mockQuestionState,
              information: sizingInformation,
              processAnswer: (_) {},
            ),
          ));

          await tester.pumpAndSettle();

          expect(find.byType(Row), findsOneWidget);
          expect(find.byType(QuizImageWidget), findsOneWidget);
          expect(find.byType(QuizAnswersWidget), findsOneWidget);
        });
  });
}