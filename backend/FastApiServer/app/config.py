from enum import Enum

SERVER_IP = "0.0.0.0"
SERVER_PORT = 8000

APP_NAME = "Server Processing API"
ISDEBUG = True

class Command(str, Enum):
    email = "email"
    video = "video"
    audio = "audio"


class Routes:
    PROCESS_PREFIX = "/process"

    EMAIL = f"{PROCESS_PREFIX}/{Command.email}"
    VIDEO = f"{PROCESS_PREFIX}/{Command.video}"
    AUDIO = f"{PROCESS_PREFIX}/{Command.audio}"