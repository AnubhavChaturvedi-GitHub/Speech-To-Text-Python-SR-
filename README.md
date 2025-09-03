# 🎙️ Speech-to-Text (Google Web Speech API) 
<a href="https://github.com/AnubhavChaturvedi-GitHub/Speech-to-Text-with-Python-Google-Web-Speech-API/raw/main/run_speech_to_text.bat">
  <img src="https://img.shields.io/badge/Download-.bat%20file-blue?style=for-the-badge" alt="Download .bat file">
</a>

A simple **Speech-to-Text (STT)** system in Python using the [SpeechRecognition](https://pypi.org/project/SpeechRecognition/) library and Google’s Web Speech API.
It listens to your microphone, sends the audio to Google’s cloud recognizer, and prints the transcribed text.

<img src="https://github.com/AnubhavChaturvedi-GitHub/Speech-To-Text-Python-SR-/blob/main/Asset/svgviewer-output%20(1).svg" width="1000" />

---

## ✨ Features

* 🎤 Capture live audio from your microphone.
* ☁️ Cloud-based transcription using Google’s Web Speech API.
* ⚡ Real-time transcription with minimal setup.
* 🛠️ Minimal Python dependencies for quick prototyping.

---

## 📂 Project Structure

```
├── stt_speechrecognition.py         # Main script (run this)
├── requirements_speechrecognition.txt  # Python dependencies
├── README.md                        # Documentation (this file)
```

---

## 🚀 Getting Started

### 1. Prerequisites

* **Python 3.8+**
* A working **microphone**
* Internet connection (required for Google Web Speech API)
* System audio backend:

  * **macOS**:

    ```bash
    brew install portaudio
    ```
  * **Ubuntu/Debian**:

    ```bash
    sudo apt-get install portaudio19-dev python3-pyaudio
    ```
  * **Windows**:
    Download PyAudio wheels from [here](https://www.lfd.uci.edu/~gohlke/pythonlibs/#pyaudio) and install with `pip install <wheel-file>`.

---

### 2. Installation

Clone or download this repo, then install dependencies:

```bash
pip install -r requirements_speechrecognition.txt
```

---

### 3. Usage

Run the script:

```bash
python stt_speechrecognition.py
```

Steps:

1. The program adjusts for background noise.
2. Speak into your microphone.
3. The recognized text is printed to the terminal.

---

## ⚠️ Notes & Limitations

* Requires an active **internet connection** (Google Web Speech API).
* API is **free but limited** (not suitable for very large-scale transcription).
* For **offline transcription**, consider using [OpenAI Whisper](https://github.com/openai/whisper).

---

## 📌 Example Output

```
🎙️  Adjusting for ambient noise...
✅ Ready. Speak now!
📝 You said: Hello world, this is my Jarvis project!
```

---

## 🛠️ Next Steps

Enhance your project by adding:

* **Wake word detection** (e.g., “Jarvis”).
* **Text-to-Speech (TTS)** for voice responses.
* **Custom commands** (open apps, fetch info, control IoT devices).

---

## 📄 License

This project is licensed under the **MIT License** — free to use, modify, and distribute.

