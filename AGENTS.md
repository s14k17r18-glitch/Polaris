# AGENTS.md (DanGi / Polaris)

## TL;DR (3–7行サマリ)
- 体験の核: 談議（Ritual→Council→Ending）と Knowledge Crystal 生成。研究室UIの世界観。
- Windows/iOS で**同一機能・同一データ・同一UIトークン・同一モーション**を厳守。
- **日本語固定**（UI/エラー/ユーザー可視ログ）。
- MVPは M0〜M3 まで。OUT事項（3D/音声クローン/自動Web検索/多言語等）は勝手に実装しない。
- 仕様の唯一の正は `docs/`。空白や矛盾が出たら必ず停止して確認。

## 重要ドキュメント（優先順）
- `docs/00_PARITY_CONTRACT.md`：Windows/iOS完全一致契約（最優先）
- `docs/00_MVP_SCOPE_LOCK.md`：M0〜M3の範囲固定（盛らない）
- `docs/12_SYNC_API_SPEC.md`：同期の唯一の正（M3はこれ準拠）
- `docs/09_IMPLEMENTATION_PLAN.md`：実装順とDoD
- `docs/CONCEPT.md` / `docs/02_PRODUCT_FLOW.md`：世界観・体験フロー

## 非交渉ルール
- パリティ契約に反する変更は禁止（例外申請が必要）。
- MVP範囲外（OUT項目）の実装禁止。
- 仕様の不足は推測で埋めない。必ず確認して止まる。

## ワークフロー（毎回これ）
1. `docs/09_IMPLEMENTATION_PLAN.md` の未完了項目を**1つだけ**選ぶ。
2. 実装前宣言：対象項目ID / 変更ファイル / テスト計画。
3. 最小変更で実装。
4. テスト実施（Windows/iOSの起動確認は必須）。
5. 差分要約・次の手を報告。

## Git運用（安全）
- `main` 直push禁止。
- ブランチ命名：`feature/<M#>-<topic>`。
- `git push --force` 禁止。
- 小さなコミット＋PR作成。

## 外部入力が必要な作業
- ログイン/登録/2FA/CAPTCHA/APIキー入力は **必ず停止**してユーザーに依頼。

## Codex Skills（repo-scoped）
`.agents/skills` に作成済み。必要に応じて使う。
- `runloop`：1回1項目と進行順の固定
- `git-safety`：Git/PR安全運用
- `autofix-loop`：解析NG時の最大3ループ自動修正
- `test-runner`：テスト必須・再実行ループ
- `release-checklist`：リリース前チェックとユーザー入力境界
- `parity-style`：共通コア優先とOS差異の抑制


## Context continuity (must)
- Use `$handoff-memory` when the session becomes long, when switching threads, and after major decisions.
- Default rule: after each meaningful commit, append an entry to `docs/handoff/LOG.md`.
- Before starting a new thread/session: read `docs/HANDOFF.md` first, then continue from “Next single action”.
