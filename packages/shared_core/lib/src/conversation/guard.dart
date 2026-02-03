// ガード判定（M1-D3：最小実装）

/// ガード判定結果のアクション
enum GuardAction {
  /// 警告（そのまま発言を通すが警告を表示）
  warn,

  /// 書き直し（moderator が介入して書き直しを促す）
  rewrite,

  /// 退場（セッションから除外）
  eject,
}

/// ガード判定結果
class GuardResult {
  const GuardResult({
    required this.action,
    required this.note,
    required this.matchedRule,
  });

  /// 実行するアクション
  final GuardAction action;

  /// 介入理由（日本語、UI表示用）
  final String note;

  /// マッチしたルール（デバッグ・ログ用）
  final String matchedRule;

  /// 問題なし（ガード発動なし）
  static const GuardResult pass = GuardResult(
    action: GuardAction.warn,
    note: '',
    matchedRule: '',
  );

  /// ガードが発動したか
  bool get isTriggered => note.isNotEmpty;
}

/// ガード判定エンジン（最小実装）
///
/// MVP では簡易キーワードマッチングで実装。
/// M2 以降で LLM による高精度判定に置き換え。
class Guard {
  Guard._(); // インスタンス化禁止

  /// 発言をガード判定する
  ///
  /// [text] 発言内容
  /// [theme] セッションテーマ
  /// [turnIndex] ターン番号（脱線判定用）
  static GuardResult evaluate({
    required String text,
    required String theme,
    required int turnIndex,
  }) {
    // 1. 誹謗中傷チェック
    final slanderResult = _checkSlander(text);
    if (slanderResult.isTriggered) {
      return slanderResult;
    }

    // 2. 強断定チェック
    final dogmaticResult = _checkDogmatic(text);
    if (dogmaticResult.isTriggered) {
      return dogmaticResult;
    }

    // 3. 脱線チェック（2ターン目以降）
    if (turnIndex >= 2) {
      final offtopicResult = _checkOfftopic(text, theme);
      if (offtopicResult.isTriggered) {
        return offtopicResult;
      }
    }

    return GuardResult.pass;
  }

  /// 誹謗中傷チェック（人格攻撃）
  static GuardResult _checkSlander(String text) {
    const slanderKeywords = [
      'バカ',
      'アホ',
      '馬鹿',
      '阿呆',
      '愚か',
      '無能',
      '低能',
      '間抜け',
      'クズ',
    ];

    for (final keyword in slanderKeywords) {
      if (text.contains(keyword)) {
        return GuardResult(
          action: GuardAction.eject,
          note: '誹謗中傷は禁止されています。人格攻撃ではなく、意見の内容に焦点を当ててください。',
          matchedRule: '誹謗中傷禁止（キーワード: $keyword）',
        );
      }
    }

    return GuardResult.pass;
  }

  /// 強断定チェック（議論を抑圧する表現）
  static GuardResult _checkDogmatic(String text) {
    const dogmaticPatterns = [
      'すべき',
      'するべき',
      'しなければならない',
      '絶対に',
      '間違いなく',
      '当然',
      '明らか',
    ];

    for (final pattern in dogmaticPatterns) {
      if (text.contains(pattern)) {
        return GuardResult(
          action: GuardAction.warn,
          note: '断定的な表現が検出されました。「〜と考えます」「〜ではないでしょうか」など、議論を促す表現を推奨します。',
          matchedRule: '強断定禁止（パターン: $pattern）',
        );
      }
    }

    return GuardResult.pass;
  }

  /// 脱線チェック（テーマから逸脱）
  ///
  /// MVP では簡易実装：テーマに含まれる主要語彙が発言に1つも含まれない場合に警告。
  /// M2 以降で LLM による意味的類似度判定に置き換え。
  static GuardResult _checkOfftopic(String text, String theme) {
    // テーマを文字単位で分解して、連続する2文字以上の部分文字列を抽出
    final themeWords = <String>[];

    // 「の」「を」などの助詞で分割
    final themeParts = theme.split(RegExp(r'[のをにへとがは、。！？\s]+'));

    for (final part in themeParts) {
      if (part.length >= 2) {
        themeWords.add(part);
      }
    }

    if (themeWords.isEmpty) {
      return GuardResult.pass; // テーマが短すぎる場合はチェックしない
    }

    // テーマ語彙が1つでも含まれていれば OK
    for (final word in themeWords) {
      if (text.contains(word)) {
        return GuardResult.pass;
      }
    }

    // テーマ語彙が1つも含まれない → 脱線の可能性
    return GuardResult(
      action: GuardAction.warn,
      note: 'テーマから離れている可能性があります。「$theme」に焦点を当てて議論を続けてください。',
      matchedRule: '脱線禁止（テーマ語彙不一致）',
    );
  }
}
