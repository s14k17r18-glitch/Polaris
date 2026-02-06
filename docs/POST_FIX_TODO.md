# POST-FIX TODO（DoD達成後に計画だけ立てる。DoD達成前は編集しない）
- [ ] (例) 気になるファイル: path/to/file  …理由/懸念/影響
- [ ] M1-THEME-ENGINE: 理由=テーマが固定文字列のまま。方針=テーマ入力をSession/Stateに保持しConversationEngineへ注入。影響=発話内容/プロンプトの整合性。
- [ ] M1-ERR-STREAM: 理由=ストリームエラー時の通知/復帰が未実装。方針=M1-B3でエラー復帰導線（SnackBar+ログ+状態遷移）を追加。影響=ユーザー体験/異常時の継続性。
- [ ] M1-THEME-CRYSTAL: 理由=Crystal生成に固定テーマを使用。方針=実テーマをSummaryCrystal.generateCrystalDraftへ渡す。影響=要約/Crystalの正確性。
- [ ] M2-E5-RESTORE-TRANSITION: 理由=履歴復元時の遷移方針が未確定。方針=M2-E5でdiscussion遷移の最小仕様を定義し実装。影響=履歴閲覧時の状態遷移一貫性。
