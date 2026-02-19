from fastapi import APIRouter, Depends
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from pydantic import BaseModel
from datetime import datetime, timedelta
from app.api.deps import get_db, get_current_user
from app.models import TeleSession, User

router = APIRouter()

class SessionCreate(BaseModel):
    title: str
    scheduled_at: datetime
    notes: str | None = None

class SessionOut(BaseModel):
    id: int
    title: str
    scheduled_at: datetime
    notes: str | None = None
    created_at: datetime | None = None

    class Config:
        from_attributes = True

@router.post("/", response_model=SessionOut)
async def create_session(
    session_in: SessionCreate,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
):
    session = TeleSession(
        title=session_in.title,
        scheduled_at=session_in.scheduled_at,
        notes=session_in.notes,
        owner_id=current_user.id,
    )
    db.add(session)
    await db.commit()
    await db.refresh(session)
    return session

@router.get("/", response_model=list[SessionOut])
async def get_upcoming_sessions(
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
):
    result = await db.execute(
        select(TeleSession)
        .filter(
            TeleSession.owner_id == current_user.id,
            TeleSession.scheduled_at >= datetime.utcnow(),
        )
        .order_by(TeleSession.scheduled_at.asc())
    )
    return result.scalars().all()

@router.get("/reminders", response_model=list[SessionOut])
async def get_session_reminders(
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
):
    """Returns sessions within the next 24 hours for notification scheduling."""
    now = datetime.utcnow()
    in_24h = now + timedelta(hours=24)
    result = await db.execute(
        select(TeleSession)
        .filter(
            TeleSession.owner_id == current_user.id,
            TeleSession.scheduled_at >= now,
            TeleSession.scheduled_at <= in_24h,
        )
        .order_by(TeleSession.scheduled_at.asc())
    )
    return result.scalars().all()
