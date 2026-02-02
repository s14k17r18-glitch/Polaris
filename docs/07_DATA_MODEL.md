# 07 データモデル（保存・同期）

## 目的
- セッションを再現できる
- Windows/iOS間で全データ共有できる
- Personaやルールが変わってもログは壊れない（バージョニング＋移行）
- 競合が起きても破綻しない（最低限の衝突戦略）

---

## 最重要：バージョンと同期メタデータ（必須）
すべての同期対象エンティティに以下を持たせる（MVPから必須）。

- `schema_version`：データスキーマの版（例：1）
- `owner_user_id`：所有者（アカウント）
- `updated_at`：更新時刻（ISO）
- `rev`：更新リビジョン（整数 or UUID）
- `deleted_at`：削除（tombstone）時刻（未削除ならnull）
- `device_id`：更新した端末（任意だが推奨）


同期APIの具体（Pull/Push/競合レスポンス）は `12_SYNC_API_SPEC.md` を唯一の正とする。
---

## エンティティ
### Persona（定義）
- persona_id
- owner_user_id
- version（persona定義の版）
- definition_json（03のスキーマ）
- schema_version, updated_at, rev, deleted_at

### PersonaSnapshot（セッション時点の固定）
- snapshot_id
- session_id
- persona_id
- persona_version
- definition_json（当時の定義をコピー）
- schema_version, updated_at, rev, deleted_at

### Session
- session_id
- owner_user_id
- created_at
- theme
- constraints（任意）
- participants（persona_id配列＋席順）
- moderator_persona_id
- rounds_max
- ended_reason（user_action / rounds_max / error）
- schema_version, updated_at, rev, deleted_at

### Message
- message_id
- session_id
- owner_user_id
- turn_index
- speaker_type（persona/user/moderator/system）
- speaker_id
- text
- created_at
- tags（任意）
- guard_flags（任意）
- schema_version, updated_at, rev, deleted_at

### GuardEvent
- event_id
- session_id
- owner_user_id
- turn_index
- type（slander/dogmatism/deviation）
- target_speaker_id
- action（warn/rewrite/eject）
- note（moderatorの指示）
- schema_version, updated_at, rev, deleted_at

### Crystal（成果物）
- crystal_id
- session_id
- owner_user_id
- summary_text
- heat_score（0-1）
- color（enum: red/blue/...）
- created_at
- schema_version, updated_at, rev, deleted_at

---

## 同期戦略（MVPの現実解）
MVPでは「複雑な同時編集」を避け、破綻しない最小戦略を採用する。

- persona定義：
  - 編集は「明示保存」で確定
  - 競合時：`updated_at` が新しい方を採用（LWW: Last Write Wins）
  - ただし競合発生ログは残す（後でUIに出せるように）

- session/message：
  - セッション中のメッセージは基本“追記”で増える（競合が起きにくい）
  - 競合時：message_id単位でマージ（同一id衝突は新rev優先）

- 削除：
  - tombstone（deleted_at）で削除を共有（即時物理削除しない）

---

## 保存戦略（MVP）
- ローカル：SQLite（推奨）もしくは端末ストレージ
- クラウド：DB + Sync API（必須）
- エクスポート：JSON（Session/Message/Crystal/Persona/Snapshot）

---

## JSON例（Sessionまとめ）
```json
{
  "schema_version": 1,
  "owner_user_id": "u_001",
  "device_id": "d_win_01",
  "rev": "r_100",
  "updated_at": "2026-01-30T00:00:00Z",
  "deleted_at": null,
  "session": {"session_id": "s_001", "theme": "〜", "created_at": "2026-01-30T00:00:00Z"},
  "participants": [{"persona_id": "p1", "seat": 0}],
  "messages": [{"message_id":"m1","speaker_type":"persona","speaker_id":"p1","turn_index":0,"text":"..."}],
  "crystal": {"crystal_id":"c1","summary_text":"...","heat_score":0.7,"color":"red"}
}
