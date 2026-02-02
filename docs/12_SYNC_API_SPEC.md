# 12_SYNC_API_SPEC.md
M3（同期）のための“契約”。これがない同期実装は禁止。
※ 技術スタックが未確定でも実装できるよう、APIとデータ契約を抽象化して定義する。

---

## 前提
- 同期対象：Persona / PersonaSnapshot / Session / Message / Crystal（07_DATA_MODEL.md に準拠）
- すべての同期対象エンティティは以下のメタデータを持つ：
  - schema_version, owner_user_id, updated_at, rev, deleted_at, device_id

---

## 用語
- **rev**：更新リビジョン（単調増加が望ましい）。サーバが権威（推奨）。
- **tombstone**：deleted_at が入った論理削除レコード。同期で必ず伝播する。
- **cursor**：差分取得のためのトークン。サーバが発行する。

---

## 認証
- すべての同期APIは認証必須
- ヘッダ例：`Authorization: Bearer <token>`
- MVPでは「匿名＋端末紐付け」でも良いが、owner_user_id が確定していることが条件

---

## 同期の基本フロー（推奨）
1) ローカル変更を **Push**
2) サーバ差分を **Pull**
3) 競合が返ってきた場合は、クライアントがログに残し、決められた規則で解決

---

## エンドポイント（例：REST）
### 1) Pull（差分取得）
`GET /sync/pull?cursor=<cursor>&limit=<n>`

#### レスポンス（例）
```json
{
  "next_cursor": "string|null",
  "server_time": "2026-01-30T12:34:56Z",
  "changes": [
    {
      "entity": "persona|persona_snapshot|session|message|crystal",
      "op": "upsert|delete",
      "id": "string",
      "rev": "string|number",
      "updated_at": "ISO",
      "deleted_at": "ISO|null",
      "payload": { "..." }
    }
  ]
}
```

- cursor が null の場合は初回フル同期（サーバは適切に分割して返す）
- delete の場合も payload は空でよいが、id/rev/updated_at/deleted_at は必須

---

### 2) Push（差分送信）
`POST /sync/push`

#### リクエスト（例）
```json
{
  "client_time": "ISO",
  "mutations": [
    {
      "entity": "persona|persona_snapshot|session|message|crystal",
      "op": "upsert|delete",
      "id": "string",
      "base_rev": "string|number|null",
      "updated_at": "ISO",
      "deleted_at": "ISO|null",
      "payload": { "..." }
    }
  ]
}
```

- base_rev：クライアントが把握している直前のサーバrev（不明ならnull）
- サーバは owner_user_id を検証し、他人のデータ更新を拒否する

#### レスポンス（例）
```json
{
  "accepted": [
    { "entity": "session", "id": "xxx", "rev": "new_rev", "updated_at": "server_time" }
  ],
  "conflicts": [
    {
      "entity": "session",
      "id": "xxx",
      "reason": "rev_mismatch|schema_mismatch|validation_failed",
      "server_record": { "rev": "srv", "updated_at": "ISO", "deleted_at": null, "payload": { "..."} },
      "client_record": { "base_rev": "cli", "updated_at": "ISO", "deleted_at": null, "payload": { "..."} }
    }
  ]
}
```

---

## 競合ルール（MVP）
- **基本**：LWW（Last Write Wins）
  - updated_at が新しい方を採用
  - 同一時刻の場合は rev が新しい方
- **追記マージ対象（append-only）**：
  - Message は append-only とみなし、同一session_id内で「未存在のmessage_id」を追加する
  - 既存Messageの書き換えは原則禁止（編集機能はMVP外）
- **tombstone**：
  - deleted_at がある場合、その時点以降の upsert より優先（復活はMVP外）
- **ログ**：
  - conflicts は必ずローカルに記録し、後で追跡できる形にする（ユーザー可視は不要）

---

## オフライン復帰
- 端末はローカルに変更をため、通信復帰時に push→pull を行う
- pull の cursor はローカルに保存し、次回以降の差分取得に使う

---

## 互換性（schema_version）
- schema_version が異なるレコードを受け取った場合：
  - 可能なら migration して保存
  - 不可能なら conflicts 扱いにして保持（ログに残す）
