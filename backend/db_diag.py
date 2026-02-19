import asyncio
import sys
import os
import traceback

sys.path.append(os.getcwd())

from app.db.session import engine
from app.db.base_class import Base
from app.models import User, Metric, ReactedDocument

async def diag():
    try:
        print("Step 1: Connecting to DB...")
        async with engine.begin() as conn:
            print("Step 2: Connected. Creating tables...")
            await conn.run_sync(Base.metadata.create_all)
            print("Step 3: Tables created successfully.")
    except Exception as e:
        print(f"FAILURE: {type(e).__name__}: {e}")
        traceback.print_exc()

if __name__ == "__main__":
    asyncio.run(diag())
