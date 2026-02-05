---
name: handoff-memory
description: 引き継ぎ/次スレ/スレッド切替/前回の続き/再開/続きから/『覚えてる？』『覚えてますか？』『前の話わかる？』のような質問が来たら、docs/HANDOFF.md と docs/handoff/LOG.md から状況を復元して短く回答する。
---
# Purpose
長時間のバイブコーディングやスレッド切替でコンテキストが圧迫されても、作業の連続性を失わない。
「最後にまとめる」を避け、短い“増分要約”を積み上げ、必要に応じて“現状スナップショット”へ統合する。

# When to use
## Trigger phrases (implicit invocation)
- 覚えてる？ / 覚えてますか？
- 前回の続き
- 次スレで続けよう
- さっきの話に戻る
- 何をやってたっけ？
- 状況まとめて

- ユーザーが「引き継ぎ」「次スレ」「続き」「再開」「まとめて」「忘れたくない」と言ったとき
- セッションが長い/話題が増えてきた/前半が埋もれそうなとき
- 仕様決定・設計判断が入った直後
- コミット前後（推奨：コミット直後にLOG追記）
- 中断直前（作業を止める前に必ず）

# When NOT to use
- 単発の短い質問に答えるだけで、作業継続の必要がないとき
- 既にLOG追記済みで、追加情報が無いとき（冗長な追記はしない）

# System (2-layer handoff)
## Layer A: Incremental log (always)
- File: `docs/handoff/LOG.md`
- 1エントリは短く（10〜20行程度）。“増分”だけを書く。
- 原則：コミット単位 or 意思決定単位で追記。

## Layer B: Snapshot (sometimes)
- File: `docs/HANDOFF.md`
- “今の状態だけ見れば再開できる” 1ページ。
- 更新は頻繁にやらない（重くなる）。以下の条件のときだけ：
  - スレッド切替が確定した
  - 大きい設計判断が入った
  - LOGが長くなって探しにくくなった（目安：20エントリ以上）
  - 「次の1アクション」が変わった/ブランチが変わった

# Procedure (write handoff)
## 0) Collect current state (copy into notes)
Run:
- `git status -sb`
- `git diff --stat`
- `git log -1 --oneline`
- `git branch --show-current`

## 1) Append an incremental entry to docs/handoff/LOG.md (always)
Add one entry using this fixed format (keep it short):
- Timestamp (JST) / Branch / Commit
- Goal (1–2 lines)
- Changes (max 3 bullets)
- Decisions (max 3 bullets)
- Blockers / Open questions (as needed)
- Next single action (exactly 1)
- Evidence (only if needed: 1–2 lines of commands/errors)

## 2) Update docs/HANDOFF.md (only when triggered)
If any trigger is met (thread switch, major decision, long log, next action changed), update snapshot:
- Current goal
- Current state (branch/last commit/what’s done/what’s not)
- Decisions & constraints (MVP/parity/guardrails)
- Blockers
- Next single action (exactly 1)
- Pointer to latest LOG entries (date range)

## 3) Commit the handoff update
- Commit message should be explicit: `chore: update handoff log` or `chore: update handoff snapshot`
- Do not touch main directly.

# Procedure (resume in a new thread)
1. Read `docs/HANDOFF.md` first.
2. Confirm branch + repo state matches.
3. Execute exactly the “Next single action”.
4. If needed, read `docs/handoff/LOG.md` entries after the snapshot date to recover fine details.

# Constraints
- Keep entries short. Do NOT paste long chat logs.
- No scope creep: MVP/Parity rules remain binding.
- If specs are unclear, stop and write the open question in LOG + ask user next.

# Output expectations
When invoked, output:
- The exact LOG entry you will append (formatted)
- Whether snapshot update is needed (yes/no + reason)
- The exact updates you will make to HANDOFF.md (if any)
- The git commands you will run (add/commit/push)
