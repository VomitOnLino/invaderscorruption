' example of non-blocking audio sample loading (threaded stream to memory)
' audio playback is via freeaudio and no maxmod audio driver is required,
' but if you do use the MaxMod2 audio driver you can start playback straightaway 
' as MaxMod plays directly from the audio sample data ;)

SuperStrict

Framework BRL.FreeAudioAudio
Import MaxMod2.ModPlayer
Import MaxMod2.Flac
Import MaxMod2.OGG
Import MaxMod2.WAV
Import MaxMod2.RtAudio

MaxModVerbose True
SetAudioDriver "MaxMod RtAudio"

Print "Loading Music..."
Global Music:TMusic = LoadTMusic(RequestFile("",MusicExtensions()))
If Not Music RuntimeError "Unable to open file"

Print "Creating sample"
Local sample:TAudioSample = CreateAudioSample(Music.GetLength(MM_SAMPLES), Music.GetSampleRate(), Music.GetFormat() )

Print "Streaming audio into memory (non blocking)"
Local stream:TChannel = CreateMemoryStream(Music,Sample.Samples)

' wait for loading to complete
'Repeat
'	Delay 100
'	StandardIOStream.WriteString(".")
'	StandardIOStream.Flush()
'Until Not ChannelPlaying(stream)
'StandardIOStream.WriteString("Complete~n")
Local working%=1

Print "Playing!"
Local Sound:TSound = LoadSound(sample,SOUND_LOOP)
Global Channel:TChannel = PlaySound(sound)

Repeat
	If working And Not ChannelPlaying(stream) ; Print "Streaming complete" ; working=0
	PollSystem()
	Delay 10
Until Not ChannelPlaying(Channel)
