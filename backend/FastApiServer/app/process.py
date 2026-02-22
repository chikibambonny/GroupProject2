from fastapi import APIRouter, UploadFile, File, Form, HTTPException, Body, UploadFile, HTTPException
from app import processor
from app.schemas import TextRequest, ProcessResponse
from app.config import Command, Routes

router = APIRouter()

@router.post("/email", response_model=ProcessResponse)
async def process_email(request: TextRequest):
    result = await processor.process_email(request.content)
    return ProcessResponse(status="success", result=result)


@router.post("/audio", response_model=ProcessResponse)
async def process_audio(file: UploadFile = File(...)):
    content = await file.read()
    result = await processor.process_audio(content)
    return ProcessResponse(status="success", result=result)


@router.post("/video", response_model=ProcessResponse)
async def process_video(file: UploadFile = File(...)):
    content = await file.read()
    result = await processor.process_video(content)
    return ProcessResponse(status="success", result=result)

@router.post("/test", response_model=ProcessResponse)
async def process_test(request: TextRequest):
    result = await processor.process_test(request.content)
    return ProcessResponse(status="success", result=result)


'''
@router.post(Routes.EMAIL, response_model=ProcessResponse)
async def process_email_endpoint(request: TextRequest):
    result = await processor.process_email(request.content)
    return ProcessResponse(status="success", result=result)


@router.post(Routes.AUDIO, response_model=ProcessResponse)
async def process_audio_endpoint(file: UploadFile = File(...)):
    content = await file.read()
    result = await processor.process_audio(content)
    return ProcessResponse(status="success", result=result)


@router.post(Routes.VIDEO, response_model=ProcessResponse)
async def process_video_endpoint(file: UploadFile = File(...)):
    content = await file.read()
    result = await processor.process_video(content)
    return ProcessResponse(status="success", result=result)
'''