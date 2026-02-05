# Polaris Progress Project 運用手順

## Project
- Name: Polaris Progress
- URL: https://github.com/users/s14k17r18-glitch/projects/1

## 毎日の運用（最小）
1. Project を開き、今日やるタスクを **In Progress** に移動する。
2. 作業が完了したら **Done** へ移動する。
3. 未着手のタスクは **Todo** のまま維持する。

## タスクの選び方
- M0 → M1 → M2 → M3 の順に進める（`docs/09_IMPLEMENTATION_PLAN.md` を参照）。
- 未完了の最小タスクを優先し、1回の作業で1項目だけ進める。

## PR/Issue と Project の関係
- PR を作成したら Project に追加する。
- PR がマージされたら該当アイテムを Done に移動する。
- Issue がクローズされたら Done に移動する。

## フィールド運用（推奨）
- **MilestonePhase**: M0〜M5（Projects用の単一選択）
- ※ GitHub標準の Milestone フィールドとは別で運用する
- **Milestone**: M0〜M5（既存Milestoneがある場合は適宜合わせる）
- **Area**: shared_core / ui / gesture / storage / sync / infra / ci / test / docs
- **Priority**: P0〜P3
- **NextAction**: 次にやる具体的な1ステップ
