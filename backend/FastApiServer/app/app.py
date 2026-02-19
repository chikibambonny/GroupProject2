from fastapi import FastAPI
from app import process
from app.config import settings

app = FastAPI(title=settings.app_name)

app.include_router(process.router, prefix="/process", tags=["Processing"])


@app.get("/")
async def root():
    return {"status": "running"}