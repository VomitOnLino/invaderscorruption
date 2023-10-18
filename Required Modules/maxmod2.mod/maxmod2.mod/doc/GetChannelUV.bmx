SuperStrict

Import MaxMod2.RtAudio
Import MaxMod2.ModPlayer
Import MaxMod2.OGG
Import MaxMod2.FLAC
Import MaxMod2.WAV

SetAudioStreamDriver("MaxMod RtAudio")
'MaxModVerbose True

Graphics 30,200,0

Local Channel:TChannel = PlayMusic(RequestFile("",MusicExtensions()))
If Not Channel RuntimeError "no channel?"

Local L!,R!
Repeat

	Cls

	GetChannelUV(Channel,L,R)

	SetColor(100,100,150)
	DrawRect(5,5,10,190)
	DrawRect(20,5,10,190)

	SetColor(255,255,255)
	DrawRect(5,195-(190*L),10,190*L)
	DrawRect(20,195-(190*R),10,190*R)

	Flip

Until ChannelPlaying(Channel)=0 Or AppTerminate() Or KeyHit(KEY_ESCAPE)
