---
id: handoff-qa-logger
name: 引き継ぎQ/A圧縮ログ（記録）
version: 1.0.0
status: active
canonical_log_file: docs/handoff/LOG_QA.md
park_file: docs/handoff/PARK.md
constraints:
  no_derailment: true
  next_must_be_single: true
  compact_lines_max: 15
output_contract:
  always_return:
    - short_result_explanation
    - log_md_qa_entry
templates:
  log_entry: |
    ### [{{date}} {{seq}}] Q/A
    Q: {{q_one_line}}
    A:
    - {{a_line_1}}
    - 変更: {{changes}}（実装がある場合のみ）
    - 検証: {{tests}}（実装がある場合のみ）
    Meta: branch={{branch}} commit={{commit}} test={{test}}
    Park: {{park_one_line}}
    Next: {{next_single_action}}
---

# 目的
- 毎回のやり取りをQ/Aで圧縮し、LOG_QA.mdに追記する。
- 脱線しそうな点はPARK.mdへ棚上げし、修正計画だけ残す。

# ルール
- 実装前宣言は不要（宣言が無くても必ずQ/Aで記録）。
- Nextは必ず1つ。
- 気になる点は修正せずParkへ（DoD達成後に計画のみ）。
