from datetime import datetime, timedelta
from typing import List
from app.models import Metric

class MetabolicService:
    @staticmethod
    def predict_trend(metrics: List[Metric]) -> str:
        # Simple moving average or linear regression stub
        if not metrics:
            return "Insufficient data"
        
        values = [m.value for m in metrics]
        avg = sum(values) / len(values)
        
        if avg > 140: # Hyperglycemia threshold example
            return "Rising Trend - Consult Physician"
        elif avg < 70:
            return "Falling Trend - Risk of Hypoglycemia"
        return "Stable"
