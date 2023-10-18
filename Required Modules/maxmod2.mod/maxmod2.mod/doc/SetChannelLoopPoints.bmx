SuperStrict
Import MaxMod2.RtAudio

SetAudioDriver("MaxMod RtAudio")
'MaxModVerbose True

Local Sound:TSound = LoadSound(RequestFile( "", "ogg,wav" ))
If Not Sound RuntimeError "Unable to load sound sound"

Local Channel:TChannel = CueSound(Sound)
If Not Channel RuntimeError "No channel?"

SetChannelLoopPoints(Channel,15000,30000)
SetChannelLoop(Channel,True)
ResumeChannel(Channel)

Repeat
	Delay 10
	PollSystem()
Until ChannelPlaying(Channel)=False Or KeyHit(KEY_ESCAPE)
