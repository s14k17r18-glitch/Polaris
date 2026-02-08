### [2026-02-07 01] Q/A
Q: mainマージ後、M0-A1/A2/A3（iOS shell追加＋verify）を進める。
A:
- `apps/dangi_app/ios/` 不在を確認し、M0-A1を事実で完了。
- `flutter create --platforms=ios .` を実行し、iOS shellを生成してM0-A2を完了。
- `melos run verify` は `NoScriptException`（verify未定義）で失敗し、M0-A3は未完了。
- `docs/PROGRESS_CHECKLIST.md` は A1/A2 を `[x]`、A3 は `[ ]` のまま更新。
Meta: branch=feature/M0-add-ios-shell commit=32c081e test=melos run verify (fail: NoScriptException)
Park: `melos run verify` 未定義のため再現性を確保できない。次回は verify スクリプト定義後に再実行する。
Next: `melos.yaml` に `verify` スクリプト（bootstrap+analyze+test）を定義して M0-A3 を再実行する。

### [2026-02-07 02] Q/A
Q: melos run verify が未定義で失敗する件を修正し、M0-A3を完了する。
A:
- 原因は `melos run` が `workspace pubspec.yaml` の scripts を参照し、`verify` 未定義だったこと。
- `melos.yaml` に verify を追加し、`pubspec.yaml` の `melos.scripts` も整備して実行経路を統一。
- analyze/test はWSL実行可能な実コマンド（app: `flutter test` / core: `dart test`）へ最小修正。
- `melos run verify` が完走し、`docs/PROGRESS_CHECKLIST.md` の M0-A3 を `[x]` に更新。
Meta: branch=feature/M0-add-ios-shell commit=d38e208 test=melos run verify (pass)
Park: `melos bootstrap` が 0 packages 表示のままのため、workspace解決方式の統一は別タスクで見直す。
Next: 既存PR `feature/M0-add-ios-shell` に本コミットを積んでレビュー依頼する。

### [2026-02-07 03] Q/A
Q: M0-A4/A5 の実行準備として、Windows/iOS起動確認のRunbookを整備し、チェック更新可能な状態を作る。
A:
- `docs/RUNBOOK_LAUNCH_CHECKS.md` を新規作成し、Windows/iOSそれぞれの前提・コマンド・期待証跡を固定。
- 主要遷移（idle→...→idle）の確認観点と、結果貼り戻しテンプレートを明文化。
- `docs/PROGRESS_CHECKLIST.md` の M0-A4/M0-A5 は実測前のため `[ ]` のまま維持。
- ユーザーがRunbook実行結果を貼れば、そのままA4/A5の完了判定へ進める状態にした。
Meta: branch=feature/M0-launch-checks commit=d514f9f test=docs update only
Park: なし
Next: ユーザーが Windows/iOS の実行ログを Runbook 形式で共有する。

### [2026-02-07 04] Q/A
Q: Windows起動確認ログを受領し、M0-A4を完了としてdocs更新する。
A:
- `flutter run -d windows` の証跡（Built/Syncing/Lost connection）とユーザー申告「起動確認済み」を事実として採用。
- `docs/PROGRESS_CHECKLIST.md` の M0-A4 を `[x]` に更新し、M0-A5 は `[ ]` のまま維持。
- `docs/RUNBOOK_LAUNCH_CHECKS.md` に symlink権限対策（開発者モード + 管理者PowerShell）を追記。
- Windows実行時の最新証跡をRunbookへ残し、次回の再現手順を固定。
Meta: branch=feature/M0-launch-checks commit=18a23b2 test=docs update only
Park: 通常権限PowerShellでは symlink 要件で失敗するため、Windows起動確認は管理者PowerShell実行を標準手順として維持する。
Next: iOSのRunbook実行ログをユーザーが共有する。

### [2026-02-07 06] Q/A
Q: Mac無しのiOS build証跡をCIで確保するため、workflowとrunbook/チェックを追加する。
A:
- GitHub Actions に iOS build（no-codesign）のworkflowを追加（macos-14）。
- `docs/PROGRESS_CHECKLIST.md` に M0-A5b を追加し、未完了のまま維持。
- `docs/RUNBOOK_LAUNCH_CHECKS.md` に CI代替手順と証跡条件を追記。
- PR作成後にCIの完了を待ち、green確認でM0-A5bを更新する前提を明文化。
Meta: branch=feature/M0-ci-ios-build commit=TBD test=CI iOS (no-codesign) pending
Park: なし
Next: PRのCIがgreenになったらM0-A5bを[x]に更新してamendする。

### [2026-02-07 07] Q/A
Q: CI iOS build（no-codesign）がgreenになったため、M0-A5bを完了扱いに更新する。
A:
- PRのGitHub Actions（CI iOS no-codesign）が成功し、証跡が残ったことを確認。
- `docs/PROGRESS_CHECKLIST.md` の M0-A5b を `[x]` に更新。
- `docs/RUNBOOK_LAUNCH_CHECKS.md` のCI代替手順を維持し、M0-A5は未実施のまま。
- 1コミット維持のため amend + force-with-lease で反映する。
Meta: branch=feature/M0-ci-ios-build commit=amended test=CI iOS (no-codesign) pass
Park: なし
Next: iOS起動確認（M0-A5）を実施してログを共有する。

### [2026-02-08 17] Q/A
Q: M3前提のデータ最小契約（ID/append-only/tombstone）をdocsとコードに照合して固定する。
A:
- docs/13_MIN_DATA_CONTRACT.md を新規作成し、ID設計（UUIDv7）、append-only、tombstone、競合/版本ルールを固定。
- 既存コードの SyncMetadata / Entity / FileLocalStore を根拠に、矛盾なしとして記述（証跡パスを明記）。
- docs/PROGRESS_CHECKLIST.md に M3-A0 を追加し、DoD達成として [x] に更新。
- 変更は docs/handoff を含むドキュメントのみで実施。
Meta: branch=feature/M3-min-data-contract commit=TBD test=docs update only
Park: なし
Next: PRを作成してレビュー依頼する。

### [2026-02-08 17] Q/A
Q: M3-A1としてBackend stackを決定し、docsに固定してチェックリストを更新する。
A:
- TypeScript(Node 20)+Fastify+Zod(OpenAPI)+Cloud Run+Firestore を採用決定として `docs/14_BACKEND_STACK_DECISION.md` を追加。
- 候補A/B/Cを比較し、WSL開発性・OpenAPI固定・Vertex連携の観点でAを採用と明記。
- `docs/MASTER_PLAN.md` の不明項目を決定内容で更新。
- `docs/PROGRESS_CHECKLIST.md` の M3-A1 を [x] に更新。
Meta: branch=feature/M3-backend-stack-decision commit=TBD test=docs update only
Park: なし
Next: `contracts/` に OpenAPI/JSON Schema の最小ひな形を固定する（M3-A2）。

### [2026-02-08 17] Q/A
Q: M3-A2として contracts/ に OpenAPI と JSON Schema の最小ひな形を固定する。
A:
- `contracts/openapi.yaml` を追加し、/v1/sync/push・/v1/sync/pull・/v1/health の最小定義を固定（docs/12 も同名に更新）。
- `contracts/schemas/*.json`（session/message/crystal/persona/persona_snapshot/tombstone/common）を追加し、ID/metadata/tombstone を最小契約で明文化。
- `contracts/README.md` に契約の正・更新方針・versioningを明記。
- `docs/MASTER_PLAN.md` と `docs/PROGRESS_CHECKLIST.md` を更新し、M3-A2を完了扱いに反映。
Meta: branch=main commit=a3412f1 test=docs/contracts update only
Park: なし
Next: M3-A3（Sync push/pull 最小実装）の着手準備を整理する。

### [2026-02-08 18] Q/A
Q: M3-A3aとしてcontracts準拠のSync push/pull最小実装をbackendに追加し、LOG_QAのMetaを確定する。
A:
- backendに Fastify + TS の最小サーバ（/v1/health, /v1/sync/push, /v1/sync/pull）とappend-onlyストアを追加。
- contracts/openapi.yaml と docs/12 のエンドポイントに合わせた入出力で疎通可能にした。
- `docs/PROGRESS_CHECKLIST.md` に M3-A3a/A3b を追加し、A3a を完了扱いに更新。
- `docs/handoff/LOG_QA.md` の M3-A2 エントリ Meta を commit=a3412f1 で修正。
Meta: branch=main commit=6027cf8 test=backend curl smoke
Park: Firestore/認証の本格導入は後タスク（最小ストアで仮実装）。
Next: Flutter側の SyncClient 疎通（M3-A3b）に着手する。

### [2026-02-08 18] Q/A
Q: M3-A3bとしてshared_coreにSyncClientを追加し、backendと疎通できる導線を整備する。
A:
- shared_coreにSyncClientとモデルを追加し、contractsと整合するpush/pullを実装。
- dangi_appにSYNC_PROBEの隠し導線を追加し、Runbookに手動疎通手順を追記。
- LOG_QAのPR #9 Metaをcommit=6027cf8に更新。
- melos run verify が pass し、PROGRESS_CHECKLIST の M3-A3b を [x] に更新。
Meta: branch=feature/M3-syncclient-wireup commit=HEAD test=melos run verify (pass)
Park: なし
Next: SyncClient の本接続（Auth/Firestore）前提を整理する。

### [2026-02-08 19] Q/A
Q: Runbookに沿って Windows で Sync smoke（health→pull→push）の証跡を取得し、再現手順を確定する。
A:
- Windows→backend は portproxy（127.0.0.1:8080→WSL_IP:8080）で到達性を確保し、`curl.exe http://127.0.0.1:8080/v1/health` で 200 を確認。
- `\\wsl$`（UNC/ネットワーク扱い）上の `flutter run -d windows` は symlink/作業ディレクトリ問題で失敗するため、Windowsローカル `C:\\src\\Polaris` に clone して実行。
- `flutter run -d windows --dart-define=SYNC_PROBE=true --dart-define=SYNC_BASE_URL=http://127.0.0.1:8080` を実行し、`SYNC_PROBE: health/pull/push completed` を取得。
- これにより M3-A3b の疎通証跡（Runbook通り）が揃った。
Meta: branch=main commit=69ac97e test=windows sync probe (health/pull/push) ok
Park: なし
Next: M0-A5 iOS起動確認（ユーザー実施） / DoD: iOSで起動し主要遷移が見える

### [2026-02-08 20] Q/A
Q: M0-A5（iOS起動確認）を実施できない前提で、Runbook/Checklist/LOGを整合させる。
A:
- iOS実機/Simulatorが無い場合は M0-A5 を未実施のまま維持し、勝手に [x] にしない方針を明記。
- 代替の証跡は M0-A5b（CI no-codesign）を採用し、実機入手後に M0-A5 を実施する流れを固定。
- `docs/RUNBOOK_LAUNCH_CHECKS.md` に “no macOS/no device” の方針と最短実行手順を追記。
- Checklist の M0-A5 は未完了、M0-A5b は完了という現状と整合する。
Meta: branch=main commit=3cf9e9d test=docs update only
Park: なし
Next: M0-A5 iOS起動確認（ユーザー実施） / DoD: iOSで起動し主要遷移が見える

### [2026-02-08 21] Q/A
Q: 次へ進む前に、Windows/WSL で発生した問題を把握し、再発防止の“解決手順”として docs に固定する。
A:
- Windows→WSL backend 到達（localhost/8080）、UNCパス起因の `pubspec.yaml not found`、symlink（`.plugin_symlinks`）失敗など、詰まりポイントを整理。
- `docs/TROUBLESHOOT_WINDOWS_WSL.md` に症状/原因/対策/確認コマンドを集約し、portproxy の追加/削除（後片付け）まで手順化。
- `docs/RUNBOOK_SYNC_SMOKE.md` からトラブルシュート文書へ誘導を追加し、Runbookの二重管理を避けた。
- 次回以降は「ユーザー=Windows PowerShell実行 / Codex=WSL内作業」を前提に復旧可能。
Meta: branch=main commit=8e22c24 test=docs troubleshoot guide
Park: なし
Next: M0-A5 iOS起動確認（ユーザー実施） / DoD: iOSで起動し主要遷移が見える
