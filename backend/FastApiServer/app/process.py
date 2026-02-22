from fastapi import APIRouter, UploadFile, File, Form, HTTPException
from app import processor
from app.schemas import TextRequest, ProcessResponse

router = APIRouter()


@router.post("/text", response_model=ProcessResponse)
async def process_text_endpoint(request: TextRequest):
    result = await processor.process_text(request.content)
    return ProcessResponse(status="success", result=result)


@router.post("/audio", response_model=ProcessResponse)
async def process_audio_endpoint(file: UploadFile = File(...)):
    content = await file.read()
    result = await processor.process_audio(content)
    return ProcessResponse(status="success", result=result)


@router.post("/video", response_model=ProcessResponse)
async def process_video_endpoint(file: UploadFile = File(...)):
    content = await file.read()
    result = await processor.process_video(content)
    return ProcessResponse(status="success", result=result)