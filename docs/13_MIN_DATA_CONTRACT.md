# 13_MIN_DATA_CONTRACT.md
M3（同期）の前提として、ID設計・append-only・tombstone を最小契約として固定する。
空欄は禁止し、不明点は「不明」と明記する。

## 対象エンティティ（同期対象）
- Session（session_id）
- Message（message_id）
- Crystal（crystal_id）
- Persona（persona_id）
- PersonaSnapshot（snapshot_id）

## ID設計
- entity_id（session_id/message_id/crystal_id/persona_id/snapshot_id）: UUIDv7（文字列、小文字ハイフン区切り）。クライアント生成で一意にする。
- 選定: UUIDv7 を採用（時系列ソート可能、RFC化が進んでおり標準化に近い）。ULID は候補だが本契約では採用しない。
- owner_user_id: 所有者アカウントID（文字列）。形式は不明（opaque）だが空は禁止。
- device_id: 端末ID（文字列）。現状は UUIDv4 を採用（Evidence 参照）。
- owner_user_id は所有者、device_id は端末を表し、M3の認可/競合解決で参照する。
- rev: 更新リビジョン（文字列/数値）。サーバが権威。生成方式は不明。
- updated_at / deleted_at / created_at: ISO 8601 文字列。

## Append-only 原則
- 既存レコードの上書きは行わず、新バージョンを追記する。
- ローカル保存は JSON Lines の追記を正とし、最新状態は updated_at / rev で決定する。
- Message は append-only を厳守（編集・上書きはMVP外）。

## Tombstone（論理削除）
- delete は deleted_at を持つ tombstone レコードとして追記する。
- tombstone は同一 entity_id の upsert より常に優先（復活はMVP外）。
- 同期で必ず伝播し、復元はしない。

## Versioning
- schema_version を全レコードに必須とする。
- 異なる schema_version は migration 可能なら変換、不可なら conflicts として保持（ログ）。

## Conflict rules（MVP最小）
- LWW（Last Write Wins）: updated_at が新しい方を採用。
- updated_at が同一なら rev が新しい方を採用。
- それでも決着しない場合は server 記録を優先し、conflict をログに残す。
- Message は append-only のため、同一 session_id 内で未存在 message_id のみ追加する。

## Evidence（既存実装参照）
- Sync metadata: `packages/shared_core/lib/src/model/sync_metadata.dart`
- Entities: `packages/shared_core/lib/src/model/session_entity.dart`, `packages/shared_core/lib/src/model/message_entity.dart`, `packages/shared_core/lib/src/model/crystal_entity.dart`, `packages/shared_core/lib/src/model/persona_entity.dart`, `packages/shared_core/lib/src/model/persona_snapshot_entity.dart`
- Local store（append-only / tombstone）: `apps/dangi_app/lib/storage/file_local_store.dart`
- device_id 生成: `apps/dangi_app/lib/auth/auth_repository.dart`（UUIDv4）
