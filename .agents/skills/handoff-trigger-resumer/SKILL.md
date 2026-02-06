---
name: handoff-trigger-resumer
description: |
  ユーザーが「前のタスクを引き継ぎ」「覚えてる？」「前の続き」等と言った時に、
  前タスク要点＋再開手順＋LOG貼付用Q/Aを返す運用スキル。
compatibility:
  codex: "*"
license: MIT
metadata:
  triggers_any_phrase:
    - "前のタスクを引き継ぎ"
    - "覚えてる？"
    - "前の続き"
    - "引き継ぎお願い"
    - "引き継ぎ"
  uses:
    - handoff-qa-logger
  response_contract:
    must_include:
      - "前タスクの要点（1〜5行）"
      - "再開手順（1〜3手、Nextは1つ）"
      - "LOG_QA.mdに貼れるQ/Aエントリ"
---

# トリガー時の返答（必須3点セット）
1) 前タスクの要点（1〜5行）
2) 再開手順（1〜3手、Nextは1つ）
3) LOG_QA.mdに貼れるQ/Aエントリ（handoff-qa-loggerのテンプレ準拠）
