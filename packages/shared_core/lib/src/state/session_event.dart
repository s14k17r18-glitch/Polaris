// セッションイベント定義（02_PRODUCT_FLOW.md 準拠）
// PC/モバイルで同一挙動（00_PARITY_CONTRACT.md）

/// セッションの遷移イベント
///
/// 状態遷移をトリガーするイベント。
/// UI 層からのアクションや、Engine からの通知を表す。
enum SessionEvent {
  /// アプリ起動完了
  ///
  /// boot → idle への遷移をトリガー
  appStarted,

  /// テーマ確定
  ///
  /// idle → themeInput、または themeInput → personaSelect への遷移
  themeSubmitted,

  /// ペルソナ選択完了
  ///
  /// personaSelect → ignition への遷移
  personasSelected,

  /// セッション開始（Ignition 完了）
  ///
  /// ignition → discussion への遷移
  sessionStarted,

  /// ターン完了（議論継続）
  ///
  /// discussion → discussion のループ
  turnCompleted,

  /// 結論トリガー（ユーザーまたはモデレーター）
  ///
  /// discussion → convergence への遷移
  conclusionTriggered,

  /// クリスタル生成完了
  ///
  /// convergence → crystallization への遷移
  crystalGenerated,

  /// セッション終了
  ///
  /// crystallization → dissolution、または dissolution → idle への遷移
  sessionEnded,

  /// エラー発生
  ///
  /// 任意の状態 → error への遷移
  errorOccurred,

  /// リカバリー完了
  ///
  /// error → 前の状態（またはsafe state）への遷移
  recovered,
}

/// SessionEvent の拡張メソッド
extension SessionEventExtension on SessionEvent {
  /// 日本語の表示名を取得
  ///
  /// **注意**: ユーザー可視の文言は l10n_ja から取得すべき。
  /// これはデバッグ・ログ用の内部表示名。
  String get displayName {
    switch (this) {
      case SessionEvent.appStarted:
        return 'アプリ起動完了';
      case SessionEvent.themeSubmitted:
        return 'テーマ確定';
      case SessionEvent.personasSelected:
        return 'ペルソナ選択完了';
      case SessionEvent.sessionStarted:
        return 'セッション開始';
      case SessionEvent.turnCompleted:
        return 'ターン完了';
      case SessionEvent.conclusionTriggered:
        return '結論トリガー';
      case SessionEvent.crystalGenerated:
        return 'クリスタル生成完了';
      case SessionEvent.sessionEnded:
        return 'セッション終了';
      case SessionEvent.errorOccurred:
        return 'エラー発生';
      case SessionEvent.recovered:
        return 'リカバリー完了';
    }
  }

  /// ユーザーアクション由来かどうか
  bool get isUserAction {
    switch (this) {
      case SessionEvent.themeSubmitted:
      case SessionEvent.personasSelected:
      case SessionEvent.conclusionTriggered:
        return true;
      default:
        return false;
    }
  }

  /// システムイベント由来かどうか
  bool get isSystemEvent {
    switch (this) {
      case SessionEvent.appStarted:
      case SessionEvent.sessionStarted:
      case SessionEvent.turnCompleted:
      case SessionEvent.crystalGenerated:
      case SessionEvent.sessionEnded:
      case SessionEvent.errorOccurred:
      case SessionEvent.recovered:
        return true;
      default:
        return false;
    }
  }
}
