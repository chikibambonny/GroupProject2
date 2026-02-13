import http
import queue
import subprocess
import base64
from flask_socketio import SocketIO,emit,Namespace
from  flask import  request
from werkzeug.sansio.multipart import Data

from config import *
from flask import Flask

class RestApi(Namespace):
    def __init__(self, namespace=None,app:Flask=None):
        self.app = app
        self.q:queue.Queue = queue.Queue()
        super().__init__(namespace)
    def on_video_event(self, data):
        if not data or 'data' not in data or 'command' not in data:
            return
        base64_string = data['data']
        video_bytes:bytes = base64.b64decode(base64_string)
        sid = request.sid
        self.q.put(Task(data['command'],video_bytes,sid))
    def response(self,response:Data):
        emit(response.event,response.data,room=response.sid)

class Task:
    def __init__(self,command:str,data:bytes,sid:str):
        self.command:str=command
        self.data:bytes=data
        self.sid:str=sid


class Data:
    def __init__(self, event: str, data: str, sid: str):
        self.event: str = event
        self.data: str = data
        self.sid: str = sid


app = Flask(__name__)
def main(app:Flask):
    socketio = SocketIO(app, cors_allowed_origins="*")
    rest_api_instance = RestApi('/', app)
    socketio.on_namespace(rest_api_instance)
    socketio.run(app, host='127.0.0.1', port=SERVER_PORT, debug=True)

if __name__ == '__main__':
    main(app)