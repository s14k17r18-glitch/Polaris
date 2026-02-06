// 英語直書き検出スクリプト（M0-A6）
// UI文言に英語が直書きされていないかチェックする
// 契約: 00_PARITY_CONTRACT.md - 文言は日本語のみ

import 'dart:io';

/// 検出結果
class Violation {
  final String file;
  final int line;
  final String literal;

  Violation(this.file, this.line, this.literal);

  @override
  String toString() => '  $file:$line  $literal';
}

/// 除外判定
bool shouldExclude(String literal, String line) {
  // 1. URL
  if (literal.startsWith('http://') || literal.startsWith('https://')) {
    return true;
  }

  // 2. import/export パス
  if (literal.startsWith('package:') || literal.startsWith('dart:')) {
    return true;
  }

  // 3. ファイルパス風（/ を含む）
  if (literal.contains('/')) {
    return true;
  }

  // 4. ファイル拡張子
  final extPattern = RegExp(r'\.(dart|json|yaml|yml|md|txt|png|jpg|svg|xml)');
  if (extPattern.hasMatch(literal)) {
    return true;
  }

  // 5. ignore-english コメント
  if (line.contains('// ignore-english')) {
    return true;
  }

  // 6. 識別子パターン（camelCase, snake_case, PascalCase）
  // 例: sessionState, session_state, SessionState
  final identifierPattern = RegExp(r'^[a-zA-Z_][a-zA-Z0-9_]*$');
  if (identifierPattern.hasMatch(literal)) {
    return true;
  }

  // 7. 全て大文字（定数/フラグ）
  // 例: DEBUG, API, HTTP
  final upperPattern = RegExp(r'^[A-Z][A-Z0-9_]*$');
  if (upperPattern.hasMatch(literal)) {
    return true;
  }

  // 8. キー名風（ドット区切り）
  // 例: session.id, user.name
  if (literal.contains('.') && !literal.contains(' ')) {
    return true;
  }

  // 9. enum値やキー名（コロン後）
  // 例: 'key': value
  if (line.contains("'$literal':") || line.contains("'$literal' :")) {
    return true;
  }

  // 10. JSON/Map のキー
  if (line.contains('"$literal":') || line.contains('"$literal" :')) {
    return true;
  }

  // 11. 日本語（ひらがな/カタカナ/漢字/全角記号/矢印）を含む場合は除外
  // 日本語メインの文言で変数補間（$variable）を含むケース
  // 全角記号: →、：、（）、「」 等
  // \u2190-\u21FF: 矢印記号（→ = U+2192）
  final japanesePattern = RegExp(
    r'[\u3040-\u309F\u30A0-\u30FF\u4E00-\u9FAF\u3000-\u303F\uFF00-\uFFEF\u2190-\u21FF]',
  );
  if (japanesePattern.hasMatch(literal)) {
    return true;
  }

  // 12. 変数補間のみで構成（$identifier や ${...}）
  // 例: '$version' や '${value}'
  final interpolationOnly = RegExp(r'^\$\{?[a-zA-Z_][a-zA-Z0-9_.]*\}?$');
  if (interpolationOnly.hasMatch(literal)) {
    return true;
  }

  // 13. バージョン表記 v + 数字
  // 例: 'v1', 'v$version'
  if (literal.startsWith('v') && literal.length <= 10) {
    final versionLike = RegExp(r'^v[\d$]');
    if (versionLike.hasMatch(literal)) {
      return true;
    }
  }

  // 14. 不完全な文字列抽出（?? や { で終わる）
  // ネストされた式の途中で切れたケース
  if (literal.endsWith('??') ||
      literal.endsWith('{') ||
      literal.contains(r'${') && !literal.contains('}')) {
    return true;
  }

  return false;
}

/// 英字が3文字以上連続するか判定
bool hasEnglishWord(String literal) {
  // ASCII英字が3文字以上連続
  final pattern = RegExp(r'[a-zA-Z]{3,}');
  return pattern.hasMatch(literal);
}

/// ファイルをスキャンして違反を検出
List<Violation> scanFile(String filePath) {
  final violations = <Violation>[];
  final file = File(filePath);

  if (!file.existsSync()) {
    return violations;
  }

  final lines = file.readAsLinesSync();
  for (var i = 0; i < lines.length; i++) {
    final line = lines[i];
    final lineNum = i + 1;

    // コメント行はスキップ（UI表示ではない）
    final trimmed = line.trimLeft();
    if (trimmed.startsWith('//') || trimmed.startsWith('///')) {
      continue;
    }

    // raw文字列 r'...' r"..." はスキップ
    if (line.contains(RegExp(r'''r['"]'''))) {
      continue;
    }

    // 文字列リテラルを抽出（シングルクォート）
    final singleQuotePattern = RegExp(r"'([^']*)'");
    for (final match in singleQuotePattern.allMatches(line)) {
      final literal = match.group(1) ?? '';
      if (hasEnglishWord(literal) && !shouldExclude(literal, line)) {
        violations.add(Violation(filePath, lineNum, "'$literal'"));
      }
    }

    // 文字列リテラルを抽出（ダブルクォート）
    final doubleQuotePattern = RegExp(r'''"([^"]*)"''');
    for (final match in doubleQuotePattern.allMatches(line)) {
      final literal = match.group(1) ?? '';
      if (hasEnglishWord(literal) && !shouldExclude(literal, line)) {
        violations.add(Violation(filePath, lineNum, '"$literal"'));
      }
    }
  }

  return violations;
}

/// 対象ディレクトリから.dartファイルを収集
List<String> collectDartFiles(String rootPath) {
  final files = <String>[];
  final targets = ['apps', 'packages'];

  for (final target in targets) {
    final dir = Directory('$rootPath/$target');
    if (!dir.existsSync()) {
      continue;
    }

    dir.listSync(recursive: true).forEach((entity) {
        if (entity is File && entity.path.endsWith('.dart')) {
          final path = entity.path.replaceAll('\\', '/');

          // 除外: 生成物・ビルド成果物
          if (path.contains('/.dart_tool/')) {
            return;
          }
          if (path.contains('/build/')) {
            return;
          }
          if (path.contains('/windows/flutter/ephemeral/')) {
            return;
          }

          // 除外: test/ 配下
          if (path.contains('/test/')) {
            return;
          }

        // 除外: 生成コード
        if (path.endsWith('.g.dart') || path.endsWith('.freezed.dart')) {
          return;
        }

        // 除外: l10n_ja 自体（ここは日本語文言の定義場所）
        if (path.contains('/l10n_ja/')) {
          return;
        }

        files.add(entity.path);
      }
    });
  }

  return files;
}

void main(List<String> args) {
  // リポジトリルートを取得
  final rootPath = args.isNotEmpty ? args[0] : Directory.current.path;

  stdout.writeln('====================================');
  stdout.writeln('  英語直書きチェック');
  stdout.writeln('====================================');
  stdout.writeln('対象: apps/, packages/ (l10n_ja除く)');
  stdout.writeln('');

  final files = collectDartFiles(rootPath);
  final allViolations = <Violation>[];

  for (final file in files) {
    final violations = scanFile(file);
    allViolations.addAll(violations);
  }

  if (allViolations.isEmpty) {
    stdout.writeln('[OK] 英語直書きなし');
    exit(0);
  } else {
    stdout.writeln('[FAIL] 英語直書き検出 (${allViolations.length}件)');
    for (final v in allViolations) {
      stdout.writeln(v);
    }
    exit(1);
  }
}
