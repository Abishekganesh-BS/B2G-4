from fastapi import APIRouter
from app.api.v1.endpoints import users, ingest, auth, metrics, sessions

api_router = APIRouter()
api_router.include_router(auth.router, prefix="/auth", tags=["auth"])
api_router.include_router(users.router, prefix="/users", tags=["users"])
api_router.include_router(ingest.router, prefix="/ingest", tags=["ingestion"])
api_router.include_router(metrics.router, prefix="/metrics", tags=["metrics"])
api_router.include_router(sessions.router, prefix="/sessions", tags=["sessions"])
