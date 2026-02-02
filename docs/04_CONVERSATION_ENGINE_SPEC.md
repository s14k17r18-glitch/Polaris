# 04_CONVERSATION_ENGINE_SPEC.md

## 1. Council Architecture
The conversation is structured not as a flat chat, but as a "Heptagon Council".

- **Max Participants**: 7 Personas + 1 User.
- **Turn System**: Dynamic. Multiple Personas can "raise hand" (Volition), but only one can "Orbit In" (Speak) at a time to prevent audio chaos, though interruptions are allowed if "Excitement" is high.

## 2. The Voice of Heaven (Moderation Engine)
A specialized System Prompt acting as the Chairman/Moderator.

### 2.1 Code of Council (Rules)
The Moderator monitors all messages against these rules:
1.  **No Slander**: Personal attacks trigger warnings.
2.  **No Dogmatism**: Phrases like "You must," "Absolutely," "There is no doubt" are flagged if they suppress discussion.
3.  **Deviation Protocol**:
    - If conversation drifts from "Theme" > 2 turns: Moderator interjects.
    - If Persona persists: **Ejection Protocol** (Forced removal).

## 3. Context & Memory
- **Short-Term**: Full transcript of current session (up to context limit).
- **Long-Term**:
    - Only "Knowledge Crystals" (Compressed Summaries) from past sessions are accessible.
    - Personas reference: Origin Knowledge + Consolidated Memories.

## 4. Resonance System (Synapse Link)
- **Logic**: Real-time semantic similarity check between current statement and other Personas' beliefs.
- **Trigger**: Similarity Score > Threshold (0.85).
- **Effect**:
    - 3D Visual: Laser connection (Synapse Link).
    - Metadata: "Agreement" recorded for Evolution.

## 5. Topic Lifecycle
1.  **Proposition**: Node claims center.
2.  **Debate**: Nodes orbit in/out.
3.  **Heat Up**: rapid switching, camera pulls back (Constellation View).
4.  **Convergence**: Moderator prompts for conclusion.
