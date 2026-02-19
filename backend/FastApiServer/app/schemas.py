from pydantic import BaseModel
from typing import Optional

class TextRequest(BaseModel):
    type: str = "text"
    content: str

class ProcessResponse(BaseModel):
    status: str
    result: Optional[str] = None
    error: Optional[str] = None