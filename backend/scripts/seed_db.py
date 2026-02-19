import sys
import os
sys.path.append(os.getcwd())
import asyncio
from app.api.v1.endpoints.ingest import IngestionService
# In a real app, we would direct insert into Vector DB here.
# For now, we print what we would insert.

WHO_GUIDELINES = [
    "Infants should be exclusively breastfed for the first six months of life to achieve optimal growth, development and health.",
    "Complementary feeding should be introduced at 6 months of age while continuing to breastfeed for up to two years or beyond."
]

async def seed():
    print("Seeding Vector DB with WHO Guidelines...")
    for guideline in WHO_GUIDELINES:
        print(f"Insertion: {guideline[:30]}... [Mock Embedding generated]")
    print("Seeding Complete.")

if __name__ == "__main__":
    asyncio.run(seed())
