# PROGRESS CHECKLIST（Polaris / DanGi）
運用ルール：
- 1項目は「ID / チェック / 1行説明 / DoD(短く)」で書く
- 終わったら [x] にする（削除しない）
- 追加工程は該当フェーズ末尾に追記してOK
- Nextは常に「未完の中で次にやる1つ」を選ぶ

## M0（基盤・パリティ前提）
- [x] M0-A1 iOS Shell の有無確認（apps/dangi_app/ios/） / DoD: 有無が事実で書ける
- [x] M0-A2 iOS Shell 追加（生成のみ） / DoD: apps/dangi_app/ios/ が作成され差分確認済み
- [x] M0-A3 verify（WSL）完走 / DoD: melos run verify がpass
- [x] M0-A4 Windows起動確認（管理者PowerShellで `flutter run -d windows` 起動確認） / DoD: windowsで起動し主要遷移が見える
- [x] M0-A5b iOS build（CI / no-codesign） / DoD: GitHub Actionsの iOS build が成功（ログが残る）
- [ ] M0-A5 iOS起動確認（ユーザー実施） / DoD: iOSで起動し主要遷移が見える

## M1（談議縦スライス完走）
- [ ] M1-A1 テーマ入力値をUI→Engineへ注入 / DoD: 固定文字列でない
- [ ] M1-A2 personaSelect 最小実装 / DoD: 遷移が成立し議論へ入れる
- [ ] M1-A3 Ritual→Ending 完走（両OS） / DoD: 想定フローが通る

## M2（保存＋再現）
- [ ] M2-A1 export/import 仕様確認（docs） / DoD: 仕様が確定 or 不明点が列挙
- [ ] M2-A2 export/import 実装 / DoD: ファイル出力/入力が動く
- [ ] M2-A3 履歴→復元が破綻しない / DoD: 主要ケースでOK

## M3（同期＋Backend＋LLM Proxy）
- [ ] M3-A1 Backend stack 決定 / DoD: 言語/ホスト/認証方針が決定
- [ ] M3-A2 contracts(OpenAPI/Schema) 整備 / DoD: docsに契約が固定
- [ ] M3-A3 Sync push/pull 最小実装 / DoD: 片方向でも同期できる
- [ ] M3-A4 競合ログ/オフライン復帰 / DoD: 壊れず復帰できる
- [ ] M3-A5 LLM Proxy 統合（Gemini方式はDecision Pending可） / DoD: クライアントに秘密無しで呼べる
