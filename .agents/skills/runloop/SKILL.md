---
name: runloop
description: Use when planning/executing work: enforce one-item-per-run, fixed order, and stop on spec gaps.
---
# Purpose
This skill encodes the project's working agreement and should be used when relevant.

# Instructions
- Follow the rules exactly.
- If the user's request conflicts with these rules, stop and explain the conflict, then propose the compliant alternative.
- Keep changes minimal and aligned with the MVP scope.

# Source (cloudcode/.claude)
This skill was derived from: .claude/rules/10-runloop.md

# Rules (verbatim / adapted)

> BEGIN SOURCE
> # skill_runloop.md（実行ループ：迷わない進め方）
> Claude Code が「順番迷子」にならないための実行ルール。
> 
> ---
> 
> ## ゴール
> - `docs/09_IMPLEMENTATION_PLAN.md` のチェックリストを **上から順に潰していく**
> - 1回の作業で進めるのは **未完了の1項目だけ**
> - 必ずテストし、NGなら直して再テスト（OKまで）
> 
> ---
> 
> ## 毎回の手順（固定）
> 1) 対象チェック項目を1つ選ぶ（未完了）
> 2) 実装前宣言（必須）
>    - 対象チェック項目ID
>    - 変更ファイル一覧（予告）
>    - テスト計画（最低：Windows/iOS起動）
> 3) 実装
> 4) テスト
> 5) NGなら修正→再テスト（OKまで繰り返し）
> 6) 差分要約（git diff要約）
> 7) コミット→push→PR作成
> 
> ---
> 
> ## 迷ったらこれ（強制）
> - UIを先に作らない。必ず **共通コア→状態遷移→保存→同期→UI** の順で。
> - docs に矛盾/空白があるなら勝手に決めず停止して、選択肢＋推奨＋理由を提示。
> - 例外が必要なら `docs/00_PARITY_CONTRACT.md` の「例外申請」に従う。
> 
> ---
> 
> ## 成果物の品質ゲート（最低ライン）
> - Windows/iOSで起動できる
> - 主要画面遷移ができる
> - セッション完走（M1以降）
> - 保存/復元（M2以降）
> - 同期の契約準拠（M3以降）
> END SOURCE
