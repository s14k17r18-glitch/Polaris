# 14_BACKEND_STACK_DECISION.md
M3の前提として「Backend stack（何をどこで動かすか）」を決定する。
空欄は禁止し、不明点は「不明」と明記する。

## Decision
TypeScript（Node 20） + Fastify + Zod（OpenAPI生成） + Cloud Run + Firestore を採用する。

## Why
- WSL開発とテストの体験が軽く、Fastify + ZodでOpenAPI固定がしやすい。
- append-only / tombstone を Firestore のドキュメント＋履歴で素直に表現できる。
- Vertex AI（service account）連携の公式SDKが整備されており、LLM proxy 実装が安定する。

### 捨てた理由
- B（Python/FastAPI）: 型・OpenAPIの一貫性が弱く、WSLでの依存管理が重め。
- C（Go）: 生成/運用は堅いが、OpenAPIと開発速度の両立で初期コストが高い。

## 比較（A/B/C）
| 観点 | A: TS + Fastify + Zod | B: Python + FastAPI + Pydantic | C: Go + Chi/Fiber |
| --- | --- | --- | --- |
| WSL開発/テスト | ◎ | ○ | △ |
| OpenAPI固定 | ◎（Zod→OpenAPI） | ○ | △（追加設計が必要） |
| Sync実装の素直さ | ○ | ○ | ○ |
| Vertex AI相性 | ◎ | ○ | ○ |
| 運用/コスト | ○ | ○ | ◎ |
| SSE対応 | ◎ | ○ | ○ |

## Runtime / Hosting
- Hosting: Cloud Run（GCP）。
- Runtime: Node 20。
- ローカル起動手順: 不明（決定後に明文化）。

## Data store
- Firestore を採用。
- append-only は履歴ドキュメント（例: `messages_history`）として追記し、最新状態は `updated_at` / `rev` で決定。
- tombstone は `deleted_at` を持つレコードとして保存し、復活はMVP外。

## Auth
- すべての同期APIは `Authorization: Bearer <token>` を必須（12_SYNC_API_SPEC準拠）。
- トークン発行方式は不明（MVPでは匿名＋端末紐付けの最小構成を許容）。

## API style
- REST + OpenAPI 固定。
- Sync API は `docs/12_SYNC_API_SPEC.md` を唯一の正とする。

## LLM proxy
- 本番: Vertex AI（service account）を backend から呼び出す。
- ローカル試作: Google AI API key を backend 環境変数で使用（クライアントに秘密は置かない）。

## Observability
- Cloud Run の構造化ログを最低限の標準とする。
- メトリクスの詳細設計は不明（必要なら後続タスクで決定）。

## Out of scope
- 自動Web検索、音声クローン、3D表示などはMVP外（00_MVP_SCOPE_LOCK準拠）。

## Next single action
- `contracts/` に OpenAPI / JSON Schema の最小ひな形を固定する（M3-A2）。
