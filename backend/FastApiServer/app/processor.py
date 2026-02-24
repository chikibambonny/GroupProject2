from unittest import result

from app.features.SpeechToText import EnglishScript as EngSpeach
from app.features.SpeechToText import TestSpeechToText
from app.features.SignsToText import SignsScript

async def process_email(content: str) -> str:
    # Todo: replace with real logic
    return content.upper()


async def process_audio(file_bytes: bytes) -> str:
    # TODo: audio processing logic
    #return EngSpeach.transcribe_audio_bytes(file_bytes)
    print(dir(TestSpeechToText))
    return TestSpeechToText.recognize_audio_bytes(file_bytes)


async def process_video(file_bytes: bytes) -> str:
    result = SignsScript.predict_sign_from_video_bytes(file_bytes)
    return result

async def process_test(content: str) -> str:
    return f"R u slow on purpose? {content}"