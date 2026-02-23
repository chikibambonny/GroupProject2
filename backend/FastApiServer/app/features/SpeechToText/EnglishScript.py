# EnglishScript.py
from vosk import Model, KaldiRecognizer
import io
from io import BytesIO
from pydub import AudioSegment
import wave
import json
from pathlib import Path
import os
import subprocess
import tempfile
from pathlib import Path


def convert_to_mono_16k(input_path: str) -> str:
    """
    Convert any audio/video file to mono 16kHz WAV using FFmpeg.
    Returns the path to the converted WAV file.
    """
    input_path = Path(input_path)
    output_file = tempfile.mktemp(suffix=".wav")  # temporary WAV file

    cmd = [
        "ffmpeg",
        "-y",                 # overwrite if exists
        "-i", str(input_path),
        "-ac", "1",           # mono
        "-ar", "16000",       # 16kHz
        "-vn",                # drop video stream if any
        "-f", "wav",
        output_file
    ]

    try:
        subprocess.run(cmd, check=True, capture_output=True)
        return output_file
    except subprocess.CalledProcessError as e:
        print("FFmpeg error:", e.stderr.decode())
        raise



# Path to your Vosk model
MODEL_PATH = r"C:\Users\almel\Kodcode\GroupProject\FlutterSignsAttempt2\flutter_application_1\backend\FastApiServer\app\features\SpeechToText\models\vosk-model-small-en-us-0.15"
print("MODEL_PATH:", MODEL_PATH)
print("Exists:", os.path.exists(MODEL_PATH))
print("Contents:", os.listdir(MODEL_PATH))
model = Model(MODEL_PATH)

def transcribe_audio_bytes(file_bytes: bytes) -> str:
    wav_file = convert_to_mono_16k(file_bytes)

    with wave.open(wav_file, "rb") as wf:
        rec = KaldiRecognizer(model, wf.getframerate())
        result = ""
        while True:
            data = wf.readframes(4000)
            if len(data) == 0:
                break
            if rec.AcceptWaveform(data):
                result += rec.Result()
        result += rec.FinalResult()
        return result.strip()





    '''
    wf = wave.open(io.BytesIO(file_bytes), "rb")
    print("Channels:", wf.getnchannels())
    print("Sample width:", wf.getsampwidth())
    print("Frame rate:", wf.getframerate())

    if wf.getnchannels() != 1:
        raise ValueError("Audio must be mono")

    if wf.getsampwidth() != 2:
        raise ValueError("Audio must be 16-bit PCM")

    rec = KaldiRecognizer(model, wf.getframerate())
    rec.SetWords(True)

    text = ""

    while True:
        data = wf.readframes(4000)
        if len(data) == 0:
            break
        if rec.AcceptWaveform(data):
            text += json.loads(rec.Result()).get("text", "") + " "

    text += json.loads(rec.FinalResult()).get("text", "")
    return text.strip()






    
    Accepts audio or video bytes (wav, mp4, m4a),
    converts to PCM WAV, and returns transcribed text.
    
    # Convert input bytes to AudioSegment
    audio = AudioSegment.from_file(BytesIO(file_bytes))

    # Ensure 16kHz mono WAV for Vosk
    audio = audio.set_frame_rate(16000).set_channels(1).set_sample_width(2)

    # Export to in-memory WAV
    wav_io = BytesIO()
    audio.export(wav_io, format="wav")
    wav_io.seek(0)

    # Use wave module to read PCM
    with wave.open(wav_io, "rb") as wf:
        recognizer = KaldiRecognizer(model, wf.getframerate())
        recognizer.SetWords(True)
        result_text = ""

        while True:
            data = wf.readframes(4000)
            if len(data) == 0:
                break
            if recognizer.AcceptWaveform(data):
                res = json.loads(recognizer.Result())
                result_text += res.get("text", "") + " "

        # Final bits
        final_res = json.loads(recognizer.FinalResult())
        result_text += final_res.get("text", "")

    return result_text.strip()
'''



'''import vosk
import json
import wave
import io
from pydub import AudioSegment
from io import BytesIO
from pathlib import Path


# __file__ is current script file
BASE_DIR = Path(__file__).parent  # points to SpeechToText folder
MODEL_PATH = BASE_DIR / "models/vosk-model-small-en-us-0.15"

model = vosk.Model(str(MODEL_PATH))

# Load once at startup
import vosk


MODEL_PATH = "models/vosk-model-small-en-us-0.15"
model = vosk.Model(MODEL_PATH)

def transcribe_audio_bytes(file_bytes: bytes):
    # Convert any audio/video to WAV in memory
    audio = AudioSegment.from_file(BytesIO(file_bytes))
    wav_io = BytesIO()
    audio.export(wav_io, format="wav")
    wav_io.seek(0)

    wf = wave.open(wav_io, "rb")
    rec = vosk.KaldiRecognizer(model, wf.getframerate())
    result_text = ""

    while True:
        data = wf.readframes(4000)
        if len(data) == 0:
            break
        if rec.AcceptWaveform(data):
            result_text += rec.Result()
    result_text += rec.FinalResult()
    return result_text
'''







'''
# Queue to hold audio chunks
q = queue.Queue()

# Load the Vosk model
model = vosk.Model(eng_model_path) 
recognizer = vosk.KaldiRecognizer(model, 16000)

# Callback function to put microphone data into the queue
def callback(indata, frames, time, status):
    if status:
        print(status)
    q.put(bytes(indata))

# Open the microphone stream
with sd.RawInputStream(samplerate=16000, blocksize=8000, dtype='int16',
                       channels=1, callback=callback):
    print("Listening... Press Ctrl+C to stop.")
    try:
        while True:
            data = q.get()
            if recognizer.AcceptWaveform(data):
                result = json.loads(recognizer.Result())
                print(">>", result.get("text", ""))
            else:
                partial = json.loads(recognizer.PartialResult())
                print("\r" + partial.get("partial", ""), end="")
    except KeyboardInterrupt:
        print("\nStopped.")
'''