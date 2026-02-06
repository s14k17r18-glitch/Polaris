---
id: handoff-trigger-resumer
name: 引き継ぎトリガー応答（呼び出し）
description: 引き継ぎ系トリガーに反応し、要点整理と再開手順とLOG貼付用Q/Aを返すskill
triggers:
  any_phrase:
    - 前のタスクを引き継ぎ
    - 覚えてる？
    - 前の続き
    - 引き継ぎお願い
    - 引き継ぎ
behavior:
  on_trigger:
    - 要点整理
    - 再開手順
    - LOG貼付用Q/A
uses_skill: handoff-qa-logger
constraints:
  - no_derailment
  - next_must_be_single
output_contract: always_return summary + resume_steps + log_entry
---

# 目的
引き継ぎトリガーを受けたときに、再開に必要な情報を短く固定形式で返す。

# トリガー時の返答フォーマット（3点セット）
- 前タスクの要点（1〜5行）
- 再開手順（1〜3手）
- `docs/handoff/LOG_QA.md` に貼れるQ/Aエントリ

# 再開手順の作り方
- `docs/HANDOFF.md` を先に確認する。
- `docs/handoff/LOG_QA.md` の最新エントリを確認する。
- 最新エントリの `Next` を1手だけ提示する。

# ルール
- 宣言の有無に関係なく、やり取りごとにQ/Aを記録する。
- `Next` は必ず1つだけ提示する。
- 脱線しそうな改善は `docs/handoff/PARK.md` に退避し、修正は行わない。

# LOG貼付用テンプレ
```markdown
### [YYYY-MM-DD NN] Q/A
Q: <ユーザーの質問/依頼を1行で要約>
A:
- <結論/結果を1〜3行で圧縮>
- 変更: <主なファイル/要点だけ>（実装がある場合のみ）
- 検証: <実行したテスト/結果>（実装がある場合のみ）
Meta: branch=<...> commit=<...> test=<...> （分からなければ空でOK）
Park: <気になる点/脱線しそうな点を1行>
Next: <次の1手を1つだけ>
```
