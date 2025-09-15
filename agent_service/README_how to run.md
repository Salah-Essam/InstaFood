InstaFood Agent (FastAPI)

Quick start
- Create a venv and activate: .\.venv\Scripts\Activate.ps1
- Install deps: pip install -r agent_service/requirements.txt
- create agent_service/.env file with your firestore cardinatlits and gemini model and api key agent fast path enable
# Local dev env for InstaFood agent
FIREBASE_PROJECT_ID=
GOOGLE_APPLICATION_CREDENTIALS=
# Agent behavior
AGENT_FASTPATH=true
GEMINI_MODEL=gemini-1.5-flash
GEMINI_MAX_TOKENS=2048
GEMINI_API_KEY=
API_BASE_URL=https://fakerestaurantapi.runasp.net/api
GEMINI_MAX_RETRIES=0
AGENT_WARM_LLM=false

 agent_service/.env and set:
  - GEMINI_API_KEY
  - GEMINI_MODEL (defaults to gemini-1.5-flash)
  - FIREBASE_PROJECT_ID and GOOGLE_APPLICATION_CREDENTIALS

  ```bash```

- Run: python -m uvicorn agent_service.main:app --reload --port 8000
- flutter run (pyhsical phone with usb):
adb reverse tcp:8787 tcp:8787                    


flutter run --dart-define=AGENT_BASE_URL=http://127.0.0.1:8787
Endpoints
- GET /health -> {"status":"ok"}
- GET /debug/auth -> Firestore connectivity probe
- GET /debug/llm -> Probes LLM and prints basic prompt info
- POST /chat -> { userId, message } -> { reply }

Notes
- Fast paths handle greetings, best sellers, cart, orders, and ETA without using the LLM for instant responses.
- LLM model can be switched with GEMINI_MODEL; use gemini-1.5-pro for higher quality, gemini-1.5-flash  for speed 50 quotes per day 
- If /debug/llm hangs, check your GEMINI_API_KEY and network, and confirm the server logs for errors.