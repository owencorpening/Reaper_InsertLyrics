# Reaper_InsertLyrics
Inserts lyrics from whisper-generated json file

I save my personal reaper scripts here:

~/Library/Application\ Support/REAPER/Scripts/Owen

It reads the Whisper generated json file to get the lyrics.

1	Add a New Track for Lyrics:
	◦	Insert a new track and name it "Lyrics."
2   If starting from an mp3 convert to whisper-required format 16khz wav using ffmpeg.
    ◦   ffmpeg -i input.mp3 -ar 16000 -ac 1 -c:a pcm_s16le output.wav
3   Extract Lyrics using Whisper:
    ◦   ~/dev/whisper.cpp-master/build/bin/whisper-cli -m ~/dev/whisper.cpp-master/models/ggml-small.en.bin  -ng -debug -ml 1 -ojf jfk.wav
4   Use this script to insert empty midi items in a pre-existing track named "Lyrics" with the words in tthe iteem notes.
5   To display the lyrics karaoke style in a browser use the x-raym script: X-raym convert track items

To put it mildly: this is first draft and leaves a lot out.

