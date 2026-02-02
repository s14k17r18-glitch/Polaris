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

## ディレクトリ構成（M3で作成予定）

```
backend/
  api/                   # API実装
  db/                    # DB接続・マイグレーション
  auth/                  # 認証
  llm/                   # LLM API プロキシ
  migrations/            # スキーマ変更履歴
```

## M0 実装状況

- ⏳ 空フォルダ（M3で実装予定）
