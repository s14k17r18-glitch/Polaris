# 10_RISKS_AND_GUARDS.md

## 1. Legal & Intellectual Property
### Risk: Voice Cloning Rights
- **Issue**: Using "Approximated User Voice" or Celebrity voices.
- **Guard**: 
    - Use "Vocal Archetypes" (generic approximation) instead of direct cloning for unauthorized figures.
    - Disclaimer: "Voices are AI-generated simulations."

### Risk: Character Copyright
- **Issue**: Standardizing "Anime Characters" (e.g., Doraemon).
- **Guard**: 
    - User-Import only (Private Use).
    - No pre-bundled copyrighted characters in the global Preset.

## 2. Content Safety
### Risk: AI Slander / Toxicity
- **Issue**: Personas becoming abusive or derogatory.
- **Guard**:
    - **System Level**: "Voice of Heaven" prompt explicitly forbids slander.
    - **Filter**: Output pre-filtering using Moderation API.

### Risk: Dogmatism / Hallucination
- **Issue**: AI asserting false facts as absolute truth.
- **Guard**: 
    - "No Dogmatism" rule in System Prompt.
    - User UI to flag/correct facts ("Correction Protocol").

## 3. Privacy
### Risk: User Data Leak
- **Issue**: Uploading private logs/diaries to Cloud LLM.
- **Guard**:
    - Data anonymization before sending to LLM.
    - Option for Local LLM (future scope).
