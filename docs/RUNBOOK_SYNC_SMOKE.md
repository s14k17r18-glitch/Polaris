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
### 1) backend 起動
```bash
cd backend
npm install
PORT=8080 npm run dev
```

### 2) health 確認
別ターミナルで:
```bash
curl -sS http://localhost:8080/v1/health
```

### 3) Flutter SyncProbe 実行
```bash
cd apps/dangi_app
flutter run -d windows --dart-define=SYNC_PROBE=true --dart-define=SYNC_BASE_URL=http://localhost:8080
```

## Evidence to paste
- backend の起動ログ（listening 行）
- `curl /v1/health` の結果
- Flutter の起動ログに `SYNC_PROBE: health/pull/push completed`

## Result template (paste back)
- Health: OK/NG
- SyncProbe: OK/NG
- Logs:

## Notes (Windows/WSL gotchas)
- Windows から WSL backend に `localhost:8080` で到達できない場合は、WSL IP を確認して portproxy で中継する（管理者PowerShell）:
  - `$WSL_IP = (wsl.exe -d Ubuntu -- hostname -I).Trim().Split(' ')[0]`
  - `netsh interface portproxy add v4tov4 listenport=8080 listenaddress=127.0.0.1 connectport=8080 connectaddress=$WSL_IP`
  - `curl.exe -sS http://127.0.0.1:8080/v1/health`
- Windows デスクトップビルドを `\\wsl$`（UNC/ネットワーク扱い）上で実行すると、`.plugin_symlinks` 作成が `ERROR_INVALID_FUNCTION` で失敗することがある。
  - 回避：Windowsローカル（例: `C:\\src\\Polaris`）に repo を clone して `apps/dangi_app` から `flutter run -d windows ...` を実行する。
- UNCパス上では `cmd.exe` が作業ディレクトリを保持できず `No pubspec.yaml` になる場合がある。上記の Windowsローカル clone で回避する。
