import os
import json
import time
import requests
from tqdm import tqdm
from requests.adapters import HTTPAdapter
from urllib3.util.retry import Retry

BASE_URL = "https://files.dan.city/isl/videos/"
DOWNLOAD_DIR = "downloads"
DICT_PATH = r"C:\Users\USER\Downloads\DataBase\dict.json"

os.makedirs(DOWNLOAD_DIR, exist_ok=True)

# ✅ Create safe requests session with retries + SSL fix
session = requests.Session()
retries = Retry(
    total=5,
    backoff_factor=1,
    status_forcelist=[500, 502, 503, 504],
)
session.mount("https://", HTTPAdapter(max_retries=retries))

# ✅ Load JSON
with open(DICT_PATH, "r", encoding="utf-8") as f:
    data = json.load(f)

# ✅ Build ID -> TITLE mapping from groups + words
id_to_title = {}

for section in ["groups", "words"]:
    if section in data:
        for title, ids in data[section].items():
            for vid in ids:
                id_to_title[vid] = title.strip().replace("/", "_")

lesson_ids = list(id_to_title.keys())

print(f"✅ Loaded {len(lesson_ids)} total video IDs")

# ✅ SSL-safe downloader
def download_file(url, filename):
    try:
        r = session.get(url, stream=True, timeout=15)
        if r.status_code != 200:
            return False

        total = int(r.headers.get("content-length", 0) or 0)

        with open(filename, "wb") as f, tqdm(
            desc=os.path.basename(filename),
            total=total,
            unit="B",
            unit_scale=True,
            unit_divisor=1024,
        ) as bar:
            for chunk in r.iter_content(chunk_size=1024):
                if chunk:
                    f.write(chunk)
                    bar.update(len(chunk))

        return True

    except requests.exceptions.SSLError:
        print("⚠️ SSL error, skipped safely")
        return False

    except requests.exceptions.RequestException as e:
        print("⚠️ Network error:", e)
        return False


# ✅ Download everything using TITLE as filename
for i, lesson_id in enumerate(lesson_ids, 1):
    title = id_to_title.get(lesson_id, lesson_id)
    safe_title = "".join(c for c in title if c not in r'\/:*?"<>|')
    url = BASE_URL + lesson_id + ".mp4"
    filename = os.path.join(DOWNLOAD_DIR, f"{safe_title}.mp4")

    print(f"\n📥 [{i}/{len(lesson_ids)}] Downloading: {title}")
    ok = download_file(url, filename)

    if ok:
        print("✅ Saved as:", filename)
    else:
        print("❌ Missing / blocked")

    time.sleep(0.3)  # anti-rate-limit chill

print("\n✅✅✅ DONE — ALL POSSIBLE VIDEOS DOWNLOADED WITH HEBREW NAMES ✅✅✅")
