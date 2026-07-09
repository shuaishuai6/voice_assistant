import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voice_assistant/app/visit_notes_app.dart';

void main() {
  testWidgets('app renders the recording entry screen', (tester) async {
    await tester.pumpWidget(const VisitNotesApp());

    expect(find.text('诊断备忘录'), findsOneWidget);
    expect(find.text('开始记录'), findsOneWidget);
    expect(find.text('今日已处理 12 份病历录音'), findsOneWidget);
    expect(find.text('SYSTEM READY'), findsOneWidget);
    expect(_assetImage('assets/images/node-id=2-826-1.png'), findsOneWidget);
    expect(_assetImage('assets/images/node-id=2-832-2.png'), findsOneWidget);
  });

  testWidgets('records tab opens list and first record opens detail', (
    tester,
  ) async {
    await tester.pumpWidget(const VisitNotesApp());

    await tester.tap(find.text('记录'));
    await tester.pumpAndSettle();

    expect(find.text('最近录入'), findsOneWidget);
    expect(find.text('皮肤过敏'), findsOneWidget);
    expect(_assetImage('assets/images/node-id=2-826-2.png'), findsOneWidget);
    expect(_assetImage('assets/images/node-id=2-832-1.png'), findsWidgets);

    await tester.tap(find.text('查看详情').first);
    await tester.pumpAndSettle();

    expect(find.text('2026年1月23日 周五'), findsOneWidget);
    expect(find.text('对话记录'), findsOneWidget);
    expect(find.text('AI 总结'), findsOneWidget);
    expect(find.text('医生 (Speaker A)'), findsWidgets);
  });
}

Finder _assetImage(String assetName) {
  return find.byWidgetPredicate((widget) {
    final image = widget is Image ? widget.image : null;
    return image is AssetImage && image.assetName == assetName;
  });
}
