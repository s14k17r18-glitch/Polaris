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
