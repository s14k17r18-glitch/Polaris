# Troubleshooting: Windows + WSL (Polaris)

このドキュメントは「詰まったときに最短で復旧する」ための手順です。
Windows PowerShellでの実行はユーザーが行い、WSL内の作業はCodexが行う想定。

## 1) Windowsから backend (WSL) の `localhost:8080` に繋がらない
### まずWSL内で backend が生きているか
(WSL)
- `curl -sS http://localhost:8080/v1/health`

### Windowsから到達確認
(Windows)
- `curl.exe -sS http://127.0.0.1:8080/v1/health`

### 繋がらない場合: portproxy で中継（管理者PowerShell）
(Windows)
- `$WSL_IP = (wsl.exe -d Ubuntu -- hostname -I).Trim().Split(' ')[0]`
- `netsh interface portproxy add v4tov4 listenport=8080 listenaddress=127.0.0.1 connectport=8080 connectaddress=$WSL_IP`
- `netsh interface portproxy show v4tov4`
- `curl.exe -sS http://127.0.0.1:8080/v1/health`

### 後片付け（不要になったら）
(Windows)
- `netsh interface portproxy delete v4tov4 listenport=8080 listenaddress=127.0.0.1`

## 2) `\\wsl$` 上で `flutter run -d windows` が失敗する（UNC / No pubspec.yaml）
原因: cmd.exe がUNCを作業ディレクトリにできず、カレントが飛ぶことがある。
対策: Windowsローカルに clone して実行する（推奨）。

(Windows)
- `mkdir C:\\src -ErrorAction SilentlyContinue`
- `cd C:\\src`
- `git clone https://github.com/s14k17r18-glitch/Polaris.git`
- `cd C:\\src\\Polaris\\apps\\dangi_app`

## 3) symlink失敗（ERROR_INVALID_FUNCTION / .plugin_symlinks）
原因: `\\wsl$` やネットワーク扱いのドライブ上で Windows ビルドすると symlink が失敗し得る。
対策: 2) と同じく Windowsローカルでビルドする。

## 4) Sync smoke（Windows）最短チェック
前提: backend が `http://127.0.0.1:8080` で health ok を返すこと。

(Windows)
- `curl.exe -sS http://127.0.0.1:8080/v1/health`
- `flutter pub get`
- `flutter run -d windows --dart-define=SYNC_PROBE=true --dart-define=SYNC_BASE_URL=http://127.0.0.1:8080`
期待ログ:
- `SYNC_PROBE: health/pull/push completed`

## 5) Codexが破壊操作をブロックする場合（branch削除/force push）
運用方針:
- force push を避け、新コミットで積む
- ブランチ削除が必要なら、ユーザーが手動実行する
