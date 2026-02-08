# contracts/
M3同期の契約（OpenAPI/JSON Schema）を固定する場所。実装より先にここを更新する。

## Source of truth
- docs/12_SYNC_API_SPEC.md（同期APIの唯一の正）
- contracts/openapi.yaml（エンドポイント/入出力）
- contracts/schemas/*.json（エンティティ最小スキーマ）

## Update policy
- 契約変更は docs と contracts を同時更新する。
- 互換性が壊れる変更は明記し、MVP範囲外なら実装しない。

## Versioning
- 形式: date-based（YYYY.MM.DD）。
- openapi.yaml の info.version に反映する。

## Append-only representation
- record_version は `rev` を採用する。
- event_id は未定義（unknown）。

## Validation (later)
- OpenAPI/JSON Schema の検証ツールは後続タスクで選定する（現時点は不明）。
