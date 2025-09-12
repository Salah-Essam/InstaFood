InstaFood Agent (FastAPI)

Quick start
- Create a venv and activate: .\.venv\Scripts\Activate.ps1
- Install deps: pip install -r agent_service/requirements.txt
- Copy agent_service/.env.example to agent_service/.env and set:
  - GEMINI_API_KEY
  - GEMINI_MODEL (defaults to gemini-1.5-flash)
  - FIREBASE_PROJECT_ID and GOOGLE_APPLICATION_CREDENTIALS
- Run: python -m uvicorn agent_service.main:app --reload --port 8000

Endpoints
- GET /health -> {"status":"ok"}
- GET /debug/auth -> Firestore connectivity probe
- GET /debug/llm -> Probes LLM and prints basic prompt info
- POST /chat -> { userId, message } -> { reply }

Notes
- Fast paths handle greetings, best sellers, cart, orders, and ETA without using the LLM for instant responses.
- LLM model can be switched with GEMINI_MODEL; use gemini-1.5-pro for higher quality, gemini-1.5-flash for speed.
- If /debug/llm hangs, check your GEMINI_API_KEY and network, and confirm the server logs for errors.