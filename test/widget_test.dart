import 'package:flutter_test/flutter_test.dart';
import 'package:voice_assistant/app/visit_notes_app.dart';

void main() {
  testWidgets('app renders the recording entry screen', (tester) async {
    await tester.pumpWidget(const VisitNotesApp());

    expect(find.text('医嘱备忘'), findsOneWidget);
    expect(find.text('开始录音'), findsOneWidget);
    expect(find.textContaining('本 App 仅供个人记录'), findsOneWidget);
  });
}
