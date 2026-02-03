import 'package:test/test.dart';
import 'package:shared_core/shared_core.dart';

void main() {
  group('SessionMachine', () {
    group('エラー遷移（M1-B3）', () {
      test('error 状態へ遷移できる', () {
        final machine = SessionMachine();
        machine.transition(SessionEvent.appStarted);
        machine.transition(SessionEvent.themeSubmitted);

        // エラー発生
        final errorCtx = ErrorContext(message: 'テストエラー');
        machine.transition(SessionEvent.errorOccurred, errorContext: errorCtx);

        expect(machine.current, SessionState.error);
        expect(machine.errorContext?.message, 'テストエラー');
        expect(machine.previousState, SessionState.themeInput);
      });

      test('error から recovered で前の状態に戻る', () {
        final machine = SessionMachine();
        machine.transition(SessionEvent.appStarted);
        machine.transition(SessionEvent.themeSubmitted);
        machine.transition(SessionEvent.errorOccurred,
            errorContext: ErrorContext(message: 'テストエラー'));

        // リカバリー
        machine.transition(SessionEvent.recovered);

        expect(machine.current, SessionState.themeInput);
        expect(machine.errorContext, null);
        expect(machine.previousState, null);
      });

      test('error から sessionEnded で idle に戻る', () {
        final machine = SessionMachine();
        machine.transition(SessionEvent.appStarted);
        machine.transition(SessionEvent.themeSubmitted);
        machine.transition(SessionEvent.errorOccurred,
            errorContext: ErrorContext(message: 'テストエラー'));

        // 中断
        machine.transition(SessionEvent.sessionEnded);

        expect(machine.current, SessionState.idle);
        expect(machine.errorContext, null);
        expect(machine.previousState, null);
      });

      test('前の状態がない場合は idle に戻る', () {
        final machine = SessionMachine();
        machine.transition(SessionEvent.appStarted);
        machine.transition(SessionEvent.errorOccurred,
            errorContext: ErrorContext(message: 'テストエラー'));

        // リカバリー（前の状態がない → idle へ）
        machine.transition(SessionEvent.recovered);

        expect(machine.current, SessionState.idle);
        expect(machine.errorContext, null);
      });

      test('エラーコンテキストに詳細情報を含められる', () {
        final machine = SessionMachine();
        machine.transition(SessionEvent.appStarted);

        final errorCtx = ErrorContext(
          message: 'データベースエラー',
          details: 'connection timeout after 30 seconds',
        );
        machine.transition(SessionEvent.errorOccurred, errorContext: errorCtx);

        expect(machine.errorContext?.message, 'データベースエラー');
        expect(machine.errorContext?.details,
            'connection timeout after 30 seconds');
      });
    });
  });
}
