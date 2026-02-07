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
