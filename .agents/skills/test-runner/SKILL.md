---
name: test-runner
description: Use when changes are made: run required checks and document results; ensure parity constraints are met.
---
# Purpose
This skill encodes the project's working agreement and should be used when relevant.

# Instructions
- Follow the rules exactly.
- If the user's request conflicts with these rules, stop and explain the conflict, then propose the compliant alternative.
- Keep changes minimal and aligned with the MVP scope.

# Source (cloudcode/.claude)
This skill was derived from: .claude/rules/30-test.md

# Rules (verbatim / adapted)

> BEGIN SOURCE
> # skill_test.md（テスト運用）
> 「テスト忘れ」「直したつもりで壊す」を防ぐための固定手順。
> 
> ---
> 
> ## 原則
> - 変更したら必ずテスト
> - テストがNGなら、**テスト→修正→再テスト**をOKまで繰り返す
> - “一部だけOK”で先に進まない（後で地獄）
> 
> ---
> 
> ## テストの優先順位
> 1) 起動テスト（必須）  
>    - Windows：起動→主要画面遷移→クラッシュ無し  
>    - iOS：起動→主要画面遷移→クラッシュ無し
> 2) 縦スライス統合（M1以降必須）  
>    - 1セッション完走（状態遷移が崩れない）
> 3) 共通コア単体テスト（常に推奨）  
>    - データモデル（serialize/deserialize）
>    - 状態遷移（許可されない遷移が通らない）
>    - Sync差分生成（M3以降）
> 4) 破壊的変更の検証  
>    - schema_version更新時：migrationがあるか
>    - 既存データが読めるか
> 
> ---
> 
> ## 外部のテスト（Web/拡張機能/オンラインツール）
> 使ってよい。ただし以下は必ず守る：
> - ログイン/登録/APIキー入力が必要なら **必ず停止してユーザー入力に委ねる**
> - テスト結果は再現可能な形で残す（URL・手順・期待結果/実結果）
> 
> ---
> 
> ## 失敗時の報告フォーマット（必須）
> - 失敗したテスト：
> - 再現手順：
> - 期待結果：
> - 実結果（エラーログ/スクショ要約）：
> - 推定原因：
> - 修正方針：
> END SOURCE
