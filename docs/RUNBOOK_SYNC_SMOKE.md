# RUNBOOK: Sync smoke (M3-A3b)

## Purpose
Flutter SyncClient が backend の /v1/health /v1/sync/pull /v1/sync/push と疎通できることを確認する。

## What to verify (DoD)
- /v1/health が 200 を返す
- SyncProbe で health→pull→push が完了する

## Prereq
- backend の最小APIが起動できること（backend/README.md 参照）
- Flutter が起動できること（任意のデバイスでOK）

## Commands (example)
### 1) backend 起動 (WSL)
```bash
cd backend
npm install
PORT=8080 npm run dev
```

### 2) health 確認 (WSL)
別ターミナルで:
```bash
curl -sS http://localhost:8080/v1/health
```

### 3) Flutter SyncProbe 実行 (Windows)
```bash
cd apps/dangi_app
flutter run -d windows --dart-define=SYNC_PROBE=true --dart-define=SYNC_BASE_URL=http://localhost:8080
```

## Evidence to paste
- backend の起動ログ（listening 行 / WSL）
- `curl /v1/health` の結果（WSL or Windows）
- Flutter の起動ログに `SYNC_PROBE: health/pull/push completed`（Windows）

## Result template (paste back)
- Health: OK/NG
- SyncProbe: OK/NG
- Logs:

## Troubleshooting (Windows + WSL)
詰まったら `docs/TROUBLESHOOT_WINDOWS_WSL.md` を参照（portproxy / UNC / symlink / 最短Sync smoke）。
