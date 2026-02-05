---
name: parity-style
description: Use for implementation decisions: shared_core-first, OS split boundaries, parity contract compliance.
---
# Purpose
This skill encodes the project's working agreement and should be used when relevant.

# Instructions
- Follow the rules exactly.
- If the user's request conflicts with these rules, stop and explain the conflict, then propose the compliant alternative.
- Keep changes minimal and aligned with the MVP scope.

# Source (cloudcode/.claude)
This skill was derived from: .claude/rules/50-style.md

# Rules (verbatim / adapted)

> BEGIN SOURCE
> # skill_style.md（実装スタイル：パリティ維持）
> Windows/iOSの差が出ないようにするための実装スタイル。
> 
> ---
> 
> ## 絶対方針
> - 「殻（platform shell）」は薄く保つ  
>   → UI入力（キーボード/タップ等）以外のロジックを置かない
> - 共通ロジックは `shared_core` に集約  
>   → 状態遷移、会話エンジン、データモデル、同期クライアント、バリデーション
> - UIトークン / モーション / 日本語文言は単一ソース  
>   → OS別に値を分けない（例外は契約に従って申請）
> 
> ---
> 
> ## よくある事故パターン（禁止）
> - iOSだけ別の画面遷移や例外処理を入れる
> - Windowsだけデバッグ文言が英語で露出
> - tokensがOS別に増殖して微妙にズレる
> END SOURCE
