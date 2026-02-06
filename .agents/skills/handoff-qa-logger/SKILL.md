---
name: handoff-qa-logger
description: |
  引き継ぎログを「Q/A圧縮」で残すための運用スキル。
  毎回、短い結果説明＋LOG貼付用Q/Aエントリをセットで出力する。
compatibility:
  codex: "*"
license: MIT
metadata:
  canonical_log_file: docs/handoff/LOG_QA.md
  park_file: docs/handoff/PARK.md
  rules:
    - "実装前宣言は不要。1ターン=Q/Aで記録"
    - "Nextは必ず1つ"
    - "脱線しそうな点はParkへ（実装修正は後）"
  log_entry_template: |
    ### [YYYY-MM-DD NN] Q/A
    Q: <1行>
    A:
    - <要点1〜3行>
    Meta: branch= commit= test=
    Park: <1行>
    Next: <1つ>
---

# 目的
- 毎回のやり取りをQ/Aで圧縮し、LOG_QA.mdに追記する。
- 脱線しそうな点はPARK.mdへ棚上げし、修正計画だけ残す。

# ルール
- 実装前宣言は不要（宣言が無くても必ずQ/Aで記録）。
- Nextは必ず1つ。
- 気になる点は修正せずParkへ（DoD達成後に計画のみ）。
