---
id: handoff-qa-logger
name: 引き継ぎQ/A圧縮ログ（記録）
description: 毎回のやり取りをQ/Aペアで圧縮し、LOG_QAへ追記するための記録用skill
canonical_log_file: docs/handoff/LOG_QA.md
park_file: docs/handoff/PARK.md
triggers:
  any_phrase:
    - 前のタスクを引き継ぎ
    - 覚えてる？
    - 前の続き
    - 引き継ぎお願い
    - 引き継ぎ
constraints:
  - no_derailment
  - next_must_be_single
compact_lines_max: 15
output_contract: always_return short_result_explanation + log_entry
templates:
  log_entry: |
    ### [YYYY-MM-DD NN] Q/A
    Q: <ユーザーの質問/依頼を1行で要約>
    A:
    - <結論/結果を1〜3行で圧縮>
    - 変更: <主なファイル/要点だけ>（実装がある場合のみ）
    - 検証: <実行したテスト/結果>（実装がある場合のみ）
    Meta: branch=<...> commit=<...> test=<...> （分からなければ空でOK）
    Park: <気になる点/脱線しそうな点を1行>
    Next: <次の1手を1つだけ>
---

# 目的
タスク切替後でも再開できるように、各やり取りをQ/Aで圧縮して記録する。

# 記録ルール
- 実装前宣言の有無に関係なく、毎回Q/Aを1件追記する。
- `Q` は依頼要約1行、`A` は1〜3行の結果要約にする。
- 実装がある場合だけ `変更` と `検証` を追記する。
- `Meta` は branch/commit/test を埋める。未確定なら空でよい。

# 圧縮ルール
- 1エントリは10〜15行を目安にする。
- 説明は要点のみ。履歴に必要な事実だけ書く。
- `Next` は必ず1つだけ書く。

# Park運用
- 作業中に気になる点を見つけたら修正せず `docs/handoff/PARK.md` に1行退避する。
- Parkは修正計画の管理のみ。DoD達成前は実装しない。

# 出力テンプレ
以下を `docs/handoff/LOG_QA.md` にそのまま貼り付けて追記する。

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
