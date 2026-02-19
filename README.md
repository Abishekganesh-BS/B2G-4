# Maternal & Infant Health Platform

An AI-powered maternal and infant health platform that provides personalized health insights using a RAG (Retrieval-Augmented Generation) agent. The system ingests clinical guidelines (PDFs), stores them in a vector database, and generates evidence-based recommendations across multiple health domains.

## Features

- **Authentication** — Secure JWT-based login & registration
- **Metabolic Health** — Glucose monitoring and metabolic risk assessment
- **Lifestyle Tracking** — Lifestyle and wellness recommendations
- **Mental Well-Being** — Mental health screening and support
- **Pediatric Care** — Infant health monitoring and guidance
- **RAG Agent** — Clinical guideline ingestion (PDF), vector search, and AI-synthesized recommendations

## Tech Stack

| Layer          | Technology                                              |
|----------------|---------------------------------------------------------|
| Frontend       | Flutter, Riverpod, GoRouter, Dio, Google Fonts          |
| Backend        | FastAPI, SQLAlchemy (async), Pydantic v2                |
| Database       | PostgreSQL + pgvector (vector similarity search)        |
| AI / RAG       | LangChain, OpenAI, pypdf                                |
| Auth           | JWT (python-jose), bcrypt (passlib)                     |
| Infrastructure | Docker Compose (pgvector, Adminer)                      |

## Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (≥ 3.3.0)
- [Python](https://www.python.org/downloads/) (≥ 3.10)
- [Docker Desktop](https://www.docker.com/products/docker-desktop/)

## Getting Started

### 1. Clone the repository

```bash
git clone <repository-url>
cd B2G
```

### 2. Start the database (Docker)

> **Important:** The PostgreSQL + pgvector database must be running before starting the backend.

```bash
cd docker
docker-compose up -d
```

This starts:
- **PostgreSQL + pgvector** on port `5432`
- **Adminer** (DB admin UI) on [http://localhost:8081](http://localhost:8081)

### 3. Backend setup

```bash
cd backend

# Create and activate virtual environment
python -m venv venv
.\venv\Scripts\activate        # Windows
# source venv/bin/activate     # macOS / Linux

# Install dependencies
pip install -r requirements.txt
```

Create a `.env` file inside the `backend/` directory:

```env
# Database (defaults work if using the provided docker-compose)
POSTGRES_SERVER=localhost
POSTGRES_USER=postgres
POSTGRES_PASSWORD=postgres
POSTGRES_DB=app

# Security — change this in production!
SECRET_KEY=your-secret-key-here

# OpenAI (required for RAG features)
OPENAI_API_KEY=sk-your-openai-key
```

Start the server:

```bash
uvicorn app.main:app --reload
```

- API docs: [http://localhost:8000/docs](http://localhost:8000/docs)
- Health check: [http://localhost:8000/health](http://localhost:8000/health)

### 4. Frontend setup

```bash
cd frontend
flutter pub get

# Run in development
flutter run

# Build APK for Android
flutter build apk
```

## Project Structure

```
B2G/
├── backend/
│   ├── app/
│   │   ├── api/v1/endpoints/   # Auth, ingestion, user endpoints
│   │   ├── core/               # Config, security (JWT + hashing)
│   │   ├── db/                 # Async DB session, base classes
│   │   ├── services/           # RAG pipeline (ingestion, retrieval, synthesis)
│   │   │   ├── ingestion.py    # PDF parsing & metric processing
│   │   │   ├── retrieval.py    # Vector similarity search
│   │   │   ├── synthesis.py    # AI recommendation generation
│   │   │   ├── metabolic.py    # Metabolic health logic
│   │   │   ├── lifestyle.py    # Lifestyle assessment logic
│   │   │   ├── mental.py       # Mental well-being logic
│   │   │   └── pediatric.py    # Pediatric care logic
│   │   ├── main.py             # FastAPI app entry point
│   │   └── models.py           # SQLAlchemy models
│   └── requirements.txt
├── frontend/
│   ├── lib/
│   │   ├── features/           # Feature screens (auth, home, health modules)
│   │   ├── services/           # API service layer (Dio)
│   │   ├── main.dart           # App entry point
│   │   ├── router.dart         # GoRouter navigation
│   │   └── theme.dart          # App theme
│   └── pubspec.yaml
└── docker/
    └── docker-compose.yml      # PostgreSQL + pgvector, Adminer
```

## API Endpoints

| Method | Endpoint               | Description                    |
|--------|------------------------|--------------------------------|
| POST   | `/api/v1/auth/register`| Register a new user            |
| POST   | `/api/v1/auth/login`   | Login (returns JWT)            |
| POST   | `/api/v1/ingest/`      | Upload PDF for RAG ingestion   |
| GET    | `/health`              | Health check                   |

## License

This project is for educational and research purposes.
