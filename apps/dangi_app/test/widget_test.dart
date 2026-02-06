// Polaris基本ウィジェットテスト
// M0-B2: 状態遷移と画面切り替えの確認

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:dangi_app/main.dart';

void main() {
  testWidgets('DangiApp 状態遷移テスト', (WidgetTester tester) async {
    // M3-F1: AuthRepository 用モック設定
    SharedPreferences.setMockInitialValues({});
    // アプリをビルド
    await tester.pumpWidget(const DangiApp());

    // 初期状態: BOOT（起動中）
    expect(find.text('Polaris'), findsOneWidget);
    expect(find.text('起動中...'), findsOneWidget);

    // postFrameCallback で IDLE へ遷移
    await tester.pumpAndSettle();

    // IDLE 状態: 待機中画面
    expect(find.text('Polaris'), findsOneWidget);
    expect(find.text('待機中'), findsOneWidget);
    expect(find.text('開始'), findsOneWidget);

    // 「開始」ボタンをタップ → THEME_INPUT へ遷移
    await tester.tap(find.text('開始'));
    await tester.pumpAndSettle();

    // THEME_INPUT 状態: テーマ入力画面
    expect(find.text('テーマ入力'), findsOneWidget);
    expect(find.text('次へ'), findsOneWidget);
  });
}
