import 'package:flutter_test/flutter_test.dart';
import 'package:voice_assistant/app/visit_notes_app.dart';

void main() {
  testWidgets('app renders the recording entry screen', (tester) async {
    await tester.pumpWidget(const VisitNotesApp());

    expect(find.text('诊断备忘录'), findsOneWidget);
    expect(find.text('开始记录'), findsOneWidget);
    expect(find.text('今日已处理 12 份病历录音'), findsOneWidget);
    expect(find.text('SYSTEM READY'), findsOneWidget);
  });
}
