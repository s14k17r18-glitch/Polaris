// セッション状態定義（02_PRODUCT_FLOW.md 準拠）
// PC/モバイルで同一挙動（00_PARITY_CONTRACT.md）

/// セッションの状態
///
/// Session Lifecycle に基づく状態遷移:
/// - Phase 1 (Ritual): boot → idle → themeInput → personaSelect → ignition
/// - Phase 2 (Council): discussion（ループ）
/// - Phase 3 (Ending): convergence → crystallization → dissolution
enum SessionState {
  /// 起動中（アプリ起動直後）
  boot,

  /// 待機中（セッションなし）
  idle,

  /// テーマ入力中
  themeInput,

  /// ペルソナ選択中
  personaSelect,

  /// セッション開始アニメーション中（Genesis Sequence）
  ignition,

  /// 議論中（メインループ）
  discussion,

  /// 結論収束中
  convergence,

  /// クリスタル生成中
  crystallization,

  /// 解散中
  dissolution,

  /// エラー状態（リカバリー可能）
  error,
}

/// SessionState の拡張メソッド
extension SessionStateExtension on SessionState {
  /// 日本語の表示名を取得
  ///
  /// **注意**: ユーザー可視の文言は l10n_ja から取得すべき。
  /// これはデバッグ・ログ用の内部表示名。
  String get displayName {
    switch (this) {
      case SessionState.boot:
        return '起動中';
      case SessionState.idle:
        return '待機中';
      case SessionState.themeInput:
        return 'テーマ入力中';
      case SessionState.personaSelect:
        return 'ペルソナ選択中';
      case SessionState.ignition:
        return 'セッション開始中';
      case SessionState.discussion:
        return '議論中';
      case SessionState.convergence:
        return '結論収束中';
      case SessionState.crystallization:
        return 'クリスタル生成中';
      case SessionState.dissolution:
        return '解散中';
      case SessionState.error:
        return 'エラー';
    }
  }

  /// セッションがアクティブかどうか
  ///
  /// ignition 〜 dissolution の間は true
  bool get isSessionActive {
    switch (this) {
      case SessionState.ignition:
      case SessionState.discussion:
      case SessionState.convergence:
      case SessionState.crystallization:
      case SessionState.dissolution:
        return true;
      default:
        return false;
    }
  }

  /// ユーザー入力を受け付ける状態かどうか
  bool get acceptsUserInput {
    switch (this) {
      case SessionState.idle:
      case SessionState.themeInput:
      case SessionState.personaSelect:
      case SessionState.discussion:
        return true;
      default:
        return false;
    }
  }
}
