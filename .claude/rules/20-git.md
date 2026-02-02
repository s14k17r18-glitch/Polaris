# skill_git.md（Git/GitHub運用）
Claude Code に Git/GitHub 操作を任せるための安全ルール。

---

## ブランチ
- main直push禁止
- `feature/<M#>-<topic>` で作る
  - 例：`feature/M0-repo-skeleton` / `feature/M1-turn-streaming`

---

## コミット粒度
- 1コミット1目的（動く単位）
- コミット前に必ず確認：
  - `git status`
  - `git diff`
- 破壊的変更（スキーマ/マイグレーション）はコミットを分ける

---

## PRテンプレ（本文に貼る）
### 対応したチェック項目
- [ ] （例）M1: D2 ターン生成（ストリーミング表示）

### 変更概要
- 

### テスト結果
- Windows起動：OK/NG（手順も）
- iOS起動：OK/NG（手順も）
- 自動テスト：OK/NG（実行コマンド）

### 影響範囲
- data model / sync / UI / docs

### 既知の制限
- 

### 次の手
- 

---

## 禁止
- `git push --force` 禁止
- 勝手なrebase/履歴改変禁止
- 大量変更を1PRに詰めない（レビュー不能になる）

---

## 推奨コマンド例
- ブランチ作成：`git checkout -b feature/M1-xxx`
- 変更確認：`git status` / `git diff`
- コミット：`git commit -m "M1: xxxx"`
- push：`git push -u origin feature/M1-xxx`
