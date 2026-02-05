# DEV_STATUS

## Outer (archived repo)
# Outer (archived repo)
/mnt/d/PROJECT/DanGi
origin	https://github.com/s14k17r18-glitch/archived-repo.git (fetch)
origin	https://github.com/s14k17r18-glitch/archived-repo.git (push)
main
 M .claude/CLAUDE.md
 M .claude/rules/25-autofix-loop.md
 M .claude/settings.local.json
 M .gitignore
 M README.md
 M analysis_options.yaml
 M apps/dangi_app/.gitignore
 M apps/dangi_app/README.md
 M apps/dangi_app/analysis_options.yaml
 M apps/dangi_app/lib/auth/auth_repository.dart
 M apps/dangi_app/lib/main.dart
 M apps/dangi_app/lib/storage/file_local_store.dart
 M apps/dangi_app/pubspec.yaml
 M apps/dangi_app/test/auth/auth_repository_test.dart
 M apps/dangi_app/test/integration/persistence_integration_test.dart
 M apps/dangi_app/test/storage/file_local_store_test.dart
 M apps/dangi_app/test/widget_test.dart
 M apps/dangi_app/windows/.gitignore
 M apps/dangi_app/windows/CMakeLists.txt
 M apps/dangi_app/windows/flutter/CMakeLists.txt
 M apps/dangi_app/windows/runner/CMakeLists.txt
 M apps/dangi_app/windows/runner/Runner.rc
 M apps/dangi_app/windows/runner/flutter_window.cpp
 M apps/dangi_app/windows/runner/flutter_window.h
 M apps/dangi_app/windows/runner/main.cpp
 M apps/dangi_app/windows/runner/resource.h
 M apps/dangi_app/windows/runner/runner.exe.manifest
 M apps/dangi_app/windows/runner/utils.cpp
 M apps/dangi_app/windows/runner/utils.h
 M apps/dangi_app/windows/runner/win32_window.cpp
 M apps/dangi_app/windows/runner/win32_window.h
 M backend/README.md
 M contracts/README.md
 M docs/00_CONCEPT_EXTRACT.md
 M docs/00_COVERAGE_MATRIX.md
 M docs/00_DOC_MAP.md
 M docs/00_MVP_SCOPE_LOCK.md
 M docs/00_PARITY_CONTRACT.md
 M docs/00_PROGRESS_LOG.md
 M docs/01_REQUIREMENTS.md
 M docs/02_PRODUCT_FLOW.md
 M docs/03_PERSONAS_SCHEMA.md
 M docs/04_CONVERSATION_ENGINE_SPEC.md
 M docs/05_UI_VISUAL_SPEC.md
 M docs/06_MOTION_AUDIO_SPEC.md
 M docs/07_DATA_MODEL.md
 M docs/10_RISKS_AND_GUARDS.md
 M docs/12_SYNC_API_SPEC.md
 M docs/CONCEPT.md
 M melos.yaml
 M packages/l10n_ja/README.md
 M packages/l10n_ja/analysis_options.yaml
 M packages/l10n_ja/lib/l10n_ja.dart
 M packages/l10n_ja/lib/src/strings.dart
 M packages/l10n_ja/pubspec.yaml
 M packages/motion_tokens/README.md
 M packages/motion_tokens/analysis_options.yaml
 M packages/motion_tokens/lib/motion_tokens.dart
 M packages/motion_tokens/lib/src/motion.dart
 M packages/motion_tokens/pubspec.yaml
 M packages/shared_core/README.md
 M packages/shared_core/analysis_options.yaml
 M packages/shared_core/lib/shared_core.dart
 M packages/shared_core/lib/src/conversation/conversation_engine.dart
 M packages/shared_core/lib/src/conversation/guard.dart
 M packages/shared_core/lib/src/conversation/message_chunk.dart
 M packages/shared_core/lib/src/conversation/prompt_template.dart
 M packages/shared_core/lib/src/conversation/summary_crystal.dart
 M packages/shared_core/lib/src/model/crystal_entity.dart
 M packages/shared_core/lib/src/model/guard_event_entity.dart
 M packages/shared_core/lib/src/model/message_entity.dart
 M packages/shared_core/lib/src/model/persona_entity.dart
 M packages/shared_core/lib/src/model/persona_snapshot_entity.dart
 M packages/shared_core/lib/src/model/session_entity.dart
 M packages/shared_core/lib/src/model/sync_metadata.dart
 M packages/shared_core/lib/src/persona/persona_definition.dart
 M packages/shared_core/lib/src/persona/persona_repository.dart
 M packages/shared_core/lib/src/schema/migration.dart
 M packages/shared_core/lib/src/schema/migrations/migration_0_to_1.dart
 M packages/shared_core/lib/src/schema/version.dart
 M packages/shared_core/lib/src/state/error_context.dart
 M packages/shared_core/lib/src/state/session_event.dart
 M packages/shared_core/lib/src/state/session_machine.dart
 M packages/shared_core/lib/src/state/session_state.dart
 M packages/shared_core/lib/src/storage/in_memory_store.dart
 M packages/shared_core/lib/src/storage/local_store.dart
 M packages/shared_core/pubspec.yaml
 M packages/shared_core/test/conversation/conversation_engine_test.dart
 M packages/shared_core/test/conversation/guard_test.dart
 M packages/shared_core/test/conversation/prompt_template_test.dart
 M packages/shared_core/test/conversation/summary_crystal_test.dart
 M packages/shared_core/test/model/data_model_test.dart
 M packages/shared_core/test/persona/persona_definition_test.dart
 M packages/shared_core/test/persona/persona_repository_test.dart
 M packages/shared_core/test/state/session_machine_test.dart
 M packages/shared_core/test/storage/local_store_test.dart
 M packages/ui_tokens/README.md
 M packages/ui_tokens/analysis_options.yaml
 M packages/ui_tokens/lib/src/tokens.dart
 M packages/ui_tokens/lib/ui_tokens.dart
 M packages/ui_tokens/pubspec.yaml
 M pubspec.yaml
 M tools/README.md
 M tools/check_english_literals.dart
 M tools/run_analyze.bat
 M tools/run_check_english.bat
 M tools/run_format.bat
 M tools/run_test.bat
?? .claude/README.md
?? .claude/agents/
?? .claude/commands/
?? .claude/playbooks/
?? .claude/settings.json
?? .claude/skills/
?? AGENTS.md
?? Polaris/
?? docs/99_SESSION_HANDOFF.md
53c9b7c Merge pull request #10 from s14k17r18-glitch/feature/M3-F1-auth-minimum
fcacffa M3: F1 Auth（最小実装）を追加
95a8a1a M2: E5 履歴一覧とPersonaSnapshot保存/復元を追加 (#9)
8949909 M2: E4 永続化をUIに統合（保存/復元） (#8)
e3d0104 M2: E3 JSON永続化（FileLocalStore）を追加 (#7)
df66ad1 M2: E2 ローカル保存基盤を追加 (#6)
12d55bd M2: E1 データモデル（保存・同期用）を追加 (#5)
c3534e1 M1: B3 エラー復帰（再試行/中断/再開） (#4)
8f3f45a M1: D4 要約生成＋Crystal生成（表示まで） (#3)
fe16637 M1: D3 ガード判定（最小）を追加 (#2)
59c848d M1: D2 ターン生成（ストリーミング表示） (#1)
5726f51 M1: D1 プロンプトテンプレを共通コアに追加
ba5d409 M1: C1 Persona読込＋最低限バリデーション
701ed57 M0: A6 英語直書き禁止チェックの追加
a456884 M0: B2 殻（Windows/iOS）の画面遷移を状態に接続
5978470 M0: B1 状態遷移（BOOT〜DISSOLUTION）の実装
7562aa6 M0: motion_tokens フォーマット調整
7570519 M0: A3 schema_version と migration 枠の追加
f4d7687 M0: A2 lint エラー修正（autofix loop 完了）
c55adc6 M0: A2 lint/format/test 環境構築

## Inner (Polaris)
# Inner (Polaris)
/mnt/d/PROJECT/DanGi/Polaris
origin	https://github.com/s14k17r18-glitch/Polaris.git (fetch)
origin	https://github.com/s14k17r18-glitch/Polaris.git (push)
feature/M0-progress-dashboard
?? .agents/skills.bak.20260205-204614/
?? AGENTS.md.bak.20260205-204614
?? AGENTS.md.bak.20260205-210812
1492abd chore: document MilestonePhase field
bf38dcd chore: add Polaris progress project runbook
a7f9931 chore: tune handoff-memory trigger phrases and add memory rule
df4b1d7 chore: add handoff-memory skill with incremental log + snapshot
8da1cac chore: rewrite Codex skills into formal format
f2583fb chore: add Codex AGENTS.md and skills from .claude
53c9b7c Merge pull request #10 from s14k17r18-glitch/feature/M3-F1-auth-minimum
fcacffa M3: F1 Auth（最小実装）を追加
95a8a1a M2: E5 履歴一覧とPersonaSnapshot保存/復元を追加 (#9)
8949909 M2: E4 永続化をUIに統合（保存/復元） (#8)
e3d0104 M2: E3 JSON永続化（FileLocalStore）を追加 (#7)
df66ad1 M2: E2 ローカル保存基盤を追加 (#6)
12d55bd M2: E1 データモデル（保存・同期用）を追加 (#5)
c3534e1 M1: B3 エラー復帰（再試行/中断/再開） (#4)
8f3f45a M1: D4 要約生成＋Crystal生成（表示まで） (#3)
fe16637 M1: D3 ガード判定（最小）を追加 (#2)
59c848d M1: D2 ターン生成（ストリーミング表示） (#1)
5726f51 M1: D1 プロンプトテンプレを共通コアに追加
ba5d409 M1: C1 Persona読込＋最低限バリデーション
701ed57 M0: A6 英語直書き禁止チェックの追加
