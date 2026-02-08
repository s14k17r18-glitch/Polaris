# backend

API / DB / migrations

## 役割

- Auth（ユーザー識別）
- Sync API（差分同期・競合戦略）
- DB（クラウド永続化）
- LLM API プロキシ（キー漏洩防止）

## 契約遵守

- **12_SYNC_API_SPEC.md 準拠**（M3で実装）
- **08_ARCHITECTURE.md 準拠**（LLM呼び出しはバックエンド経由）

## ディレクトリ構成（M3最小）

```
backend/
  src/                   # API最小実装（health / sync push / sync pull）
  .data/                 # ローカル最小ストア（append-only）
```

## 起動（ローカル最小）
- `cd backend`
- `npm install`
- `PORT=8081 npm run dev`
- `curl http://localhost:8081/v1/health`
- `curl -X POST http://localhost:8081/v1/sync/pull -H 'content-type: application/json' -d '{\"cursor\":null,\"limit\":10}'`

## M3 実装状況

- 最小API（health / sync push / sync pull）まで実装
