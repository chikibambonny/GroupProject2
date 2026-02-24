import cv2
import numpy as np
# import tf_keras
#from tensorflow import keras as tf_keras
import tensorflow as tf
tf_keras = tf.keras
import tempfile
import os
from collections import Counter

# -----------------------------
# Model + Labels (Loaded Once)
# -----------------------------

MODEL_PATH = r"C:\Users\almel\Kodcode\GroupProject\FlutterSignsAttempt2\flutter_application_1\backend\FastApiServer\app\features\SignsToText\keras_model.h5"
LABELS_PATH = r"C:\Users\almel\Kodcode\GroupProject\FlutterSignsAttempt2\flutter_application_1\backend\FastApiServer\app\features\SignsToText\labels.txt"

model = tf_keras.models.load_model(MODEL_PATH, compile=False)

with open(LABELS_PATH, "r", encoding="utf-8") as f:
    class_names = [line.strip().split(' ', 1)[-1] for line in f.readlines()]


# -----------------------------
# Internal Helpers
# -----------------------------

def _preprocess_frame(frame: np.ndarray) -> np.ndarray:
    img = cv2.resize(frame, (224, 224))
    img = np.asarray(img, dtype=np.float32).reshape(1, 224, 224, 3)
    img = (img / 127.5) - 1
    return img


def _map_label_to_hebrew(label: str) -> str:
    label = label.lower()
    if "bayit" in label:
        return "בית"
    elif "ahava" in label:
        return "אהבה"
    return label


# -----------------------------
# Public API Function
# -----------------------------

def predict_sign_from_video_bytes(
    video_bytes: bytes,
    confidence_threshold: float = 0.98,
    frame_skip: int = 3,
) -> str | None:
    """
    Receives raw video bytes.
    Returns detected Hebrew word or None.
    """

    # Save bytes to temp file (OpenCV needs file path)
    with tempfile.NamedTemporaryFile(delete=False, suffix=".mp4") as tmp:
        tmp.write(video_bytes)
        tmp_path = tmp.name

    cap = cv2.VideoCapture(tmp_path)
    predictions = []

    frame_index = 0

    while cap.isOpened():
        ret, frame = cap.read()
        if not ret:
            break

        # Skip frames for efficiency
        if frame_index % frame_skip != 0:
            frame_index += 1
            continue

        processed = _preprocess_frame(frame)

        prediction = model.predict(processed, verbose=0)
        index = np.argmax(prediction)
        confidence = float(np.max(prediction))

        if confidence >= confidence_threshold:
            label = class_names[index]
            hebrew_word = _map_label_to_hebrew(label)
            predictions.append(hebrew_word)

        frame_index += 1

    cap.release()
    os.remove(tmp_path)

    if not predictions:
        return None

    # Majority vote
    most_common = Counter(predictions).most_common(1)[0][0]
    return most_common