# RUNBOOK: Launch checks (M0-A4/A5)

## Purpose
Windows/iOS の「起動＋主要遷移が見える」ことを事実で確認し、M0-A4/M0-A5 を完了する。

## What to verify (DoD)
- 起動できる
- 主要遷移が“見た目として”辿れる：
  idle → themeInput → personaSelect → ignition → discussion → convergence → crystallization → dissolution → idle

## Windows (user-run)
### Prereq
- Windows 環境で Flutter が動作
- `flutter doctor` が致命エラー無し

### Commands
1) repoを最新mainにする
2) 初回で `Building with plugins requires symlink support` が出る場合は、Windowsの開発者モードを有効化し、管理者PowerShellで実行する
3) アプリディレクトリで実行：
```bash
cd apps/dangi_app
flutter doctor
flutter devices
flutter run -d windows
```

### Evidence to paste
- `flutter doctor` の要点（エラーがあれば全文）
- `flutter devices` の出力
- `flutter run -d windows` の起動ログ末尾（失敗時はエラー全文）
- 画面遷移の確認結果（できた/できない、止まった画面）

### Latest evidence (M0-A4)
- `Built build\\windows\\x64\\runner\\Debug\\dangi_app.exe`
- `Syncing files to device Windows...`
- `Lost connection to device.`（ユーザー申告: 起動確認済み）

## iOS (user-run on macOS)
### Prereq
- macOS + Xcode
- iOS Simulator or real device
- `flutter doctor` が致命エラー無し

### Commands
```bash
cd apps/dangi_app
flutter doctor
flutter devices
flutter run -d ios
```

（または Xcode で Runner を開いて起動）

### Evidence to paste
- `flutter doctor` / `flutter devices`
- `flutter run -d ios` のログ（失敗時はエラー全文）
- 画面遷移の確認結果

### CI alternative (no macOS)
Macが無い場合は GitHub Actions の iOS build を証跡として採用（M0-A5b）。
Evidence:
- Workflow: `CI iOS (no-codesign)`
- Command: `flutter build ios --no-codesign`
- Success: workflow が成功し、`ios-build` が green

## Result template (paste back)
### Windows result
- OK/NG:
- Stuck at:
- Logs:

### iOS result
- OK/NG:
- Stuck at:
- Logs:

## SyncClient smoke (M3-A3b)
### Prereq
- backend の最小APIが起動できること（`backend/README.md` 参照）

### Commands (example)
```bash
cd backend
npm install
PORT=8080 npm run dev
```

別ターミナルで:
```bash
cd apps/dangi_app
flutter run -d windows --dart-define=SYNC_PROBE=true --dart-define=SYNC_BASE_URL=http://localhost:8080
```

### Evidence to paste
- backend の起動ログ（listening 行）
- Flutter の起動ログに `SYNC_PROBE: health/pull/push completed`
