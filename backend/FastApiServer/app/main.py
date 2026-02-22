from fastapi import FastAPI
from app import process

app = FastAPI(title="Server Processing API")

app.include_router(process.router, prefix="/process", tags=["Processing"])

@app.get("/")
async def root():
    return {"status": "running"}