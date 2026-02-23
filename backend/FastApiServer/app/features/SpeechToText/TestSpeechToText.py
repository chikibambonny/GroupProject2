import subprocess
import io
import wave
import json
from vosk import Model, KaldiRecognizer

# ---- 1. Load your Vosk model ----
# Replace with your model folder path
MODEL_PATH = r"C:\Users\almel\Kodcode\GroupProject\FlutterSignsAttempt2\flutter_application_1\backend\FastApiServer\app\features\SpeechToText\models\vosk-model-small-en-us-0.15"
model = Model(MODEL_PATH)

# ---- 2. Function to recognize speech from audio bytes ----
def recognize_audio_bytes(audio_bytes: bytes, sample_rate: int = 16000) -> str:
    """
    Convert any audio bytes to WAV PCM16 mono and recognize text using Vosk.

    :param audio_bytes: Raw file bytes (wav, mp3, mp4, etc.)
    :param sample_rate: Target sample rate for recognition
    :return: Recognized text
    """

    # ---- Convert to WAV PCM16 mono using FFmpeg ----
    # 'pipe:0' = input from stdin, 'pipe:1' = output to stdout
    process = subprocess.Popen(
        [
            "ffmpeg",
            "-i", "pipe:0",          # input from stdin
            "-ar", str(sample_rate),  # resample
            "-ac", "1",               # mono
            "-f", "wav",              # format WAV
            "pipe:1"                  # output to stdout
        ],
        stdin=subprocess.PIPE,
        stdout=subprocess.PIPE,
        stderr=subprocess.DEVNULL
    )
    wav_bytes, _ = process.communicate(audio_bytes)

    # ---- Open WAV from bytes ----
    wf = wave.open(io.BytesIO(wav_bytes), "rb")

    rec = KaldiRecognizer(model, wf.getframerate())
    rec.SetWords(True)

    result_text = ""
    while True:
        data = wf.readframes(4000)
        if len(data) == 0:
            break
        if rec.AcceptWaveform(data):
            res = json.loads(rec.Result())
            result_text += res.get("text", "") + " "

    # Add final part
    final_res = json.loads(rec.FinalResult())
    result_text += final_res.get("text", "")

    return result_text.strip()


# ---- 3. Example usage ----
if __name__ == "__main__":
    # Example: read any audio file
    file_path = r"C:\Users\almel\Downloads\example.mp4"
    with open(file_path, "rb") as f:
        audio_bytes = f.read()

    text = recognize_audio_bytes(audio_bytes)
    print("Recognized text:", text)