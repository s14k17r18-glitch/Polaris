// 要約＋Crystal生成（M1-D4：スタブ実装）

import '../persona/persona_definition.dart';

/// Crystal Draft（結晶化草稿）
///
/// MVP では最小項目のみ。M2 以降で詳細項目を追加。
class CrystalDraft {
  const CrystalDraft({
    required this.title,
    required this.theme,
    required this.summary,
    required this.participants,
    required this.createdAt,
  });

  /// タイトル（自動生成）
  final String title;

  /// テーマ
  final String theme;

  /// 要約
  final String summary;

  /// 参加者リスト
  final List<PersonaDefinition> participants;

  /// 生成日時
  final DateTime createdAt;
}

/// 要約＋Crystal生成エンジン（最小実装）
///
/// MVP ではスタブ実装。M2 以降で実 LLM 接続に置き換え。
class SummaryCrystal {
  SummaryCrystal._(); // インスタンス化禁止

  /// 談議の要約を生成（スタブ）
  ///
  /// [theme] セッションテーマ
  /// [messages] メッセージ履歴（発言者名：発言内容）
  /// [turnCount] ターン数
  ///
  /// MVP ではテンプレートベースで生成。
  /// M2 以降で LLM による高品質要約に置き換え。
  static String generateSummary({
    required String theme,
    required List<String> messages,
    required int turnCount,
  }) {
    if (messages.isEmpty) {
      return 'テーマ「$theme」について、談議が行われました。';
    }

    // スタブ実装：最初と最後のメッセージを使って要約を構成
    final firstMessage = messages.first;
    final lastMessage = messages.last;

    return '''テーマ「$theme」について、$turnCount ターンの談議が行われました。

議論の開始：
$firstMessage

議論の結論：
$lastMessage

参加者それぞれの視点から、テーマに対する多角的な考察が展開されました。''';
  }

  /// Crystal Draft を生成（スタブ）
  ///
  /// [theme] セッションテーマ
  /// [messages] メッセージ履歴
  /// [participants] 参加者リスト
  /// [turnCount] ターン数
  ///
  /// MVP ではスタブ実装。M2 以降で LLM による高品質 Crystal 生成に置き換え。
  static CrystalDraft generateCrystalDraft({
    required String theme,
    required List<String> messages,
    required List<PersonaDefinition> participants,
    required int turnCount,
  }) {
    // タイトル自動生成（スタブ）
    final title = _generateTitle(theme, turnCount);

    // 要約生成
    final summary = generateSummary(
      theme: theme,
      messages: messages,
      turnCount: turnCount,
    );

    return CrystalDraft(
      title: title,
      theme: theme,
      summary: summary,
      participants: participants,
      createdAt: DateTime.now(),
    );
  }

  /// タイトル自動生成（スタブ）
  ///
  /// MVP では簡易ルールで生成。M2 以降で LLM によるタイトル生成に置き換え。
  static String _generateTitle(String theme, int turnCount) {
    // テーマの最初の10文字を使用（長すぎる場合は省略）
    final themePrefix = theme.length > 10 ? '${theme.substring(0, 10)}...' : theme;

    // 日時を含めたタイトル
    final now = DateTime.now();
    final dateStr =
        '${now.year}/${now.month.toString().padLeft(2, '0')}/${now.day.toString().padLeft(2, '0')}';

    return '「$themePrefix」の談議（$dateStr）';
  }
}
