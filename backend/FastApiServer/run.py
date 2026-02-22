import uvicorn
from app import config

if __name__ == "__main__":
    uvicorn.run(
        "app.main:app",
        host=config.SERVER_IP,
        port=config.SERVER_PORT,
        reload=True
    )