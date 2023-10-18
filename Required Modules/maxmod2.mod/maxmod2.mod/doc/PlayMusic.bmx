SuperStrict
Import MaxMod2.RtAudio
Import MaxMod2.Ogg
Import MaxMod2.Flac
Import MaxMod2.ModPlayer
Import MaxMod2.Wav

SetAudioStreamDriver("MaxMod RtAudio")
'MaxModVerbose True

Local file$ = RequestFile( "", MusicExtensions() )
Local Channel:TChannel = PlayMusic( file )
If Not Channel RuntimeError("Unable to cue music")

Repeat
	Delay 10
	PollSystem()
Until ChannelPlaying(Channel)=False
