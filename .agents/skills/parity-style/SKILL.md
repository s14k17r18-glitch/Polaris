---
name: parity-style
description: 実装スタイルのパリティ維持。shared_core優先、OS別分岐は入力のみ。parity/shared_core/style
---
# Purpose
Windows/iOSの機能差を生まない実装スタイルを徹底する。

# When to use
- アーキテクチャ判断や配置場所を決めるとき
- OS別分岐を検討するとき

# When NOT to use
- UI入力差以外のロジック分岐を入れたくなるとき

# Procedure
1. ロジックは `shared_core` に集約する。
2. UIトークン/モーション/文言は単一ソースにする。
3. OS別分岐は入力差のみに限定する。

Checklist:
- [ ] 共通コアにロジックを置いた
- [ ] OS別の値分岐がない
- [ ] 日本語文言の単一ソースを維持

# Constraints
- iOSだけ/Windowsだけの挙動差を作らない。
- トークンやモーションのOS別値は禁止。

# Output expectations
- どの層に配置したかの説明
- パリティ維持の根拠

# Sources
- Derived from: `.claude/rules/50-style.md`
