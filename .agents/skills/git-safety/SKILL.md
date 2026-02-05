---
name: git-safety
description: Git/GitHub 操作の安全ルール。main直push禁止、force禁止、featureブランチ運用。git/PR/branch
---
# Purpose
Git操作で履歴破壊やレビュー困難を防ぎ、安全に変更を届けるための運用ルールを徹底する。

# When to use
- ブランチ作成、コミット、push、PR作成を行うとき
- Git運用手順を決めるとき

# When NOT to use
- Git操作をしない純粋な読み取り作業のとき

# Procedure
1. `feature/<M#>-<topic>` のブランチを作成する。
2. 変更確認は `git status` と `git diff` を必ず行う。
3. 1コミット1目的でコミットする。
4. push して PR を作成する。

Checklist:
- [ ] `main` 直push禁止
- [ ] `git push --force` 禁止
- [ ] PR本文にチェック項目/テスト結果/影響範囲/既知の制限を書く

# Constraints
- 履歴改変（rebase等）を勝手にしない。
- 大量変更を1PRに詰めない。

# Output expectations
- 使用したブランチ名
- 実行したGitコマンドの要約
- PR作成の有無と次の手

# Sources
- Derived from: `.claude/rules/20-git.md`
