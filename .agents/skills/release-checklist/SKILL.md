---
name: release-checklist
description: リリース時のチェックとユーザー入力境界を明確化。署名/登録は必ず停止。release/checklist
---
# Purpose
リリース直前で詰まらないよう、必要チェックとユーザー操作の境界を明確にする。

# When to use
- 配布/ビルド/リリース準備を進めるとき
- 署名やストア登録が関わるとき

# When NOT to use
- 通常の開発タスクでリリースが関係ないとき

# Procedure
1. 起動テスト、縦スライス、保存/同期の最低ラインを確認する。
2. リリース前チェック項目を順に消化する。
3. 署名/ストア登録など外部入力が必要なら停止して依頼する。

Checklist:
- [ ] Windows/iOS起動
- [ ] セッション完走（M1）
- [ ] 保存/復元（M2）
- [ ] 同期（M3）
- [ ] 日本語固定

# Constraints
- 証明書/ストア登録/課金/同意はユーザー作業。
- 勝手に登録・決済を行わない。

# Output expectations
- 実施したチェックと結果
- 必要なユーザー入力の指示

# Sources
- Derived from: `.claude/rules/40-release.md`
