SuperStrict
Import MaxMod2.Ogg
Import MaxMod2.Flac
Import MaxMod2.ModPlayer
Import MaxMod2.Wav

'MaxModVerbose True

Print "Loading Music..."
Local file$ = RequestFile( "Choose an audio file to load", MusicExtensions() )
Local Sample:TAudioSample = LoadMusic( file )
If Not Sample RuntimeError("Unable to load music")
Print "Complete"

Local Sound:TSound = LoadSound(Sample)
If Not Sample RuntimeError("Unable to load sound")
Local Channel:TChannel = PlaySound(sound)

Repeat
	Delay 10
	PollSystem()
Until ChannelPlaying(Channel)=False
