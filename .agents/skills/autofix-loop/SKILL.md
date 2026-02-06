---
name: autofix-loop
description: 解析/フォーマット失敗時の自動修正ループ。最大3回、MVP外に拡張しない。lint/test/format
---
# Purpose
解析やフォーマットの失敗を、最小修正で確実に解消するための手順を固定する。

# When to use
- `tools/run_analyze.bat` や `tools/run_format.bat` が失敗したとき
- 解析/フォーマットのエラーを最短で収束させたいとき

# When NOT to use
- 失敗の原因が環境依存や外部入力で、手元で再現できないとき
- 仕様追加や大規模改修が必要な場合

# Procedure
1. 必要なら `flutter pub get` を実行する。
2. `tools/run_format.bat` → `tools/run_analyze.bat` の順に実行する。
3. 失敗原因を分類し、最小修正を行う。
4. 2に戻る。最大3ループで打ち切り、停止して相談する。

Checklist:
- [ ] 1ループで変更するのは原因ファイルのみ
- [ ] 3ループで収束しなければ停止
- [ ] MVP外の機能追加はしない

# Constraints
- 置換が不明確な非推奨APIは勝手に変更しない。
- include設定は Dart/Flutter の区別に従う。

# Output expectations
- 直したエラー種別
- 修正ファイル一覧
- 最終ログの要点

# Sources
- Derived from: `.claude/rules/25-autofix-loop.md`
