# Reaper_InsertLyrics
Inserts lyrics from whisper-generated json file

I save my personal reaper scripts here:

~/Library/Application\ Support/REAPER/Scripts/Owen

It reads the Whisper generated json file to get the lyrics.

<ol>
<li>	Add a New Track for Lyrics:</li>
&emsp;	◦	Insert a new track and name it "Lyrics."<br>
<li>   If starting from an mp3 convert to whisper-required format 16khz wav using ffmpeg.</li>
&emsp;    ◦   ffmpeg -i input.mp3 -ar 16000 -ac 1 -c:a pcm_s16le output.wav<br>
<li>   Extract Lyrics using Whisper:</li>
&emsp;    ◦   ~/dev/whisper.cpp-master/build/bin/whisper-cli -m ~/dev/whisper.cpp-master/models/ggml-small.en.bin  -ng -debug -ml 1 -ojf jfk.wav<br>
<li>   Use this script to insert empty midi items in a pre-existing track named "Lyrics" with the words in tthe iteem notes.</li>
<li>   To display the lyrics karaoke style in a browser use the x-raym script: X-raym convert track items</li>
</ol>

To put it mildly: this is first draft and leaves a lot out.

