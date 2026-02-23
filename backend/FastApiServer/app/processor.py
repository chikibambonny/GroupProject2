from .features.SpeechToText import EnglishScript as EngSpeach

async def process_email(content: str) -> str:
    # Todo: replace with real logic
    return content.upper()


async def process_audio(file_bytes: bytes) -> str:
    # TODo: audio processing logic
    return EngSpeach.transcribe_audio_bytes(file_bytes)


async def process_video(file_bytes: bytes) -> str:
    # TOdO: video processing logic
    return "video processed"

async def process_test(content: str) -> str:
    return f"R u slow on purpose? {content}"