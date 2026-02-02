# 03_PERSONAS_SCHEMA.md

## 1. Deep Persona Engine Overview
The core engine responsible for simulating "True-to-Life" identities. It manages static attributes (Origin) and dynamic attributes (Evolution).

## 2. Persona Data Schema
```json
{
  "id": "uuid",
  "name": "string",
  "category": "HUMAN" | "CHARACTER" | "NATURE",
  "core_symbol": "asset_id", // e.g., "quill", "crystal"
  "voice_config": {
    "provider": "api_provider",
    "voice_id": "string_or_generated",
    "pitch": 1.0,
    "speed": 1.0
  },
  "knowledge_base": {
    "basic_preset": "SCHOLAR", // LLM System Prompt Preset
    "user_imports": ["file_id_1", "file_id_2"], // Vector DB IDs
    "web_access": true
  },
  "evolution_stats": {
    "neuro_plasticity": 1.0, // Defines rate of change
    "trust": 0.5,
    "beliefs": {
      "topic_A": 0.8, // -1.0 to 1.0
      "topic_B": -0.2
    }
  },
  "visuals": {
    "avatar_model": "3d_model_id",
    "holo_color": "#RRGGBB"
  }
}
```

## 3. Categories & Plasticity
The rate at which a Persona's beliefs change (`neuro_plasticity`) is strictly defined by their category.

| Category | Description | Neuro-Plasticity | Note |
|:---|:---|:---|:---|
| **Human** | Historic figures, Professionals | **1.0x** (Standard) | Updates ideology through discussion. |
| **Character** | Anime, Fiction, Drama | **1.0x** (Standard) | Can grow beyond original script. |
| **Animal** | Cats, Dogs, Dinosaurs | **0.01x** (Instinctive) | Hard to change; driven by instinct. |
| **Nature** | Trees, Stones, Concepts | **0.0x** (Immutable) | "Principled" existence; never changes. |

## 4. Digital Forge (Creation Wizard)
1.  **Identity Input**: User provides Name & Role.
2.  **Source Material**: Upload PDF/Txt (e.g., "My Philosophy.txt").
3.  **Analysis**: Engine extracts:
    - Keywords for `core_symbol`.
    - Tone/Style for `voice_config`.
    - Base beliefs for `evolution_stats`.
4.  **Materialization**:
    - Generates 3D Avatar (Symmetrical/Porcelain).
    - Assigns Holo-Node shape.

## 5. Voice Synthesis
- **Source**: Text-to-Speech API.
- **Logic**: 
  - If "Voice Sample" provided -> Clone.
  - If Unknown -> AI imagines based on "Role" and "Personality" (e.g., "Old Philosopher" -> Deep/Slow).
