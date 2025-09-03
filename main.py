#!/usr/bin/env python3
"""
Speech-to-Text with Python SpeechRecognition + Google Web Speech API
-------------------------------------------------------------------
This script:
- Listens to your microphone for a phrase
- Uses Google's free Web Speech API to transcribe (requires internet)
- Prints recognized text or an error if nothing is detected
"""

import speech_recognition as sr

def main():
    recognizer = sr.Recognizer()
    mic = sr.Microphone()

    with mic as source:
        print("🎙️  Adjusting for ambient noise...")
        recognizer.adjust_for_ambient_noise(source)
        print("✅ Ready. Speak now!")
        audio = recognizer.listen(source)

    try:
        text = recognizer.recognize_google(audio)
        print("📝 You said:", text)
    except sr.UnknownValueError:
        print("❌ Google Speech Recognition could not understand audio.")
    except sr.RequestError as e:
        print(f"⚠️ Could not request results; {e}")

if __name__ == "__main__":
    main()
