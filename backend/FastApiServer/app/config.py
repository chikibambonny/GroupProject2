from pydantic import BaseSettings

class Settings(BaseSettings):
    app_name: str = "Server Processing API"
    debug: bool = True

settings = Settings()