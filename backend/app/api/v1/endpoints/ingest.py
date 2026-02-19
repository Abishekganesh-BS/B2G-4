from fastapi import APIRouter, UploadFile, File, HTTPException
from app.services.ingestion import IngestionService
from pydantic import BaseModel

router = APIRouter()

class MetricInput(BaseModel):
    type: str
    value: float
    unit: str
    user_id: int

@router.post("/pdf")
async def extract_pdf(file: UploadFile = File(...)):
    try:
        content = await IngestionService.process_pdf(file)
        return {"filename": file.filename, "extracted_text": content[:100] + "..."} # Preview
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.post("/metric")
async def ingest_metric(metric: MetricInput):
    # In a real app, save to DB here
    return {"status": "received", "data": metric}
