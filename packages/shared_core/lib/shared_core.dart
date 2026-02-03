// 共通コア: 状態遷移・会話エンジン・データモデル・同期クライアント

// M0: Schema (A3 で実装済み)
export 'src/schema/version.dart';
export 'src/schema/migration.dart';
export 'src/schema/migrations/migration_0_to_1.dart';

// M0: State (B1 で実装済み)
export 'src/state/session_state.dart';
export 'src/state/session_event.dart';
export 'src/state/session_machine.dart';

// M1: Persona (C1 で実装)
export 'src/persona/persona_definition.dart';
export 'src/persona/persona_repository.dart';

// M1: Conversation (D1 で実装)
export 'src/conversation/prompt_template.dart';

// M1: Conversation (D2 で実装)
export 'src/conversation/message_chunk.dart';
export 'src/conversation/conversation_engine.dart';

// M1以降で実装
// export 'src/models/session.dart';
// export 'src/sync/sync_client.dart';
