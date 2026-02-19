from fastapi import APIRouter, Depends, Query
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from pydantic import BaseModel
from datetime import datetime, timedelta
from app.api.deps import get_db, get_current_user
from app.models import Metric, User

router = APIRouter()

class MetricCreate(BaseModel):
    metric_type: str  # "glucose", "weight", "bp"
    value: float
    unit: str

class MetricOut(BaseModel):
    id: int
    metric_type: str
    value: float
    unit: str
    timestamp: datetime

    class Config:
        from_attributes = True

@router.post("/", response_model=MetricOut)
async def create_metric(
    metric_in: MetricCreate,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
):
    metric = Metric(
        metric_type=metric_in.metric_type,
        value=metric_in.value,
        unit=metric_in.unit,
        owner_id=current_user.id,
    )
    db.add(metric)
    await db.commit()
    await db.refresh(metric)
    return metric

@router.get("/history", response_model=list[MetricOut])
async def get_metric_history(
    metric_type: str = Query(..., description="Type of metric: glucose, weight, bp"),
    days: int = Query(30, description="Number of days of history"),
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
):
    since = datetime.utcnow() - timedelta(days=days)
    result = await db.execute(
        select(Metric)
        .filter(
            Metric.owner_id == current_user.id,
            Metric.metric_type == metric_type,
            Metric.timestamp >= since,
        )
        .order_by(Metric.timestamp.asc())
    )
    return result.scalars().all()
