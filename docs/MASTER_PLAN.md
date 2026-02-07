# MASTER PLAN（Polaris / DanGi）
この文書は、`docs/`（契約/コンセプト/実装計画）を一次ソースとして、現行コードと突き合わせた「総合計画（マスタープラン）」です。  
空欄は禁止し、不明点は「不明」と明記します。

## 0. ソース・オブ・トゥルース
- 最優先契約: `docs/00_PARITY_CONTRACT.md`（Windows/iOS 同一機能・同一データ・同一トークン/モーション・日本語固定）
- 範囲固定: `docs/00_MVP_SCOPE_LOCK.md`（M0〜M3、OUT事項は実装禁止）
- 同期契約: `docs/12_SYNC_API_SPEC.md`（M3の唯一の正）
- 実装順/DoD: `docs/09_IMPLEMENTATION_PLAN.md`
- 体験原典: `docs/CONCEPT.md` / `docs/02_PRODUCT_FLOW.md`

## 1. コンセプト要約（docs由来、3〜8行）
- 研究室UI世界観の中で、ユーザーと複数Personaが「談議」を行い、結論を「Knowledge Crystal」として生成・保存する。
- 体験の核は Ritual（開始）→ Council（議論）→ Ending（収束/結晶化/解散）の儀式的ライフサイクル。
- ルール（No Slander / No Dogmatism / Deviation Protocol / Ejection）を司会（Voice of Heaven）が監督し、ログ破壊を防ぐ。
- Windows/iOSで同一機能・同一データを保証し、同期でpersona/談議データを全共有する。
- MVP（M0〜M3）は「縦スライス完走→ローカル保存→最低限同期」まで。自動Web検索/3D/音声クローン等は範囲外。

## 2. 現状スナップショット（コード/構成に基づく事実）
- Repo: `~/projects/Polaris`
- Branch: `feature/M0-todo-warnings`
- Commit: 53c9b7c
- Platform Shell:
  - Windows: あり（`apps/dangi_app/windows/`）
  - iOS: **なし**（`apps/dangi_app/ios/` ディレクトリが存在しない）
- Backend / Contracts:
  - `backend/`: READMEのみ（未実装）
  - `contracts/`: READMEのみ（未実装）

## 3. 現状の実装ステータス（出来てる/未実装/不明）
### 3.1 MVP（M0〜M3）対比（要点）
- M0（骨組み）
  - 出来てる: `ui_tokens` / `motion_tokens` / `l10n_ja` / `shared_core`（state machine・schema枠）/ `melos verify` 導線 / 英語直書きチェック
  - 未実装/不足: iOS Shell（`apps/dangi_app/ios/` 不在）
- M1（談議縦スライス）
  - 出来てる: PromptTemplate / Guard（簡易）/ ConversationEngine（疑似ストリーミング）/ SummaryCrystal（スタブ）/ error state枠
  - 未実装/不足: Persona選択UI（`SessionState.personaSelect` が未実装画面）/ テーマ入力値の実注入（UI→Engineが固定文字列）
- M2（保存＋再現）
  - 出来てる: Data Model（Session/Message/Crystal等）/ FileLocalStore（JSONL）/ 履歴一覧UI（最小）
  - 未実装/不足: エクスポート/インポート（JSON）導線（仕様化/実装ともに未確認）
- M3（同期）
  - 出来てる: Auth最小（device_id/owner_user_idの永続化）
  - 未実装: Sync Client / Backend Sync API / OpenAPI・JSON Schema（contracts）/ 競合処理ログ / オフライン復帰フロー

### 3.2 “不明” として残す項目（決定待ち）
- Backend実装スタック（言語/フレームワーク/ホスティング）
- Gemini呼び出し方式の最終決定（Vertex AI主軸だが、ローカル試作はAPI key案も比較）

## 4. アーキテクチャ（Flutter / 状態遷移 / データ流れ / AI層）
### 4.1 目標構造（docs/08準拠）
- `apps/dangi_app`: Shell（UI/入力/OS連携のみ）
- `packages/shared_core`: 共通コア（状態遷移/会話/データモデル/同期クライアント）
- `backend/`: Auth + Sync API + LLM Proxy（キーをクライアントに置かない）
- `contracts/`: OpenAPI + JSON Schema（同期/データ契約を固定）

### 4.2 状態遷移（SessionMachine）
- 単一の `SessionMachine` を“画面の唯一の正”としてUIを切り替える。
- エラーは任意状態→`error` へ遷移し、`recovered` で前状態へ復帰する設計。

### 4.3 データ流れ（MVP）
- UI → SessionEvent → SessionMachine（状態遷移）
- 議論（M1）: ConversationEngine（現状はスタブ）→ メッセージ（チャンク）→ UI表示
- 保存（M2）: LocalStore（FileLocalStore）へ upsert（Session/Message/Crystal…）
- 同期（M3）: SyncClient（未実装）で push→pull、競合は契約に従って解決しログへ記録

## 5. AI統合計画（Gemini / Vertex AI）
### 5.1 原則（契約）
- APIキー/秘密情報はクライアントに埋め込まない（`docs/08_ARCHITECTURE.md`）
- 自動Web検索はMVP OUT（`docs/00_MVP_SCOPE_LOCK.md`）
- 出力・エラー・ユーザー可視ログは日本語固定（`docs/00_PARITY_CONTRACT.md`）

### 5.2 統合アプローチ（推奨）
- クライアント（Flutter）→ Backend（LLM Proxy）→ Gemini
- `shared_core` に “LLM呼び出しインターフェース” を用意し、MVPはスタブ/本番はHTTP実装に差し替える。

### 5.3 認証/キー管理
- Preferred（本番想定）: Vertex AI（service account）
  - サーバはサービスアカウントで呼び出し（鍵はリポジトリに置かない）
  - 実運用はSecret管理/Workload Identity等で注入（詳細は不明、決定後に具体化）
- Alternative（ローカル試作）: Google AI API（API key）
  - API keyはバックエンド環境変数で管理（クライアントには置かない）
- Decision Pending: どちらを標準にするか（比較表/決定条件は後述）

### 5.4 リクエスト設計（案）
- Turn生成（ストリーミング）
  - Input: theme, personas, transcript, turn_index, guard_policy
  - Output: speaker_id, chunks（順序付き）, moderation_flags, usage（token/latency）
- 要約/Crystal生成
  - Input: theme, messages, participants, turn_count
  - Output: title, summary_text, heat_score, color, usage
※ 具体のAPI形（REST/SSE/WebSocket）は backend stack 決定後に確定（現時点は不明）

### 5.5 安全（Safety）
- System prompt（司会）で「誹謗中傷禁止/独断禁止/脱線修正」を明文化（docs/04,10準拠）
- 出力前フィルタ（Moderation）をバックエンドで実施（実装方式は不明）
- 送信ログの匿名化/最小化（プライバシー対策、docs/10準拠）

### 5.6 レート/コスト
- ユーザー単位のレート制限（RPS/同時セッション）とセッションあたり上限（turn/token）をバックエンドで強制
- 失敗時は `SessionState.error` に遷移し、再試行/中断/再開（M1-B3）で復帰

### 5.7 比較表（Vertex vs API key）
- Vertex AI: 運用/監査/権限が強い（セットアップ重め）
- API key: MVPで手軽（キー流出/課金事故対策をバックエンド運用で補う）
- 推奨方針: ローカル試作はAPI key可、本番はVertexへ移行（移行タスクをWBSに含める）

## 6. UI/UX計画（画面/フロー/状態別UX/エラーUX）
### 6.1 画面一覧（SessionState対応）
- boot: 起動演出（System Boot）
- idle: トップ（Gateway）
- themeInput: テーマ入力
- personaSelect: Persona選択（最大7 + 司会）
- ignition: 点火（Genesis/Resonance Join）
- discussion: Council（ログ投影/Data Stream）
- convergence: 収束（生成中）
- crystallization: Crystal表示/保存
- dissolution: 解散→トップ
- error: 再試行/中断/再開
- history: 履歴一覧/復元

### 6.2 ユーザーフロー（MVP）
- 新規: idle → themeInput → personaSelect → ignition → discussion → convergence → crystallization → dissolution → idle
- 復元: idle → history → session復元 → discussion（未終了）/（終了済みは方針未確定）
- エラー: 任意 → error → recovered（前状態） or sessionEnded（idle）

### 6.3 UIトークン/モーション
- 色/余白/角丸/影: `ui_tokens` 単一ソース（OS別分岐禁止）
- duration/curve: `motion_tokens` 単一ソース（OS別分岐禁止）

### 6.4 エラーUX（MVP）
- ユーザー可視メッセージは日本語
- 再試行（同一操作リトライ）、中断（セッション終了）、再開（前状態復帰）

## 7. 工程（WBS：フェーズ/マイルストーン/DoD/依存関係）
### 7.1 フェーズ方針
- M0→M1→M2→M3 の順（`docs/09_IMPLEMENTATION_PLAN.md` に従う）
- 1回の作業で1項目（runloop）

### 7.2 WBS（要点）
- M0: 既存基盤のパリティ確立
  - iOS Shell 追加（`apps/dangi_app/ios/` 生成・起動確認）※現状未実装
  - DoD: Windows+iOSで起動し、状態遷移が同じ
- M1: 談議縦スライス完走（UI導線の穴埋め）
  - テーマ入力値の保持→Engineへ注入
  - personaSelect の最小実装（固定3名でも可、遷移を成立）
  - DoD: 両OSで Ritual→Ending まで完走
- M2: 保存/再現
  - export/import（JSON）導線の仕様化→実装
  - DoD: 両OSで保存・履歴・復元が破綻しない
- M3: 同期 + Backend + LLM Proxy
  - Backend stack決定（Decision）
  - contracts（OpenAPI/JSON Schema）整備
  - Auth（トークン）→ Sync push/pull → 競合ログ → オフライン復帰
  - LLM proxy（Gemini/Vertex）→ Turn/要約/Crystal の実接続
  - DoD: Windowsで作ったセッションがiOSで見える（逆も）＋ LLMキーがクライアントに存在しない

## 8. ツール一覧（開発/テスト/CI/配布/監視/ドキュメント/AI支援）
- 既存: Flutter/Dart, melos（`melos run verify`）, 英語直書きチェック（`tools/check_english_literals.dart`）, 共有Zip（`scripts/make_shared_zip.sh`）
- 追加候補（未導入）:
  - CI: GitHub Actions（analyze/test/english-check）
  - 監視: backendの構造化ログ/メトリクス（方式は不明）
  - Secret管理: Vertex/LLMキーを安全に注入（方式は不明）
  - ドキュメント: `docs/` をPRで必ず更新する運用

## 9. リスクと対策（上位5つ）
1. iOS Shell 不在によるパリティ崩壊 → iOS生成/起動確認を最優先で追加
2. LLMキー漏洩/課金事故 → backend proxy + secret管理 + rate/cost cap
3. セーフティ違反（誹謗中傷/独断/プライバシー）→ prompt + moderation + ログ最小化
4. 同期競合でデータ破壊 → `12_SYNC_API_SPEC.md` 準拠 + tombstone + 競合ログ
5. ローカル保存破損 → schema_version + migration + exportバックアップ

## 10. Next single action（1つ）
- `apps/dangi_app` に iOS Shell を追加し、Windows/iOSで起動確認できる状態にする（パリティ契約の前提を満たす）
