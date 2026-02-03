// セッション状態マシン（08_ARCHITECTURE.md 準拠）
// PC/モバイルで同一挙動（00_PARITY_CONTRACT.md）

import 'session_state.dart';
import 'session_event.dart';
import 'error_context.dart';

/// 不正な状態遷移が発生した場合の例外
class InvalidTransitionException implements Exception {
  const InvalidTransitionException({
    required this.from,
    required this.event,
  });

  final SessionState from;
  final SessionEvent event;

  @override
  String toString() =>
      '不正な状態遷移: ${from.displayName} で ${event.displayName} は許可されていません';
}

/// セッション状態マシン
///
/// Session Lifecycle の状態遷移を管理する。
/// - 現在の状態を保持
/// - イベントに基づいて次の状態へ遷移
/// - 不正な遷移を検出・拒否
///
/// **重要**: このクラスは Windows/iOS で共通。
/// OS 固有のロジックを入れないこと（00_PARITY_CONTRACT.md）。
class SessionMachine {
  SessionMachine() : _current = SessionState.boot;

  SessionState _current;

  /// エラー発生前の状態（リカバリー用）
  SessionState? _previousState;

  /// エラーコンテキスト（M1-B3で追加）
  ErrorContext? _errorContext;

  /// 現在の状態
  SessionState get current => _current;

  /// エラー発生前の状態（リカバリー先）
  SessionState? get previousState => _previousState;

  /// 現在のエラーコンテキスト（M1-B3で追加）
  ErrorContext? get errorContext => _errorContext;

  /// イベントを処理して次の状態へ遷移
  ///
  /// [event]: 発生したイベント
  /// [errorContext]: エラーコンテキスト（errorOccurred の場合のみ）
  /// 返り値: 遷移後の状態
  ///
  /// 不正な遷移の場合は [InvalidTransitionException] を throw
  SessionState transition(SessionEvent event, {ErrorContext? errorContext}) {
    final next = _getNextState(_current, event);
    if (next == null) {
      throw InvalidTransitionException(from: _current, event: event);
    }

    // エラー遷移の場合、前の状態とエラー情報を保存
    if (event == SessionEvent.errorOccurred) {
      _previousState = _current;
      _errorContext = errorContext;
    }

    // リカバリーまたは中断の場合、前の状態とエラー情報をクリア
    if (event == SessionEvent.recovered ||
        (event == SessionEvent.sessionEnded && _current == SessionState.error)) {
      _previousState = null;
      _errorContext = null;
    }

    _current = next;
    return _current;
  }

  /// 遷移が可能かどうかを確認（throw しない）
  bool canTransition(SessionEvent event) {
    return _getNextState(_current, event) != null;
  }

  /// 状態をリセット（テスト・デバッグ用）
  void reset() {
    _current = SessionState.boot;
    _previousState = null;
  }

  /// 遷移マップに基づいて次の状態を取得
  ///
  /// 返り値: 次の状態、または null（不正遷移）
  SessionState? _getNextState(SessionState from, SessionEvent event) {
    // エラー発生は任意の状態から可能
    if (event == SessionEvent.errorOccurred) {
      return SessionState.error;
    }

    // リカバリーは error 状態からのみ
    if (event == SessionEvent.recovered) {
      if (from == SessionState.error) {
        // 前の状態があればそこへ、なければ idle へ
        return _previousState ?? SessionState.idle;
      }
      return null;
    }

    // 状態遷移マップ
    switch (from) {
      case SessionState.boot:
        if (event == SessionEvent.appStarted) return SessionState.idle;
        break;

      case SessionState.idle:
        if (event == SessionEvent.themeSubmitted) return SessionState.themeInput;
        break;

      case SessionState.themeInput:
        if (event == SessionEvent.themeSubmitted) {
          return SessionState.personaSelect;
        }
        break;

      case SessionState.personaSelect:
        if (event == SessionEvent.personasSelected) return SessionState.ignition;
        break;

      case SessionState.ignition:
        if (event == SessionEvent.sessionStarted) return SessionState.discussion;
        break;

      case SessionState.discussion:
        if (event == SessionEvent.turnCompleted) return SessionState.discussion;
        if (event == SessionEvent.conclusionTriggered) {
          return SessionState.convergence;
        }
        break;

      case SessionState.convergence:
        if (event == SessionEvent.crystalGenerated) {
          return SessionState.crystallization;
        }
        break;

      case SessionState.crystallization:
        if (event == SessionEvent.sessionEnded) return SessionState.dissolution;
        break;

      case SessionState.dissolution:
        if (event == SessionEvent.sessionEnded) return SessionState.idle;
        break;

      case SessionState.error:
        // M1-B3: error 状態からの遷移追加
        if (event == SessionEvent.sessionEnded) return SessionState.idle;
        // recovered イベントは上で処理済み
        break;
    }

    return null; // 不正遷移
  }
}
