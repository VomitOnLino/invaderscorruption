Type TTrackingVar
	'Stores current and max integers and can display them.
	'Useful for debug variables
	Field Current:Int
	Field maximum:Int
	Field displayLimit:Int = 999
	Field displayLimitChars:Int = 3
	Field Label:String = ""

	Method Init()
		Current = 0
		Maximum = 0
		DisplayLimit = 999
		DisplayLimitChars = Len(String(DisplayLimit))
	End Method	
	
	Method Display(x:Int,y:Int)
		DrawText GetDisplay(),x,y
	End Method		 
	
	Method GetDisplay:String()
		Return Label + PadWithZeros(Current, DisplayLimitChars) + "/" + PadWithZeros(maximum, DisplayLimitChars)		
	EndMethod
End Type


' -----------------------------------------------------------------------------
' TFixedRateLogic: 'keeps a game's logic running at a fixed rate, independent of refresh rate
' -----------------------------------------------------------------------------
Type TFixedRateLogic Extends TTrackingVar
	Field FramerateDefault% = 200 'Default value for restoring after slow motion or speed up.
	Field Framerate# = 200 'Speed you want the logic to run at.  Float on purpose so calculations end up as float.
	Field LastTime:Double
	Field TmpMS:Double 'float isn't accurate enough because Millisecs is such a big number
	Field NumTicks:Double
	Field LastNumTicks:Double
	Field MS# = 0 'milliseconds per frame float	e.g. 1000 millisecs/200 frames per second = 5ms per frame
	Field DeltaMultiplier#=1 'Alter this to speed up or slow down time.
	Field FullDelta# 'Records the unaltered Delta value.
	Field Fast:Int=0
	'Threshold clamps the change in millisecs to a fixed value so that if the logic
	'runs really slowly on a PC the timing code does not spiral out of control trying
	'to catch up and thus taking even longer and so on.  What will happen is that the
	'actual game will just slow down instead, but not loose update/collision accuracy
	'as would happen if we just used Delta timing only.  
	Field Threshold% = 60 'in Millisecs.  (Doesn't need to be a float.)

	Field JitterCorrection%=1 'Not much point in turning this off.
	Field HistorySize%=1 'Start the size small and grow it up to the Max.
	Field HistorySizeMax%=50 'Max History array slots.
	Field History%[] 'This is the History array used for Jitter Correction.  We'll grow it dynamically.			
	Field HistoryCounter%=0 'Points to the current array slot.	
	Field First%=0 'Is used to track how many frames we should ignore before recording the history.
	Field FirstMax%=15 'You can define how many frames are ignored before recording the history.
	Field IgnoreHistoryOnSpeedChange% = 1 'This will prevent a logic speed up/down to compensate for any slow downs/speed ups.
	
	Method Create() 'Must be called before Init
		'Create a history array
		Local h%[HistorySizeMax]
		History = h
	End Method
				
	Method Init() 'Make sure you call Create() first!
		CalcMS()
		'Set a first value for LastTime (it will be used in the main loop).
		'This method should also be called if gameplay is paused for any reason such as
		'showing Paused or a Menu, or focus regained after loss of focus.
		LastTime = MilliSecs()
		NumTicks = 0
		LastNumTicks = 1	
		SetDelta(1)
		Super.Init() 'Init the TrackingVar (base class) variables.

		'Set First so that we can avoid adding the next few frames to the history.
		'This is useful because we want the framerate to go steady before recording.
		'If Init() has been called mid-game we don't want to record the next elapsed
		'time because we have altered it artificially above.
		First=FirstMax
	End Method
	
	Method SetFPS(FPS:Float)
		FrameRate=FPS
	End Method
	
	Method ResetFPS()
		FrameRate=200
	End Method
	
	Method CalcMS()
		MS = CalcMSPerFrame(Framerate)
	End Method

	Method SetThreshold(t%) 'millisecs
		Threshold = t
	EndMethod
		
	Method Calc()
		'Used Fixed Rate Logic (Retro64 method) to calculate number of Logic Loop interations.
		'However, I've modified the Retro64 method to run a final loop iteration
		'with a fractional Delta value (the remainder) to make it more accurate.
		'I've also added Jitter Correction in V1.04 and better clamping for slow machines.
		
		'For our purposes, a tick is based on the Framerate field.
	
		'Are we running at full speed? i.e. no timing
		If Fast Then
			NumTicks =1 'only one logic loop per frame
		Else		
			'Get the time and make sure that at least 1 tick expired.
			Local Now% = MilliSecs()
			
			'Little sanity check here in Case the timer flips back To 0 :)
			If Now < LastTime Then
				NumTicks = LastNumTicks 'best we can do
			Else
				'Work out how much time has elapsed.
				TmpMS = Now - LastTime			
				'Apply the threshold.  This should stop the logic time (and numticks)
				'spiralling out of control on slow PCs.
				If TmpMS>Threshold Then TmpMS=Threshold 

				'Get average			
				Local Av! = 0
				'Don't store the few frame as part of the history because they are often unstable.
				If First>0 Then
					First:-1
					Av = TmpMs
				Else
					'Store the current time difference in the History array.
					History[HistoryCounter]=TmpMS
					'Now add up all the values in the History Array.
					For Local i%=0 To HistorySize-1
						Av:+History[i]
					Next
					'Get an average.
					Av=Av/HistorySize
					'Move the counter on ready for the next slot.
					HistoryCounter:+1
					'Do we need to grow the array?
					If HistorySize<HistorySizeMax Then HistorySize:+1
					'Do we need to loop the Counter back to the start of the array?
					If HistoryCounter>=HistorySize Then HistoryCounter=0
				EndIf
	
				'Shall we apply JitterCorrection?
				If JitterCorrection Then
					'Only apply IgnoreHistoryOnSpeedChange if VSync is On, otherwise Jitter Correction will only half work for VSync Off.
					If IgnoreHistoryOnSpeedChange And VerticalSync=1 Then
						If TmpMS < av-1 Or TmpMS > av+1 Then 'Is current rendering faster or slower than the average? (-1/+1 is used for a bit of allowance)
							av=TmpMS
						EndIf
					EndIf
					NumTicks = Av/MS 'use the average
				Else
					NumTicks = TmpMS/MS 'use the last value passed in
				EndIf
			EndIf
			
			'Must track the current time for next time round.
			LastTime = Now
					
			Rem All this code is now obsolete since V1.04
			'Implement a threshold that if NumTicks goes over, it gets set to 0.
			'This may help on some PCs where jerks occur due to the logic catching up
			'because any sprites will simply pause instead. This still won't look smooth
			'but if might be better than the sprites/animation jerking on a lot forward.
			If NumTicks > Threshold Then NumTicks = 0
'			If NumTicks > Threshold Then NumTicks = 1 'or try 1 or more instead (3 is about right for a 60Hz refresh)
			
			'Account for when the user alt-tabs (i.e. don't allow a silly amount of logic iterations).
			'Actually this may not occur as this game framework detects when focus is lost
			'and regained and calls Init() to reset LastTime.
			'Remember NumTicks is not in millisecs, it's Millisecs/MS and MS is normally 5 if framerate is 200.
			If NumTicks > 100 Then NumTicks = LastNumTicks 'use the last sensible value (hopefully).
			'Prevent too many iterations on really slow machines.
			If NumTicks > 50 Then NumTicks = 50
			End Rem
			
			'Track the current number of ticks in case for next time round. 
			LastNumTicks = NumTicks		
			'Keep track of MaxTicks for debug purposes.
			If NumTicks > maximum Then maximum = NumTicks
		EndIf
		Current = numticks 'set display variable
	End Method
	
	Method SetDelta(d#)
		'Sets a global variable called Delta for use with all movement.
		Delta = d#*DeltaMultiplier
		FullDelta = d# 'store this
	End Method

	Method SetDefaultFramerate(NewFrameRate%)
		FramerateDefault = NewFrameRate
		Framerate = NewFrameRate
	End Method
	
	Method HistoryClear()
		For Local i%=0 To HistorySize-1
			History[i]=0
		Next
		HistorySize=1 'make sure we have a single array slot
		HistoryCounter=0 'point to the first array slot.
	End Method	
End Type


' -----------------------------------------------------------------------------
' Work out MilliSecs per frame so all game times can be specified as MS
' -----------------------------------------------------------------------------
Function CalcMSPerFrame#(theFrameRate%)
	Return 1000.0/theFrameRate 'use .0 to ensure Float is returned
End Function