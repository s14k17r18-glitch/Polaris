# DanGi - Concept Design Document

**[Role]** 体験/世界観リファレンス。実装・セットアップは [README.md](README.md) を参照。

> **"Dive into the Nexus."**
> 多次元的な視点が交錯する、次世代の談議空間。

## 1. 概要 (Overview) & Vision
**DanGi** は、あなたと多彩な「Persona」たちが一堂に会し、一つの課題について多方面から談議（DanGi）を行うためのプラットフォームです。

*   **Core Philosophy**: "Research Lab UI" (Cyber/Dark) × "Gesture-Driven UX" (Fluidity).
    *   単なるツールではなく、未知の知性を解析・生成する「研究室」のような体験を提供します。
*   **Branding**: トップ画面にはAI生成された「Nexus-AI」スタイル（サイバーパンク・幾何学）のロゴを配置。
*   **Language**: **完全日本語アプリ**。インターフェース、メニュー、対話のすべてを日本語ベースで設計。

---

## 2. Persona一覧 (The Intellect)
Deep Persona Engine により再現された多様な「知性体」が、議論の参加者（Actor）となります。

### 2.1 カテゴリ (Categories)
*   **人物**: 政治家、学者、企業家、大富豪、歴史上の偉人、哲学者など。
*   **キャラクター**: アニメキャラクター、フィクションドラマの登場人物。
*   **その他 (森羅万象)**: 恐竜、細胞、ねこ、いぬ、樹木、石（鉱物）など。

### 2.2 性質と生成 (Nature & Creation)
*   **Voice**: 本人の声質に似せて作成したAPIを使用（不明な場合はAIの想像で補完）。
*   **Knowledge Source**:
    *   **Basic**: LLMプリセット知識 + Web検索。
    *   **User Import**: 著書や論文、ログデータをインポートし、固有の知識ベースとして学習可能。
*   **Digital Forge (Creation)**: ウィザード形式で、テキストファイル群から「その人らしい」人格を自動生成。

### 2.3 学習と進化 (Evolution Mechanics)
議論を重ねるごとにPersonaは変化しますが、その速度と条件は厳密に定義されます。

*   **Learning Condition**: 有意義に完結し「**Knowledge Crystal (知識の結晶)**」が生成されたセッションのみを記憶対象とします。さらに、結論がPersonaの信念と「共鳴」した場合のみ、性格パラメータが変化します。
*   **Neuro-Plasticity (学習速度)**:
    *   **Humans**: `1.0x` (Standard). 対話により思想がアップデートされる。
    *   **Animals**: `0.01x` (Instinctive). 野性的本能が強く、基本性質は変わらない。
    *   **Nature**: `0.0x` (Immutable). 原理原則を貫く不変の存在。

---

## 3. Visuals & UX (The Nexus)
「未知の知性との対話」を演出する、没入感のあるビジュアルスタイル。

### 3.1 UI Design
*   **Theme**: "Cyber / Sci-Fi Research Lab" (近未来の仮想研究室)。
*   **Colors**: Base (`#0A0E17` Deep Space), Accent (`#00F0FF` Cyan Neon), Secondary (`#7000FF` Purple).
*   **Glassmorphism**: 半透明のガラスパネルによる奥行き表現。
*   **Data Stream**: 会話ログを「ガラスに投影された光の文字列」として表示（従来の吹き出し廃止）。

### 3.2 Metamorphosis (Two-State System)
Personaは状況に応じて「アバター」と「コア」の姿を行き来します。

1.  **Waiting State (Avatar Mode)**:
    *   待機・選択画面。実物をベースに美化された「美男美女（Perfect Symmetry）」として表示。
    *   **Nexus Aesthetics**: 陶器のような肌、推論時に瞳奥で回る幾何学模様 (Glow Eyes)、背面のデジタル光輪 (Halo)。
2.  **Discussion State (Core Mode)**:
    *   談議中。円卓に着席した瞬間、ノイズと共に抽象化され「六角柱のHolo-Node」へ変身。純粋な思考体となる。

### 3.3 Internal Core Symbol
Holo-Node内部には、そのPersonaを象徴するオブジェクトが封入され、発光しています。
*   (例) **歴史家**: 羽ペン / **数学者**: 幾何学模様 / **猫**: シルエット / **石**: 結晶

---

## 4. セッション体験 (The Session Lifecycle)
談議は、開始から終了までが一つの「儀式（Ritual）」としてデザインされています。

### Phase 1: The Ritual (開始フロー)
1.  **Inception (お題提示)**: ユーザーがコアにテーマを投げ込む。
2.  **Volition (意思表示)**: 全Personaが参加意思を表明（光る/暗転）。
3.  **Selection (選抜)**: ユーザーがドラッグ操作でPersonaを円卓（Heptagon Ring）へ配置。強制参加も可能。
4.  **Voice of Heaven (司会)**: 選ばれなかった中から司会役（天の声）を選出・配置。
5.  **Ignition (点火)**: 全員が揃い、コアが弾けて談議スタート。

### Phase 2: The Council (談議・挙動)
最大7名 + あなたで行う談議モード。

*   **Heptagon Ring**: 7つのHolo-Nodeが円卓状に浮遊。
*   **Focus & Orbit**: 発言者は一歩前へスライド（Orbit In）し、クローズアップされる。
*   **Constellation View**: 議論が白熱するとカメラが引き、共鳴（Synapse Link）を星座のように可視化。
*   **The Code of Council (談議ルール)**:
    *   **No Slander**: 誹謗中傷の禁止。
    *   **No Dogmatism**: 絶対的肯定（思想の押し付け）の禁止。
    *   **Deviation Protocol**: 脱線時は「天の声」が修正。改善なければ強制退席（Ejection）。

### Phase 3: The Ending (終了フロー)
1.  **Convergence (収束)**: 結論ボタン押下で、全Nodeから光が中央へ集中。
2.  **Crystallization (結晶化)**: 会話ログが圧縮され、「Knowledge Crystal」として物質化。色は議論の熱量（赤/青）で変化。
3.  **Dissolution (解散)**: 一瞬アバターに戻り、一礼して粒子となり消滅。

---

## 5. アニメーション定義 (Motion Language)
システム内の主要なイベント演出。

*   **System Boot**: 起動シーケンス。
*   **The Genesis Sequence (PersonaCreation)**:
    *   *Phase 1*: ネオンの骨格と神経網の構築。
    *   *Phase 2*: ガラス素体とデータ充填。
    *   *Phase 3*: コア点火による実体化 (Soul Ignition)。
*   **Resonance Join**: 参加意思があるPersonaのヒロイックな実体化。
*   **Boot Sequence**: 無理やり起こされる強制起動。
*   **Synapse Link**: 談議中、意見が一致した者同士を繋ぐレーザー演出。

---

## 6. 操作性 (Operability / UX)
**Gesture-Driven Interface** (Mobile First)
物理ボタンを極力排除し、直感的な身体操作で対話を行う。

*   **Swipe Interaction**:
    *   画面端スワイプ: 設定やログへのアクセス。
    *   Personaスワイプ: 退席、または同意の意思表示。
*   **Rotary Manipulation**: 仮想ホイールによる時間軸操作（ログ巻き戻し）や席順回転。
*   **Touch & Haptics**:
    *   **Double Tap**: 共感 (Like)。
    *   **Long Press (Mind Dive)**: 詳細ステータスや思考の覗き見。
    *   **Haptic Feedback**: ガラスの質感を伝える微細な振動フィードバック。
