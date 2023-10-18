' NOTE: this funtionality has been removed for now, stay tuned
' For use with the threaded version of blitzmax.
SuperStrict

Import MaxMod2.RtAudio

SetAudioStreamDriver("MaxMod RtAudio")

Graphics 800,600,0

Local test:TAudio = New TAudio
Local Chn:TChannel = CreateAudioCallbackStream(test)
Repeat
	Cls
	DrawText test.p,10,10
	Flip
Until ChannelPlaying(Chn)=0 Or KeyHit(KEY_ESCAPE) Or AppTerminate()
test=Null


Type TAudio Extends TCustomMusic

	Field p!, p1!

	Method New()
		SampleRate = 44100							' set required samplerate
		Channels   = 2								' set the number of channels
		Bits       = 16							' set bits per channel
	EndMethod

	Method FillBuffer:Int(output:Byte Ptr,size:Int)

'		Local txt$ = Int(output)+"1"+Int(SampleRate) ' stress garbage collector
		
		Local AudioPtr:Short Ptr = Short Ptr(output)		' get out pointer to the output
		Local n:Int,av!							' make some local variables
		For n=0 Until size/2						' loop to process the output buffer
			av=cos(p)*35000
			'av=Sin( Sin(p1^2)*ATan(p^2)*20000 )*5000	' calculate our audio value
			'If p1<1 Then av:*p1					' add a simple fade in
			AudioPtr[n] = av						' apply audio value to output
			p:+0.01 ; p1:+0.10009					' increment for next pass
'			If p>1000000 Exit;						' stop after 10000000 samples
		Next
		Return n*2								' return number of bytes written to output.
												' a return value less than 'size' 
												' causes the stream to stop
	EndMethod

EndType
