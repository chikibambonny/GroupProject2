from fastapi import APIRouter, UploadFile, File, Form, HTTPException
from app import processor
from app.schemas import TextRequest, ProcessResponse
from app.config import Command, Routes

router = APIRouter()


@router.post("/{command}", response_model=ProcessResponse)
async def process_dynamic(command: Command, file: UploadFile = File(None), request: TextRequest = None):
    
    if command == Command.email:
        result = await processor.process_email(request.content)

    elif command == Command.audio:
        content = await file.read()
        result = await processor.process_audio(content)

    elif command == Command.video:
        content = await file.read()
        result = await processor.process_video(content)

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