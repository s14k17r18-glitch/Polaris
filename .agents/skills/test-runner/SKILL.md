---
name: test-runner
description: 変更後の必須テスト手順と報告を固定化。Windows/iOS起動確認を含む。test/verify/report
---
# Purpose
変更による破壊を防ぐため、必須テストと報告形式を守る。

# When to use
- 何らかの変更を加えたとき
- テスト計画や結果報告が必要なとき

# When NOT to use
- 変更が一切ない読み取り/質問回答のみのとき

# Procedure
1. 起動テスト（Windows/iOS）を最優先で実施する。
2. M1以降は縦スライス完走テストを実施する。
3. 共通コア単体テストを可能な限り実施する。
4. NGなら修正→再テストを繰り返す。

Checklist:
- [ ] Windows起動OK
- [ ] iOS起動OK
- [ ] 変更範囲に応じた追加テスト

# Constraints
- 外部ログインやAPIキー入力が必要なら必ず停止してユーザー依頼。
- “一部OK”のまま次へ進まない。

# Output expectations
- 実行したテストと結果
- 失敗時は再現手順・期待/実結果・原因・方針を報告

# Sources
- Derived from: `.claude/rules/30-test.md`
