// 北極星（Hokyoksei）基本ウィジェットテスト
// M0: Hello World 表示確認

import 'package:flutter_test/flutter_test.dart';

import 'package:dangi_app/main.dart';

void main() {
  testWidgets('DangiApp smoke test', (WidgetTester tester) async {
    // アプリをビルドしてフレームをトリガー
    await tester.pumpWidget(const DangiApp());

    // アプリタイトルが表示されることを確認
    expect(find.text('北極星（Hokyoksei）'), findsOneWidget);

    // Hello World メッセージが表示されることを確認
    expect(find.text('M0: 骨組み確認用 Hello World'), findsOneWidget);
  });
}
