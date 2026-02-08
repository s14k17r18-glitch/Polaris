// 共通コア: 状態遷移・会話エンジン・データモデル・同期クライアント

// M0: Schema (A3 で実装済み)
export 'src/schema/version.dart';
export 'src/schema/migration.dart';
export 'src/schema/migrations/migration_0_to_1.dart';

// M0: State (B1 で実装済み)
export 'src/state/session_state.dart';
export 'src/state/session_event.dart';
export 'src/state/session_machine.dart';

// M1: State (B3 で実装)
export 'src/state/error_context.dart';

// M1: Persona (C1 で実装)
export 'src/persona/persona_definition.dart';
export 'src/persona/persona_repository.dart';

// M1: Conversation (D1 で実装)
export 'src/conversation/prompt_template.dart';

// M1: Conversation (D2 で実装)
export 'src/conversation/message_chunk.dart';
export 'src/conversation/conversation_engine.dart';

// M1: Conversation (D3 で実装)
export 'src/conversation/guard.dart';

// M1: Conversation (D4 で実装)
export 'src/conversation/summary_crystal.dart';

// M2: Model (E1 で実装：保存・同期用データモデル)
export 'src/model/sync_metadata.dart';
export 'src/model/theme_input.dart';
export 'src/model/persona_entity.dart';
export 'src/model/persona_snapshot_entity.dart';
export 'src/model/session_entity.dart';
export 'src/model/message_entity.dart';
export 'src/model/guard_event_entity.dart';
export 'src/model/crystal_entity.dart';

// M2: Storage (E2 で実装：ローカル保存基盤)
export 'src/storage/local_store.dart';
export 'src/storage/in_memory_store.dart';

// M3: Sync（最小）
export 'src/sync/sync_models.dart';
export 'src/sync/sync_client.dart';
