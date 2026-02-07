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
2) アプリディレクトリで実行：
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

## Result template (paste back)
### Windows result
- OK/NG:
- Stuck at:
- Logs:

### iOS result
- OK/NG:
- Stuck at:
- Logs:
