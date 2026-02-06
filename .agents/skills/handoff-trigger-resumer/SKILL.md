---
id: handoff-trigger-resumer
name: 引き継ぎトリガー応答（呼び出し）
version: 1.0.0
status: active
triggers:
  any_phrase:
    - "前のタスクを引き継ぎ"
    - "覚えてる？"
    - "前の続き"
    - "引き継ぎお願い"
    - "引き継ぎ"
uses_skill:
  - handoff-qa-logger
response_contract:
  must_include:
    - previous_task_key_points
    - resume_steps
    - log_md_qa_entry
---

# トリガー時の返答（必須3点セット）
1) 前タスクの要点（1〜5行）
2) 再開手順（1〜3手、Nextは1つ）
3) LOG_QA.mdに貼れるQ/Aエントリ（handoff-qa-loggerのテンプレ準拠）
