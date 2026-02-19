from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from pydantic import BaseModel
from datetime import datetime
from app.api.deps import get_db, get_current_user
from app.models import User

router = APIRouter()

class UserProfile(BaseModel):
    id: int
    email: str
    full_name: str | None = None
    age: int | None = None
    pre_pregnancy_weight: float | None = None
    lmp_date: datetime | None = None
    conditions: str | None = None
    is_onboarded: bool

    class Config:
        from_attributes = True

class OnboardingData(BaseModel):
    age: int
    pre_pregnancy_weight: float | None = None
    lmp_date: datetime | None = None
    conditions: str | None = None  # JSON string e.g. '["hypertension","diabetes"]'

@router.get("/me", response_model=UserProfile)
async def read_current_user(current_user: User = Depends(get_current_user)):
    return current_user

@router.put("/onboard", response_model=UserProfile)
async def onboard_user(
    data: OnboardingData,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
):
    current_user.age = data.age
    current_user.pre_pregnancy_weight = data.pre_pregnancy_weight
    current_user.lmp_date = data.lmp_date
    current_user.conditions = data.conditions
    current_user.is_onboarded = True
    await db.commit()
    await db.refresh(current_user)
    return current_user
