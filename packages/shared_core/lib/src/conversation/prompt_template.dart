// プロンプトテンプレート（M1-D1）
// 会話エンジンが LLM に渡すプロンプトを生成する

import '../persona/persona_definition.dart';

/// プロンプトテンプレート（MVP最小実装）
///
/// 会話エンジンが LLM に渡すプロンプトを生成する。
/// M1 では固定テンプレート、M2 以降でカスタマイズ可能。
class PromptTemplate {
  const PromptTemplate._();

  /// 司会者（モデレーター）用プロンプトを生成
  ///
  /// [theme] 談議のテーマ（ユーザー入力）
  /// [personas] 参加者リスト
  /// [rules] 談議のルール（Code of Council）
  static String buildModeratorPrompt({
    required String theme,
    required List<PersonaDefinition> personas,
    List<String>? rules,
  }) {
    final effectiveRules = rules ?? defaultRules;

    // 参加者リストを整形
    final personasText = personas.map((p) => '- ${p.name}：${p.stance}').join('\n');

    // ルールリストを整形
    final rulesText = effectiveRules.map((r) => '- $r').join('\n');

    return '''
あなたは談議の司会者です。以下の役割を担います：

【テーマ】
$theme

【参加者】
$personasText

【ルール（Code of Council）】
$rulesText

【あなたの役割】
1. 議論の進行を管理する
2. ルール違反を検知し、警告または介入する
3. 脱線時にテーマに戻すよう促す
4. 結論に向けて収束を促す

【介入基準】
- 誹謗中傷：即座に警告
- 独断的発言：2回まで注意、3回目で強制退席
- 脱線：2ターン連続でテーマから外れたら介入

議論を公正に進めてください。''';
  }

  /// Persona 用プロンプトを生成
  ///
  /// [persona] 対象 Persona
  /// [theme] 談議のテーマ
  /// [context] 会話履歴（オプション、M1では未使用）
  static String buildPersonaPrompt({
    required PersonaDefinition persona,
    required String theme,
    String? context,
  }) {
    final basePrompt = '''
あなたは以下の Persona として談議に参加します：

【あなたの情報】
名前：${persona.name}
立場：${persona.stance}

【談議のテーマ】
$theme

【あなたの役割】
- あなたの立場から意見を述べる
- 他の参加者の意見を尊重する
- 建設的な議論を心がける

【禁止事項】
- 誹謗中傷
- 独断的な主張（「〜すべき」の連発）
- テーマから大きく逸脱すること

${persona.stance} の視点から、テーマについて語ってください。''';

    // M1 では context は使用しない（M2 以降で会話履歴を追加）
    return basePrompt;
  }

  /// デフォルトルール（Code of Council）
  static const List<String> defaultRules = [
    '誹謗中傷禁止：人格攻撃は警告対象',
    '独断禁止：「〜すべき」「絶対に」など議論を抑圧する表現を避ける',
    '脱線禁止：テーマから2ターン以上離れたら司会が介入',
  ];
}
