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
