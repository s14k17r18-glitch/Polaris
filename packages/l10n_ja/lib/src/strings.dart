/// 日本語文言（完全日本語固定）
/// **英語直書き禁止**（00_PARITY_CONTRACT.md）
class L10nJa {
  L10nJa._(); // インスタンス化禁止

  // アプリ基本
  static const String appTitle = '北極星（Hokyoksei）';
  static const String helloWorld = 'M0: 骨組み確認用 Hello World';

  // 状態表示（B2 で追加）
  static const String stateBooting = '起動中...';
  static const String stateIdle = '待機中';
  static const String stateThemeInput = 'テーマ入力';
  static const String statePersonaSelect = 'ペルソナ選択';
  static const String stateNotImplemented = '実装予定';

  // 状態表示（M1-D2 で追加）
  static const String stateIgnition = 'セッション開始';
  static const String stateDiscussion = '議論中';

  // 状態表示（M1-D4 で追加）
  static const String stateConvergence = '結晶化';

  // 状態表示（M1-B3 で追加）
  static const String stateError = 'エラー';

  // ボタン（B2 で追加）
  static const String buttonStart = '開始';
  static const String buttonNext = '次へ';

  // ボタン（M1-D2 で追加）
  static const String buttonNextTurn = '次の発言';
  static const String buttonConclusion = '結論へ';

  // ボタン（M1-D4 で追加）
  static const String buttonToHistory = '履歴へ';

  // ボタン（M1-B3 で追加）
  static const String buttonRetry = '再試行';
  static const String buttonAbort = '中断';
  static const String buttonResume = '再開';

  // 状態説明（B2 で追加）
  static const String descIdle = 'セッションを開始するには「開始」をタップしてください';
  static const String descThemeInput = 'テーマを入力してください（M1で実装）';
  static const String descNotImplemented = 'この画面は M1 以降で実装予定です';

  // 状態説明（M1-D2 で追加）
  static const String descDiscussion = '談議が進行中です。「次の発言」で議論を続けます。';

  // 状態説明（M1-D4 で追加）
  static const String descConvergence = '談議が結晶化されました。以下の内容をご確認ください。';

  // Crystal 項目ラベル（M1-D4 で追加）
  static const String labelCrystalTitle = 'タイトル';
  static const String labelCrystalTheme = 'テーマ';
  static const String labelCrystalSummary = '要約';
  static const String labelCrystalParticipants = '参加者';

  // ペルソナ（M1-D3 で追加）
  static const String moderatorName = '司会';

  // エラーメッセージ（M1-B3 で追加）
  static const String errorGeneric = 'エラーが発生しました';
  static const String errorRecoveryHint = '再試行するか、セッションを中断できます';

  // M1以降で追加
  // static const String errorNetwork = 'ネットワークエラーが発生しました';
}
