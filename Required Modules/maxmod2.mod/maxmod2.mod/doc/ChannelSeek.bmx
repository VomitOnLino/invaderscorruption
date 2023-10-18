SuperStrict

Import MaxMod2.RtAudio
Import MaxMod2.ModPlayer

Graphics 320,240,0

SetAudioStreamDriver "MaxMod RtAudio"
'MaxModVerbose True

Local file$ = RequestFile("",MusicExtensions())
Local channel:TChannel = PlayMusic(file,True)
If Not channel RuntimeError "unable to play file"

Repeat
	Cls

	If KeyHit(KEY_SPACE) 
		PauseChannel(channel)
		ChannelSeek(channel,1,MM_SEQUENCE)
		ChannelSeek(channel,32,MM_LINE)
		ResumeChannel(channel)
	EndIf

	DrawText "    LENGTH: "+GetChannelLength(Channel,MM_SAMPLES),10,25
	DrawText "  POSITION: "+GetChannelPosition(Channel,MM_MILLISECS),10,40
	DrawText "  SEQUENCE: "+GetChannelPosition(Channel,MM_SEQUENCE)+"/"+GetChannelLength(Channel,MM_SEQUENCE),10,55
	DrawText "      LINE: "+GetChannelPosition(Channel,MM_LINE),10,70
	DrawText "   PLAYING: "+ChannelPlaying(Channel),10,85

	Flip
Until KeyHit(KEY_ESCAPE) Or AppTerminate()
