'--------------------------------------------------------------------------------------------------
'The Very Basic "Entity-Skeleton" of my Engine, Each animated Object should inherit these functions
'--------------------------------------------------------------------------------------------------
Type TObject

	Field X:Float,Y:Float
	Field XSpeed:Float,YSpeed:Float
	Field Direction:Float
	
	Function UpdateAll() EndFunction
	
	Method New() EndMethod
	
	Method Update() EndMethod

	Method Destroy() EndMethod


End Type

'-----------------------------------------------------------------------------
'Shake the Screen, old-style arcade Effect
'-----------------------------------------------------------------------------
Type ScreenShake
	Global ShakeX:Float
	Global ShakeY:Float
	Global Force:Float
	
	Function Update()
		Local CurrX:Float
		Local CurrY:Float
		Local FailSafe:Int=0
		
		If GameState=Pause Return
	
		If Force>=0
			If Force>1.4
				GetOrigin (CurrX,CurrY)
				Repeat
					ShakeX=Rnd(Force*-2,Force*2)
					ShakeY=Rnd(Force*-2,Force*2)
					FailSafe:+1
				Until Abs(CurrX-ShakeX)>1.25 Or Abs(CurrY-ShakeY)>1.25 Or FailSafe>=8
			Else
				ShakeX=Rnd(-Force,Force)
				ShakeY=Rnd(-Force,Force)
			End If
			
			Force:-.019*Delta
	
		End If
		
	End Function
	
	Function Draw()
		
		If GameState=Pause Return
		
		If Force>0
			SetOrigin ShakeX,ShakeY
		Else
			Force=0
			SetOrigin 0,0
		End If
	End Function

End Type

'-----------------------------------------------------------------------------
'Water effect background
'-----------------------------------------------------------------------------
Type TWater Extends TObject
	Const Dampening:Float=0.966
	
	Field Width:Int,Height:Int
	Field Pool:Float[,]
	Field Buffer:Float[,]
	Field TempArray:Float[,]
	Field ClearBit:Byte
	Field DidUpdate:Byte
	
	Global EX:Int
	Global EY:Int
	Global MX:Int
	Global MY:Int
	
	Global Size:Int=6
	Global WideOffset:Float=1.0
	
	Global Image:TImage
	Global GameRGB:Int[3]
	Global BrightRGB:Int[3]
	
	Method New()
		Width = ScreenWidth*.125
		Height = ScreenHeight*.125
		Width:+3
		Height:+3
	End Method
	
	Method AspectChange()
		Pool = New Float[Width,Height]
		Buffer = New Float[Width,Height]
		TempArray = New Float[Width,Height]
		For Local x:Int = 0 To Width-1
			For Local y:Int = 0 To Height-1
				Pool[x,y] = 0
				Buffer[x,y]=0
			Next
		Next
	End Method
	
	Method Init()
		Pool = Null
		Buffer = Null
		TempArray = Null
		Local Hue:Int
		Pool = New Float[Width,Height]
		Buffer = New Float[Width,Height]
		TempArray = New Float[Width,Height]
		For Local x:Int = 0 To Width-1
			For Local y:Int = 0 To Height-1
				Pool[x,y] = 0
				Buffer[x,y]=0
			Next
		Next
		For Local i=0 To 2
			GameRGB[i]=Rand(120,210)
		Next
		RGB_to_HSL(GameRGB[0],GameRGB[1],GameRGB[2])
		Hue=Rand(50,320)
		Result_H=Hue
		If Result_L<=.66
			'Print "dark"
			Result_L:+.2
		End If
		If Result_S<=.59
			'Print "Drab"
			Result_S:+.515
		End If
		
		HSL_to_RGB(Result_H,Result_S,Result_L)
		
		GameRGB[0]=Result_R
		GameRGB[1]=Result_G
		GameRGB[2]=Result_B
		
		Result_L:+.035
		Result_S:+.015
		
		HSL_to_RGB(Result_H,Result_S,Result_L)
		
		BrightRGB[0]=Result_R
		BrightRGB[1]=Result_G
		BrightRGB[2]=Result_B
	End Method
	
	Method Clear()
		For Local x:Int = 0 Until Width
			For Local y:Int = 0 Until Height
				Pool[x,y] = 0
				Buffer[x,y] = 0
				TempArray[x,y] = 0
			Next
		Next

	EndMethod
	
	Method Update()
		
		If ClearBit			
			MemCopy(TempArray,Pool,SizeOf(Pool))
			MemCopy(Pool,Buffer,SizeOf(Buffer))
			MemCopy(Buffer,TempArray,SizeOf(TempArray))
			Rem
			For Local x:Int = 0 To Width-1
				For Local y:Int = 0 To Height-1
					TempArray[x,y]=Pool[x,y]
					Pool[x,y]=Buffer[x,y]
				Next
			Next
			For Local x:Int = 0 To Width-1
				For Local y:Int = 0 To Height-1
					Buffer[x,y]=TempArray[x,y]
				Next
			Next
			End Rem
			ClearBit=False
		End If
		If DidUpdate=False
			If Explosion.List
				Local Explosion:TExplosion
				For Explosion = EachIn Explosion.List
					If Explosion.CurrentFrame<=2
						EX=Explosion.X*.125
						EY=Explosion.Y*.125
						If EX>0 And EY>0 And EX<Width And EY<Height Then Buffer[EX,EY]=1+2.5*Explosion.Size
					End If
				Next
			End If
			If PlayerBomb.List
				Local PlayerBomb:TPlayerBomb
				For PlayerBomb = EachIn PlayerBomb.List
					If  PlayerBomb.Radius>0 And PlayerBomb.Radius<=6
						EX=PlayerBomb.X*.125
						EY=PlayerBomb.Y*.125
						If EX>0 And EY>0 And EX<Width And EY<Height Then Buffer[EX,EY]=25
					End If
				Next
			End If

			MX = Player.X*.125
			MY = Player.Y*.125
			If MX>0 And MY>0 And MX<Width And MY<Height And Abs(Player.XSpeed)+Abs(Player.YSpeed)>0.2 Then Buffer[MX,MY]= Min(Abs(Player.XSpeed)+Abs(Player.YSpeed),1.55) '1.5		
			For Local x:Int = 1 Until Width-2
				For Local y:Int = 1 Until Height-2
					Pool[x,y] = ((Buffer[x-1,y]+Buffer[x+1,y]+Buffer[x,y+1]+Buffer[x,y-1]) /2 - Pool[x,y])*Dampening
				Next
			Next
			DidUpdate=True
		End If
		
	End Method

	Method Draw(HalfTone:Byte=False)
		Local GrabColor:Float
		'Local updatetime=MilliSecs()
		If HalfTone
			If GlowQuality<512 And FullScreenGlow
				Size=2
				WideOffset=-7
			Else
				If GlowQuality>512
					Size=4
					WideOffset=-5
				Else
					Size=3
					WideOffset=-6
				End If
			End If
		Else
			If GlowQuality<512 And FullScreenGlow
				Size=9
			Else
				If GlowQuality>512
					Size=6
					WideOffset=1
				Else
					Size=6
					WideOffset=0.5
				End If
			End If
		End If
		If HalfTone
			If GlLines
				SetScale 1,1
				glDisable GL_TEXTURE_2D ; glBegin GL_QUADS
				SetColor GameRGB[1]*.3,GameRGB[2]*.3,GameRGB[0]*.3
				For Local x:Int = 0 To Width-1 
					For Local y:Int = 0 To Height-1
						If Pool[x,y]>0.12
							If Pool[x,y]>.3 SetColor GameRGB[1]*.88,GameRGB[2]*.88,GameRGB[0]*.88
							'SetAlpha Pool[x,y]
							If WideScreen
								FastRect x*8-8,y*8-8,Size-WideOffset,Size
							Else
								FastRect x*8-8,y*8-8,Size-WideOffset,Size
							End If
							If Pool[x,y]>.3 SetColor GameRGB[1]*.3,GameRGB[2]*.3,GameRGB[0]*.3
						End If
					Next
				Next
				glEnd ; glEnable GL_TEXTURE_2D	
			Else
				SetScale 1,1
				SetColor GameRGB[1]*.3,GameRGB[2]*.3,GameRGB[0]*.3
				For Local x:Int = 0 To Width-1 
					For Local y:Int = 0 To Height-1
						If Pool[x,y]>0.12
							If Pool[x,y]>.3 SetColor GameRGB[1]*.88,GameRGB[2]*.88,GameRGB[0]*.88
							'SetAlpha Pool[x,y]
							'SetColor GameRGB[0]*GrabColor,GameRGB[1]*GrabColor,GameRGB[2]*GrabColor
							If WideScreen
								DrawRect x*8-8,y*8-8,Size-WideOffset,Size
							Else
								DrawRect x*8-8,y*8-8,Size-WideOffset,Size
							End If
							If Pool[x,y]>.3 SetColor GameRGB[1]*.3,GameRGB[2]*.3,GameRGB[0]*.3
						End If
					Next
				Next
			End If
		Else
			If GlLines
			SetScale 1,1
			glDisable GL_TEXTURE_2D ; glBegin GL_QUADS
			'SetColor GameRGB[0],GameRGB[1],GameRGB[2]
			For Local x:Int = 0 To Width-1 
				For Local y:Int = 0 To Height-1
					GrabColor=Pool[x,y]
					If GrabColor>0.047
						SetColor BrightRGB[0]*GrabColor,BrightRGB[1]*GrabColor,BrightRGB[2]*GrabColor
						'SetAlpha Pool[x,y]
						If WideScreen
							FastRect x*8-8,y*8-8,Size-WideOffset,Size
						Else
							FastRect x*8-8,y*8-8,Size,Size
						End If
					End If
				Next
			Next
			glEnd ; glEnable GL_TEXTURE_2D	
			Else
				SetScale 1,1
				'SetColor GameRGB[0],GameRGB[1],GameRGB[2]
				For Local x:Int = 0 To Width-1 
					For Local y:Int = 0 To Height-1
						GrabColor=Pool[x,y]
						If GrabColor>0.047
							'SetAlpha Pool[x,y]
							SetColor BrightRGB[0]*GrabColor,BrightRGB[1]*GrabColor,BrightRGB[2]*GrabColor
							If WideScreen
								DrawRect x*8-8,y*8-8,Size-WideOffset,Size
							Else
								DrawRect x*8-8,y*8-8,Size,Size
							End If
						End If
					Next
				Next
			End If
		End If
		ClearBit=True
		DidUpdate=False
		SetColor 255,255,255
		'DisplayMe= MilliSecs()-updatetime
	End Method

End Type


'--------------------------------------------------------------------------------------------------
'Timercheck makes sure that no naughty speedhacks or other things are modifying the game flow 
'--------------------------------------------------------------------------------------------------
Type TSpeedCheck
	Global StopBit:Byte
	Global GetTick:Byte
	Global DontMeasureNext:Byte
	
	Global NowTime:Int
	Global LastTime:Int
	Global LastTick:Int
	
	Global TimeOffset:Int
	
	Global MeasurePoints:Int
	Global OffsetAverage:Int
	Global Hi_Infractions:Int
	Global Low_Infractions:Int

	Function Reset()
		
		'Reset The time verfication
		'To make sure the measurement is always fair
		NowTime=0
		LastTime=0
		LastTick=0
		TimeOffset=0
		OffsetAverage=0
		MeasurePoints=0
		Low_Infractions=-1
		Hi_Infractions=0
		StopBit=False
		GetTick=True
		DontMeasureNext=False
		
	End Function
	
	Function Stop()
		'Stop the time Verification
		If StopBit Return
		If MeasurePoints>=1 Then
			OffsetAverage=OffsetAverage/MeasurePoints
		End If
		
		'Print "Infractions: "+Hi_Infractions+Low_Infractions
		'Print "Offset Average: "+OffsetAverage
		'Print "Measure Points: "+MeasurePoints
		StopBit=True
	End Function
	
	Method Update()
		Local TimeString:String
		
		'Dont measure when dead
		If StopBit Return
		'If we paused the game, don't get the next measure point as it would distort the truth
		If GameState=Pause Then DontMeasureNext=True
		'Dont Measure in the Menus
		If GameState<>Playing Return
		
		'Get the current system time (Seconds)
		TimeString=Right(CurrentTime(),2)
		NowTime=Int(TimeString)
		
		'If one second has passed
		If NowTime<>LastTime Then
			If ScoreMultiplier<>Float(SeedJumble(Trk_Mul,False,True))
				Trk_RedFlag=True
				'Print "infraction!"
			End If
			
			LastTime=NowTime
			If GetTick
				'Grab the timer to compare against the seconds
				LastTick=MilliSecs()
				GetTick=False
				'Print "Get Sample."
			Else
				'Get and Compare the time
				TimeOffset=MilliSecs()-LastTick
				'Add to the Average
				If DontMeasureNext=False
					'Increase Data Points
					MeasurePoints:+1
					'Add to Average
					OffsetAverage:+TimeOffset
					'Compare
					'If the time is different, log it.
					If TimeOffset<895 Then
						Low_Infractions:+1
					End If
					If TimeOffset>1450 Then
						Hi_Infractions:+1
					End If
				Else
					'Okay we run the first time after pause, measure the next data point
					DontMeasureNext=False
				End If
				'Reset Byte to get next data point
				GetTick=True
			End If
		End If
		
	End Method

End Type
'--------------------------------------------------------------------------------------------------
'Extra HUD handles displaying of extras onto the HUD and its animation/fading 
'--------------------------------------------------------------------------------------------------
Type TBombHud Extends TObject
	
	Global List:TList
	Global BombIcon:TImage
	Global Amount:Int
	
	Field ID:Int
	Field Scale:Float
	Field Alpha:Float
	Field Spawn:Byte
	Field Disappear:Byte
	
	Function Init()
		
		If Not List Then List=CreateList()
		
		If Not BombIcon
			BombIcon = LoadImage(GetBundleResource("graphics/bombicon.png"),MASKEDIMAGE)
			MidHandleImage BombIcon
			PrepareFrame(BombIcon)
		End If
		
	End Function
	
	Function ReCache()
		PrepareFrame(BombIcon)
	End Function
	
	Function AspectChange()
		Amount=0
		DestroyAll()
		UpdateAll()
	End Function
	
	Function UpdateAll()
		
		If Player.HasBomb-Player.MaskBomb > Amount And Player.HasBomb-Player.MaskBomb<=3
			'Spawn		
			Local BombHUD:TBombHUD = New TBombHUD
			List.Addlast BombHud
			Amount:+1
			BombHUD.X=ScreenWidth+3-40*Amount
			BombHUD.Y=ScreenHeight-34
			BombHUD.Spawn=True
			BombHUD.Scale=0
			BombHUD.Alpha=0
			BombHUD.ID=Amount
			
		ElseIf Player.Hasbomb-Player.MaskBomb < Amount
			
			For Local BombHUD:TBombHUD = EachIn List
				If BombHUD.ID=Amount
					BombHUD.Disappear=True
					Exit
				End If
			Next
			Amount:-1
			
		End If
		
		For Local BombHUD:TBombHUD = EachIn List
			BombHUD.Update()
		Next
	
	End Function
	
	Method Update()
		
		If Spawn And Scale<1.3
			Scale:+0.06*Delta
			Alpha:+0.035*Delta
		ElseIf Spawn=True And Scale>=1.3
			Spawn=False
			Alpha=.97
		End If
		
		If Disappear And Scale<3.6
			Scale:+0.08*Delta
			Alpha:-0.05*Delta
		ElseIf Disappear=True And Scale>=3.6
			Disappear=False
			Destroy()
		End If
		
	End Method
	
	Method Draw()
		
		If Not Player.Alive And MilliSecs()-DeathSecs>=275
			'Don't do anything let global Alpha value take over
		Else
			SetAlpha Alpha-(HudBombVisibility)'*.915)
		End If

		SetScale Scale,Scale
		DrawImage BombIcon,X,Y
		
	End Method
	
	Method Destroy()
		List.Remove( Self )
	End Method
		
	Function DestroyAll()
		For Local BombHUD:TBombHUD = EachIn List
			BombHUD.Destroy()
		Next
	End Function
	
	Function DrawAll()
		For Local BombHUD:TBombHUD = EachIn List
			BombHUD.Draw()
		Next
	End Function
	

End Type
'--------------------------------------------------------------------------------------------------
'The MusicPlayer Type handles the music playback and keeps track of the game's requests 
'--------------------------------------------------------------------------------------------------
Type TMusicPlayer Extends TObject
	
	Const TrackList:Int=5
	
	Global XMas:Byte
	Global List:TList
	Global PlayList:Int[TrackList+1]
	Global PlayListPosition:Int
	Global ActiveChannel:Int
	Global RequestedSong:Int
	Global CurrentSong:Int
	Global FadeChannel:Float
	Global FadeVolume:Float
	Global TrackPause:Int=MilliSecs()+1250
	
	Global PlayedHiScoreBopOnce:Byte
	
	Function Init()
		
		If Not List List = CreateList()
		
		Local MusicPlayer:TMusicPlayer = New TMusicPlayer
		List.Addlast MusicPlayer
		
	End Function
	
	Function Request(Song:String)
		
		If Upper(Song)="GAMEOVER" Then RequestedSong=1
		
		If Upper(Song)="HISCORE-BOP" Then RequestedSong=2
		
	End Function
	
	Function Resume()
		
		RequestedSong=0
		
	End Function
	
	Method Update()
		Local SongNum:Int
	
		If SoundMute Or MusicVol<=0
			SetChannelVolume MusicChannel_One, 0
			SetChannelVolume MusicChannel_Two, 0
			Return
		End If
		
		If RequestedSong<>0
			
			If ChannelPlaying(MusicChannel_Two)=False
				
				Select RequestedSong
					
					Case 1
						MusicChannel_Two = PlayMusic(GameOverSong)
						CurrentSong=1
					Case 2
						If SeedJumble(Seed)<>"PM>@BFKS>ABOP" And PlayedHiScoreBopOnce=False
							MusicChannel_Two = PlayMusic(Space_Invaders)
							PlayedHiScoreBopOnce=True
							CurrentSong=2
						Else
							RequestedSong=0
						End If
				
				End Select
			ElseIf ChannelPlaying(MusicChannel_Two) And RequestedSong=1 And CurrentSong=2
				
				If FadeVolume<MusicVol
					FadeVolume:+0.015*Delta
					SetChannelVolume MusicChannel_One,(MusicVol-(FadeVolume))/1.35
					SetChannelVolume MusicChannel_Two,(MusicVol-(FadeVolume))/1.35
				End If
				
				If FadeVolume=>MusicVol
					FadeVolume=MusicVol
					StopChannel(MusicChannel_Two)
					SetChannelVolume MusicChannel_Two,(FadeVolume)/1.35
					SetChannelVolume MusicChannel_One,0
				End If
			
			End If
			
			If FadeVolume<MusicVol
				FadeVolume:+0.015*Delta
				SetChannelVolume MusicChannel_One,(MusicVol-(FadeVolume))/1.35
				SetChannelVolume MusicChannel_Two,(FadeVolume)/1.35
			End If
			
			If FadeVolume=>MusicVol
				FadeVolume=MusicVol
				SetChannelVolume MusicChannel_Two,(FadeVolume)/1.35
				SetChannelVolume MusicChannel_One,0
			End If
		
		Else
			
			If FadeVolume<>0 And FadeVolume>MusicVol
				FadeVolume=MusicVol
				SetChannelVolume MusicChannel_Two,(FadeVolume)/1.35
			ElseIf FadeVolume<=0
				StopChannel MusicChannel_Two
				SetChannelVolume MusicChannel_Two,0
				FadeVolume=0
			End If
			
			If ChannelPlaying(MusicChannel_Two) And FadeVolume>0
				FadeVolume:-0.1*Delta
				SetChannelVolume MusicChannel_One,(MusicVol-FadeVolume)/1.35
				SetChannelVolume MusicChannel_Two,(FadeVolume)/1.35
				
			Else
				SetChannelVolume MusicChannel_One, MusicVol/1.35
				SetChannelVolume MusicChannel_Two, 0
			End If
			
			If SeedJumble(Seed)="PM>@BFKS>ABOP" And XMas=False
				StopChannel(MusicChannel_One)
			End If
			
			If ChannelPlaying(MusicChannel_One)=False And MusicVol>0 Then
				
				StopChannel(MusicChannel_One)
				If FadeVolume<=0 SetChannelVolume MusicChannel_One,0
				
				If TrackPause=-1
					TrackPause=MilliSecs()+1150
					'Print "Cue"
				End If
				
				If TrackPause-MilliSecs()>0
					'Print "Wait"
					Return
				End If
				
				If TrackPause-MilliSecs()<=0 And TrackPause<>-1 TrackPause=-1
				
				If SeedJumble(Seed)="PM>@BFKS>ABOP" And XMas=False
					StopChannel(MusicChannel_One)
					MusicChannel_One = PlayMusic(Space_Invaders)
					Xmas=True
					If FadeVolume<=0 SetChannelVolume MusicChannel_One,MusicVol/1.35
					ResumeChannel(MusicChannel_One)
					Return
				End If
				
				If PlayListPosition=Tracklist Or PlayList[1]=0
					Local LastSong=PlayList[TrackList]		
					Local TempPlayList:Int[TrackList+1]
					Local TracksPulled:Int
					Local SelectedTrack:Int
					Local cnt
					
					For Local i=1 To TrackList
						TempPlayList[i]=i
					Next
					
					Repeat
						cnt:+1
						SelectedTrack=Rand(1,TrackList)
						If TempPlayList[SelectedTrack]<>0
							TracksPulled:+1
							PlayList[TracksPulled]=TempPlayList[SelectedTrack]
							TempPlayList[SelectedTrack]=0
						End If
						
					Until TracksPulled=TrackList
					
					If LastSong<>0
						For Local i=1 To TrackList-2
							If PlayList[i]=LastSong
								Playlist[i]=PlayList[TrackList]
								PlayList[TrackList]=LastSong
							End If
						Next
					End If
					
					'Print "loops it took:"+cnt
					
					PlayListPosition=1
				Else
					PlayListPosition:+1
				End If
				
				'Print "Playing Track: "+PlayListPosition+" Name: "+PlayList[PlayListPosition]
							
				Select PlayList[PlayListPosition]
					
					Case 1
						MusicChannel_One = PlayMusic(Song1)
					Case 2
						MusicChannel_One = PlayMusic(Song2)
					Case 3
						MusicChannel_One = PlayMusic(Song3)
					Case 4
						MusicChannel_One = PlayMusic(Song4)
					Case 5
						MusicChannel_One = PlayMusic(Song5)
						
				End Select
				
				If FadeVolume<=0 SetChannelVolume MusicChannel_One,MusicVol/1.35
				ResumeChannel(MusicChannel_One)
			
			End If
		End If

	End Method
	
	Function UpdateAll()
		
		For Local MusicPlayer:TMusicPlayer = EachIn List
			MusicPlayer.Update()
		Next
		
	End Function

	
	Method Destroy()
		
		StopChannel(MusicChannel_One)
		StopChannel(MusicChannel_Two)
		List.Remove( Self )
		List=Null
	
	End Method

End Type
'--------------------------------------------------------------------------------------------------
'The SoundLoop class handles looping sounds and keep track of their channels & volume settings
'--------------------------------------------------------------------------------------------------
Rem
Type TSoundLoop Extends TObject
	
	Global List:TList
	
	Field Volume:Float
	Field MaxVolume:Float
	Field Sample:TSound
	Field LoopChannel:TChannel
	Field Duration:Int
	Field NumLoops:Int
	Field PlayMode:Int
	
	Field ID:Int
	
	Const FADE_IN:Int=1
	Const FADE_OUT:Int=2
	
	Function Init()
	
		If Not List List = CreateList()
	
	End Function
	
	Function Play(Sample:TSound,InitialVolume:Float=0,MaxVolume:Float=1,ID:Int)
		
		'If we already have a loop of this ID, chances are we don't want another one!
		For Local SoundLoop:TSoundLoop = EachIn List
			If SoundLoop.ID=ID Return
		Next
		
		Local SoundLoop:TSoundLoop = New TSoundLoop
		List.Addlast SoundLoop
		
		
		SoundLoop.LoopChannel=AllocChannel()
		CueSound Sample,SoundLoop.LoopChannel
		SetChannelVolume (SoundLoop.LoopChannel,InitialVolume)
		
		SoundLoop.Sample=Sample
		SoundLoop.Volume=InitialVolume 
		SoundLoop.MaxVolume=MaxVolume
		SoundLoop.PlayMode=FADE_IN
		SoundLoop.ID=ID
		ResumeChannel SoundLoop.LoopChannel
		
	End Function
	
	Function FadeOut(ID:Int)
	
		For Local SoundLoop:TSoundLoop = EachIn List
			If SoundLoop.ID=ID SoundLoop.PlayMode=FADE_OUT
		Next
	
	End Function

	Function Stop(ID:Int)
	
		For Local SoundLoop:TSoundLoop = EachIn List
			If SoundLoop.ID=ID
				SoundLoop.PlayMode=FADE_OUT
				SoundLoop.Volume=0
			End If
		Next
	
	End Function
	
	Method Update()
		
		SetChannelVolume LoopChannel, Volume
		
		If Not ChannelPlaying(LoopChannel) And Volume>0
			PlaySound Sample,LoopChannel
		End If
		
		If PlayMode=FADE_IN And Volume<MaxVolume
			
			Volume:+0.005*Delta
			
		ElseIf PlayMode=FADE_OUT And Volume>0
		
			Volume:-0.003*Delta
		
		End If
		
		If Volume<=0 And PlayMode=FADE_OUT Destroy()
		
	End Method 
	
	
	Function UpdateAll()
		
		For Local SoundLoop:TSoundLoop = EachIn List
			SoundLoop.Update()
		Next
		
	End Function

	
	Method Destroy()
		
		StopChannel LoopChannel
		LoopChannel=Null
		Sample=Null
		List.Remove( Self )
	
	End Method
	
	Function DestroyAll()
		
		For Local SoundLoop:TSoundLoop = EachIn List
			SoundLoop.Destroy()
		Next
		
	End Function
	
End Type
End Rem
'-----------------------------------------------------------------------------
'Particle Manager, Manages glowy particles
'-----------------------------------------------------------------------------
Rem
Type ParticleManager 
	
	Field X:Float
	Field Y:Float
	Field Direction:Float
	Field XSpeed:Float
	Field YSpeed:Float
	Field R:Int,G:Int,B:Int
	Field Active:Float
	
	Global List:TList 
	Global Image:TImage
	
	Global AllocatedParticles:Int ' = 2048
	Const ParticleLife:Int = 145
	Global ParticleDecay:Float = .9925
	
	Const MAXPARTICLES:Int = 8704
	Const LengthMultiplier:Int=2
	
	Global SlotCount:Int '0 to numparticles-1
	Global ParticleArray:ParticleManager[]
	
	
	Global DeltaOne:Float
	Global DeltaTwo:Float
	Global DeltaDecay:Float
	
	Function AllocateParticles()
		
		AllocatedParticles=4096*ParticleMultiplier
		
		If AllocatedParticles>=MAXPARTICLES
			AllocatedParticles=MAXPARTICLES-1
		End If
		
	End Function
	
	Function Init()
		
		ParticleArray = New ParticleManager[MAXPARTICLES]
		
		If Not List List = CreateList()
		
		If Not Image Then
			Image= LoadImage(GetBundleResource("Graphics/particle.png"),FILTEREDIMAGE)
			MidHandleImage Image
			image.Frame(0)
		End If

		For Local i = 0 To MAXPARTICLES-1
			ParticleArray[i] = New ParticleManager
			ParticleArray[i].Y = 0
			ParticleArray[i].X = 0
			ParticleArray[i].R = 0
			ParticleArray[i].G = 0
			ParticleArray[i].B = 0
			ParticleArray[i].Active = 0
			ParticleArray[i].XSpeed = 0
			ParticleArray[i].YSpeed = 0
			ParticleManager.List.Addlast( ParticleArray[i] )				
		Next
		
		SlotCount = 0
		
	End Function	
	
	Function ReCache()
		image.Frame(0)
	End Function

	Function Create( x:Float, y:Float ,Amount:Int, R:Int,G:Int,B:Int, Rotation:Float = 0, Size:Float = 1)	

		Local Particle:ParticleManager
		Local Magnitude:Float
		Local CreateAmount:Int=Amount*ParticleMultiplier
		
		If CreateAmount<=1 Then CreateAmount=1
		
		For Local i=1 To CreateAmount
			
			Particle:ParticleManager = ParticleArray[SlotCount]
			Particle.X = X
			Particle.Y = Y
			Particle.R = R
			Particle.G = G
			Particle.B = B
			Particle.Active = Rand(ParticleLife-20,ParticleLife)
			
			If ParticleMultiplier>=150 Particle.Active:+35
			
			If Size>=3 Then Particle.Active:+10
			
			If Rotation=0
				Particle.Direction = Rand(0,359)
			Else
				Particle.Direction = Rnd(Rotation-20,Rotation+20)
			EndIf
			Magnitude = Rnd(7.5,14)
			Particle.XSpeed = Cos(Particle.Direction)*Magnitude*Size
			Particle.YSpeed = Sin(Particle.Direction)*Magnitude*Size

			Particle.X:+ Particle.XSpeed/12
			Particle.Y:+ Particle.YSpeed/12
			
			SlotCount:+1
			
			If SlotCount => AllocatedParticles-1 Then SlotCount = 0
		
		Next

	EndFunction
		
	Method Update()
		If Active > 0
			Local DeltaDecay:Float=(ParticleDecay^Delta)
			
			X:+ (XSpeed/7.15)*Delta
			Y:+ (YSpeed/7.15)*Delta

			XSpeed = XSpeed * DeltaDecay
			YSpeed = YSpeed * DeltaDecay
			'XSpeed = XSpeed * ParticleDecay
			'YSpeed = YSPeed * ParticleDecay
			Active:-1*Delta
			
			If Active < 50		
				If Active < 25
					R:*DeltaOne
					G:*DeltaOne
					B:*DeltaOne
				Else
					R:*DeltaTwo
					G:*DeltaTwo
					B:*DeltaTwo		
				EndIf				
			EndIf
		EndIf
	End Method
	
	Function DrawAllGlow()
		Local Particle:ParticleManager
				
		SetAlpha .6
		SetBlend LIGHTBLEND
		
		'Really really weird GL-Bug (FIX HACK)
		If GlowQuality<=256 And FullScreenGlow
			SetLineWidth 1.5
		ElseIf GlowQuality<=512
			SetLineWidth 2.5
		Else
			SetLineWidth 3
		End If
		If GlLines
			glDisable GL_TEXTURE_2D; glBegin GL_LINES
			If GlowQuality<=256 And FullScreenGlow
				glLineWidth 1.5
			ElseIf GlowQuality<=512
				glLineWidth 2.5
			Else
				glLineWidth 3
			End If
			For Local t = 0 To AllocatedParticles-1
				Particle:ParticleManager = ParticleArray[t]
				If Particle.Active > 0

					SetColor Particle.R,Particle.G,Particle.B
				
					glVertex2f Particle.X,Particle.Y
					glVertex2f Particle.X+(Particle.XSpeed*LengthMultiplier),Particle.Y+(Particle.YSpeed*LengthMultiplier)

				EndIf
			Next
			glEnd; glEnable GL_TEXTURE_2D
		Else
			SetTransform 0,2,2
			If GlowQuality<=256 And FullScreenGlow
				SetLineWidth 1.5
			ElseIf GlowQuality<=512
				SetLineWidth 2.5
			Else
				SetLineWidth 3
			End If
			For Local t = 0 To AllocatedParticles-1
				Particle:ParticleManager = ParticleArray[t]
				If Particle.Active > 0

					SetColor Particle.R,Particle.G,Particle.B
				
					DrawLine Particle.X,Particle.Y,Particle.X+Particle.XSpeed,Particle.Y+Particle.YSpeed
					
				EndIf
			Next
		End If
		
		SetAlpha 1
		SetTransform 0,1,1
		SetColor 255,255,255						
		SetBlend ALPHABLEND
		
	End Function
	
		
	Function DrawAll()
		Local Particle:ParticleManager
		Local Angle:Float, dx:Float, dy:Float
		Local rr:Int ,gg:Int ,bb:Int
		
		SetBlend LIGHTBLEND								
				
		SetAlpha .8
		SetLineWidth 2
		
		If GlLines
			glDisable GL_TEXTURE_2D; glBegin GL_LINES
			glLineWidth 2.0
			
			For Local t = 0 To AllocatedParticles-1
				Particle:ParticleManager = ParticleArray[t]
				If Particle.Active > 0
					rr = Particle.R*1.25
					gg = Particle.G*1.25
					bb = Particle.B*1.25
					SetColor rr,gg,bb
				
					glVertex2f Particle.X,Particle.Y
					glVertex2f Particle.X+(Particle.XSpeed*LengthMultiplier),Particle.Y+(Particle.YSpeed*LengthMultiplier)

				EndIf
			Next
			glEnd; glEnable GL_TEXTURE_2D
		Else
			SetTransform 0,2,2
			SetLineWidth 2.0
			For Local t = 0 To AllocatedParticles-1
				Particle:ParticleManager = ParticleArray[t]
				If Particle.Active > 0
					rr = Particle.R*1.25
					gg = Particle.G*1.25
					bb = Particle.B*1.25
					SetColor rr,gg,bb
				
					DrawLine Particle.X,Particle.Y,Particle.X+Particle.XSpeed,Particle.Y+Particle.YSpeed
					
				EndIf
			Next
		End If
		
		For Local t = 0 To AllocatedParticles-1
			Particle:ParticleManager = ParticleArray[t]
			If Particle.Active > 0
				
				rr = Particle.R*1.25
				gg = Particle.G*1.25
				bb = Particle.B*1.25
				
				SetColor rr,gg,bb
				
				SetAlpha .4
				'SetTransform Rotation Direction, This stretches the sprite along it's speed * Factor, Y Stretch along the width
				SetTransform Particle.Direction,Sqr(Particle.XSpeed*Particle.XSpeed+Particle.YSpeed*Particle.YSpeed)*.4,1.2
				DrawImage Image,Particle.X+Particle.XSpeed*1.0,Particle.Y+Particle.YSpeed*1.0
				
				'DrawImage Image,Particle.X+Particle.XSpeed*2.0,Particle.Y+Particle.YSpeed*2.0
				
			EndIf
		Next				
				
		SetAlpha 1
		SetBlend ALPHABLEND
		SetTransform 0,1,1						
		SetColor 255,255,255
					
	End Function
	
	
	Function UpdateAll()	
		
		DeltaDecay=(ParticleDecay^Delta)
		DeltaTwo=(.98^Delta)
		DeltaOne=(.965^Delta)
		
		Local Particle:ParticleManager
			For Local t = 0 To AllocatedParticles-1
				Particle:ParticleManager = ParticleArray[t]
				If Particle.Active > 0
					Particle.Update()
				EndIf
			Next	
	End Function
	
	Function ResetAll()
		Local Particle:ParticleManager
		
		For Local t = 0 To MAXPARTICLES-1
			Particle:ParticleManager = ParticleArray[t]
			Particle.X = 0
			Particle.Y = 0
			Particle.R = 0
			Particle.G = 0
			Particle.B = 0
			Particle.Active = 0
			Particle.XSpeed = 0
			Particle.YSpeed = 0
		Next
		SlotCount = 0
	End Function

End Type
Type ParticleManager
	
	Field X:Float,Y:Float
	Field XSpeed:Float,YSpeed:Float
	Field Direction:Float
	
	Field R:Int,G:Int,B:Int
	Field Age:Float
	
	Global List:TList 
	Global Image:TImage
	
	Const ParticleLife:Int = 145
	
	Global DeltaOne:Float
	Global DeltaTwo:Float
	Global DeltaDecay:Float
	Const ParticleDecay:Float = .9925

	Const LengthMultiplier:Byte=2
	
	Global GrabTime:Int
	Global CycleTime:Float
	Global DataPoints:Int
	
	
	Function Init()
		
		If Not List List = CreateList()
		
		If Not Image Then
			Image= LoadImage(GetBundleResource("Graphics/particle.png"),FILTEREDIMAGE)
			MidHandleImage Image
			image.Frame(0)
		End If
		
	End Function	
	
	Function ReCache()
		image.Frame(0)
	End Function

	Function Create( x:Float, y:Float ,Amount:Int, R:Int,G:Int,B:Int, Rotation:Float = 0, Size:Float = 1)	
		
		Local Point1:Int=MilliSecs()
		
		
		Local Magnitude:Float

		For Local i=1 To Amount*ParticleMultiplier
			
			Local Particle:ParticleManager = New ParticleManager
			List.AddLast Particle
			
			Particle.X = X
			Particle.Y = Y
			Particle.R = R
			Particle.G = G
			Particle.B = B
			Particle.Age = Rand(ParticleLife-20,ParticleLife)
			
			If ParticleMultiplier>=150 Particle.Age:+35
			
			If Size>=3 Then Particle.Age:+10
			
			If Rotation=0
				Particle.Direction = Rand(0,359)
			Else
				Particle.Direction = Rnd(Rotation-20,Rotation+20)
			EndIf
			Magnitude = Rnd(7.5,14)
			Particle.XSpeed = Cos(Particle.Direction)*Magnitude*Size
			Particle.YSpeed = Sin(Particle.Direction)*Magnitude*Size

			Particle.X:+ Particle.XSpeed/12
			Particle.Y:+ Particle.YSpeed/12
			
			
		Next
		
		GrabTime:+MilliSecs()-Point1

		
	EndFunction
		
	Method Update()
		'Print "jup"
		'Local DeltaDecay:Float=ParticleDecay^Delta
		X:+ (XSpeed/7.15)*Delta
		Y:+ (YSpeed/7.15)*Delta

		XSpeed = XSpeed * DeltaDecay
		YSpeed = YSpeed * DeltaDecay
		'XSpeed = XSpeed * ParticleDecay
		'YSpeed = YSPeed * ParticleDecay
		Age:-1*Delta
		
		If Age < 50		
			If Age < 25
				If Age<=0 Then
					List.Remove( Self )
					'ReplaceSelf()
					'Return
				End If
				'Local DeltaOne:Float=(.96^Delta)
				R:*DeltaOne
				G:*DeltaOne
				B:*DeltaOne
			Else
				
				'Local DeltaTwo:Float=(.985^Delta)
				R:*DeltaTwo
				G:*DeltaTwo
				B:*DeltaTwo		
			EndIf				
		EndIf

	End Method
	
		Function DrawAllGlow()
		If List.Count()=0
			SetTransform 0,1,1
			Return
		End If
		Local Particle:ParticleManager
				
		SetAlpha .6
		SetBlend LIGHTBLEND
		
		'Really really weird GL-Bug (FIX HACK)
		If GlowQuality<=256 And FullScreenGlow
			SetLineWidth 1.5
		ElseIf GlowQuality<=512
			SetLineWidth 2.5
		Else
			SetLineWidth 3
		End If
		If GlLines
			glDisable GL_TEXTURE_2D; glBegin GL_LINES
			If GlowQuality<=256 And FullScreenGlow
				glLineWidth 1.5
			ElseIf GlowQuality<=512
				glLineWidth 2.5
			Else
				glLineWidth 3
			End If
			For Particle = EachIn List 
	

				SetColor Particle.R,Particle.G,Particle.B
				
				glVertex2f Particle.X,Particle.Y
				glVertex2f Particle.X+(Particle.XSpeed*LengthMultiplier),Particle.Y+(Particle.YSpeed*LengthMultiplier)


			Next
			glEnd; glEnable GL_TEXTURE_2D
		Else
			SetTransform 0,2,2
			If GlowQuality<=256 And FullScreenGlow
				SetLineWidth 1.5
			ElseIf GlowQuality<=512
				SetLineWidth 2.5
			Else
				SetLineWidth 3
			End If
			For Particle = EachIn List 

				SetColor Particle.R,Particle.G,Particle.B
				
				DrawLine Particle.X,Particle.Y,Particle.X+Particle.XSpeed,Particle.Y+Particle.YSpeed
					

			Next
		End If
		
		SetAlpha 1
		SetTransform 0,1,1
		SetColor 255,255,255						
		SetBlend ALPHABLEND
		
	End Function
	
	Function DrawAll()
		Local Point2:Int=MilliSecs()
		If List.Count()=0
			SetTransform 0,1,1
			Return
		End If
		Local Angle:Float, dx:Float, dy:Float
		Local rr:Int ,gg:Int ,bb:Int
		
		SetBlend LIGHTBLEND								
				
		SetAlpha .8
		SetLineWidth 2
		Local Particle:ParticleManager
		
		If GlLines
			glDisable GL_TEXTURE_2D; glBegin GL_LINES
			glLineWidth 2.0
			
			
			For Particle = EachIn List 

				rr = Particle.R*1.25
				gg = Particle.G*1.25
				bb = Particle.B*1.25
				SetColor rr,gg,bb
				
				glVertex2f Particle.X,Particle.Y
				glVertex2f Particle.X+(Particle.XSpeed*LengthMultiplier),Particle.Y+(Particle.YSpeed*LengthMultiplier)


			Next
			glEnd; glEnable GL_TEXTURE_2D
		Else
			SetTransform 0,2,2
			SetLineWidth 2.0

			For Particle = EachIn List 

				rr = Particle.R*1.25
				gg = Particle.G*1.25
				bb = Particle.B*1.25
				SetColor rr,gg,bb
				
				DrawLine Particle.X,Particle.Y,Particle.X+Particle.XSpeed,Particle.Y+Particle.YSpeed
					

			Next
		End If
		
			For Particle = EachIn List 
							
			rr = Particle.R*1.25
			gg = Particle.G*1.25
			bb = Particle.B*1.25
				
			SetColor rr,gg,bb
				
			SetAlpha .4
			'SetTransform Rotation Direction, This stretches the sprite along it's speed * Factor, Y Stretch along the width
			SetTransform Particle.Direction,Sqr(Particle.XSpeed*Particle.XSpeed+Particle.YSpeed*Particle.YSpeed)*.4,1.2
			DrawImage Image,Particle.X+Particle.XSpeed*1.0,Particle.Y+Particle.YSpeed*1.0
				
			'DrawImage Image,Particle.X+Particle.XSpeed*2.0,Particle.Y+Particle.YSpeed*2.0

		Next				
				
		SetAlpha 1
		SetBlend ALPHABLEND
		SetTransform 0,1,1						
		SetColor 255,255,255
		
		GrabTime:+MilliSecs()-Point2	
		CycleTime:+GrabTime
		GrabTime=0
		DataPoints:+1
				
	End Function
	
	Method Destroy()
		List.Remove (Self)
	End Method
	
	Function UpdateAll()
		Local Point3:Int=MilliSecs()
		'Local counter:Int=0
		DeltaDecay=(ParticleDecay^Delta)
		DeltaTwo=(.98^Delta)
		DeltaOne=(.965^Delta)
			Local Particle:Particlemanager
			For Particle = EachIn List 
				Particle.Update()
			Next
			'CurrentParticles=Counter	
		GrabTime:+MilliSecs()-Point3	
	End Function
	

End Type
End Rem
Type ParticleManager
	
	Field X:Float,Y:Float
	Field XSpeed:Float,YSpeed:Float
	Field Direction:Float
	
	Field R:Int,G:Int,B:Int
	Field Age:Float
	
	Global List:TList 
	Global Image:TImage
	
	Const ParticleLife:Int = 145
	
	Global DeltaOne:Float
	Global DeltaTwo:Float
	Global DeltaDecay:Float
	Const ParticleDecay:Float = .9925

	Const LengthMultiplier:Byte=2
	
	Function Init()
		
		If Not List List = CreateList()
		
		If Not Image Then
			Image= LoadImage(GetBundleResource("Graphics/particle.png"),FILTEREDIMAGE)
			MidHandleImage Image
			image.Frame(0)
		End If
		
	End Function	
	
	Function ReCache()
		image.Frame(0)
	End Function

	Function Create( x:Float, y:Float ,Amount:Int, R:Int,G:Int,B:Int, Rotation:Float = 0, Size:Float = 1)	
		
		Local Magnitude:Float

		For Local i=1 To Amount*ParticleMultiplier
			
			Local Particle:ParticleManager = New ParticleManager
			List.AddLast Particle
			
			Particle.X = X
			Particle.Y = Y
			Particle.R = R
			Particle.G = G
			Particle.B = B
			Particle.Age = Rand(ParticleLife-20,ParticleLife)
			
			If ParticleMultiplier>=150 Particle.Age:+35
			
			If Size>=3 Then Particle.Age:+10
			
			If Rotation=0
				Particle.Direction = Rand(0,359)
			Else
				Particle.Direction = Rnd(Rotation-20,Rotation+20)
			EndIf
			Magnitude = Rnd(7.5,14)
			Particle.XSpeed = Cos(Particle.Direction)*Magnitude*Size
			Particle.YSpeed = Sin(Particle.Direction)*Magnitude*Size

			Particle.X:+ Particle.XSpeed/12
			Particle.Y:+ Particle.YSpeed/12
			
			
		Next
		
	EndFunction
		
	Method Update()
		'Print "jup"
		'Local DeltaDecay:Float=ParticleDecay^Delta
		X:+ (XSpeed/7.15)*Delta
		Y:+ (YSpeed/7.15)*Delta

		XSpeed = XSpeed * DeltaDecay
		YSpeed = YSpeed * DeltaDecay
		'XSpeed = XSpeed * ParticleDecay
		'YSpeed = YSPeed * ParticleDecay
		Age:-1*Delta
		
		If Age < 50		
			If Age < 25
				If Age<=0 Then
					List.Remove( Self )
					'ReplaceSelf()
					'Return
				End If
				'Local DeltaOne:Float=(.96^Delta)
				R:*DeltaOne
				G:*DeltaOne
				B:*DeltaOne
			Else
				
				'Local DeltaTwo:Float=(.985^Delta)
				R:*DeltaTwo
				G:*DeltaTwo
				B:*DeltaTwo		
			EndIf				
		EndIf

	End Method
	
	Function DrawAllGlow()
		If List.Count()=0
			SetTransform 0,1,1
			Return
		End If
		'Local Particle:ParticleManager
				
		SetAlpha .6
		SetBlend LIGHTBLEND
		
		'Really really weird GL-Bug (FIX HACK)
		If GlowQuality<=256 And FullScreenGlow
			SetLineWidth 1.5
		ElseIf GlowQuality<=512
			SetLineWidth 2.5
		Else
			SetLineWidth 3
		End If
		If GlLines
			glDisable GL_TEXTURE_2D; glBegin GL_LINES
			If GlowQuality<=256 And FullScreenGlow
				glLineWidth 1.5
			ElseIf GlowQuality<=512
				glLineWidth 2.5
			Else
				glLineWidth 3
			End If
			Local link:TLink= List.FirstLink()
			
			While link
				Local Particle:ParticleManager=ParticleManager(link._value)
				SetColor Particle.R,Particle.G,Particle.B
				glVertex2f Particle.X,Particle.Y
				glVertex2f Particle.X+(Particle.XSpeed*LengthMultiplier),Particle.Y+(Particle.YSpeed*LengthMultiplier)
				If link._succ._value<>link._succ 
					link=link._succ
				Else
			  		link=Null
			  End If		
			Wend	
			glEnd; glEnable GL_TEXTURE_2D
		Else
			SetTransform 0,2,2
			If GlowQuality<=256 And FullScreenGlow
				SetLineWidth 1.5
			ElseIf GlowQuality<=512
				SetLineWidth 2.5
			Else
				SetLineWidth 3
			End If
			Local link:TLink= List.FirstLink()
			
			While link
				Local Particle:ParticleManager=ParticleManager(link._value)
				SetColor Particle.R,Particle.G,Particle.B
					
				DrawLine Particle.X,Particle.Y,Particle.X+Particle.XSpeed,Particle.Y+Particle.YSpeed
				If link._succ._value<>link._succ 
					link=link._succ
				Else
			  		link=Null
			  End If		
			Wend		
		End If
		
		SetAlpha 1
		SetTransform 0,1,1
		SetColor 255,255,255						
		SetBlend ALPHABLEND
		
	End Function
	
	Function DrawAll()
		If List.Count()=0
			SetTransform 0,1,1
			Return
		End If
		Local Angle:Float, dx:Float, dy:Float
		Local rr:Int ,gg:Int ,bb:Int
		
		SetBlend LIGHTBLEND								
				
		SetAlpha .8
		SetLineWidth 2
		'Local Particle:ParticleManager
		
		If GlLines
			glDisable GL_TEXTURE_2D; glBegin GL_LINES
			glLineWidth 2.0
			
			Local link:TLink= List.FirstLink()
			
			While link
				Local Particle:ParticleManager=ParticleManager(link._value)
				rr = Particle.R*1.25
				gg = Particle.G*1.25
				bb = Particle.B*1.25
				SetColor rr,gg,bb
				
				glVertex2f Particle.X,Particle.Y
				glVertex2f Particle.X+(Particle.XSpeed*LengthMultiplier),Particle.Y+(Particle.YSpeed*LengthMultiplier)
				If link._succ._value<>link._succ 
					link=link._succ
				Else
			  		link=Null
			  End If		
			Wend		
			glEnd; glEnable GL_TEXTURE_2D
		Else
			SetTransform 0,2,2
			SetLineWidth 2.0

			Local link:TLink= List.FirstLink()
			
			While link
				Local Particle:ParticleManager=ParticleManager(link._value)
				rr = Particle.R*1.25
				gg = Particle.G*1.25
				bb = Particle.B*1.25
				SetColor rr,gg,bb
				
				DrawLine Particle.X,Particle.Y,Particle.X+Particle.XSpeed,Particle.Y+Particle.YSpeed
				If link._succ._value<>link._succ 
					link=link._succ
				Else
			  		link=Null
			  End If		
			Wend			

		End If
		
			Local link:TLink= List.FirstLink()
			While link
				Local Particle:ParticleManager=ParticleManager(link._value)
				  							
				rr = Particle.R*1.25
				gg = Particle.G*1.25
				bb = Particle.B*1.25
					
				SetColor rr,gg,bb
					
				SetAlpha .4
				'SetTransform Rotation Direction, This stretches the sprite along it's speed * Factor, Y Stretch along the width
				SetTransform Particle.Direction,Sqr(Particle.XSpeed*Particle.XSpeed+Particle.YSpeed*Particle.YSpeed)*.4,1.2
				DrawImage Image,Particle.X+Particle.XSpeed*1.0,Particle.Y+Particle.YSpeed*1.0
					
				'DrawImage Image,Particle.X+Particle.XSpeed*2.0,Particle.Y+Particle.YSpeed*2.0
				
				If link._succ._value<>link._succ 
					link=link._succ
				Else
					link=Null
				End If		
			Wend		
				
		SetAlpha 1
		SetBlend ALPHABLEND
		SetTransform 0,1,1						
		SetColor 255,255,255
		
				
	End Function
	
	
	Function UpdateAll()
		'Local Point3:Int=MilliSecs()
		'Local counter:Int=0
		DeltaDecay=(ParticleDecay^Delta)
		DeltaTwo=(.98^Delta)
		DeltaOne=(.965^Delta)
			'Local Particle:Particlemanager
			'For Particle = EachIn List 
				'Particle.Update()
			'Next
			'CurrentParticles=Counter	
		Local link:TLink= List.FirstLink()
		While link
			Local Particle:ParticleManager=ParticleManager(link._value)
		 	Particle.Update()
			If link._succ._value<>link._succ 
			link=link._succ
			
			Else
				link=Null
			End If		
		Wend
		'GrabTime:+MilliSecs()-Point3	
	End Function
	
	Method Destroy()
		List.Remove(Self)
	End Method

End Type

'-----------------------------------------------------------------------------
'A simple Parallax Starfield, another of the possible backgrounds for the game
'-----------------------------------------------------------------------------
Type TStarField Extends TObject
	Global Stars:TList = CreateList()
	Global Image:TImage
	Global BlurryImage:TImage
	
	Field a:Float
	
	Method New()
		ListAddLast Stars,Self
	End Method
	
	Method DrawStar(gx#,gy#,Scale# = 1.0)
		Local tx = x+(gx*a)
		Local ty = y+(gy*a)
		
		If tx < -190 Then x = ScreenWidth - (gx*a)+190
		If tx > ScreenWidth+190 Then x = -(gx*a)-190
		If ty < -190 Then y = ScreenHeight - (gy*a)+190
		If ty > ScreenHeight+190 Then y = -(gy*a)-190
		
		SetAlpha a-.15
		SetScale a*6,a*6

		If Scale*a < 1.0 Then
			'Plot x+(gx*a),y+(gy*a)
			If GlowQuality>256
				DrawImage Image,x+(gx*a),y+(gy*a)
			End If
		Else
			If GlowQuality>256
				DrawImage Image,x+(gx*a),y+(gy*a)
			Else
				DrawImage BlurryImage,x+(gx*a),y+(gy*a)
			End If
			'IngameFont.Draw ".",x+(gx*a),y+(gy*a),True
			'DrawOval x+(gx*a),y+(gy*a),gscale*a,gscale*a
		End If
		SetAlpha 1
	End Method
	
	Method DrawStarHalf(gx#,gy#,Scale# = 1.0)
		
		Local tx = x+(gx*a)
		Local ty = y+(gy*a)
		
		If tx < -190 Then x = ScreenWidth - (gx*a)+190
		If tx > ScreenWidth+190 Then x = -(gx*a)-190
		If ty < -190 Then y = ScreenHeight - (gy*a)+190
		If ty > ScreenHeight+190 Then y = -(gy*a)-190
		
		SetAlpha (a-.15)*.6
		SetScale a*6,a*6

		If Scale*a < 1.0 Then
			'Plot x+(gx*a),y+(gy*a)
			DrawImage Image,x+(gx*a),y+(gy*a)

		Else

			DrawImage Image,x+(gx*a),y+(gy*a)
			'DrawOval x+(gx*a),y+(gy*a),gscale*a,gscale*a
		EndIf

		SetAlpha 1
	End Method
	
	Method Destroy()
		Stars.Remove ( Self )
	End Method
	
	Function DestroyAll()
		For Local tempStar:TStarfield = EachIn Stars
			tempStar.Destroy()
		Next
	End Function
	
	Function DrawAll(gx#,gy#,Scale# =1.0,HalfBright:Byte=False)
		
		If Not HalfBright
			For Local tempStar:TStarfield = EachIn Stars
				tempStar.DrawStar gx/5,gy/5,Scale
			Next
		Else
			For Local tempStar:TStarfield = EachIn Stars
				tempStar.DrawStarHalf gx/5,gy/5,Scale
			Next
		End If
		
	End Function
	
	Function AspectChange(StarAmount= 100)
		If Stars Then DestroyAll()
		For Local i = 0 To StarAmount
			Local tempStar:TStarfield = New TStarfield
			tempStar.x = Rand(-230,ScreenWidth+230)
			tempStar.y = Rand(-200,ScreenHeight+200)
			tempstar.a = Rnd(0.2,1.1)
		Next
	End Function
	
	Function Init(StarAmount = 100)
		If Stars Then DestroyAll()
		For Local i = 0 To StarAmount
			Local tempStar:TStarfield = New TStarfield
			tempStar.x = Rand(-230,ScreenWidth+230)
			tempStar.y = Rand(-200,ScreenHeight+200)
			tempstar.a = Rnd(0.2,1.1)
		Next
		
		If Not Image
			Local TempMap:TPixmap=CreatePixmap(11,11,PF_RGBA8888)
			ClearPixels (TempMap)
			For Local i=0 To 4
				WritePixel (TempMap,i+3,3,$ffffffff)
				WritePixel (TempMap,i+3,4,$ffffffff)
				WritePixel (TempMap,i+3,5,$ffffffff)
				WritePixel (TempMap,i+3,6,$ffffffff)
				WritePixel (TempMap,i+3,7,$ffffffff)
			Next
			
			Image=LoadImage(GaussianBlur(TempMap,1,220,35,245))
			BlurryImage=LoadImage(GaussianBlur(TempMap,2,220,35,245))
			
			MidHandleImage Image
			MidHandleImage BlurryImage
			
			image.Frame(0)
			blurryimage.Frame(0)
		End If
	End Function
End Type
'-----------------------------------------------------------------------------
'Conway's game of Life, used as a background effect here
'-----------------------------------------------------------------------------
Type TGameOfLife Extends TObject
	Field Width:Int,Height:Int
	Field Array:Int[,]
	Global TempArray:Int[,]
	
	Global Image:TImage
	Global GameRGB:Int[3]
	
	Method New()
		Width = ScreenWidth*0.125
		Height = ScreenHeight*0.125
		Width:+2
		Height:+2
	End Method
	
	Method AspectChange()
		Array = New Int[Width,Height]
		TempArray = New Int[Width,Height]

		For Local x:Int = 0 To Width-1
			For Local y:Int = 0 To Height-1
				Array[x,y] = 0
				TempArray[x,y] = 0
			Next
		Next
	End Method
	
	Method Init()
		Array = New Int[Width,Height]
		TempArray = New Int[Width,Height]

		For Local x:Int = 0 To Width-1
			For Local y:Int = 0 To Height-1
				Array[x,y] = 0
				TempArray[x,y] = 0
			Next
		Next
		For Local i=0 To 2
			GameRGB[i]=Rand(45,135)
		Next
	End Method
	
	Method Clear()
		For Local x:Int = 0 Until Width
			For Local y:Int = 0 Until Height
				Array[x,y] = 0
			Next
		Next

	EndMethod
	
	Method Update()
		
		Local MX:Int = Player.X*0.125,MY:Int = Player.Y*0.125
		If MX>0 And MY>0 And MX<Width And MY<Height Then Array[MX,MY] = 1 ;Array[MX+1,MY] = 1;Array[MX,MY+1] = 1
		
		'Local NewArray:Int[Width,Height]

		For Local x:Int = 0 To Width-1
			For Local y:Int = 0 To Height-1
				TempArray[x,y] = 0
			Next
		Next

		For Local x:Int = 0 To Width-1
			For Local y:Int = 0 To Height-1
				Local NCount:Int = Neighbours(x,y)
				If (Array[x,y] And (NCount = 2)) Or NCount = 3 Then TempArray[x,y] = 1
			Next
		Next
		
		MemCopy (Array,TempArray,SizeOf(TempArray))
	End Method

	Method Draw()
		
		'Return, we don't need to toggle drawmodes when we are not going to draw anything - duh!
		If GlLines
			glDisable GL_TEXTURE_2D ; glBegin GL_QUADS
			SetColor GameRGB[0],GameRGB[1],GameRGB[2]
			For Local x:Int = 0 To Width-1
				For Local y:Int = 0 To Height-1
					If Array[x,y]
						'DrawRect x*8,y*8,8,8
						If WideScreen
							Select BackGroundStyle
							
							Case 1
								FastRect x*8,y*8,5,6
							Case 2
								FastRect x*8,y*8,8,8
							Case 3
								FastRect x*8,y*8,8,3
							Case 4
								SetColor GameRGB[0],GameRGB[1],GameRGB[2]
								FastRect x*8,y*8,8,3
								SetColor GameRGB[0]+55,GameRGB[1]+55,GameRGB[2]+55
								FastRect x*8+2,y*8+2,4,4
							End Select
						Else
							Select BackGroundStyle
							Case 1
								FastRect x*8,y*8,6,6
							Case 2
								FastRect x*8,y*8,8,8
							Case 3
								FastRect x*8,y*8,8,3
							Case 4
								SetColor GameRGB[0],GameRGB[1],GameRGB[2]
								FastRect x*8,y*8,8,3
								SetColor GameRGB[0]+55,GameRGB[1]+55,GameRGB[2]+55
								FastRect x*8+2,y*8+2,4,4
							End Select
						End If
					End If
				Next
			Next
			glEnd ; glEnable GL_TEXTURE_2D	
		Else
			SetScale 1,1
			SetColor GameRGB[0],GameRGB[1],GameRGB[2]
			For Local x:Int = 0 To Width-1
				For Local y:Int = 0 To Height-1
					If Array[x,y]
						'DrawRect x*8,y*8,8,8
						If WideScreen
							Select BackGroundStyle
							
							Case 1
								DrawRect x*8,y*8,5,6
							Case 2
								DrawRect x*8,y*8,8,8
							Case 3
								DrawRect x*8,y*8,8,3
							Case 4
								SetColor GameRGB[0],GameRGB[1],GameRGB[2]
								DrawRect x*8,y*8,8,3
								SetColor GameRGB[0]+55,GameRGB[1]+55,GameRGB[2]+55
								DrawRect x*8+2,y*8+2,4,4
							End Select
						Else
							Select BackGroundStyle
						
							Case 1
								DrawRect x*8,y*8,6,6
							Case 2
								DrawRect x*8,y*8,8,8
							Case 3
								DrawRect x*8,y*8,8,3
							Case 4
								SetColor GameRGB[0],GameRGB[1],GameRGB[2]
								FastRect x*8,y*8,8,3
								SetColor GameRGB[0]+55,GameRGB[1]+55,GameRGB[2]+55
								FastRect x*8+2,y*8+2,4,4
							End Select
						End If
					End If
				Next
			Next
		End If
		'SetScale 1,1
		SetColor 255,255,255
	End Method

	Method Neighbours:Int(x:Int,y:Int)
		Local NCount:Int = 0
		For Local t:Int = x-1 To x+1
			For Local s:Int = y-1 To y+1
				If t=>0 And s=>0 And t<Width And s<Height Then
					If Array[t,s] And Not (t=x And s=y) Then NCount:+1
				EndIf
			Next
		Next
		Return NCount
	End Method

End Type

'--------------------------------------------------------------------------------
'BoxedIN another Background preference displaying random colorful boxes
'--------------------------------------------------------------------------------
Type TBoxedIn Extends TObject
	
	Const MaxAmount:Int=128
	
	Global RGB:Int[3]
	Global OwnRGB:Int[3]
	Global List:TList
	Global BoxCount:Int
	
	Field Transparency:Float
	Field TargetTransparency:Float
	Field FadeSpeed:Float
	Field Width:Float
	Field Height:Float
	
	Function WarmUp()
		For Local i=1 To 500
			UpdateAll()
		Next
	End Function
	
	Function Init()
		If RGB[0]=0
		
			For Local i=0 To 2
				RGB[i]=Rand(Player.RGB[i]/2.2,Player.RGB[i]*1.15)
				OwnRGB[i]=Rand(55,125)
			Next
			
		End If
	End Function
	
	Function Spawn()
	
		If Not List List = CreateList()
		
		Local BoxedIn:TBoxedIn = New TBoxedIn
		List.Addlast BoxedIn
		
		BoxedIn.X = Rand(-100,ScreenWidth+100)
		BoxedIn.Y = Rand(-100,ScreenHeight+100)
		BoxedIn.Width = Rand (25,175)
		BoxedIn.Height = Rand (20,175)
		BoxedIn.Transparency=0
		BoxedIn.TargetTransparency = Rnd(.35,.75)
		BoxedIn.FadeSpeed = Rnd(1,5)
		
		BoxCount:+1
		
	End Function
	
	Method DrawGL()
		
		SetAlpha Transparency
		FastRect(X,Y,Width,Height)
	
	End Method
	
	Method Draw()
		
		SetAlpha Transparency
		DrawRect (X,Y,Width,Height)
	
	End Method
	
	Method DrawGLHalf()
		
		SetAlpha Transparency*.6
		FastRect(X,Y,Width,Height)
	
	End Method
	
	Method DrawHalf()
		
		SetAlpha Transparency*.6
		DrawRect (X,Y,Width,Height)
	
	End Method
	
	Method Update()
		
		If TargetTransparency>Transparency
			Transparency:+(FadeSpeed/4000)*Delta
		Else
			TargetTransparency=0
			Transparency:-(FadeSpeed/2750)*Delta
		End If
		
		If Transparency<=0
			Destroy()
			BoxCount:-1
		End If
		
	End Method
	
	Function DrawAll(UseOwnColor:Byte,HalfTransparency:Byte=False)
	
		If Not List Return
		
		If UseOwnColor
			SetColor OwnRGB[0],OwnRGB[1],OwnRGB[2]
		Else
			SetColor RGB[1],RGB[1],RGB[1]
		End If
		
		If Not HalfTransparency
			If GlLines
				glDisable GL_TEXTURE_2D ; glBegin GL_QUADS
				For Local BoxedIn:TBoxedIn = EachIn List
					BoxedIn.DrawGL()
				Next
				glEnd ; glEnable GL_TEXTURE_2D
				
				SetAlpha 1	
				SetColor 255,255,255
			Else
				SetScale 1,1
				For Local BoxedIn:TBoxedIn = EachIn List
					BoxedIn.Draw()
				Next
				
				SetAlpha 1	
				SetColor 255,255,255
			End If
		Else
			If GlLines
				glDisable GL_TEXTURE_2D ; glBegin GL_QUADS
				For Local BoxedIn:TBoxedIn = EachIn List
					BoxedIn.DrawGLHalf()
				Next
				glEnd ; glEnable GL_TEXTURE_2D
				
				SetAlpha 1	
				SetColor 255,255,255
			Else
				SetScale 1,1
				For Local BoxedIn:TBoxedIn = EachIn List
					BoxedIn.DrawHalf()
				Next
				
				SetAlpha 1	
				SetColor 255,255,255
			End If
		End If
		
	End Function
	
	Function UpdateAll()
			
		If WideScreen
			While BoxCount<=MaxAmount+16
				Spawn()
			Wend
		Else
			While BoxCount<=MaxAmount
				Spawn()
			Wend
		End If
		
		For Local BoxedIn:TBoxedIn = EachIn List
			BoxedIn.Update()
		Next
		
	End Function
	
	Method Destroy()
	
		List.Remove ( Self )
	
	End Method
	
End Type

'-----------------------------------------------------------------------------------
'UpRising another Background displaying random boxes rising up in the eternal draft
'-----------------------------------------------------------------------------------
Type TUpRising Extends TObject
	
	Const MaxAmount:Int=128
	
	Global RGB:Int[3]
	Global OwnRGB:Int[3]
	Global List:TList
	Global BoxCount:Int
	
	Field Transparency:Float
	Field Speed:Float
	Field Width:Float
	Field OldWidth:Float
	Field Height:Float
	Field RotationDir:Int
	
	Function Init()
	
		If RGB[0]=0
		
			For Local i=0 To 2
				RGB[i]=Rand(Player.RGB[i]/2.4,Player.RGB[i]*1.05)
				OwnRGB[i]=Rand(55,125)
			Next
		
		End If
		
	End Function
	
	Function WarmUp()
		For Local i=1 To 3000
			UpdateAll()
		Next
	End Function
	
	Function Spawn()
	
		If Not List List = CreateList()
		
		Local UpRising:TUpRising = New TUpRising
		List.Addlast UpRising
		
		UpRising.X = Rand(-100,ScreenWidth+100)
		UpRising.Y = Rand(ScreenHeight+150,ScreenHeight+200)
		UpRising.Width = Rand (27,160)
		UpRising.Height = Rand (65,160)
		UpRising.OldWidth = UpRising.Width
		UpRising.Transparency=Rnd(.25,.75)
		UpRising.Speed = UpRising.Transparency/1.3
		UpRising.RotationDir = Rand(0,1)
		
		BoxCount:+1
		
	End Function
	
	Method DrawGL()
		
		SetAlpha Transparency
		FastRect(X-(OldWidth-Width)/2,Y,Width,Height)
	
	End Method
	
	Method Draw()
		
		SetAlpha Transparency
		DrawRect (X-(OldWidth-Width)/2,Y,Width,Height)
	
	End Method
	
	Method DrawGLHalf()
		
		SetAlpha Transparency*.65
		FastRect(X-(OldWidth-Width)/2,Y,Width,Height)
	
	End Method
	
	Method DrawHalf()
		
		SetAlpha Transparency*.65
		DrawRect (X-(OldWidth-Width)/2,Y,Width,Height)
	
	End Method
	
	Method Update()
		
		Y:-Speed*Delta
		
		If RotationDir=0
			Width:-.35*Delta
			If Width<=-OldWidth RotationDir=1
		Else
			Width:+.35*Delta
			If Width>= OldWidth RotationDir=0
		End If
		
		If Y<-(Height+20)
			Destroy()
			BoxCount:-1
		End If
		
	End Method
	
	Function DrawAll(UseOwnColor:Byte,HalfBright:Byte=False)
	
		If Not List Return
		
		If UseOwnColor
			SetColor OwnRGB[0],OwnRGB[1],OwnRGB[2]
		Else
			SetColor RGB[1],RGB[1],RGB[1]
		End If
		
		If Not HalfBright
			If GlLines
				glDisable GL_TEXTURE_2D ; glBegin GL_QUADS
				For Local UpRising:TUpRising = EachIn List
					UpRising.DrawGL()
				Next
				glEnd ; glEnable GL_TEXTURE_2D
				
				SetAlpha 1	
				SetColor 255,255,255
			Else
				SetScale 1,1
				For Local UpRising:TUpRising = EachIn List
					UpRising.Draw()
				Next
				
				SetAlpha 1	
				SetColor 255,255,255
			End If
		Else
			If GlLines
				glDisable GL_TEXTURE_2D ; glBegin GL_QUADS
				For Local UpRising:TUpRising = EachIn List
					UpRising.DrawGLHalf()
				Next
				glEnd ; glEnable GL_TEXTURE_2D
				
				SetAlpha 1	
				SetColor 255,255,255
			Else
				SetScale 1,1
				For Local UpRising:TUpRising = EachIn List
					UpRising.DrawHalf()
				Next
				
				SetAlpha 1	
				SetColor 255,255,255
			End If
		End If
		
	End Function
	
	Function UpdateAll()
			
		If WideScreen
			While BoxCount<=MaxAmount+6
				Spawn()
			Wend
		Else
			While BoxCount<=MaxAmount
				Spawn()
			Wend
		End If
		
		For Local UpRising:TUpRising = EachIn List
			UpRising.Update()
		Next
		
	End Function
	
	Method Destroy()
	
		List.Remove ( Self )
	
	End Method
	
End Type

'--------------------------------------------------------------------------------
'Grid Hit: Just another glowing grid background
'--------------------------------------------------------------------------------
Type TGridHit Extends TObject
	
	Const MaxAmount:Int=150
	
	Global RGB:Int[3]
	Global List:TList
	Global BoxCount:Int
	
	Field Transparency:Float
	Field TransparencyTarget:Float
	Field Width:Float
	Field Height:Float

	Function Init()
	
		If RGB[0]=0
			
			For Local i=0 To 2
				RGB[i]=Rand(50,120)
			Next
			
		End If
			
	End Function
		
	Function Generate(XRes:Int,YRes:Int)

		DestroyAll()
		
		If List Then List=Null
		
		List = CreateList()
		
		For Local x=0 To XRes Step 42
			
			Local GridHit:TGridHit = New TGridHit	 
			List.AddLast GridHit
			
			GridHit.X=X
			GridHit.Y=0
			GridHit.Width=8
			GridHit.Height=YRes
			GridHit.Transparency=.1
			GridHit.TransparencyTarget=.1

		Next
		
		For Local y=0 To YRes Step 42
			
			Local GridHit:TGridHit = New TGridHit	 
			List.AddLast GridHit
			
			GridHit.X=0
			GridHit.Y=Y
			GridHit.Width=Xres
			GridHit.Height=8
			GridHit.Transparency=.1
			GridHit.TransparencyTarget=.1
			
		Next
		
	EndFunction
	
	Method DrawGL()
		
		If Transparency<=0 Return
		
		SetAlpha Transparency
		
		If X=0
			FastRect(X,Y,Width,Height)
			FastRect(X+2,Y,Width,4)
		Else
			FastRect(X,Y,Width,Height)
			FastRect(X,Y+2,4,Height)
		End If
		
	End Method
	
	Method Draw()
		
		If Transparency<=0 Return
		
		SetAlpha Transparency
		
		If X=0
			DrawRect(X,Y,Width,Height)
			DrawRect(X+2,Y,Width,4)
		Else
			DrawRect(X,Y,Width,Height)
			DrawRect(X,Y+2,4,Height)
		End If
		
	End Method
	
	Method DrawGLHalf()
		
		If Transparency<=0 Return
		
		SetAlpha Transparency*.6
		
		If X=0
			FastRect(X,Y,Width,Height)
			FastRect(X+2,Y,Width,4)
		Else
			FastRect(X,Y,Width,Height)
			FastRect(X,Y+2,4,Height)
		End If
		
	End Method
	
	Method DrawHalf()
		
		If Transparency<=0 Return
		
		SetAlpha Transparency*.6
		
		If X=0
			DrawRect(X,Y,Width,Height)
			DrawRect(X+2,Y,Width,4)
		Else
			DrawRect(X,Y,Width,Height)
			DrawRect(X,Y+2,4,Height)
		End If
		
	End Method
	
	Method Update()
		
		If Player.X-8<=X And Player.X+8=>X
			If Abs(Player.XSpeed) + Abs(Player.YSpeed)>0.2 Then
				TransparencyTarget=.6
			End If	

		ElseIf Player.Y-8<=Y And Player.Y+8=>Y
			If Abs(Player.XSpeed) + Abs(Player.YSpeed)>0.2 Then
				TransparencyTarget=.6
			End If		
		End If 
		
		If Transparency=>TransparencyTarget
			TransparencyTarget=.10
			Transparency:-0.001*Delta
		ElseIf Transparency<TransparencyTarget And TransparencyTarget>.10
			Transparency:+0.005*Delta
		End If
		
	End Method
	
	Function Reset()
	
		For Local GridHit:TGridHit = EachIn List
			GridHit.Transparency=.1
			GridHit.TransparencyTarget=.25
		Next
	
	End Function
	
	Function DrawAll(LowBright:Byte=False)
	
		If Not List Return
		SetBlend LIGHTBLEND
		SetColor RGB[0],RGB[1],RGB[2]
		
		If Not LowBright
			If GlLines
			glDisable GL_TEXTURE_2D ; glBegin GL_QUADS
			For Local GridHit:TGridHit = EachIn List
				GridHit.DrawGL()
			Next
			glEnd ; glEnable GL_TEXTURE_2D
			Else
				For Local GridHit:TGridHit = EachIn List
					GridHit.Draw()
				Next
			End If
		Else
			If GlLines
			glDisable GL_TEXTURE_2D ; glBegin GL_QUADS
			For Local GridHit:TGridHit = EachIn List
				GridHit.DrawGLHalf()
			Next
			glEnd ; glEnable GL_TEXTURE_2D
			Else
				For Local GridHit:TGridHit = EachIn List
					GridHit.DrawHalf()
				Next
			End If
		End If
		SetAlpha 1	
		SetColor 255,255,255
		SetBlend ALPHABLEND
	End Function
	
	Function UpdateAll()
		
		For Local GridHit:TGridHit = EachIn List
			GridHit.Update()
		Next
		
	End Function
	
	Method Destroy()
	
		List.Remove ( Self )
	
	End Method
	
	Function DestroyAll()
		If Not List Return
		For Local GridHit:TGridHit = EachIn List
			GridHit.Destroy()
		Next
	End Function

End Type

'-----------------------------------------------------------------------------
'BackGround pixel effect, looks like 70ies Disco
'-----------------------------------------------------------------------------
Type TBackground Extends TObject

	Global Image:TImage
	Global List:TList
	
	Field Transparency	:Float
	Field Scale:Float
	
	Function Generate(XRes:Int,YRes:Int)
		
		DestroyAll()
		
		If List Then List=Null
		
		List = CreateList()
		
		For Local x=0 To Xres Step 16
			For Local y=0 To Yres Step 16
			
			Local Background:TBackground = New TBackground	 
			List.AddLast Background
			
			Background.X=X
			Background.Y=Y
			Background.Transparency=1
			BackGround.Scale=1
			
			Next
		Next
		
	EndFunction

	
	Function Init()
		
		If List = Null List = CreateList()
		
		If Not Image'First Time
			Image = LoadImage(GetBundleResource("Graphics/glow.png"))
			MidHandleImage( Image )
		EndIf
		
	End Function
	
	Method Draw()	
		
		If Transparency<=0 Or Scale<=0 Return
		
		SetScale(Scale,Scale)
		SetAlpha (Transparency)
		
		DrawImage(Image,X,Y)
		
	EndMethod
	
	Method DrawHalf()	
		
		If Transparency<=0 Or Scale<=0 Return
		
		SetScale(Scale,Scale)
		SetAlpha (Transparency*.6)
		
		DrawImage(Image,X,Y)
		
	EndMethod
	
	Method Update()
	

		If Player.X-4<X And Player.X+16>X
		
			If Player.Y-4<Y And Player.Y+16>Y
			
				If Abs(Player.XSpeed) + Abs(Player.YSpeed)>0.4 Then
					Transparency=.6
					Scale=3
				End If
				
			End If
		
		End If 

		If Scale>0
		
			Transparency:-0.0004*Delta
			Scale:-0.0035*Delta
		
		End If
		
	End Method
	
	Function DrawAll(HalfBright:Byte=False)
		
		If Not List Return 
		
		SetRotation 0
		Local Background:TBackground
		If Not HalfBright
			For Background = EachIn List
				Background.Draw()
			Next
		Else
			For Background = EachIn List
				Background.DrawHalf()
			Next
		End If
		'It's faster to re-set the scale and transparency once than every time for a particle
		SetAlpha 1
	
	End Function

	Function UpdateAll()
		
		Local Background:TBackground
		For Background = EachIn List
			Background.Update()
		Next
		
	End Function
	
	
	Function Reset()
		
		Local Background:TBackground
		For Background = EachIn List
			Background.Scale=0
			BackGround.Transparency=0
		Next
		
	End Function
	
	Method Destroy()
	
		List.Remove( Self )
	
	End Method
	
	Function DestroyAll()
		If Not List Return
		Local Background:TBackground
		For Background = EachIn List
			Background.Destroy()
		Next
	End Function

End Type

'-----------------------------------------------------------------------------
'Squared pixel effect, follwoing the player
'-----------------------------------------------------------------------------
Type TSquared Extends TObject

	Global Image:TImage
	Global List:TList
	
	Field OffsetX:Float
	Field OffsetY:Float
	Field Width:Float
	Field Height:Float
	
	Function Generate(XRes:Int,YRes:Int)
		
		DestroyAll()
		
		If List Then List=Null
		
		List = CreateList()
		
		For Local x=-Xres/4 To Xres*1.25 Step 32
			For Local y=-Yres/4 To Yres*1.25 Step 32
			
			Local Squared:TSquared = New TSquared	 
			List.AddLast Squared
			
			Squared.X=X
			Squared.Y=Y
			Squared.Width=10
			Squared.Height=10
			
			Next
		Next
		
	EndFunction

	
	Function Init()
		
		If List = Null List = CreateList()
		
	End Function

	Method DrawGL()
		
		FastRect(X+OffsetX,Y+OffsetY,Width,Height)
	
	End Method
	
	Method Draw()
		
		DrawRect (X+OffsetX,Y+OffsetY,Width,Height)
	
	End Method
	
	Method DrawGLHalf()

		FastRect(X+OffsetX,Y+OffsetY,Width,Height)
	
	End Method
	
	Method DrawHalf()
		
		DrawRect (X+OffsetX,Y+OffsetY,Width,Height)
	
	End Method
	
	Function DrawAll(HalfTransparency:Byte=False, UseOwnColor:Byte=False)

		If UseOwnColor
			SetColor Player.RGB[0]*.6,Player.RGB[1]*.55,Player.RGB[2]*1.05
		Else
			SetColor Player.RGB[2],Player.RGB[2],Player.RGB[2]
		End If
		'SetBlend ALPHABLEND
		If Not HalfTransparency
			If Not UseOwnColor
				SetAlpha 0.34
			Else
				SetAlpha 0.34
			End If
			If GlLines
				glDisable GL_TEXTURE_2D ; glBegin GL_QUADS
				
				Local link:TLink= List.FirstLink()
				While link
					Local Squared:TSquared=TSquared(link._value)
					Squared.DrawGL() 
					If link._succ._value<>link._succ 
						link=link._succ
					Else
						link=Null
					End If		
				Wend
				'For Local Squared:TSquared = EachIn List
				'	Squared.DrawGL()
				'Next
				glEnd ; glEnable GL_TEXTURE_2D
				
				SetAlpha 1	
				SetColor 255,255,255
			Else
				SetScale 1,1
				Local link:TLink= List.FirstLink()
				While link
					Local Squared:TSquared=TSquared(link._value)
					Squared.Draw() 
					If link._succ._value<>link._succ 
						link=link._succ
					Else
						link=Null
					End If		
				Wend
				'For Local Squared:TSquared = EachIn List
				'	Squared.Draw()
				'Next
				
				SetAlpha 1	
				SetColor 255,255,255
			End If
		Else
			SetAlpha 0.35*.6
			If GlLines
				glDisable GL_TEXTURE_2D ; glBegin GL_QUADS
				Local link:TLink= List.FirstLink()
				While link
					Local Squared:TSquared=TSquared(link._value)
					Squared.DrawGLHalf() 
					If link._succ._value<>link._succ 
						link=link._succ
					Else
						link=Null
					End If		
				Wend
				'For Local Squared:TSquared = EachIn List
				'	Squared.DrawGLHalf()
				'Next
				glEnd ; glEnable GL_TEXTURE_2D
				
				SetAlpha 1	
				SetColor 255,255,255
			Else
				SetScale 1,1
				'For Local Squared:TSquared = EachIn List
				'	Squared.DrawHalf()
				'Next
				Local link:TLink= List.FirstLink()
				While link
					Local Squared:TSquared=TSquared(link._value)
					Squared.DrawHalf() 
					If link._succ._value<>link._succ 
						link=link._succ
					Else
						link=Null
					End If		
				Wend
				SetAlpha 1	
				SetColor 255,255,255
			End If
		End If
		'SetBlend ALPHABLEND
	End Function
	
	Method Update()
		Local PlayerDist:Float=4000/PlayerDistance(X,Y)
		Local PlayerFar:Float=PlayerDistance(X,Y)
		PlayerDist = Min (PlayerDist,50)
		PlayerDist = Max (PlayerDist,8.5)
		
		If Player.X>X+Width/2 And PlayerFar<350
			OffsetX:+.5*Delta
		ElseIf Player.X<X+Width/2 And PlayerFar<350
			OffsetX:-.5*Delta
		Else
			If OffsetX>0
				OffsetX:-.15*Delta
			ElseIf OffsetX<0
				OffsetX:+.15*Delta
			End If
		End If
		
		If Player.Y>Y+Height/2 And PlayerFar<350
			OffsetY:+.5*Delta
		ElseIf Player.Y<Y+Height/2 And PlayerFar<350
			OffsetY:-.5*Delta
		Else
			If OffsetY>0
				OffsetY:-.15*Delta
			ElseIf OffsetY<0
				OffsetY:+.15*Delta
			End If
		End If
		
		If Width>PlayerDist Then
			Width:-.15*Delta
		ElseIf Width<PlayerDist
			Width:+.5*Delta
		End If
		If Height>PlayerDist Then
			Height:-.15*Delta
		ElseIf Height<PlayerDist
			Height:+.5*Delta
		End If
		
		If OffsetX>65 Then OffsetX=65
		If OffsetX<-65 Then OffsetX=-65
		If OffsetY>65 Then OffsetY=65
		If OffsetY<-65 Then OffsetY=-65
		
	End Method
	
	Function UpdateAll()
		
		'Local Squared:TSquared
		'For Squared = EachIn List
		'	Squared.Update()
		'Next
		
		Local link:TLink= List.FirstLink()
		While link
			Local Squared:TSquared=TSquared(link._value)
			Squared.Update() 
			If link._succ._value<>link._succ 
				link=link._succ
			Else
				link=Null
			End If		
		Wend
		
	End Function
	
	
	Function Reset()
		
		Local Squared:TSquared
		For Squared = EachIn List
			Squared.OffsetX=0
			Squared.OffsetY=0
			Squared.Width=10
			Squared.Height=10
		Next
		
	End Function
	
	Method Destroy()
	
		List.Remove( Self )
	
	End Method
	
	Function DestroyAll()
		If Not List Return
		Local Squared:TSquared
		For Squared = EachIn List
			Squared.Destroy()
		Next
	End Function

End Type

'--------------------------------------------------------------------------------
'The Spawn Queue allows the "AI Director" to enque spawns.
'--------------------------------------------------------------------------------
Type TSpawnQueue Extends TObject

	Global List:TList
	
	Field SpawnType
	Field Interval
	
	Function Init()
		
		If Not List List = CreateList()
	
	End Function
	
	Function Add(SpawnType:Int,Kind:Int,Amount:Int,Interval:Int)
		
		Local TempVar:Float
		
		'Don't allow chasers, data probes and thieves to spawn next to the player - it's unfair!
		If SpawnType=SURROUND And Kind=SMARTIE Then SpawnType=CORNER
		If SpawnType=SURROUND And Kind=THIEFBOT Then SpawnType=CORNER
		If SpawnType=SURROUND And Kind=DATPROBE Then SpawnType=CORNER
		
		'Weavers have a 50% chance of spawning scattered
		If SpawnType=SURROUND And Kind=WEAVER Then
			If Rand(0,10)<=5 Then SpawnType=SCATTER
		End If
		
		'Always Scatter Corruption node spawns
		If SpawnType<>SCATTER And Kind=CORRUPTNODE Then SpawnType=SCATTER
		
		If Not List List = CreateList()
		
		Select SpawnType
		
			Case CORNER
				
				TempVar=Rand(1,4)
				
				Select TempVar
					
					Case 1
						
						For Local i=1 To Amount
							Local SpawnQueue:TSpawnQueue = New TSpawnQueue	 
							List.AddLast SpawnQueue
							
							SpawnQueue.X=Rand(1,145)
							SpawnQueue.Y=Rand(1,145)
							SpawnQueue.Interval=Rand(1,Interval)+MilliSecs()
							SpawnQueue.SpawnType=Kind
							
						Next
					
					Case 2
					
						For Local i=1 To Amount
							Local SpawnQueue:TSpawnQueue = New TSpawnQueue	 
							List.AddLast SpawnQueue
							
							SpawnQueue.X=Rand(FieldWidth-1,FieldWidth-145)
							SpawnQueue.Y=Rand(1,145)
							SpawnQueue.Interval=Rand(1,Interval)+MilliSecs()
							SpawnQueue.SpawnType=Kind
						
						Next
					
					Case 3
					
						For Local i=1 To Amount
							Local SpawnQueue:TSpawnQueue = New TSpawnQueue	 
							List.AddLast SpawnQueue
							
							SpawnQueue.X=Rand(1,145)
							SpawnQueue.Y=Rand(FieldHeight-1,FieldHeight-145)
							SpawnQueue.Interval=Rand(1,Interval)+MilliSecs()
							SpawnQueue.SpawnType=Kind
						
						Next
					
					Case 4
					
						For Local i=1 To Amount
							Local SpawnQueue:TSpawnQueue = New TSpawnQueue	 
							List.AddLast SpawnQueue
							
							SpawnQueue.X=Rand(FieldWidth-1,FieldWidth-145)
							SpawnQueue.Y=Rand(FieldHeight-1,FieldHeight-145)
							SpawnQueue.Interval=Rand(1,Interval)+MilliSecs()
							SpawnQueue.SpawnType=Kind
						
						Next
					
				End Select
				
			Case RNDCORNER
				
				
				For Local i=1 To Amount
					Local SpawnQueue:TSpawnQueue = New TSpawnQueue	 
					List.AddLast SpawnQueue
					
					TempVar=Rand(1,4)
				
					Select TempVar
					
						Case 1

							SpawnQueue.X=Rand(5,135)
							SpawnQueue.Y=Rand(5,135)
							SpawnQueue.Interval=Rand(1,Interval)+MilliSecs()
							SpawnQueue.SpawnType=Kind
					
						Case 2
					
							SpawnQueue.X=Rand(FieldWidth-5,FieldWidth-135)
							SpawnQueue.Y=Rand(5,135)
							SpawnQueue.Interval=Rand(1,Interval)+MilliSecs()
							SpawnQueue.SpawnType=Kind
					
						Case 3

							SpawnQueue.X=Rand(5,135)
							SpawnQueue.Y=Rand(FieldHeight-5,FieldHeight-135)
							SpawnQueue.Interval=Rand(1,Interval)+MilliSecs()
							SpawnQueue.SpawnType=Kind

					
						Case 4
							
							SpawnQueue.X=Rand(FieldWidth-5,FieldWidth-135)
							SpawnQueue.Y=Rand(FieldHeight-5,FieldHeight-135)
							SpawnQueue.Interval=Rand(1,Interval)+MilliSecs()
							SpawnQueue.SpawnType=Kind

					
					End Select
				
					SpawnQueue.Interval=Rand(1,Interval)+MilliSecs()
					SpawnQueue.SpawnType=Kind
				
				Next

			Case SCATTER
			
				For Local i=1 To Amount
					Local SpawnQueue:TSpawnQueue = New TSpawnQueue	 
					List.AddLast SpawnQueue
					Repeat
						SpawnQueue.X=Rand(55,FieldWidth-55)
						SpawnQueue.Y=Rand(55,FieldHeight-55)
					Until PlayerDistance(SpawnQueue.X,SpawnQueue.Y)>128
					SpawnQueue.Interval=Rand(1,Interval)+MilliSecs()
					SpawnQueue.SpawnType=Kind					
				Next
			
			Case CLUSTER
					Local FocalX:Int
					Local FocalY:Int
					
					Repeat
						FocalX=Rand(45,FieldWidth-45)
						FocalY=Rand(45,FieldHeight-45)
					Until PlayerDistance(FocalX,FocalY)>256
					
					For Local i=1 To Amount
						Local SpawnQueue:TSpawnQueue = New TSpawnQueue	 
						List.AddLast SpawnQueue
						
						SpawnQueue.X=Rand(FocalX-90,FocalX+90)
						SpawnQueue.Y=Rand(FocalY-90,FocalY+90)
						SpawnQueue.Interval=Rand(1,Interval)+MilliSecs()
						SpawnQueue.SpawnType=Kind
							
					Next
			
			Case SURROUND
			
				For Local i=1 To Amount
					Local SpawnQueue:TSpawnQueue = New TSpawnQueue	 
					Local FailSafe:Byte
					List.AddLast SpawnQueue
					Repeat
						SpawnQueue.X=Rand(25,FieldWidth-25)
						SpawnQueue.Y=Rand(25,FieldHeight-25)
						FailSafe:+1
						If FailSafe=9 Exit
					Until PlayerDistance(SpawnQueue.X,SpawnQueue.Y)>260 And PlayerDistance(SpawnQueue.X,SpawnQueue.Y)<400
					SpawnQueue.Interval=Rand(1,Interval)+MilliSecs()
					SpawnQueue.SpawnType=Kind					
				Next
			
			Case BORDER
		
				TempVar=Rand(1,4)
				
				Select TempVar
					
					Case 1
						
						For Local i=1 To Amount
							Local SpawnQueue:TSpawnQueue = New TSpawnQueue	 
							List.AddLast SpawnQueue
							
							SpawnQueue.X=Rand(5,55)
							SpawnQueue.Y=Rand(25,FieldHeight-25)
							SpawnQueue.Interval=Rand(1,Interval)+MilliSecs()
							SpawnQueue.SpawnType=Kind
							
						Next
					
					Case 2
					
						For Local i=1 To Amount
							Local SpawnQueue:TSpawnQueue = New TSpawnQueue	 
							List.AddLast SpawnQueue
							
							SpawnQueue.X=Rand(FieldWidth-5,FieldWidth-55)
							SpawnQueue.Y=Rand(25,FieldHeight-25)
							SpawnQueue.Interval=Rand(1,Interval)+MilliSecs()
							SpawnQueue.SpawnType=Kind
						
						Next
					
					Case 3
					
						For Local i=1 To Amount
							Local SpawnQueue:TSpawnQueue = New TSpawnQueue	 
							List.AddLast SpawnQueue
							
							SpawnQueue.X=Rand(25,FieldWidth-25)
							SpawnQueue.Y=Rand(5,55)
							SpawnQueue.Interval=Rand(1,Interval)+MilliSecs()
							SpawnQueue.SpawnType=Kind
						
						Next
					
					Case 4
					
						For Local i=1 To Amount
							Local SpawnQueue:TSpawnQueue = New TSpawnQueue	 
							List.AddLast SpawnQueue
							
							SpawnQueue.X=Rand(25,FieldWidth-25)
							SpawnQueue.Y=Rand(FieldHeight-5,FieldHeight-55)
							SpawnQueue.Interval=Rand(1,Interval)+MilliSecs()
							SpawnQueue.SpawnType=Kind
						
						Next
					
					End Select
					
			Case RNDBORDER
					
				For Local i=1 To Amount
					
					Local SpawnQueue:TSpawnQueue = New TSpawnQueue	 
					List.AddLast SpawnQueue		
				
					TempVar=Rand(1,4)
				
					Select TempVar
					
						Case 1
						
							SpawnQueue.X=Rand(5,55)
							SpawnQueue.Y=Rand(25,FieldHeight-25)


						Case 2
							
							SpawnQueue.X=Rand(FieldWidth-5,FieldWidth-55)
							SpawnQueue.Y=Rand(25,FieldHeight-25)


						Case 3

							SpawnQueue.X=Rand(25,FieldWidth-25)
							SpawnQueue.Y=Rand(5,55)
											
						Case 4
							
							SpawnQueue.X=Rand(25,FieldWidth-25)
							SpawnQueue.Y=Rand(FieldHeight-5,FieldHeight-55)
							
					End Select
						
					SpawnQueue.Interval=Rand(1,Interval)+MilliSecs()
					SpawnQueue.SpawnType=Kind
						
				Next
		
		End Select
	
	End Function
	
	Method Update()
		Local CornerHug:Byte 
		
		'Don't spawn enemys when getting ready
		If GameState=READY
			If MilliSecs()-Interval>0 Interval:+Rand(150,975)
			Return
		End If
		
		If Player.X<74 And Player.Y<74 CornerHug=True
		If Player.X>FieldWidth-74 And Player.Y>FieldHeight-74 CornerHug=True
		If Player.X<74 And Player.Y>FieldHeight-74 CornerHug=True
		If Player.X>FieldWidth-74 And Player.Y<74 CornerHug=True
		
		If Not CornerHug		
			'If too close delay the spawn another 375ms
			If Not SpawnType=Surround
				If MilliSecs()-Interval>0 And PlayerDistance(X+2.2,Y+2.2)<250
					Interval:+375
					Return
				End If
				
				If MilliSecs()-Interval>0 And PlayerDistance(X-2.2,Y-2.2)<250
					Interval:+375
					Return
				End If
			Else
				If MilliSecs()-Interval>0 And PlayerDistance(X+2.2,Y+2.2)<215
					Interval:+375
					Return
				End If
				
				If MilliSecs()-Interval>0 And PlayerDistance(X-2.2,Y-2.2)<215
					Interval:+375
					Return
				End If
			End If
		Else
			'If too close delay the spawn another 375ms
			If MilliSecs()-Interval>0 And PlayerDistance(X+2.2,Y+2.2)<168
				Interval:+285
				Return
			End If
			
			If MilliSecs()-Interval>0 And PlayerDistance(X-2.2,Y-2.2)<168
				Interval:+285
				Return
			End If
		End If
			
		If MilliSecs()-Interval>0 Then
			
			
			Select SpawnType		
			
				Case BOUNCER
					'Spawn the Spinner
					Spinner.Spawn(X,Y,False)
					'Remove Self from Qeue
					List.Remove( Self )
				
				Case ERRATIC
					'Spawn the Spinner
					Spinner.Spawn(X,Y,True)
					'Remove Self from Qeue
					List.Remove( Self )
				
				Case FOLLOWER
					'Spawn the Invader
					Invader.Spawn(X,Y,FOLLOWER)
					'Remove Self from Qeue
					List.Remove( Self )
		
				Case EVADER
					'Spawn the Invader
					Invader.Spawn(X,Y,EVADER)
					'Remove Self from Qeue
					List.Remove( Self )
					
				Case PANICER
					'Spawn the Invader
					Invader.Spawn(X,Y,PANICER)
					'Remove Self from Qeue
					List.Remove( Self )
				
				Case WEAVER
					'Spawn the Invader
					Invader.Spawn(X,Y,WEAVER)
					'Remove Self from Queue
					List.Remove ( Self )
				
				Case SSNAKE
					'Spawn the Snake
					Snake.Spawn(X,Y,20,Rand(3,50),0,0,0,True)
					'Remove Self from Queue
					List.Remove( Self )
				
				Case MMINELAYER
					'Spawn the MineLayer
					MineLayer.Spawn(X,Y,False)
					'Remove Self from Queue
					List.Remove( Self )
					
				Case CONNECTEDMINELAYER
					'Spawn the Connective MineLayer
					MineLayer.Spawn(X,Y,True)
					'Remove Self from Queue
					List.Remove( Self )
					
				Case SMARTIE
					'Spawn the Chaser
					Chaser.Spawn(X,Y)
					'Remove Self from Queue
					List.Remove( Self )
					
				Case THIEFBOT
					'Spawn the Thief
					Thief.Spawn(X,Y)
					'Remove Self from Queue
					List.Remove( Self )
					
				Case FEARLESSTHIEF
					'Spawn the Fearless Thief
					Thief.Spawn(X,Y,True)
					'Remove Self from Queue
					List.Remove( Self )
					
				Case FLOCK
					'Spawn the Flocking Boid
					Boid.Spawn(X,Y)
					'Remove Self from Queue
					List.Remove( Self )
					
				Case AASTEROID
					'Spawn the Asteroid
					Asteroid.Spawn(X,Y)
					'Remove Self from Queue
					List.Remove( Self )
						
				Case CORRUPTNODE
					'Spawn the Corruption Node
					CorruptionNode.Spawn(X,Y)
					'Remove Self from Queue
					List.Remove( Self )
				
				Case DATPROBE
					'Spawn the DataProbe
					DataProbe.Spawn(X,Y)
					'Remove Self from Queue
					List.Remove( Self )
				
			End Select

		End If
	
	EndMethod
	
	Method Destroy()
	
		List.Remove( Self )
	
	End Method
	
	Function Empty()
		
		For Local SpawnQueue:TSpawnQueue = EachIn TSpawnQueue.List
			SpawnQueue.Destroy()
		Next
	
	End Function
	
	Function UpdateAll()
		If Not List Return 
		
		For Local SpawnQueue:TSpawnQueue = EachIn List
			SpawnQueue.Update()
		Next
	EndFunction

End Type

'-----------------------------------------------------------------------------
'The Basic Invader Type
'-----------------------------------------------------------------------------
Type TInvader Extends TObject	
	Global List:TList
	Global Variations:Int
	Global InvaderBody:TImage[]
	Global InvaderGlow:TImage[]
	Global InvaderRGB:Int[,]
	Global AllPanic:Int=0
	Global DeathX:Float=0
	Global DeathY:Float=0
	Global Name:String[WEAVER+1]
	
	Field Homing:Byte=False
	Field Panic:Byte=False
	Field TargetStretch:Byte=False
	Field SpriteNumber:Int
	Field Wavy:Float
	Field AI:Byte
	Field MaxSpeed:Float
	Field Evading:Int=False
	Field Radius:Float 
	Field InterpolateDir:Float
	Field ScanRadius:Int
	
	Field OldSpeedX:Float
	Field OldSpeedY:Float
	
	Field MissID:String	
	Field NearMissTime:Int
	
	Field BlurSteps:Float
	
	Function Generate(NumInvaders:Int)
		
		List=Null
		
		List = CreateList()
		
		Name[EVADER]="EVADER"
		Name[PANICER]="PANICER"
		Name[FOLLOWER]="FOLLOWER"
		Name[WEAVER]="WEAVER"
		
		Variations=NumInvaders
		
		InvaderGlow = New TImage[Variations+1]
		InvaderBody = New TImage[Variations+1]
		InvaderRGB = New Int[Variations+1,3]
		
		For Local i=1 To NumInvaders
			
			'Generate and Draw
			GenerateInvader(i)
			
			PrepareFrame(InvaderBody[i])
			PrepareFrame(InvaderGlow[i])
			
		Next
		
	End Function
		
	Function Preview(X,Y,SpriteNum)
		
		'Print InvaderLogo
		SetBlend alphablend
		SetScale 4,4
		
		DrawImage InvaderBody[SpriteNum],x,y
		
		SetScale 5,5
		SetAlpha .95
		SetBlend lightblend
		DrawImage InvaderGlow[SpriteNum],x,y
		
		SetBlend alphablend
		SetScale 1,1
		SetAlpha 1
	End Function
	
	Function ReCache()
		For Local i=1 To Variations
			PrepareFrame(InvaderBody[i])
			PrepareFrame(InvaderGlow[i])
		Next
	End Function

	Function Spawn(X:Int,Y:Int,AiType:Int)
		
		If Player.Alive
			If CountList(List) => 42 Then Return Null	
		Else
			If CountList(List) => 20 Then Return Null	
		End If
		
		If PlayerDistance(X,Y)<120 Return Null
		
		'EnemyCount:+1
		
		Local Invader:TInvader = New TInvader	 
		List.AddLast Invader
			
		Invader.SpriteNumber=Rand(1,Variations)
		
		Invader.MissID=String(Invader.SpriteNumber)+"="+String(Rand(-32000,94000))
		
		Invader.X=X
		Invader.Y=Y
		Invader.AI=AiType

		SpawnEffect.Fire(Invader.X,Invader.Y,.8,InvaderRGB[Invader.SpriteNumber,0]	,InvaderRGB[Invader.SpriteNumber,1],InvaderRGB[Invader.SpriteNumber,2])	

		Select AiType
				
			Case FOLLOWER
			
				Invader.Direction=Rand(1,360)
				Invader.MaxSpeed=.42+SpeedGain
				Invader.XSpeed:+ Cos(Invader.Direction)/2
				Invader.YSpeed:+ Sin(Invader.Direction)/2
				Invader.Direction=ATan2(Invader.YSpeed,Invader.XSpeed)+90
				PlaySoundBetter Sound_Invader_Born,X,Y
				
			Case EVADER
			
				Invader.Direction=Rand(1,360)
				Invader.MaxSpeed=.52+SpeedGain*.85
				Invader.XSpeed:+ Cos(Invader.Direction)/2
				Invader.YSpeed:+ Sin(Invader.Direction)/2
				Invader.Direction=ATan2(Invader.YSpeed,Invader.XSpeed)+90
				PlaySoundBetter Sound_ScaredInvader_Born,X,Y
				Invader.ScanRadius=125
				
			Case PANICER

				Invader.Direction=Rand(1,360)
				Invader.MaxSpeed=.54+SpeedGain*.65
				Invader.XSpeed:+ Cos(Invader.Direction)/2
				Invader.YSpeed:+ Sin(Invader.Direction)/2
				Invader.Direction=ATan2(Invader.YSpeed,Invader.XSpeed)+90
				PlaySoundBetter Sound_ScaredInvader_Born,X,Y
				Invader.ScanRadius=155
				
			Case WEAVER
				'Invader.ScanRadius=85
				Invader.Direction=Rand(1,360)
				'Invader.MaxSpeed=.49
				Invader.MaxSpeed=.5+SpeedGain*.45
				Invader.XSpeed:+ Cos(Invader.Direction)/2
				Invader.YSpeed:+ Sin(Invader.Direction)/2
				Invader.Direction=ATan2(Invader.YSpeed,Invader.XSpeed)+90
				Invader.Radius=Rand(0,359)
				PlaySoundBetter Sound_WeaverInvader_Born,X,Y
				
		End Select
		
		If SeedDifficultyJudge<40 And Invader.ScanRadius>0
			Invader.Scanradius:-30
		End If
		'If Not ChannelPlaying(BornChannel) PlaySound SoundBorn,BornChannel
		
	End Function
	
	Method DrawBodyCorr()
		Local ImgWidth = ImageWidth(InvaderBody[SpriteNumber])
		Local ImgHeight = ImageHeight(InvaderBody[SpriteNumber])
		
		If Panic SetAlpha 0.45
		SetRotation(Direction)
		'DrawImage InvaderBody[SpriteNumber],x,y
		'DrawSubImageRect DataNodeBody[SpriteNumber],x,y+DrawOffset*4,NodeDimensions,5,0,DrawOffset,NodeDimensions,5,0,0

		For Local i=1 To ImgHeight
			DrawSubImageRect InvaderBody[SpriteNumber],ImgWidth*2+X+Cos(Direction)*((Y+I*4)-ImgHeight*2),ImgHeight*2+(Y+I*4)+Sin(Direction)*((Y+I*4)-ImgHeight*2),ImgWidth,1,0,i,ImgHeight,1,0,0
		Next
		If Panic SetAlpha 1
		
	EndMethod
	
	Method DrawGlowCorr()
		
		Local ImgWidth = ImageWidth(InvaderBody[SpriteNumber])
		Local ImgHeight = ImageHeight(InvaderBody[SpriteNumber])
		
		SetRotation(Direction)
		'DrawImage InvaderBody[SpriteNumber],x,y
		'DrawSubImageRect DataNodeBody[SpriteNumber],x,y+DrawOffset*4,NodeDimensions,5,0,DrawOffset,NodeDimensions,5,0,0

		For Local i=1 To ImgHeight
			DrawSubImageRect InvaderGlow[SpriteNumber],x,y+i*4,ImgWidth,1,0,i,ImgHeight,1,0,0
		Next

	EndMethod
	
	Method DrawBody()
		

		'SetScale 4,4
		'InterPolateDir=Direction
		If Panic
			SetColor 158,158,158
		Else
			SetColor 255,255,255
		End If
		SetRotation(Direction+Cos(Wavy)*10)
		DrawImage InvaderBody[SpriteNumber],x,y
		'SetScale 1,1
		'SetRotation(0)
		'SetColor 0,255,0
		'DrawText Direction,x,y
		'SetColor 255,0,0
		'DrawText InterpolateDir,x,y+20
		'SetColor 255,255,255
	EndMethod
	
	Method DrawGlow()
		
		SetRotation(Direction+Cos(Wavy)*10)
		DrawImage InvaderGlow[SpriteNumber],x,y
		
	EndMethod
	
	Method DodgeShot(x1:Float,y1:Float,x2:Float,y2:Float)
		'Dont evade when close to walls
		If Not IsVisible(X,Y,-32) Return
		Local ddx:Float = x1-x-(x1-x2)*3
		Local ddy:Float = y1-y-(y1-y2)*3
		Local bdx:Float = x1-x2
		Local bdy:Float = y1-y2
		Local distd:Float = Sqr(ddx*ddx + ddy*ddy)+0.001
		Local distb:Float = Sqr(bdx*bdx + bdy*bdy)+0.001					
		If distd < ScanRadius 
			ddx = -ddx/distd*32
			ddy = -ddy/distd*32

			ddx = ddx+bdx/distb*32
			ddy = ddy+bdy/distb*32
			
			XSpeed:+ ddx*Delta
			YSpeed:+ ddy*Delta
			Local Speed:Float = Sqr(XSpeed*XSpeed+YSpeed*YSpeed)
			If Speed > MaxSpeed*1.25
				XSpeed = XSpeed/Speed*MaxSpeed*1.25
				YSpeed = YSpeed/Speed*MaxSpeed*1.25
			EndIf
			Evading=MilliSecs()
		EndIf
	End Method
	
	Method Update()
		Local distx:Float,InvaderDistance:Float,disty:Float,Speed:Float
		Local BumpX:Float=0, BumpY:Float=0
		
		'Check against Colosions
		Collision()
		
		'Check Against Near Misses
		NearMissCheck(2.95)
		
		BlurSteps:+1*Delta
		
		Select AI
		
		Case FOLLOWER
		
			If BlurSteps>62/BlurDivider
				MotionBlur.Spawn(X,Y,Direction,4,InvaderGlow[SpriteNumber])
				BlurSteps=0
			End If
			
			'Add wavieness to the motion of
			Wavy:+1*Delta
			If Cos(Wavy)=Cos(0) Then Wavy=0
			
			Homing=False
			
			If PlayerDistance(X,Y)<260
				XSpeed=XSpeed+(Player.X-X)/(PlayerDistance(X,Y)+0.02)/2
				YSpeed=YSpeed+(Player.Y-Y)/(PlayerDistance(X,Y)+0.02)/2
				Homing=True
			End If
			'Avoid Other invaders
			For Local Invader:TInvader = EachIn List
				If Invader <> Self
					distx = Invader.X-X
					disty = Invader.Y-Y
					InvaderDistance = (distx * distx + disty * disty)
					If InvaderDistance < 18*18  + 18*18
						BumpX:- Sgn(distx)
						BumpY:- Sgn(disty)
					EndIf
				EndIf
			Next		
			
			'Bounce around the corners
			If x < 8 
				XSpeed = Abs(XSpeed)
				X:+ XSpeed*Delta
				Direction:+ 90
			ElseIf x > FieldWidth-8
				XSpeed = -Abs(XSpeed)
				X:+ XSpeed*Delta
				Direction:+ 90
			EndIf
			If y < 8
				YSpeed = Abs(Yspeed)
				Y:+ YSpeed*Delta
				Direction:+ 90
			ElseIf y > FieldHeight-8
				YSpeed = -Abs(YSpeed)
				Y:+ YSpeed*Delta
				Direction:+ 90
			EndIf

			Speed = Sqr(XSpeed*XSpeed+YSpeed*YSpeed)
			If Speed >  MaxSpeed
				XSpeed=XSpeed/Speed*MaxSpeed
				YSpeed=YSpeed/Speed*MaxSpeed
			EndIf

			X:+ (XSpeed+BumpX)*Delta
			Y:+ (YSpeed+BumpY)*Delta
			
			'Direction = ATan2(YSpeed,XSpeed)+90
			

			'InterPolateDir=Direction
			'Direction=ATan2(YSpeed,XSpeed)+90
			'If Direction<0 Direction:+360
			'Direction=TweenSmooth(Direction,ATan2(YSpeed,XSpeed)+90,0.2*Delta)
			'Direction = Tween(Direction,InterpolateDir,0.05*Delta)'9*Delta)
			
			'Crude Direction Interpolation
			InterpolateDir = (Direction+ATan2(YSpeed,XSpeed)+90)/2	
			Direction = RotateSmooth(Direction,InterpolateDir,7*Delta)
		Case EVADER
			
			If BlurSteps>62/BlurDivider
				MotionBlur.Spawn(X,Y,Direction,4,InvaderGlow[SpriteNumber])
				BlurSteps=0
			End If
			'Add wavieness to the motion of
			Wavy:+1*Delta
			If Cos(Wavy)=Cos(0) Then Wavy=0
			
			Homing=False
			
			OldSpeedX=XSpeed
			OldSpeedY=YSpeed
			
			If PlayerDistance(X,Y)<320 And Evading=False
				XSpeed=XSpeed+(Player.X-X)/(PlayerDistance(X,Y)+0.02)/2
				YSpeed=YSpeed+(Player.Y-Y)/(PlayerDistance(X,Y)+0.02)/2
				Homing=True
			End If
		
			
			For Local Invader:TInvader = EachIn List
				If Invader <> Self
					distx = Invader.X-X
					disty = Invader.Y-Y
					InvaderDistance = (distx * distx + disty * disty)
					If InvaderDistance < 18*18  + 18*18
						BumpX:- Sgn(distx)
						BumpY:- Sgn(disty)
					EndIf
				EndIf
			Next		

			'Cool down to evade again is shorter than cooldown to chase again
			'If MilliSecs()-Evading>125
			
			'distx = Shot.X-X
					'disty = Shot.Y-Y
					'InvaderDistance = (distx * distx + disty * disty)
					'If InvaderDistance < 64*64  + 64*64 
					'	XSpeed:- Sgn(distx)*1.5
					'	YSpeed:- Sgn(disty)*1.5
					'Evading=MilliSecs()+575
					'EndIfed)
				'Next	
			'End If		

			If Evading=0 Or MilliSecs()-Evading>165
				For Local Shot:TShot = EachIn TShot.List
					DodgeShot(Shot.X,Shot.Y,Shot.X+Shot.XSpeed*6,Shot.Y+Shot.YSpeed*6)
				Next	
			End If
			
			If Evading<>0
				'Print "evading"
				If MilliSecs()-Evading>275 Then Evading=0'; Print "evade end"
			End If
			'Bounce around the corners
			If x < 8 
				XSpeed = Abs(XSpeed)
				X:+ XSpeed*Delta
				Direction:+ 90
			ElseIf x > FieldWidth-8
				XSpeed = -Abs(XSpeed)
				X:+ XSpeed*Delta
				Direction:+ 90
			EndIf
			If y < 8
				YSpeed = Abs(Yspeed)
				Y:+ YSpeed*Delta
				Direction:+ 90
			ElseIf y > FieldHeight-8
				YSpeed = -Abs(YSpeed)
				Y:+ YSpeed*Delta
				Direction:+ 90
			EndIf
				
			Speed = Sqr(XSpeed*XSpeed+YSpeed*YSpeed)
			If Speed > MaxSpeed And Evading=False
				XSpeed=XSpeed/Speed*MaxSpeed
				YSpeed=YSpeed/Speed*MaxSpeed
			ElseIf Speed > MaxSpeed*1.25 And Evading
				XSpeed = XSpeed/Speed*MaxSpeed*1.25
				YSpeed = YSpeed/Speed*MaxSpeed*1.25
			EndIf
	
				
			X:+ (XSpeed+BumpX)*Delta
			Y:+ (YSpeed+BumpY)*Delta
			
			'Crude Direction Interpolation (This way seems a bit better than the other)
			'If Evading=False
			

			'InterPolateDir=Direction
			'Direction=ATan2(YSpeed,XSpeed)+90
			'If Direction<0 Direction:+360
			'Direction=TweenSmooth(Direction,ATan2(YSpeed,XSpeed)+90,0.2*Delta)
			'Direction = Tween(Direction,InterpolateDir,0.05*Delta)'9*Delta)
			
			
			'Crude Direction Interpolation

			InterpolateDir = (Direction+ATan2(YSpeed,XSpeed)+90)/2	
			Direction = RotateSmooth(Direction,InterpolateDir,8*Delta)
			
			'Print "Direction: "+Direction
			
			'If Direction>360 Direction=Direction Mod 360
		Case PANICER
			
			If BlurSteps>60/BlurDivider
				MotionBlur.Spawn(X,Y,Direction,4,InvaderGlow[SpriteNumber])
				BlurSteps=0
			End If
			'Add wavieness to the motion of
			Wavy:+1*Delta
			If Cos(Wavy)=Cos(0) Then Wavy=0
			
			If AllPanic<>0 
			
				If Distance(X,Y,DeathX,DeathY)<=165 Panic=MilliSecs()+1680
				If MilliSecs()-AllPanic>0 AllPanic=0
			
			End If
			
			If MilliSecs()-Panic>0 And PlayerDistance(X,Y)>450 Panic=False
			
			Local PredictX:Float
			Local PredictY:Float
			
			PredictX:+Player.XSpeed*6+Player.X
			PredictY:+Player.YSpeed*6+Player.Y
			
			If Panic=False And Evading=False
				XSpeed=XSpeed+(PredictX-X)/(Distance(X,Y,PredictX,PredictY)+0.2)/2
				YSpeed=YSpeed+(PredictY-Y)/(Distance(X,Y,PredictX,PredictY)+0.2)/2
				Homing=True
			ElseIf Evading=False
				XSpeed=XSpeed+(X-PredictX)/(Distance(X,Y,PredictX,PredictY)+0.01)/2
				YSpeed=YSpeed+(Y-PredictY)/(Distance(X,Y,PredictX,PredictY)+0.01)/2
				Homing=False
			End If
				
			For Local Invader:TInvader = EachIn List
				If Invader <> Self
					distx = Invader.X-X
					disty = Invader.Y-Y
					InvaderDistance = (distx * distx + disty * disty)
					If InvaderDistance < 18*18  + 18*18
						BumpX:- Sgn(distx)
						BumpY:- Sgn(disty)
					EndIf
				EndIf
			Next		
			Rem
			If Not Evading
				For Local Shot:TShot = EachIn TShot.List
					distx = Shot.X-X
					disty = Shot.Y-Y
					InvaderDistance = (distx * distx + disty * disty)
					If InvaderDistance < 64*64  + 64*64 
						XSpeed:- Sgn(distx)
						YSpeed:- Sgn(disty)
						Evading=MilliSecs()+575
						EvadeTween=.15
					EndIf
				Next			
			End If
			End Rem
			'If MilliSecs()-Evading>125
			
			If Evading=0 Or MilliSecs()-Evading>185
				For Local Shot:TShot = EachIn TShot.List
					DodgeShot(Shot.X,Shot.Y,Shot.X+Shot.XSpeed*6,Shot.Y+Shot.YSpeed*6)
				Next	
			End If
			
			If Evading<>0
				'Print "evading"
				If MilliSecs()-Evading>350 Then Evading=0'; Print "evade end"
			End If

			'Bounce around the corners
			If x < 8 
				XSpeed = Abs(XSpeed)
				X:+ XSpeed*Delta
				Direction:+ 90
				Panic=False
			ElseIf x > FieldWidth-8
				XSpeed = -Abs(XSpeed)
				X:+ XSpeed*Delta
				Direction:+ 90
				Panic=False
			EndIf
			If y < 8
				YSpeed = Abs(Yspeed)
				Y:+ YSpeed*Delta
				Direction:+ 90
				Panic=False
			ElseIf y > FieldHeight-8
				YSpeed = -Abs(YSpeed)
				Y:+ YSpeed*Delta
				Direction:+ 90
				Panic=False
			EndIf
			
			Speed = Sqr(XSpeed*XSpeed+YSpeed*YSpeed)
			If Panic
				If Speed >  MaxSpeed*1.25
					XSpeed=XSpeed/Speed*MaxSpeed*1.25
					YSpeed=YSpeed/Speed*MaxSpeed*1.25
				EndIf		
			Else
				If Speed >  MaxSpeed
					XSpeed=XSpeed/Speed*MaxSpeed
					YSpeed=YSpeed/Speed*MaxSpeed
				EndIf		
			End If
			X:+ (XSpeed+BumpX)*Delta
			Y:+ (YSpeed+BumpY)*Delta
			
			'Direction = ATan2(YSpeed,XSpeed)+90
			

			'InterPolateDir=Direction
			'Direction=ATan2(YSpeed,XSpeed)+90
			'If Direction<0 Direction:+360
			'Direction=TweenSmooth(Direction,ATan2(YSpeed,XSpeed)+90,0.2*Delta)
			'Direction = Tween(Direction,InterpolateDir,0.05*Delta)'9*Delta)
			
			'Crude Direction Interpolation
			InterpolateDir = (Direction+ATan2(YSpeed,XSpeed)+90)/2	
			Direction = RotateSmooth(Direction,InterpolateDir,8.3*Delta)
		Case WEAVER
			
			If BlurSteps>51/BlurDivider
				MotionBlur.Spawn(X,Y,Direction,4,InvaderGlow[SpriteNumber])
				BlurSteps=0
			End If
			'If EvadeTween<1 EvadeTween:+0.005*Delta
			'Add wavieness to the motion of
			'Wavy:+1*Delta
			'If Cos(Wavy)=Cos(0) Then Wavy=0
			
			Homing=False
			
			If PlayerDistance(X,Y)<570
				XSpeed=XSpeed+(Player.X-X)/(PlayerDistance(X,Y)+0.02)/2
				YSpeed=YSpeed+(Player.Y-Y)/(PlayerDistance(X,Y)+0.02)/2
				Homing=True		
				If PlayerDistance(X,Y)<130 
					TargetStretch=True
				ElseIf PlayerDistance(X,Y)>140 
					TargetStretch=False
				End If
			End If
			
			For Local Invader:TInvader = EachIn List
				If Invader <> Self
					distx = Invader.X-X
					disty = Invader.Y-Y
					InvaderDistance = (distx * distx + disty * disty)
					If InvaderDistance < 18*18  + 18*18
						BumpX:- Sgn(distx)
						BumpY:- Sgn(disty)
					EndIf
				EndIf
			Next		
			
			Rem
			If Not Evading
				For Local Shot:TShot = EachIn TShot.List
					distx = Shot.X-X
					disty = Shot.Y-Y
					InvaderDistance = (distx * distx + disty * disty)
					If InvaderDistance < 96*96 + 96*96 
						'XSpeed:- Sgn(distx)
						'YSpeed:- Sgn(disty)
						If Abs(Shot.Direction-(Direction+180))>45
							XSpeed:-Sin(Direction+90)*1.8
							YSpeed:-Cos(Direction+90)*1.8
							Evading=MilliSecs()+375
						End If
						 ' Print "It will hit me!"
						
					EndIf
				Next			
			End If
			End Rem
			
			

			If Homing 'And TargetStretch=False
				x=x + (Sin(Radius*(1.1))*.6)*Delta
				y=y + (Cos(Radius*(1.1))*.6)*Delta
			End If

			Rem

			If MilliSecs()-Evading>125
				For Local Shot:TShot = EachIn TShot.List
					DodgeShot(Shot.X,Shot.Y,Shot.X+Shot.XSpeed,Shot.Y+Shot.YSpeed)
				Next	
			End If	
			
			
			If Evading And MilliSecs()-Evading>125 Then Evading=0
			End Rem
			'Bounce around the corners
			If x < 8 
				XSpeed = Abs(XSpeed)
				X:+ XSpeed*Delta
				Direction:+ 90
			ElseIf x > FieldWidth-8
				XSpeed = -Abs(XSpeed)
				X:+ XSpeed*Delta
				Direction:+ 90
			EndIf
			If y < 8
				YSpeed = Abs(Yspeed)
				Y:+ YSpeed*Delta
				Direction:+ 90
			ElseIf y > FieldHeight-8
				YSpeed = -Abs(YSpeed)
				Y:+ YSpeed*Delta
				Direction:+ 90
			EndIf
			
			GetUnstuck()
			
			If TargetStretch
				Speed = Sqr(XSpeed*XSpeed+YSpeed*YSpeed)
				If Speed >  MaxSpeed*.55
					XSpeed=XSpeed/Speed*MaxSpeed*.55
					YSpeed=YSpeed/Speed*MaxSpeed*.55
				EndIf	
			Else
				Speed = Sqr(XSpeed*XSpeed+YSpeed*YSpeed)
				If Speed >  MaxSpeed*.925
					XSpeed=XSpeed/Speed*MaxSpeed
					YSpeed=YSpeed/Speed*MaxSpeed
				EndIf	
			End If
			Radius:+.7*Delta
			

			'InterPolateDir=Direction
			'Direction=ATan2(YSpeed,XSpeed)+90
			'If Direction<0 Direction:+360
			'Direction=TweenSmooth(Direction,ATan2(YSpeed,XSpeed)+90,0.2*Delta)
			'Direction = Tween(Direction,InterpolateDir,0.05*Delta)'9*Delta)
			
			'Crude Direction Interpolation
			InterpolateDir = (Direction+ATan2(YSpeed,XSpeed)+90)/2	
			Direction = RotateSmooth(Direction,InterpolateDir,9*Delta)
			
			X:+ (XSpeed+BumpX)*Delta
			Y:+ (YSpeed+BumpY)*Delta
		
		
		End Select
		
		
		
	EndMethod


	Function DrawAllGlow()
		If Not List Return 
		
		SetScale 4.5,4.5
		
		For Local Invader:TInvader = EachIn List
			Invader.DrawGlow()
		Next
		
	EndFunction
	
	Function DrawAll()
		If Not List Return 
		
		SetScale 4,4
		
		
		For Local Invader:TInvader = EachIn List
			Invader.DrawBody()
		Next
		
		SetBlend LIGHTBLEND
		SetScale 5,5
		
		For Local Invader:TInvader = EachIn List
			Invader.DrawGlow()
		Next
		
		SetBlend ALPHABLEND
		
	EndFunction
	
	Function UpdateAll()
		If Not List Return 
		
		For Local Invader:TInvader = EachIn List
			Invader.Update()
		Next
	EndFunction

	Method Destroy()
		List.Remove( Self )
	EndMethod
	
	Method DestroyAll()
		If Not List Return 
		
		For Local Invader:TInvader = EachIn List
			Invader.Destroy()
		Next
	EndMethod
	
	Function GenerateInvader:TPixmap(Index:Int) Private
		'The amount of White Pixels
		Local PixelCount:Int=0	
		'Stores the Invaders Pixels
		Local InvaderPixels:Int[6,6]
		'Stores the Invaders Colors
		Local InvaderColor[3]
		
		'-----------------MATH GEN ROUTINE---------------------------
		
		'As long as there are less than 3 or more than 14 White pixels, redo Invader
		Repeat
			PixelCount=0
			For Local i=0 To 2
				For Local j=0 To 4
						
					'A Pixel can be either 0 (Black) or 1 (White)
					InvaderPixels[i,j]=Rand(0,1)
						
					'Count the number of White Pixels
					PixelCount:+InvaderPixels[i,j]
						
				Next
				
				'Set the invaders color
				InvaderColor[i]=Rand(65,195)
				'InvaderColor[i]=Rand(60,130)
				
			Next
				
			'If condition is met, X mirror Invader
			If PixelCount>=6 And Rand(0,100)=42 
				
				For Local n=0 To 4
					InvaderPixels[n,4]=InvaderPixels[n,0]
					InvaderPixels[n,3]=InvaderPixels[n,1]
				Next
				
			End If
		Until PixelCount>=6 And PixelCount<=16 
		
		RGB_to_HSL(InvaderColor[0],InvaderColor[1],InvaderColor[2])
		
		If Result_L<=.36
			'Print "Dark"
			Result_L:+.197
			Result_S:+.025
		End If
		
		HSL_to_RGB(Result_H,Result_S,Result_L)
		
		InvaderColor[0]=Result_R
		InvaderColor[1]=Result_G
		InvaderColor[2]=Result_B
		
		
		If EasterEgg
			InvaderColor[1]=InvaderColor[0]
			InvaderColor[2]=InvaderColor[0]
		End If
		
		'Mirror invader along the Y axis
		For Local m=0 To 4
			InvaderPixels[4,m]=InvaderPixels[0,m]
			InvaderPixels[3,m]=InvaderPixels[1,m]
		Next
		
		'-----------------DRAWING ROUTINE-----------------

		Local InvaderPixmap:TPixmap=CreatePixmap(9,9,PF_RGBA8888)
		Local GlowPixmap:TPixmap
		
		ClearPixels (InvaderPixmap)
		
		'Loop through the invader's pixel array 
		For Local x=0 To 4
			For Local y=0 To 4
				
				'Proceed to draw the invader
				If InvaderPixels[x,y]=1
					
					WritePixel InvaderPixmap,2+x,2+y,ToRGBA(InvaderColor[0],InvaderColor[1],InvaderColor[2],255)
				
				End If
			
			Next
		Next
		
		For Local i=0 To 2
		
			InvaderRGB[index,i]=InvaderColor[i]
		Next
		
		GlowPixmap=CopyPixmap(InvaderPixmap)
		
		InvaderBody[index]=LoadImage(InvaderPixmap,MASKEDIMAGE)
				
		GlowPixmap=GaussianBlur(GlowPixmap,2,220,35,255)
		
		InvaderGlow[index]=LoadImage(GlowPixmap,FILTEREDIMAGE)
		
		InvaderPixmap=Null;GlowPixmap=Null
		
	End Function
	
	Function PrepareFrame(image:TImage) Private
		'Use this to cache an image or animimage in VRAM for quicker drawing later.
		image.Frame(0)
		MidHandleImage Image
	End Function
	
	Function ToRGBA%(r%,g%,b%,a%) Private
		'return (a << 24) | (r << 16) | (g << 8) | (b);
	Return ((A Shl 24) | (R Shl 16) | (G Shl 8) | B)
	
	End Function
	
	Method GetUnstuck()
		If X<8 Then X=9
		If X>FieldWidth-8 Then X=FieldWidth-9
		If Y<8 Then Y=9
		If Y>FieldWidth-9 Then Y=FieldWidth-9
	End Method
	
	Method Collision()
		Local ShotDirection:Float
		
		If Player.Alive And PlayerDistance(X,Y)<ComfortZone
			CloseEncounters:+.095*Delta
		End If
		
		If PlayerDistance(X,Y)<42 And Player.Alive Then
			If Player.HasShield-Player.MaskShield>0
				Glow.MassFire(X,Y,1,2,15,AwayFrom(X,Y,Player.X,Player.Y),InvaderRGB[SpriteNumber,0],InvaderRGB[SpriteNumber,1],InvaderRGB[SpriteNumber,2])
				ParticleManager.Create(X,Y,25,InvaderRGB[SpriteNumber,0],InvaderRGB[SpriteNumber,1],InvaderRGB[SpriteNumber,2],AwayFrom(X,Y,Player.X,Player.Y),1.2)
				Flash.Fire(X,Y,0.3,25)
				Destroy()
				'EnemyCount:-1
				EnemiesKilled:+1
				Player.HasShield:-1
				Trk_Shd:-1
				PlaySoundBetter Sound_Player_Shield_Die,X,Y
			Else
				If PlayerDistance(X,Y)<30
					Player.Destroy()
					DeathBy=Name[AI]
				End If
			End If
		End If
		
		If TPlayerBomb.List
			For Local PlayerBomb:TPlayerBomb = EachIn TPlayerBomb.List
				
				If Distance(X,Y,PlayerBomb.X,PlayerBomb.Y) < PlayerBomb.Radius
					
					Glow.MassFire(X,Y,1,2,7,AwayFrom(X,Y,PlayerBomb.X,PlayerBomb.Y),InvaderRGB[SpriteNumber,0],InvaderRGB[SpriteNumber,1],InvaderRGB[SpriteNumber,2])
					ParticleManager.Create(X,Y,15,InvaderRGB[SpriteNumber,0],InvaderRGB[SpriteNumber,1],InvaderRGB[SpriteNumber,2],AwayFrom(X,Y,PlayerBomb.X,PlayerBomb.Y),1.2)
					Flash.Fire(X,Y,0.3,25)
					'Explosion.Fire(X,Y,.55)
					Destroy()
					'EnemyCount:-1
					EnemiesKilled:+1
				
				End If
				
			Next
		End If
		
		
		'If a shot hit a rock
		If Not TShot.List Return
		For Local Shot:TShot = EachIn TShot.List
			If Distance( X, Y, Shot.X, Shot.Y ) < 18
				
				
				Local TempScore:Int, SniperShot=False
				
				PlaySoundBetter Sound_Explosion,X,Y
				
				If PlayerDistance(X,Y)<36
					If Abs(Player.XSpeed)>0.25 Or Abs (Player.YSpeed)>0.25
						Score:+45*Multiplier
						ScoreRegister.Fire(Player.x,Player.y-35,75*Multiplier,"CLOSE ENCOUNTER!",4)
						Frenzy:+2
						Trk_FrnzGn:+4
					End If
				End If
				
				If Rand(ExtraLikeliness,68)=42 Then Powerup.Spawn(x,y,Rand(0,9))
				
		
				TempScore=EvenScore(50*(AI/2)*Multiplier*ScoreMultiplier)
				
				Glow.MassFire(X,Y,1,2,25,Shot.Direction-90,InvaderRGB[SpriteNumber,0],InvaderRGB[SpriteNumber,1],InvaderRGB[SpriteNumber,2])
				ParticleManager.Create(X,Y,30,InvaderRGB[SpriteNumber,0],InvaderRGB[SpriteNumber,1],InvaderRGB[SpriteNumber,2])
			
				Shot.EnemyDestroy()
				Flash.Fire(X,Y,.6,13)
				'Debris.MassFire (X,Y,1,1,11,1)
				Explosion.Fire(X,Y,.55)
		
				'Did the player shoot - or the AI?
				If Shot.Shooter=1 Then
					'Sniper Shot
					If Player.LastShotFired-Player.PrevShotFired>575 Then
						'Print "time req. met! "+(Player.LastShotFired-Player.PrevShotFired)
						If Distance( X, Y, Player.X, Player.Y) >305 Then
							'Print "almost"
							If IsVisible(x,y,15) 
								'Print "Sniper!"+Distance( X, Y, Player.X, Player.Y )
								ScoreRegister.Fire(x,y,TempScore,"2x")
								Tempscore:*2
								SniperShot=True
								Score:+Tempscore
							End If
						End If
					End If
					
					'No Sniper Shot? But still a Player shot?
					If Not SniperShot And Shot.Shooter=1  Then
						If FrenzyMode
							Score:+TempScore*2
							ScoreRegister.Fire(x,y,TempScore,"2x")
						Else
							Score:+TempScore
							ScoreRegister.Fire(x,y,TempScore)
						End If	
					End If
					
					'General Kill Stuff
					EnemiesKilled:+1
					If TempScore>LargestScore Then LargestScore=TempScore
				End If
				
				DeathX=X
				DeathY=Y
				AllPanic=MilliSecs()+150
				'Destroy the rock, at last
				Destroy()
				'EnemyCount:-1
				Exit
			EndIf
		Next	
	EndMethod

	Method NearMissCheck(Size:Float)
		'Check for "Near Misses"
		If Distance( X, Y, Player.X, Player.Y) < Size*16 Then
			If Abs(Player.XSpeed)>0.35 Or Abs (Player.YSpeed)>0.35 Then
				NearMissCount:+1
				NearMissTime=MilliSecs()
				If NearMissID="" NearMissID=MissID
			End If
		Else
			'If there was a near miss more than 250 msec ago... and the player is still alive - heh.
			If NearMissTime<>0 And MilliSecs()-NearMissTime>245 And Player.Alive And NearMissCount=1 Then
				'Print "Near Miss!"
				NearMissTime=0
				NearMissCount=0
				NearMissID=""
				If Player.BounceTime=0 Then
					Score:+EvenScore(75*Multiplier*ScoreMultiplier)
					ScoreRegister.Fire(Player.x,Player.y,EvenScore(75*Multiplier*ScoreMultiplier),"NEAR MISS!",4)
					Frenzy:+1
					Trk_FrnzGn:+2
				Else
					Score:+EvenScore(115*Multiplier*ScoreMultiplier)
					ScoreRegister.Fire(Player.x,Player.y,EvenScore(115*Multiplier*ScoreMultiplier),"REBOUND EVADE!",4)
					Frenzy:+2
					Trk_FrnzGn:+4
					Player.BounceTime=0
				End If
			ElseIf NearMissTime<>0 And MilliSecs()-NearMissTime>235 And Player.Alive And NearMissCount>=2 Then
				If Not NearMissID=MissID
					NearMissTime=0
					NearMissCount=0
					NearMissID=""
					Score:+EvenScore(105*Multiplier*ScoreMultiplier)
					ScoreRegister.Fire(Player.x,Player.y,EvenScore(105*Multiplier*ScoreMultiplier),"DOUBLE NEAR MISS!",4)
					Frenzy:+2
					Trk_FrnzGn:+4
				Else
					NearMissTime=0
					NearMissCount=0
					NearMissID=""
					If Player.BounceTime=0 Then
						Score:+EvenScore(75*Multiplier*ScoreMultiplier)
						ScoreRegister.Fire(Player.x,Player.y,EvenScore(75*Multiplier*ScoreMultiplier),"NEAR MISS!",4)
						Frenzy:+1
						Trk_FrnzGn:+2
					Else
						Score:+EvenScore(115*Multiplier*ScoreMultiplier)
						ScoreRegister.Fire(Player.x,Player.y,EvenScore(115*Multiplier*ScoreMultiplier),"REBOUND EVADE!",4)
						Frenzy:+2
						Trk_FrnzGn:+4
						Player.BounceTime=0
					End If
				End If
			End If
		End If
	EndMethod

End Type

'-----------------------------------------------------------------------------
'Spinner a basic but annoying Enemy
'-----------------------------------------------------------------------------
Type TSpinner Extends TObject  
	Const ErraticSpeed:Float=.68
	
	Global List:TList
	Global Variations:Int
	Global SpinnerBody:TImage[]
	Global SpinnerGlow:TImage[]
	Global SpinnerRGB:Int[,]
	
	Field SpriteNumber:Int
	Field MaxSpeed:Float
	Field BlurSteps:Float
	'Field Killer:Byte
	
	Field MissID:String
	Field NearMisstime:Int
	
	Field ComputeSize:Int
	
	Function Generate(NumSpinners:Int)
		
		List=Null
		
		List = CreateList()
		
		Variations=NumSpinners
		
		SpinnerGlow = New TImage[Variations+1]
		SpinnerBody = New TImage[Variations+1]
		SpinnerRGB = New Int[Variations+1,3]
		
		For Local i=1 To NumSpinners
			
			'Generate and Draw
			GenerateSpinner(i)
			
			PrepareFrame(SpinnerBody[i])
			PrepareFrame(SpinnerGlow[i])
			
		Next
		
	End Function
	
	Function ReCache()
		For Local i=1 To Variations
			PrepareFrame(SpinnerBody[i])
			PrepareFrame(SpinnerGlow[i])
		Next
	End Function
	
	Function Spawn(X:Int,Y:Int,FastSpinner:Int=False)
	
		If Player.Alive
			If CountList(List) => 35 Then Return Null	
		Else
			If CountList(List) => 25 Then Return Null	
		End If
		
		If PlayerDistance(X,Y)<85 Return Null
		
		'EnemyCount:+1
		
		Local Spinner:TSpinner = New TSpinner	 
		List.AddLast Spinner
			
		Spinner.SpriteNumber=Rand(1,Variations)
		
		Spinner.MissID=String(Spinner.SpriteNumber)+"-"+String(Rand(-12000,92000))
		
		Spinner.X=X
		Spinner.Y=Y
			
		SpawnEffect.Fire(Spinner.X,Spinner.Y,.75,SpinnerRGB[Spinner.SpriteNumber,0]	,SpinnerRGB[Spinner.SpriteNumber,1],SpinnerRGB[Spinner.SpriteNumber,2])	
		
		Spinner.Direction=Rand(1,360)
		If Not FastSpinner
			Spinner.MaxSpeed=.51+SpeedGain
			PlaySoundBetter Sound_Spinner_Born,X,Y
		Else
			Spinner.MaxSpeed=ErraticSpeed+SpeedGain*.9
			PlaySoundBetter Sound_ErraticSpinner_Born,X,Y
		End If
		Spinner.XSpeed:+ Cos(Spinner.Direction)/2
		Spinner.YSpeed:+ Sin(Spinner.Direction)/2
		
		'If Not ChannelPlaying(BornChannel) PlaySound SoundBorn,BornChannel
		
		Spinner.ComputeSize = 40'SpinnerBody[Spinner.SpriteNumber].Width*2
		
	End Function
	
	Function Preview(X,Y,SpriteNum)
		
		SetBlend alphablend
		SetScale 4,4
		
		DrawImage SpinnerBody[SpriteNum],x,y
		
		SetScale 6,6
		SetBlend lightblend
		DrawImage SpinnerGlow[SpriteNum],x,y
		
		SetBlend alphablend
		SetScale 1,1
	End Function
	
	Method DrawBody()
		
		
		SetRotation(Direction)
		DrawImage SpinnerBody[SpriteNumber],x,y

	EndMethod
	
	Method DrawGlow()
		
		SetRotation(Direction)
		DrawImage SpinnerGlow[SpriteNumber],x,y

	EndMethod
	
	
	Method Update()
		Local distx:Float,Distance:Float,disty:Float, Speed:Float
		
		'Check against Colosions
		Collision()
		
		'Check for Near Misses
		NearMissCheck(2.9)
		
		'Avoid Other Spinners
		For Local Spinner:TSpinner = EachIn List
			If Spinner <> Self
				distx# = Spinner.X-X
				disty# = Spinner.Y-Y
				Distance = (distx * distx + disty * disty)
				If Distance < 16*16  + 16*16
					'Dampen the bounce against other Spinners
					XSpeed:- Sgn(distx)/3
					YSpeed:- Sgn(disty)/3
				EndIf
			EndIf
		Next
		
		'If we are a fast and erratic spinner add some Randomness
		If MaxSpeed=ErraticSpeed+SpeedGain
			
			'0.3% chance of odd behavior
			If Rand(0,300)<1
			
				Direction:+Rand(-35,35)
				XSpeed=Cos(Direction)
				YSpeed=Sin(Direction)
			End If
		
		End If
		

		'Bounce around the corners
		If x < 8
			XSpeed = Abs(XSpeed)
			X:+ XSpeed*Delta
			Direction:+ 90
		ElseIf x > FieldWidth-8
			XSpeed = -Abs(XSpeed)
			X:+ XSpeed*Delta
			Direction:+ 90
		EndIf
		If y < 8
			YSpeed = Abs(Yspeed)
			Y:+ YSpeed*Delta
			Direction:+ 90
		ElseIf y > FieldHeight-8
			YSpeed = -Abs(YSpeed)
			Y:+ YSpeed*Delta
			Direction:+ 90
		EndIf
		
		GetUnstuck()
		
		'Limit Spinner Speed
		Speed = Sqr(XSpeed*XSpeed+YSpeed*YSpeed)
		If Speed > MaxSpeed
			XSpeed=XSpeed/Speed*MaxSpeed
			YSpeed=YSpeed/Speed*MaxSpeed
		ElseIf Speed<0.15
			Direction:+Rand(0,359)
			XSpeed=Cos(Direction)
			YSpeed=Sin(Direction)
		EndIf		
		X:+ XSpeed*Delta
		Y:+ YSpeed*Delta
			
		'Keep Spinning
		If MaxSpeed=ErraticSpeed+SpeedGain
			Direction:-1.45*Delta
		Else
			Direction:+1*Delta
		End If		
		
		BlurSteps:+1*Delta
			
		If MaxSpeed=ErraticSpeed+SpeedGain And BlurSteps>56/BlurDivider
			MotionBlur.Spawn(X-XSpeed,Y-YSpeed,Direction,4,SpinnerGlow[SpriteNumber])
			'CorruptionEffect.Spawn(X-XSpeed,Y-YSpeed,Direction,4)
			BlurSteps=0
		ElseIf BlurSteps>62/BlurDivider
			MotionBlur.Spawn(X-XSpeed,Y-YSpeed,Direction,4,SpinnerGlow[SpriteNumber])
			'CorruptionEffect.Spawn(X-XSpeed,Y-YSpeed,Direction,4)
			BlurSteps=0
		End If
		
	EndMethod

	Function DrawAllGlow()
		If Not List Return 
		
		SetScale 4.5,4.5
		
		For Local Spinner:TSpinner = EachIn List
			Spinner.DrawGlow()
		Next
		
	EndFunction
	
	Function DrawAll()
		If Not List Return 
	
		SetScale 4,4
		
		For Local Spinner:TSpinner = EachIn List
			Spinner.DrawBody()
		Next

		SetBlend LIGHTBLEND
		SetScale 5,5
		
		For Local Spinner:TSpinner = EachIn List
			Spinner.DrawGlow()
		Next

		SetBlend ALPHABLEND
		
	EndFunction
	
	Function UpdateAll()
		If Not List Return 
		
		For Local Spinner:TSpinner = EachIn List
			Spinner.Update()
		Next
	EndFunction

	Method Destroy()
		List.Remove( Self )
	EndMethod
	
	Method DestroyAll()
		If Not List Return 
		
		For Local Spinner:TSpinner = EachIn List
			Spinner.Destroy()
		Next
	EndMethod
	
	Function GenerateSpinner:TPixmap(Index:Int) Private
		'The amount of White Pixels
		Local PixelCount:Int=0	
		'Stores the Spinners Pixels
		Local SpinnerPixels:Int[6,6]
		'Stores the Spinners Colors
		Local SpinnerColor[3]
		
		'-----------------MATH GEN ROUTINE-----------------
		
		'As long as there are less than 3 or more than 14 White pixels, redo Spinner
		Repeat
			PixelCount=0
			For Local i=0 To 2
				For Local j=0 To 4
						
					'A Pixel can be either 0 (Black) or 1 (White)
					SpinnerPixels[i,j]=Rand(0,1)
						
					'Count the number of White Pixels
					PixelCount:+SpinnerPixels[i,j]
						
				Next
				
				'Set the Spinners color
				'SpinnerColor[i]=Rand(225,7)
				'SpinnerColor[i]=Rand(55,165)
				SpinnerColor[i]=Rand(50,165)
				
			Next	

		Until PixelCount>8 And PixelCount<15 
		
		'GenerateColor(SpinnerColor,50,165,1,1)
		RGB_to_HSL(SpinnerColor[0],SpinnerColor[1],SpinnerColor[2])
		
		If Result_L<=.29
			'Print "Dark"
			Result_L:+.145
			Result_S:+.05
		End If
		
		HSL_to_RGB(Result_H,Result_S,Result_L)
		
		SpinnerColor[0]=Result_R
		SpinnerColor[1]=Result_G
		SpinnerColor[2]=Result_B
		
		If EasterEgg
			SpinnerColor[1]=SpinnerColor[0]
			SpinnerColor[2]=SpinnerColor[0]
		End If
		
		If SpinnerPixels[0,0]=0 Or SpinnerPixels[0,4]=0
			SpinnerPixels[0,0]=0
			SpinnerPixels[0,4]=0
		End If
		
		If PixelCount>10
			SpinnerPixels[0,0]=0
			SpinnerPixels[0,4]=0
		End If
		
		'X mirror Spinner
		If PixelCount<=10
			For Local n=0 To 4
				SpinnerPixels[n,4]=SpinnerPixels[n,0]
				SpinnerPixels[n,3]=SpinnerPixels[n,1]
			Next
		End If
		'Mirror Spinner along the Y axis
		For Local m=0 To 4
			SpinnerPixels[4,m]=SpinnerPixels[0,m]
			SpinnerPixels[3,m]=SpinnerPixels[1,m]
		Next
		
		If SpinnerPixels[1,0]=0 And SpinnerPixels[0,1]=0 And SpinnerPixels[0,3]=0 And SpinnerPixels[1,4]=0 And SpinnerPixels[1,1]=0 And SpinnerPixels[1,3]=0 Then
			'Print "nullor"
			SpinnerPixels[0,0]=0
			SpinnerPixels[0,4]=0
			SpinnerPixels[4,4]=0
			SpinnerPixels[4,0]=0
		End If
		
		PixelCount=0
		For Local x=0 To 4
			For Local y=0 To 4
				PixelCount:+SpinnerPixels[x,y]
			Next
		Next

		If PixelCount<=8
			SpinnerPixels[0,0]=1
			SpinnerPixels[0,1]=0
			SpinnerPixels[0,2]=1
			SpinnerPixels[0,3]=0
			SpinnerPixels[0,4]=1
			SpinnerPixels[4,4]=0
			SpinnerPixels[4,3]=1
			SpinnerPixels[4,2]=0
			SpinnerPixels[4,1]=1
			SpinnerPixels[4,0]=0
		End If
		'-----------------DRAWING ROUTINE-----------------

		Local SpinnerPixmap:TPixmap=CreatePixmap(9,9,PF_RGBA8888)
		Local GlowPixmap:TPixmap
		
		ClearPixels (SpinnerPixmap)
		
		'Loop through the Spinner's pixel array 
		For Local x=0 To 4
			For Local y=0 To 4
				
				'Proceed to draw the Spinner
				If SpinnerPixels[x,y]=1
					
					WritePixel SpinnerPixmap,2+x,2+y,ToRGBA(SpinnerColor[0],SpinnerColor[1],SpinnerColor[2],255)
				
				End If
			
			Next
		Next
		
		If SpinnerPixels[2,2]
			WritePixel SpinnerPixmap,2+2,2+2,ToRGBA(165,165,165,255)
			WritePixel SpinnerPixmap,2+2,2+3,ToRGBA(137,137,137,255)
			WritePixel SpinnerPixmap,2+2,2+1,ToRGBA(137,137,137,255)
			WritePixel SpinnerPixmap,2+1,2+2,ToRGBA(137,137,137,255)
			WritePixel SpinnerPixmap,2+3,2+2,ToRGBA(137,137,137,255)
		Else
			WritePixel SpinnerPixmap,2+2,2+3,ToRGBA(155,155,155,255)
			WritePixel SpinnerPixmap,2+2,2+1,ToRGBA(155,155,155,255)
			WritePixel SpinnerPixmap,2+1,2+2,ToRGBA(155,155,155,255)
			WritePixel SpinnerPixmap,2+3,2+2,ToRGBA(155,155,155,255)
		End If
		
		For Local i=0 To 2
			SpinnerRGB[index,i]=SpinnerColor[i]
		Next
		
		GlowPixmap=CopyPixmap(SpinnerPixmap)
		
		SpinnerBody[index]=LoadImage(SpinnerPixmap,MASKEDIMAGE)
				
		GlowPixmap=GaussianBlur(GlowPixmap,2,220,35,245)
		
		SpinnerGlow[index]=LoadImage(GlowPixmap,FILTEREDIMAGE)
		
		SpinnerPixmap=Null;GlowPixmap=Null
		
	End Function
	
	Function PrepareFrame(image:TImage) Private
		'Use this to cache an image or animimage in VRAM for quicker drawing later.
		image.Frame(0)
		MidHandleImage Image
	End Function
	
	Function ToRGBA%(r%,g%,b%,a%) Private
		'return (a << 24) | (r << 16) | (g << 8) | (b);
	Return ((A Shl 24) | (R Shl 16) | (G Shl 8) | B)	
	End Function
	
	Method GetUnstuck()
		If X<8 Then X=8
		If X>FieldWidth-8 Then X=FieldWidth-8
		If Y<8 Then Y=8
		If Y>FieldWidth-8 Then Y=FieldWidth-8
	End Method
	
	Method Collision()
		Local ShotDirection:Float
		
		If Player.Alive And PlayerDistance(X,Y)<ComfortZone
			CloseEncounters:+.05*Delta
		End If
		
		If Player. Alive And PlayerDistance(X,Y)<42 Then
			If Player.HasShield-Player.MaskShield>0
				Glow.MassFire(X,Y,1,2,15,AwayFrom(X,Y,Player.X,Player.Y),SpinnerRGB[SpriteNumber,0],SpinnerRGB[SpriteNumber,1],SpinnerRGB[SpriteNumber,2])
				ParticleManager.Create(X,Y,15,SpinnerRGB[SpriteNumber,0],SpinnerRGB[SpriteNumber,1],SpinnerRGB[SpriteNumber,2],AwayFrom(X,Y,Player.X,Player.Y),1.2)
				Flash.Fire(X,Y,0.3,25)
				Destroy()
				'EnemyCount:-1
				EnemiesKilled:+1
				Player.HasShield:-1
				Trk_Shd:-1
				PlaySoundBetter Sound_Player_Shield_Die,X,Y
			Else
				If PlayerDistance(X,Y)<30
					Player.Destroy()
					'Killer=True
					If MaxSpeed<ErraticSpeed+SpeedGain
						DeathBy="Spinner"
					Else
						DeathBy="Erratic Spinner"
					End If
				End If
			End If
		End If
		
		If TPlayerBomb.List
			For Local PlayerBomb:TPlayerBomb = EachIn TPlayerBomb.List
				
				If Distance(X,Y,PlayerBomb.X,PlayerBomb.Y) < PlayerBomb.Radius
					
					Glow.MassFire(X,Y,1,2,5,AwayFrom(X,Y,PlayerBomb.X,PlayerBomb.Y),SpinnerRGB[SpriteNumber,0],SpinnerRGB[SpriteNumber,1],SpinnerRGB[SpriteNumber,2])
					ParticleManager.Create(X,Y,13,SpinnerRGB[SpriteNumber,0],SpinnerRGB[SpriteNumber,1],SpinnerRGB[SpriteNumber,2],AwayFrom(X,Y,PlayerBomb.X,PlayerBomb.Y),1.2)
					Flash.Fire(X,Y,0.3,25)
					'Explosion.Fire(X,Y,.55)
					Destroy()
					'EnemyCount:-1
					EnemiesKilled:+1
				
				End If
				
			Next
		End If
		
		'If a shot hit a rock
		If Not TShot.List Return
		For Local Shot:TShot = EachIn TShot.List
			If Distance( X, Y, Shot.X, Shot.Y ) < 18
				
				Local TempScore:Int, SniperShot=False
				
				'PlaySound SoundHit , ExplodeChannel
				PlaySoundBetter Sound_Explosion,X,Y
				
				If PlayerDistance(X,Y)<36
					If Abs(Player.XSpeed)>0.25 Or Abs (Player.YSpeed)>0.25
						Score:+45*Multiplier
						ScoreRegister.Fire(Player.x,Player.y-35,75*Multiplier,"CLOSE ENCOUNTER!",4)
						Frenzy:+2
						Trk_FrnzGn:+4
					End If
				End If
				
				If Rand(ExtraLikeliness,86)=42 Then Powerup.Spawn(x,y,Rand(0,9))
				If MaxSpeed<ErraticSpeed+SpeedGain
					TempScore=EvenScore(30*Multiplier*ScoreMultiplier)
				Else
					TempScore=EvenScore(45*Multiplier*ScoreMultiplier)
				End If
				Glow.MassFire(X,Y,1,2,20,Shot.Direction-90,SpinnerRGB[SpriteNumber,0],SpinnerRGB[SpriteNumber,1],SpinnerRGB[SpriteNumber,2])
				ParticleManager.Create(X,Y,25,SpinnerRGB[SpriteNumber,0],SpinnerRGB[SpriteNumber,1],SpinnerRGB[SpriteNumber,2])
				'Glow.MassFire(X,Y,1,2,25,Shot.Direction-90,SpinnerRGB[SpriteNumber,0],SpinnerRGB[SpriteNumber,1],SpinnerRGB[SpriteNumber,2])
				
				Shot.EnemyDestroy()
				Flash.Fire(X,Y,.5,12)
				'Debris.MassFire (X,Y,1,1,11,1)
				Explosion.Fire(X,Y,.5)
		
				'Did the player shoot - or the AI?
				If Shot.Shooter=1 Then
					'Sniper Shot
					If Player.LastShotFired-Player.PrevShotFired>575 Then
						'Print "time req. met! "+(Player.LastShotFired-Player.PrevShotFired)
						If Distance( X, Y, Player.X, Player.Y) >305 Then
							'Print "almost"
							If IsVisible(x,y,15) 
								'Print "Sniper!"+Distance( X, Y, Player.X, Player.Y )
								ScoreRegister.Fire(x,y,TempScore,"2x")
								Tempscore:*2
								SniperShot=True
								Score:+Tempscore
							End If
						End If
					End If
					
					'No Sniper Shot? But still a Player shot?
					If Not SniperShot And Shot.Shooter=1  Then
						If FrenzyMode
							Score:+TempScore*2
							ScoreRegister.Fire(x,y,TempScore,"2x")
						Else
							Score:+TempScore
							ScoreRegister.Fire(x,y,TempScore)
						End If	
					End If
					
					'General Kill Stuff
					EnemiesKilled:+1
					If TempScore>LargestScore Then LargestScore=TempScore
				End If
				
				'Destroy the Spinner, at last
				Destroy()
				'EnemyCount:-1
				Exit
				
			EndIf
		Next	
	EndMethod
	
	Method NearMissCheck(Size:Float)
		'Check for "Near Misses"
		If Distance( X, Y, Player.X, Player.Y) < Size*16 Then
			If Abs(Player.XSpeed)>0.35 Or Abs (Player.YSpeed)>0.35 Then
				NearMissCount:+1
				NearMissTime=MilliSecs()
				If NearMissID="" NearMissID=MissID
			End If
		Else
			'If there was a near miss more than 250 msec ago... and the player is still alive - heh.
			If NearMissTime<>0 And MilliSecs()-NearMissTime>245 And Player.Alive And NearMissCount=1 Then
				'Print "Near Miss!"
				NearMissTime=0
				NearMissCount=0
				NearMissID=""
				If Player.BounceTime=0 Then
					Score:+EvenScore(75*Multiplier*ScoreMultiplier)
					ScoreRegister.Fire(Player.x,Player.y,EvenScore(75*Multiplier*ScoreMultiplier),"NEAR MISS!",4)
					Frenzy:+1
					Trk_FrnzGn:+2
				Else
					Score:+EvenScore(115*Multiplier*ScoreMultiplier)
					ScoreRegister.Fire(Player.x,Player.y,EvenScore(115*Multiplier*ScoreMultiplier),"REBOUND EVADE!",4)
					Player.BounceTime=0
					Frenzy:+2
					Trk_FrnzGn:+4
				End If
			ElseIf NearMissTime<>0 And MilliSecs()-NearMissTime>235 And Player.Alive And NearMissCount>=2 Then
				If NearMissID<>MissID
					NearMissTime=0
					NearMissCount=0
					Score:+EvenScore(105*Multiplier*ScoreMultiplier)
					ScoreRegister.Fire(Player.x,Player.y,EvenScore(105*Multiplier*ScoreMultiplier),"DOUBLE NEAR MISS!",4)
					Frenzy:+2
					Trk_FrnzGn:+4
					NearMissID=""
				Else
					NearMissTime=0
					NearMissCount=0
					NearMissID=""
					If Player.BounceTime=0 Then
						Score:+EvenScore(75*Multiplier*ScoreMultiplier)
						ScoreRegister.Fire(Player.x,Player.y,EvenScore(75*Multiplier*ScoreMultiplier),"NEAR MISS!",4)
						Frenzy:+1
						Trk_FrnzGn:+2
					Else
						Score:+EvenScore(115*Multiplier*ScoreMultiplier)
						ScoreRegister.Fire(Player.x,Player.y,EvenScore(115*Multiplier*ScoreMultiplier),"REBOUND EVADE!",4)
						Player.BounceTime=0
						Frenzy:+2
						Trk_FrnzGn:+4
					End If
				End If
			End If
		End If
	EndMethod
	
End Type

'-----------------------------------------------------------------------------
'Asteroid passive tumbling space rocks
'-----------------------------------------------------------------------------
Type TAsteroid Extends TObject  
	
	Const LARGE=1
	Const MEDIUM=2
	Const SMALL=3
	
	Global List:TList
	Global Variations:Int
	Global AsteroidBody:TImage[]
	Global AsteroidGlow:TImage[]

	Global SmallAsteroidBody:TImage[]
	Global SmallAsteroidGlow:TImage[]
	
	Global AsteroidRGB:Int[,]
	
	Field SpriteNumber:Int
	Field MaxSpeed:Float
	Field BlurSteps:Float
	Field Mass:Float
	Field Kind:Int
	Field SpawnTime:Int
	
	
	Field MissID:String
	Field NearMissTime:Int
	Field CoolDown:Float
	Field Radius:Float
	
	Function Generate(NumAsteroids:Int)
	
		List=Null
		
		List = CreateList()
	
		Variations=NumAsteroids
		
		AsteroidGlow = New TImage[Variations+1]
		AsteroidBody = New TImage[Variations+1]
		
		SmallAsteroidGlow = New TImage[Variations+1]
		SmallAsteroidBody = New TImage[Variations+1]
		
		AsteroidRGB = New Int[Variations+1,3]
		
		For Local i=1 To NumAsteroids
			
			'Generate and Draw
			GenerateAsteroid(i)
			
			PrepareFrame(AsteroidBody[i])
			PrepareFrame(AsteroidGlow[i])
			
			GenerateSmallAsteroid(i)
			
			PrepareFrame(SmallAsteroidBody[i])
			PrepareFrame(SmallAsteroidGlow[i])
			
		Next
		
	End Function
	
	Function ReCache()
		For Local i=1 To Variations
			PrepareFrame(SmallAsteroidBody[i])
			PrepareFrame(SmallAsteroidGlow[i])
			PrepareFrame(AsteroidBody[i])
			PrepareFrame(AsteroidGlow[i])
		Next
	End Function
	
	Function Spawn(X:Int,Y:Int,SmallAsteroid:Byte=False)
	
		'If Not List List = CreateList()
		
		If SmallAsteroid=False
			If Rand(0,5)<4 Return Null
		End If
		
		If Player.Alive And SmallAsteroid=False
			If CountList(List) => 15 Then Return Null	
		ElseIf Player.Alive=False And SmallAsteroid=False
			If CountList(List) => 5 Then Return Null	
		End If
		
		If PlayerDistance(X,Y)<97 Return Null
		'EnemyCount:+1
		
		Local Asteroid:TAsteroid = New TAsteroid	 
		List.AddLast Asteroid
			
		Asteroid.SpriteNumber=Rand(1,Variations)
		
		Asteroid.MissID=String(Asteroid.SpriteNumber)+"."+String(Rand(-32000,92000))
		
		Asteroid.X=X
		Asteroid.Y=Y
			
		Asteroid.Direction=Rand(1,360)
		
		If Not SmallAsteroid
			Asteroid.Mass=Rnd(1,1.9)
			Asteroid.MaxSpeed=.75+SpeedGain/3-(Asteroid.Mass/5)
			Asteroid.Kind=LARGE
			Asteroid.Radius=34
			PlaySoundBetter Sound_DataFragment_Born,X,Y
			SpawnEffect.Fire(Asteroid.X,Asteroid.Y,.75,AsteroidRGB[Asteroid.SpriteNumber,0]	,AsteroidRGB[Asteroid.SpriteNumber,1],AsteroidRGB[Asteroid.SpriteNumber,2])	
		ElseIf SmallAsteroid
			Asteroid.Mass=Rnd(.2,.9)
			Asteroid.MaxSpeed=.93+SpeedGain/3-(Asteroid.Mass/4)
			Asteroid.Kind=SMALL
			Asteroid.SpawnTime=MilliSecs()
			Asteroid.Radius=19.5
		End If
		
		Asteroid.XSpeed:+ Cos(Asteroid.Direction)/4
		Asteroid.YSpeed:+ Sin(Asteroid.Direction)/4
		
	End Function
	
	Function Preview(X,Y,SpriteNum)
		
		SetBlend alphablend
		SetScale 3.5,3.5
		
		DrawImage AsteroidBody[SpriteNum],x,y
		
		SetScale 4.5,4.5
		SetBlend lightblend
		DrawImage AsteroidGlow[SpriteNum],x,y
		
		SetBlend alphablend
		SetScale 1,1
	End Function
	
	Method DrawBody()
		
		If Kind=LARGE
			SetRotation(Direction)
			DrawImage AsteroidBody[SpriteNumber],x,y
		Else
			SetRotation(Direction)
			DrawImage SmallAsteroidBody[SpriteNumber],x,y
		End If
		
	EndMethod
	
	Method DrawGlow()
		
		If Kind=LARGE
			SetRotation(Direction)
			DrawImage AsteroidGlow[SpriteNumber],x,y
		Else
			SetRotation(Direction)
			DrawImage SmallAsteroidGlow[SpriteNumber],x,y
		End If
		
	EndMethod
	
	Method CollisionPhysics(Radius)
		
		If TAsteroid.List=Null Return	
		'Inititialise all other Asteroids (E.g. X&Y representing the current Asteroid Asteroid.X representing the others being checked against)
		For Local Asteroid:TAsteroid = EachIn TAsteroid.List
			
			'Don't check for collisions against "yourself".
			If Asteroid=Self Continue
			
			'Dont check freshly spawned asteroids, give them some time to settle
			If MilliSecs()-Asteroid.SpawnTime<350 Continue
			
			Local collisionDistance# = Radius
			Local actualDistance# = Sqr((Asteroid.X-X)^2+(Asteroid.Y-Y)^2)
			' collided or not?
			If actualDistance<collisionDistance Then
				
				Local collNormalAngle#=ATan2(Asteroid.Y-Y, Asteroid.X-X)
				' position exactly touching, no intersection
				Local moveDist1#=(collisionDistance-actualDistance)*(Asteroid.Mass/Float((Mass+Asteroid.Mass)))
				Local moveDist2#=(collisionDistance-actualDistance)*(Mass/Float((Mass+Asteroid.Mass)))
				X=X + moveDist1*Cos(collNormalAngle+180)
				Y=Y + moveDist1*Sin(collNormalAngle+180)
				
				Asteroid.X=Asteroid.X + moveDist2*Cos(collNormalAngle)
				Asteroid.Y=Asteroid.Y + moveDist2*Sin(collNormalAngle)
				' COLLISION RESPONSE
				' n = vector connecting the centers of the balls.
				' we are finding the components of the normalised vector n
				Local nX#=Cos(collNormalAngle)
				Local nY#=Sin(collNormalAngle)
				' now find the length of the components of each movement vectors
				' along n, by using dot product.
				Local a1# = XSpeed*nX  +  YSpeed*nY
				Local a2# = Asteroid.XSpeed*nX +  Asteroid.YSpeed*nY
				' optimisedP = 2(a1 - a2)
				'             ----------
				'              m1 + m2
				Local optimisedP# = (2.0 * (a1-a2)) / (Mass + Asteroid.Mass)
				' now find out the resultant vectors
				'' Local r1% = c1.v - optimisedP * mass2 * n
				XSpeed = XSpeed - (optimisedP*Asteroid.Mass*nX)
				YSpeed = YSpeed - (optimisedP*Asteroid.Mass*nY)
				'' Local r2% = c2.v - optimisedP * mass1 * n
				Asteroid.XSpeed = Asteroid.XSpeed + (optimisedP*Mass*nX)
				Asteroid.YSpeed = Asteroid.YSpeed + (optimisedP*Mass*nY)
				
				If CoolDown<=0 Flash.Fire(X,Y,0.3,25)
				If CoolDown<=0 ParticleManager.Create(X,Y,12,100,100,100,0,.7)
				If CoolDown<=0 CoolDown:+50

			End If
		Next
		
	End Method

	
	Method Update()
		Local distx:Float,Distance:Float,disty:Float, Speed:Float
		
		'Check against Colosions
		Collision()
		
		'Cooldown to prevent rapid firing of effects
		If CoolDown>0 CoolDown:-1.1*Delta
		
		'Avoid Other Asteroids
		If Kind=Small
			CollisionPhysics(24)
			NearMissCheck(3.3)
		Else
			CollisionPhysics(38)
			NearMissCheck(4)
		End If
		'Warp around the corners
		If x < -16 
			x=FieldWidth+16
		ElseIf x > FieldWidth+16
			x=-16
		EndIf
		If y < -16
			y=FieldHeight+16
		ElseIf y > FieldHeight+16
			y=-16
		EndIf
		
		'Limit Asteroid Speed
		Speed = Sqr(XSpeed*XSpeed+YSpeed*YSpeed)
		If Speed > MaxSpeed
			XSpeed=XSpeed/Speed*MaxSpeed
			YSpeed=YSpeed/Speed*MaxSpeed
		ElseIf Speed<0.15
			Direction:+Rand(0,359)
			XSpeed=Cos(Direction)
			YSpeed=Sin(Direction)
		EndIf		
		X:+ XSpeed*Delta
		Y:+ YSpeed*Delta
			
		'Keep Spinning
		Direction:+0.45*Delta		
		
		BlurSteps:+1*Delta
		
		If BlurSteps>62/BlurDivider
			If Kind=SMALL
				MotionBlur.Spawn(X-XSpeed,Y-YSpeed,Direction,4,SmallAsteroidGlow[SpriteNumber])
				BlurSteps=0
			Else
				If BlurSteps>82/BlurDivider
					MotionBlur.Spawn(X-XSpeed,Y-YSpeed,Direction,4,AsteroidGlow[SpriteNumber])
					BlurSteps=0
				End If
			End If
			
		End If
		
	EndMethod

	Function DrawAllGlow()
		If Not List Return 
		
		SetScale 4.5,4.5
		
		For Local Asteroid:TAsteroid = EachIn List
			Asteroid.DrawGlow()
		Next
		
	EndFunction
	
	Function DrawAll()
		If Not List Return 
		If List.Count()=0 Return
		SetScale 4,4
		SetAlpha 1
		For Local Asteroid:TAsteroid = EachIn List
			Asteroid.DrawBody()
		Next
		
		SetBlend LIGHTBLEND
		SetScale 5,5
		
		For Local Asteroid:TAsteroid = EachIn List
			Asteroid.DrawGlow()
		Next
		
		SetBlend ALPHABLEND
		
	EndFunction
	
	Function UpdateAll()
		If Not List Return 
		
		For Local Asteroid:TAsteroid = EachIn List
			Asteroid.Update()
		Next
	EndFunction

	Method Destroy()
		List.Remove( Self )
	EndMethod
	
	Method DestroyAll()
		If Not List Return 
		
		For Local Asteroid:TAsteroid = EachIn List
			Asteroid.Destroy()
		Next
	EndMethod
	
	Function GenerateAsteroid:TPixmap(Index:Int) Private
		'The amount of White Pixels
		Local PixelCount:Int=0	
		'Stores the Asteroids Pixels
		Local AsteroidPixels:Int[10,10]
		'Stores the Asteroids Colors
		Local AsteroidColor[5]
		'Neighboring Pixels
		Local Neighbors:Int
		
		'-----------------MATH GEN ROUTINE-----------------
		
		'As long as there are less than 3 or more than 14 White pixels, redo Asteroid
		Repeat
			PixelCount=0
			For Local i=2 To 6
				For Local j=2 To 6
						
					'A Pixel can be either 0 (Black) or 1 (White)
					AsteroidPixels[i,j]=Rand(0,1)
						
					'Count the number of White Pixels
					PixelCount:+AsteroidPixels[i,j]
						
				Next
				
				'Set the Asteroids color
				'AsteroidColor[i]=Rand(225,7)
				'AsteroidColor[i]=Rand(55,165)
				AsteroidColor[i-2]=Rand(90,105)
				
			Next	

		Until PixelCount>=15 And PixelCount<60
		
		'Grow Asteroid (Like Silicate)
		For Local x=0 To 8
			For Local y=0 To 8
			
			If AsteroidPixels[x,y]=1
				'Neighbors=0
				If x+1<8 And Rand(0,PixelCount)<10 AsteroidPixels[x+1,y]=1 
				If x-1>0 And Rand(0,PixelCount)<10 AsteroidPixels[x-1,y]=1
				If y-1>0 And Rand(0,PixelCount)<10 AsteroidPixels[x,y-1]=1
				If y+1<8 And Rand(0,PixelCount)<10 AsteroidPixels[x,y+1]=1
				
			EndIf
			
			Next
		Next
		
		'Erode Asteroids
		For Local x=0 To 8
			For Local y=0 To 8
			
				If y=0 AsteroidPixels[x,y]=Rand(0,1)
				If y=8 AsteroidPixels[x,y]=Rand(0,1)
				If x=0 AsteroidPixels[x,y]=Rand(0,1)
				If x=8 AsteroidPixels[x,y]=Rand(0,1)
			
			Next
		Next
		'Remove Loose Pixels
		For Local x=0 To 8
			For Local y=0 To 8
			
			If AsteroidPixels[x,y]=1
				Neighbors=0
				If x+1<8 If AsteroidPixels[x+1,y]=>1 Then Neighbors:+1
				If x-1>0 If AsteroidPixels[x-1,y]=>1 Then Neighbors:+1
				If y-1>0 If AsteroidPixels[x,y-1]=>1 Then Neighbors:+1
				If y+1<8 If AsteroidPixels[x,y+1]=>1 Then Neighbors:+1
				
				If Neighbors<1
					AsteroidPixels[x,y]=0
				End If
			EndIf
			
			Next
		Next
		
		If EasterEgg
			AsteroidColor[0]=AsteroidColor[1]
			AsteroidColor[2]=AsteroidColor[1]
		End If
		
		'-----------------DRAWING ROUTINE-----------------

		Local AsteroidPixmap:TPixmap=CreatePixmap(12,12,PF_RGBA8888)
		Local GlowPixmap:TPixmap
		
		ClearPixels (AsteroidPixmap)
		
		'Loop through the Asteroid's pixel array 
		For Local x=0 To 8
			For Local y=0 To 8
				
				'Proceed to draw the Asteroid
				If AsteroidPixels[x,y]>0
					
					WritePixel AsteroidPixmap,2+x,2+y,ToRGBA(AsteroidColor[0],AsteroidColor[1],AsteroidColor[2],255)
				
				End If
			
			Next
		Next
		
		For Local i=0 To 2
			AsteroidRGB[index,i]=AsteroidColor[i]
		Next
		
		GlowPixmap=CopyPixmap(AsteroidPixmap)
		
		AsteroidBody[index]=LoadImage(AsteroidPixmap,MASKEDIMAGE)
				
		GlowPixmap=GaussianBlur(GlowPixmap,2,220,35,245)
		
		AsteroidGlow[index]=LoadImage(GlowPixmap,FILTEREDIMAGE)
		
		AsteroidPixmap=Null;GlowPixmap=Null
		
	End Function
	
	Function GenerateSmallAsteroid:TPixmap(Index:Int) Private
		'The amount of White Pixels
		Local PixelCount:Int=0	
		'Stores the SmallAsteroids Pixels
		Local SmallAsteroidPixels:Int[6,6]
		'Neighboring Pixels
		Local Neighbors:Int
		'Random Seeder
		Local Iterations:Int
		
		'-----------------MATH GEN ROUTINE-----------------
		
		'As long as there are less than 3 or more than 14 White pixels, redo SmallAsteroid
		Repeat
			PixelCount=0
			For Local i=1 To 4
				For Local j=1 To 4
						
					'A Pixel can be either 0 (Black) or 1 (White)
					SmallAsteroidPixels[i,j]=Rand(0,1)
						
					'Count the number of White Pixels
					PixelCount:+SmallAsteroidPixels[i,j]
						
				Next
				
			Next	

		Until PixelCount>=3 And PixelCount<13
		
		'Grow SmallAsteroid (Like Silicate)
		For Local x=0 To 5
			For Local y=0 To 5
			
			If SmallAsteroidPixels[x,y]=1
				'Neighbors=0
				If x+1<5 And Rand(0,PixelCount)<2 SmallAsteroidPixels[x+1,y]=1 
				If x-1>0 And Rand(0,PixelCount)<2 SmallAsteroidPixels[x-1,y]=1
				If y-1>0 And Rand(0,PixelCount)<2 SmallAsteroidPixels[x,y-1]=1
				If y+1<5 And Rand(0,PixelCount)<2 SmallAsteroidPixels[x,y+1]=1
				
			EndIf
			
			Next
		Next
		
		'Erode SmallAsteroid
		For Local x=0 To 5
			For Local y=0 To 5
			
				If y=0 SmallAsteroidPixels[x,y]=Rand(0,1)
				If y=5 SmallAsteroidPixels[x,y]=Rand(0,1)
				If x=0 SmallAsteroidPixels[x,y]=Rand(0,1)
				If x=5 SmallAsteroidPixels[x,y]=Rand(0,1)
			
			Next
		Next
		'Remove Loose Pixels
		For Local x=0 To 5
			For Local y=0 To 5
			
			If SmallAsteroidPixels[x,y]=1
				Neighbors=0
				Iterations:+1
				If x+1<5 If SmallAsteroidPixels[x+1,y]=>1 Then Neighbors:+1
				If x-1>0 If SmallAsteroidPixels[x-1,y]=>1 Then Neighbors:+1
				If y-1>0 If SmallAsteroidPixels[x,y-1]=>1 Then Neighbors:+1
				If y+1<5 If SmallAsteroidPixels[x,y+1]=>1 Then Neighbors:+1
				
				If Neighbors<1
					SmallAsteroidPixels[x,y]=0
					Iterations:-5
				End If
			EndIf
			
			Next
		Next
		
		'-----------------DRAWING ROUTINE-----------------

		Local SmallAsteroidPixmap:TPixmap=CreatePixmap(9,9,PF_RGBA8888)
		Local GlowPixmap:TPixmap
		'Print Iterations
		ClearPixels (SmallAsteroidPixmap)
		
		'Loop through the SmallAsteroid's pixel array 
		For Local x=0 To 5
			For Local y=0 To 5
				
				'Proceed to draw the SmallAsteroid
				If SmallAsteroidPixels[x,y]>0
					
					WritePixel SmallAsteroidPixmap,2+x,2+y,ToRGBA(120-Iterations*1.5,120-Iterations*1.5,120-Iterations*1.5,255)

				End If
			
			Next
		Next
		
		GlowPixmap=CopyPixmap(SmallAsteroidPixmap)
		
		SmallAsteroidBody[index]=LoadImage(SmallAsteroidPixmap,MASKEDIMAGE)
				
		GlowPixmap=GaussianBlur(GlowPixmap,2,220,35,245)
		
		SmallAsteroidGlow[index]=LoadImage(GlowPixmap,FILTEREDIMAGE)
		
		SmallAsteroidPixmap=Null;GlowPixmap=Null
		
	End Function

	Function PrepareFrame(image:TImage) Private
		'Use this to cache an image or animimage in VRAM for quicker drawing later.
		image.Frame(0)
		MidHandleImage Image
	End Function
	
	Function ToRGBA%(r%,g%,b%,a%) Private
		'return (a << 24) | (r << 16) | (g << 8) | (b);
	Return ((A Shl 24) | (R Shl 16) | (G Shl 8) | B)
	
	End Function
	
	Method Collision()
		Local ShotDirection:Float
		Local XPos:Int
		Local YPos:Int
		
		If Player.Alive And PlayerDistance(X,Y)<ComfortZone
			CloseEncounters:+.075*Delta
		End If
		
		If TPlayerBomb.List
			For Local PlayerBomb:TPlayerBomb = EachIn TPlayerBomb.List
				
				If Distance(X,Y,PlayerBomb.X,PlayerBomb.Y) < PlayerBomb.Radius
					
					Glow.MassFire(X,Y,1,2,20,AwayFrom(X,Y,PlayerBomb.X,PlayerBomb.Y),AsteroidRGB[SpriteNumber,0],AsteroidRGB[SpriteNumber,1],AsteroidRGB[SpriteNumber,2])
					'ParticleManager.Create(X,Y,15,AsteroidRGB[SpriteNumber,0],AsteroidRGB[SpriteNumber,1],AsteroidRGB[SpriteNumber,2],AwayFrom(X,Y,PlayerBomb.X,PlayerBomb.Y),1.2)
					Flash.Fire(X,Y,0.3,25)
					'Explosion.Fire(X,Y,.55)
					Destroy()
					'EnemyCount:-1
					EnemiesKilled:+1
					
				End If
				
			Next
		End If

		
		If Kind=SMALL
			If PlayerDistance(X,Y)<38 And Player.Alive Then
				If Player.HasShield-Player.MaskShield>0
					Glow.MassFire(X,Y,1,2,15,AwayFrom(X,Y,Player.X,Player.Y),100,100,100)
					ParticleManager.Create(X,Y,15,100,100,100,AwayFrom(X,Y,Player.X,Player.Y),1.2)
					Flash.Fire(X,Y,0.3,25)
					Destroy()
					'EnemyCount:-1
					EnemiesKilled:+1
					Player.HasShield:-1
					Trk_Shd:-1
					PlaySoundBetter Sound_Player_Shield_Die,X,Y
				Else
					If PlayerDistance(X,Y)<28
						Player.Destroy()
	
						DeathBy="Small Data Fragment"
	
					End If
				End If
			End If
		Else
			If PlayerDistance(X,Y)<50 And Player.Alive Then
				If Player.HasShield-Player.MaskShield>0
					Glow.MassFire(X,Y,1,2,35,AwayFrom(X,Y,Player.X,Player.Y),100,100,100)
					ParticleManager.Create(X,Y,15,100,100,100,AwayFrom(X,Y,Player.X,Player.Y),1.2)
					Flash.Fire(X,Y,0.65,35)
					Destroy()
					'EnemyCount:-1
					EnemiesKilled:+1
					Player.HasShield:-1
					Trk_Shd:-1
					PlaySoundBetter Sound_Player_Shield_Die,X,Y
				Else
					If PlayerDistance(X,Y)<40
						Player.Destroy()
	
						DeathBy="Data Fragment"
	
					End If
				End If
			End If
		End If

		If Not TShot.List Return
				
		For Local Shot:TShot = EachIn TShot.List
			If Distance( X, Y, Shot.X, Shot.Y ) < Radius
				
				Local TempScore:Int, SniperShot=False
				
				If Kind=LARGE
					
					Destroy()
					'EnemyCount:-1
					
					XPos=Rand(-18,18)
					Ypos=Rand(-18,18)
					Asteroid.Spawn(X+Xpos,Y+YPos,True)
					Asteroid.Spawn(X+(Xpos*-1),Y+(Ypos*-1),True)
					If Rand(0,100)<19 Asteroid.Spawn(X+(Xpos/2),Y+(Ypos/2),True)
					
					PlaySoundBetter Sound_Shatter,X,Y
					
					If X>32 And X<FieldWidth-32 And Y>32 And Y<FieldHeight-32
						If Rand(ExtraLikeliness,82)=42 Then Powerup.Spawn(x,y,Rand(0,9))
					End If
					TempScore=EvenScore(45*Multiplier*ScoreMultiplier)
		
					Glow.MassFire(X,Y,2,2,47,0,AsteroidRGB[SpriteNumber,0],AsteroidRGB[SpriteNumber,1],AsteroidRGB[SpriteNumber,2],True,True)
					ShockWave.Fire(X,Y,.5,3)
					
					Shot.EnemyDestroy()
					Flash.Fire(X,Y,.65,25)
					Explosion.Fire(X,Y,.82)
					Explosion.Fire(X+Rand(-4,4),Y+Rand(-4,4),.5,True)
			
					'Did the Asteroid shoot - or the AI?
					If Shot.Shooter=1 Then
						'Sniper Shot
						If Player.LastShotFired-Player.PrevShotFired>575 Then
							'Print "time req. met! "+(Asteroid.LastShotFired-Asteroid.PrevShotFired)
							If Distance( X, Y, Player.X, Player.Y) >305 Then
								'Print "almost"
								If IsVisible(x,y,15) 
									'Print "Sniper!"+Distance( X, Y, Asteroid.X, Asteroid.Y )
									ScoreRegister.Fire(x,y,TempScore,"2x")
									Tempscore:*2
									SniperShot=True
									Score:+Tempscore
								End If
							End If
						End If
						
						'No Sniper Shot? But still a Asteroid shot?
						If Not SniperShot And Shot.Shooter=1  Then
							If FrenzyMode
								Score:+TempScore*2
								ScoreRegister.Fire(x,y,TempScore,"2x")
							Else
								Score:+TempScore
								ScoreRegister.Fire(x,y,TempScore)
							End If	
						End If
						
						'General Kill Stuff
						EnemiesKilled:+1
						If TempScore>LargestScore Then LargestScore=TempScore
						Exit
					End If
					Continue
				Else
					If MilliSecs()-Asteroid.SpawnTime<70 And Player.HasSuper=False Return
					PlaySoundBetter Sound_Explosion,X,Y
					'If Rand(4+ExtraLikeliness,74)=42 Then Powerup.Spawn(x,y,Rand(0,9))
					TempScore=EvenScore(75*Multiplier*ScoreMultiplier)
	
					Glow.MassFire(X,Y,1,2,27,0,AsteroidRGB[SpriteNumber,0],AsteroidRGB[SpriteNumber,1],AsteroidRGB[SpriteNumber,2],True,True)
					
					If PlayerDistance(X,Y)<36
						If Abs(Player.XSpeed)>0.25 Or Abs (Player.YSpeed)>0.25
							Score:+45*Multiplier
							ScoreRegister.Fire(Player.x,Player.y-35,75*Multiplier,"CLOSE ENCOUNTER!",4)
							Frenzy:+2
							Trk_FrnzGn:+4
						End If
					End If
					
					If X>32 And X<FieldWidth-32 And Y>32 And Y<FieldHeight-32
						If Rand(ExtraLikeliness,74)=42 Then Powerup.Spawn(x,y,Rand(0,9))
					End If
					
					
					Shot.EnemyDestroy()
					Flash.Fire(X,Y,.5,15)
					Explosion.Fire(X,Y,.55,True)
					Destroy()
					'EnemyCount:-1
					
					If Shot.Shooter=1 Then
						'Sniper Shot
						If Player.LastShotFired-Player.PrevShotFired>575 Then
							'Print "time req. met! "+(Asteroid.LastShotFired-Asteroid.PrevShotFired)
							If Distance( X, Y, Player.X, Player.Y) >305 Then
								'Print "almost"
								If IsVisible(x,y,15) 
									'Print "Sniper!"+Distance( X, Y, Asteroid.X, Asteroid.Y )
									ScoreRegister.Fire(x,y,TempScore,"2x")
									Tempscore:*2
									SniperShot=True
									Score:+Tempscore
								End If
							End If
						End If
						
						'No Sniper Shot? But still a Asteroid shot?
						If Not SniperShot And Shot.Shooter=1  Then
							If FrenzyMode
								Score:+TempScore*2
								ScoreRegister.Fire(x,y,TempScore,"2x")
							Else
								Score:+TempScore
								ScoreRegister.Fire(x,y,TempScore)
							End If	
						End If
						
						'General Kill Stuff
						EnemiesKilled:+1
						If TempScore>LargestScore Then LargestScore=TempScore
						Exit
					End If
					Continue
				End If
			EndIf
		Next	
	EndMethod
	
	Method NearMissCheck(Size:Float)
		'Check for "Near Misses"
		If Distance( X, Y, Player.X, Player.Y) < Size*16 Then
			If Abs(Player.XSpeed)>0.35 Or Abs (Player.YSpeed)>0.35 Then
				NearMissCount:+1
				NearMissTime=MilliSecs()
				If NearMissID="" NearMissID=MissID
			End If
		Else
			'If there was a near miss more than 250 msec ago... and the player is still alive - heh.
			If NearMissTime<>0 And MilliSecs()-NearMissTime>245 And Player.Alive And NearMissCount=1 Then
				'Print "Near Miss!"
				NearMissTime=0
				NearMissCount=0
				NearMissID=""
				If Player.BounceTime=0 Then
					Score:+EvenScore(75*Multiplier*ScoreMultiplier)
					ScoreRegister.Fire(Player.x,Player.y,EvenScore(75*Multiplier*ScoreMultiplier),"NEAR MISS!",4)
					Frenzy:+1
					Trk_FrnzGn:+2
				Else
					Score:+EvenScore(115*Multiplier*ScoreMultiplier)
					ScoreRegister.Fire(Player.x,Player.y,EvenScore(115*Multiplier*ScoreMultiplier),"REBOUND EVADE!",4)
					Player.BounceTime=0
					Frenzy:+2
					Trk_FrnzGn:+4
				End If
			ElseIf NearMissTime<>0 And MilliSecs()-NearMissTime>235 And Player.Alive And NearMissCount>=2 Then
				If Not MissID=NearMissID
					NearMissTime=0
					NearMissCount=0
					NearMissID=""
					Score:+EvenScore(105*Multiplier*ScoreMultiplier)
					ScoreRegister.Fire(Player.x,Player.y,EvenScore(105*Multiplier*ScoreMultiplier),"DOUBLE NEAR MISS!",4)
					Frenzy:+2
					Trk_FrnzGn:+4
				Else
					NearMissTime=0
					NearMissCount=0
					NearMissID=""
					If Player.BounceTime=0 Then
						Score:+EvenScore(75*Multiplier*ScoreMultiplier)
						ScoreRegister.Fire(Player.x,Player.y,EvenScore(75*Multiplier*ScoreMultiplier),"NEAR MISS!",4)
						Frenzy:+1
						Trk_FrnzGn:+2
					Else
						Score:+EvenScore(115*Multiplier*ScoreMultiplier)
						ScoreRegister.Fire(Player.x,Player.y,EvenScore(115*Multiplier*ScoreMultiplier),"REBOUND EVADE!",4)
						Player.BounceTime=0
						Frenzy:+2
						Trk_FrnzGn:+4
					End If
				End If
			End If
		End If
	EndMethod

	
	
End Type

'-------------------------------------------------------------------------------------
'MineLayer - Harmless but smart, Advanced Minelayer can also lay a deadly laser grid
'-------------------------------------------------------------------------------------
Type TMineLayer Extends TObject  
	
	Global List:TList
	Global Variations:Int
	Global MineLayerBody:TImage[]
	Global MineLayerBodyHit:TImage[]
	Global MineLayerGlow:TImage[]
	Global MineLayerRGB:Int[,]
	Global LastSpawnVariation:Int
	
	Global LastSpawn:Int
	
	Field SpriteNumber:Int
	Field MaxSpeed:Float
	Field BlurSteps:Float
	Field Turning:Int
	Field CoolDown:Float
	Field AdvancedMineLayer:Float
	Field Hurt:Int
	Field HurtSteps:Float
	Field FlashOnce:Byte
	Field PainFlash:Float
	
	Function Generate(NumMineLayers:Int)
		
		List=Null
		
		List = CreateList()
		
		Variations=NumMineLayers
		
		MineLayerGlow = New TImage[Variations+1]
		MineLayerBody = New TImage[Variations+1]
		MineLayerBodyHit = New TImage[Variations+1]
		MineLayerRGB = New Int[Variations+1,3]
		
		For Local i=1 To NumMineLayers
			
			'Generate and Draw
			GenerateMineLayer(i)
			
			PrepareFrame(MineLayerBody[i])
			PrepareFrame(MineLayerBodyHit[i])
			PrepareFrame(MineLayerGlow[i])
			
		Next
		
	End Function
	
	Function ReCache()
		For Local i=1 To Variations
			PrepareFrame(MineLayerBody[i])
			PrepareFrame(MineLayerBodyHit[i])
			PrepareFrame(MineLayerGlow[i])
		Next
	End Function
	
	Function Spawn(X:Int,Y:Int,AdvancedMineLayer:Int=False)
		Local FailSafe:Int=0
		
		'If Not List List = CreateList()
		
		If Player.Alive
			If CountList(List) => 3 Then Return Null	
		Else
			If CountList(List) => 1 Then Return Null	
		End If
		
		If MilliSecs()-LastSpawn<3200 Return
		
		'1/3 chance of not spawning the Minelayer
		If AdvancedMineLayer
			If Rand(0,15)<9 Then Return
		Else
			If Rand(0,15)<6 Then Return
		End If
		
		Local MineLayer:TMineLayer = New TMineLayer	 
		List.AddLast MineLayer
			
		Repeat 
			MineLayer.SpriteNumber=Rand(1,Variations)
			FailSafe:+1
			If FailSafe=8 Exit
		Until MineLayer.SpriteNumber<>LastSpawnVariation	
		LastSpawnVariation=MineLayer.SpriteNumber
		
		MineLayer.X=X
		MineLayer.Y=Y
		MineLayer.CoolDown=350
		MineLayer.AdvancedMineLayer=AdvancedMineLayer
		
		SpawnEffect.Fire(MineLayer.X,MineLayer.Y,1,MineLayerRGB[MineLayer.SpriteNumber,0],MineLayerRGB[MineLayer.SpriteNumber,1],MineLayerRGB[MineLayer.SpriteNumber,2])	
		
		MineLayer.Direction=Rand(1,360)
		If Not AdvancedMineLayer
			MineLayer.MaxSpeed=.58+SpeedGain
			'MineLayer.MaxSpeed=.52
		Else
			MineLayer.MaxSpeed=.68
		End If
		MineLayer.XSpeed:+ Cos(MineLayer.Direction)/2
		MineLayer.YSpeed:+ Sin(MineLayer.Direction)/2
		
		PlaySoundBetter Sound_Minelayer_Born,X,Y
		
		LastSpawn=MilliSecs()
		
	End Function
	
	Function TurnToFaceCenter:Int(x#,y#, dx#, dy#)

		Local angle1#, angle2#, ret:Int
		
		angle1 = ATan2((FieldHeight/2)-y,(FieldWidth/2)-x)
		angle2 = ATan2(dy,dx)
		
		ret = angle1-angle2
		If ret >= 180
			ret = -(360 - ret)
		Else
			If ret <= -180
				ret = ret + 360
			EndIf
		EndIf
	
		If Abs(ret) < 6 Then ret = 0
		
	    Return ret

	End Function
	
	Function TurnToFaceAway:Int(x#,y#, mx#,my#, dx#, dy#)

		Local angle1#, angle2#, ret:Int
		
		angle1 = ATan2(my-y,mx-x)
		angle2 = ATan2(dy,dx)
		
		ret = angle1-angle2
		If ret >= 180
			ret = -(360 - ret)
		Else
			If ret <= -180
				ret = ret + 360
			EndIf
		EndIf
	
		If Abs(ret) < 6 Then ret = 0
		
	    Return -ret/4

	End Function
	
	Method Update()
		Local distx:Float,Distance:Float,disty:Float, Speed:Float
		Local ShotDistance:Float
		
		'Check against Colosions
		Collision()
		
		'Flash the Advanced Minelayer when Hit
		If Hurt And PainFlash<1 And FlashOnce=False
			PainFlash:+0.225*Delta
		ElseIf Hurt And PainFlash>1 And FlashOnce=False
			FlashOnce=True
		ElseIf Hurt And FlashOnce
			If PainFlash=>0 PainFlash:-0.05*Delta
		End If
		
		HurtSteps:+1*Delta
		
		If HurtSteps>=64 Then HurtSteps=0
		
		If ParticleMultiplier>=1
			If HurtSteps>16 And HurtSteps<18 And Hurt=2
				If Rand(0,22)=22
					PlaySoundBetter Sound_Game_Presents,X,Y
					Flash.Fire(X,Y,.4,25)
					Glow.MassFire(X,Y,1,1.5,Rand(2,5),Rand(Direction-10,Direction+10),180,180,180,False,True)
				Else
					Glow.MassFire(X,Y,1,1.5,Rand(0,2),Rand(Direction-10,Direction+10),MineLayerRGB[SpriteNumber,0],MineLayerRGB[SpriteNumber,1],MineLayerRGB[SpriteNumber,2],False,True)
				End If
			ElseIf HurtSteps>16 And HurtSteps<18 And Hurt=1
				Glow.MassFire(X,Y,1,1.5,Rand(0,1),Rand(Direction-10,Direction+10),MineLayerRGB[SpriteNumber,0],MineLayerRGB[SpriteNumber,1],MineLayerRGB[SpriteNumber,2],False,True)
			End If
		Else
			If HurtSteps>16 And HurtSteps<16.5 And Hurt=2
				If Rand(0,22)=22
					PlaySoundBetter Sound_Game_Presents,X,Y
					Flash.Fire(X,Y,.4,25)
					Glow.MassFire(X,Y,1,1.5,Rand(2,5),Rand(Direction-10,Direction+10),180,180,180,False,True)
				Else
					Glow.MassFire(X,Y,1,1.5,Rand(0,2),Rand(Direction-10,Direction+10),MineLayerRGB[SpriteNumber,0],MineLayerRGB[SpriteNumber,1],MineLayerRGB[SpriteNumber,2],False,True)
				End If
			ElseIf HurtSteps>16 And HurtSteps<16.5 And Hurt=1
				Glow.MassFire(X,Y,1,1.5,Rand(0,1),Rand(Direction-10,Direction+10),MineLayerRGB[SpriteNumber,0],MineLayerRGB[SpriteNumber,1],MineLayerRGB[SpriteNumber,2],False,True)
			End If
		End If
		
		'Avoid Other MineLayers
		For Local MineLayer:TMineLayer = EachIn List
			If MineLayer <> Self
				distx# = MineLayer.X-X
				disty# = MineLayer.Y-Y
				Distance = (distx * distx + disty * disty)
				If Distance < 60*60  + 60*60
					Turning=TurnToFaceAway(X,Y,MineLayer.X,MineLayer.Y,XSpeed,YSpeed)
				EndIf
			EndIf
		Next
		
		If Turning<>0
			Direction:+Sgn(Turning)*Delta
			Turning = Turning - Sgn(Turning)
			XSpeed=Cos(Direction)
			YSpeed=Sin(Direction)
		End If
			
		'Turn around at corners and try to face the center
		If Turning=0
			
			If x < 64 And XSpeed<0
				Turning=TurnToFaceCenter(X,Y,XSpeed,YSpeed)
			ElseIf x > FieldWidth-64 And XSpeed>0
				Turning=TurnToFaceCenter(X,Y,XSpeed,YSpeed)
			EndIf
			
			If y < 64 And YSpeed<0
				Turning=TurnToFaceCenter(X,Y,XSpeed,YSpeed)
			ElseIf y > FieldHeight-64 And YSpeed>0
				Turning=TurnToFaceCenter(X,Y,XSpeed,YSpeed)
			EndIf
		
		End If
		'Limit MineLayer Speed
		Speed = Sqr(XSpeed*XSpeed+YSpeed*YSpeed)
		If Speed > MaxSpeed
			XSpeed=XSpeed/Speed*MaxSpeed
			YSpeed=YSpeed/Speed*MaxSpeed
		ElseIf Speed<0.15
			Direction:+Rand(0,359)
			XSpeed=Cos(Direction)
			YSpeed=Sin(Direction)
		EndIf		
		X:+ XSpeed*Delta
		Y:+ YSpeed*Delta
			
		CoolDown:-1*Delta
		
		If CoolDown<0 
		
			Mine.Spawn(X,Y,AdvancedMineLayer,MineLayerRGB[SpriteNumber,0],MineLayerRGB[SpriteNumber,1],MineLayerRGB[SpriteNumber,2],SpriteNumber)
			CoolDown=215
		
		End If
		
		BlurSteps:+1*Delta
		
		If BlurSteps>62/BlurDivider
			MotionBlur.Spawn(X-XSpeed,Y-YSpeed,Direction+90,4,MineLayerGlow[SpriteNumber])
			BlurSteps=0
		End If
		
	EndMethod
	
	Function Preview(X,Y,SpriteNum)
		
		SetBlend alphablend
		SetScale 4,4
		
		DrawImage MineLayerBody[SpriteNum],x,y
		
		SetScale 5,5
		SetBlend lightblend
		DrawImage MineLayerGlow[SpriteNum],x,y
		
		SetBlend alphablend
		SetScale 1,1
	End Function
	
	Method DrawBody()

		SetRotation(Direction+90)
		DrawImage MineLayerBody[SpriteNumber],x,y
		
		If PainFlash>0
			SetAlpha PainFlash
			DrawImage MineLayerBodyHit[SpriteNumber],x,y
			SetAlpha 1
		End If
		
	EndMethod
	
	Method DrawGlow()
		
		SetRotation(Direction+90)
		DrawImage MineLayerGlow[SpriteNumber],x,y

	EndMethod

	Function DrawAllGlow()
		If Not List Return 
		
		SetScale 4.2,4.2
		
		For Local MineLayer:TMineLayer = EachIn List
			MineLayer.DrawGlow()
		Next
		
	EndFunction
	
	Function DrawAll()
		If Not List Return 
		If List.Count()=0 Return
		SetScale 4,4
		

		For Local MineLayer:TMineLayer = EachIn List
			MineLayer.DrawBody()
		Next
		
		SetBlend LIGHTBLEND
		SetScale 4.5,4.5
		
		For Local MineLayer:TMineLayer = EachIn List
			MineLayer.DrawGlow()
		Next
		
		SetBlend ALPHABLEND
		
	EndFunction
	
	Function UpdateAll()
		If Not List Return 
		
		For Local MineLayer:TMineLayer = EachIn List
			MineLayer.Update()
		Next
	EndFunction

	Method Destroy()
		List.Remove( Self )
	EndMethod
	
	Method DestroyAll()
		If Not List Return 
		
		For Local MineLayer:TMineLayer = EachIn List
			MineLayer.Destroy()
		Next
	EndMethod
	
	Function GenerateMineLayer:TPixmap(Index:Int) Private
		'The amount of White Pixels
		Local PixelCount:Int=0	
		'Stores the MineLayer Pixels
		Local MineLayerPixels:Int[13,13]
		'Stores the MineLayer's Colors
		Local MineLayerColor[3]
		'Amount of Neighboring Pixels
		Local Neighbors:Int
		'Pixels Marked for Removal
		Local KillBody[13,13]
		'The amount of smoothing applied to the Outline
		Local Spikiness=Rand(1,2)
		'GoAgain becomes true when the ship shape is deemed uninteresting/repetive
		Local GoAgain:Int = False
		'The brightness of the MineLayerSprite
		Local Brightness:Int=0 
		
		Repeat 
			PixelCount=0
			'Fill the body
			For Local x=1 To 4 '6
				For Local y=1 To 9 '11
					MineLayerPixels[x,y]=Rand(0,1)
					PixelCount:+ MineLayerPixels[x,y]
				Next
			Next
		Until PixelCount > 16 + Spikiness * 2 And PixelCount < 37
		
		MineLayerPixels[1,1]=0
		
		'Generate Cockpit
		For Local i=6 To 7 '2
			'MineLayerPixels[3,i]=Rand(0,1)*3
			MineLayerPixels[4,i]=Rand(0,1)*3
			MineLayerPixels[5,i]=Rand(0,1)*3
		Next
		
		'Clamp the MineLayers color to a predefined brightness range
		Repeat
			For Local c=0 To 2
				MineLayerColor[c]=Rand(55,145)
			Next
			Brightness=Sqr((MineLayerColor[0]*MineLayerColor[0]*0.241) + (MineLayerColor[1]*MineLayerColor[1]*0.691) + (MineLayerColor[2]*MineLayerColor[2]*0.068))
		Until brightness<=135 And brightness>=85
		'Print brightness
		
		If EasterEgg
			MineLayerColor[1]=MineLayerColor[0]
			MineLayerColor[2]=MineLayerColor[0]
		End If
		
		'Generate "Spine"
		For Local i=2 To 5
			If MineLayerPixels[4,i]<>3 MineLayerPixels[4,i]=1
		Next 	
		
		'Mirror the Ship
		For Local y=1 To 9
		
			MineLayerPixels[7,y]=MineLayerPixels[1,y]
			MineLayerPixels[6,y]=MineLayerPixels[2,y]
			MineLayerPixels[5,y]=MineLayerPixels[3,y]
		
		Next 
		
		
		For Local x=0 To 8 '12
			For Local y=0 To 9
			
			If MineLayerPixels[x,y]=1
				Neighbors=0
				If x+1<8 If MineLayerPixels[x+1,y]=>1 Then Neighbors:+1
				If x-1>0 If MineLayerPixels[x-1,y]=>1 Then Neighbors:+1
				If y-1>0 If MineLayerPixels[x,y-1]=>1 Then Neighbors:+1
				If y+1<8 If MineLayerPixels[x,y+1]=>1 Then Neighbors:+1
				
				If Neighbors<1
					KillBody[x,y]=1
				ElseIf Neighbors=4
					MineLayerPixels[x , y] = 4
				End If
			EndIf
			
			Next
		Next
		
		
		For Local x=0 To 8 '12
			For Local y=0 To 9 '12
				If KillBody[x,y]=1 Then MineLayerPixels[x,y]=0; KillBody[x,y]=0
			Next
		Next
		
		
		For Local x=0 To 8 '12
			For Local y=0 To 9 '12
			
			If MineLayerPixels[x,y]=1
				Neighbors=0
				If x+1<8 If MineLayerPixels[x+1,y]=>1 Then Neighbors:+1
				If x-1>0 If MineLayerPixels[x-1,y]=>1 Then Neighbors:+1
				If y-1>0 If MineLayerPixels[x,y-1]=>1 Then Neighbors:+1
				If y+1<8 If MineLayerPixels[x,y+1]=>1 Then Neighbors:+1
				
				If Neighbors < 1
					KillBody[x , y] = 1
				End If
			EndIf
			
			Next
		Next
				
		For Local x=0 To 8 '12
			For Local y=0 To 9 '12
				If KillBody[x,y]=1 Then MineLayerPixels[x,y]=0; KillBody[x,y]=0
			Next
		Next
		
		For Local x=Spikiness+1 To 7-Spikiness '11
			For Local y=Spikiness To 9-Spikiness '12
			
			If MineLayerPixels[x,y]=0
				If MineLayerPixels[x+1,y]>0 Then MineLayerPixels[x,y]=-1
				If x-1=>0 If MineLayerPixels[x-1,y]>0 Then MineLayerPixels[x,y]=-1
				If y-1=>0 If MineLayerPixels[x,y-1]>0 Then MineLayerPixels[x,y]=-1
				If MineLayerPixels[x,y+1]>0 Then MineLayerPixels[x,y]=-1
			EndIf
			
			Next
		Next
		
		Local ShipWidth:Int[13], PrevShipWidth:Int, RepeatSection:Int
		
		For Local y=0 To 8 
			
			For Local x = 0 To 9
				
				If MineLayerPixels[x,y]<>0 Then ShipWidth[y]:+1
			
			Next
			
			'If the shipwidth is the same as the last section it's a repeat section, we don't want lots of those
			If PrevShipWidth=ShipWidth[y] RepeatSection:+1
			
			PrevShipWidth=ShipWidth[y]
			
		Next
		'-----------------DRAWING ROUTINE-----------------

		Local MineLayerPixmap:TPixmap=CreatePixmap(13,14,PF_RGBA8888)
		Local MineLayerHitPixmap:TPixmap=CreatePixmap(13,14,PF_RGBA8888)
		Local GlowPixmap:TPixmap
		
		ClearPixels (MineLayerPixmap)
		ClearPixels (MineLayerHitPixmap)
		
		'Loop through the MineLayer's pixel array 
		For Local x=0 To 8
			For Local y=0 To 9
				
				'Proceed to draw the MineLayer
				If MineLayerPixels[x,y]=1
					
					WritePixel MineLayerPixmap,2+x,2+y,ToRGBA(MineLayerColor[0],MineLayerColor[1],MineLayerColor[2],255)
					WritePixel MineLayerHitPixmap,2+x,2+y,ToRGBA(255,255,255,255)

				ElseIf MineLayerPixels[x,y]=-1
				
					WritePixel MineLayerPixmap,2+x,2+y,ToRGBA(MineLayerColor[0]*.7,MineLayerColor[1]*.7,MineLayerColor[2]*.7,255)
					WritePixel MineLayerHitPixmap,2+x,2+y,ToRGBA(255,255,255,255)
				
				ElseIf MineLayerPixels[x,y]=3
				
					WritePixel MineLayerPixmap,2+x,2+y,ToRGBA(MineLayerColor[2]-45,MineLayerColor[1]-40,MineLayerColor[0]-10,255)
					WritePixel MineLayerHitPixmap,2+x,2+y,ToRGBA(255,255,255,255)
					
				ElseIf MineLayerPixels[x,y]=4
				
					WritePixel MineLayerPixmap,2+x,2+y,ToRGBA(MineLayerColor[1]*.8,MineLayerColor[2]*.8,MineLayerColor[0]*.8,255)
					WritePixel MineLayerHitPixmap,2+x,2+y,ToRGBA(255,255,255,255)
					
				End If
			
			Next
		Next
		
		For Local i=0 To 2
			MineLayerRGB[Index,i]=MineLayerColor[i]
		Next
		
		GlowPixmap=CopyPixmap(MineLayerPixmap)
		
		MineLayerBody[Index]=LoadImage(MineLayerPixmap,MASKEDIMAGE)
		
		MineLayerBodyHit[index]=LoadImage(MineLayerHitPixmap,MASKEDIMAGE)
				
		GlowPixmap=GaussianBlur(GlowPixmap,3,225,5,245)
		
		MineLayerGlow[Index]=LoadImage(GlowPixmap,FILTEREDIMAGE)
		
		MineLayerPixmap=Null;GlowPixmap=Null; MineLayerHitPixmap=Null
		
	End Function

	
	Function PrepareFrame(image:TImage) Private
		'Use this to cache an image or animimage in VRAM for quicker drawing later.
		image.Frame(0)
		MidHandleImage Image
	End Function
	
	Function ToRGBA%(r%,g%,b%,a%) Private
		'return (a << 24) | (r << 16) | (g << 8) | (b);
	Return ((A Shl 24) | (R Shl 16) | (G Shl 8) | B)
	
	End Function
	Method Collision()
		Local ShotDirection:Float
		
		If TPlayerBomb.List
			For Local PlayerBomb:TPlayerBomb = EachIn TPlayerBomb.List
				
				If Distance(X,Y,PlayerBomb.X,PlayerBomb.Y) < PlayerBomb.Radius
					
					Glow.MassFire(X,Y,1,2,20,AwayFrom(X,Y,PlayerBomb.X,PlayerBomb.Y),MineLayerRGB[SpriteNumber,0],MineLayerRGB[SpriteNumber,1],MineLayerRGB[SpriteNumber,2])
					ParticleManager.Create(X,Y,18,MineLayerRGB[SpriteNumber,0],MineLayerRGB[SpriteNumber,1],MineLayerRGB[SpriteNumber,2],AwayFrom(X,Y,PlayerBomb.X,PlayerBomb.Y),1.2)
					Flash.Fire(X,Y,0.5,25)
					'Explosion.Fire(X,Y,.55)
					Destroy()
					'EnemyCount:-1
					EnemiesKilled:+1
					
				End If
				
			Next
		End If

		If PlayerDistance(X,Y)<50 And Player.Alive Then
			If Player.HasShield-Player.MaskShield>0
				Glow.MassFire(X,Y,1,2,20,AwayFrom(X,Y,Player.X,Player.Y),MinelayerRGB[SpriteNumber,0],MinelayerRGB[SpriteNumber,1],MinelayerRGB[SpriteNumber,2])
				ParticleManager.Create(X,Y,35,MinelayerRGB[SpriteNumber,0],MinelayerRGB[SpriteNumber,1],MinelayerRGB[SpriteNumber,2],AwayFrom(X,Y,Player.X,Player.Y),1.2)
				Flash.Fire(X,Y,0.45,25)
				Destroy()
				'EnemyCount:-1
				EnemiesKilled:+1
				Player.HasShield:-1
				Trk_Shd:-1
				PlaySoundBetter Sound_Player_Shield_Die,X,Y
			Else
				If PlayerDistance(X,Y)<40
					Player.Destroy()
					If Not AdvancedMineLayer
						DeathBy="Minelayer"
					Else
						DeathBy="Advanced Minelayer"
					End If
				End If
			End If
		End If
		
		'If a shot hit a rock
		If Not TShot.List Return
		For Local Shot:TShot = EachIn TShot.List
			If Distance( X, Y, Shot.X, Shot.Y ) < 28
				
				Local TempScore:Int, SniperShot=False
				
				If AdvancedMineLayer And Hurt<2
					Hurt:+1
					PlaySoundBetter Sound_Player_ShotHit,X,Y
					ParticleManager.Create(X,Y,4,MineLayerRGB[SpriteNumber,0],MineLayerRGB[SpriteNumber,1],MineLayerRGB[SpriteNumber,2],0,0.9)
					Glow.MassFire(X,Y,1,2,7,0,MineLayerRGB[SpriteNumber,0],MineLayerRGB[SpriteNumber,1],MineLayerRGB[SpriteNumber,2],True,True)
					Shot.EnemyDestroy()
					FlashOnce=False
					Return
				End If
					
				If AdvancedMineLayer And PainFlash>0 And Player.HasSuper=False
					Shot.EnemyDestroy()
					Return
				End If
				PlaySoundBetter Sound_Explosion_Big,X,Y
				
				
				If AdvancedMinelayer
					If Rand(16+ExtraLikeliness,59)=42 Then Powerup.Spawn(x,y,Rand(0,9))
					TempScore=EvenScore(205*Multiplier*ScoreMultiplier)
				Else
					If Rand(12+ExtraLikeliness,59)=42 Then Powerup.Spawn(x,y,Rand(0,9))
					TempScore=EvenScore(175*Multiplier*ScoreMultiplier)
				End If
				'Glow.MassFire(X,Y,1,2,20,Shot.Direction-90,MineLayerRGB[SpriteNumber,0],MineLayerRGB[SpriteNumber,1],MineLayerRGB[SpriteNumber,2])
				ParticleManager.Create(X,Y,32,MineLayerRGB[SpriteNumber,0],MineLayerRGB[SpriteNumber,1],MineLayerRGB[SpriteNumber,2],0,1.2)
				Glow.MassFire(X,Y,1,2,10,Shot.Direction-93,MineLayerRGB[SpriteNumber,0],MineLayerRGB[SpriteNumber,1],MineLayerRGB[SpriteNumber,2])
				Glow.MassFire(X,Y,1,2,9,Shot.Direction-90,MineLayerRGB[SpriteNumber,0],MineLayerRGB[SpriteNumber,1],MineLayerRGB[SpriteNumber,2])
				Glow.MassFire(X,Y,1,2,11,Shot.Direction-87,MineLayerRGB[SpriteNumber,0],MineLayerRGB[SpriteNumber,1],MineLayerRGB[SpriteNumber,2])

				Shot.EnemyDestroy()
				Flash.Fire(X,Y,1.05,28)
				'Debris.MassFire (X,Y,1,1,11,1)
				Explosion.Fire(X,Y,0.78)
				Explosion.Fire(X+Rand(-5,5),Y+Rand(-5,5),0.45)
		
				'Did the player shoot - or the AI?
				If Shot.Shooter=1 Then
					'Sniper Shot
					If Player.LastShotFired-Player.PrevShotFired>575 Then
						'Print "time req. met! "+(Player.LastShotFired-Player.PrevShotFired)
						If Distance( X, Y, Player.X, Player.Y) >305 Then
							'Print "almost"
							If IsVisible(x,y,15) 
								'Print "Sniper!"+Distance( X, Y, Player.X, Player.Y )
								ScoreRegister.Fire(x,y,TempScore,"2x")
								Tempscore:*2
								SniperShot=True
								Score:+Tempscore
							End If
						End If
					End If
					
					'No Sniper Shot? But still a Player shot?
					If Not SniperShot And Shot.Shooter=1  Then
						If FrenzyMode
							Score:+TempScore*2
							ScoreRegister.Fire(x,y,TempScore,"2x")
						Else
							Score:+TempScore
							ScoreRegister.Fire(x,y,TempScore)
						End If	
					End If
					
					'General Kill Stuff
					EnemiesKilled:+1
					If TempScore>LargestScore Then LargestScore=TempScore
				End If
				
				'Destroy the MineLayer, at last
				Destroy()
				'EnemyCount:-1
				Exit
			EndIf
		Next	
	EndMethod
End Type

'-----------------------------------------------------------------------------
'Mine - passive and deadly
'-----------------------------------------------------------------------------
Type TMine Extends TObject  
	
	Global List:TList
	Global Variations:Int
	Global MineBody:TImage[]
	Global MineGlow:TImage[]
	Global MineRGB:Int[,]
	Global Image:TImage
		
	Field SpriteNumber:Int
	Field CoolDown:Float
	Field Color:Int[3]
	
	'Connected Mine Specific
	Field Connected:Int
	Field ConnectX:Float
	Field ConnectY:Float
	Field ConnectAngle:Float
	Field LaserFlicker:Float
	
	
	
	Function Generate(NumMines:Int)
		
		List=Null
		
		List = CreateList()
		
		If Not Image Then
		
			Image= LoadImage(GetBundleResource("Graphics/particle.png"),FILTEREDIMAGE)
			MidHandleImage Image
		
		End If
	
		Variations=NumMines
		
		MineGlow = New TImage[Variations+1]
		MineBody = New TImage[Variations+1]
		MineRGB = New Int[Variations+1,3]
		
		For Local i=1 To NumMines
			
			'Generate and Draw
			GenerateMine(i)
			
			PrepareFrame(MineBody[i])
			PrepareFrame(MineGlow[i])
			
		Next
		
	End Function
	
	Function ReCache()
		For Local i=1 To Variations
			PrepareFrame(MineBody[i])
			PrepareFrame(MineGlow[i])
		Next
	End Function
	
	Function Spawn(X:Int,Y:Int,ConnectedMine:Int=False,R:Int,G:Int,B:Int,MineType:Int)
	
		
		'If Not List List = CreateList()
		
		'Don't spawn mines close to the corners
		If Not IsVisible(X,Y,-10) Return
		
		If Player.Alive
			If CountList(List) => 90 Then Return Null	
		Else
			If CountList(List) => 35 Then Return Null	
		End If
		
		Local Mine:TMine = New TMine	 
		List.AddLast Mine
			
		Mine.SpriteNumber=MineType
		
		Mine.Color[0]=R*1.3
		Mine.Color[1]=G*1.2
		Mine.Color[2]=B*1.4
		
		Mine.Connected=ConnectedMine

		Mine.X=X
		Mine.Y=Y
		Mine.CoolDown=160	
		'Maybe play a "PLUNK" sound here
		'If Not ChannelPlaying(BornChannel) PlaySound SoundBorn,BornChannel
		PlaySoundBetter Sound_Mine_Born,X,Y
		
	End Function
	
	Function Preview(X,Y,SpriteNum)
		
		SetBlend alphablend
		SetScale 4,4
		
		DrawImage MineBody[SpriteNum],x,y
		
		SetScale 6,6
		SetBlend lightblend
		DrawImage MineGlow[SpriteNum],x,y
		
		SetBlend alphablend
		SetScale 1,1
	End Function
	
	Method DrawBody()
		
		SetRotation(Direction)
		DrawImage MineBody[SpriteNumber],x,y
	
	EndMethod
	
	Method DrawLaser()
		
		If Connected
			If ConnectX<>0 And ConnectY<>0
				SetColor Color[0]*1.2,Color[1]*1.2,Color[2]*1.2
				DrawLine X,Y,ConnectX,ConnectY
			End If
		End If
			
	End Method
	
	Method DrawLaserGL()
		
		If Connected
			If ConnectX<>0 And ConnectY<>0
				SetColor Color[0]*1.2,Color[1]*1.2,Color[2]*1.2
				
				glVertex2f X,Y
				glVertex2f ConnectX,ConnectY
			
			End If
		End If
			
	End Method
	
	
	Method DrawLaserShine()
		
		If Connected
			If ConnectX<>0 And ConnectY<>0
				SetColor Color[0]*1.4,Color[1]*1.4,Color[2]*1.4
				SetTransform ConnectAngle,7.8,1.25+LaserFlicker
				DrawImage Image,(X+ConnectX)/2,(Y+ConnectY)/2
			End If
		End If
	
	End Method
	
	Method DrawGlow()
		

		SetRotation(Direction)
		DrawImage MineGlow[SpriteNumber],x,y

	EndMethod
	
	
	Method Update()
		Local HasLink:Int
		
		'Check against Colosions
		Collision()
		
		'Keep Spinning
		Direction:+.5*Delta	
		
		CoolDown:-1*Delta
		
		If CoolDown<0
		
			Flash.Fire(X,Y,.38,25,Color[0],Color[1],Color[2],False,True)
			CoolDown=140
		End If
		
		'If its a connected kind of Mine
		If Connected
			
			LaserFlicker:+0.05*Delta
			If LaserFlicker>=.5 Then LaserFlicker=Rnd(0.01,0.3)
			
			For Local Mine:TMine = EachIn List
				'Dont connect to yourself
				If Mine=Self Continue
				'Dont connect to passive Mines
				If Not Mine.Connected Continue
				'Only connect to mines laid by the same vehicle
				If Mine.SpriteNumber=SpriteNumber
					If Distance(X,Y,Mine.X,Mine.Y)<160 And ConnectX=0 And ConnectY=0 And Mine.ConnectX=0 And Mine.ConnectY=0
						ConnectX=Mine.X
						ConnectY=Mine.Y
						ConnectAngle=-ATan2((ConnectX-X),(ConnectY-Y))+90
						HasLink=True
						Exit		
						
					End If
					
				End If
				
				If ConnectX=Mine.X And ConnectY=Mine.Y HasLink=True
			Next
			
			If Not HasLink
				ConnectX=0
				ConnectY=0
			End If
			
			If HasLink And PlayerDistance(X,Y)<100
				PlaySoundBetter Sound_Laser_Barrier,X,Y,False,True,True
			End If
			
		End If
	
	EndMethod

	Function DrawAllGlow(FrontBuffer:Int)
		If Not List Return 
		If List.Count()=0 Return
		For Local Mine:TMine = EachIn List
			Mine.DrawLaserShine()
		Next
		
		SetColor 255,255,255
		SetTransform 0,3.7,3.7
		
		'If we are drawing for the frontbuffer we don't need to redraw the Body!
		If FrontBuffer Return
		
		For Local Mine:TMine = EachIn List
			Mine.DrawBody()
		Next
		
	EndFunction
	
	Function DrawAll()
		If Not List Return 
		If List.Count()=0 Return
		
		SetLineWidth 2
		If GlLines
			
			glDisable GL_TEXTURE_2D; glBegin GL_LINES
			SetLineWidth 2
			glLineWidth 2.0
			
			For Local Mine:TMine = EachIn List
				Mine.DrawLaserGL()
			Next

			glEnd; glEnable GL_TEXTURE_2D

		Else
		
			SetTransform 0,1,1
			SetLineWidth 2
							
			For Local Mine:TMine = EachIn List
				Mine.DrawLaser()
			Next
			
		End If
		
		'Temporarily commenting out linewidth to test if that's OK
		'SetLineWidth 1
		SetColor 255,255,255
		
		SetScale 3.5,3.5
		
		For Local Mine:TMine = EachIn List
			Mine.DrawBody()
		Next
		
		SetBlend LIGHTBLEND
		SetScale 4,4
		
		For Local Mine:TMine = EachIn List
			Mine.DrawGlow()
		Next
		
		SetBlend ALPHABLEND
		
	EndFunction
	
	Function UpdateAll()
		If Not List Return 
		
		For Local Mine:TMine = EachIn List
			Mine.Update()
		Next
	EndFunction

	Method Destroy()
		List.Remove( Self )
	EndMethod
	
	Method DestroyAll()
		If Not List Return 
		For Local Mine:TMine = EachIn List
			Mine.Destroy()
		Next
	EndMethod
	
	Function GenerateMine:TPixmap(Index:Int) Private
		'The amount of White Pixels
		Local PixelCount:Int=0	
		'Stores the Mines Pixels
		Local MinePixels:Int[6,6]
		'Stores the Mines Colors
		Local MineColor[3]
		
		'-----------------MATH GEN ROUTINE-----------------
		
		'As long as there are less than 3 or more than 14 White pixels, redo Mine
		Repeat
			PixelCount=0
			For Local i=0 To 2
				For Local j=0 To 4
						
					'A Pixel can be either 0 (Black) or 1 (White)
					MinePixels[i,j]=Rand(0,1)
						
					'Count the number of White Pixels
					PixelCount:+MinePixels[i,j]
						
				Next
				
				'Set the Mines color
				'MineColor[i]=Rand(225,7)
				'MineColor[i]=Rand(55,165)
				MineColor[i]=Rand(145,165)
				
			Next	

		Until PixelCount>6 And PixelCount<10 
		
		MinePixels[0,0]=0
		MinePixels[0,4]=0
		
		'X mirror Mine
		For Local n=0 To 4
			MinePixels[n,4]=MinePixels[n,0]
			MinePixels[n,3]=MinePixels[n,1]
		Next
		
		'Mirror Mine along the Y axis
		For Local m=0 To 4
			MinePixels[4,m]=MinePixels[0,m]
			MinePixels[3,m]=MinePixels[1,m]
		Next
		
		'-----------------DRAWING ROUTINE-----------------

		Local MinePixmap:TPixmap=CreatePixmap(9,9,PF_RGBA8888)
		Local GlowPixmap:TPixmap
		
		ClearPixels (MinePixmap)
		
		'Loop through the Mine's pixel array 
		For Local x=0 To 4
			For Local y=0 To 4
				
				'Proceed to draw the Mine
				If MinePixels[x,y]=1
					
					WritePixel MinePixmap,2+x,2+y,ToRGBA(MineColor[0],MineColor[1],MineColor[2],255)
				
				End If
			
			Next
		Next
		
		For Local i=0 To 2
			MineRGB[index,i]=MineColor[i]
		Next
		
		GlowPixmap=CopyPixmap(MinePixmap)
		
		MineBody[index]=LoadImage(MinePixmap,MASKEDIMAGE)
				
		GlowPixmap=GaussianBlur(GlowPixmap,2,220,35,245)
		
		MineGlow[index]=LoadImage(GlowPixmap,FILTEREDIMAGE)
		
		MinePixmap=Null;GlowPixmap=Null
		
	End Function
	
	Function PrepareFrame(image:TImage) Private
		'Use this to cache an image or animimage in VRAM for quicker drawing later.
		image.Frame(0)
		MidHandleImage Image
	End Function
	
	Function ToRGBA%(r%,g%,b%,a%) Private
		'return (a << 24) | (r << 16) | (g << 8) | (b);
	Return ((A Shl 24) | (R Shl 16) | (G Shl 8) | B)
	
	End Function
	
	Method Collision()
		Local ShotDirection:Float
		Local TakeAwayShield:Int
		
		If TPlayerBomb.List
			For Local PlayerBomb:TPlayerBomb = EachIn TPlayerBomb.List
				
				If Distance(X,Y,PlayerBomb.X,PlayerBomb.Y) < PlayerBomb.Radius
					
					'Glow.MassFire(X,Y,1,2,15,AwayFrom(X,Y,PlayerBomb.X,PlayerBomb.Y),MineRGB[SpriteNumber,0],MineRGB[SpriteNumber,1],MineRGB[SpriteNumber,2])
					ParticleManager.Create(X,Y,6,MineRGB[SpriteNumber,0],MineRGB[SpriteNumber,1],MineRGB[SpriteNumber,2],AwayFrom(X,Y,PlayerBomb.X,PlayerBomb.Y),1.2)
					'Flash.Fire(X,Y,0.3,25)
					'Explosion.Fire(X,Y,.55)
					Destroy()
				
				End If
				
			Next
		End If
		
		If PlayerDistance(X,Y)<36 And Player.Alive Then
			If Player.HasShield-Player.MaskShield>0
				ParticleManager.Create(X,Y,15,200,200,200,AwayFrom(X,Y,Player.X,Player.Y),1.2)
				Flash.Fire(X,Y,0.2,25)
				Destroy()
				TakeAwayShield=True
			Else
				If PlayerDistance(X,Y)<18
					Player.Destroy()
					If Connected
						Deathby="Laser Mine"
					Else
						DeathBy="Mine"
					End If
				End If
			End If
		End If
		
		'Connected mine laser grid can kill the player
		If Connected
			If ConnectX<>0 And ConnectY<>0
				If LineDistance(X,Y,ConnectX,ConnectY,Player.X,Player.Y)<39
					'When the player has a shield he can disarm the laser & mines
					If Player.HasShield-Player.MaskShield>0
						ParticleManager.Create(Player.X,Player.Y,25,200,200,200,Player.Direction,1.2)
						Flash.Fire(X,Y,0.2,25)
						ConnectX=0
						ConnectY=0
						
						'Find nearby Mines, they will get overloaded (Explode)
						For Local Mine:TMine = EachIn List
							If Distance(Mine.X,Mine.Y,Player.X,Player.Y)<88
								ParticleManager.Create(Mine.X,Mine.Y,10,200,200,200,AwayFrom(X,Y,Player.X,Player.Y),1.2)
								Flash.Fire(X,Y,0.2,25)
								Mine.Destroy()
							End If
						Next
						TakeAwayShield=True
						
					ElseIf TakeAwayShield=False
						If LineDistance(X,Y,ConnectX,ConnectY,Player.X,Player.Y)<18 And Player.Alive
							Player.Destroy()
							Deathby="Laser Fence"
						End If
					End If
				End If
			End If
		End If
		
		'Take the shield away from teh player
		If TakeAwayShield Then
			Player.HasShield:-1
			PlaySoundBetter Sound_Player_Shield_Die,X,Y
			Trk_Shd:-1
		End If	
		
		'If a shot hit a rock
		If Not TShot.List Return
		For Local Shot:TShot = EachIn TShot.List
			
			
			If Distance( X, Y, Shot.X, Shot.Y ) < 15 - Connected*4
				
				Local TempScore:Int, SniperShot=False
				
				PlaySoundBetter Sound_Explosion_Big,X,Y
				'If Rand(2,92)=42 Then powerup.Spawn(x,y,1+Rand(0,7))
				If Connected
					TempScore=EvenScore(15*Multiplier*ScoreMultiplier)
				Else
					TempScore=EvenScore(10*Multiplier*ScoreMultiplier)
				End If
				'Glow.MassFire(X,Y,1,2,20,Shot.Direction-90,MineRGB[SpriteNumber,0],MineRGB[SpriteNumber,1],MineRGB[SpriteNumber,2])
				ParticleManager.Create(X,Y,15,MineRGB[SpriteNumber,0],MineRGB[SpriteNumber,1],MineRGB[SpriteNumber,2],0,.75)
				'Glow.MassFire(X,Y,1,2,25,Shot.Direction-90,MineRGB[SpriteNumber,0],MineRGB[SpriteNumber,1],MineRGB[SpriteNumber,2])
				
				Shot.EnemyDestroy()
				Flash.Fire(X,Y,.75,25)
				'Debris.MassFire (X,Y,1,1,11,1)
				'Explosion.Fire(X,Y,.55)
		
				'Did the player shoot - or the AI?
				If Shot.Shooter=1 Then
					'Sniper Shot
					If Player.LastShotFired-Player.PrevShotFired>575 Then
						'Print "time req. met! "+(Player.LastShotFired-Player.PrevShotFired)
						If Distance( X, Y, Player.X, Player.Y) >305 Then
							'Print "almost"
							If IsVisible(x,y,15) 
								'Print "Sniper!"+Distance( X, Y, Player.X, Player.Y )
								ScoreRegister.Fire(x,y,TempScore,"2x")
								Tempscore:*2
								SniperShot=True
								Score:+Tempscore
							End If
						End If
					End If
					
					'No Sniper Shot? But still a Player shot?
					If Not SniperShot And Shot.Shooter=1  Then
						If FrenzyMode
							Score:+TempScore*2
							ScoreRegister.Fire(x,y,TempScore,"2x")
						Else
							Score:+TempScore
							ScoreRegister.Fire(x,y,TempScore)
						End If	
					End If
					
					'General Kill Stuff
					EnemiesKilled:+1
					If TempScore>LargestScore Then LargestScore=TempScore
				End If
				
				'Destroy the Mine, at last
				Destroy()
			EndIf
			
			If Connected
				
				If ConnectX<>0 And ConnectY<>0
				
					'If the shot hits the grid it will fizzle
					If LineDistance(X,Y,ConnectX,ConnectY,Shot.X,Shot.Y)<4.65
						
						If Shot.Bounce=0 And Player.HasBounce>0
							Shot.CalculateNewDirection(X,Y,ConnectX,ConnectY)
							Shot.Immune=3
							Flash.Fire(Shot.X,Shot.Y,.2,50)
							Shot.Bounce:+1
						ElseIf Shot.Immune<=0
							Shot.EnemyDestroy(True,True)
						End If
						
						
						Rem
						Local PX:Float
						Local PY:Float
						PX=Y-ConnectY
						PY=-(X-ConnectX)
						PX = Px/Sqr(PX^2+PY^2)
						PY = Py/Sqr(PY^2+PX^2)

						Shot.Direction=ATan2(PX,PY)
						Shot.XSpeed= Cos(Shot.Direction)*Player.ShotSpeed
						Shot.YSpeed= Sin(Shot.Direction)*Player.ShotSpeed
						Shot.Bounce:+1
						End Rem
						'Shot.EnemyDestroy(True,True)
					End If
					
				End If
			
			End If
			
		Next	
	EndMethod
End Type


'-----------------------------------------------------------------------------
'Data Probe: Chases the player in short bursts
'-----------------------------------------------------------------------------
Type TDataProbe Extends TObject  
	
	Global List:TList
	Global Variations:Int
	Global ProbeBody:TImage[]
	Global ProbeLaunch:TImage[]
	Global ProbeGlow:TImage[]
	Global ChaosShield:TImage
	Global DataProbeRGB:Int[,]
	Global LastSpawn:Int
	Global DualStream:Byte
	Global LastSpawnVariation:Int
	
	Field SpriteNumber:Int
	Field MaxSpeed:Float
	Field LaunchFlash:Float
	Field PainFlash:Float
	Field Fuel:Float
	Field LastLaunch:Int
	Field Launching:Byte
	Field PlayerDirection:Int
	Field XRight#,YRight#,XLeft#,YLeft#
	Field BlurSteps:Float
	Field HurtSteps:Float
	Field i:Float
	Field CoolDown:Float
	Field EffectCoolDown:Float
	Field Hurt:Int
	Field NearMisstime:Int
	Field MissID:String
	
	Function Generate(NumProbes:Int)
		
		List=Null
		
		List = CreateList()
				
		Variations=NumProbes
		
		ProbeGlow = New TImage[Variations+1]
		ProbeBody = New TImage[Variations+1]
		ProbeLaunch = New TImage[Variations+1]
		DataProbeRGB = New Int[Variations+1,3]
		
		For Local i=1 To NumProbes
			
			'Generate and Draw
			GenerateProbe(i)
			
			PrepareFrame(ProbeBody[i])
			PrepareFrame(ProbeLaunch[i])
			PrepareFrame(ProbeGlow[i])
			
		Next
		
		If Rand(0,100)<65 Then
			DualStream=True
		Else
			DualStream=False
		End If
		
	End Function
	
	Function ReCache()
		For Local i=1 To Variations
			PrepareFrame(ProbeBody[i])
			PrepareFrame(ProbeLaunch[i])
			PrepareFrame(ProbeGlow[i])
		Next
	End Function
	
	Function Spawn(X:Int,Y:Int,FastProbe:Int=False)
		Local FailSafe:Int=0
		
		'If Not List List = CreateList()
		
		If Rand(1,20)<9 Return
		
		If PlayerDistance(X,Y)<445 Return
		
		If MilliSecs()-LastSpawn<2550 Return
		
		If Player.Alive
			If CountList(List) => 3 Then Return Null	
		Else
			If CountList(List) => 1 Then Return Null	
		End If
		
		'EnemyCount:+1
		
		Local DataProbe:TDataProbe = New TDataProbe	 
		List.AddLast DataProbe
			
		Repeat 
			DataProbe.SpriteNumber=Rand(1,Variations)
			FailSafe:+1
			If FailSafe=8 Exit
		Until DataProbe.SpriteNumber<>LastSpawnVariation	
		LastSpawnVariation=DataProbe.SpriteNumber
		
		DataProbe.X=X
		DataProbe.Y=Y
		
		
		
		DataProbe.MissID=String(DataProbe.SpriteNumber)+"@"+String(Rand(-32000,92000))
			
		SpawnEffect.Fire(DataProbe.X,DataProbe.Y,.95,DataProbeRGB[DataProbe.SpriteNumber,0],DataProbeRGB[DataProbe.SpriteNumber,1],DataProbeRGB[DataProbe.SpriteNumber,2])	
		
		DataProbe.Direction=Rand(1,360)
		DataProbe.MaxSpeed=.78+SpeedGain*.25
		DataProbe.XSpeed:+ Cos(DataProbe.Direction)/2
		DataProbe.YSpeed:+ Sin(DataProbe.Direction)/2
		
		PlaySoundBetter Sound_DataProbe_Born,X,Y
		
		LastSpawn=MilliSecs()
		
		DataProbe.CoolDown=850
		
	End Function
	
	Function Preview(X,Y,SpriteNum)
		
		SetBlend alphablend
		SetScale 4,4
		
		DrawImage ProbeBody[SpriteNum],x,y
		SetColor 255,255,255
		SetScale 5,5
		SetBlend lightblend
		DrawImage ProbeGlow[SpriteNum],x,y
		
		SetBlend alphablend
		SetScale 1,1
	End Function
	
	Method DrawBodyGlow()

		SetRotation(Direction+90)
		DrawImage ProbeBody[SpriteNumber],x,y
		
		If LaunchFlash>0
			SetAlpha LaunchFlash
			DrawImage ProbeLaunch[SpriteNumber],x,y
			SetAlpha 1
		End If
		
	EndMethod

	Method DrawBody()

		SetRotation(Direction+90)
		DrawImage ProbeBody[SpriteNumber],x,y
		
		If LaunchFlash>0
			SetAlpha LaunchFlash
			DrawImage ProbeLaunch[SpriteNumber],x,y
			SetAlpha 1
		End If
		
	EndMethod
	
	Method DrawGlow()
		
		SetRotation(Direction+90)
		DrawImage ProbeGlow[SpriteNumber],x,y

	EndMethod
	
	
	Method Update()
		Local distx:Float,Distance:Float,disty:Float, Speed:Float
		Local PlayerTurn:Float
		'Check against Colosions
		Collision()
		NearMissCheck(3.95)
		CollisionPhysics(32)
		
		BlurSteps:+1*Delta
		
		
		If EffectCoolDown>-1 EffectCoolDown:-1.1*Delta
		HurtSteps:+1*Delta
		CoolDown:-1*Delta
		
		If HurtSteps>=64 Then HurtSteps=0
		
		If ParticleMultiplier>=1		
			If HurtSteps>16 And HurtSteps<18 And Hurt=1
				Glow.MassFire(X,Y,1,1.5,1,Rand(Direction-10,Direction+10),DataProbeRGB[SpriteNumber,0],DataProbeRGB[SpriteNumber,1],DataProbeRGB[SpriteNumber,2],False,True)
			End If
		Else
			If HurtSteps>16 And HurtSteps<17 And Hurt=1
				Glow.MassFire(X,Y,1,1.5,1,Rand(Direction-10,Direction+10),DataProbeRGB[SpriteNumber,0],DataProbeRGB[SpriteNumber,1],DataProbeRGB[SpriteNumber,2],False,True)
			End If
		End If
		'If we are launching display thruster
		PlayerTurn=TurnToFacePoint(Player.X,Player.Y,x,y,xspeed,yspeed)
		If Launching=False
			If PlayerTurn>0
				Direction:+1*Delta
			ElseIf PlayerTurn<0
				Direction:-1*Delta
			End If
		Else
			If PlayerTurn>0
				Direction:+.3*Delta
			ElseIf PlayerTurn<0
				Direction:-.3*Delta
			End If
		End If
		
		'If Launching=False
			
			'Direction:+ Sgn(PlayerDirection)*Delta
			'PlayerDirection = PlayerDirection - Sgn(PlayerDirection)
		
		'End If
		
		
		i:+1*Delta
		
		If Launching
			
			If i>=(2.5*1/ParticleMultiplier) Then 
				i=0
				If DualStream
					Thrust.Fire( (X-Cos(Direction+21)*11), (Y-Sin(Direction+21)*11),0.6,DataProbeRGB[SpriteNumber,0]*1.2,DataProbeRGB[SpriteNumber,1]*1.2,DataProbeRGB[SpriteNumber,2]*1.2 )
					Thrust.Fire( (X-Cos(Direction-21)*11), (Y-Sin(Direction-21)*11),0.6,DataProbeRGB[SpriteNumber,0]*1.2,DataProbeRGB[SpriteNumber,1]*1.2,DataProbeRGB[SpriteNumber,2]*1.2 )
				Else
					Thrust.Fire( (X-Cos(Direction)*11), (Y-Sin(Direction)*11),0.7,DataProbeRGB[SpriteNumber,0]*1.2,DataProbeRGB[SpriteNumber,1]*1.2,DataProbeRGB[SpriteNumber,2]*1.2 )
				End If
			End If
		
		Else
		
			If i>=(5*1/ParticleMultiplier) Then 
				i=0
				If DualStream
					Thrust.Fire( (X-Cos(Direction+21)*11), (Y-Sin(Direction+21)*11),0.6,DataProbeRGB[SpriteNumber,0],DataProbeRGB[SpriteNumber,1],DataProbeRGB[SpriteNumber,2],True )
					Thrust.Fire( (X-Cos(Direction-21)*11), (Y-Sin(Direction-21)*11),0.6,DataProbeRGB[SpriteNumber,0],DataProbeRGB[SpriteNumber,1],DataProbeRGB[SpriteNumber,2],True )
				Else
					Thrust.Fire( (X-Cos(Direction)*11), (Y-Sin(Direction)*11),0.7,DataProbeRGB[SpriteNumber,0],DataProbeRGB[SpriteNumber,1],DataProbeRGB[SpriteNumber,2],True )
				End If
			End If
			
		End If
		
		If Launching
			If BlurSteps>30/BlurDivider
				MotionBlur.Spawn(X,Y,Direction+90,4,ProbeGlow[SpriteNumber])
				BlurSteps=0
			End If
		Else
			If BlurSteps>52/BlurDivider
				MotionBlur.Spawn(X,Y,Direction+90,4,ProbeGlow[SpriteNumber])
				BlurSteps=0
			End If
		End If
		
		If Launching=False And CoolDown<=0
			Fuel=94
			Launching=True
			PlaySoundBetter Sound_DataProbe_Boost,X,Y
			Flash.Fire(x,y,0.88,30,255,255,255,False,True)
		ElseIf Launching=True
			Fuel:-.5*Delta
			XSpeed = XSpeed + Cos(Direction)*2.3*Delta	
			YSpeed = YSpeed + Sin(Direction)*2.3*Delta
		ElseIf Launching=False And Cooldown>0
			XSpeed = XSpeed + Cos(Direction)*.6*Delta	
			YSpeed = YSpeed + Sin(Direction)*.6*Delta
		End If
		
		If Fuel<=0 And Launching
			Launching=False
			CoolDown=600
		End If
		
		If CoolDown>40 And CoolDown<60
			LaunchFlash=3
		End If
		
		If LaunchFlash>0
			LaunchFlash:-.08*Delta
		End If
		
		If PainFlash>0
			PainFlash:-.08*Delta
		End If
		
		'Avoid Other Probes
		For Local Probe:TDataProbe = EachIn List
			If Probe <> Self
				distx# = Probe.X-X
				disty# = Probe.Y-Y
				Distance = (distx * distx + disty * disty)
				If Distance < 25*25  + 25*25
					XSpeed:- Sgn(distx)
					YSpeed:- Sgn(disty)
				EndIf
			EndIf
		Next
		
		'Bounce around the corners
		If x < 8 
			XSpeed = Abs(XSpeed)
			X:+ XSpeed*Delta
			Direction:+ 90
		ElseIf x > FieldWidth-8
			XSpeed = -Abs(XSpeed)
			X:+ XSpeed*Delta
			Direction:+ 90
		EndIf
		If y < 8
			YSpeed = Abs(Yspeed)
			Y:+ YSpeed*Delta
			Direction:+ 90
		ElseIf y > FieldHeight-8
			YSpeed = -Abs(YSpeed)
			Y:+ YSpeed*Delta
			Direction:+ 90
		EndIf
		
		'Limit Probe Speed
		If Launching
			Speed = Sqr(XSpeed*XSpeed+YSpeed*YSpeed)
			If Speed > MaxSpeed
				XSpeed=XSpeed/Speed*(MaxSpeed*2.4)
				YSpeed=YSpeed/Speed*(MaxSpeed*2.4)
			EndIf		
			X:+ XSpeed*Delta
			Y:+ YSpeed*Delta
		Else
			Speed = Sqr(XSpeed*XSpeed+YSpeed*YSpeed)
			If Speed > MaxSpeed
				XSpeed=XSpeed/Speed*MaxSpeed
				YSpeed=YSpeed/Speed*MaxSpeed
			EndIf		
			X:+ XSpeed*Delta
			Y:+ YSpeed*Delta
		End If
		
	EndMethod
	
	Method CollisionPhysics(Radius)
		Local Mass=6.75	
		'Inititialise all other Asteroids (E.g. X&Y representing the current Asteroid Asteroid.X representing the others being checked against)
		If TAsteroid.List
		For Local Asteroid:TAsteroid = EachIn TAsteroid.List
			
			'Don't check for collisions against "yourself".
			'If Asteroid=Self Continue
			
			'Dont check freshly spawned asteroids, give them some time to settle
			If MilliSecs()-Asteroid.SpawnTime<350 Continue
			
			Local collisionDistance# = Radius
			Local actualDistance# = Sqr((Asteroid.X-X)^2+(Asteroid.Y-Y)^2)
			' collided or not?
			If actualDistance<collisionDistance Then
				
				Local collNormalAngle#=ATan2(Asteroid.Y-Y, Asteroid.X-X)
				' position exactly touching, no intersection
				Local moveDist1#=(collisionDistance-actualDistance)*(Asteroid.Mass/Float((Mass+Asteroid.Mass)))
				Local moveDist2#=(collisionDistance-actualDistance)*(Mass/Float((Mass+Asteroid.Mass)))
				X=X + moveDist1*Cos(collNormalAngle+180)
				Y=Y + moveDist1*Sin(collNormalAngle+180)
				
				Asteroid.X=Asteroid.X + moveDist2*Cos(collNormalAngle)
				Asteroid.Y=Asteroid.Y + moveDist2*Sin(collNormalAngle)
				' COLLISION RESPONSE
				' n = vector connecting the centers of the balls.
				' we are finding the components of the normalised vector n
				Local nX#=Cos(collNormalAngle)
				Local nY#=Sin(collNormalAngle)
				' now find the length of the components of each movement vectors
				' along n, by using dot product.
				Local a1# = XSpeed*nX  +  YSpeed*nY
				Local a2# = Asteroid.XSpeed*nX +  Asteroid.YSpeed*nY
				' optimisedP = 2(a1 - a2)
				'             ----------
				'              m1 + m2
				Local optimisedP# = (2.0 * (a1-a2)) / (Mass + Asteroid.Mass)
				' now find out the resultant vectors
				'' Local r1% = c1.v - optimisedP * mass2 * n
				XSpeed = XSpeed - (optimisedP*Asteroid.Mass*nX)
				YSpeed = YSpeed - (optimisedP*Asteroid.Mass*nY)
				'' Local r2% = c2.v - optimisedP * mass1 * n
				Asteroid.XSpeed = Asteroid.XSpeed + (optimisedP*Mass*nX)
				Asteroid.YSpeed = Asteroid.YSpeed + (optimisedP*Mass*nY)
				
				If EffectCoolDown<=0 Flash.Fire(X,Y,0.3,25)
				If EffectCoolDown<=0 ParticleManager.Create(X,Y,13,100,100,100,0,.7)
				If EffectCoolDown<=0 EffectCoolDown:+50

			End If
		Next
		End If
		
		If TInvader.List
		For Local Invader:TInvader = EachIn TInvader.List
			
			'Don't check for collisions against "yourself".
			'If Invader=Self Continue
			
			'Dont check freshly spawned Invaders, give them some time to settle
			'If MilliSecs()-Invader.SpawnTime<350 Continue
			
			Local collisionDistance# = Radius
			Local actualDistance# = Sqr((Invader.X-X)^2+(Invader.Y-Y)^2)
			' collided or not?
			If actualDistance<collisionDistance Then
				
				Local collNormalAngle#=ATan2(Invader.Y-Y, Invader.X-X)
				' position exactly touching, no intersection
				Local moveDist1#=(collisionDistance-actualDistance)*(1.1/Float((Mass+1.1)))
				Local moveDist2#=(collisionDistance-actualDistance)*(Mass/Float((Mass+1.1)))
				X=X + moveDist1*Cos(collNormalAngle+180)
				Y=Y + moveDist1*Sin(collNormalAngle+180)
				
				Invader.X=Invader.X + moveDist2*Cos(collNormalAngle)
				Invader.Y=Invader.Y + moveDist2*Sin(collNormalAngle)
				' COLLISION RESPONSE
				' n = vector connecting the centers of the balls.
				' we are finding the components of the normalised vector n
				Local nX#=Cos(collNormalAngle)
				Local nY#=Sin(collNormalAngle)
				' now find the length of the components of each movement vectors
				' along n, by using dot product.
				Local a1# = XSpeed*nX  +  YSpeed*nY
				Local a2# = Invader.XSpeed*nX +  Invader.YSpeed*nY
				' optimisedP = 2(a1 - a2)
				'             ----------
				'              m1 + m2
				Local optimisedP# = (2.0 * (a1-a2)) / (Mass + 1.1)
				' now find out the resultant vectors
				'' Local r1% = c1.v - optimisedP * mass2 * n
				XSpeed = XSpeed - (optimisedP*1.1*nX)
				YSpeed = YSpeed - (optimisedP*1.1*nY)
				'' Local r2% = c2.v - optimisedP * mass1 * n
				Invader.XSpeed = Invader.XSpeed + (optimisedP*Mass*nX)
				Invader.YSpeed = Invader.YSpeed + (optimisedP*Mass*nY)
				
				If EffectCoolDown<=0 Flash.Fire(X,Y,0.3,25)
				If EffectCoolDown<=0 ParticleManager.Create(X,Y,13,100,100,100,0,.7)
				If EffectCoolDown<=0 EffectCoolDown:+50

			End If
		Next
		End If
		
		If TSpinner.List
		For Local Spinner:TSpinner = EachIn TSpinner.List
			
			'Don't check for collisions against "yourself".
			'If Spinner=Self Continue
			
			'Dont check freshly spawned Spinners, give them some time to settle
			'If MilliSecs()-Spinner.SpawnTime<350 Continue
			
			Local collisionDistance# = Radius
			Local actualDistance# = Sqr((Spinner.X-X)^2+(Spinner.Y-Y)^2)
			' collided or not?
			If actualDistance<collisionDistance Then
				
				Local collNormalAngle#=ATan2(Spinner.Y-Y, Spinner.X-X)
				' position exactly touching, no intersection
				Local moveDist1#=(collisionDistance-actualDistance)*(1.0/Float((Mass+1.0)))
				Local moveDist2#=(collisionDistance-actualDistance)*(Mass/Float((Mass+1.0)))
				X=X + moveDist1*Cos(collNormalAngle+180)
				Y=Y + moveDist1*Sin(collNormalAngle+180)
				
				Spinner.X=Spinner.X + moveDist2*Cos(collNormalAngle)
				Spinner.Y=Spinner.Y + moveDist2*Sin(collNormalAngle)
				' COLLISION RESPONSE
				' n = vector connecting the centers of the balls.
				' we are finding the components of the normalised vector n
				Local nX#=Cos(collNormalAngle)
				Local nY#=Sin(collNormalAngle)
				' now find the length of the components of each movement vectors
				' along n, by using dot product.
				Local a1# = XSpeed*nX  +  YSpeed*nY
				Local a2# = Spinner.XSpeed*nX +  Spinner.YSpeed*nY
				' optimisedP = 2(a1 - a2)
				'             ----------
				'              m1 + m2
				Local optimisedP# = (2.0 * (a1-a2)) / (Mass + 1.0)
				' now find out the resultant vectors
				'' Local r1% = c1.v - optimisedP * mass2 * n
				XSpeed = XSpeed - (optimisedP*1.0*nX)
				YSpeed = YSpeed - (optimisedP*1.0*nY)
				'' Local r2% = c2.v - optimisedP * mass1 * n
				Spinner.XSpeed = Spinner.XSpeed + (optimisedP*Mass*nX)
				Spinner.YSpeed = Spinner.YSpeed + (optimisedP*Mass*nY)
				
				If EffectCoolDown<=0 Flash.Fire(X,Y,0.3,25)
				If EffectCoolDown<=0 ParticleManager.Create(X,Y,13,100,100,100,0,.7)
				If EffectCoolDown<=0 EffectCoolDown:+50

			End If
		Next
		End If
		If TCorruptedInvader.List
		For Local CorruptedInvader:TCorruptedInvader = EachIn TCorruptedInvader.List
			
			'Don't check for collisions against "yourself".
			'If CorruptedInvader=Self Continue
			
			'Dont check freshly spawned CorruptedInvaders, give them some time to settle
			'If MilliSecs()-CorruptedInvader.SpawnTime<350 Continue
			
			Local collisionDistance# = Radius
			Local actualDistance# = Sqr((CorruptedInvader.X-X)^2+(CorruptedInvader.Y-Y)^2)
			' collided or not?
			If actualDistance<collisionDistance Then
				
				Local collNormalAngle#=ATan2(CorruptedInvader.Y-Y, CorruptedInvader.X-X)
				' position exactly touching, no intersection
				Local moveDist1#=(collisionDistance-actualDistance)*(1.2/Float((Mass+1.2)))
				Local moveDist2#=(collisionDistance-actualDistance)*(Mass/Float((Mass+1.2)))
				X=X + moveDist1*Cos(collNormalAngle+180)
				Y=Y + moveDist1*Sin(collNormalAngle+180)
				
				CorruptedInvader.X=CorruptedInvader.X + moveDist2*Cos(collNormalAngle)
				CorruptedInvader.Y=CorruptedInvader.Y + moveDist2*Sin(collNormalAngle)
				' COLLISION RESPONSE
				' n = vector connecting the centers of the balls.
				' we are finding the components of the normalised vector n
				Local nX#=Cos(collNormalAngle)
				Local nY#=Sin(collNormalAngle)
				' now find the length of the components of each movement vectors
				' along n, by using dot product.
				Local a1# = XSpeed*nX  +  YSpeed*nY
				Local a2# = CorruptedInvader.XSpeed*nX +  CorruptedInvader.YSpeed*nY
				' optimisedP = 2(a1 - a2)
				'             ----------
				'              m1 + m2
				Local optimisedP# = (2.0 * (a1-a2)) / (Mass + 1.2)
				' now find out the resultant vectors
				'' Local r1% = c1.v - optimisedP * mass2 * n
				XSpeed = XSpeed - (optimisedP*1.2*nX)
				YSpeed = YSpeed - (optimisedP*1.2*nY)
				'' Local r2% = c2.v - optimisedP * mass1 * n
				CorruptedInvader.XSpeed = CorruptedInvader.XSpeed + (optimisedP*Mass*nX)
				CorruptedInvader.YSpeed = CorruptedInvader.YSpeed + (optimisedP*Mass*nY)
				
				If EffectCoolDown<=0 Flash.Fire(X,Y,0.3,25)
				If EffectCoolDown<=0 ParticleManager.Create(X,Y,13,100,100,100,0,.7)
				If EffectCoolDown<=0 EffectCoolDown:+50

			End If
		Next
		End If

	End Method
	
	Function DrawAllGlow()
		If Not List Return 
		
		SetScale 4.4,4.4
		
		For Local Probe:TDataProbe = EachIn List
			Probe.DrawBodyGlow()
		Next
		
	EndFunction
	
	Function DrawAll()
		If Not List Return 
		If List.Count()=0 Return
		SetScale 4,4
		

		For Local Probe:TDataProbe = EachIn List
			Probe.DrawBody()
		Next
		
		SetBlend LIGHTBLEND
		SetScale 5,5
		
		For Local Probe:TDataProbe = EachIn List
			Probe.DrawGlow()
		Next
		SetBlend ALPHABLEND
	EndFunction
	
	Function UpdateAll()
		If Not List Return 
		
		For Local Probe:TDataProbe = EachIn List
			Probe.Update()
		Next
	EndFunction

	Method Destroy()
		List.Remove( Self )
	EndMethod
	
	Method DestroyAll()
		If Not List Return 
		
		For Local Probe:TDataProbe = EachIn List
			Probe.Destroy()
		Next
	EndMethod
	
	Function GenerateProbe:TPixmap(Index:Int) Private
		'The amount of White Pixels
		Local PixelCount:Int=0	
		'Stores the Probes Pixels
		Local ProbePixels:Int[9,9]
		'Stores the Probes Colors
		Local ProbeColor[3]
		
		'-----------------MATH GEN ROUTINE-----------------
		
		'As long as there are less than 3 or more than 14 White pixels, redo Probe
		Repeat
			PixelCount=0
			For Local i=0 To 2
				For Local j=0 To 6
						
					'A Pixel can be either 0 (Black) or 1 (White)
					ProbePixels[i,j]=Rand(0,1)
						
					'Count the number of White Pixels
					PixelCount:+ProbePixels[i,j]
						
				Next
				
				'Set the Probes color
				ProbeColor[i]=Rand(75,165)
				'ProbeColor[i]=Rand(60,130)
				
			Next
				
		Until PixelCount>=15 And PixelCount<=19 
		
		If EasterEgg
			ProbeColor[1]=ProbeColor[0]
			ProbeColor[2]=ProbeColor[0]
		End If
			
		For Local n=0 To 1
			ProbePixels[n,3]=0
			ProbePixels[n,4]=0
		Next
		
		ProbePixels[0,6]=0
		ProbePixels[2,6]=0
		
		'For Local n=3 To 4
		'	ProbePixels[2,n]=1
		'Next
		
		
		'Mirror Probe along the Y axis
		For Local m=0 To 6
			ProbePixels[5,m]=ProbePixels[0,m]
			ProbePixels[4,m]=ProbePixels[1,m]
			ProbePixels[3,m]=ProbePixels[2,m]
		Next
		
		
		
		'-----------------DRAWING ROUTINE-----------------

		Local ProbePixmap:TPixmap=CreatePixmap(10,11,PF_RGBA8888)
		Local ProbeLaunchPixmap:TPixmap=CreatePixmap(10,11,PF_RGBA8888)
		Local GlowPixmap:TPixmap
		
		ClearPixels (ProbePixmap)
		ClearPixels (ProbeLaunchPixmap)
		
		'Loop through the Probe's pixel array 
		For Local x=0 To 5
			For Local y=0 To 6
				
				'Proceed to draw the Probe
				If ProbePixels[x,y]=1
					
					WritePixel ProbePixmap,2+x,2+y,ToRGBA(ProbeColor[0],ProbeColor[1],ProbeColor[2],255)
					WritePixel ProbeLaunchPixmap,2+x,2+y,ToRGBA(255,255,255,255)
				
				End If
			
			Next
		Next
		
		For Local i=0 To 2
			DataProbeRGB[index,i]=ProbeColor[i]
		Next
		
		GlowPixmap=CopyPixmap(ProbePixmap)
		
		ProbeBody[index]=LoadImage(ProbePixmap,MASKEDIMAGE)
		
		ProbeLaunch[index]=LoadImage(ProbeLaunchPixmap,MASKEDIMAGE)
				
		GlowPixmap=GaussianBlur(GlowPixmap,2,220,35,255)
		
		ProbeGlow[index]=LoadImage(GlowPixmap,FILTEREDIMAGE)
		
		ProbePixmap=Null;GlowPixmap=Null
		
	End Function
	
	Function PrepareFrame(image:TImage) Private
		'Use this to cache an image or animimage in VRAM for quicker drawing later.
		image.Frame(0)
		MidHandleImage Image
	End Function
	
	Function ToRGBA%(r%,g%,b%,a%) Private
		'return (a << 24) | (r << 16) | (g << 8) | (b);
	Return ((A Shl 24) | (R Shl 16) | (G Shl 8) | B)
	
	End Function
	
	Method Collision()
		Local ShotDirection:Float
		
		If Player.Alive And PlayerDistance(X,Y)<ComfortZone
			CloseEncounters:+.15*Delta
		End If
		
		If PlayerDistance(X,Y)<46 And Player.Alive Then
			If Player.HasShield-Player.MaskShield>0
					Glow.MassFire(X,Y,1,2,25,AwayFrom(X,Y,Player.X,Player.Y),DataProbeRGB[SpriteNumber,0],DataProbeRGB[SpriteNumber,1],DataProbeRGB[SpriteNumber,2])
					ParticleManager.Create(X,Y,15,DataProbeRGB[SpriteNumber,0],DataProbeRGB[SpriteNumber,1],DataProbeRGB[SpriteNumber,2],AwayFrom(X,Y,Player.X,Player.Y),1.3)					
					Flash.Fire(X,Y,0.4,25)
					Destroy()
					'EnemyCount:-1
					EnemiesKilled:+1
					Player.HasShield:-1
					Trk_Shd:-1
					PlaySoundBetter Sound_Player_Shield_Die,X,Y
			Else
				If PlayerDistance(X,Y)<36
					Player.Destroy()
					Deathby="Data Probe"
				End If
			End If
		End If
		
		If TPlayerBomb.List
			For Local PlayerBomb:TPlayerBomb = EachIn TPlayerBomb.List
				
				If Distance(X,Y,PlayerBomb.X,PlayerBomb.Y) < PlayerBomb.Radius
					
					Glow.MassFire(X,Y,1,2,15,AwayFrom(X,Y,PlayerBomb.X,PlayerBomb.Y),DataProbeRGB[SpriteNumber,0],DataProbeRGB[SpriteNumber,1],DataProbeRGB[SpriteNumber,2])
					ParticleManager.Create(X,Y,20,DataProbeRGB[SpriteNumber,0],DataProbeRGB[SpriteNumber,1],DataProbeRGB[SpriteNumber,2],AwayFrom(X,Y,PlayerBomb.X,PlayerBomb.Y),1.2)
					Flash.Fire(X,Y,0.3,25)
					'Explosion.Fire(X,Y,.55)
					Destroy()
					'EnemyCount:-1
					EnemiesKilled:+1
					
				End If
				
			Next
		End If

		'If a shot hit a rock
		If Not TShot.List Return
		For Local Shot:TShot = EachIn TShot.List
			
			If Distance( X, Y, Shot.X, Shot.Y ) < 21
				
				
				If Hurt=0
					Hurt=1
					Glow.MassFire(X,Y,1,2.1,8,0,DataProbeRGB[SpriteNumber,0],DataProbeRGB[SpriteNumber,1],DataProbeRGB[SpriteNumber,2],True,True)
					ParticleManager.Create(X,Y,5,DataProbeRGB[SpriteNumber,0],DataProbeRGB[SpriteNumber,1],DataProbeRGB[SpriteNumber,2],0,0.9)
					PlaySoundBetter Sound_Player_ShotHit,X,Y
					Shot.EnemyDestroy()
					LaunchFlash=2
					PainFlash=2
					Return
				End If
				
				If PainFlash>0 And Player.HasSuper=False
					Shot.EnemyDestroy()
					Return
				End If
				Local TempScore:Int, SniperShot=False
				PlaySoundBetter Sound_Explosion,X,Y
				If Rand(6+ExtraLikeliness,62)=42 Then Powerup.Spawn(x,y,Rand(0,8))
				TempScore=EvenScore(240*Multiplier*ScoreMultiplier)
				Glow.MassFire(X,Y,1,2.1,21,Shot.Direction-90,DataProbeRGB[SpriteNumber,0],DataProbeRGB[SpriteNumber,1],DataProbeRGB[SpriteNumber,2])
				ParticleManager.Create(X,Y,10,DataProbeRGB[SpriteNumber,0],DataProbeRGB[SpriteNumber,1],DataProbeRGB[SpriteNumber,2],0,1.35)
				ParticleManager.Create(X,Y,15,240,240,240,0,.65)
				Shot.EnemyDestroy()
				Flash.Fire(X,Y,.9,25)
				'Debris.MassFire (X,Y,1,1,11,1)
				Explosion.Fire(X,Y,.6)
				Explosion.Fire(X,Y,.45)
		
				'Did the player shoot - or the AI?
				If Shot.Shooter=1 Then
					'Sniper Shot
					If Player.LastShotFired-Player.PrevShotFired>575 Then
						'Print "time req. met! "+(Player.LastShotFired-Player.PrevShotFired)
						If Distance( X, Y, Player.X, Player.Y) >305 Then
							'Print "almost"
							If IsVisible(x,y,15) 
								'Print "Sniper!"+Distance( X, Y, Player.X, Player.Y )
								ScoreRegister.Fire(x,y,TempScore,"2x")
								Tempscore:*2
								SniperShot=True
								Score:+Tempscore
							End If
						End If
					End If
					
					'No Sniper Shot? But still a Player shot?
					If Not SniperShot And Shot.Shooter=1  Then
						Score:+TempScore
						ScoreRegister.Fire(x,y,TempScore)	
					End If
					
					'General Kill Stuff
					EnemiesKilled:+1
					If TempScore>LargestScore Then LargestScore=TempScore
				End If
				
				'Destroy the Probe, at last
				Destroy()
				Shot.EnemyDestroy()
				'EnemyCount:-1
				Exit
			EndIf
		Next	
	EndMethod
	
	Method NearMissCheck(Size:Float)
		'Check for "Near Misses"
		If Distance( X, Y, Player.X, Player.Y) < Size*16 Then
			If Abs(Player.XSpeed)>0.35 Or Abs (Player.YSpeed)>0.35 Then
				NearMissCount:+1
				NearMissTime=MilliSecs()
				If NearMissID="" NearMissID=MissID
			End If
		Else
			'If there was a near miss more than 250 msec ago... and the player is still alive - heh.
			If NearMissTime<>0 And MilliSecs()-NearMissTime>245 And Player.Alive And NearMissCount=1 Then
				'Print "Near Miss!"
				NearMissTime=0
				NearMissCount=0
				NearMissID=""
				If Player.BounceTime=0 Then
					Score:+EvenScore(75*Multiplier*ScoreMultiplier)
					ScoreRegister.Fire(Player.x,Player.y,EvenScore(75*Multiplier*ScoreMultiplier),"NEAR MISS!",4)
					Frenzy:+1
					Trk_FrnzGn:+2
				Else
					Score:+EvenScore(115*Multiplier*ScoreMultiplier)
					ScoreRegister.Fire(Player.x,Player.y,EvenScore(115*Multiplier*ScoreMultiplier),"REBOUND EVADE!",4)
					Player.BounceTime=0
					Frenzy:+2
					Trk_FrnzGn:+4
				End If
			ElseIf NearMissTime<>0 And MilliSecs()-NearMissTime>235 And Player.Alive And NearMissCount>=2 Then
				If Not MissID=NearMissID
					NearMissTime=0
					NearMissCount=0
					NearMissID=""
					Score:+EvenScore(105*Multiplier*ScoreMultiplier)
					ScoreRegister.Fire(Player.x,Player.y,EvenScore(105*Multiplier*ScoreMultiplier),"DOUBLE NEAR MISS!",4)
					Frenzy:+2
					Trk_FrnzGn:+4
				Else
					NearMissTime=0
					NearMissCount=0
					NearMissID=""
					If Player.BounceTime=0 Then
						Score:+EvenScore(75*Multiplier*ScoreMultiplier)
						ScoreRegister.Fire(Player.x,Player.y,EvenScore(75*Multiplier*ScoreMultiplier),"NEAR MISS!",4)
						Frenzy:+1
						Trk_FrnzGn:+2
					Else
						Score:+EvenScore(115*Multiplier*ScoreMultiplier)
						ScoreRegister.Fire(Player.x,Player.y,EvenScore(115*Multiplier*ScoreMultiplier),"REBOUND EVADE!",4)
						Player.BounceTime=0
						Frenzy:+2
						Trk_FrnzGn:+4
					End If
				End If
			End If
		End If
	EndMethod
	
End Type


'-----------------------------------------------------------------------------
'Chaser: Very deliberate, VERY deadly invader
'-----------------------------------------------------------------------------
Type TChaser Extends TObject  
	
	Global List:TList
	Global Variations:Int
	Global ChaserBody:TImage[]
	Global ChaserGlow:TImage[]
	Global ChaosShield:TImage
	Global ChaserRGB:Int[,]
	Global LastSpawn:Int
	Global LastSpawnVariation:Int
	
	Field FrameNum:Float
	Field SpriteNumber:Int
	Field MaxSpeed:Float
	Field PlayerDirection:Int
	Field FlatSpin:Int
	Field XRight#,YRight#,XLeft#,YLeft#
	Field BlurSteps:Float
	
	Function Generate(NumChasers:Int)
		
		List=Null
		
		List = CreateList()
		
		If Not ChaosShield Then ChaosShield=LoadAnimImage(GetBundleResource("graphics/chaosshield.png"),12,3,1,10,MASKEDIMAGE) 
		
		MidHandleImage ChaosShield
		
		SetImageHandle ChaosShield,6,10
		
		Variations=NumChasers
		
		ChaserGlow = New TImage[Variations+1]
		ChaserBody = New TImage[Variations+1]
		ChaserRGB = New Int[Variations+1,3]
		
		For Local i=1 To NumChasers
			
			'Generate and Draw
			GenerateChaser(i)
			
			PrepareFrame(ChaserBody[i])
			PrepareFrame(ChaserGlow[i])
			
		Next
		
	End Function
	
	Function ReCache()
		For Local i=1 To Variations
			PrepareFrame(ChaserBody[i])
			PrepareFrame(ChaserGlow[i])
		Next
	End Function
	
	Function Spawn(X:Int,Y:Int,FastChaser:Int=False)
		Local FailSafe:Int=0
		
		'If Not List List = CreateList()
		
		If PlayerDistance(X,Y)<275 Return
		
		If MilliSecs()-LastSpawn<6000 Return
		
		If Player.Alive
			If CountList(List) => 3 Then Return Null	
		Else
			If CountList(List) => 1 Then Return Null	
		End If
		
		If Rand(1,9)<7 Return
		
		'EnemyCount:+1
		
		Local Chaser:TChaser = New TChaser	 
		List.AddLast Chaser
			
		Repeat 
			Chaser.SpriteNumber=Rand(1,Variations)
			FailSafe:+1
			If FailSafe=8 Exit
		Until Chaser.SpriteNumber<>LastSpawnVariation	
		LastSpawnVariation=Chaser.SpriteNumber
		
		Chaser.X=X
		Chaser.Y=Y
			
		SpawnEffect.Fire(Chaser.X,Chaser.Y,.9,ChaserRGB[Chaser.SpriteNumber,0],ChaserRGB[Chaser.SpriteNumber,1],ChaserRGB[Chaser.SpriteNumber,2])	
		
		Chaser.Direction=Rand(1,360)
		Chaser.MaxSpeed=.96+SpeedGain*.90
		Chaser.XSpeed:+ Cos(Chaser.Direction)/2
		Chaser.YSpeed:+ Sin(Chaser.Direction)/2
		
		PlaySoundBetter Sound_Chaser_Born,X,Y
		
		LastSpawn=MilliSecs()
		
	End Function
	
	Function Preview(X,Y,SpriteNum)
		
		SetBlend alphablend
		SetScale 4,4
		
		DrawImage ChaserBody[SpriteNum],x,y
		SetColor (ChaserRGB[SpriteNum,0]+55,ChaserRGB[SpriteNum,1]+55,ChaserRGB[SpriteNum,2]+55)
		DrawImage ChaosShield,X,Y,2
		SetColor 255,255,255
		SetScale 5,5
		SetBlend lightblend
		DrawImage ChaserGlow[SpriteNum],x,y
		
		SetBlend alphablend
		SetScale 1,1
	End Function
	
	Method DrawBodyGlow()

		SetRotation(Direction+90)
		DrawImage ChaserBody[SpriteNumber],x,y
		If Abs(PlayerDirection)<9
			SetScale (3.1,3.1)
			SetColor (ChaserRGB[SpriteNumber,0]+55,ChaserRGB[SpriteNumber,1]+55,ChaserRGB[SpriteNumber,2]+55)
			DrawImage ChaosShield,x,y,Int(FrameNum+1)
			SetScale (4.3,4.3)
			SetColor (255,255,255)
		End If
			Rem
		SetScale 1,1
		SetRotation 0
		DrawLine ((x-XSpeed),(Y-YSpeed),XRight,YRight)
		DrawLine ((X-XSpeed),(Y-YSpeed),XLeft,YLeft)
		DrawLine (XLeft,YLeft,XRight,YRight)
		End Rem
		
		
	EndMethod

	Method DrawBody()

		SetRotation(Direction+90)
		DrawImage ChaserBody[SpriteNumber],x,y
		If Abs(PlayerDirection)<9
			SetScale (3,3)
			SetColor (ChaserRGB[SpriteNumber,0]+55,ChaserRGB[SpriteNumber,1]+55,ChaserRGB[SpriteNumber,2]+55)
			DrawImage ChaosShield,x,y,Int(FrameNum+1)
			SetScale (4,4)
			SetColor (255,255,255)
		End If
		
		Rem
		SetScale 1,1
		SetRotation 0
		DrawLine ((x-XSpeed),(Y-YSpeed),XRight,YRight)
		DrawLine ((X-XSpeed),(Y-YSpeed),XLeft,YLeft)
		DrawLine (XLeft,YLeft,XRight,YRight)
		End Rem
		
	EndMethod
	
	Method DrawGlow()
		
		SetRotation(Direction+90)
		DrawImage ChaserGlow[SpriteNumber],x,y

	EndMethod
	
	
	Method Update()
		Local distx:Float,Distance:Float,disty:Float, Speed:Float
		
		'Check against Colosions
		Collision()
		
		BlurSteps:+1*Delta
		
		If BlurSteps>54/BlurDivider
			MotionBlur.Spawn(X,Y,Direction+90,4,ChaserGlow[SpriteNumber])
			BlurSteps=0
		End If
		
		'If we hit a shield we are in a flat spin and can't control the vehicle for a short time
		If MilliSecs()-FlatSpin>0
			If Rand(1,815)<15 Then PlayerDirection=TurnToFacePoint(Player.X,Player.Y,x,y,xspeed,yspeed)
			
			If PlayerDirection<>0
			
				Direction:+ Sgn(PlayerDirection)*Delta
				PlayerDirection = PlayerDirection - Sgn(PlayerDirection)
			
			End If
		Else
			Direction:+1*Delta
		End If
		
		If Abs(PlayerDirection)<9
			XSpeed = XSpeed + Cos(Direction)*Delta	
			YSpeed = YSpeed + Sin(Direction)*Delta
		Else
			XSpeed = (XSpeed + Cos(Direction))*(0.265+MaxSpeed/16)*Delta
			YSpeed = (YSpeed + Sin(Direction))*(0.265+MaxSpeed/16)*Delta
		EndIf
		
		'Avoid Other Chasers
		For Local Chaser:TChaser = EachIn List
			If Chaser <> Self
				distx# = Chaser.X-X
				disty# = Chaser.Y-Y
				Distance = (distx * distx + disty * disty)
				If Distance < 27*27  + 27*27
					XSpeed:- Sgn(distx)
					YSpeed:- Sgn(disty)
				EndIf
			EndIf
		Next
		
		'Bounce around the corners
		If x < 8 
			XSpeed = Abs(XSpeed)
			X:+ XSpeed*Delta
			Direction:+ 90
		ElseIf x > FieldWidth-8
			XSpeed = -Abs(XSpeed)
			X:+ XSpeed*Delta
			Direction:+ 90
		EndIf
		If y < 8
			YSpeed = Abs(Yspeed)
			Y:+ YSpeed*Delta
			Direction:+ 90
		ElseIf y > FieldHeight-8
			YSpeed = -Abs(YSpeed)
			Y:+ YSpeed*Delta
			Direction:+ 90
		EndIf
		
		'Limit Chaser Speed
		Speed = Sqr(XSpeed*XSpeed+YSpeed*YSpeed)
		If Speed > MaxSpeed
			XSpeed=XSpeed/Speed*MaxSpeed
			YSpeed=YSpeed/Speed*MaxSpeed
		EndIf		
		X:+ XSpeed*Delta
		Y:+ YSpeed*Delta
		
		FrameNum:+0.1*Delta
		
		If FrameNum=>9 Then FrameNum=0

		Local xn#,yn#
		Local Velocity# = Sqr(XSpeed*XSpeed + YSpeed*YSpeed)
		If Velocity = 0
			xn# = 1
			yn# = 1
		Else
			xn# = -YSpeed/Velocity
			yn# = XSpeed/Velocity
		EndIf
		XRight# = x+yn*30+xn*25
		YRight# = y-xn*30+yn*25
		XLeft# = x+yn*30-xn*25
		YLeft# = y-xn*30-yn*25
		
	EndMethod

	Function DrawAllGlow()
		If Not List Return 
		
		SetScale 4.4,4.4
		
		For Local Chaser:TChaser = EachIn List
			Chaser.DrawBodyGlow()
		Next
		
	EndFunction
	
	Function DrawAll()
		If Not List Return 
		If List.Count()=0 Return
		SetScale 4,4
		

		For Local Chaser:TChaser = EachIn List
			Chaser.DrawBody()
		Next
		
		SetBlend LIGHTBLEND
		SetScale 5,5
		
		For Local Chaser:TChaser = EachIn List
			Chaser.DrawGlow()
		Next
		SetBlend ALPHABLEND
	EndFunction
	
	Function UpdateAll()
		If Not List Return 
		
		For Local Chaser:TChaser = EachIn List
			Chaser.Update()
		Next
	EndFunction

	Method Destroy()
		List.Remove( Self )
	EndMethod
	
	Method DestroyAll()
		If Not List Return 
		
		For Local Chaser:TChaser = EachIn List
			Chaser.Destroy()
		Next
	EndMethod
	
	Function GenerateChaser:TPixmap(Index:Int) Private
		'The amount of White Pixels
		Local PixelCount:Int=0	
		'Stores the Chasers Pixels
		Local ChaserPixels:Int[9,9]
		'Stores the Chasers Colors
		Local ChaserColor[3]
		
		'-----------------MATH GEN ROUTINE-----------------
		
		'As long as there are less than 3 or more than 14 White pixels, redo Chaser
		Repeat
			PixelCount=0
			For Local i=0 To 2
				For Local j=0 To 6
						
					'A Pixel can be either 0 (Black) or 1 (White)
					ChaserPixels[i,j]=Rand(0,1)
						
					'Count the number of White Pixels
					PixelCount:+ChaserPixels[i,j]
						
				Next
				
				'Set the Chasers color
				ChaserColor[i]=Rand(85,195)
				'ChaserColor[i]=Rand(60,130)
				
			Next
				
		Until PixelCount>=16 And PixelCount<=20 
		
		If EasterEgg
			ChaserColor[1]=ChaserColor[0]
			ChaserColor[2]=ChaserColor[0]
		End If
			
		'Mirror Chaser along the Y axis
		For Local m=0 To 6
			ChaserPixels[5,m]=ChaserPixels[0,m]
			ChaserPixels[4,m]=ChaserPixels[1,m]
			ChaserPixels[3,m]=ChaserPixels[2,m]
		Next
		
		'Zero out Upper middle section giving a horsehoe shape
		For Local m=0 To 4
			ChaserPixels[2,m]=0
			ChaserPixels[3,m]=0
			'ChaserPixels[4,m]=0
		Next
		
		
		'-----------------DRAWING ROUTINE-----------------

		Local ChaserPixmap:TPixmap=CreatePixmap(10,11,PF_RGBA8888)
		Local GlowPixmap:TPixmap
		
		ClearPixels (ChaserPixmap)
		
		'Loop through the Chaser's pixel array 
		For Local x=0 To 5
			For Local y=0 To 6
				
				'Proceed to draw the Chaser
				If ChaserPixels[x,y]=1
					
					WritePixel ChaserPixmap,2+x,2+y,ToRGBA(ChaserColor[0],ChaserColor[1],ChaserColor[2],255)
				
				End If
			
			Next
		Next
		
		For Local i=0 To 2
		
			ChaserRGB[index,i]=ChaserColor[i]
		Next
		
		GlowPixmap=CopyPixmap(ChaserPixmap)
		
		ChaserBody[index]=LoadImage(ChaserPixmap,MASKEDIMAGE)
				
		GlowPixmap=GaussianBlur(GlowPixmap,2,220,35,255)
		
		ChaserGlow[index]=LoadImage(GlowPixmap,FILTEREDIMAGE)
		
		ChaserPixmap=Null;GlowPixmap=Null
		
	End Function
	
	Function PrepareFrame(image:TImage) Private
		'Use this to cache an image or animimage in VRAM for quicker drawing later.
		image.Frame(0)
		MidHandleImage Image
	End Function
	
	Function ToRGBA%(r%,g%,b%,a%) Private
		'return (a << 24) | (r << 16) | (g << 8) | (b);
	Return ((A Shl 24) | (R Shl 16) | (G Shl 8) | B)
	
	End Function
	
	Method Collision()
		Local ShotDirection:Float
		
		If Player.Alive And PlayerDistance(X,Y)<ComfortZone
			CloseEncounters:+.175*Delta
		End If
		
		If PlayerDistance(X,Y)<60 And Player.Alive Then
			If Player.HasShield-Player.MaskShield>0
				If Abs(PlayerDirection)<9
					XSpeed=Cos(AwayFrom(X,Y,Player.X,Player.Y))*6
					YSpeed=Sin(AwayFrom(X,Y,Player.X,Player.Y))*6
					X:+XSpeed*2*Delta
					Y:+YSpeed*2*Delta
					PlayerDirection=-Direction
					Direction=AwayFrom(X,Y,Player.X,Player.Y)
					FlatSpin=MilliSecs()+670
					ParticleManager.Create(X,Y,12,180,180,180,AwayFrom(X,Y,Player.X,Player.Y),2)
					Lightning.MassFire(Player.X,Player.Y,26,Rand(1,3),True)
					PlaySoundBetter Sound_Chaser_Surprised,X,Y
				Else
					Glow.MassFire(X,Y,1,2,25,AwayFrom(X,Y,Player.X,Player.Y),ChaserRGB[SpriteNumber,0],ChaserRGB[SpriteNumber,1],ChaserRGB[SpriteNumber,2])
					ParticleManager.Create(X,Y,35,ChaserRGB[SpriteNumber,0],ChaserRGB[SpriteNumber,1],ChaserRGB[SpriteNumber,2],AwayFrom(X,Y,Player.X,Player.Y),1.8)
					Flash.Fire(X,Y,0.4,25)
					Destroy()
					'EnemyCount:-1
					EnemiesKilled:+1
					Player.HasShield:-1
					Trk_Shd:-1
					PlaySoundBetter Sound_Player_Shield_Die,X,Y
				End If
			Else
				If PlayerDistance(X,Y)<50
					Player.Destroy()
					Deathby="Chaser"
				End If
			End If
		End If
		
		If TPlayerBomb.List
			For Local PlayerBomb:TPlayerBomb = EachIn TPlayerBomb.List
				
				If Distance(X,Y,PlayerBomb.X,PlayerBomb.Y) < PlayerBomb.Radius
					
					Glow.MassFire(X,Y,1,2,15,AwayFrom(X,Y,PlayerBomb.X,PlayerBomb.Y),ChaserRGB[SpriteNumber,0],ChaserRGB[SpriteNumber,1],ChaserRGB[SpriteNumber,2])
					ParticleManager.Create(X,Y,20,ChaserRGB[SpriteNumber,0],ChaserRGB[SpriteNumber,1],ChaserRGB[SpriteNumber,2],AwayFrom(X,Y,PlayerBomb.X,PlayerBomb.Y),1.2)
					Flash.Fire(X,Y,0.35,25)
					'Explosion.Fire(X,Y,.55)
					Destroy()
					'EnemyCount:-1
					EnemiesKilled:+1
					
				End If
				
			Next
		End If

		'If a shot hit a rock
		If Not TShot.List Return
		For Local Shot:TShot = EachIn TShot.List
			
			If InTriangle(Shot.X+Shot.XSpeed,Shot.Y+Shot.YSpeed, (X-XSpeed), (Y-YSpeed), XRight,YRight,XLeft,YLeft) And Abs(PlayerDirection)<8
				
				Shot.EnemyDestroy(True)
				
			End If
			
			If Distance( X, Y, Shot.X, Shot.Y ) < 22
				
				Local TempScore:Int, SniperShot=False
				
				PlaySoundBetter Sound_Explosion,X,Y
				If Rand(26+ExtraLikeliness,45)=42 Then Powerup.Spawn(x,y,Rand(0,8))
				TempScore=EvenScore(295*Multiplier*ScoreMultiplier)
				Glow.MassFire(X,Y,1,2.1,35,Shot.Direction-90,ChaserRGB[SpriteNumber,0],ChaserRGB[SpriteNumber,1],ChaserRGB[SpriteNumber,2])
				ParticleManager.Create(X,Y,45,ChaserRGB[SpriteNumber,0],ChaserRGB[SpriteNumber,1],ChaserRGB[SpriteNumber,2],0,1.3)
			
				Shot.EnemyDestroy()
				Flash.Fire(X,Y,.75,10)
				'Debris.MassFire (X,Y,1,1,11,1)
				Explosion.Fire(X,Y,.75)
		
				'Did the player shoot - or the AI?
				If Shot.Shooter=1 Then
					'Sniper Shot
					If Player.LastShotFired-Player.PrevShotFired>575 Then
						'Print "time req. met! "+(Player.LastShotFired-Player.PrevShotFired)
						If Distance( X, Y, Player.X, Player.Y) >305 Then
							'Print "almost"
							If IsVisible(x,y,15) 
								'Print "Sniper!"+Distance( X, Y, Player.X, Player.Y )
								ScoreRegister.Fire(x,y,TempScore,"2x")
								Tempscore:*2
								SniperShot=True
								Score:+Tempscore
							End If
						End If
					End If
					
					'No Sniper Shot? But still a Player shot?
					If Not SniperShot And Shot.Shooter=1  Then
						Score:+TempScore
						ScoreRegister.Fire(x,y,TempScore)	
					End If
					
					'General Kill Stuff
					EnemiesKilled:+1
					If TempScore>LargestScore Then LargestScore=TempScore
				End If
				
				'Destroy the Chaser, at last
				Destroy()
				Shot.EnemyDestroy()
				'EnemyCount:-1
				Exit
			EndIf
		Next	
	EndMethod
End Type

'-----------------------------------------------------------------------------
'Thief: A sneaky invader that steals your extras
'-----------------------------------------------------------------------------
Type TThief Extends TObject  
	
	
	Global List:TList
	Global Variations:Int
	Global ThiefBody:TImage[]
	Global ThiefBodyHit:TImage[]
	Global ThiefGlow:TImage[]
	Global PowerUpImage:TImage
	Global BeamImage:TImage
	Global ThiefRGB:Int[,]
	Global LastSpawnVariation:Int
	Global LastSpawn:Int
	
	Field SpriteNumber:Int
	Field MaxSpeed:Float
	Field Fearless:Byte
	Field PlayerDirection:Int
	Field RunAway:Byte
	Field GotExtra:Byte
	Field ExtraType:Int=-1
	Field CornerX:Int
	Field CornerY:Int
	Field XRight#,YRight#,XLeft#,YLeft#,xdir#,ydir#
	Field BlurSteps:Float
	Field HurtSteps:Float
	Field Stealing:Byte
	Field StealTime:Float
	Field Hurt:Byte
	Field FlashOnce:Byte
	Field PainFlash:Float
	
	Const SHOT = 0
	Const FASTERSHOT = 1
	Const SHOTINTERVAL = 3
	Const SHIELD = 5
	Const BOMB = 6
	Const ENGINEBOOST = 8
	
	Function Generate(NumThiefs:Int)
		
		List=Null
		
		List = CreateList()
		
		If Not PowerUpImage
			PowerUpImage = LoadAnimImage(GetBundleResource("Graphics/powerups.png"),39,39,0,9,FILTEREDIMAGE)
			SetImageHandle PowerUpImage,19.5,55
			
			BeamImage= LoadImage(GetBundleResource("Graphics/particle.png"),FILTEREDIMAGE)
			MidHandleImage BeamImage
		
		End If
		
		Variations=NumThiefs
		
		ThiefGlow = New TImage[Variations+1]
		ThiefBody = New TImage[Variations+1]
		ThiefBodyHit = New TImage[Variations+1]
		ThiefRGB = New Int[Variations+1,3]
		
		For Local i=1 To NumThiefs
			
			'Generate and Draw
			GenerateThief(i)
			
			PrepareFrame(ThiefBody[i])
			PrepareFrame(ThiefBodyHit[i])
			PrepareFrame(ThiefGlow[i])
			
		Next
		
	End Function
	
	Function ReCache()
		For Local i=1 To Variations
			PrepareFrame(ThiefBody[i])
			PrepareFrame(ThiefBodyHit[i])
			PrepareFrame(ThiefGlow[i])
		Next
	End Function
	
	Function Spawn(X:Int,Y:Int,FearlessThief:Int=False)
		Local FailSafe:Int=0
		
		'If Not List List = CreateList()
		
		If MilliSecs()-LastSpawn<8650 Return
		
		If Player.Alive
			If CountList(List) => 1 Then Return Null	
		Else
			If CountList(List) => 1 Then Return Null	
		End If
		
		If Rand(1,9)<8 Return
		
		'EnemyCount:+1
		
		Local Thief:TThief = New TThief	 
		List.AddLast Thief
		
		Repeat 
			Thief.SpriteNumber=Rand(1,Variations)
			FailSafe:+1
			If FailSafe=8 Exit
		Until Thief.SpriteNumber<>LastSpawnVariation
			
		LastSpawnVariation=Thief.SpriteNumber
		
		Thief.X=X
		Thief.Y=Y
		
		Thief.GotExtra=False
		Thief.ExtraType=-1
		
		SpawnEffect.Fire(Thief.X,Thief.Y,.9,ThiefRGB[Thief.SpriteNumber,0],ThiefRGB[Thief.SpriteNumber,1],ThiefRGB[Thief.SpriteNumber,2])	
		
		LastSpawn=MilliSecs()
		
		Thief.Direction=Rand(1,360)
		Thief.MaxSpeed=1.08+SpeedGain*.35
		'Thief.MaxSpeed=.865
		Thief.XSpeed:+ Cos(Thief.Direction)/2
		Thief.YSpeed:+ Sin(Thief.Direction)/2
		Thief.FearLess=FearLessThief
		
		If FearLessThief Thief.MaxSpeed=1.1+SpeedGain*.7
		
		PlaySoundBetter Sound_Thief_Born,X,Y
		
	End Function
	
	Function Preview(X,Y,SpriteNum)
		
		SetBlend alphablend
		SetScale 4,4
		
		DrawImage ThiefBody[SpriteNum],x,y

		SetScale 5,5
		SetBlend lightblend
		DrawImage ThiefGlow[SpriteNum],x,y
		
		SetBlend alphablend
		SetScale 1,1
	End Function
	
	Method DrawBodyGlow()

		SetRotation(Direction+90)
		DrawImage ThiefBody[SpriteNumber],x,y
		
		If Stealing And Player.Alive
			DrawStealShine()
		End If
		
		If PainFlash>0
			SetAlpha PainFlash
			DrawImage ThiefBodyHit[SpriteNumber],x,y
			SetAlpha 1
		End If
			Rem
		SetScale 1,1
		SetRotation 0
		DrawLine ((x-XSpeed),(Y-YSpeed),XRight,YRight)
		DrawLine ((X-XSpeed),(Y-YSpeed),XLeft,YLeft)
		DrawLine (XLeft,YLeft,XRight,YRight)
		End Rem
		
		
	EndMethod

	Method DrawBody()

		SetRotation(Direction+90)
		DrawImage ThiefBody[SpriteNumber],x,y
		If GotExtra
			SetScale 1,1
			DrawImage PowerUpImage,X,Y,ExtraType
			SetScale 4,4
		End If
		
		If Stealing And Player.Alive
			DrawStealShine()
		End If
		
		If PainFlash>0
			SetAlpha PainFlash
			DrawImage ThiefBodyHit[SpriteNumber],x,y
			SetAlpha 1
		End If
		
		
		'Draw Player LOS
		Rem
		SetScale 1,1
		SetRotation 0
		DrawLine ((Player.x-Player.XSpeed),(Player.Y-Player.YSpeed),XRight,YRight)
		DrawLine ((Player.X-Player.XSpeed),(Player.Y-Player.YSpeed),XLeft,YLeft)
		DrawLine (XLeft,YLeft,XRight,YRight)
		SetColor 255,0,0
		DrawRect (XLeft,YLeft,8,8)
		DrawRect (XRight,YRight,8,8)
		
		DrawRect(Player.X-Cos(Player.Direction)*50,Player.Y-Sin(Player.Direction)*50,8,8)
	
		SetColor 255,255,255
		End Rem
		
	EndMethod
	
	Method DrawGlow()
		
		SetRotation(Direction+90)
		DrawImage ThiefGlow[SpriteNumber],x,y

	EndMethod
	

	
	Method DrawStealShine()
		
		SetColor ThiefRGB[SpriteNumber,0]*1.25,ThiefRGB[SpriteNumber,1]*1.25,ThiefRGB[SpriteNumber,2]*1.25
		SetTransform -ATan2((Player.X-X),(Player.Y-Y))+90,3.5,1.25
		DrawImage BeamImage,(X+Player.X)/2,(Y+Player.Y)/2
		DrawImage BeamImage,(X+Player.X)/2,(Y+Player.Y)/2
		SetColor 255,255,255
		
	End Method

	Method Steal()
		
		If Not Player.Alive Return
		
		For Local i=1 To 10
		
			Local Temp:Int=Rand(0,6)
			Select Temp
			
				Case 1
					If Player.HasShot-Player.MaskShot>0
						Player.HasShot:-1
						ExtraType=Shot
						Exit
					End If
					
				Case 2
					If Player.ShotSpeed>4.5
						Player.ShotSpeed:-.75
						ExtraType=FASTERSHOT
						Exit
					End If
					
				Case 3
					If Player.ShotInterval<175 And Frenzymode<=0
						Player.ShotInterval:+20
						ExtraType=SHOTINTERVAL
						Exit
					End If
					
				Case 4
					If Player.HasBomb-Player.MaskBomb>0
						Player.HasBomb:-1
						ExtraType=BOMB
						Exit
					End If
					
				Case 5
					If Player.EngineBoost>0
						Player.EngineBoost:-0.00225
						ExtraType=ENGINEBOOST
						If Player.EngineBoost<0 Player.EngineBoost=0
						Exit
					End If
			End Select
		
		Next
	End Method
	
	
	Method ChoseCorner()
		
		If CornerX=0 And CornerY=0
		
			Repeat
		
				Local TempVar=Rand(1,4)
			
				Select TempVar
				
					Case 1
						CornerX=Rand(25,75)
						CornerY=Rand(25,75)
				
					Case 2
						CornerX=Rand(FieldWidth-25,FieldWidth-75)
						CornerY=Rand(25,75)
				
					Case 3
						CornerX=Rand(25,75)
						CornerY=Rand(FieldHeight-25,FieldHeight-75)
						
					Case 4
						CornerX=Rand(FieldWidth-25,FieldWidth-75)
						CornerY=Rand(FieldHeight-25,FieldHeight-75)
				
				End Select
			
			Until Distance(CornerX,CornerY,X,Y)>150 And Distance(CornerX,CornerY,Player.X,Player.Y)>200
			
		End If
	End Method
	
	
	Method Update()
		Local distx:Float,ThiefDistance:Float,disty:Float, Speed:Float
		
		'Check against Colosions
		Collision()
		
		BlurSteps:+1*Delta
		HurtSteps:+1*Delta
		
		If HurtSteps>28
			HurtSteps=0
		End If
		
		If BlurSteps>28/BlurDivider
			MotionBlur.Spawn(X,Y,Direction+90,4,ThiefGlow[SpriteNumber])
			BlurSteps=0
		End If
		
		If ParticleMultiplier>=1
			If HurtSteps>16 And HurtSteps<18 And Hurt
				Glow.MassFire(X,Y,1,2.1,1,Rand(Direction-10,Direction+10),ThiefRGB[SpriteNumber,0],ThiefRGB[SpriteNumber,1],ThiefRGB[SpriteNumber,2],False,True)
			End If
		Else
			If HurtSteps>16 And HurtSteps<16.5 And Hurt
				Glow.MassFire(X,Y,1,2.1,1,Rand(Direction-10,Direction+10),ThiefRGB[SpriteNumber,0],ThiefRGB[SpriteNumber,1],ThiefRGB[SpriteNumber,2],False,True)
			End If
		End If
		
		'Flash the thief to indicate the player got a hit in
		If Hurt And PainFlash<1 And FlashOnce=False
			PainFlash:+0.225*Delta
		ElseIf Hurt And PainFlash>1 And FlashOnce=False
			FlashOnce=True
		ElseIf Hurt And FlashOnce
			If PainFlash=>0 PainFlash:-0.05*Delta
		End If
		
		Local PredictX:Float
		Local PredictY:Float
			
		PredictX=Player.X-Cos(Player.Direction)*45
		PredictY=Player.Y-Sin(Player.Direction)*45
			
		If RunAway=False And GotExtra=False
			PlayerDirection=TurnToFacePoint(PredictX,PredictY,X,Y,XSpeed,YSpeed)
		ElseIf GotExtra And RunAway=False
			PlayerDirection=TurnToFacePoint(CornerX,CornerY,X,Y,XSpeed,YSpeed)
		End If
		
		'If we have the extra and are at our predetermined safe spot, teleport out
		If GotExtra And Distance(X,Y,CornerX,CornerY)<10
			Flash.Fire(X,Y,.85,45)
			SpawnEffect.Fire(X,Y,1.3,ThiefRGB[SpriteNumber,0],ThiefRGB[SpriteNumber,1],ThiefRGB[SpriteNumber,2])	
			For Local i=1 To 4
				MotionBlur.Spawn(X,Y,Direction+90,4,ThiefGlow[SpriteNumber],True)
				MotionBlur.Spawn(X,Y,Direction+90,4,ThiefBody[SpriteNumber],True)
				MotionBlur.Spawn(X,Y,Direction+90,1,PowerUpImage,True,ExtraType)
			Next
			
			'Soundeffect ThiefLaugh
			Destroy()
			
		End If
		
		If PlayerDirection<>0 
			
			Direction:+ Sgn(PlayerDirection)*Delta
			PlayerDirection = PlayerDirection - Sgn(PlayerDirection)
			
		End If
		
		Local xn#,yn#
		XDir#=Cos(Player.Direction)*4
		YDir#=Sin(Player.Direction)*4
		
		Local Velocity# = Sqr(XDir*XDir + YDir*YDir)
		If Velocity = 0
			xn# = 1
			yn# = 1
		Else
			xn# = -YDir/Velocity
			yn# = XDir/Velocity
		EndIf
		
		'When we have the extra the LOS decreases, the thief now only cares about going home
		If Not FearLess
			If Not GotExtra
				XRight# = Player.x+yn*350+xn*170
				YRight# = Player.y-xn*350+yn*170
				XLeft# = Player.x+yn*350-xn*170
				YLeft# = Player.y-xn*350-yn*170
			Else
				XRight# = Player.x+yn*50+xn*45
				YRight# = Player.y-xn*50+yn*45
				XLeft# = Player.x+yn*50-xn*45
				YLeft# = Player.y-xn*50-yn*45
			EndIf
		Else
			If Not GotExtra
				XRight# = Player.x+yn*110+xn*70
				YRight# = Player.y-xn*110+yn*70
				XLeft# = Player.x+yn*110-xn*70
				YLeft# = Player.y-xn*110-yn*70
			Else
				XRight# = 0
				YRight# = 0
				XLeft# = 0
				YLeft# = 0
			EndIf
		End If
		'Avoid the players line of sight at all cost
		If InTriangle(X,Y, (Player.X-Player.XSpeed), (Player.Y-Player.YSpeed), XRight,YRight,XLeft,YLeft) 
			
			Local DistanceLeft:Float
			Local DistanceRight:Float
			
			'Find out which way is the quickest to escape the LOS
			DistanceRight=Distance(X,Y,XRight,YRight)
			DistanceLeft=Distance(X,Y,XLeft,YLeft)
			
			If DistanceLeft>DistanceRight And RunAway<=0 And GotExtra=False
				
				'Strafe Left
				PlayerDirection:+90+ATan2(X-Player.X,Y-Player.Y)/4
				RunAway=MilliSecs()+850
				
			ElseIf DistanceLeft<DistanceRight And RunAway<=0 And GotExtra=False
				
				'Strafe Right
				PlayerDirection:-90+ATan2(X-Player.X,Y-Player.Y)/4
				RunAway=MilliSecs()+850
			
			End If
		Else 
		
			If RunAway<>0 And MilliSecs()-RunAway>0 RunAway=0
				
		End If
		
		If Abs(PlayerDirection)<10
			XSpeed = XSpeed + Cos(Direction)*Delta	
			YSpeed = YSpeed + Sin(Direction)*Delta
		Else
			XSpeed = (XSpeed + Cos(Direction))*(0.265+MaxSpeed/16)*Delta
			YSpeed = (YSpeed + Sin(Direction))*(0.265+MaxSpeed/16)*Delta
		EndIf
		
		'Avoid Other Thieves
		For Local Thief:TThief = EachIn List
			If Thief <> Self
				distx# = Thief.X-X
				disty# = Thief.Y-Y
				ThiefDistance = (distx * distx + disty * disty)
				If ThiefDistance < 26*26  + 26*26
					XSpeed:- Sgn(distx)
					YSpeed:- Sgn(disty)
				EndIf
			EndIf
		Next
		
		'If we have the extra avoid the player too, dying now would be stupid
		If GotExtra
			distx# = Player.X-X
			disty# = Player.Y-Y
			ThiefDistance = (distx * distx + disty * disty)
			If ThiefDistance < 52*52  + 52*52
				XSpeed:- Sgn(distx)*.85
				YSpeed:- Sgn(disty)*.85
			EndIf
		End If
		
		'Bounce around the corners
		If x < 12 
			XSpeed = Abs(XSpeed)
			X:+ XSpeed*Delta
			Direction:+ 90
		ElseIf x > FieldWidth-12
			XSpeed = -Abs(XSpeed)
			X:+ XSpeed*Delta
			Direction:+ 90
		EndIf
		If y < 12
			YSpeed = Abs(Yspeed)
			Y:+ YSpeed*Delta
			Direction:+ 90
		ElseIf y > FieldHeight-12
			YSpeed = -Abs(YSpeed)
			Y:+ YSpeed*Delta
			Direction:+ 90
		EndIf
		
		'Limit Thief Speed
		Speed = Sqr(XSpeed*XSpeed+YSpeed*YSpeed)
		If RunAway=False And GotExtra=False And Speed > MaxSpeed
			XSpeed=XSpeed/Speed*MaxSpeed
			YSpeed=YSpeed/Speed*MaxSpeed
		ElseIf RunAway And GotExtra=False And Speed>MaxSpeed*1.3
			XSpeed=XSpeed/Speed*MaxSpeed*1.3
			YSpeed=YSpeed/Speed*MaxSpeed*1.3
		ElseIf GotExtra And Speed>MaxSpeed*1.05
			XSpeed=XSpeed/Speed*MaxSpeed*1.05
			YSpeed=YSpeed/Speed*MaxSpeed*1.05
		EndIf
				
		X:+ XSpeed*Delta
		Y:+ YSpeed*Delta
		
		If PlayerDistance(X,Y)<92 And PlayerDistance(X,Y)>86 And GotExtra=False
			Stealing=True
		ElseIf PlayerDistance(X,Y)<86 And GotExtra=False
			If StealTime>25 Steal()
			If ExtraType<>-1
				'We got an extra - time to run away
				Stealing=False
				GotExtra=True
				PlayerDirection:-180
				Direction:-140
				RunAway=MilliSecs()+1150
				ChoseCorner()
				'ParticleManager.Create(X,Y,45,200,200,200,AwayFrom(X,Y,Player.X,Player.Y),2)
				Glow.MassFire(Player.X,Player.Y,1,2,25,0,Player.RGB[0],Player.RGB[1],Player.RGB[2],True)
				Flash.Fire((X+Cos(Direction-5)*22), (Y+Sin(Direction-5)*22),0.4,20)
				PlaySoundBetter Sound_Thief_Steal,X,Y
			Else
				'Ram the player in frustration if he has no extra
				XSpeed=XSpeed*15
				YSpeed=YSpeed*15
				RunAway=False
			End If
			StealTime:+.5*Delta
			XSpeed=XSpeed/10
			YSpeed=YSpeed/10
		ElseIf PlayerDistance(X,Y)>92
			Stealing=False
		End If
		
	EndMethod

	Function DrawAllGlow()
		If Not List Return 
		
		SetScale 4.4,4.4
		
		For Local Thief:TThief = EachIn List
			Thief.DrawBodyGlow()
		Next
		
	EndFunction
	
	Function DrawAll()
		If Not List Return 
		If List.Count()=0 Return
		SetScale 4,4
		

		For Local Thief:TThief = EachIn List
			Thief.DrawBody()
		Next
		
		SetBlend LIGHTBLEND
		SetScale 5,5
		
		For Local Thief:TThief = EachIn List
			Thief.DrawGlow()
		Next
		SetBlend ALPHABLEND
	EndFunction
	
	Function UpdateAll()
		If Not List Return 
		
		For Local Thief:TThief = EachIn List
			Thief.Update()
		Next
	EndFunction

	Method Destroy()
		List.Remove( Self )
	EndMethod
	
	Method DestroyAll()
		If Not List Return 
		
		For Local Thief:TThief = EachIn List
			Thief.Destroy()
		Next
	EndMethod
	
	Function GenerateThief:TPixmap(Index:Int) Private
		'The amount of White Pixels
		Local PixelCount:Int=0	
		'Stores the Thiefs Pixels
		Local ThiefPixels:Int[9,9]
		'Stores the Thiefs Colors
		Local ThiefColor[3]
		
		'-----------------MATH GEN ROUTINE-----------------
		
		'As long as there are less than 3 or more than 14 White pixels, redo Thief
		Repeat
			PixelCount=0
			For Local i=1 To 3
				For Local j=0 To 7
						
					'A Pixel can be either 0 (Black) or 1 (White)
					ThiefPixels[i,j]=Rand(0,1)
						
					'Count the number of White Pixels
					PixelCount:+ThiefPixels[i,j]
						
				Next
				
				'Set the Thiefs color
				ThiefColor[i-1]=Rand(60,145)
				'ThiefColor[i]=Rand(60,130)
				
			Next
				
		Until PixelCount>=19 And PixelCount<=27 
		
		If EasterEgg
			ThiefColor[1]=ThiefColor[0]
			ThiefColor[2]=ThiefColor[0]
		End If
			
		'Mirror Thief along the Y axis
		For Local m=0 To 8
			ThiefPixels[6,m]=ThiefPixels[1,m]
			ThiefPixels[5,m]=ThiefPixels[2,m]
			ThiefPixels[4,m]=ThiefPixels[3,m]
		Next
		
		'Add the Bulge in the middle
		For Local n=0 To 7
			
			ThiefPixels[n,2]=1
			ThiefPixels[n,3]=1
			ThiefPixels[n,4]=1
			
		Next

		'Zero out Upper middle section giving a horsehoe shape
		For Local m=0 To 6 Step 2
			ThiefPixels[2,m]=0
			ThiefPixels[3,m]=0
			ThiefPixels[4,m]=0
			ThiefPixels[5,m]=0
		Next
		
		If Rand(0,1)
		For Local m=0 To 3

			ThiefPixels[3,m]=0
			ThiefPixels[4,m]=0
		Next
		End If
		
		'-----------------DRAWING ROUTINE-----------------

		Local ThiefPixmap:TPixmap=CreatePixmap(12,13,PF_RGBA8888)
		Local GlowPixmap:TPixmap
		Local ThiefHitPixmap:TPixmap=CreatePixmap(12,13,PF_RGBA8888)
		
		ClearPixels (ThiefPixmap)
		ClearPixels (ThiefHitPixmap)
		
		'Loop through the Thief's pixel array 
		For Local x=0 To 7
			For Local y=0 To 7
				
				'Proceed to draw the Thief
				If ThiefPixels[x,y]=1
					
					WritePixel ThiefPixmap,2+x,2+y,ToRGBA(ThiefColor[0],ThiefColor[1],ThiefColor[2],255)
					WritePixel ThiefHitPixmap,2+x,2+y,ToRGBA(255,255,255,255)
					
				End If
			
			Next
		Next
		
		For Local i=0 To 2
		
			ThiefRGB[index,i]=ThiefColor[i]
		Next
		
		GlowPixmap=CopyPixmap(ThiefPixmap)
		
		ThiefBody[index]=LoadImage(ThiefPixmap,MASKEDIMAGE)
		
		ThiefBodyHit[index]=LoadImage(ThiefHitPixmap,MASKEDIMAGE)
				
		GlowPixmap=GaussianBlur(GlowPixmap,2,220,35,255)
		
		ThiefGlow[index]=LoadImage(GlowPixmap,FILTEREDIMAGE)
		
		ThiefPixmap=Null;GlowPixmap=Null;ThiefHitPixmap=Null
		
	End Function
	
	Function PrepareFrame(image:TImage) Private
		'Use this to cache an image or animimage in VRAM for quicker drawing later.
		image.Frame(0)
		MidHandleImage Image
	End Function
	
	Function ToRGBA%(r%,g%,b%,a%) Private
		'return (a << 24) | (r << 16) | (g << 8) | (b);
	Return ((A Shl 24) | (R Shl 16) | (G Shl 8) | B)
	
	End Function
	
	Method Collision()
		Local ShotDirection:Float
		
		If Player.Alive And PlayerDistance(X,Y)<ComfortZone
			CloseEncounters:+.1*Delta
		End If
		
		If PlayerDistance(X,Y)<60 And Player.Alive Then
			If Player.HasShield-Player.MaskShield>0
				Glow.MassFire(X,Y,1,2,25,AwayFrom(X,Y,Player.X,Player.Y),ThiefRGB[SpriteNumber,0],ThiefRGB[SpriteNumber,1],ThiefRGB[SpriteNumber,2])
				ParticleManager.Create(X,Y,35,ThiefRGB[SpriteNumber,0],ThiefRGB[SpriteNumber,1],ThiefRGB[SpriteNumber,2],AwayFrom(X,Y,Player.X,Player.Y),1.4)
				Flash.Fire(X,Y,0.4,25)
				Destroy()
				'EnemyCount:-1
				EnemiesKilled:+1
				Player.HasShield:-1
				Trk_Shd:-1
				If GotExtra Then
					PowerUp.Spawn((X+Cos(Direction)*25), (Y+Sin(Direction)*25),ExtraType,True)
				End If
				PlaySoundBetter Sound_Player_Shield_Die,X,Y
			ElseIf PlayerDistance(X,Y)<40
				Player.Destroy()
				If Not FearLess
					Deathby="Thief"
				Else
					Deathby="Advanced Thief"
				End If
			End If
		End If
		
		If TPlayerBomb.List
			For Local PlayerBomb:TPlayerBomb = EachIn TPlayerBomb.List
				
				If Distance(X,Y,PlayerBomb.X,PlayerBomb.Y) < PlayerBomb.Radius
					
					Glow.MassFire(X,Y,1,2,15,AwayFrom(X,Y,PlayerBomb.X,PlayerBomb.Y),ThiefRGB[SpriteNumber,0],ThiefRGB[SpriteNumber,1],ThiefRGB[SpriteNumber,2])
					ParticleManager.Create(X,Y,20,ThiefRGB[SpriteNumber,0],ThiefRGB[SpriteNumber,1],ThiefRGB[SpriteNumber,2],AwayFrom(X,Y,PlayerBomb.X,PlayerBomb.Y),1.2)
					Flash.Fire(X,Y,0.3,25)
					'Explosion.Fire(X,Y,.55)
					Destroy()
					'EnemyCount:-1
					EnemiesKilled:+1
					If GotExtra Then
						PowerUp.Spawn((X+Cos(Direction)*25), (Y+Sin(Direction)*25),ExtraType,True)
					End If
				
				End If
				
			Next
		End If

		'If a shot hit a Thief
		If Not TShot.List Return
		For Local Shot:TShot = EachIn TShot.List
			
			If Distance( X, Y, Shot.X, Shot.Y ) < 25
				
				Local TempScore:Int, SniperShot=False
				
			
				Shot.EnemyDestroy()
				If Hurt=0
				
					Glow.MassFire(X,Y,1,2.1,8,0,ThiefRGB[SpriteNumber,0],ThiefRGB[SpriteNumber,1],ThiefRGB[SpriteNumber,2],True,True)
					ParticleManager.Create(X,Y,5,ThiefRGB[SpriteNumber,0],ThiefRGB[SpriteNumber,1],ThiefRGB[SpriteNumber,2],0,0.9)
					PlaySoundBetter Sound_Player_ShotHit,X,Y
					
				End If
				
				Hurt:+1
				
				If PainFlash>0 And Player.HasSuper=False
					Shot.EnemyDestroy()
					Return
				End If
				If Hurt<2 Return
				
				PlaySoundBetter Sound_Explosion,X,Y
				'If Rand(28+ExtraLikeliness,45)=42 Then Powerup.Spawn(x,y,Rand(0,9))
				If GotExtra Then
					PowerUp.Spawn((X+Cos(Direction)*25), (Y+Sin(Direction)*25),ExtraType,True)
				Else
					If Rand(2+ExtraLikeliness,68)=42 Then Powerup.Spawn(x,y,Rand(0,9))
				End If
				
				TempScore=EvenScore(250*Multiplier*ScoreMultiplier)
				Glow.MassFire(X,Y,1,2.1,35,Shot.Direction-90,ThiefRGB[SpriteNumber,0],ThiefRGB[SpriteNumber,1],ThiefRGB[SpriteNumber,2])
				ParticleManager.Create(X,Y,45,ThiefRGB[SpriteNumber,0],ThiefRGB[SpriteNumber,1],ThiefRGB[SpriteNumber,2],0,1.3)
				
				Flash.Fire(X,Y,.75,10)
				'Debris.MassFire (X,Y,1,1,11,1)
				Explosion.Fire(X,Y,.65)
		
				'Did the player shoot - or the AI?
				If Shot.Shooter=1 Then
					'Sniper Shot
					If Player.LastShotFired-Player.PrevShotFired>575 Then
						'Print "time req. met! "+(Player.LastShotFired-Player.PrevShotFired)
						If Distance( X, Y, Player.X, Player.Y) >305 Then
							'Print "almost"
							If IsVisible(x,y,15) 
								'Print "Sniper!"+Distance( X, Y, Player.X, Player.Y )
								ScoreRegister.Fire(x,y,TempScore,"2x")
								Tempscore:*2
								SniperShot=True
								Score:+Tempscore
							End If
						End If
					End If
					
					'No Sniper Shot? But still a Player shot?
					If Not SniperShot And Shot.Shooter=1  Then
						If FrenzyMode
							Score:+TempScore*2
							ScoreRegister.Fire(x,y,TempScore,"2x")
						Else
							Score:+TempScore
							ScoreRegister.Fire(x,y,TempScore)
						End If	
					End If
					
					'General Kill Stuff
					EnemiesKilled:+1
					If TempScore>LargestScore Then LargestScore=TempScore
				End If
				
				'Destroy the Thief, at last
				Destroy()
				Shot.EnemyDestroy()
				'EnemyCount:-1
				Exit
			EndIf
		Next	
	EndMethod
End Type



'-----------------------------------------------------------------------------
'A Snake - slow but deadly, obstructing the playfield
'-----------------------------------------------------------------------------
Type TSnake Extends TObject
	
	Const Segments:Int=20
	Field IsHead:Int
	Field Tail:TSnake
	Field Length:Int
	Field Head:TSnake
	Field RotationDirection:Int
	Field Dying:Byte=False
	Field SilentDeath:Byte=False
	Field CountDown:Int=0
	Field BlurSteps:Float
	'Field SpeedFactor:Float
	
	Global SegmentDirection:Int = 20
	Global List:TList

	Global Variations:Int
	Global SnakeBody:TImage[]
	Global SnakeHeadGlow:TImage[]
	Global SnakeBodyGlow:TImage[]
	Global SnakeHead:TImage[]
	
	Global BodyRGB:Int[,]
	Global HeadRGB:Int[,]
	Field SpriteNumber:Int
	
	Field MaxSpeed:Float=1.0


	Function Spawn:TSnake( x:Float, y:Float, SnakeLength:Int, RotationRange:Int=0, HeadX:Float=0,HeadY:Float=0,SpriteNumber:Int=0,QueueSpawn:Int=False)	
		Local Factor:Float
		Local Snake:TSnake = New TSnake
		Local NewDirectionX:Int = 0
		Local NewDirectionY:Int = 0
				
		If Player.Alive
			If CountList(List) => 7*20 And QueueSpawn Then Return Null	
		Else
			If CountList(List) => 60  And QueueSpawn Then Return Null	
		End If
		
		Snake.X = X
		Snake.Y = Y
		Snake.Direction = Rand(0,359)
		Snake.Length = Snakelength
		'Some Snakes are faster than others
		'If QueueSpawn And Rand(0,5)>4 Then Snake.SpeedFactor:+1
		'Print SpeedGain*1.75
		Snake.MaxSpeed=.75+SpeedGain*1.75

		If SpriteNumber=0
			Snake.SpriteNumber=Rand(1,Variations)
		Else
			Snake.SpriteNumber=SpriteNumber
		End If
		
		If QueueSpawn 
			SpawnEffect.Fire(X,Y,1.2,BodyRGB[Snake.SpriteNumber,0],BodyRGB[Snake.SpriteNumber,1],BodyRGB[Snake.SpriteNumber,2])	
			PlaySoundBetter Sound_Snake_Born,X,Y
			'EnemyCount:+1
		End If
		
		If SnakeLength = Segments
			Snake.IsHead = True
			Snake.Head = Null
			Snake.Direction = Snake.Direction
			Snake.RotationDirection = Rand(0,1)
			Factor# = Rnd(0.5,2)
			Snake.XSpeed = Cos(Snake.Direction)*Factor
			Snake.YSpeed = Sin(Snake.Direction)*Factor
		Else
			Snake.IsHead = False		
			Snake.XSpeed = HeadX
			Snake.YSpeed = HeadY
		EndIf
		If SnakeLength > 0
			If SnakeLength Mod 3 = 0 If Rand(0,1) = 1 SegmentDirection = -SegmentDirection 
			Snake.Tail = Snake.Spawn(X+NewDirectionX,Y+NewDirectionY,SnakeLength-1, Snake.Direction+SegmentDirection, -NewDirectionX , -NewDirectionY,Snake.SpriteNumber )
			Snake.Tail.Head = Snake
		Else
			Snake.Tail = Null
		EndIf			
		List.AddLast Snake 
		Return Snake
	EndFunction
	
	Method Update()
		Local Speed:Float, DistX:Float,DistY:Float,Distance:Float
		
		Direction:+ .35*Delta
		
		If Dying=True
			If Tail <> Null
				Tail.Dying = True
				Tail.CountDown=CountDown+25
			EndIf
			If CountDown<=0
				Explode()
			End If
		EndIf
		If CountDown>0 CountDown:-1*Delta
		If head <> Null
			
			BlurSteps:+1*Delta
		
			If BlurSteps>64/BlurDivider
				MotionBlur.Spawn(X,Y,Direction+90,4,SnakeBodyGlow[SpriteNumber])
				BlurSteps=0
			End If

			DistX = Head.x-x
			DistY = Head.y-y
			Distance = Sqr(distx * distx + disty * disty)
			If Distance > 22
				XSpeed = distx/Distance*MaxSpeed
				YSpeed = disty/Distance*MaxSpeed
			Else
				If Distance = 0 Then Distance = 0.001
				XSpeed = distx/Distance/30
				YSpeed = disty/Distance/30
			EndIf
		EndIf				
		If IsHead
		
			BlurSteps:+1*Delta
		
			If BlurSteps>64/BlurDivider
				MotionBlur.Spawn(X,Y,Direction+90,4,SnakeHeadGlow[SpriteNumber])
				BlurSteps=0
			End If
		
			XSpeed:+ Cos(Direction)*MaxSpeed
			YSpeed:+ Sin(Direction)*MaxSpeed
			If RotationDirection = 0 
				Direction:+ 2*Delta
			Else
				Direction:- 2*Delta
			EndIf
			If Rand(1,100) > 92 Then RotationDirection = 1 - RotationDirection		
		EndIf		

		Speed = Sqr(XSpeed*XSpeed+YSpeed*YSpeed)
		If Speed > MaxSpeed
			XSpeed=XSpeed/Speed*MaxSpeed
			YSpeed=YSpeed/Speed*MaxSpeed
		EndIf		
		X:+ XSpeed*Delta
		Y:+ YSpeed*Delta
		If x < 4 
			XSpeed = Abs(XSpeed)
			x:+ XSpeed
			Direction:+ 90
		ElseIf x > FieldWidth-4
			XSpeed = -Abs(XSpeed)
			x:+ XSpeed
			Direction:+ 90
		EndIf
		If y < 4
			YSpeed = Abs(Yspeed)
			y:+ YSpeed
			Direction:+ 90
		ElseIf y > FieldHeight-4
			YSpeed = -Abs(YSpeed)
			y:+ YSpeed
			Direction:+ 90
		EndIf
		
		Collision()
				
	End Method
	
	Function Preview(X,Y,SpriteNum)
		
		SetBlend alphablend
		SetScale 4,4
		
		DrawImage SnakeHead[SpriteNum],x,y+30
		DrawImage SnakeBody[SpriteNum],x+4,y+10
		DrawImage SnakeBody[SpriteNum],x-4,y-10
		DrawImage SnakeBody[SpriteNum],x+3,y-30
		DrawImage SnakeBody[SpriteNum],x-3,y-50
		
		SetScale 6,6
		SetBlend lightblend
		DrawImage SnakeHeadGlow[SpriteNum],x,y+30
		DrawImage SnakeBodyGlow[SpriteNum],x+4,y+10
		DrawImage SnakeBodyGlow[SpriteNum],x-4,y-10
		DrawImage SnakeBodyGlow[SpriteNum],x+3,y-30
		DrawImage SnakeBodyGlow[SpriteNum],x-3,y-50
		
		SetBlend alphablend
		SetScale 1,1
	End Function

	Method Draw()
		Local Rotation:Int
		Rotation = ATan2(YSpeed,XSpeed)+90
		SetRotation(Rotation)
		If Length = Segments
			'Draw the head
			DrawImage SnakeHead[SpriteNumber],x,y
		Else
			'Draw body parts
			DrawImage SnakeBody[SpriteNumber],x,y
		EndIf
		Return
	End Method
	
	Method DrawGlow()
		Local Rotation:Int
		Rotation = ATan2(YSpeed,XSpeed)+90
		SetRotation(Rotation)
		If Length = Segments
			'Draw the head
			DrawImage SnakeHeadGlow[SpriteNumber],x,y
		Else
			'Draw body parts
			DrawImage SnakeBodyGlow[SpriteNumber],x,y
		EndIf
		Return
	End Method
	
	Function Generate(NumSnakes:Int)
		
		List=Null
		
		List=CreateList()
		
		Variations=NumSnakes
		
		SnakeBodyGlow = New TImage[Variations+1]
		SnakeBody = New TImage[Variations+1]
		SnakeHeadGlow = New TImage[Variations+1]
		SnakeHead = New TImage[Variations+1]
		BodyRGB = New Int[Variations+1,3]
		HeadRGB = New Int[Variations+1,3]
		
		For Local i=1 To NumSnakes
			
			'Generate and Draw
			GenerateSnakeBody(i)
			GenerateSnakeHead(i)
			
			PrepareFrame(SnakeBody[i])
			PrepareFrame(SnakeBodyGlow[i])
			PrepareFrame(SnakeHead[i])
			PrepareFrame(SnakeHeadGlow[i])
			
		Next
		
	End Function
	
	Function ReCache()
		For Local i=1 To Variations
			PrepareFrame(SnakeBody[i])
			PrepareFrame(SnakeBodyGlow[i])
			PrepareFrame(SnakeHead[i])
			PrepareFrame(SnakeHeadGlow[i])
		Next
	End Function

	Method Destroy()
		List.Remove( Self )
	EndMethod
	
	Method DestroyAll()
		If Not List Return 
		
		For Local Snake:TSnake = EachIn List
			Snake.Destroy()
		Next
	EndMethod
	
	Function GenerateSnakeHead:TPixmap(Index:Int) Private
		'The amount of White Pixels
		Local PixelCount:Int=0	
		'Stores the Snakes Pixels
		Local SnakePixels:Int[6,6]
		'Stores the Snakes Colors
		Local SnakeColor[3]
		
		'-----------------MATH GEN ROUTINE-----------------
		
		'As long as there are less than 3 or more than 14 White pixels, redo Snake
		Repeat
			PixelCount=0
			For Local i=0 To 2
				For Local j=0 To 4
						
					'A Pixel can be either 0 (Black) or 1 (White)
					SnakePixels[i,j]=Rand(0,1)
						
					'Count the number of White Pixels
					PixelCount:+SnakePixels[i,j]
						
				Next
				
				'Set the Snakes color
				SnakeColor[i]=Rand(65,185)
				'SnakeColor[i]=Rand(60,130)
				
			Next
				
			'X mirror Snake
			For Local n=0 To 4
				SnakePixels[n,4]=SnakePixels[n,0]
				SnakePixels[n,3]=SnakePixels[n,1]
			Next

		Until PixelCount>=9 And PixelCount<=13 
		
		If EasterEgg
			SnakeColor[1]=SnakeColor[0]
			SnakeColor[2]=SnakeColor[0]
		End If
		
		'Mirror Snake along the Y axis
		For Local m=0 To 4
			SnakePixels[4,m]=SnakePixels[0,m]
			SnakePixels[3,m]=SnakePixels[1,m]
		Next
		
		'-----------------DRAWING ROUTINE-----------------

		Local SnakePixmap:TPixmap=CreatePixmap(9,9,PF_RGBA8888)
		Local GlowPixmap:TPixmap
		
		ClearPixels (SnakePixmap)
		
		'Loop through the Snake's pixel array 
		For Local x=0 To 4
			For Local y=0 To 4
				
				'Proceed to draw the Snake
				If SnakePixels[x,y]=1
					
					WritePixel SnakePixmap,2+x,2+y,ToRGBA(SnakeColor[0],SnakeColor[1],SnakeColor[2],255)
				
				End If
			
			Next
		Next
		
		For Local i=0 To 2
		
			HeadRGB[index,i]=SnakeColor[i]
		Next
		
		GlowPixmap=CopyPixmap(SnakePixmap)
		
		SnakeHead[index]=LoadImage(SnakePixmap,MASKEDIMAGE)
				
		GlowPixmap=GaussianBlur(GlowPixmap,2,220,35,255)
		
		SnakeHeadGlow[index]=LoadImage(GlowPixmap,FILTEREDIMAGE)
		
		SnakePixmap=Null;GlowPixmap=Null
		
	End Function
	
	Function GenerateSnakeBody:TPixmap(Index:Int) Private 
		'The amount of White Pixels
		Local PixelCount:Int=0	
		'Stores the Snakes Pixels
		Local SnakePixels:Int[6,6]
		'Stores the Snakes Colors
		Local BodyColor[3]
		
		'-----------------MATH GEN ROUTINE-----------------
		
		'As long as there are less than 3 or more than 14 White pixels, redo Invader
		Repeat
			PixelCount=0
			For Local i=0 To 2
				For Local j=0 To 3
						
					'A Pixel can be either 0 (Black) or 1 (White)
					SnakePixels[i,j]=Rand(0,1)
					SnakePixels[2,j]=1
					'Count the number of White Pixels
					PixelCount:+SnakePixels[i,j]
						
				Next
				
				'Set the invaders color
				BodyColor[i]=Rand(65,165)
				
			Next
		Until PixelCount>=6 And PixelCount<=9 
		
		If EasterEgg
			BodyColor[1]=BodyColor[0]
			BodyColor[2]=BodyColor[0]
		End If

		'Find disconnected pixels and remove them
		For Local x=1 To 3
			For Local y=1 To 3
				If SnakePixels[x,y]=1
					If SnakePixels[x-1,y]<>1
						If SnakePixels[x+1,y]<>1
							If SnakePixels[x,y+1]<>1
								If SnakePixels[x,y-1]<>1
									SnakePixels[x,y]=0
								End If
							End If
						End If
					End If
				End If
			Next
		Next

		
		'Mirror invader along the Y axis
		For Local m=0 To 3
			SnakePixels[4,m]=SnakePixels[0,m]
			SnakePixels[3,m]=SnakePixels[1,m]
		Next
		
		
		'-----------------DRAWING ROUTINE-----------------

		Local SnakePixmap:TPixmap=CreatePixmap(9,9,PF_RGBA8888)
		Local GlowPixmap:TPixmap
		
		ClearPixels (SnakePixmap)
		
		'Loop through the Snake's pixel array 
		For Local x=0 To 4
			For Local y=0 To 4
				
				'Proceed to draw the Snake
				If SnakePixels[x,y]=1
					
					WritePixel SnakePixmap,2+x,2+y,ToRGBA(BodyColor[0],BodyColor[1],BodyColor[2],255)
				
				End If
			
			Next
		Next
		
		For Local i=0 To 2
		
			BodyRGB[index,i]=BodyColor[i]
		Next
		
		GlowPixmap=CopyPixmap(SnakePixmap)
		
		SnakeBody[index]=LoadImage(SnakePixmap,MASKEDIMAGE)
				
		GlowPixmap=GaussianBlur(GlowPixmap,2,220,35,255)
		
		SnakeBodyGlow[index]=LoadImage(GlowPixmap,FILTEREDIMAGE)
		
		SnakePixmap=Null;GlowPixmap=Null
		
	End Function

		
	Function PrepareFrame(image:TImage) Private
		'Use this to cache an image or animimage in VRAM for quicker drawing later.
		image.Frame(0)
		MidHandleImage Image
	End Function
	
	Function ToRGBA%(r%,g%,b%,a%) Private
		'return (a << 24) | (r << 16) | (g << 8) | (b);
	Return ((A Shl 24) | (R Shl 16) | (G Shl 8) | B)
	
	End Function
	
	Method Explode()
		
		Local TempScore:Int
	
		If IsHead 
			If Rand(24+ExtraLikeliness,64)=42 Then Powerup.Spawn(x,y,Rand(0,9))
			PlaySoundBetter Sound_Explosion,X,Y
			Glow.MassFire(X,Y,1,2,25,Shot.Direction-90,HeadRGB[SpriteNumber,0],HeadRGB[SpriteNumber,1],HeadRGB[SpriteNumber,2])
			ParticleManager.Create(X,Y,35,HeadRGB[SpriteNumber,0],HeadRGB[SpriteNumber,1],HEadRGB[SpriteNumber,2])
			Flash.Fire(X,Y,.7,100)
			TempScore=EvenScore(90*ScoreMultiplier)
			Explosion.Fire(X,Y,.65)
		Else
			If Rand(0,105)=42 Then Powerup.Spawn(x,y,Rand(0,9))
			'Glow.MassFire(X,Y,1,1.5,10,10,BodyRGB[SpriteNumber,0],BodyRGB[SpriteNumber,1],BodyRGB[SpriteNumber,2])
			ParticleManager.Create(X,Y,10,BodyRGB[SpriteNumber,0],BodyRGB[SpriteNumber,1],BodyRGB[SpriteNumber,2])
			PlaySoundBetter Sound_Player_ShotHit,X,Y
			TempScore=EvenScore(15*ScoreMultiplier)
			Explosion.Fire(X,Y,.45)
		End If
		
		TempScore:*Multiplier
		
		If FrenzyMode
			Score:+TempScore*2
			ScoreRegister.Fire(x,y,TempScore,"2x")
		Else
			Score:+TempScore
			ScoreRegister.Fire(x,y,TempScore)
		End If	

		
		If TempScore>LargestScore Then LargestScore=TempScore
	
		Shot.Destroy()
		'Flash.Fire(X,Y,.5,10)
		'Debris.MassFire (X,Y,1,1,11,1)
		
		Destroy()
	
	End Method
	
	Method Collision()
		Local ShotDirection:Float
		
		'If PlayerDistance(X,Y)<32 And Player.Alive Then Player.Destroy(); DeathBy="DIGIPEDE"
		
		If PlayerDistance(X,Y)<42 And Player.Alive Then
			If Player.HasShield-Player.MaskShield>0
				If IsHead
					Glow.MassFire(X,Y,1,2,25,AwayFrom(X,Y,Player.X,Player.Y),HeadRGB[SpriteNumber,0],HeadRGB[SpriteNumber,1],HeadRGB[SpriteNumber,2])
					ParticleManager.Create(X,Y,28,HeadRGB[SpriteNumber,0],HeadRGB[SpriteNumber,1],HeadRGB[SpriteNumber,2],AwayFrom(X,Y,Player.X,Player.Y),1.2)
					Flash.Fire(X,Y,0.3,25)
					Dying=True
					'EnemyCount:-1
					EnemiesKilled:+1
				Else
					ParticleManager.Create(Player.X,Player.Y,30,Player.RGB[0],Player.RGB[1],Player.RGB[2],0,2)
				End If
				Player.HasShield:-1
				Trk_Shd:-1
				PlaySoundBetter Sound_Player_Shield_Die,X,Y
			Else
				If PlayerDistance(X,Y)<31
					Player.Destroy()
					Deathby="Digipede"
				End If
			End If
		End If
		
		If TPlayerBomb.List
			For Local PlayerBomb:TPlayerBomb = EachIn TPlayerBomb.List
				
				If Distance(X,Y,PlayerBomb.X,PlayerBomb.Y) < PlayerBomb.Radius
					
					Glow.MassFire(X,Y,1,2,4,AwayFrom(X,Y,PlayerBomb.X,PlayerBomb.Y),BodyRGB[SpriteNumber,0],BodyRGB[SpriteNumber,1],BodyRGB[SpriteNumber,2])
					ParticleManager.Create(X,Y,6,BodyRGB[SpriteNumber,0],BodyRGB[SpriteNumber,1],BodyRGB[SpriteNumber,2],AwayFrom(X,Y,PlayerBomb.X,PlayerBomb.Y),1.2)
					'Flash.Fire(X,Y,0.3,25)
					If IsHead EnemiesKilled:+1
					'Print "my maxspeed was:"+MaxSpeed
					Destroy()
					Dying=True
					
				
				End If
				
			Next
		End If


		
		
		'If a shot hit a snake
		If Not TShot.List Return
		For Local Shot:TShot = EachIn TShot.List
			If Distance( X, Y, Shot.X, Shot.Y ) < 16
				
				
				If IsHead=False 
				
					Shot.EnemyDestroy(True,True)
				
				Else
					EnemiesKilled:+1
					'EnemyCount:-1
					Dying=True
					Shot.EnemyDestroy()
					'Destroy the Spinner, at last
				End If
			EndIf
		Next	

	EndMethod

	
	Function DrawAll()
		If Not List Return 
		If List.Count()=0 Return
		SetAlpha 1
		SetScale 4,4		
		
		For Local Snake:TSnake = EachIn List
			Snake.Draw()
		Next
		
		SetBlend LIGHTBLEND
		SetScale 5,5
		
		For Local Snake:TSnake = EachIn List
			Snake.DrawGlow()
		Next
		SetBlend ALPHABLEND
		
	EndFunction
	
	Function DrawAllGlow()
		If Not List Return 
		'If List.Count()=0 Return
		SetAlpha 1
		SetScale 4.5,4.5		
		
		For Local Snake:TSnake = EachIn List
			Snake.DrawGlow()
		Next
		
	EndFunction
	
	Function UpdateAll()
		If Not List Return 
		
		For Local Snake:TSnake = EachIn List
			Snake.Update()
		Next
	EndFunction

End Type

'--------------------------------------------------------------------------------------------------
'Boid - Swarming AI
'--------------------------------------------------------------------------------------------------
Type TBoid Extends TObject  
	
	Const minDistance=48
	Const swarmDistance=420
	
	Global List:TList
	Global Variations:Int
	Global SpreadOut:Int
	Global CoolDown:Int
	Global CornerX:Int
	Global CornerY:Int
	
	Field MaxSpeed:Float=.75
	Field FlockId:Int=0
	Field TurnTo:Int=0
	Field SpriteNumber:Int
	Field BlurSteps:Float
	Field Hurt:Int
	Field HurtSteps:Float
	Field PainFlash:Float
	
	Global BoidBody:TImage[]
	Global BoidHit:TImage[]
	Global BoidGlow:TImage[]
	Global BoidRGB:Int[,]
	
	Field NearMissTime:Int

	
	Function Generate(NumBoids:Int)
		
		List=Null
		
		List=CreateList()
		
		Variations=NumBoids
		
		BoidGlow = New TImage[Variations+1]
		BoidBody = New TImage[Variations+1]
		BoidHit = New TImage[Variations+1]
		BoidRGB = New Int[Variations+1,3]
		
		For Local i=1 To NumBoids
			
			'Generate and Draw
			GenerateBoid(i)
			
			PrepareFrame(BoidBody[i])
			PrepareFrame(BoidGlow[i])
			PrepareFrame(BoidHit[i])
			
		Next
		
	End Function
	
	Function ReCache()
		For Local i=1 To Variations
			PrepareFrame(BoidBody[i])
			PrepareFrame(BoidGlow[i])
			PrepareFrame(BoidHit[i])
		Next
	End Function
	
	Function GenerateBoid:TPixmap(Index:Int) Private
		'The amount of White Pixels
		Local PixelCount:Int=0	
		'Stores the Boids Pixels
		Local BoidPixels:Int[6,6]
		'Stores the Boids Colors
		Local BoidColor[3]
		
		'-----------------MATH GEN ROUTINE---------------------------
		
		'As long as there are less than 3 or more than 14 White pixels, redo Boid
		Repeat
			PixelCount=0
			For Local i=0 To 2
				For Local j=0 To 4
						
					'A Pixel can be either 0 (Black) or 1 (White)
					BoidPixels[i,j]=Rand(0,1)
						
					'Count the number of White Pixels
					PixelCount:+BoidPixels[i,j]
						
				Next
				
				'Set the Boids color
				BoidColor[i]=Rand(55,195)
				'BoidColor[i]=Rand(60,130)
				
			Next
				
			'If condition is met, X mirror Boid
			If PixelCount>=6 And Rand(0,100)=42 
				
				For Local n=0 To 4
					BoidPixels[n,4]=BoidPixels[n,0]
					BoidPixels[n,3]=BoidPixels[n,1]
				Next
				
			End If
		Until PixelCount>=6 And PixelCount<=16 
		
		If EasterEgg
			BoidColor[1]=BoidColor[0]
			BoidColor[2]=BoidColor[0]
		End If
		
		'Mirror Boid along the Y axis
		For Local m=0 To 4
			BoidPixels[4,m]=BoidPixels[0,m]
			BoidPixels[3,m]=BoidPixels[1,m]
		Next
		
		'-----------------DRAWING ROUTINE-----------------

		Local BoidPixmap:TPixmap=CreatePixmap(13,9,PF_RGBA8888)
		Local BoidHitPixmap:TPixmap=CreatePixmap(13,9,PF_RGBA8888)
		Local GlowPixmap:TPixmap
		
		ClearPixels (BoidPixmap)
		ClearPixels (BoidHitPixmap)
		
		'Loop through the Boid's pixel array 
		For Local x=0 To 4
			For Local y=0 To 4
				
				'Proceed to draw the Boid
				If BoidPixels[x,y]=1
					
					WritePixel BoidPixmap,2+x,2+y,ToRGBA(BoidColor[0],BoidColor[1],BoidColor[2],255)
					WritePixel BoidHitPixmap,2+x,2+y,ToRGBA(255,255,255,255)
					
				End If
			
			Next
		Next
				For Local x=0 To 4
			For Local y=0 To 4
				
				'Proceed to draw the Boid
				If BoidPixels[x,y]=1
					
					WritePixel BoidPixmap,4+x,3+y,ToRGBA(BoidColor[0],BoidColor[1],BoidColor[2],255)
					WritePixel BoidHitPixmap,4+x,3+y,ToRGBA(255,255,255,255)
					
				End If
			
			Next
		Next
		
		For Local x=0 To 4
			For Local y=0 To 4
				
				'Proceed to draw the Boid
				If BoidPixels[x,y]=1
					
					WritePixel BoidPixmap,6+x,2+y,ToRGBA(BoidColor[0],BoidColor[1],BoidColor[2],255)
					WritePixel BoidHitPixmap,6+x,2+y,ToRGBA(255,255,255,255)
					
				End If
			
			Next
		Next
		
		For Local i=0 To 2
			BoidRGB[index,i]=BoidColor[i]
		Next
		
		GlowPixmap=CopyPixmap(BoidPixmap)
		
		BoidBody[index]=LoadImage(BoidPixmap,MASKEDIMAGE)
		
		BoidHit[index]=LoadImage(BoidHitPixmap,MASKEDIMAGE)
				
		GlowPixmap=GaussianBlur(GlowPixmap,2,220,35,255)
		
		BoidGlow[index]=LoadImage(GlowPixmap,FILTEREDIMAGE)
		
		BoidPixmap=Null;GlowPixmap=Null
		
	End Function
	
	Function PrepareFrame(image:TImage) Private
		'Use this to cache an image or animimage in VRAM for quicker drawing later.
		image.Frame(0)
		MidHandleImage Image
	End Function
	
	Function ToRGBA%(r%,g%,b%,a%) Private
		'return (a << 24) | (r << 16) | (g << 8) | (b);
	Return ((A Shl 24) | (R Shl 16) | (G Shl 8) | B)
	
	End Function
	
	Method Collision()
		Local ShotDirection:Float
		
		If Player.Alive And PlayerDistance(X,Y)<ComfortZone
			CloseEncounters:+.125*Delta
		End If
		
		If PlayerDistance(X,Y)<52 And Player.Alive Then
			If Player.HasShield-Player.MaskShield>0
				Glow.MassFire(X,Y,1,2,25,AwayFrom(X,Y,Player.X,Player.Y),BoidRGB[SpriteNumber,0],BoidRGB[SpriteNumber,1],BoidRGB[SpriteNumber,2])
				ParticleManager.Create(X,Y,40,BoidRGB[SpriteNumber,0],BoidRGB[SpriteNumber,1],BoidRGB[SpriteNumber,2],AwayFrom(X,Y,Player.X,Player.Y),1.2)
				Flash.Fire(X,Y,0.4,25)
				Destroy()
				'EnemyCount:-1
				EnemiesKilled:+1
				Player.HasShield:-1
				Trk_Shd:-1
				PlaySoundBetter Sound_Player_Shield_Die,X,Y
			Else
				If PlayerDistance(X,Y)<42
					Player.Destroy()
					DeathBy="NET MIND"
				End If
			End If
		End If
		
		If TPlayerBomb.List
			For Local PlayerBomb:TPlayerBomb = EachIn TPlayerBomb.List
				
				If Distance(X,Y,PlayerBomb.X,PlayerBomb.Y) < PlayerBomb.Radius
					
					Glow.MassFire(X,Y,1,2,15,AwayFrom(X,Y,PlayerBomb.X,PlayerBomb.Y),BoidRGB[SpriteNumber,0],BoidRGB[SpriteNumber,1],BoidRGB[SpriteNumber,2])
					ParticleManager.Create(X,Y,20,BoidRGB[SpriteNumber,0],BoidRGB[SpriteNumber,1],BoidRGB[SpriteNumber,2],AwayFrom(X,Y,PlayerBomb.X,PlayerBomb.Y),1.2)
					Flash.Fire(X,Y,0.4,25)
					'Explosion.Fire(X,Y,.55)
					Destroy()
					'EnemyCount:-1
					EnemiesKilled:+1
					
				End If
				
			Next
		End If
		
		'If a shot hit a Boid
		If Not TShot.List Return
		For Local Shot:TShot = EachIn TShot.List

			If Distance( X, Y, Shot.X, Shot.Y ) < 30
				
				Local TempScore:Int, SniperShot=False
				'Local XPos:Int,YPos:Int
				
				If Not Hurt
					Hurt:+1
					PlaySoundBetter Sound_Player_ShotHit,X,Y
					Glow.MassFire(X,Y,1,2,7,Shot.Direction-90,BoidRGB[SpriteNumber,0],BoidRGB[SpriteNumber,1],BoidRGB[SpriteNumber,2])
					'ParticleManager.Create(X,Y,5,BoidRGB[SpriteNumber,0],BoidRGB[SpriteNumber,1],BoidRGB[SpriteNumber,2],0,1.1)
					Shot.EnemyDestroy()
					PainFlash=2.0
					Return
				End If
				
				PlaySoundBetter Sound_Explosion,X,Y

				If Rand(9+ExtraLikeliness,64)=42 Then Powerup.Spawn(x,y,Rand(0,10))
				
		
				TempScore=EvenScore(275*Multiplier*ScoreMultiplier)
				
				SpreadOut=MilliSecs()+650
				
				Glow.MassFire(X,Y,1,2,28,Shot.Direction-90,BoidRGB[SpriteNumber,0],BoidRGB[SpriteNumber,1],BoidRGB[SpriteNumber,2])
				ParticleManager.Create(X,Y,30,BoidRGB[SpriteNumber,0],BoidRGB[SpriteNumber,1],BoidRGB[SpriteNumber,2],0,1.3)
				
				Rem
				XPos=Rand(-18,18)
				Ypos=Rand(-18,18)
				Asteroid.Spawn(X+Xpos,Y+YPos,True)
				Asteroid.Spawn(X+(Xpos*-1),Y+(Ypos*-1),True)
				If Rand(0,100)<19 Asteroid.Spawn(X+(Xpos/2),Y+(Ypos/2),True)
				End Rem
				
				Shot.EnemyDestroy()
				Flash.Fire(X,Y,.6,10)
				'Debris.MassFire (X,Y,1,1,11,1)
				Explosion.Fire(X,Y,.65)
		
				'Did the player shoot - or the AI?
				If Shot.Shooter=1 Then
					'Sniper Shot
					If Player.LastShotFired-Player.PrevShotFired>575 Then
						'Print "time req. met! "+(Player.LastShotFired-Player.PrevShotFired)
						If Distance( X, Y, Player.X, Player.Y) >305 Then
							'Print "almost"
							If IsVisible(x,y,15) 
								'Print "Sniper!"+Distance( X, Y, Player.X, Player.Y )
								ScoreRegister.Fire(x,y,TempScore,"2x")
								Tempscore:*2
								SniperShot=True
								Score:+Tempscore
							End If
						End If
					End If
					
					'No Sniper Shot? But still a Player shot?
					If Not SniperShot And Shot.Shooter=1  Then
						If FrenzyMode
							Score:+TempScore*2
							ScoreRegister.Fire(x,y,TempScore,"2x")
						Else
							Score:+TempScore
							ScoreRegister.Fire(x,y,TempScore)
						End If	
					End If
					
					'General Kill Stuff
					EnemiesKilled:+1
					If TempScore>LargestScore Then LargestScore=TempScore
				End If
				
				Destroy()
				'EnemyCount:-1
				Exit
			EndIf
		Next	
	EndMethod

	Function Spawn(X:Int,Y:Int)
	
		'If Not List List = CreateList()
		
		If Player.Alive
			If CountList(List) => 14 Then Return Null	
		Else
			If CountList(List) => 6 Then Return Null	
		End If
		
		If Rand(0,5)<2 Return Null
		
		If CountList (List) = 0
				
				Local TempVar=Rand(1,4)
				
				Select TempVar
					
					Case 1
						CornerX=Rand(45,145)
						CornerY=Rand(45,145)

					Case 2
						CornerX=Rand(FieldWidth-45,FieldWidth-145)
						CornerY=Rand(45,145)
						
					Case 3
						CornerX=Rand(45,145)
						CornerY=Rand(FieldHeight-45,FieldHeight-145)
						
					Case 4
						CornerX=Rand(FieldWidth-45,FieldWidth-145)
						CornerY=Rand(FieldHeight-45,FieldHeight-145)
						
				End Select
		End If
		
		Local Boid:TBoid = New TBoid	 
		List.AddLast Boid
		
		Boid.X=X
		Boid.Y=Y
		Boid.SpriteNumber=Rand(1,Variations)
		
		'EnemyCount:+1
		Boid.MaxSpeed=.7+SpeedGain*.75

		Boid.Direction=Rand(1,360)
		Boid.XSpeed:+ Cos(Boid.Direction)/2
		Boid.YSpeed:+ Sin(Boid.Direction)/2
		
		SpawnEffect.Fire(X,Y,.8,BoidRGB[Boid.SpriteNumber,0],BoidRGB[Boid.SpriteNumber,1],BoidRGB[Boid.SpriteNumber,2])	

		PlaySoundBetter Sound_Boid_Born,X,Y
		
	End Function
	
	Function Preview(X,Y,SpriteNum)
		
		SetBlend alphablend
		SetScale 4,4
		
		DrawImage BoidBody[SpriteNum],x,y
		
		SetScale 5,5
		SetBlend lightblend
		DrawImage BoidGlow[SpriteNum],x,y
		
		SetBlend alphablend
		SetScale 1,1
	End Function
	
	Method Update()
		If Not List Return
		Local TravelDistance:Int
		Local Speed:Float
		Local FlockSize:Int
		Local SwarmSize:Int
		
		If PainFlash>-.1
			PainFlash:-0.04*Delta
		End If
		
		HurtSteps:+1*Delta
		
		If HurtSteps>=64+Rand(0,100) Then HurtSteps=0
		
		If ParticleMultiplier>=1
			If HurtSteps>16 And HurtSteps<17.2 And Hurt=1
				Glow.MassFire(X,Y,1,1,1,Rand(Direction-10,Direction+10),BoidRGB[SpriteNumber,0],BoidRGB[SpriteNumber,1],BoidRGB[SpriteNumber,2],False,True)
			End If
		Else
			If HurtSteps>16 And HurtSteps<16.5 And Hurt=1
				Glow.MassFire(X,Y,1,1,1,Rand(Direction-10,Direction+10),BoidRGB[SpriteNumber,0],BoidRGB[SpriteNumber,1],BoidRGB[SpriteNumber,2],False,True)
			End If
		End If
		

		
		Collision()
		
		'Count the entire swarm
		SwarmSize=CountList(List)
		
		If SwarmSize=0 Return
		
		'Count the Flock
		If FlockID<>0
			For Local Boid:TBoid = EachIn List
				If Boid.FlockID=FlockId FlockSize:+1
			Next
		End If
		
		'If a Boid is hit Rule 4 comes into effect (Spread out!)
		If CoolDown-MilliSecs()<=0
			If SpreadOut-MilliSecs()>0
				RuleFour(SwarmSize)
			Else
				RuleOne(SwarmSize)
				If SpreadOut<>0
					Cooldown=MilliSecs()+725
					SpreadOut=0
				End If
			End If
		End If
			RuleTwo()
		RuleThree(SwarmSize)
		
		'Print FlockSize
		
		'Give Chase when you are in a swarm
		If FlockSize=>5 And PlayerDistance(X,Y)>5
			TravelDistance=PlayerDistance(X,Y)
			XSpeed=XSpeed+((Player.X-X)/TravelDistance+0.02)
			YSpeed=YSpeed+((Player.Y-Y)/TravelDistance+0.02)
		ElseIf Distance(X,Y,CornerX, CornerY)>365
			TravelDistance=Distance(X,Y,CornerX,CornerY)
			XSpeed=XSpeed+((CornerX-X)/TravelDistance+0.02)
			YSpeed=YSpeed+((CornerY-Y)/TravelDistance+0.02)
		End If
		
		'Limit Boid Speed
		Speed = Sqr(XSpeed*XSpeed+YSpeed*YSpeed)
		If Speed > MaxSpeed
			XSpeed=XSpeed/Speed*MaxSpeed
			YSpeed=YSpeed/Speed*MaxSpeed
		EndIf
		
		'Bounce around the corners
		If x < 24 
			XSpeed = Abs(XSpeed)
			X:+ XSpeed
		ElseIf x > FieldWidth-24
			XSpeed = -Abs(XSpeed)
			X:+ XSpeed
		EndIf
		If y < 24
			YSpeed = Abs(Yspeed)
			Y:+ YSpeed
		ElseIf y > FieldHeight-24
			YSpeed = -Abs(YSpeed)
			Y:+ YSpeed
		EndIf
		
		'Finall add up the speed vectors
		X:+XSpeed*Delta
		Y:+YSpeed*Delta
		

		'Crude Direction Interpolation
		Direction = TweenSmooth(Direction,TurnTo,0.35)
		
		BlurSteps:+1*Delta
		
		If BlurSteps>62/BlurDivider
			MotionBlur.Spawn(X,Y,Direction,4,BoidGlow[SpriteNumber])
			BlurSteps=0
		End If
		
		'Direction=((Direction+ATan2(Abs(XSpeed),Abs(YSpeed)))/2)*Delta
		
		'Interploate the current and the turning direction to avoid Jitter
		TurnTo=((Direction+ATan2(Abs(XSpeed),Abs(YSpeed)))/2)*Delta
	EndMethod
	
	Method RuleOne(SwarmSize:Int)
		Local AverageX:Float
		Local AverageY:Float
		
		'Move Boids closer to each other
		For Local Boid:TBoid = EachIn List
			If Boid = Self Continue
			AverageX:+(X-Boid.X)
			AverageY:+(Y-Boid.Y)
		Next
		
		AverageX=AverageX/SwarmSize
		AverageY=AverageY/SwarmSize
		
		XSpeed:-(AverageX/100)*Delta
		YSpeed:-(AverageY/100)*Delta
	EndMethod

	
	Method RuleTwo()
		Local DistX:Float
		Local DistY:Float
		Local Distance:Float
		Local DistanceX:Float
		Local DistanceY:Float
		Local NearbyBoids:Int
		
		'Avoid Other Boids
		For Local Boid:TBoid = EachIn List
			If Boid = Self Continue
			DistX = X-Boid.X
			DistY = Y-Boid.Y
			Distance = Sqr(DistX * DistX + DistY * DistY)
			
			If Distance<minDistance+35
				NearbyBoids:+1
				DistanceX:- Sgn(Distx)/2
				DistanceY:- Sgn(Disty)/2
			ElseIf Distance<minDistance
				DistanceX:- Sgn(Distx)
				DistanceY:- Sgn(Disty)
			ElseIf Distance<minDistance-5
				DistanceX:- Sgn(Distx)*2.5
				DistanceY:- Sgn(Disty)*2.5
			ElseIf Distance < SwarmDistance 
				If Boid.FlockID=0
					'Hacky, but eh ... for now.
					FlockID=Rand(1,1000)
				Else
					FlockID=Boid.FlockID
				End If
			Else
				DistanceX:- Sgn(Distx)/8
				DistanceY:- Sgn(Disty)/8
			End If
		Next
		
		'If NearbyBoids>0
			XSpeed:-DistanceX*Delta
			YSpeed:-DistanceY*Delta
		'End If
		
	EndMethod
	
	Method RuleThree(SwarmSize:Int)
		Local AverageVX:Float=0
		Local AverageVY:Float=0
		Local AverageDir:Int=0
		
		'Move with the swarm
		For Local Boid:TBoid = EachIn List
			If Boid = Self Continue
			AverageVX:+(Boid.XSpeed)
			AverageVY:+(Boid.YSpeed)
			AverageDir:+Boid.Direction
		Next
		
		If SwarmSize>1
			AverageVX=AverageVX/(SwarmSize-1)
			AverageVY=AverageVX/(SwarmSize-1)
			'AverageDir=AverageDir/(SwarmSize-1)
		End If
		
		'TurnTo=AverageDir
		XSpeed:+(AverageVX/8)*Delta
		YSpeed:+(AverageVY/8)*Delta
	EndMethod
	
	Method RuleFour(SwarmSize:Int)
		Local AverageX:Float
		Local AverageY:Float
		
		'Panic! Spread out as fast as possible
		For Local Boid:TBoid = EachIn List
			If Boid = Self Continue
			AverageX:+(X-Boid.X)
			AverageY:+(Y-Boid.Y)
		Next
		
		AverageX=AverageX/SwarmSize
		AverageY=AverageY/SwarmSize
		
		XSpeed:+(AverageX)*Delta
		YSpeed:+(AverageY)*Delta
	EndMethod
	
	Method DrawBody()
		
		SetRotation(Direction)
		If PainFlash>0 Then
			SetAlpha PainFlash
			DrawImage BoidHit[SpriteNumber],x,y
			SetAlpha 1
		End If
		DrawImage BoidBody[SpriteNumber],x,y

	EndMethod
	
	Method DrawGlow()
		
		SetRotation(Direction)
		DrawImage BoidGlow[SpriteNumber],x,y
		
	EndMethod
	
	Function DrawAllGlow()
		If Not List Return 
		
		SetScale 4.5,4.5
		
		For Local Boid:TBoid = EachIn List
			Boid.DrawGlow()
		Next
		
	EndFunction
	
	Function DrawAll()
		If Not List Return 
		If List.Count()=0 Return
		SetScale 4,4
		
		
		For Local Boid:TBoid = EachIn List
			Boid.DrawBody()
		Next
		
		SetBlend LIGHTBLEND
		SetScale 5,5
		
		For Local Boid:TBoid = EachIn List
			Boid.DrawGlow()
		Next
		
		SetBlend ALPHABLEND
		
	EndFunction
	
	Function UpdateAll()
		If Not List Return 
		
		For Local Boid:TBoid = EachIn List
			Boid.Update()
		Next
		
	EndFunction

	Method Destroy()
		List.Remove( Self )
	EndMethod
	
	Method DestroyAll()
		If Not List Return 
		
		For Local Boid:TBoid = EachIn List
			Boid.Destroy()
		Next
	EndMethod
	
End Type

'-----------------------------------------------------------------------------
'The Corrupted Invader Only Spawns from destroyed Corruption Nodes
'-----------------------------------------------------------------------------
Type TCorruptedInvader Extends TObject	
	Global List:TList
	Global Variations:Int
	Global CorruptedInvaderBody:TImage[]
	Global CorruptedInvaderGlow:TImage[]
	Global CorruptedInvaderRGB:Int[,]
	Global AllowedMax:Int[2]
	
	Field Homing:Int=False
	Field SpriteNumber:Int
	Field Wavy:Float
	Field MaxSpeed:Float
	Field Evading=False
	Field InterpolateDir:Float
	Field Name:String
	Field Blink:Byte
	
	Field NearMissTime:Int
	Field MissID:String
	
	Field BlurSteps:Float

	Function Generate(NumCorruptedInvaders:Int)
		
		List=Null
		
		List=CreateList()
		
		AllowedMax[1]=72
		AllowedMax[0]=24
		
		Variations=NumCorruptedInvaders
		
		CorruptedInvaderGlow = New TImage[Variations+1]
		CorruptedInvaderBody = New TImage[Variations+1]
		CorruptedInvaderRGB = New Int[Variations+1,3]
		
		For Local i=1 To NumCorruptedInvaders
			
			'Generate and Draw
			GenerateCorruptedInvader(i)
			
			PrepareFrame(CorruptedInvaderBody[i])
			PrepareFrame(CorruptedInvaderGlow[i])
			
		Next
		
	End Function
	
	Function ReCache()
		For Local i=1 To Variations
			PrepareFrame(CorruptedInvaderBody[i])
			PrepareFrame(CorruptedInvaderGlow[i])
		Next
	End Function
		
	Function Preview(X,Y,SpriteNum)
		
		SetBlend alphablend
		SetScale 4,4
		
		DrawImage CorruptedInvaderBody[SpriteNum],x,y
		
		SetScale 6,6
		SetBlend lightblend
		DrawImage CorruptedInvaderGlow[SpriteNum],x,y
		
		SetBlend alphablend
		SetScale 1,1
	End Function
	
	Function Spawn:TObject(X:Int,Y:Int,Silent:Byte=False,Name:String="")
		
		'If Not List List = CreateList()
		
		If Silent
			If Player.Alive=True
				If CountList(List) > AllowedMax[1] Return Null	
			ElseIf Player.Alive=False
				If CountList(List) > AllowedMax[0] Return Null	
			End If
		End If
		
		Local CorruptedInvader:TCorruptedInvader = New TCorruptedInvader	 
		List.AddLast CorruptedInvader
			
		CorruptedInvader.SpriteNumber=Rand(1,Variations)
		
		CorruptedInvader.MissID=String(CorruptedInvader.SpriteNumber)+"+"+String(Rand(-32000,92000))
		
		CorruptedInvader.X=X
		CorruptedInvader.Y=Y
				
		CorruptedInvader.Direction=Rand(1,360)
		CorruptedInvader.MaxSpeed=.65+Rnd(0,.36+SpeedGain)
		CorruptedInvader.XSpeed:+ Cos(CorruptedInvader.Direction)/2
		CorruptedInvader.YSpeed:+ Sin(CorruptedInvader.Direction)/2
		If Not Silent
			'EnemyCount:+1
			'PlaySoundBetter Sound_Invader_Born,X,Y
			CorruptedInvader.Name="CORRUPTION SEED"
			If Rand(0,5)<2 SpawnEffect.Fire(CorruptedInvader.X,CorruptedInvader.Y,.4,CorruptedInvaderRGB[CorruptedInvader.SpriteNumber,0],CorruptedInvaderRGB[CorruptedInvader.SpriteNumber,1],CorruptedInvaderRGB[CorruptedInvader.SpriteNumber,2])	
		Else
			PlaySoundBetter Sound_Corruption_Infect,X,Y
			CorruptedInvader.Name=Name
			Return CorruptedInvader
		End If			
	End Function
		
	Method DrawBody()
		
		SetRotation(Direction+Cos(Wavy)*10)
		DrawImage CorruptedInvaderBody[SpriteNumber],x,y
		
	EndMethod
	
	Method DrawGlow()
		
		SetRotation(Direction+Cos(Wavy)*10)
		DrawImage CorruptedInvaderGlow[SpriteNumber],x,y
		
	EndMethod
	
	Method DodgeShot(x1#,y1#,x2#,y2#)
		Local ddx# = x1-x-(x1-x2)*4
		Local ddy# = y1-y-(y1-y2)*4 
		Local bdx# = x1-x2
		Local bdy# = y1-y2
		Local distd# = Sqr(ddx*ddx + ddy*ddy)+0.002
		Local distb# = Sqr(bdx*bdx + bdy*bdy)+0.002					
		If distd < 64
			ddx# = -ddx/distd*16*2
			ddy# = -ddy/distd*16*2

			ddx# = ddx+bdx/distb*16*2
			ddy# = ddy+bdy/distb*16*2

			XSpeed = XSpeed + ddx*Delta
			YSpeed = YSpeed + ddy*Delta
			Local Speed:Float = Sqr(XSpeed*XSpeed+YSpeed*YSpeed)
			If Speed > MaxSpeed*1.25
				XSpeed = XSpeed/Speed*MaxSpeed*1.25
				YSpeed = YSpeed/Speed*MaxSpeed*1.25
			EndIf
			Evading=MilliSecs()+375
		EndIf
	End Method
	
	Method Infect(X:Float,Y:Float)
		Local distx:Float
		Local disty:Float
		Local InvaderDistance:Float
		
		'Only do this if there are actual Invaders to check against
		If Invader.List
			For Local Invader:TInvader = EachIn Invader.List
				distx = Invader.X-X
				disty = Invader.Y-Y
				InvaderDistance = (distx * distx + disty * disty)
				If InvaderDistance < 26*26  + 26*26 And CountList(List) <= AllowedMax[Player.Alive]
					Local TempCorr:TObject
					TempCorr=CorruptedInvader.Spawn(Invader.X,Invader.Y,True,"CORRUPTED "+Invader.Name[Invader.AI])
					If TempCorr=Null Return
					Flash.Fire(Invader.X,Invader.Y,0.58,30,225,225,225,True,True)
					Lightning.Fire(Self,TempCorr)
					If ParticleMultiplier>1.1 Lightning.Fire(Self,TempCorr)
					Corruption.Spawn(Invader.X,Invader.Y)
					Corruption.Spawn(Invader.X+Rand(-8,8),Invader.Y+Rand(-8,8))
					Corruption.Spawn(Invader.X+Rand(-8,8),Invader.Y+Rand(-8,8))
					If ParticleMultiplier>1
						Corruption.Spawn(Invader.X+Rand(-12,12),Invader.Y+Rand(-12,12))
						Corruption.Spawn(Invader.X+Rand(-12,12),Invader.Y+Rand(-12,12))
					End If
					Invader.Destroy()
				EndIf
			Next	
		End If
		
		'Dito for the spinners
		If Spinner.List
			For Local Spinner:TSpinner = EachIn Spinner.List
				distx = Spinner.X-X
				disty = Spinner.Y-Y
				InvaderDistance = (distx * distx + disty * disty)
				If InvaderDistance < 28*28  + 28*28 And CountList(List) <= AllowedMax[Player.Alive]
					Local TempCorr:TObject
					TempCorr=CorruptedInvader.Spawn(Spinner.X,Spinner.Y,True,"CORRUPTED SPINNER")
					If TempCorr=Null Return
					Flash.Fire(Spinner.X,Spinner.Y,0.58,30,225,225,225,True,True)
					Corruption.Spawn(Spinner.X,Spinner.Y)
					Lightning.Fire(Self,TempCorr)
					If ParticleMultiplier>1.1 Lightning.Fire(Self,TempCorr)
					Corruption.Spawn(Spinner.X+Rand(-8,8),Spinner.Y+Rand(-8,8))
					Corruption.Spawn(Spinner.X+Rand(-8,8),Spinner.Y+Rand(-8,8))
					If ParticleMultiplier>1
						Corruption.Spawn(Spinner.X+Rand(-12,12),Spinner.Y+Rand(-12,12))
						Corruption.Spawn(Spinner.X+Rand(-12,12),Spinner.Y+Rand(-12,12))
					End If
					Spinner.Destroy()
				EndIf
			Next	
		End If
		Rem
		If Snake.List
			For Local Snake:TSnake = EachIn Snake.List
				distx = Snake.X-X
				disty = Snake.Y-Y
				InvaderDistance = (distx * distx + disty * disty)
				If InvaderDistance < 16*16  + 16*16 And CountList(List) <= AllowedMax[Player.Alive]
					Local TempCorr:TObject
					TempCorr=CorruptedInvader.Spawn(Snake.X,Snake.Y,True,"CORRUPTED SNAKE SEGMENT")
					If TempCorr=Null Return
					Flash.Fire(Invader.X,Invader.Y,0.55,30,215,215,215,True)
					Lightning.Fire(Self,TempCorr)
					Corruption.Spawn(Invader.X,Invader.Y)
					'Corruption.Spawn(Invader.X+Rand(-8,8),Invader.Y+Rand(-8,8))
					Corruption.Spawn(Invader.X+Rand(-8,8),Invader.Y+Rand(-8,8))
					Snake.Destroy()
				EndIf

			
			Next
		End If
		End Rem
		
	End Method
	
	Method Update()
		Local distx:Float,CorruptedInvaderDistance:Float,disty:Float,Speed:Float
		Local BumpX:Float=0, BumpY:Float=0
		
		'Check against Colosions
		Collision()
		
		'Infect other invaders
		Infect(X,Y)
		
		'Check Against Near Misses
		NearMissCheck(3.1)
		
		BlurSteps:+1*Delta
		
		If Int(BlurSteps)=8 Or Int(BlurSteps)=16 Or Int(BlurSteps)=24 Or Int(BlurSteps)=32
			If Rand(0,2)<2 SpriteNumber=Rand(1,Variations)
			If Rand(0,382)=42 Then
				Flash.Fire(X,Y,0.42,20,175,175,175,True,True)
				Corruption.Spawn(X,Y)
			End If
		End If
		
		If BlurSteps>38/BlurDivider
			MotionBlur.Spawn(X,Y,Direction,4,CorruptedInvaderGlow[SpriteNumber])
			BlurSteps=0
		End If
		
		'Add wavieness to the motion of
		Wavy:+Rand(-2,12)*Delta
		If Cos(Wavy)=Cos(0) Then Wavy=0
		
		Homing=False
		
		If MilliSecs()-Evading>105
			For Local Shot:TShot = EachIn TShot.List
				DodgeShot(Shot.X,Shot.Y,Shot.X+Shot.XSpeed,Shot.Y+Shot.YSpeed)
			Next	
		End If	
		
		If PlayerDistance(X,Y)<380 And MilliSecs()-Evading>55
			XSpeed=XSpeed+(Player.X-X)/(PlayerDistance(X,Y)+0.02)/2
			YSpeed=YSpeed+(Player.Y-Y)/(PlayerDistance(X,Y)+0.02)/2
			Homing=True
		End If
		'Avoid Other CorruptedInvaders
		
		'Sometimes randomly change your direction when not giving chase
		If Homing=False And Rand(1,999)<25
			Direction=Rand(0,359)
		End If
		
		For Local CorruptedInvader:TCorruptedInvader = EachIn List
			If CorruptedInvader <> Self
				distx = CorruptedInvader.X-X
				disty = CorruptedInvader.Y-Y
				CorruptedInvaderDistance = (distx * distx + disty * disty)
				If CorruptedInvaderDistance < 18*18  + 18*18
					BumpX:- Sgn(distx)
					BumpY:- Sgn(disty)
				EndIf
			EndIf
		Next		
		
		'Bounce around the corners
		If x < 8 
			XSpeed = Abs(XSpeed)
			X:+ XSpeed*Delta
			Direction:+ 90
		ElseIf x > FieldWidth-8
			XSpeed = -Abs(XSpeed)
			X:+ XSpeed*Delta
			Direction:+ 90
		EndIf
		If y < 8
			YSpeed = Abs(Yspeed)
			Y:+ YSpeed*Delta
			Direction:+ 90
		ElseIf y > FieldHeight-8
			YSpeed = -Abs(YSpeed)
			Y:+ YSpeed*Delta
			Direction:+ 90
		EndIf	

			
		If Evading And MilliSecs()-Evading>0 Then Evading=0
		
		Speed = Sqr(XSpeed*XSpeed+YSpeed*YSpeed)
		If Speed >  MaxSpeed
			XSpeed=XSpeed/Speed*MaxSpeed
			YSpeed=YSpeed/Speed*MaxSpeed
		EndIf

		X:+ (XSpeed+BumpX)*Delta
		Y:+ (YSpeed+BumpY)*Delta
		
		'Direction = ATan2(YSpeed,XSpeed)+90
		
		'Crude Direction Interpolation
		InterpolateDir = (Direction+ATan2(YSpeed,XSpeed)+90)/2	
		Direction = TweenSmooth(Direction,InterpolateDir,0.35)
				
	EndMethod


	Function DrawAllGlow()
		If Not List Return 
		
		SetScale 4.2,4.2
		
		For Local CorruptedInvader:TCorruptedInvader = EachIn List
			CorruptedInvader.DrawGlow()
		Next
		
	EndFunction
	
	Function DrawAll()
		If Not List Return 
		If List.Count()=0 Return
		SetScale 4,4
		
		
		For Local CorruptedInvader:TCorruptedInvader = EachIn List
			CorruptedInvader.DrawBody()
		Next
		
		SetBlend LIGHTBLEND
		SetScale 5,5
		
		For Local CorruptedInvader:TCorruptedInvader = EachIn List
			CorruptedInvader.DrawGlow()
		Next
		
		SetBlend ALPHABLEND
		
	EndFunction
	
	Function UpdateAll()
		If Not List Return 
		
		For Local CorruptedInvader:TCorruptedInvader = EachIn List
			CorruptedInvader.Update()
		Next
	EndFunction

	Method Destroy()
		List.Remove( Self )
	EndMethod
	
	Method DestroyAll()
		If Not List Return 
		
		For Local CorruptedInvader:TCorruptedInvader = EachIn List
			CorruptedInvader.Destroy()
		Next
	EndMethod
	
	Function GenerateCorruptedInvader:TPixmap(Index:Int) Private
		'The amount of White Pixels
		Local PixelCount:Int=0	
		'Stores the CorruptedInvaders Pixels
		Local CorruptedInvaderPixels:Int[6,6]
		'Stores the CorruptedInvaders Colors
		Local CorruptedInvaderColor[3]
		
		'-----------------MATH GEN ROUTINE---------------------------
		
		'As long as there are less than 3 or more than 14 White pixels, redo CorruptedInvader
		Repeat
			PixelCount=0
			For Local i=0 To 4
				For Local j=0 To 4
						
					'A Pixel can be either 0 (Black) or 1 (White)
					CorruptedInvaderPixels[i,j]=Rand(0,1)
						
					'Count the number of White Pixels
					PixelCount:+CorruptedInvaderPixels[i,j]
						
				Next
								
			Next

		Until PixelCount>=5 And PixelCount<=15 
		
		'Generate the color for the corrupted Invaders
		For Local c=0 To 2
			CorruptedInvaderColor[c]=Rand(110,130)
		Next
		
		If EasterEgg
			CorruptedInvaderColor[1]=CorruptedInvaderColor[0]
			CorruptedInvaderColor[2]=CorruptedInvaderColor[0]
		End If
		
		'Mirror CorruptedInvader along the Y axis
		For Local m=0 To 4
			If CorruptedInvaderPixels[4,m]=0 CorruptedInvaderPixels[4,m]=CorruptedInvaderPixels[0,m]
			If CorruptedInvaderPixels[3,m]=0 CorruptedInvaderPixels[3,m]=CorruptedInvaderPixels[1,m]
		Next
		

		
		'-----------------DRAWING ROUTINE-----------------

		Local CorruptedInvaderPixmap:TPixmap=CreatePixmap(9,9,PF_RGBA8888)
		Local GlowPixmap:TPixmap
		
		ClearPixels (CorruptedInvaderPixmap)
		
		'Loop through the CorruptedInvader's pixel array 
		For Local x=0 To 4
			For Local y=0 To 4
				
				'Proceed to draw the CorruptedInvader
				If CorruptedInvaderPixels[x,y]=1
					
					WritePixel CorruptedInvaderPixmap,2+x,2+y,ToRGBA(CorruptedInvaderColor[0],CorruptedInvaderColor[1],CorruptedInvaderColor[2],255)
				
				End If
			
			Next
		Next
		
		For Local i=0 To 2
		
			CorruptedInvaderRGB[index,i]=CorruptedInvaderColor[i]
		Next
		
		GlowPixmap=CopyPixmap(CorruptedInvaderPixmap)
		
		CorruptedInvaderBody[index]=LoadImage(CorruptedInvaderPixmap,MASKEDIMAGE)
				
		GlowPixmap=GaussianBlur(GlowPixmap,2,250,35,250)
		
		CorruptedInvaderGlow[index]=LoadImage(GlowPixmap,FILTEREDIMAGE)
		
		CorruptedInvaderPixmap=Null;GlowPixmap=Null
		
	End Function
	
	Function PrepareFrame(image:TImage) Private
		'Use this to cache an image or animimage in VRAM for quicker drawing later.
		image.Frame(0)
		MidHandleImage Image
	End Function
	
	Function ToRGBA%(r%,g%,b%,a%) Private
		'return (a << 24) | (r << 16) | (g << 8) | (b);
	Return ((A Shl 24) | (R Shl 16) | (G Shl 8) | B)
	
	End Function
	
	Method Collision()
		Local ShotDirection:Float
		
		If Player.Alive And PlayerDistance(X,Y)<ComfortZone
			CloseEncounters:+.125*Delta
		End If
		
		If PlayerDistance(X,Y)<42 And Player.Alive Then
			If Player.HasShield-Player.MaskShield>0
				Glow.MassFire(X,Y,1,2,15,AwayFrom(X,Y,Player.X,Player.Y),CorruptedInvaderRGB[SpriteNumber,0],CorruptedInvaderRGB[SpriteNumber,1],CorruptedInvaderRGB[SpriteNumber,2])
				Glow.MassFire(X,Y,1,2,8,AwayFrom(X,Y,Player.X,Player.Y),CorruptedInvaderRGB[SpriteNumber,0],CorruptedInvaderRGB[SpriteNumber,1],CorruptedInvaderRGB[SpriteNumber,2],False,False,True)
				ParticleManager.Create(X,Y,25,CorruptedInvaderRGB[SpriteNumber,0],CorruptedInvaderRGB[SpriteNumber,1],CorruptedInvaderRGB[SpriteNumber,2],AwayFrom(X,Y,Player.X,Player.Y),1.2)
				Flash.Fire(X,Y,0.3,25,255,255,255,True)
				Lightning.MassFire(X,Y,15,1)
				Destroy()
				'EnemyCount:-1
				EnemiesKilled:+1
				Player.HasShield:-1
				Trk_Shd:-1
				PlaySoundBetter Sound_Player_Shield_Die,X,Y
			Else
				If PlayerDistance(X,Y)<30
					Player.Destroy()
					DeathBy=Name
				End If
			End If
		End If
		
		If TPlayerBomb.List
			For Local PlayerBomb:TPlayerBomb = EachIn TPlayerBomb.List
				
				If Distance(X,Y,PlayerBomb.X,PlayerBomb.Y) < PlayerBomb.Radius
					
					Glow.MassFire(X,Y,1,2,7,AwayFrom(X,Y,PlayerBomb.X,PlayerBomb.Y),CorruptedInvaderRGB[SpriteNumber,0],CorruptedInvaderRGB[SpriteNumber,1],CorruptedInvaderRGB[SpriteNumber,2])
					ParticleManager.Create(X,Y,15,CorruptedInvaderRGB[SpriteNumber,0],CorruptedInvaderRGB[SpriteNumber,1],CorruptedInvaderRGB[SpriteNumber,2],AwayFrom(X,Y,PlayerBomb.X,PlayerBomb.Y),1.2)
					Flash.Fire(X,Y,0.3,25,255,255,255,True)
					Lightning.MassFire(X,Y,15,1)
					'Explosion.Fire(X,Y,.55)
					Destroy()
					'EnemyCount:-1
					EnemiesKilled:+1
					
				End If
				
			Next
		End If
		
		
		'If a shot hit a rock
		If Not TShot.List Return
		For Local Shot:TShot = EachIn TShot.List
			If Distance( X, Y, Shot.X, Shot.Y ) < 18
				
				
				Local TempScore:Int, SniperShot=False
				
				'PlaySoundBetter Sound_Game_Presents,X,Y
				PlaySoundBetter Sound_Game_Presents,X,Y
				PlaySoundBetter Sound_Explosion,X,Y
				
				If PlayerDistance(X,Y)<36
					If Abs(Player.XSpeed)>0.25 Or Abs (Player.YSpeed)>0.25
						Score:+45*Multiplier
						ScoreRegister.Fire(Player.x,Player.y-35,75*Multiplier,"CLOSE ENCOUNTER!",4)
						Frenzy:+2
						Trk_FrnzGn:+4
					End If
				End If
				
				If Rand(12+ExtraLikeliness,62)=42 Then Powerup.Spawn(x,y,Rand(0,10))
				
		
				TempScore=EvenScore(275*Multiplier*ScoreMultiplier)
				
				Glow.MassFire(X,Y,1,2,12,Shot.Direction-90,CorruptedInvaderRGB[SpriteNumber,0],CorruptedInvaderRGB[SpriteNumber,1],CorruptedInvaderRGB[SpriteNumber,2])
				Glow.MassFire(X,Y,1,2,12,Shot.Direction-90,CorruptedInvaderRGB[SpriteNumber,0],CorruptedInvaderRGB[SpriteNumber,1],CorruptedInvaderRGB[SpriteNumber,2],False,False,True)
				ParticleManager.Create(X,Y,20,CorruptedInvaderRGB[SpriteNumber,0],CorruptedInvaderRGB[SpriteNumber,1],CorruptedInvaderRGB[SpriteNumber,2],0,1.1)

				Shot.EnemyDestroy()
				Flash.Fire(X,Y,.6,10,255,255,255,True)
				'Debris.MassFire (X,Y,1,1,11,1)
				Explosion.Fire(X,Y,.45)
				Explosion.Fire(X,Y,.55,True)
				Lightning.MassFire(X,Y,15,1)
		
				'Did the player shoot - or the AI?
				If Shot.Shooter=1 Then
					'Sniper Shot
					If Player.LastShotFired-Player.PrevShotFired>575 Then
						'Print "time req. met! "+(Player.LastShotFired-Player.PrevShotFired)
						If Distance( X, Y, Player.X, Player.Y) >305 Then
							'Print "almost"
							If IsVisible(x,y,15) 
								'Print "Sniper!"+Distance( X, Y, Player.X, Player.Y )
								ScoreRegister.Fire(x,y,TempScore,"2x")
								Tempscore:*2
								SniperShot=True
								Score:+Tempscore
							End If
						End If
					End If
					
					'No Sniper Shot? But still a Player shot?
					If Not SniperShot And Shot.Shooter=1  Then
						If FrenzyMode
							Score:+TempScore*2
							ScoreRegister.Fire(x,y,TempScore,"2x")
						Else
							Score:+TempScore
							ScoreRegister.Fire(x,y,TempScore)
						End If	
					End If
					
					'General Kill Stuff
					EnemiesKilled:+1
					If TempScore>LargestScore Then LargestScore=TempScore
				End If

				Destroy()
				'EnemyCount:-1
				Exit
			EndIf
		Next	
	EndMethod

	Method NearMissCheck(Size:Float)
		'Check for "Near Misses"
		If Distance( X, Y, Player.X, Player.Y) < Size*16 Then
			If Abs(Player.XSpeed)>0.35 Or Abs (Player.YSpeed)>0.35 Then
				NearMissCount:+1
				NearMissTime=MilliSecs()
				If NearMissID="" NearMissID=MissID
			End If
		Else
			'If there was a near miss more than 250 msec ago... and the player is still alive - heh.
			If NearMissTime<>0 And MilliSecs()-NearMissTime>245 And Player.Alive And NearMissCount=1 Then
				'Print "Near Miss!"
				NearMissTime=0
				NearMissCount=0
				NearMissID=""
				If Player.BounceTime=0 Then
					Score:+EvenScore(75*Multiplier*ScoreMultiplier)
					ScoreRegister.Fire(Player.x,Player.y,EvenScore(75*Multiplier*ScoreMultiplier),"NEAR MISS!",4)
					Frenzy:+1
					Trk_FrnzGn:+2
				Else
					Score:+EvenScore(115*Multiplier*ScoreMultiplier)
					ScoreRegister.Fire(Player.x,Player.y,EvenScore(115*Multiplier*ScoreMultiplier),"REBOUND EVADE!",4)
					Frenzy:+2
					Trk_FrnzGn:+4
					Player.BounceTime=0
				End If
			ElseIf NearMissTime<>0 And MilliSecs()-NearMissTime>235 And Player.Alive And NearMissCount>=2 Then
				If Not NearMissID=MissID
					NearMissTime=0
					NearMissCount=0
					NearMissID=""
					Score:+EvenScore(105*Multiplier*ScoreMultiplier)
					ScoreRegister.Fire(Player.x,Player.y,EvenScore(105*Multiplier*ScoreMultiplier),"DOUBLE NEAR MISS!",4)
					Frenzy:+2
					Trk_FrnzGn:+4
				Else
					NearMissTime=0
					NearMissCount=0
					NearMissID=""
					If Player.BounceTime=0 Then
						Score:+EvenScore(75*Multiplier*ScoreMultiplier)
						ScoreRegister.Fire(Player.x,Player.y,EvenScore(75*Multiplier*ScoreMultiplier),"NEAR MISS!",4)
						Frenzy:+1
						Trk_FrnzGn:+2
					Else
						Score:+115*Multiplier*ScoreMultiplier
						ScoreRegister.Fire(Player.x,Player.y,EvenScore(115*Multiplier*ScoreMultiplier),"REBOUND EVADE!",4)
						Frenzy:+2
						Trk_FrnzGn:+4
						Player.BounceTime=0
					End If
				End If
			End If
		End If
	EndMethod

End Type

'-----------------------------------------------------------------------------
'CorruptionNode is volatile and spawns extemely nasty invaders when disturbed
'-----------------------------------------------------------------------------
Type TCorruptionNode Extends TObject  
	
	Global List:TList
	Global Variations:Int
	Global CorruptionNodeBody:TImage[]
	Global CorruptionNodeGrid:TImage[]
	Global CorruptionNodeGlow:TImage[]
	Global CorruptionNodeRGB:Int[3]
	Global NodeDimensions:Int
	Global LastSpawn:Int
	
	Field SpriteNumber:Int
	Field DrawOffset:Float[32]
	Field CoolDown:Float
	Field Shaker:Float
	Field Transparency:Float
	Field GridTransparency:Double
	Field NodeType:Byte
	Field ExplosionEffect:Float
	Field IsDead:Byte
	
	Function Generate(NumCorruptionNodes:Int)
		
		List=Null
		
		List=CreateList()
		
		Variations=NumCorruptionNodes
		
		CorruptionNodeGlow = New TImage[Variations+1]
		CorruptionNodeBody = New TImage[Variations+1]
		CorruptionNodeGrid = New TImage[Variations+1]

		'Only one color for all nodes
		For Local i=0 To 2
			CorruptionNodeRGB[i]=Rand(125,145)
		Next

		
		For Local i=1 To NumCorruptionNodes
			
			'Generate and Draw
			GenerateCorruptionNode(i)
			
			PrepareFrame(CorruptionNodeBody[i])
			PrepareFrame(CorruptionNodeGrid[i])
			PrepareFrame(CorruptionNodeGlow[i])
			
		Next
		
		NodeDimensions=ImageWidth(CorruptionNodeBody[1])
		
	End Function
	
	Function ReCache()
		For Local i=1 To Variations
			PrepareFrame(CorruptionNodeBody[i])
			PrepareFrame(CorruptionNodeGrid[i])
			PrepareFrame(CorruptionNodeGlow[i])
		Next
	End Function
	
	Function Spawn(X:Int,Y:Int)
	
		'If Not List List = CreateList()
		If MilliSecs()-LastSpawn<7750 Return
		
		If Player.Alive
			If CountList(List) => 2 Then Return Null	
		Else
			If CountList(List) => 1 Then Return Null	
		End If
		
		'Don't spawn nodes on top of each other/too close together
		For Local CorruptionNode:TCorruptionNode = EachIn TCorruptionNode.List
			If Distance(X,Y,CorruptionNode.X,CorruptionNode.Y)<245 Return Null
		Next
		
		Local CorruptionNode:TCorruptionNode = New TCorruptionNode	 
		List.AddLast CorruptionNode
			
		CorruptionNode.SpriteNumber=Rand(1,Variations)
				
		LastSpawn=MilliSecs()
		CorruptionNode.X=X
		CorruptionNode.Y=Y
		CorruptionNode.NodeType=Rand(0,1)
		CorruptionNode.Transparency=0
		CorruptionNode.GridTransparency=0
		SpawnEffect.Fire(CorruptionNode.X,CorruptionNode.Y,1.55,CorruptionNodeRGB[0]	,CorruptionNodeRGB[1],CorruptionNodeRGB[2])
		
		PlaySoundBetter Sound_Corruption_Born,X,Y
		
		'EnemyCount:+1	
		
	End Function
	
	Method DrawBody()
		
		DrawGrid()
		
		If IsDead Return
		SetAlpha Transparency
		
		If NodeType
			For Local i=1 To NodeDimensions
				DrawSubImageRect CorruptionNodeBody[SpriteNumber],x,(y+i*(4-ExplosionEffect))+ExplosionEffect*8,NodeDimensions+DrawOffset[i]+ExplosionEffect/2,1,0,i,NodeDimensions,1,NodeDimensions/2,NodeDimensions/2
			Next
		Else
			For Local i=1 To NodeDimensions
				DrawSubImageRect CorruptionNodeBody[SpriteNumber],(x+i*(4-ExplosionEffect))+ExplosionEffect*8,y,1,NodeDimensions+DrawOffset[i]+ExplosionEffect/2,i,0,1,NodeDimensions,NodeDimensions/2,NodeDimensions/2
			Next
		End If
		
	EndMethod
	
	Method DrawGrid()
		SetAlpha GridTransparency
		DrawImage CorruptionNodeGrid[SpriteNumber],x,y
	End Method
	
	Method DrawGlow()
		
		If IsDead Return
		SetAlpha Transparency*.8
		DrawImage CorruptionNodeGlow[SpriteNumber],x,y

	EndMethod
	
	
	Method Update()
			
		If IsDead
			GridTransparency:-0.00005*Delta
			If GridTransparency<=0 Destroy()
			Return
		End If
		
		If GridTransparency<.19 Then GridTransparency:+0.00025*Delta
		If Transparency<1 Then Transparency:+0.006*Delta
		CoolDown:+1*Delta
		Shaker:+0.001*Delta
		
		If CoolDown>13
			CoolDown=0
			For Local i=0 To 20
				DrawOffset[i]=Rnd(-Shaker,Shaker)
			Next
			'Corruption.Spawn(X,Y)
		End If
		
		If Shaker>10
			ExplosionEffect:+0.15*Delta
		End If
		
		If ExplosionEffect>1.7 Then
			Explode()
		End If
		
		Collision()
		
	EndMethod
	
	Method Explode()
		If ScreenShakeEnable ScreenShake.Force=2.17
		
		PlaySoundBetter Sound_Explosion_Big,X,Y
		Glow.MassFire(X,Y,2,2,59,0,165,165,165,True,True)
		ShockWave.Fire(X,Y,.55,4,True)
		Flash.Fire(X,Y,.95,37)
		Explosion.Fire(X,Y,1.1,True)
		Explosion.Fire(X,Y,.65,True)
		Lightning.MassFire(X,Y,44,6)
			
		For Local i=1 To Rand(10,16)
			CorruptedInvader.Spawn(X,Y)
		Next
		
		IsDead=True
		'EnemyCount:-1
	
	End Method
	
	Function DrawAllGlow()
		If Not List Return 
		
		SetTransform 0,4,4
		For Local CorruptionNode:TCorruptionNode = EachIn List
			CorruptionNode.DrawGrid()
		Next
		
		SetScale 4.5,4.5
		
		For Local CorruptionNode:TCorruptionNode = EachIn List
			CorruptionNode.DrawGlow()
		Next
		
		SetAlpha 1
		
	EndFunction
	
	Function DrawAll()
		If Not List Return 
		If List.Count()=0 Return
		SetTransform 0,4,4
		
		For Local CorruptionNode:TCorruptionNode = EachIn List
			CorruptionNode.DrawBody()
		Next
		
		SetBlend LIGHTBLEND

		SetScale 4.1,4.1
		For Local CorruptionNode:TCorruptionNode = EachIn List
			CorruptionNode.DrawGlow()
		Next
		
		SetBlend ALPHABLEND
		SetAlpha 1
		
	EndFunction
	
	Function UpdateAll()
		If Not List Return 
		
		For Local CorruptionNode:TCorruptionNode = EachIn List
			CorruptionNode.Update()
		Next
	EndFunction

	Method Destroy()
		'Print "OK Removed."
		List.Remove( Self )
	EndMethod
	
	Method DestroyAll()
		If Not List Return 
		
		For Local CorruptionNode:TCorruptionNode = EachIn List
			CorruptionNode.Destroy()
		Next
	EndMethod
	
	Function GenerateCorruptionNode:TPixmap(Index:Int) Private
		
		'-----------------DRAWING ROUTINE-----------------
		
		
		Local NodeColor:Int[3]
		Local CorruptionNodePixmap:TPixmap=CreatePixmap(9,9,PF_RGBA8888)
		Local CorruptionNodePixmapLayer2:TPixmap=CreatePixmap(9,9,PF_RGBA8888)
		Local CorruptionNodeGridPixmap:TPixmap=CreatePixmap(24,24,PF_RGBA8888)
		Local GlowPixmap:TPixmap
		Local Maze:TMaze = TMazeGenerator.createMaze(8, 8)
		Local MazeTwo:TMaze = TMazeGenerator.createMaze(8,8)
		Local MazeThree:TMaze = TMazeGenerator.createMaze(26,26)
		
		ClearPixels (CorruptionNodePixmap)
		ClearPixels (CorruptionNodePixmapLayer2)
		ClearPixels (CorruptionNodeGridPixmap)

		CorruptionNodePixMap=Maze.Generate(CorruptionNodeRGB[0],CorruptionNodeRGB[1],CorruptionNodeRGB[2],255)
		
		CorruptionNodePixMapLayer2=MazeTwo.Generate(CorruptionNodeRGB[0],CorruptionNodeRGB[1],CorruptionNodeRGB[2],255)
		
		CorruptionNodeGridPixMap=MazeThree.Generate(CorruptionNodeRGB[0]*.5,CorruptionNodeRGB[1]*.5,CorruptionNodeRGB[2]*.5,255,False,True)
		
		DrawPixmapOnPixmap(CorruptionNodePixmapLayer2,0,CorruptionNodePixmap,0,0,.35)
		
		GlowPixmap=CopyPixmap(CorruptionNodePixmap)
		
		CorruptionNodeGridPixmap=GaussianBlur(CorruptionNodeGridPixmap,.5,160,5,200)
		
		CorruptionNodeBody[index]=LoadImage(CorruptionNodePixmap,MASKEDIMAGE)
		
		CorruptionNodeGrid[index]=LoadImage(CorruptionNodeGridPixmap,MASKEDIMAGE)
				
		GlowPixmap=GaussianBlur(GlowPixmap,2,160,5,200)
		
		CorruptionNodeGlow[index]=LoadImage(GlowPixmap,FILTEREDIMAGE)
		
		CorruptionNodePixmap=Null;GlowPixmap=Null
		
	End Function
	
	Function PrepareFrame(image:TImage) Private
		'Use this to cache an image or animimage in VRAM for quicker drawing later.
		image.Frame(0)
		MidHandleImage Image
	End Function
	
	Function ToRGBA%(r%,g%,b%,a%) Private
		'return (a << 24) | (r << 16) | (g << 8) | (b);
	Return ((A Shl 24) | (R Shl 16) | (G Shl 8) | B)
	
	End Function

	Method Collision()
		Local ShotDirection:Float
		Local XPos:Int
		Local YPos:Int
		
		
		If TPlayerBomb.List
			For Local PlayerBomb:TPlayerBomb = EachIn TPlayerBomb.List
				
				If Distance(X,Y,PlayerBomb.X,PlayerBomb.Y) < PlayerBomb.Radius-22
				
					Glow.MassFire(X,Y,1,2,45,AwayFrom(X,Y,PlayerBomb.X,PlayerBomb.Y),CorruptionNodeRGB[0],CorruptionNodeRGB[1],CorruptionNodeRGB[2],False,False,True)
					ParticleManager.Create(X,Y,10,CorruptionNodeRGB[0],CorruptionNodeRGB[1],CorruptionNodeRGB[2],AwayFrom(X,Y,PlayerBomb.X,PlayerBomb.Y),1.2)
					Flash.Fire(X,Y,0.8,25)
					Corruption.Spawn(X,Y)
					Corruption.Spawn(X+Rand(-8,8),Y+Rand(-8,8))
					Corruption.Spawn(X+Rand(-8,8),Y+Rand(-8,8))
					Corruption.Spawn(X+Rand(-12,12),Y+Rand(-12,12))
					Corruption.Spawn(X+Rand(-12,12),Y+Rand(-12,12))
					Lightning.MassFire(X,Y,32,18)
					'Explosion.Fire(X,Y,.55)
					IsDead=True
					'EnemyCount:-1
					EnemiesKilled:+1
				
				End If
				
			Next
		End If
		
		If Transparency<.95 Return
		
		If PlayerDistance(X,Y)<70 And Player.Alive Then
			If Player.HasShield-Player.MaskShield>0
				Glow.MassFire(X,Y,1,2,25,AwayFrom(X,Y,Player.X,Player.Y),100,100,100)
				ParticleManager.Create(X,Y,15,100,100,100,AwayFrom(X,Y,Player.X,Player.Y),1.2)
				Flash.Fire(X,Y,0.3,25)
				Player.HasShield:-1
				Trk_Shd:-1
				PlaySoundBetter Sound_Player_Shield_Die,X,Y
			Else
				If PlayerDistance(X,Y)<46
					Player.Destroy()

					DeathBy="Corrupted Data-Node"

				End If
			End If
		End If


		If Not TShot.List Return
		For Local Shot:TShot = EachIn TShot.List
			If Distance( X, Y, Shot.X, Shot.Y ) < 35
				Shot.EnemyDestroy(True,True)
				Shaker:+1.15
			EndIf
		Next	
	EndMethod

End Type
'-----------------------------------------------------------------------------
'TCorruption displays playfield-staining Corruption effect
'-----------------------------------------------------------------------------
Type TCorruption Extends TObject
	
	Const AllocatedSizeX:Int=85
	Const AllocatedSizeY:Int=52
	
	Global Image:TImage
	Global List:TList
	Global NodeCount:Int
	Global CorruptionArray:Int[AllocatedSizeX,AllocatedSizeY]
	Global Scale:Float=4
	Global Variations:Int
	Global CorruptionBody:TImage[]
	Global CorruptionGlow:TImage[]
	

	Field SpriteNumber:Int
	Field Transparency	:Float
	Field Alive:Byte

	Function ReGenerate(XRes:Int,YRes:Int)
		Local YPos:Int
		Local XPos:Int
		
		DestroyAll()
		
		If List Then List=Null
		
		List = CreateList()
		
		For Local x=0 To Xres Step 16
			
			For Local y=0 To Yres Step 16
			
				Local Corruption:TCorruption = New TCorruption	 
				List.AddLast Corruption
					
				Corruption.X=X
				Corruption.Y=Y
				Corruption.Transparency=0
				CorruptionArray[XPos,YPos]=0
				YPos:+1
			Next
			
			XPos:+1
			YPos=0
			
		Next
	End Function
	
	Function Generate(XRes:Int,YRes:Int,NumVariations:Int)
		
		List=Null
		
		If List = Null List = CreateList()
		Local YPos:Int
		Local XPos:Int
		
		Variations=NumVariations
		
		CorruptionGlow = New TImage[Variations+1]
		CorruptionBody = New TImage[Variations+1]
		
		
		For Local i=1 To Variations
			
			'Generate and Draw
			GenerateCorruption(i)
			
			PrepareFrame(CorruptionBody[i])
			PrepareFrame(CorruptionGlow[i])

		Next
		
		For Local x=0 To Xres Step 16
			
			For Local y=0 To Yres Step 16
			
				Local Corruption:TCorruption = New TCorruption	 
				List.AddLast Corruption
					
				Corruption.X=X
				Corruption.Y=Y
				Corruption.Transparency=0
				CorruptionArray[XPos,YPos]=0
				YPos:+1
			Next
			
			XPos:+1
			YPos=0
			
		Next
		
	EndFunction
	
	Function ReCache()
		For Local i=1 To Variations
			PrepareFrame(CorruptionBody[i])
			PrepareFrame(CorruptionGlow[i])
		Next
	End Function
	
	Function Spawn(X:Int,Y:Int)
		
		CorruptionArray[X/16,Y/16]=1
		
	End Function
	
	Function Init()
		
		If List = Null List = CreateList()
		
	End Function
	
	Method Draw()	
		
		If SpriteNumber=0 Return
		
		SetAlpha (Transparency)
		
		DrawImage(CorruptionBody[SpriteNumber],X,Y)
		
		DrawImage(CorruptionGlow[SpriteNumber],X,Y)
		
	EndMethod
	
	Method Update()
	
		If CorruptionArray[X/16,Y/16]
			If SpriteNumber=0
				SpriteNumber=Rand(1,Variations)
				Alive=True
			End If
			
			If Transparency<1 And Alive
				Transparency:+0.025*Delta
			ElseIf Alive=False
				Transparency:-0.0005*Delta	
				Rem
				Local Xpos=X/16
				Local YPos=Y/16
				If Rand(0,5)>3 And XPos<=FieldWidth/16 And NodeCount<MaxNodes
					If CorruptionArray[XPos+1,YPos]<>1
						NodeCount:+1
						CorruptionArray[XPos+1,YPos]=1
					End If
				End If
				If Rand(0,5)>3 And XPos>=1 And NodeCount<MaxNodes
					If CorruptionArray[XPos-1,YPos]<>1
						NodeCount:+1
						CorruptionArray[XPos-1,YPos]=1
					End If
				End If
				If Rand(0,5)>3 And YPos<=FieldHeight/16 And NodeCount<MaxNodes
					If CorruptionArray[XPos,YPos+1]<>1
						NodeCount:+1
						CorruptionArray[XPos,YPos+1]=1
					End If
				End If
				If Rand(0,5)>3 And YPos>=1 And NodeCount<MaxNodes
					If CorruptionArray[XPos,YPos-1]<>1
						NodeCount:+1
						CorruptionArray[XPos,YPos-1]=1
					End If
				End If
				If Rand(0,10)<4
					Transparency=0
					CorruptionArray[XPos,YPos]=0
					SpriteNumber=0
					NodeCount:-1
				Else
					Transparency=.45
				End If
				End Rem
			End If
		End If
		If Transparency>=1 And CorruptionArray[X/16,Y/16]
			Alive=False
		End If
		
		If Transparency<=0 And Alive=False And CorruptionArray[X/16,Y/16]
			CorruptionArray[X/16,Y/16]=0
			Transparency=0
		End If
		
	End Method
	
	Function DestroyAll()
		
		If Not List Return 

		Local Corruption:TCorruption
		For Corruption = EachIn List
			Corruption.Destroy()
		Next
	
	End Function
	
	Function DrawAll()
		
		If Not List Return 
		
		SetTransform 0,Scale,Scale
		
		Local link:TLink= List.FirstLink()
		While link
			Local Corruption:TCorruption=TCorruption(link._value)
			Corruption.Draw() 
			If link._succ._value<>link._succ 
			link=link._succ
			
			Else
				link=Null
			End If		
		Wend

		'Local Corruption:TCorruption
		'For Corruption = EachIn List
		'	Corruption.Draw()
		'Next
		SetAlpha 1
		'It's faster to re-set the scale and transparency once than every time for a particle

	End Function

	Function UpdateAll()

		Local link:TLink= List.FirstLink()
		While link
			Local Corruption:TCorruption=TCorruption(link._value)
			Corruption.Update() 
			If link._succ._value<>link._succ 
			link=link._succ
			
			Else
				link=Null
			End If		
		Wend
		'Local Corruption:TCorruption
		'For Corruption = EachIn List
		'	Corruption.Update()
		'Next
		
	End Function
	
	
	Function Reset()
		
		Local Corruption:TCorruption
		For Corruption = EachIn List
			Corruption.SpriteNumber=0
			Corruption.Transparency=0
			Corruption.Alive=0
		Next
		
		For Local x=0 To AllocatedSizeX-1
			For Local y=0 To AllocatedSizeY-1
				CorruptionArray[X,Y]=0
			Next
		Next
		
	End Function
	
	Function GenerateCorruption:TPixmap(Index:Int) Private
		'The amount of White Pixels
		Local PixelCount:Int=0	
		'Stores the Corruptions Pixels
		Local CorruptionPixels:Int[9,9]
		'Neighboring Pixels
		Local Neighbors:Int
		
		'-----------------MATH GEN ROUTINE-----------------
		
		'As long as there are less than 3 or more than 14 White pixels, redo Corruption
		Repeat
			PixelCount=0
			For Local i=1 To 4
				For Local j=1 To 4
						
					'A Pixel can be either 0 (Black) or 1 (White)
					CorruptionPixels[i,j]=Rand(0,1)
						
					'Count the number of White Pixels
					PixelCount:+CorruptionPixels[i,j]
						
				Next
				
			Next	

		Until PixelCount>=3 And PixelCount<16
		
		'Grow Corruption (Like Silicate)
		For Local x=0 To 4
			For Local y=0 To 4
			
			If CorruptionPixels[x,y]=1
				'Neighbors=0
				If x+2<5 And Rand(0,PixelCount)<2 CorruptionPixels[x+2,y]=1 
				If x-2>0 And Rand(0,PixelCount)<2 CorruptionPixels[x-2,y]=1
				If y-2>0 And Rand(0,PixelCount)<2 CorruptionPixels[x,y-2]=1
				If y+2<5 And Rand(0,PixelCount)<2 CorruptionPixels[x,y+2]=1
				
			EndIf
			
			Next
		Next
		
		'Erode Corruption
		For Local x=0 To 4
			For Local y=0 To 4
			
				If y=0 CorruptionPixels[x,y]=Rand(0,1)
				If y=5 CorruptionPixels[x,y]=Rand(0,1)
				If x=0 CorruptionPixels[x,y]=Rand(0,1)
				If x=5 CorruptionPixels[x,y]=Rand(0,1)
			
			Next
		Next
		'Remove Loose Pixels
		For Local x=0 To 4
			For Local y=0 To 4
			
			If CorruptionPixels[x,y]=1
				Neighbors=0
				If x+1<5 If CorruptionPixels[x+1,y]=>1 Then Neighbors:+1
				If x-1>0 If CorruptionPixels[x-1,y]=>1 Then Neighbors:+1
				If y-1>0 If CorruptionPixels[x,y-1]=>1 Then Neighbors:+1
				If y+1<5 If CorruptionPixels[x,y+1]=>1 Then Neighbors:+1
				
				If Neighbors<1
					CorruptionPixels[x,y]=0
				End If
			EndIf
			
			Next
		Next
		
		'-----------------DRAWING ROUTINE-----------------

		Local CorruptionPixmap:TPixmap=CreatePixmap(8,8,PF_RGBA8888)
		Local GlowPixmap:TPixmap
		Local MonoChrome:Int
		
		ClearPixels (CorruptionPixmap)
		
		'Loop through the Corruption's pixel array 
		For Local x=0 To 3
			For Local y=0 To 3
				
				'Proceed to draw the Corruption
				If CorruptionPixels[x,y]>0
					If Not EasterEgg
						WritePixel CorruptionPixmap,2+x,2+y,ToRGBA(Rand(115,188),Rand(115,188),Rand(115,188),255)
					Else
						'Run the randomizer three times to maintain seed synchronity
						'Use only the last value to have a monochrome colour
						MonoChrome=Rand(115,188)
						MonoChrome=Rand(115,188)
						MonoChrome=Rand(115,188)
						WritePixel CorruptionPixmap,2+x,2+y,ToRGBA(Monochrome,Monochrome,Monochrome,255)
					End If
				End If
			
			Next
		Next
		
		GlowPixmap=CopyPixmap(CorruptionPixmap)
		
		CorruptionBody[index]=LoadImage(CorruptionPixmap,MASKEDIMAGE)
				
		GlowPixmap=GaussianBlur(GlowPixmap,3,220,35,245)
		
		CorruptionGlow[index]=LoadImage(GlowPixmap,FILTEREDIMAGE)
		
		CorruptionPixmap=Null;GlowPixmap=Null
		
	End Function

	Function PrepareFrame(image:TImage) Private
		'Use this to cache an image or animimage in VRAM for quicker drawing later.
		image.Frame(0)
		MidHandleImage Image
	End Function
	
	Function ToRGBA%(r%,g%,b%,a%) Private
		'return (a << 24) | (r << 16) | (g << 8) | (b);
	Return ((A Shl 24) | (R Shl 16) | (G Shl 8) | B)
	
	End Function


End Type


'-----------------------------------------------------------------------------
'The Player's Ship Type 
'-----------------------------------------------------------------------------
Type TPlayerShip Extends TObject
	
	Global List:TList
	
	Global ShieldImage:TImage
	Global ShieldMask:TImage
	Global ShieldTexture:TImage
	Global ShieldTextureGlow:TImage
	Global MuzzleFlash:TImage
	
	Global PlayerBody:TImage
	Global PlayerGlow:TImage
	Global RGB:Int[3]
	
	Global MaskShot:Int
	Global MaskBomb:Int
	Global MaskShield:Int
	
	Global LastGunPickup:Int
	
	Field BlurSteps:Float
	
	Field Invincible:Int=False
	Field TurnSpeed#
	Field i:Float, j:Float
	Field Alive:Int=True	'Are we alive?
	Field Dying:Int=False
	Field LastShotFired:Int
	Field PrevShotFired:Int
	
	Global TwinEngine:Byte
	
	Field BounceTime:Int
	Field MuzzleAlpha:Float
	Field SpeedUpSoundMute:Byte
	
	Field HasBounce:Int
	Field HasShot:Int
	Field HasSuper:Int
	Field HasShield:Int
	Field HasSlowmotion:Int
	Field ShotSpeed:Float
	Field ShotInterval:Int
	Field HasBomb:Int
	Field EngineBoost:Float
	Field Immolation:Byte
	
	Field ShieldRot:Float
	Field ShieldPulse:Float
	Field ShieldOffset:Float
	
	Field CursorX:Float
	Field CursorY:Float
	Field CursorXD:Float
	Field CursorYD:Float
	Field AimDirection:Float
	
	Field MoveStartTime:Int
	Field MobilityLevel:Int
	
	Function Generate()
		
		If Not ShieldImage
			
			ShieldImage = LoadImage(GetBundleResource("graphics/playershield.png"),MASKEDIMAGE)
			MidHandleImage ShieldImage
			
			ShieldMask = LoadImage(GetBundleResource("graphics/playershieldmask.png"),FILTEREDIMAGE)
			'MidHandleImage ShieldMask
			
			MuzzleFlash = LoadImage(GetBundleResource("graphics/muzzle.png"),MASKEDIMAGE)
			SetImageHandle MuzzleFlash,(ImageWidth(MuzzleFlash))/2.0,0
			
		End If
		
		If SeedJumble(Seed)="LIAP@ELLI"
			GeneratePlayer()
		Else
			If Rand(0,1)= 1
				GenerateAlternativePlayer()
			Else
				GeneratePlayer()
			End If
		End If
		
		
		'Generate Shield "Veins"
		Local ShieldPixmap:TPixmap=CreatePixmap(80,80,PF_RGBA8888)
		Local Maze:TMaze = TMazeGenerator.createMaze(48, 48)
		Local ShieldBlurTemp:TPixmap
		
		ClearPixels (ShieldPixmap)
		
		ShieldPixMap=Maze.Generate(Player.RGB[1]*1.3,Player.RGB[0]*1.35,Player.RGB[2]*1.5,255,True)
		
		'ShieldPixmap = ResizePixmap(ShieldPixmap,40,40)
		
		DrawOnPixmap(ShieldMask,0,ShieldPixmap,1,1)
		
		ShieldBlurTemp= CopyPixmap (ShieldPixmap)
		
		'DrawOnPixmap(ShieldMask,0,ShieldBlurTemp,1,1)
		
		ShieldTextureGlow = LoadImage(ShieldBlurTemp)
			
		ShieldTexture = LoadImage(ShieldPixmap,MASKEDIMAGE)
		
		SetImageHandle ShieldTexture,49,49

		PrepareFrame(ShieldTexture)
		PrepareFrame(ShieldTextureGlow)
		PrepareFrame(PlayerBody)
		PrepareFrame(PlayerGlow)
		
	End Function
	
	Function ReCache()
		PrepareFrame(ShieldTexture)
		PrepareFrame(ShieldTextureGlow)
		PrepareFrame(PlayerBody)
		PrepareFrame(PlayerGlow)
	End Function
	
	Function Create()
			 
		If List = Null
			List = CreateList()
			Local Ship:TPlayerShip = New TPlayerShip
			List.AddLast Ship 'Add Ship Last in List
		End If

	EndFunction
	
	Function Preview(X,Y,SpriteNum)
		
		SetBlend alphablend
		SetScale 3.5,3.5
		
		DrawImage PlayerBody,x,y
		
		SetScale 4.5,4.5
		SetBlend lightblend
		DrawImage PlayerGlow,x,y
		
		SetBlend alphablend
		SetScale 1,1
	End Function
	
	
	Method Reset(EffectFire:Byte)'Starting Values
		'Reset Coordinates & Speeds
		X = ScreenWidth/2
		Y = ScreenHeight/2
		XSpeed=0
		YSpeed=0
		Direction=0
		
		'Reset Extras & Buffs
		'HasShield=0
		'HasShot=0
		HasSuper=0
		HasSlowMotion=-1
		HasBounce=0
		ShotSpeed=4.5
		ShotInterval=175
		'HasBomb=1
		EngineBoost=0
		BounceTime=0
		Immolation=0
		SpeedUpSoundMute=False
		
		LastGunPickup=MilliSecs()-25000

		MoveStartTime=0
		MobilityLevel=0
		
		MaskShot=Rand(-3632,8140)
		MaskBomb=Rand(-7100,9100)
		MaskShield=Rand(-4200,7400)
		
		HasShot=MaskShot
		HasBomb=MaskBomb+1
		HasShield=MaskShield
		Invincible=0
		
		CursorX=X
		CursorY=Y-64
		
		Dying=False
		
		If GameMode=ARCADE Or GameMode=DEFENDER
			If EffectFire SpawnEffect.Fire(X,Y,1.5,RGB[0],RGB[1],RGB[2])	
		End If
		
	EndMethod
	
	Function HelpScreen(X,Y,SpriteNum,Rotation)
		
		'Print InvaderLogo
		SetBlend ALPHABLEND
		SetTransform Rotation,1,1
		SetScale 4,4
		DrawImage PlayerBody,x,y
		SetBlend LIGHTBLEND
		SetAlpha .75
		DrawImage PlayerGlow,x,y
		'SetColor RCol,GCol,BCol
		'SetRotation -Rotation
		SetScale 1,1
		SetBlend ALPHABLEND
		'DrawImage HighLight,x,y
		'SetColor 255,255,255
		SetRotation 0
		'SetAlpha 1
		
	End Function
	
	Method Draw()
		
		If Not Alive Return
		
		'Only draw the aiming cursor for dual analog and when not paused
		Local SizeUpX:Float
		Local SizeUpY:Float
		If InputMethod=4 And GameState<>PAUSE
			'Size up the cursor & tooltips for resolutions smaller than 1024x768
			If RealWidth>=1024 And RealHeight>=768
				SetTransform 0,1,1
				SizeUpX=0
			Else
				If WideScreen
					SizeUpX=1280/Float(RealWidth)
					SizeUpY=768/Float(RealHeight)
					SizeUpX=(SizeUpX+SizeUpY)/2
				Else
					SizeUpX=1024/Float(RealWidth)
					SizeUpY=768/Float(RealHeight)
					SizeUpX=(SizeUpX+SizeUpY)/2
				End If
				'Print SizeUpX
				SetTransform 0,SizeUpX,SizeUpX
			End If
			SetAlpha 1
	
			If CrossHairType>6
				'If GameState<>PAUSE CycleColors(3^Delta)
				SetColor RCol,GCol,BCol
				DrawImage MouseCursor,CursorXD,CursorYD, CrossHairType-7
				SetColor 255,255,255
			Else
				DrawImage MouseCursor,CursorXD,CursorYD, CrossHairType-1
			End If	
		End If

		SetColor 255,255,255
		
		If HasShield-MaskShield
			'SetColor RGB[0]*1.2,RGB[1]*1.2,RGB[2]*1.2
			If HasShield-MaskShield=2
				SetTransform 0,2,2
				SetAlpha .1
				SetBlend LIGHTBLEND
				DrawSubImageRect ShieldTexture,X-98,Y-98+ShieldOffset*2-4,102,3,0,ShieldOffset-2,102,3,0,0
				SetAlpha .3
				DrawSubImageRect ShieldTexture,X-98,Y-98+ShieldOffset*2,102,3,0,ShieldOffset,102,3,0,0
				DrawSubImageRect ShieldTexture,X-98,Y-96+ShieldOffset*2,102,1,0,ShieldOffset,102,1,0,0
				SetAlpha  .05+Abs(ShieldPulse)*1.5
				DrawImage ShieldTexture,X+4,Y+4
				SetBlend ALPHABLEND
			End If
			
			SetAlpha 0.1
			SetTransform ShieldRot,1.2,1.2
			
			DrawImage ShieldImage,X,Y
			'SetColor 255,255,255
		End If
		

		
		'SetScale(3.5,3.5)
		'SetAlpha 1
		'SetRotation( Direction +270)
		SetTransform Direction+270,3.5,3.5
		
		If MuzzleAlpha<3.7
			SetBlend LIGHTBLEND
			SetAlpha 2/MuzzleAlpha
			If HasSuper
				SetColor Shot.ShotRGB[0]*2.25,Shot.ShotRGB[1]*0.2,Shot.ShotRGB[2]*0.2
			Else
				SetColor Shot.ShotRGB[0]*1.3,Shot.ShotRGB[1]*1.3,Shot.ShotRGB[2]*1.3
			End If
			DrawImage(MuzzleFlash,X,Y)
			SetBlend ALPHABLEND
			SetColor 255,255,255
		End If
		
		SetAlpha 1
		DrawImage(PlayerBody,X,Y)
		SetAlpha .5
		SetScale(4,4)
		SetBlend LIGHTBLEND
		
		DrawImage(PlayerGlow,x,y)
		
		SetBlend ALPHABLEND
		
		
	End Method
	
	Method DrawGlow()
		
		If Not Alive Return
		'SetBlend LightBlend
		If HasShield-MaskShield>0
			'SetBlend LIGHTBLEND
			If HasShield-MaskShield=2
				SetTransform 0,2.2,2.2
				SetAlpha .3
				DrawSubImageRect ShieldTextureGlow,X-108,Y-98+ShieldOffset*2-8,102,4,0,ShieldOffset-2,102,4,0,0
				SetAlpha .5
				DrawSubImageRect ShieldTextureGlow,X-108,Y-98+ShieldOffset*2,102,5,0,ShieldOffset,102,5,0,0
				DrawSubImageRect ShieldTextureGlow,X-108,Y-96+ShieldOffset*2,102,2,0,ShieldOffset,102,2,0,0
				SetAlpha .15
			Else
				SetAlpha .25
			End If
			SetColor RGB[0]*1.3,RGB[1]*1.35,RGB[2]*1.4
			SetTransform ShieldRot,1.3,1.3
			DrawImage ShieldImage,X,Y
			SetColor 255,255,255
			'SetBlend ALPHABLEND
		End If
		
		'SetScale(3.7,3.7)
		
		SetTransform Direction+270,3.7,3.7
		SetBlend ALPHABLEND
		DrawImage PlayerBody,X,Y
		SetBlend LIGHTBLEND
		'SetRotation( Direction +270)
		If MuzzleAlpha<3.7
			'SetBlend LIGHTBLEND
			SetAlpha 2/MuzzleAlpha
			If HasSuper
				SetColor Shot.ShotRGB[0]*2.1,Shot.ShotRGB[1]*0.2,Shot.ShotRGB[2]*0.2
			Else
				SetColor Shot.ShotRGB[0]*2.2,Shot.ShotRGB[1]*2.2,Shot.ShotRGB[2]*2.2
			End If
			DrawImage(MuzzleFlash,X,Y)
			'SetBlend ALPHABLEND
			SetColor 255,255,255
		End If

		SetAlpha .25
		SetScale 4.25,4.25
		DrawImage(PlayerGlow,X,Y)
		'SetBlend AlphaBlend
	End Method
	
	Method Update()
		'-------------------------------------------------
		'Player is Dead - Play Attract Mode
		If Not Alive And MilliSecs()-DeathSecs>450
			
			'If GAMEMODE=DEFENDER And TReacher.List
			'	If TReacher.List.Count()>0
			'		For Local Reacher:TReacher = EachIn TReacher.List
			'			Reacher.Destroy()
			'		Next
			'	End If
			'End If
			
			If Dying And MilliSecs()-DeathSecs>=725
				
				Dying=False
				GameState=DEAD
				Return
				
			End If
			
			Local Speed:Float
		
			If Rand(0,300)<3
				Direction:+Rand(-45,45)
				XSpeed=Cos(Direction)*2
				YSpeed=Sin(Direction)*2
			End If
			
			'Bounce Player around the corners
			If x < 4 
				XSpeed = Abs(XSpeed)
				X:+ XSpeed*Delta
				Direction:+ 90
			ElseIf x > FieldWidth-4
				XSpeed = -Abs(XSpeed)
				X:+ XSpeed*Delta
				Direction:+ 90
			EndIf
			
			If y < 4
				YSpeed = Abs(Yspeed)
				Y:+ YSpeed*Delta
				Direction:+ 90
			ElseIf y > FieldHeight-4
				YSpeed = -Abs(YSpeed)
				Y:+ YSpeed*Delta
				Direction:+ 90
			EndIf
			
			'Limit Player Speed
			Speed = Sqr(XSpeed*XSpeed+YSpeed*YSpeed)
			If Speed > 2
				XSpeed=XSpeed/Speed*2
				YSpeed=YSpeed/Speed*2
			ElseIf Speed<0.15
				Direction:+Rand(0,359)
				XSpeed=Cos(Direction)*2
				YSpeed=Sin(Direction)*2
			EndIf
			
			'Print Speed
					
			X:+ XSpeed*Delta
			Y:+ YSpeed*Delta
			
			'Return and don't poll inputs as we are dead and playing attract demo
			Return
			
		End If
		'---------- End Attract Mode -----------
		
		ShieldRot:+1*Delta
		
		ShieldPulse=Cos(ShieldRot/4)/16
		
		ShieldOffset:+.3*Delta
		
		If ShieldOffset>78 Then ShieldOffset=8
		
		'Prevent Cheating & Errors
		If Player.HasBomb-Player.MaskBomb>3 Player.HasBomb=Player.MaskBomb+3
		If Player.ShotInterval<=75 Then Player.ShotInterval=80
		If Player.ShotSpeed>7.55 Then Player.ShotSpeed=7.5	
		If Player.EngineBoost>0.01125 Then Player.EngineBoost=0.01125
		
		'Possible Actions
		Local Up,Down,Left,Right,Fire:Int=0,Bomb:Int=0
		
		' PHYSICS PARAMETERS
		Local Acceleration:Float 		= 0.0139 + EngineBoost*1.6
		Local Friction:Float 			= 0.0067 + EngineBoost*.74
		Local TopSpeed:Float 			= 1.25 + EngineBoost*4.75
		Local JoyAcceleration:Float
			
		'Local TurnAcceleration#	= 0.95 + EngineBoost
		'Local TurnFriction#		= 0.001		
		'Local TurnMax# 		= 1.9 + EngineBoost
		
		
		If GameState=PLAYING And Dying=False Then
		
			'Controls for Player 1
			If InputKey[MOVE_UP]>3 And InputKey[MOVE_UP]<200
				If KeyDown(InputKey[MOVE_UP]) Up=True
			ElseIf InputKey[MOVE_UP]<=3
				If MouseDown(InputKey[MOVE_UP]) Up=True
			Else
				If JoyInput(InputKey[MOVE_UP])
					Up=True
					JoyAcceleration=Abs(JoyAnalogInput(InputKey[MOVE_UP]))*1.1
				End If
			End If
			
			If InputKey[MOVE_DOWN]>3 And InputKey[MOVE_DOWN]<200
				If KeyDown(InputKey[MOVE_DOWN]) Down=True
			ElseIf InputKey[MOVE_DOWN]<=3
				If MouseDown(InputKey[MOVE_DOWN]) Down=True
			Else
				If JoyInput(InputKey[MOVE_DOWN])
					Down=True
					JoyAcceleration=Abs(JoyAnalogInput(InputKey[MOVE_DOWN]))*1.1
				End If
			End If
			
			If InputKey[MOVE_LEFT]>3 And InputKey[MOVE_LEFT]<200
				If KeyDown(InputKey[MOVE_LEFT]) Left=True
			ElseIf InputKey[MOVE_LEFT]<=3
				If MouseDown(InputKey[MOVE_LEFT]) Left=True
			Else
				If JoyInput(InputKey[MOVE_LEFT])
					Left = True
					JoyAcceleration=Abs(JoyAnalogInput(InputKey[MOVE_LEFT]))*1.1
				End If
			End If
			
			If InputKey[MOVE_RIGHT]>3 And InputKey[MOVE_RIGHT]<200
				If KeyDown(InputKey[MOVE_RIGHT]) Right=True
			ElseIf InputKey[MOVE_RIGHT]<=3
				If MouseDown(InputKey[MOVE_RIGHT]) Right=True
			Else
				If JoyInput(InputKey[MOVE_RIGHT])
					Right = True
					JoyAcceleration=Abs(JoyAnalogInput(InputKey[MOVE_RIGHT]))*1.1
				End If
			End If
			
			If InputKey[FIRE_CANNON]>3 And InputKey[FIRE_CANNON]<200
				If KeyDown(InputKey[FIRE_CANNON]) Fire=True
			ElseIf InputKey[FIRE_CANNON]<=3
				If MouseDown(InputKey[FIRE_CANNON]) Fire=True
			Else
				If JoyInput(InputKey[FIRE_CANNON]) Fire=True
			End If
			
			If InputKey[FIRE_BOMB]>3 And InputKey[FIRE_BOMB]<200
				If KeyHit(InputKey[FIRE_BOMB]) And HasBomb-MaskBomb>0
					Bomb=True
					HasBomb:-1
				End If
			ElseIf InputKey[FIRE_BOMB]<=3
				If MouseHit(InputKey[FIRE_BOMB]) And HasBomb-MaskBomb>0
					Bomb=True
					HasBomb:-1
				End If
			Else
				If JoyInput(InputKey[FIRE_BOMB],True) And HasBomb-MaskBomb>0
					Bomb=True
					HasBomb:-1
					FlushJoy()
				End If
			End If
						
		End If
		

		If InputMethod=4
			'CursorX=0
			'CursorY=1
			
			If InputKey[AIM_UP]>3 And InputKey[AIM_UP]<200
				If KeyDown(InputKey[AIM_UP]) CursorY=-1
			ElseIf InputKey[AIM_UP]<=3
				If MouseDown(InputKey[AIM_UP]) CursorY=-1
			Else
				If JoyInput(InputKey[AIM_UP])
					CursorY=(JoyAnalogInput(InputKey[AIM_UP],False))
				End If
			End If
			
			If InputKey[AIM_DOWN]>3 And InputKey[AIM_DOWN]<200
				If KeyDown(InputKey[AIM_DOWN])  CursorY=+1
			ElseIf InputKey[AIM_DOWN]<=3
				If MouseDown(InputKey[AIM_DOWN]) CursorY=+1
			Else
				If JoyInput(InputKey[AIM_DOWN])
					CursorY=(JoyAnalogInput(InputKey[AIM_DOWN],False))
				End If
			End If
			
			If InputKey[AIM_LEFT]>3 And InputKey[AIM_LEFT]<200
				If KeyDown(InputKey[AIM_LEFT]) CursorX=+1
			ElseIf InputKey[AIM_LEFT]<=3
				If MouseDown(InputKey[AIM_LEFT]) CursorX=+1
			Else
				If JoyInput(InputKey[AIM_LEFT])
					CursorX=(JoyAnalogInput(InputKey[AIM_LEFT],False))
				End If
			End If
			
			If InputKey[AIM_RIGHT]>3 And InputKey[AIM_RIGHT]<200
				If KeyDown(InputKey[AIM_RIGHT]) CursorX=-1
			ElseIf InputKey[AIM_RIGHT]<=3
				If MouseDown(InputKey[AIM_RIGHT]) CursorX=-1
			Else
				If JoyInput(InputKey[AIM_RIGHT])
					 CursorX=(JoyAnalogInput(InputKey[AIM_RIGHT],False))
				End If
			End If
			
			
		End If
		'If Abs(FixAngle(ATan2(YMouse-Y,XMouse-X)))-Direction<=25 And Abs(FixAngle(ATan2(YMouse-Y,XMouse-X)))-Direction>=-25
		'	Print "Mouse Proximity Dectected. Aim Enabled."
		'End If
		'Print "Against: "+(Abs(FixAngle(ATan2(YMouse-Y,XMouse-X)))-Direction)
		'Print "Pure   : "+Abs(FixAngle(ATan2(YMouse-Y,XMouse-X)))
		'If InputMethod=1 Direction=ATan2(YMouse-Y,XMouse-X)
		If Invincible And Trk_Toggle=0
			Trk_Toggle=MilliSecs()
		ElseIf Invincible=0 And Trk_Toggle<>0
			Trk_Inv:+MilliSecs()-Trk_Toggle
			Trk_Toggle=0
		End If
		
		If Up Or Down Or Left Or Right
			
			i:+1*Delta
			
			If TwinEngine=False
				If i>=(4*1/ParticleMultiplier) i=0; Thrust.Fire( (X-Cos(Direction)*11), (Y-Sin(Direction)*11),1,RGB[0],RGB[1],RGB[2] )
			Else
				If i>=(4*1/ParticleMultiplier)
					Thrust.Fire( (X-Cos(Direction+35)*11), (Y-Sin(Direction+35)*11), .85,RGB[0]*.9,RGB[1]*.9,RGB[2]*.9 )
					Thrust.Fire( (X-Cos(Direction-35)*11), (Y-Sin(Direction-35)*11), .85,RGB[0]*.9,RGB[1]*.9,RGB[2]*.9 )
					i=0
				End If
			End If
		End If
		
		If AutoFire And Alive And GameState=PLAYING
			Fire=True
		End If
			
		If Fire And HasShot-MaskShot=0 And MilliSecs()-LastShotFired>ShotInterval Then
			
			Rem
			'Backwards Cannon not Implemented
			If BackCannon
				Shot.Fire( (X+Cos(Direction)*16), (Y+Sin(Direction)*16), Direction+90, XSpeed, YSpeed, 1,ShotSpeed)
				Shot.Fire( (X+Cos(Direction)*16), (Y+Sin(Direction)*16), Direction-90, XSpeed, YSpeed, 1,ShotSpeed)
			End If
			End Rem
			
			Shot.Fire( (X+Cos(Direction)*13), (Y+Sin(Direction)*13), Direction, XSpeed, YSpeed, 1,ShotSpeed)

			If Not HasSuper
				PlaySoundBetter Sound_Player_Shot,X,Y
			Else
				PlaySoundBetter Sound_Player_Super_Shot,X,Y
			End If

			PrevShotFired=LastShotFired
			LastShotFired=MilliSecs()
			MuzzleAlpha=0
			
		ElseIf Fire And HasShot-MaskShot=1 And MilliSecs()-LastShotFired>ShotInterval+35
			
			Rem
			'Backwards Cannon not Implemented
			If BackCannon
				Shot.Fire( (X+Cos(Direction)*16), (Y+Sin(Direction)*16), Direction+180, XSpeed, YSpeed, 1,ShotSpeed)
			End If
			End Rem
			
			Shot.Fire( (X+Cos(Direction)*13), (Y+Sin(Direction)*13), Direction+4, XSpeed, YSpeed, 1,ShotSpeed)
			Shot.Fire( (X+Cos(Direction)*13), (Y+Sin(Direction)*13), Direction-4, XSpeed, YSpeed, 1,ShotSpeed)

			If Not HasSuper
				PlaySoundBetter Sound_Player_Shot,X,Y
			Else
				PlaySoundBetter Sound_Player_Super_Shot,X,Y
			End If

			PrevShotFired=LastShotFired
			LastShotFired=MilliSecs()
			MuzzleAlpha=0
			
		ElseIf Fire And HasShot-MaskShot=2 And MilliSecs()-LastShotFired>ShotInterval+75 
			
			Rem
			If BackCannon
				Shot.Fire( (X+Cos(Direction)*16), (Y+Sin(Direction)*16), Direction+180, XSpeed, YSpeed, 1,ShotSpeed)
			End If
			End Rem
			
			Shot.Fire( (X+Cos(Direction)*13), (Y+Sin(Direction)*13), Direction+5, XSpeed, YSpeed, 1,ShotSpeed)
			Shot.Fire( (X+Cos(Direction)*13), (Y+Sin(Direction)*13), Direction, XSpeed, YSpeed, 1,ShotSpeed)
			Shot.Fire( (X+Cos(Direction)*13), (Y+Sin(Direction)*13), Direction-5, XSpeed, YSpeed, 1,ShotSpeed)

			If Not HasSuper
				PlaySoundBetter Sound_Player_Shot,X,Y
			Else
				PlaySoundBetter Sound_Player_Super_Shot,X,Y
			End If

			PrevShotFired=LastShotFired
			LastShotFired=MilliSecs()
			MuzzleAlpha=0
			
		ElseIf Fire And HasShot-MaskShot=3 And MilliSecs()-LastShotFired>ShotInterval+125 
			
			Rem
			If BackCannon
				Shot.Fire( (X+Cos(Direction)*16), (Y+Sin(Direction)*16), Direction+180, XSpeed, YSpeed, 1,ShotSpeed)
			End If
			End Rem
			
			Shot.Fire( (X+Cos(Direction)*13), (Y+Sin(Direction)*13), Direction+5.8, XSpeed, YSpeed, 1,ShotSpeed)
			Shot.Fire( (X+Cos(Direction)*13), (Y+Sin(Direction)*13), Direction+1.85, XSpeed, YSpeed, 1,ShotSpeed)
			Shot.Fire( (X+Cos(Direction)*13), (Y+Sin(Direction)*13), Direction-1.85, XSpeed, YSpeed, 1,ShotSpeed)
			Shot.Fire( (X+Cos(Direction)*13), (Y+Sin(Direction)*13), Direction-5.8, XSpeed, YSpeed, 1,ShotSpeed)

			If Not HasSuper
				PlaySoundBetter Sound_Player_Shot,X,Y
			Else
				PlaySoundBetter Sound_Player_Super_Shot,X,Y
			End If

			PrevShotFired=LastShotFired
			LastShotFired=MilliSecs()
			MuzzleAlpha=0
			
		End If 
		
		If Immolation
			Flash.Fire(X,Y,.78,28)
			If HasSlowMotion=-1
				HasSlowMotion=MilliSecs()+900
				SpeedUpSoundMute=True
				ScanLineFader=-.175
			Else
				HasSlowMotion:+830
			End If
			PlaySoundBetter Sound_Player_Super_Shot,X,Y
			PlaySoundBetter Sound_Player_Shot,X,Y
			PrevShotFired=LastShotFired
			LastShotFired=MilliSecs()+30
			For i=1 To 359 Step 7
				Shot.Fire( (X+Cos(i)*13), (Y+Sin(i)*13), i, XSpeed, YSpeed, 1,ShotSpeed,True)
			Next
			Immolation=False
		End If
		
		If HasSlowMotion=-1
			MuzzleAlpha:+0.7*Delta
		Else
			MuzzleAlpha:+1.92*Delta
		End If
		
		If Bomb
			Trk_Bmb:+1
			Invincible=True
			PlayerBomb.Fire(X,Y)
			PlaySoundBetter Sound_Player_Bomb,X,Y
			Bomb=False
		End If
										
		'Mouse MOVEMENT CALCULATION
		j:+1*Delta
		
		BlurSteps:+1*Delta
		
		If BlurSteps>30/BlurDivider And Alive
			MotionBlur.Spawn(X,Y,Direction-90,3.5,PlayerGlow)
			BlurSteps=0
		End If
		
		If HasBounce>0
			If MilliSecs()-HasBounce>0 HasBounce=0
		End If
		If HasSuper > 0
			If MilliSecs()-HasSuper>0 HasSuper=0
		End If
		
		If HasSlowmotion > 0 And FPSTarget=FAST_FPS
			'PlaySoundBetter Sound_Time_Slow,FieldWidth/2,FieldHeight/2
		End If
		
		If HasSlowmotion > 0
			FPSTarget=SLOW_FPS
			If MilliSecs()-HasSlowMotion>0 HasSlowMotion=0
		End If
		
		If HasSlowMotion=0 And FPSTarget=SLOW_FPS And Alive
			FPSTarget=FAST_FPS
			HasSlowMotion=-1
			If Not SpeedUpSoundMute PlaySoundBetter Sound_Time_Fast,FieldWidth/2,FieldHeight/2
		End If
		'There is no back-pedal in space
		
		If InputMethod<>2
			If Up 
				'Create a Acceleration Vector and
				'add it to the Speed Vector
				'XSpeed:+ Cos(Direction)*Acceleration*Delta
				'YSpeed:+ Sin(Direction)*Acceleration*Delta
				If JoyAcceleration=0
					YSpeed:-Acceleration*Delta
				Else
					YSpeed:-(Acceleration*JoyAcceleration)*Delta
				End If
				Direction=270
				
				'i:+1*Delta
				'If i>=(4*1/ParticleMultiplier) i=0; Thrust.Fire( (X-Cos(Direction)*11), (Y-Sin(Direction)*11), Direction, XSpeed, YSpeed )
					
			EndIf
			
			If Down
				'Create a Acceleration Vector and
				'substract it from the Speed Vector
				'XSpeed:- Cos(Direction)*Acceleration*Delta
				'YSpeed:- Sin(Direction)*Acceleration*Delta
				If JoyAcceleration=0
					YSpeed:+Acceleration*Delta
				Else
					YSpeed:+(Acceleration*JoyAcceleration)*Delta
				End If
				Direction=90
				
			EndIf
			
			'ROTATIONAL PHYSICS					
			'If Left	TurnSpeed:-TurnAcceleration
			'If Right TurnSpeed:+TurnAcceleration	
			
			If Left
				'XSpeed:-Cos(Direction+90)*Acceleration*Delta
				'YSpeed:-Sin(Direction+90)*Acceleration*Delta
				
				If JoyAcceleration=0
					XSpeed:-Acceleration*Delta
				Else
					XSpeed:-(Acceleration*JoyAcceleration)*Delta
				End If
				Direction=180
				'i:+1*Delta
				'If i>=(8*1/ParticleMultiplier) i=0; Thrust.Fire( (X-Cos(Direction)*11), (Y-Sin(Direction)*11), Direction+90, XSpeed, YSpeed )
		
			End If
			
			If Right
				If JoyAcceleration=0
					XSpeed:+Acceleration*Delta
				Else
					XSpeed:+(Acceleration*JoyAcceleration)*Delta
				End If
				Direction=0
				'XSpeed:+Cos(Direction+90)*Acceleration*Delta
				'YSpeed:+Sin(Direction+90)*Acceleration*Delta
				'i:+1*Delta
				'If i>=(8*1/ParticleMultiplier) i=0; Thrust.Fire( (X-Cos(Direction)*11), (Y-Sin(Direction)*11), Direction-90, XSpeed, YSpeed )
		
			End If
		Else
			If Up 
				'Create a Acceleration Vector and
				'add it to the Speed Vector
				XSpeed:+ Cos(Direction)*Acceleration*Delta
				YSpeed:+ Sin(Direction)*Acceleration*Delta
				
				'i:+1*Delta
				'If i>=(4*1/ParticleMultiplier) i=0; Thrust.Fire( (X-Cos(Direction)*11), (Y-Sin(Direction)*11), Direction, XSpeed, YSpeed )
					
			EndIf
			
			If Down
				'Create a Acceleration Vector and
				'substract it from the Speed Vector
				XSpeed:- Cos(Direction)*Acceleration*Delta
				YSpeed:- Sin(Direction)*Acceleration*Delta

			EndIf
			
			If Left
				XSpeed:-Cos(Direction+90)*Acceleration*Delta
				YSpeed:-Sin(Direction+90)*Acceleration*Delta
				
				'i:+1*Delta
				'If i>=(8*1/ParticleMultiplier) i=0; Thrust.Fire( (X-Cos(Direction)*11), (Y-Sin(Direction)*11), Direction+90, XSpeed, YSpeed )
		
			End If
			
			If Right
				XSpeed:+Cos(Direction+90)*Acceleration*Delta
				YSpeed:+Sin(Direction+90)*Acceleration*Delta
				'i:+1*Delta
				'If i>=(8*1/ParticleMultiplier) i=0; Thrust.Fire( (X-Cos(Direction)*11), (Y-Sin(Direction)*11), Direction-90, XSpeed, YSpeed )
		
			End If
		End If
	
		If InputMethod<>1 And InputMethod<>2
			If Up And Right
				Direction=315
			End If
			
			If Up And Left
				Direction=225
			End If
			
			If Down And Right
				Direction=45
			End If
			
			If Down And Left
				Direction=135
			End If
		Else
			Direction=ATan2(YMouse-Y,XMouse-X)
		End If
		
		If JoyAcceleration<>0
			Direction=ATan2(YSpeed,XSpeed)
		End If
		
		If InputMethod=4
			AimDirection=ATan2(CursorY,CursorX)

			CursorXD=(X+Cos(AimDirection)*72)
			CursorYD=(Y+Sin(AimDirection)*72)
		
			Direction:+TurnToAim(AimDirection,Direction)
		
		End If
		
		
		
		'Bounce
		If Not Keen4E
			If X > FieldWidth-16
				If Alive Flash.Fire(X+16,Y,.75,160)
				XSpeed=-Xspeed*1.25 '/2
				X=FieldWidth-17'X = 0
				BounceTime=MilliSecs()+950
				PlaySoundBetter Sound_Player_Rebound,X,Y
			End If
			If Y > FieldHeight-16
				If Alive Flash.Fire(X,Y+16,.75,160)
				YSpeed=-YSpeed*1.25 '/2
				Y=FieldHeight-17'Y = 0
				BounceTime=MilliSecs()+950
				PlaySoundBetter Sound_Player_Rebound,X,Y
			End If
			If X < 16
				If Alive Flash.Fire(X-16,Y,.75,160) 
				XSpeed=-Xspeed*1.25 '/2
				X=17'X = FieldWidth
				BounceTime=MilliSecs()+950
				PlaySoundBetter Sound_Player_Rebound,X,Y
			End If
			If Y < 16 
				If Alive Flash.Fire(X,Y-16,.75,160)
				YSpeed=-Yspeed*2.55 '/2
				Y=17'Y = FieldHeight
				BounceTime=MilliSecs()+950
				PlaySoundBetter Sound_Player_Rebound,X,Y
			End If
		Else
			If X > FieldWidth-16
				If Alive Flash.Fire(X+16,Y,.85,160)
				XSpeed=-Xspeed*3.95 '/2
				X=FieldWidth-17'X = 0
				BounceTime=MilliSecs()+950
				PlaySoundBetter Sound_Keen_Pogo,X/2,Y
			End If
			If Y > FieldHeight-16
				If Alive Flash.Fire(X,Y+16,.85,160)
				YSpeed=-YSpeed*3.95 '/2
				Y=FieldHeight-17'Y = 0
				BounceTime=MilliSecs()+950
				PlaySoundBetter Sound_Keen_Pogo,X,Y/2
			End If
			If X < 16
				If Alive Flash.Fire(X-16,Y,.85,160) 
				XSpeed=-Xspeed*3.95 '/2
				X=17'X = FieldWidth
				BounceTime=MilliSecs()+950
				PlaySoundBetter Sound_Keen_Pogo,X/2,Y
			End If
			If Y < 16 
				If Alive Flash.Fire(X,Y-16,.85,160)
				YSpeed=-Yspeed*3.95 '/2
				Y=17'Y = FieldHeight
				BounceTime=MilliSecs()+950
				PlaySoundBetter Sound_Keen_Pogo,X,Y/2
			End If
		End If
		If BounceTime<>0 And MilliSecs()-BounceTime>0 BounceTime=0
		
		'Calculate the length of the Speed Vector
		Local SpeedVectorLength# = Sqr(XSpeed*XSpeed + YSpeed*YSpeed)
		
		If SpeedVectorLength > 0
			'Decrease Speed with Friction if we are moving
			XSpeed:- ((XSpeed/SpeedVectorLength)*Friction)*Delta
			YSpeed:- ((YSpeed/SpeedVectorLength)*Friction)*Delta
		EndIf
		
		If SpeedVectorLength>0.04
			If MoveStartTime=0 MoveStartTime=MilliSecs()
		ElseIf MoveStartTime<>0
			'Print "you stopped after: "+((MilliSecs()-MovestartTime)/1000)
			MoveStartTime=0
			MobilityLevel=0
		End If
		
		If MoveStartTime<>0 And MilliSecs()-MoveStartTime>32500
			If MobilityLevel<=0
				Score:+EvenScore(750*Multiplier*ScoreMultiplier)
				ScoreRegister.Fire(Player.x,Player.y-34,EvenScore(750*Multiplier*ScoreMultiplier),"MOBILITY BONUS!",4)
				Frenzy:+1
				Trk_FrnzGn:+2
				MoveStartTime=0
				MobilityLevel:+1
			ElseIf MobilityLevel=1
				Score:+EvenScore(950*Multiplier*ScoreMultiplier)
				ScoreRegister.Fire(Player.x,Player.y-34,EvenScore(950*Multiplier*ScoreMultiplier),"RESTLESS BONUS!",4)
				Frenzy:+1
				Trk_FrnzGn:+2
				MoveStartTime=0
				MobilityLevel:+1
			ElseIf MobilityLevel=2
				Score:+EvenScore(1250*Multiplier*ScoreMultiplier)
				ScoreRegister.Fire(Player.x,Player.y-34,EvenScore(1250*Multiplier*ScoreMultiplier),"NOMADIC BONUS!",4)
				Frenzy:+2
				Trk_FrnzGn:+4
				MoveStartTime=0
				MobilityLevel=0
			End If
		End If
		
		If SpeedVectorLength > TopSpeed
			'If we are going beyond the speed barrier then reduce our speed
			'with the amount in which it surpases TopSpeed
			XSpeed:+ (XSpeed/SpeedVectorLength)*(TopSpeed - SpeedVectorLength)
			YSpeed:+ (YSpeed/SpeedVectorLength)*(TopSpeed - SpeedVectorLength)
		EndIf
		
		'Move
		X:+ XSpeed*Delta
		Y:+ YSpeed*Delta
		
		If FPSTarget=SLOW_FPS And FPSCurrent<=FAST_FPS*.97
			X:+ XSpeed*(1/(FPSCurrent/15))*Delta
			Y:+ YSpeed*(1/(FPSCurrent/15))*Delta
		End If
			

		
		'Limit TurnSpeed
		'If TurnSpeed >  TurnMax TurnSpeed = TurnMax
		'If TurnSpeed < -TurnMax TurnSpeed = -TurnMax
		
		'Print Turnspeed
		'Direction:+Turnspeed '*Delta
		
		'Keep Angles Sane
		If Direction > 360 Direction:- 360
		If Direction < 0 Direction:+ 360
		
		'Apply Friction To Rotation
		'If TurnSpeed >  TurnFriction	TurnSpeed:- TurnFriction
		'If TurnSpeed < -TurnFriction TurnSpeed:+ TurnFriction
		
		'If Friction is Greater than Speed then Stop
		'TurnSpeed = 0

		
	EndMethod

	Function UpdateAll()
		Local Ship:TPlayerShip
		For Ship = EachIn List
			Ship.Update()
		Next
	EndFunction
	
	Method Destroy()
		If Alive And PlayerBomb.List.Count()=0 Then Trk_Ndeath:+1	
		'If we are debugging and are Invincible this has no effect
		'Return
		If Invincible Or Not Alive Then Return
		
		'Get the time of death
		DeathSecs=MilliSecs()
		
		'Get the Average Ticktime
		TickAverage=Int((GameTicks/(DeathSecs-PlaySecs))*1000)
		
		'Slow Down	
		FixedRateLogic.SetFPS(SLOW_FPS)
		FPSTarget=SLOW_FPS
		FixedRateLogic.CalcMS()
		
		'Do explosion Effects, but only if we are playing
		If GameState=PLAYING
			PlaySoundBetter Sound_Explosion_Huge,X,Y
			Explode()
		End If
		
		'Set the Death Flag, Change GameState
		Alive=False
		Dying=True
		'GameState=DEAD
		
		'Stop the "Tension" looping sound sample if it was playing
		'SoundLoop.Stop(LOOP_TENSION)
		
		'Clear out the input queue
		FlushKeys()
		FlushMouse()
	
	End Method
	
	Method Explode()
		'Fix Tracking Variables
		Trk_Diff=Difficulty
		Trk_Sht=(HasShot-MaskShot)
		Trk_Bmb_Up=Trk_Bmb_Up/-2
		Trk_Sht_Up=Trk_Sht_Up/-3
		'Explode Animation	
		If ScreenShakeEnable ScreenShake.Force=3.28
		Flash.Fire(X,Y,2.75,240)
		Flash.Fire(X,Y,3.75,120)
		Explosion.MassFire (X,Y,35,1.25,5,3)
		Explosion.MassFire (X,Y,35,1.25,105,4)
		ShockWave.Fire (X,Y,0.5,6)
		Glow.MassFire(X,Y,2,2,99,0,RGB[0],RGB[1],RGB[2],True)
		ParticleManager.Create(X,Y,40,RGB[0],RGB[1],RGB[2],0,2.1)
		ParticleManager.Create(X,Y,30,RGB[0],RGB[1],RGB[2],0,.75)
	
	EndMethod
	
	
	Function GeneratePlayer:TPixmap() Private
		'The amount of White Pixels
		Local PixelCount:Int=0	
		'Stores the Spinners Pixels
		Local PlayerPixels:Int[11,11]
		Local CocpitPixels:Int[4,4]
		'Stores the Spinners Colors
		Local PlayerColor:Int[5]
		'Brightness stores the sprite brightness
		Local Brightness:Int
		
		'-----------------MATH GEN ROUTINE-----------------
		
		'As long as there are less than 3 or more than 14 White pixels, redo Spinner
		Repeat
			PixelCount=0
			For Local i=0 To 4
				For Local j=0 To 9
						
					'A Pixel can be either 0 (Black) or 1 (White)
					PlayerPixels[i,j]=Rand(0,1)
						
					'Count the number of White Pixels
					PixelCount:+PlayerPixels[i,j]
						
				Next
				
				PlayerColor[i]=Rand(75,195)
				
			Next
			
			If PlayerPixels[0,0] And PlayerPixels[0,9] Then PixelCount=50

		Until PixelCount>35 And PixelCount<45 
		
		'Clamp the Players color to a predefined brightness range
		Repeat
			For Local c=0 To 2
				PlayerColor[c]=Rand(75,195)
			Next
			Brightness=Sqr((PlayerColor[0]*PlayerColor[0]*0.241) + (PlayerColor[1]*PlayerColor[1]*0.691) + (PlayerColor[2]*PlayerColor[2]*0.068))
		Until brightness<=150 And brightness>=100
		
		If EasterEgg
			PlayerColor[1]=PlayerColor[0]
			PlayerColor[2]=PlayerColor[0]
		End If
		
		If SeedJumble(Seed)<>"LIAP@ELLI"
			Repeat
				PixelCount=0
				For Local i=0 To 1
					For Local j=0 To 3
					
						CocpitPixels[i,j]=Rand(0,1)
						PixelCount:+CocpitPixels[i,j]
						
					Next
				Next
			Until PixelCount>3 And PixelCount<10			
		End If
		'Find connected pixels and change them to a different hue
		For Local x=1 To 4
			For Local y=1 To 9
				If PlayerPixels[x,y]>0
					If PlayerPixels[x-1,y]>0
						If PlayerPixels[x+1,y]>0
							If PlayerPixels[x,y+1]>0
								PlayerPixels[x,y]=2
							End If
						End If
					End If
				End If
			Next
		Next
		
		For Local l=0 To 3
		
			CocpitPixels[2,l]=CocpitPixels[0,l]
		
		Next
		
		If SeedJumble(Seed)="LIAP@ELLI"
			For Local i=0 To 4
				For Local j=0 To 9
					PlayerPixels[i,j]=0
				Next
			Next
			
			PlayerPixels[2,0]=1
			PlayerPixels[3,0]=1
			PlayerPixels[1,1]=1
			PlayerPixels[4,1]=1
			PlayerPixels[0,2]=1
			PlayerPixels[0,3]=1
			PlayerPixels[1,4]=1
			PlayerPixels[2,5]=1
			PlayerPixels[2,6]=1
			PlayerPixels[3,7]=1
			PlayerPixels[3,8]=1
			PlayerPixels[4,9]=1
			
			PlayerColor[0]=165
			PlayerColor[1]=165
			PlayerColor[2]=165
		End If
		
		'Mirror Player along the Y axis
		For Local m=0 To 9
			PlayerPixels[8,m]=PlayerPixels[0,m]
			PlayerPixels[7,m]=PlayerPixels[1,m]
			PlayerPixels[6,m]=PlayerPixels[2,m]
			PlayerPixels[5,m]=PlayerPixels[3,m]
		Next
		
		If SeedJumble(Seed)<>"LIAP@ELLI"
			For Local n=9 To 4 Step -1
	
				PlayerPixels[5,n]=0
				PlayerPixels[4,n]=0
				PlayerPixels[3,n]=0
			
			Next
		End If
		'-----------------DRAWING ROUTINE-----------------

		Local PlayerPixmap:TPixmap=CreatePixmap(13,14,PF_RGBA8888)
		Local GlowPixmap:TPixmap
		
		ClearPixels (PlayerPixmap)
		
		'Loop through the Spinner's pixel array 
		For Local x=0 To 8
			For Local y=0 To 9
				
				'Proceed to draw the Player
				If PlayerPixels[x,y]=1
					
					WritePixel PlayerPixmap,2+x,2+y,ToRGBA(PlayerColor[0],PlayerColor[1],PlayerColor[2],255)
				
				ElseIf PlayerPixels[x,y]=2
				
					WritePixel PlayerPixmap,2+x,2+y,ToRGBA(PlayerColor[0]-65,PlayerColor[1]-65,PlayerColor[2]-65,255)
					
				End If
			
			Next
		Next
		
		For Local x=0 To 3
			For Local y=0 To 3
			
				If CocpitPixels[x,y]
				
						WritePixel PlayerPixmap,5+x,4+y,ToRGBA(PlayerColor[2],PlayerColor[1],PlayerColor[0],255)
				
				End If
			
			Next
		Next
		
		For Local i=0 To 2
			RGB[i]=PlayerColor[i]
		Next
		
		GlowPixmap=CopyPixmap(PlayerPixmap)
		
		PlayerBody=LoadImage(PlayerPixmap,MASKEDIMAGE)
				
		GlowPixmap=GaussianBlur(GlowPixmap,2,225,5,245)
		
		PlayerGlow=LoadImage(GlowPixmap,FILTEREDIMAGE)
		
		PlayerPixmap=Null;GlowPixmap=Null
		
		PrepareFrame(PlayerGlow)
		PrepareFrame(PlayerBody)
		
	End Function
	
	Function GenerateAlternativePlayer:TPixmap() Private
		'The amount of White Pixels
		Local PixelCount:Int=0	
		'Stores the Player Pixels
		Local PlayerPixels:Int[16,16]
		'Stores the Player's Colors
		Local PlayerColor[5]
		'Amount of Neighboring Pixels
		Local Neighbors:Int
		'Pixels Marked for Removal
		Local KillBody[16 , 16]
		'The amount of smoothing applied to the Outline
		Local Spikiness=Rand(1,3)
		'GoAgain becomes true when the ship shape is deemed uninteresting/repetive
		Local GoAgain:Int = False
		'The brightness of the PlayerSprite
		Local Brightness:Int=0 
		
		Repeat
			
			GoAgain=False
			
			Repeat 
				PixelCount=0
				'Fill the body
				For Local x=1 To 6
					For Local y=1 To 11
						PlayerPixels[x,y]=Rand(0,1)
						PixelCount:+ PlayerPixels[x,y]
					Next
				Next
			Until PixelCount > 26 + Spikiness * 2 And PixelCount < 37
			
			'Generate Cockpit
			For Local i=6 To 8
				PlayerPixels[3,i]=Rand(0,1)*3
				PlayerPixels[4,i]=Rand(0,1)*3
				PlayerPixels[5,i]=Rand(0,1)*3
			Next
			
			'Clamp the Players color to a predefined brightness range
			Repeat
				For Local c=0 To 2
					PlayerColor[c]=Rand(95,160)
				Next
				Brightness=Sqr((PlayerColor[0]*PlayerColor[0]*0.241) + (PlayerColor[1]*PlayerColor[1]*0.691) + (PlayerColor[2]*PlayerColor[2]*0.068))
			Until brightness<=148 And brightness>=100
			'Print brightness
			
			If EasterEgg
				PlayerColor[0]=PlayerColor[1]
				PlayerColor[2]=PlayerColor[1]
			End If
			
			'Generate "Spine"
			For Local i=2 To 10
				If PlayerPixels[6,i]<>3 PlayerPixels[6,i]=1
			Next 	
			
			'Mirror the Ship
			For Local y=1 To 12
			
				PlayerPixels[11,y]=PlayerPixels[1,y]
				PlayerPixels[10,y]=PlayerPixels[2,y]
				PlayerPixels[9,y]=PlayerPixels[3,y]
				PlayerPixels[8,y]=PlayerPixels[4,y]
				PlayerPixels[7,y]=PlayerPixels[5,y]
			
			Next 
			
			
			For Local x=0 To 12
				For Local y=0 To 12
				
				If PlayerPixels[x,y]=1
					Neighbors=0
					If x+1<12 If PlayerPixels[x+1,y]=>1 Then Neighbors:+1
					If x-1>0 If PlayerPixels[x-1,y]=>1 Then Neighbors:+1
					If y-1>0 If PlayerPixels[x,y-1]=>1 Then Neighbors:+1
					If y+1<12 If PlayerPixels[x,y+1]=>1 Then Neighbors:+1
					
					If Neighbors<1
						KillBody[x,y]=1
					ElseIf Neighbors=4
						PlayerPixels[x , y] = 4
					End If
				EndIf
				
				Next
			Next
			
			
			For Local x=0 To 12
				For Local y=0 To 12
					If KillBody[x,y]=1 Then PlayerPixels[x,y]=0; KillBody[x,y]=0
				Next
			Next
			
			
			For Local x=0 To 12
				For Local y=0 To 12
				
				If PlayerPixels[x,y]=1
					Neighbors=0
					If x+1<12 If PlayerPixels[x+1,y]=>1 Then Neighbors:+1
					If x-1>0 If PlayerPixels[x-1,y]=>1 Then Neighbors:+1
					If y-1>0 If PlayerPixels[x,y-1]=>1 Then Neighbors:+1
					If y+1<12 If PlayerPixels[x,y+1]=>1 Then Neighbors:+1
					
					If Neighbors < 1
						KillBody[x , y] = 1
					End If
				EndIf
				
				Next
			Next
					
			For Local x=0 To 12
				For Local y=0 To 12
					If KillBody[x,y]=1 Then PlayerPixels[x,y]=0; KillBody[x,y]=0
				Next
			Next
			
			For Local x=Spikiness+1 To 11-Spikiness
				For Local y=Spikiness To 12-Spikiness
				
				If PlayerPixels[x,y]=0
					If PlayerPixels[x+1,y]>0 Then PlayerPixels[x,y]=-1
					If x-1=>0 If PlayerPixels[x-1,y]>0 Then PlayerPixels[x,y]=-1
					If y-1=>0 If PlayerPixels[x,y-1]>0 Then PlayerPixels[x,y]=-1
					If PlayerPixels[x,y+1]>0 Then PlayerPixels[x,y]=-1
				EndIf
				
				Next
			Next
			
			Local ShipWidth:Int[13], PrevShipWidth:Int, RepeatSection:Int
			
			For Local y=0 To 12 
				
				For Local x = 0 To 12
					
					If PlayerPixels[x,y]<>0 Then ShipWidth[y]:+1
				
				Next
				
				'If the shipwidth is the same as the last section it's a repeat section, we don't want lots of those
				If PrevShipWidth=ShipWidth[y] RepeatSection:+1
				
				PrevShipWidth=ShipWidth[y]
				
			Next
			
			'Random chance of a snout
			If Rand(1 , 15) < 9
			
				'Give it a "Snout"
				PlayerPixels[5 , 12] = 0
				PlayerPixels[5 , 11] = 0
				PlayerPixels[5 , 10] = 0
				PlayerPixels[6 , 12] = 0
				PlayerPixels[6 , 11] = 0
				PlayerPixels[6 , 10] = 0
				PlayerPixels[7 , 12] = 0
				PlayerPixels[7 , 11] = 0
				PlayerPixels[7 , 10] = 0
			
			End If
			
			'Indent the back
			If (Rand(1, 15) > 13)
					PlayerPixels[0 , 0] = 0
					PlayerPixels[1 , 0] = 0
					PlayerPixels[2 , 0] = 0
					PlayerPixels[3 , 0] = 0
					PlayerPixels[4 , 0] = 0
					PlayerPixels[5 , 0] = 0
					PlayerPixels[1 , 1] = 0
					PlayerPixels[2 , 1] = 0
					PlayerPixels[3 , 1] = 0
					PlayerPixels[1 , 2] = 0
					PlayerPixels[2 , 2] = 0
					PlayerPixels[1 , 3] = 0
					PlayerPixels[0 , 3] = 0
					PlayerPixels[0 , 2] = 0
					PlayerPixels[0 , 1] = 0
			End If
			
			
			'If there are a lot of repeat section the ship is likely beyond hope - Regen!
			If RepeatSection > 7
				GoAgain = True
			
			'Otherwise try and fix it
			ElseIf RepeatSection >= 5 And RepeatSection <= 7
				
				'Indent the back
				If (Rand(1, 15) < 12)
					PlayerPixels[0 , 0] = 0
					PlayerPixels[1 , 0] = 0
					PlayerPixels[2 , 0] = 0
					PlayerPixels[3 , 0] = 0
					PlayerPixels[4 , 0] = 0
					PlayerPixels[5 , 0] = 0
					PlayerPixels[1 , 1] = 0
					PlayerPixels[2 , 1] = 0
					PlayerPixels[3 , 1] = 0
					PlayerPixels[1 , 2] = 0
					PlayerPixels[2 , 2] = 0
					PlayerPixels[1 , 3] = 0
					PlayerPixels[0 , 3] = 0
					PlayerPixels[0 , 2] = 0
					PlayerPixels[0 , 1] = 0
				End If
				
				'Give it a "Snout"
				PlayerPixels[5 , 12] = 0
				PlayerPixels[5 , 11] = 0
				PlayerPixels[5 , 10] = 0
				PlayerPixels[6 , 12] = 0
				PlayerPixels[6 , 11] = 0
				PlayerPixels[6 , 10] = 0
				
				'Re-Mirror the Ship
				For Local y=0 To 12
				
					PlayerPixels[11,y]=PlayerPixels[1,y]
					PlayerPixels[10,y]=PlayerPixels[2,y]
					PlayerPixels[9,y]=PlayerPixels[3,y]
					PlayerPixels[8,y]=PlayerPixels[4,y]
					PlayerPixels[7,y]=PlayerPixels[5,y]
				
				Next 
				
			End If
					
		Until GoAgain=False
		'-----------------DRAWING ROUTINE-----------------

		Local PlayerPixmap:TPixmap=CreatePixmap(17,17,PF_RGBA8888)
		Local GlowPixmap:TPixmap
		
		ClearPixels (PlayerPixmap)
		
		'Loop through the Player's pixel array 
		For Local x=0 To 12
			For Local y=0 To 12
				
				'Proceed to draw the Player
				If PlayerPixels[x,y]=1
					
					WritePixel PlayerPixmap,2+x,2+y,ToRGBA(PlayerColor[0],PlayerColor[1],PlayerColor[2],255)
				
				ElseIf PlayerPixels[x,y]=-1
				
					WritePixel PlayerPixmap,2+x,2+y,ToRGBA(PlayerColor[0]*.7,PlayerColor[1]*.7,PlayerColor[2]*.7,255)
				
				ElseIf PlayerPixels[x,y]=3
				
					WritePixel PlayerPixmap,2+x,2+y,ToRGBA(PlayerColor[2]-40,PlayerColor[1]-40,PlayerColor[0]-40,255)
					
				ElseIf PlayerPixels[x,y]=4
				
					WritePixel PlayerPixmap,2+x,2+y,ToRGBA(PlayerColor[1]*.8,PlayerColor[2]*.8,PlayerColor[0]*.8,255)
					
				End If
			
			Next
		Next
		
		For Local i=0 To 2
			RGB[i]=PlayerColor[i]
		Next
		
		GlowPixmap=CopyPixmap(PlayerPixmap)
		
		PlayerBody=LoadImage(PlayerPixmap,MASKEDIMAGE)
				
		GlowPixmap=GaussianBlur(GlowPixmap,2,225,5,245)
		
		PlayerGlow=LoadImage(GlowPixmap,FILTEREDIMAGE)
		
		PlayerPixmap=Null;GlowPixmap=Null
		
		PrepareFrame(PlayerGlow)
		PrepareFrame(PlayerBody)
		
	End Function


	
	Function PrepareFrame(image:TImage) Private
		'Use this to cache an image or animimage in VRAM for quicker drawing later.
		image.Frame(0)
		MidHandleImage Image
	End Function
	
	Function ToRGBA%(r%,g%,b%,a%) Private
		'return (a << 24) | (r << 16) | (g << 8) | (b);
	Return ((A Shl 24) | (R Shl 16) | (G Shl 8) | B)
	End Function
	
End Type

'-----------------------------------------------------------------------------
'The Player's Bomb - Manages Effect & Destruction
'-----------------------------------------------------------------------------
Type TPlayerBomb Extends TObject
	
	Global List:TList
	Global Image:TImage
	
	Const MaxAge=175
	
	Field Size:Float
	Field Radius:Float
	Field Age:Float
	Field Transparency:Float
	Field ParticlesFired:Int
	Field FlashFired:Int
	
	Field Waves:Float=16.0, MaxOffset:Float=11.5, Scroll:Double=0, Decrease:Int=True
	
	Function Init()
		
		If Not List List = CreateList()
		
		If Not Image	'First Time
			Image = LoadImage(GetBundleResource("Graphics/bombwave.png"),FILTEREDIMAGE)
			MidHandleImage Image
			PrepareFrame Image
		EndIf
		
	End Function
	
	Function PrepareFrame(image:TImage) Private
		'Use this to cache an image or animimage in VRAM for quicker drawing later.
		For Local c=0 Until image.frames.length
			image.Frame(c)
		Next
	End Function
	
	Function Fire (X#,Y#)
		
		Local PlayerBomb:TPlayerBomb = New TPlayerBomb	 
		'If Not List List = CreateList()
		List.AddLast PlayerBomb
		
		PlayerBomb.X=X
		PlayerBomb.Y=Y
		PlayerBomb.Radius=1
		PlayerBomb.Age=0
		PlayerBomb.Transparency=1.1
		playerBomb.ParticlesFired=False
		PlayerBomb.FlashFired=False
		
		If GlowQuality<=128 And FullScreenGlow
		
			PlayerBomb.Waves=8
		
		End If
		
		If Player.HasSlowMotion=-1
			Player.HasSlowMotion=MilliSecs()+685
			Player.SpeedUpSoundMute=True
		Else
			Player.HasSlowMotion:+655
		End If
		
	End Function

	Method Update()
	
		If Not Player.Alive Destroy()
		
		WipeOutOnce=MilliSecs()+19500
		
		Radius:+(.05+Radius/24)*Delta
		
		If Radius>1 And Not FlashFired
			
			Flash.Fire(X,Y,3,175,185,165,165)
			
			If ScreenShakeEnable ScreenShake.Force=2.3
		
			FlashFired=True
			
		End If
		
		If Radius>32 And ParticlesFired=False
			ParticleManager.Create(X,Y,75,200,200,200,0,3)
			Glow.MassFire(X,Y,2,2,53,0,240,240,240,True,False,True)
			ParticlesFired=True
		End If
		
		If Radius>88
			'Don't allow spamming bombs to downgrade the difficulty, it's a cheap trick
			If Difficulty>5 And MilliSecs()-LastDifficultyDowngrade>150
				Local SeedAdd:Int=0
				Local DifficultySwitch:Int=0
				If SeedDifficultyJudge>72 Then
					SeedAdd=7500
					DifficultySwitch=1
				ElseIf SeedDifficultyJudge<54
					SeedAdd=-4500
				End If
				If Score-WriteMask<1500000
					LastDifficultyDowngrade=MilliSecs()+36500+SeedAdd
					If Difficulty<12+DifficultySwitch
						Difficulty:-1
					Else
						Difficulty:-2
					End If
					LastDifficultyChange=MilliSecs()-5000
				ElseIf Score-WriteMask>1500000
					LastDifficultyDowngrade=MilliSecs()+41500+SeedAdd
					If Difficulty<13+DifficultySwitch
						Difficulty:-1
					Else
						Difficulty:-2
					End If
					LastDifficultyChange=MilliSecs()-10000
				ElseIf Score-WriteMask>3500000
					LastDifficultyDowngrade=MilliSecs()+61500+SeedAdd
					If Difficulty<14+DifficultySwitch
						Difficulty:-1
					Else
						Difficulty:-2
					End If
					LastDifficultyChange=MilliSecs()-15000
				ElseIf Score-WriteMask>4500000
					LastDifficultyDowngrade=MilliSecs()+71500+SeedAdd
					If Difficulty<15+DifficultySwitch
						Difficulty:-1
					Else
						Difficulty:-2
					End If
					LastDifficultyChange=MilliSecs()-20000
				ElseIf Score-WriteMask>5500000
					LastDifficultyDowngrade=MilliSecs()+81500+SeedAdd
					If Difficulty<17
						Difficulty:-1
					Else
						Difficulty:-2
					End If
					LastDifficultyChange=MilliSecs()-30000
				End If
			End If
			CloseEncounters=0
			SpawnPause=GameTicks+995 'Give the player a short break
			ExtraLikeliness=0
		End If
		
		If Radius>98
			Player.Invincible=False
		End If
		
		MaxOffset=112/(Radius/2)*Delta
		If GlowQuality<=128 And FullScreenGlow MaxOffset=192/Radius
		Age:+1*Delta
		If Age=>MaxAge Destroy()
		Scroll:+0.05*Delta
		If Transparency>0 Transparency:-0.00755*Delta
		
	End Method
	
	Method Draw()
		
		SetBlend LIGHTBLEND
		
		SetScale (Radius/20,Radius/20)
		SetAlpha Transparency

		If Transparency=>0
			DrawImage Image,X,Y
		EndIf
		
		SetScale 1,1
		
		If FullScreenGlow
			For Local i=0 To GlowQuality 
			
				DrawSubImageRect BloomFilter,Float(MaxOffset*Sin(Float(i*(ScreenHeight/GlowQuality))/ScreenHeight*360.0*Waves+Scroll*360.0)),Float(i*ScreenHeight/GlowQuality),ScreenWidth,Float(ScreenHeight/GlowQuality),0,i,GlowQuality,1
		
			Next
		EndIf
		
		'SetAlpha 1
		
	End Method
	
	Function DrawAll()
		If Not List Return 
		
		For Local PlayerBomb:TPlayerBomb = EachIn List
			PlayerBomb.Draw()
		Next
	End Function
	
	Function UpdateAll()
		If Not List Return 
		
		For Local PlayerBomb:TPlayerBomb = EachIn List
			PlayerBomb.Update()
		Next
	End Function
	
	Method Destroy()
	
		List.Remove( Self )
	
	End Method
	
End Type
Rem
'-----------------------------------------------------------------------------
'DataNode streams vital data to the player in the "DATA DEFENSE" mode
'-----------------------------------------------------------------------------
Type TDataNode Extends TObject  
	
	Global List:TList
	Global Variations:Int
	Global DataNodeBody:TImage[]
	Global DataNodeGlow:TImage[]
	Global DataNodeRGB:Int[3]
	Global NodeDimensions:Int
	
	Field SpriteNumber:Int
	Field GlowPulse:Float
	Field DrawOffset:Float
	Field ScanDirection:Int
	
	Function Generate(NumDataNodes:Int)
	
		Variations=NumDataNodes
		
		DataNodeGlow = New TImage[Variations+1]
		DataNodeBody = New TImage[Variations+1]
		
		'Only one color for all nodes
		For Local i=0 To 2
			DataNodeRGB[i]=Rand(35,165)
		Next

		
		For Local i=1 To NumDataNodes
			
			'Generate and Draw
			GenerateDataNode(i)
			
			PrepareFrame(DataNodeBody[i])
			PrepareFrame(DataNodeGlow[i])
			
		Next
		
		NodeDimensions=ImageWidth(DataNodeBody[1])
		
	End Function
	
	Function Spawn(X:Int,Y:Int,FastDataNode:Int=False)
	
		If Not List List = CreateList()
		
		Local DataNode:TDataNode = New TDataNode	 
		List.AddLast DataNode
			
		DataNode.SpriteNumber=Rand(1,Variations)
		
		DataNode.X=X
		DataNode.Y=Y
		Datanode.GlowPulse=Rand(1,150)
		'SpawnEffect.Fire(DataNode.X,DataNode.Y,.75,DataNodeRGB[DataNode.SpriteNumber,0]	,DataNodeRGB[DataNode.SpriteNumber,1],DataNodeRGB[DataNode.SpriteNumber,2])	
		
		'If Not ChannelPlaying(BornChannel) PlaySound SoundBorn,BornChannel
		'PlaySoundBetter SoundBorn,X,Y
		
	End Function
	
	Method DrawBody()

		SetRotation(Direction)
		'DrawImage DataNodeBody[SpriteNumber],x,y

		'DrawImage InvaderBody[SpriteNumber],x,y
		'DrawSubImageRect DataNodeBody[SpriteNumber],x,y+DrawOffset*4,NodeDimensions,5,0,DrawOffset,NodeDimensions,5,0,0
		'SetRotation GlowPulse
		For Local i=1 To NodeDimensions
			
			DrawSubImageRect DataNodeBody[SpriteNumber],x,y+i*4,NodeDimensions+(Abs(i-DrawOffset)/3),1,0,i,NodeDimensions,1,NodeDimensions/2,NodeDimensions/2
				

		Next
		
		'DrawSubImageRect ShieldTexture,X-98,Y-98+ShieldOffset*2-4,102,3,0,ShieldOffset-2,102,3,0,0
		'DrawSubImageRect DataNodeBody[SpriteNumber],x,y+DrawOffset*4,NodeDimensions,5,0,DrawOffset,NodeDimensions,5,0,0
		'DrawSubImageRect DataNodeBody[SpriteNumber],x,y+(5+DrawOffset)*4,NodeDimensions,5,0,DrawOffset+5,NodeDimensions,5,0,0
	
		'Print ImageWidth(DataNodeBody[SpriteNumber])
		'Print ImageHeight(DataNodeBody[SpriteNumber])
		'DrawSubImageRect  i,0,h,480,123,0,h,480,123,0,0
		
	EndMethod
	
	Method DrawGlow()
		
		SetScale 4.2,4.2
		SetRotation(Direction)
		DrawImage DataNodeGlow[SpriteNumber],x,y

	EndMethod
	
	
	Method Update()
		
		GlowPulse:+0.5*Delta
		If ScanDirection
			DrawOffset:+.5*Delta
		Else
			DrawOffset:-.5*Delta
		End If
		If DrawOffset>32
			ScanDirection=0
		ElseIf DrawOffset<4
			ScanDirection=1
		End If
	EndMethod

	Function DrawAllGlow()
		If Not List Return 
		
		'SetScale 4.5,4.5
		
		For Local DataNode:TDataNode = EachIn List
			DataNode.DrawGlow()
		Next
		
	EndFunction
	
	Function DrawAll()
		If Not List Return 
		
		SetScale 4,4
		SetAlpha 1

		For Local DataNode:TDataNode = EachIn List
			DataNode.DrawBody()
		Next
		
		SetBlend LIGHTBLEND
		SetScale 4,4
		SetAlpha .7
		For Local DataNode:TDataNode = EachIn List
			DataNode.DrawGlow()
		Next
		
		SetBlend ALPHABLEND
		SetAlpha 1
		
	EndFunction
	
	Function UpdateAll()
		If Not List Return 
		
		For Local DataNode:TDataNode = EachIn List
			DataNode.Update()
		Next
	EndFunction

	Method Destroy()
		List.Remove( Self )
	EndMethod
	
	Method DestroyAll()
		If Not List Return 
		
		For Local DataNode:TDataNode = EachIn List
			DataNode.Destroy()
		Next
	EndMethod
	
	Function GenerateDataNode:TPixmap(Index:Int) Private
		
		'-----------------DRAWING ROUTINE-----------------
		
		
		Local NodeColor:Int[3]
		Local DataNodePixmap:TPixmap=CreatePixmap(20,20,PF_RGBA8888)
		Local GlowPixmap:TPixmap
		Local Maze:TMaze = TMazeGenerator.createMaze(15, 15)
		
		ClearPixels (DataNodePixmap)
		
		DataNodePixMap=Maze.Generate(DataNodeRGB[0],DataNodeRGB[1],DataNodeRGB[2],255)
		
		GlowPixmap=CopyPixmap(DataNodePixmap)
		
		DataNodeBody[index]=LoadImage(DataNodePixmap,MASKEDIMAGE)
				
		GlowPixmap=GaussianBlur(GlowPixmap,2,220,35,245)
		
		DataNodeGlow[index]=LoadImage(GlowPixmap,FILTEREDIMAGE)
		
		DataNodePixmap=Null;GlowPixmap=Null
		
	End Function
	
	Function PrepareFrame(image:TImage) Private
		'Use this to cache an image or animimage in VRAM for quicker drawing later.
		image.Frame(0)
		MidHandleImage Image
	End Function
	
	Function ToRGBA%(r%,g%,b%,a%) Private
		'return (a << 24) | (r << 16) | (g << 8) | (b);
	Return ((A Shl 24) | (R Shl 16) | (G Shl 8) | B)
	
	End Function

	Method Collision()

	EndMethod
	
End Type
End Rem
'-----------------------------------------------------------------------------
'Space PowerUps - Help you out in sticky situations
'-----------------------------------------------------------------------------
Type TPowerUp Extends TObject

	Global List:TList
	Global Image:TImage
	Global Highlight:TImage
	Global LastSpawn:Int

	Global ShotsAvailable:Int
	Global LastPowerUpSpawned:Int
	
	Field Size:Float
	Field Rotation:Float
	Field RotationSpeed:Float
	Field Kind:Int
	Field DrawMode:Int
	Field Age:Float
	Field IsVanishing:Int
	Field BlinkInterval:Float
	Field RingAlpha:Float
	Field PlayOnce:Int
	Field Stolen:Byte
	
	Field PRCol:Float=250
	Field PGCol:Float=20
	Field PBCol:Float=20
	Field PRColDelta:Float=-4.5
	Field PGColDelta:Float=5
	Field PBColDelta:Float=7

	Const SHOT = 0
	Const FASTERSHOT = 1
	Const BOUNCE  = 2
	Const SHOTINTERVAL = 3
	Const SUPERSHOT = 4
	Const SHIELD = 5
	Const BOMB = 6
	Const SLOW = 7
	Const ENGINEBOOST = 8
	Const IMMOLATION = 9
	Const EXTREME = 10
	
	Function PrepareFrame(image:TImage) Private
		'Use this to cache an image or animimage in VRAM for quicker drawing later.
		For Local c=0 Until image.frames.length
			image.Frame(c)
		Next
	End Function
	
	Function Init()
		
		LastSpawn=-1
		
		If Not List List = CreateList()
		
		If Not Image	'First Time
			Image = LoadAnimImage(GetBundleResource("Graphics/powerups.png"),39,39,0,11,FILTEREDIMAGE)
			MidHandleImage Image
			
			Highlight = LoadImage(GetBundleResource("Graphics/marker.png"),MASKEDIMAGE)
			MidHandleImage Highlight
			
			PrepareFrame(Image)
			PrepareFrame(Highlight)
			
		EndIf
		
	End Function
	
	Function ReCache()
		PrepareFrame(Image)
		PrepareFrame(Highlight)
	End Function
	
	Function Spawn( X, Y ,Kind, ForceKind:Byte=False )
		
		For Local PowerUp:TPowerUp = EachIn List
			
			If Distance(X,Y,PowerUp.X,PowerUp.Y)<=66
				Return Null
				Exit
			End If
			
		Next
		
		If Not ForceKind
			Local SafetyRelease:Int
			'75% chance of not spawning extras 1.25s or less apart
			If LastSpawn<>-1 If MilliSecs()-LastSpawn<3250 And Rand(0,6)<6 Return Null
			'If LastSpawn<>-1 If MilliSecs()-LastSpawn<3250 Return Null
			
			If Kind=SUPERSHOT Then
			
				If Rand(1,50)>28
					If Rand(0,3)<3
						Kind=BOUNCE
					Else
						Kind=IMMOLATION
					End If
				EndIf
			End If
			
			If Kind<>SHOT And Player.HasShot-Player.MaskShot<=0 And Score<65000
				
				If Rand(0,30)>12 Then Kind=SHOT
				
			End If
			
			If Kind=LastPowerUpSpawned And Rand(0,19)>1
				SafetyRelease=0
				Repeat
					Kind = Rand(FASTERSHOT,EXTREME)
					SafetyRelease:+1
					If SafetyRelease>8 Exit
				Until Kind<>LastPowerUpSpawned
			
			End If
			
			If Kind=SHOT And Player.HasShot-Player.MaskShot>0 And Player.HasShot-Player.MaskShot<3
			
				If Rand(0,65)>25-((Player.HasShot-Player.MaskShot)*8) Then KIND=Rand(FASTERSHOT,EXTREME)
			
			End If
			
			If Kind=SHOT And Player.HasShot-Player.MaskShot=>3
			
				Kind=Rand(FASTERSHOT,EXTREME)
			
			End If
			
			If Player.ShotInterval<105 And Kind=SHOTINTERVAL
				SafetyRelease=0
				While Kind=SHOTINTERVAL
					Kind=Rand(BOUNCE,EXTREME)
					SafetyRelease:+1
					If SafetyRelease>8 Exit
				Wend
			
			End If
			
			If Player.ShotSpeed=>7 And Kind=FASTERSHOT
				SafetyRelease=0
				While Kind=FASTERSHOT
					Kind=Rand(BOUNCE,EXTREME)
					SafetyRelease:+1
					If SafetyRelease>8 Exit
				Wend
			
			End If
					

			If Kind=SHOT And ShotsAvailable>0
			
				Kind=Rand(FASTERSHOT,SLOW)
			
			End If
			
			If Kind=SHIELD And Score-WriteMask<125000
				SafetyRelease=0
				While Kind=SHIELD
					Kind=Rand(FASTERSHOT,EXTREME)
					SafetyRelease:+1
					If SafetyRelease>8 Exit
				Wend
			End If
			
			
			If Kind=BOMB And Player.HasBomb-Player.MaskBomb>0 And Rand(0,1)=1
				
				Kind=Rand(FASTERSHOT,ENGINEBOOST)	
				
			End If
			
			If Kind=BOMB And Player.HasBomb-Player.MaskBomb>1
				
				Kind=Rand(FASTERSHOT,ENGINEBOOST)	
				
			End If
						
			'Prevent Awkward Positioning of powerups
			If x < 42 
				X:+42
			ElseIf x > FieldWidth-42
				X:-42
			EndIf
			If y < 42
				Y:+42
			ElseIf y > FieldHeight-42
				Y:-42
			EndIf
			
			If SeedDifficultyJudge>79
				If Kind=SHOT And MilliSecs()-Player.LastGunPickup<68700
					Kind=Rand(FASTERSHOT,IMMOLATION)
					'Print "delayed shot"
				End If
			Else
				If Kind=SHOT And MilliSecs()-Player.LastGunPickup<58700
					Kind=Rand(FASTERSHOT,EXTREME)
					'Print "delayed shot"
				End If
			End If
			
			If SeedDifficultyJudge<55
				If Kind=SHOT And Player.HasShot-Player.MaskShot=1
					If Rand(0,11)<8 Kind=Rand(FASTERSHOT,EXTREME)
				End If
			
				If Kind=SHOT And Player.HasShot-Player.MaskShot=2
					If Rand(0,11)<9 Return
				End If
				
				If KIND=LastPowerUpSpawned And KIND=SLOW
					If Rand(0,20)<7 Return
				End If
				
			Else
				If Kind=SHOT And Player.HasShot-Player.MaskShot=1
					If Rand(0,11)<9 Return
				End If
			
				If Kind=SHOT And Player.HasShot-Player.MaskShot=2
					If Rand(0,11)<10 Return
				End If
				If KIND=LastPowerUpSpawned
					If Rand(0,20)<7 Return
				End If
			End If
			
		End If
		
		If ForceExtra And ForceKind=False And ShotsAvailable=0
			KIND=SHOT
			ForceExtra=False
			ExtraLikeliness=0
			'ShotsAvailable:+1
			'Print "forced shot"
			If SeedDifficultyJudge>79
				If Kind=SHOT And MilliSecs()-Player.LastGunPickup<68700
					Kind=Rand(FASTERSHOT,IMMOLATION)
					'Print "delayed shot"
				End If
			Else
				If Kind=SHOT And MilliSecs()-Player.LastGunPickup<58700
					Kind=Rand(FASTERSHOT,EXTREME)
					'Print "delayed shot"
				End If
			End If
		End If
		
		If Kind=SHOT ShotsAvailable:+1
		
		'If the Spawn is created by a dying thief dont play the effect
		If Not ForceKind
			ShockWave.Fire(x,y,175,-1.2)
			LastPowerUpSpawned=Kind
			LastSpawn=MilliSecs()
			PlaySoundBetter Sound_Powerup_Born,X,Y
		End If
		
		
		
		Local PowerUp:TPowerUp = New TPowerUp	 
		If Not List List = CreateList()
		List.AddLast PowerUp
		If ForceKind PowerUp.Stolen=True
		PowerUp.Age			 = 2070'1972	
		PowerUp.X 			 = X
		PowerUp.Y 			 = Y
		PowerUp.Direction 	 = Rand(360)
		PowerUp.Rotation 	 = PowerUp.Direction
		PowerUp.RotationSpeed = 0.75
		PowerUp.Kind 		 = Kind
		PowerUp.Size		 = 1.1
		PowerUp.DrawMode	 = 1
		PowerUp.PlayOnce  	 = False

	EndFunction
	
	Method DrawGlow()
	
		SetTransform Rotation,1,1
		SetColor PRCol,PGCol,PBCol
		SetAlpha RingAlpha

		DrawImage HighLight,X,Y
	
	End Method
	
	Function HelpScreen(X,Y,SpriteNum,Rotation)
		
		'Print InvaderLogo
		SetBlend alphablend
		SetTransform Rotation,1,1
		
		DrawImage Image,x,y,SpriteNum
		SetAlpha .65
		SetColor RCol,GCol,BCol
		SetRotation -Rotation
		DrawImage HighLight,x,y
		SetColor 255,255,255
		SetRotation 0
		SetAlpha 1
		
	End Function
	
	Method Draw()
		
		SetTransform Rotation,1,1
		SetColor PRCol,PGCol,PBCol
		SetAlpha RingAlpha
		
		DrawImage HighLight,X,Y
		
		SetColor 255,255,255
		SetScale  Size,Size
		SetRotation -Rotation
		'If Not IsVanishing SetScale (1,1)
		
		If Not IsVanishing
			SetAlpha 1
		Else
			If BlinkInterval<16 Then
				SetAlpha 1
			Else
				SetAlpha 0.2
			End If
		End If
		
		'Draw two stacked powerups for the extreme shot
		DrawImage Image,X,Y,KIND
		
	EndMethod
	
	
	Method Update()
		'Draw()
		PowerupCycleColors(3*Delta)
		If Age>=550 And RingAlpha<1
			RingAlpha:+0.003*Delta
		ElseIf Age<=140 And RingAlpha>0
			RingAlpha:-0.005*Delta
		End If
		
		If DrawMode=1 Then
			Size:-0.002*Delta
		ElseIf DrawMode=2
			Size:+0.002*Delta
		End If
		
		Rotation:+RotationSpeed*Delta
		
		If Size>=1.25 Then DrawMode=1
		If Size<=0.85 Then DrawMode=2
		
		Collision()
						
		If FpsTarget=FAST_FPS
			Age:-1*Delta
		Else
			Age:-.7*Delta
		End If
		BlinkInterval:+1*Delta
		
		If Age<=0 Then TimeOut
		
		If Age<=685 Then IsVanishing=True
		
		If IsVanishing=True And PlayOnce=False
			PlaySoundBetter Sound_Powerup_Time,X,Y
			PlayOnce=True
		End If	
		
		If BlinkInterval>31 Then BlinkInterval=0
		
	EndMethod

	Function DrawAll()
		If Not List Return 
	
		'FIX this later when you have proper sprites
		'SetBlend LIGHTBLEND
		For Local PowerUp:TPowerUp = EachIn List
			PowerUp.Draw()
		Next
		'SetBlend ALPHABLEND
		SetAlpha 1

	EndFunction
	
	Function DrawAllGlow()
		If Not List Return 
		
		SetAlpha .5
		
		For Local PowerUp:TPowerUp = EachIn List
			PowerUp.DrawGlow()
		Next

		SetAlpha 1
		SetColor 255,255,255
		
	EndFunction
	
	Function UpdateAll()
		If Not List Return 
		
		For Local PowerUp:TPowerUp = EachIn List
			PowerUp.Update()
		Next
	EndFunction

	Method Destroy()

		List.Remove( Self )
	EndMethod
	
	Method TimeOut()
	
		ShockWave.Fire(x,y,0.5,1.2,False,True)		
		Flash.Fire(x,y,0.4,10)
		
		List.Remove( Self )
		
		If Kind=SHOT Then ShotsAvailable:-1
		CloseEncounters:+1.25
		
	End Method
	
	Method Collision()
		Local TempScore:Int=EvenScore(150*Multiplier*ScoreMultiplier)
		
		'Check for Pickups
		If Player.Alive And Distance( X, Y, Player.X, Player.Y ) < 24 Then
			
			Select Kind
				
				Case SHIELD
					If Player.HasShield-Player.MaskShield=0
						ScoreRegister.Fire(X,Y,0,"SHIELD ACQUIRED!",3)
						Player.HasShield=Player.MaskShield+1
						CloseEncounters:-15
						PlaySoundBetter Sound_Player_Pickup,X+1,Y+1
						Trk_Shd:+1
					ElseIf Player.HasShield-Player.MaskShield=1
						ScoreRegister.Fire(X,Y,0,"SHIELD BOOSTED!",3)
						Player.HasShield=Player.MaskShield+2
						PlaySoundBetter Sound_Player_Pickup,X+1,Y+1
						Trk_Shd:+1
					Else
						ScoreRegister.Fire(X,Y,0,"SHIELD MAX!",3)
						Score:+TempScore
						ScoreRegister.Fire(x,y-25,TempScore)
						PlaySoundBetter Sound_Player_Maxed,X+1,Y+1
					End If
					
				Case BOMB
					If Player.HasBomb-Player.MaskBomb<3
						If Stolen
							ScoreRegister.Fire(X,Y,0,"BOMB RECLAIMED!",3)
						Else
							ScoreRegister.Fire(X,Y,0,"BOMB ACQUIRED!",3)
						End If
						Player.HasBomb:+1
						Trk_Bmb_Up:-2
						If Player.HasBomb>=2 Difficulty:+1
						CloseEncounters:-25
						PlaySoundBetter Sound_Player_Pickup,X+1,Y+1
					Else
						ScoreRegister.Fire(X,Y,0,"BOMB-SLOT FULL!",3)
						Score:+TempScore
						ScoreRegister.Fire(x,y-25,TempScore)
						PlaySoundBetter Sound_Player_Maxed,X+1,Y+1
					End If
					
				Case FASTERSHOT
					If Player.ShotSpeed<6.75
						ScoreRegister.Fire(X,Y,0,"FASTER SHOTS!",3)
						Player.ShotSpeed:+.75
						CloseEncounters:-5
						PlaySoundBetter Sound_Player_Pickup,X+1,Y+1
					Else
						ScoreRegister.Fire(X,Y,0,"SHOT SPEED MAX!",3)
						Score:+TempScore
						ScoreRegister.Fire(x,y-25,TempScore)
						PlaySoundBetter Sound_Player_Maxed,X+1,Y+1
					End If
					
				Case SHOTINTERVAL
					If Player.ShotInterval>100
						ScoreRegister.Fire(X,Y,0,"RATE OF FIRE UP!",3)
						Player.ShotInterval:-20
						CloseEncounters:-5
						PlaySoundBetter Sound_Player_Pickup,X+1,Y+1
					Else
						ScoreRegister.Fire(X,Y,0,"RATE OF FIRE MAX!",3)
						Score:+TempScore
						ScoreRegister.Fire(x,y-25,TempScore)
						PlaySoundBetter Sound_Player_Maxed,X+1,Y+1
					End If
					
				Case SUPERSHOT
					If Player.HasSuper=0
						ScoreRegister.Fire(X,Y,0,"SUPER SHOT!",3)
						If Player.HasSlowmotion>0
							Player.HasSuper=MilliSecs()+5900*1.6
						Else
							Player.HasSuper=MilliSecs()+5900
						End If
						CloseEncounters:-10*(Player.HasShot-Player.MaskShot)
						PlaySoundBetter Sound_Player_Pickup,X+1,Y+1
					ElseIf Player.HasSuper>0
						ScoreRegister.Fire(X,Y,0,"SUPER SHOT EXTENDED!",3)
						If Player.HasSlowmotion>0
							Player.HasSuper:+5500*1.6
						Else
							Player.HasSuper:+5500
						End If
						PlaySoundBetter Sound_Player_PickUp,X+1,Y+1
					End If
					
				Case SHOT
					If Player.HasShot-Player.MaskShot<3
						ForceExtra=False
						Player.HasShot:+1
						ShotsAvailable:-1
						Trk_Sht_Up:-3
						If Player.HasShot-Player.MaskShot=1
							Player.LastGunPickup=MilliSecs()
							If Stolen
								ScoreRegister.Fire(X,Y,0,"DOUBLE CANNON RECLAIMED!",3)
							Else
								ScoreRegister.Fire(X,Y,0,"DOUBLE CANNON!",3)
							End If
							CloseEncounters:-25
							PlaySoundBetter Sound_Player_Pickup,X+1,Y+1
						ElseIf Player.HasShot-Player.MaskShot=2
							Player.LastGunPickup=MilliSecs()
							If Stolen
								ScoreRegister.Fire(X,Y,0,"TRIPLE CANNON RECLAIMED!",3)
							Else
								ScoreRegister.Fire(X,Y,0,"TRIPLE CANNON!",3)
							End If
							Difficulty:+1
							CloseEncounters:-45
							If SpawnPause<>0 SpawnPause:-450
							PlaySoundBetter Sound_Player_Pickup,X+1,Y+1
						ElseIf Player.HasShot-Player.MaskShot=3
							Player.LastGunPickup=MilliSecs()
							If Stolen
								ScoreRegister.Fire(X,Y,0,"QUAD CANNON RECLAIMED!",3)
							Else
								ScoreRegister.Fire(X,Y,0,"QUAD CANNON!",3)
							End If
							Difficulty:+2
							CloseEncounters:-75
							If SpawnPause<>0 SpawnPause:-950
							PlaySoundBetter Sound_Player_Pickup,X+1,Y+1
						End If
					Else
						ScoreRegister.Fire(X,Y,0,"CANNON MAX!",3)
						Score:+TempScore
						ScoreRegister.Fire(x,y-25,TempScore)
						PlaySoundBetter Sound_Player_Maxed,X+1,Y+1
					End If

						
				Case BOUNCE
					
					If Player.HasBounce=0
						If Player.HasSlowmotion>0
							Player.HasBounce=MilliSecs()+12850*1.6
						Else
							Player.HasBounce=MilliSecs()+12850
						End If
						ScoreRegister.Fire(X,Y,0,"BOUNCY SHOT!",3)
						CloseEncounters:-10
						PlaySoundBetter Sound_Player_Pickup,X+1,Y+1
					Else
						ScoreRegister.Fire(X,Y,0,"BOUNCY SHOT EXTENDED!",3)
						If Player.HasSlowmotion>0
							Player.HasBounce:+12000*1.6
						Else
							Player.HasBounce:+12000
						End If
						PlaySoundBetter Sound_Player_Pickup,X+1,Y+1
					End If

					
				Case SLOW
					
					If Player.HasSlowMotion=-1 And FrenzyMode<=0
						Player.HasSlowmotion=MilliSecs()+10500
						Player.SpeedUpSoundMute=False
						ScoreRegister.Fire(X,Y,0,"TIME STRETCH!",3)
						CloseEncounters:-10
						PlaySoundBetter Sound_Player_Pickup,X+1,Y+1
						PlaySoundBetter Sound_Time_Slow,FieldWidth/2,FieldHeight/2
						If Player.HasSuper 
							Local Multi:Int=Player.HasSuper-MilliSecs()
							Player.HasSuper=MilliSecs()+Multi*1.6
						End If
						If Player.HasBounce
							Local Multi:Int=Player.HasBounce-MilliSecs()
							Player.HasBounce=MilliSecs()+Multi*1.6
						End If
					ElseIf Player.HasSlowMotion>0 And FrenzyMode<=0
						If Player.SpeedUpSoundMute=True
							ScoreRegister.Fire(X,Y,0,"TIME STRETCH!",3)
							Player.HasSlowmotion:+10200
						Else
							ScoreRegister.Fire(X,Y,0,"TIME STRETCH EXTENDED!",3)
							Player.HasSlowmotion:+10000
						End If
						Player.SpeedUpSoundMute=False
						PlaySoundBetter Sound_Player_Pickup,X+1,Y+1
					ElseIf FrenzyMode>0
						FrenzyMode:+5550
						If Player.HasSlowMotion>0
							Player.HasSlowMotion:+8750
						Else
							Player.HasSlowMotion=MilliSecs()+8750
						End If
						Player.SpeedUpSoundMute=False
						ScoreRegister.Fire(X,Y,0,"FRENZY EXTENDED!",3)
						PlaySoundBetter Sound_Player_Pickup,X+1,Y+1
					End If
					
				Case ENGINEBOOST
					
					If Player.EngineBoost<0.009
						Player.EngineBoost:+0.00225
						ScoreRegister.Fire(X,Y,0,"THRUSTER BOOSTED!",3)
						CloseEncounters:-15
						PlaySoundBetter Sound_Player_Pickup,X+1,Y+1
					Else
						ScoreRegister.Fire(X,Y,0,"THRUSTER MAX!",3)
						Score:+TempScore
						ScoreRegister.Fire(x,y-25,TempScore)
						PlaySoundBetter Sound_Player_Maxed,X+1,Y+1
					End If
				
				Case IMMOLATION
					
					ScoreRegister.Fire(X,Y,0,"IMMOLATION!",3)
					PlaySoundBetter Sound_Player_Pickup,X+1,Y+1
					Player.Immolation=True
					
				Case EXTREME
					If Player.HasSuper=0
						ScoreRegister.Fire(X,Y,0,"SUPER BOUNCY SHOT!",3)
						If Player.HasSlowmotion>0
							Player.HasSuper=MilliSecs()+5000*1.6
						Else
							Player.HasSuper=MilliSecs()+5000
						End If
						CloseEncounters:-10*Player.HasShot
						PlaySoundBetter Sound_Player_Pickup,X+1,Y+1
					ElseIf Player.HasSuper>0
						ScoreRegister.Fire(X,Y,0,"SUPER BOUNCY SHOT!",3)
						If Player.HasSlowmotion>0
							Player.HasSuper:+5050*1.6
						Else
							Player.HasSuper:+5050
						End If
						PlaySoundBetter Sound_Player_PickUp,X+1,Y+1
					End If
					If Player.HasBounce=0
						If Player.HasSlowmotion>0
							Player.HasBounce=MilliSecs()+5000*1.6
						Else
							Player.HasBounce=MilliSecs()+5000
						End If
						PlaySoundBetter Sound_Player_Pickup,X+1,Y+1
					Else
						If Player.HasSlowmotion>0
							Player.HasBounce:+5500*1.6
						Else
							Player.HasBounce:+5500
						End If
						PlaySoundBetter Sound_Player_Pickup,X+1,Y+1
					End If
			End Select
			
			
			
			Destroy()
		
		End If

	EndMethod
	
	Method PowerupCycleColors(CycleSpeed:Float=10)
		
		If GameState=PAUSE Return
			
		PRCol = PRCol + (PRColDelta/10*CycleSpeed)
		
		If PRCol<80
			PRCol=80
			PRcolDelta:*-1
		ElseIf PRCol>255
			PRCol=255
			PRColDelta:*-1
		End If
		
		PGCol = PGCol + (PGColDelta/10*CycleSpeed)
		
		If PGCol<45
			PGCol=45
			PGColDelta:*-1
		ElseIf PGCol>255
			PGCol=255
			PGColDelta:*-1
		End If
		
		PBCol = PBCol + (PBColDelta/10*CycleSpeed)
		
		If PBCol<35
			PBCol=35
			PBColDelta:*-1
		ElseIf PBCol>255
			PBCol=255
			PBColDelta:*-1
		End If
	
	End Method

End Type

'-----------------------------------------------------------------------------
'ScoreDraw Writing out the Gained Score above the Player for easy understanding.
'-----------------------------------------------------------------------------
Type TScoreRegister Extends TObject

	Field MaxAge:Int
	Field Age:Float
	Field Size#, Transparency#
	Field Text:String
	Field R:Int,G:Int,B:Int
	Field Wobble:Float
	
	Global List:TList
	Global Image:TImage
	
	Function Init()
		If List = Null List = CreateList()
	End Function
	
	Function Fire( X, Y, ScoreAmount:Int, Saying$="", Kind=1)
	
		Local ScoreRegister:TScoreRegister = New TScoreRegister	 
		'If List = Null List = CreateList()
		List.AddLast ScoreRegister

		ScoreRegister.X 			= X
		ScoreRegister.Y 			= Y
		ScoreRegister.MaxAge = 265
		ScoreRegister.Transparency = 1.2
		ScoreRegister.R=255
		ScoreRegister.G=255
		ScoreRegister.B=255
		If Saying$="" Then
			ScoreRegister.Text = ScoreAmount
			ScoreRegister.Size = .75
			ScoreRegister.Transparency:+0.2
			ScoreRegister.MaxAge:+25
			ScoreRegister.Wobble=200
		ElseIf Kind=1
			ScoreRegister.Text = Saying$+ScoreAmount+"!"
			ScoreRegister.Size = .75
			ScoreRegister.MaxAge:+(65*ScoreAmount)
			ScoreRegister.Transparency:+0.3
			ScoreRegister.Wobble=200
		ElseIf Kind=2
			ScoreRegister.Text = Saying$
			ScoreRegister.Size = 2
			ScoreRegister.MaxAge:+550
			ScoreRegister.Transparency:+0.45
			ScoreRegister.Y:-15
			ScoreRegister.G=129
			ScoreRegister.B=0
		ElseIf Kind=3
			ScoreRegister.Text = Saying$
			ScoreRegister.Size = .8
			ScoreRegister.MaxAge:+330
			ScoreRegister.Transparency:+0.25
			ScoreRegister.G=15
			ScoreRegister.B=35
		ElseIf Kind=4
			ScoreRegister.Text = Saying+" - "+ScoreAmount+"!"
			ScoreRegister.Size = .8
			ScoreRegister.MaxAge:+400
			ScoreRegister.Transparency:+0.3
			ScoreRegister.R=200
			ScoreRegister.G=175
			ScoreRegister.B=15
		End If
		
		If FrenzyMode<>0 And Kind=1
			ScoreRegister.R=255
			ScoreRegister.G=128
			ScoreRegister.B=0
		End If
		
	EndFunction
	
	Method Draw()	
		
		SetAlpha Transparency
		SetScale Size,Size
		SetColor R,G,B
		'DoubleBoldFont.Draw "GET READY!",ScreenWidth/2,ScreenHeight/2-30,True,False,False,False,False,3
		If Wobble>0	
			InGameFont.Draw (Text,X,Y-10,True,False,False,False,False,Wobble)
		Else
			InGameFont.Draw (Text,X,Y-10,True)
		End If
		'See note below about performance concerns (resetting the alpha & rot)
		'SetAlpha (1)
	EndMethod
	
	Method Update()
		Transparency:-0.0049*Delta
		Age:+1*Delta
		If Wobble>100
			Wobble:-2*Delta		
		ElseIf Wobble>0
			Wobble:-1*Delta
		End If
		If Age > MaxAge Destroy()
	EndMethod
	
	Function DrawAllGlow()
		
		If Not List Return
		SetRotation 0
		'Local OldBlend=GetBlend()
		'SetBlend (LIGHTBLEND)
		
		Local ScoreRegister:TScoreRegister
		For ScoreRegister = EachIn List
			If ScoreRegister.G=128 ScoreRegister.Draw()
		Next
		
		'SetBlend OldBlend
		'scSetScale(1,1)
		SetAlpha 1
		SetColor 255,255,255
		
	EndFunction
	
	Function DrawAll()
		
		'SetImageFont ImageFont
		
		If Not List Return 
		SetRotation 0
		'Local OldBlend=GetBlend()
		'SetBlend (LIGHTBLEND)
		
		Local ScoreRegister:TScoreRegister
		For ScoreRegister = EachIn List
			ScoreRegister.Draw()
		Next
		
		'SetBlend OldBlend
		'scSetScale(1,1)
		SetAlpha 1
		SetColor 255,255,255
		
	EndFunction

	Function UpdateAll()
		If Not List Return 
		
		Local ScoreRegister:TScoreRegister
		For ScoreRegister = EachIn List
			ScoreRegister.Update()
		Next
		
	EndFunction

	Method Destroy() 
		List.Remove( Self )
	EndMethod
	
EndType	

'-----------------------------------------------------------------------------
'A bright Flash
'-----------------------------------------------------------------------------
Type TFlash Extends TObject

	Field MaxAge:Int
	Field Age:Int
	Field Size:Float
	Field FinalSize:Float
	Field Transparency:Float
	Field Color:Int[3]
	Field DistortedFlash:Byte
	
	Global List:TList
	Global Image:TImage
	Global DistortedImage:TImage
	
	Function PrepareFrame(image:TImage) Private
		'Use this to cache an image or animimage in VRAM for quicker drawing later.
		For Local c=0 Until image.frames.length
			image.Frame(c)
		Next
	End Function
	
	Function Init()
		
		If Not List Then List=CreateList()
		
		If Not Image'First Time
			Image = LoadImage(GetBundleResource("Graphics/brightflash.png"))
			'Image = LoadImage("Graphics/brightflash2.png")
			
			DistortedImage = LoadImage(GetBundleResource("graphics/distortedflash.png"),MASKEDIMAGE)
			
			MidHandleImage ( DistortedImage )
			MidHandleImage( Image )
			
			PrepareFrame DistortedImage
			PrepareFrame Image
		EndIf
		
	End Function
	
	Function ReCache()
		PrepareFrame DistortedImage
		PrepareFrame Image
	End Function

	Function Fire( X, Y, Size#, Duration,R:Int=255,G:Int=255,B:Int=255,Distorted:Byte=False,Instantaneous:Byte=False)
	
		Local Flash:TFlash = New TFlash	 
		'If List = Null List = CreateList()
		List.AddLast Flash

		Flash.X 			= X
		Flash.Y 			= Y
		Flash.MaxAge = Duration+5
		'Flash.Size = Size
		Flash.FinalSize = Size*1.05
		If Instantaneous
			Flash.Size = Size
			Flash.Transparency = 0.88
		Else
			Flash.Size=.1
			Flash.Transparency = 0.92
		End If
		Flash.Color[0] = R
		Flash.Color[1] = G
		Flash.Color[2] = B		
		Flash.DistortedFlash = Distorted 		

	EndFunction
	
	Method Draw()	
		
		SetColor Color[0],Color[1],Color[2]
		SetAlpha Transparency
		SetScale Size,Size
		If DistortedFlash
			DrawImage DistortedImage,X,Y
		Else
			DrawImage Image,X,Y
		End If
		
	EndMethod
	
	Method Update()
		If FPSTARGET=SLOW_FPS
			If FinalSize<=.45
				If Size <= FinalSize Then Size:+(FinalSize/5)*Delta
			Else
				If Size < FinalSize Then Size:+(FinalSize/14)*Delta
			End If
		Else
			If FinalSize<=.45
				If Size <= FinalSize Then Size:+(FinalSize/4)*Delta
			Else
				If Size < FinalSize Then Size:+(FinalSize/7)*Delta
			End If
		End If
		Transparency:-0.012*Delta
		Age:+1*Delta				
		If Age => MaxAge Destroy()
		'If Not IsVisible(x,y,45) Destroy()
	EndMethod
	
	Function DrawAllGlow()
		If Not List Return 
		
		SetBlend LIGHTBLEND
		
		Local Flash:TFlash
		For Flash = EachIn List
			Flash.Draw()
		Next
		SetColor 255,255,255
		SetBlend ALPHABLEND
		SetAlpha 1
		
	EndFunction


	Function DrawAll()
		If Not List Return 
		
		SetBlend LIGHTBLEND
		
		Local Flash:TFlash
		For Flash = EachIn List
			Flash.Draw()
		Next
		SetColor 255,255,255
		SetBlend ALPHABLEND
		SetAlpha 1
		
	EndFunction

	Function UpdateAll()
		If Not List Return 
		
		Local Flash:TFlash
		For Flash = EachIn List
			Flash.Update()
		Next
		
	EndFunction

	Method Destroy() 
		List.Remove( Self )
	EndMethod
	
EndType	
'-----------------------------------------------------------------------------
'A firey Explosion
'-----------------------------------------------------------------------------
Type TExplosion Extends TObject

	Field FrameAge:Float
	Field StartAge:Float
	Field CurrentFrame:Float
	Field Size:Float
	Field Transparency:Float
	Field MaxAge:Float
	Field Desaturated:Byte
	
	Global List:TList
	Global ImageColor:TImage
	Global ImageBW:TImage
	Global BigImage:TImage
	
	Global ImageColorBlur:TImage
	Global ImageBWBlur:TImage
	Global BigImageBlur:TImage
	
	Function PrepareFrame(image:TImage) Private
		'Use this to cache an image or animimage in VRAM for quicker drawing later.
		For Local c=0 Until image.frames.length
			image.Frame(c)
		Next
	End Function
	
	Function Init()
		
		If Not ImageBw'First Time
			'Image = LoadAnimImage("graphics/pixel_bang.png",19,25,0,16,MASKEDIMAGE)
			ImageBw = LoadAnimImage (GetBundleResource("graphics/exp_g.png"),71,100,0,16,MASKEDIMAGE)
			ImageColor = LoadAnimImage (GetBundleResource("graphics/exp_c.png"),71,100,0,16,MASKEDIMAGE)
			'Image = LoadAnimImage (GetBundleResource("graphics/fireballg.png"),71,100,0,16,FILTEREDIMAGE)
			'BigImage = LoadAnimImage("graphics/pixel_boom.png",25,25,0,25,MASKEDIMAGE)
			'BigImage = LoadAnimImage (GetBundleResource("graphics/bigbang.png"),104,104,0,25,FILTEREDIMAGE)
			BigImage = LoadAnimImage (GetBundleResource("graphics/expb_c.png"),104,104,0,25,MASKEDIMAGE)
			'BigImage = LoadAnimImage (GetBundleResource("graphics/expb_g.png"),104,104,0,25,MASKEDIMAGE)
			'BigImage = LoadAnimImage ("graphics/pixel_boom.png",104,104,0,25,MASKEDIMAGE)
			MidHandleImage( BigImage )
			MidHandleImage( ImageBw )
			MidHandleImage ( ImageColor )
			
			Local TempBigImage:TPixmap = LoadPixmap (GetBundleResource("graphics/expb_c.png"))
			Local TempBWImage:TPixmap = LoadPixmap (GetBundleResource("graphics/exp_g.png"))
			Local TempColorImage:TPixmap = LoadPixmap (GetBundleResource("graphics/exp_c.png"))
			
			TempBigImage=GaussianBlur(TempBigImage,3,240,38,255)
			TempBWImage=GaussianBlur(TempBWImage,3,240,38,255)
			TempColorImage=GaussianBlur(TempColorImage,4,240,38,255)
			
			ImageBWBlur = LoadAnimImage (TempBWImage,71,100,0,16,FILTEREDIMAGE)
			ImageColorBlur = LoadAnimImage (TempColorImage,71,100,0,16,FILTEREDIMAGE)
			BigImageBlur = LoadAnimImage (TempBigImage,104,104,0,25,FILTEREDIMAGE)
			
			TempColorImage=Null
			TempBWImage=Null
			TempBigImage=Null
			
			MidHandleImage( BigImageBlur )
			MidHandleImage( ImageBwBlur )
			MidHandleImage ( ImageColorBlur )
			
			PrepareFrame ImageColor
			PrepareFrame ImageBw
			PrepareFrame BigImage
			
			PrepareFrame ImageColorBlur
			PrepareFrame ImageBwBlur
			PrepareFrame BigImageBlur
			
		EndIf
		
		If Not List Then List=CreateList()
		
	End Function
	
	Function ReCache()
		PrepareFrame ImageColor
		PrepareFrame ImageBw
		PrepareFrame BigImage
		
		PrepareFrame ImageColorBlur
		PrepareFrame ImageBwBlur
		PrepareFrame BigImageBlur
	End Function
	
	Function MassFire (X#,Y#,Div#,MaxSize#,Duration#,Amount#)
		
		'If List = Null List = CreateList()
		
		For Local i=1 To Amount
			Local Explosion:TExplosion = New TExplosion	 
			
			List.AddLast Explosion
			
			If Rand(0,1) Then
				Explosion.MaxAge=25
			Else
				Explosion.MaxAge=16
			End If
			Explosion.X 			= X+Rand(-Div,Div)
			Explosion.Y 			= Y+Rand(-Div,Div)
			Explosion.FrameAge = 0
			Explosion.StartAge = 0 + Rand(Duration)
			Explosion.Size = Rnd(MaxSize*.75,MaxSize*1.25)
			Explosion.Transparency = 0.65
			Explosion.CurrentFrame = 1
			Explosion.Direction = Rand(0,359)
			If EasterEgg<>2
				Explosion.Desaturated = False
			Else
				Explosion.Desaturated = True
				Explosion.MaxAge=16
			End If
			'Explosion.MaxAge=16
		Next
	
	End Function

	Function Fire( X, Y, Size#, Desaturated:Byte=False)
		
		Local Explosion:TExplosion = New TExplosion	 
		'If List = Null List = CreateList()
		List.AddLast Explosion

		Explosion.X 			= X
		Explosion.Y 			= Y
		Explosion.FrameAge = 0
		Explosion.StartAge = 0
		Explosion.Size = Size+Rnd(-.12,-.015)
		Explosion.Transparency = 0.6
		Explosion.CurrentFrame = 1
		Explosion.Direction = Rand(0,360)
		Explosion.MaxAge=16
		Explosion.Desaturated = Desaturated
		If EasterEgg=2 Explosion.Desaturated=True

	EndFunction
	
	Method Draw(FrontBufferOnly:Byte)	

		If FrameAge>=StartAge
			If Not FrontBufferOnly
				SetAlpha (Transparency)
			End If
			'SetScale (Size,Size)
			'SetRotation(Direction)
			SetTransform Direction,Size,Size
			If MaxAge>16 Then
				DrawImage(BigImage,X,Y, CurrentFrame)
			ElseIf Desaturated = False
				DrawImage(ImageColor,X,Y, CurrentFrame)
			Else
				DrawImage(ImageBw,X,Y, CurrentFrame)
			End If
		End If
		'See note below about performance concerns (resetting the alpha & rot)
		'SetAlpha (1)
	EndMethod
	
	
	Method DrawGlow()	
		
		If FrameAge>=StartAge
			SetTransform Direction,Size*1.25,Size*1.25
			If MaxAge>16 Then
				DrawImage(BigImageBlur,X,Y, CurrentFrame)
			ElseIf Desaturated = False
				DrawImage(ImageColorBlur,X,Y, CurrentFrame)
			Else
				DrawImage(ImageBwBlur,X,Y, CurrentFrame)
			End If
		End If

		'See note below about performance concerns (resetting the alpha & rot)
		'SetAlpha (1)
	EndMethod
	
	Method Update()
		FrameAge:+1*Delta
		If FPSCurrent<=45 FrameAge:+1*Delta
		If FrameAge>StartAge 
			StartAge=0
			If FrameAge>7 Then FrameAge=0; CurrentFrame:+1
			If CurrentFrame => MaxAge Destroy()			
		End If
		If Not IsVisible(X,Y,1) Then Destroy()
	EndMethod

	Function DrawAll(FrontBufferOnly:Byte=False)
		
		If Not List Return 
		If EasterEgg=1 Or NoExplode Return
		
		If FrontBufferOnly SetAlpha 0.95
		SetBlend LIGHTBLEND
		
		Local Explosion:TExplosion
		For Explosion = EachIn List
			Explosion.Draw(FrontBufferOnly)
		Next
		
		SetBlend ALPHABLEND
		SetAlpha 1
		
	EndFunction
	
	Function DrawAllGlow()
		
		If Not List Return 
		If EasterEgg=1 Or NoExplode Return
		
		SetBlend LIGHTBLEND
		SetAlpha .75
		
		Local Explosion:TExplosion
		For Explosion = EachIn List
			Explosion.DrawGlow()
		Next
		
		SetBlend ALPHABLEND

	EndFunction

	Function UpdateAll()
		If Not List Return 
		
		Local Explosion:TExplosion
		For Explosion = EachIn List
			Explosion.Update()
		Next
		
	EndFunction

	Method Destroy() 
		List.Remove( Self )
	EndMethod
	
EndType	

'-----------------------------------------------------------------------------
'A Shockwave
'-----------------------------------------------------------------------------
Type TShockWave Extends TObject

	Field MaxAge:Float
	Field Age:Float
	Field Size:Float
	Field Transparency:Float
	Field Growth:Float
	Field IsGreyScale:Byte
	Field PowerUpEnd:Byte
	
	Global List:TList
	Global Image:TImage
	Global GreyImage:TImage
	
	Function Init()
		
		If Not List Then List=CreateList()
		
		If Not Image'First Time
			Image = LoadImage(GetBundleResource("Graphics/shockwaves.png"),MASKEDIMAGE)
			MidHandleImage( Image )
			PrepareFrame Image
			Local ShockWavePixmap:TPixmap = LoadPixmap (GetBundleResource("Graphics/shockwaves.png"))
			ConvertToGreyScale(ShockWavePixmap)
			GreyImage = LoadImage (ShockWavePixmap,MASKEDIMAGE)
			MidHandleImage GreyImage
			PrepareFrame GreyImage
		EndIf
		
	End Function
	
	Function ReCache()
		PrepareFrame GreyImage
		PrepareFrame Image
	End Function
	
	Function PrepareFrame(image:TImage) Private
		'Use this to cache an image or animimage in VRAM for quicker drawing later.
		For Local c=0 Until image.frames.length
			image.Frame(c)
		Next
	End Function
	
	Function Fire( X:Float, Y:Float, Size:Float=1, Grow:Float=8,GreyScale:Byte=False,PowerUpEnd:Byte=False)
	
		Local ShockWave:TShockWave = New TShockWave	 
		'If List = Null List = CreateList()
		List.AddLast ShockWave

		ShockWave.X 			= X
		ShockWave.Y 			= Y
		ShockWave.MaxAge = 150
		ShockWave.Size = Size/30
		ShockWave.Growth = Grow/30
		ShockWave.Transparency = 0.6
		ShockWave.IsGreyscale = Greyscale
		ShockWave.PowerUpEnd=PowerUpEnd
		If EasterEgg=2 Then ShockWave.IsGreyScale=True
		
	EndFunction
	
	Method Draw()	
		
		'If Not IsVisible(x,y,155) Then Return
		If Growth<0 
			SetColor 0,165,95
		ElseIf PowerUpEnd
			SetColor 74,255,235
		Else
			SetColor 255,255,255
		End If
		SetAlpha Transparency
		SetScale Size,Size
		If IsGreyScale
			DrawImage GreyImage,X,Y
		Else
			DrawImage Image,X,Y
		End If
		'See note below about performance concerns (resetting the alpha & rot)
		'SetAlpha (1)
	EndMethod
	
	Method Update()
		Transparency:-0.005*Delta
		Size:+Growth*Delta
		Age:+1*Delta				
		If Age > MaxAge Destroy()
	EndMethod

	Function DrawAll()
		If Not List Return 
		
		SetRotation 0
		Local ShockWave:TShockWave
		For ShockWave = EachIn List
			ShockWave.Draw()
		Next

		SetAlpha 1
		
	EndFunction

	Function UpdateAll()
		If Not List Return 
		
		Local ShockWave:TShockWave
		For ShockWave = EachIn List
			ShockWave.Update()
		Next
		
	EndFunction

	Method Destroy() 
		List.Remove( Self )
	EndMethod
	
EndType
'-----------------------------------------------------------------------------
'Lightning Flash
'-----------------------------------------------------------------------------	
Type TLightning Extends TObject
	
	Field Steps:Int
	Field Transparency:Float
	Field Origin:Tobject
	Field Target:Tobject
	Field Tick:Float
	Field TargetX:Float[14]
	Field TargetY:Float[14]
	Field OriginX:Float[14]
	Field OriginY:Float[14]
	Field JitterX:Float[14]
	Field JitterY:Float[14]
	
	Field ColorR:Int
	Field ColorG:Int
	Field ColorB:Int
	Field CoreR:Int
	Field CoreG:Int
	Field CoreB:Int
	
	Field StartX:Int
	Field StartY:Int
	Field EndX:Int
	Field EndY:Int
	Field FireTime:Int
	
	Global List:TList
	
	Const Jitter:Float=10
	
	Function Init()
	
		If Not List List=CreateList()
		
	End Function
	
	Function MassFire(AroundX:Float,AroundY:Float,Margin:Int,Amount:Int,ColorLess:Byte=False)
		
		'If List = Null List = CreateList()
		
		For Local i=1 To Amount*ParticleMultiplier
			Local Lightning:TLightning = New TLightning	
			List.Addlast Lightning
			
			Lightning.StartX=Rand(AroundX-Margin,AroundX+Margin)
			Lightning.StartY=Rand(AroundY-Margin,AroundY+Margin)
			Lightning.EndX=Rand(AroundX-Margin,AroundX+Margin)
			Lightning.EndY=Rand(AroundY-Margin,AroundY+Margin)
			Lightning.Transparency=0.9+Rnd(-.35,.2)
			Lightning.Steps=8-Rand(-4,0)
			Lightning.FireTime=MilliSecs()+Rand(0,1100)
			Lightning.Tick=9
			If Not ColorLess
				Lightning.CoreR=0
				Lightning.CoreG=25
				Lightning.CoreB=155
			Else
				Lightning.CoreR=190
				Lightning.CoreG=190
				Lightning.CoreB=190
			End If
		Next
	
	End Function
	
	Function Fire(Origin:Tobject,Target:TObject)
		'Print "Fired"
		
		If Target=Null Or Origin=Null Return
		Local Lightning:TLightning = New TLightning
		
		'If List = Null List = CreateList()
		List.Addlast Lightning
		
		Lightning.Origin = Origin
		Lightning.Target = Target
		Lightning.Transparency=0.9
		Lightning.Steps=6-Rand(-3,0)
		Lightning.FireTime=0
		Lightning.Tick=9
		Lightning.CoreR=0
		Lightning.CoreG=25
		Lightning.CoreB=155
		
		'PlaySoundBetter Sound_Game_Presents,Origin.X,Origin.Y
		
	End Function
	
	Method Update()
		
		If FireTime<>0 And MilliSecs()-FireTime<=0 Return
		
		'Print "called! u"
		Local XStep:Float
		Local YStep:Float
		
		Local BeginX:Float
		Local BeginY:Float
		
		Local TailX:Float
		Local TailY:Float
		
		If Target = Null
			TargetX[1]=EndX
			TargetY[1]=EndY
			
			OriginX[Steps-1]=StartX
			OriginY[Steps-1]=StartY
			
			XStep=(StartX-EndX)/Steps
			YStep=(StartY-EndY)/Steps
		Else
			TargetX[1]=Target.X
			TargetY[1]=Target.Y
			
			OriginX[Steps-1]=Origin.X
			OriginY[Steps-1]=Origin.Y
			
			XStep=(Origin.X-Target.X)/Steps
			YStep=(Origin.Y-Target.Y)/Steps
		End If
		
		If Transparency>.6 And Rand(0,12)<2 PlaySoundBetter Sound_Game_Presents,TargetX[1],TargetY[1]
		
		Tick:+1*Delta
		
		If Tick>8
			For Local i=1 To Steps-1
				JitterX[i]=Rnd(-Jitter,Jitter)
				JitterY[i]=Rnd(-Jitter,Jitter)
				OriginX[i]=(TargetX[i]+XStep)+JitterX[i]
				OriginY[i]=(TargetY[i]+YStep)+JitterY[i]
				
				TargetX[i+1]=OriginX[i]
				TargetY[i+1]=OriginY[i]
			Next
			Tick=0
			
		End If
		
		Transparency:-0.01*Delta
		
		If Transparency<=0 Destroy()
		
	End Method
	
	Method DrawGlow()
		
		SetAlpha Transparency
		
		For Local i=1 To Steps-1
			SetColor CoreR,CoreG,CoreB
			SetLineWidth 2
			DrawLine TargetX[i]+.5,TargetY[i]+.5,OriginX[i]+.5,OriginY[i]+.5
			DrawLine TargetX[i]-.5,TargetY[i]-.5,OriginX[i]-.5,OriginY[i]-.5
				
			SetColor 125,125,125
			SetLineWidth 3
			DrawLine TargetX[i]-1,TargetY[i]-1,OriginX[i]-1,OriginY[i]-1
			DrawLine TargetX[i]+1,TargetY[i]+1,OriginX[i]+1,OriginY[i]+1
			
		Next
			
		'DrawLine TargetX[0],TargetY[0],TargetX[1],TargetY[1]
	
	End Method
	
	Method DrawGlowGL()
	
		SetAlpha Transparency
		
		For Local i=1 To Steps-1
			
			SetColor CoreR,CoreG,CoreB
			
			glLineWidth 2
			
			glVertex2f TargetX[i]-.5,TargetY[i]-.5
			glVertex2f OriginX[i]-.5,OriginY[i]-.5
			
						
			glVertex2f TargetX[i]+1,TargetY[i]+1
			glVertex2f OriginX[i]+1,OriginY[i]+1
			
			SetColor 125,125,125
			
			glLineWidth 3
			
			glVertex2f TargetX[i]-1,TargetY[i]-1
			glVertex2f OriginX[i]-1,OriginY[i]-1
			
			glVertex2f TargetX[i]+1,TargetY[i]+1
			glVertex2f OriginX[i]+1,OriginY[i]+1
		
		Next

		'glVertex2f TargetX[0],TargetY[0]
		'glVertex2f TargetX[1],TargetY[1]
			
	End Method
	
	Method Draw()
		
		SetAlpha Transparency
		
		For Local i=1 To Steps-1
			SetColor CoreR,CoreG,CoreB
			SetLineWidth 2.5
			DrawLine TargetX[i],TargetY[i],OriginX[i],OriginY[i]
				
			SetColor 125,125,125
			SetLineWidth 3
			DrawLine TargetX[i],TargetY[i],OriginX[i],OriginY[i]
			
		Next
			
		'DrawLine TargetX[0],TargetY[0],TargetX[1],TargetY[1]
	
	End Method
	
	Method DrawGL()
	
		SetAlpha Transparency
		
		For Local i=1 To Steps-1
			
			SetColor CoreR,CoreG,CoreB
			
			glLineWidth 2.5
			
			glVertex2f TargetX[i],TargetY[i]
			glVertex2f OriginX[i],OriginY[i]
			
			SetColor 125,125,125
			
			glLineWidth 3
			
			glVertex2f TargetX[i],TargetY[i]
			glVertex2f OriginX[i],OriginY[i]
		
		Next

		'glVertex2f TargetX[0],TargetY[0]
		'glVertex2f TargetX[1],TargetY[1]
			
	End Method
	
	Function DrawAll()
		
		If Not List Return 
		If List.Count()=0 Return
		SetTransform 0,1,1
		SetBlend LIGHTBLEND
		
		If GlLines
			SetLineWidth 2.5
			glDisable GL_TEXTURE_2D; glBegin GL_LINES
			Local Lightning:TLightning
			For Lightning = EachIn List
				Lightning.DrawGL()
			Next
			glEnd; glEnable GL_TEXTURE_2D
		Else
			Local Lightning:TLightning
			For Lightning = EachIn List
				Lightning.Draw()
			Next
		End If
		
		'SetLineWidth 1
		SetBlend ALPHABLEND
		SetAlpha 1
		SetColor 255,255,255
		
	EndFunction

	Function DrawAllGlow()
		
		If Not List Return 
		
		SetTransform 0,1,1

		SetBlend LIGHTBLEND
		
		If GlLines
			SetLineWidth 2.5
			glDisable GL_TEXTURE_2D; glBegin GL_LINES
			Local Lightning:TLightning
			If GlowQuality>=512 And FullScreenGlow
				SetLineWidth 3.5
				For Lightning = EachIn List
					Lightning.DrawGlowGL()
				Next
			Else
				For Lightning = EachIn List
					Lightning.DrawGL()
				Next
			End If
			glEnd; glEnable GL_TEXTURE_2D
		Else
			Local Lightning:TLightning
			If GlowQuality>=512 And FullScreenGlow
				For Lightning = EachIn List
					Lightning.DrawGlow()
				Next
			Else
				For Lightning = EachIn List
					Lightning.Draw()
				Next
			End If
		End If
		
		SetBlend ALPHABLEND
		SetAlpha 1
		'SetLineWidth 1
		SetColor 255,255,255
		
	EndFunction

	Function UpdateAll()
	
		If Not List Return 
		
		Local Lightning:TLightning
		For Lightning = EachIn List
			Lightning.Update()
		Next
		
	EndFunction

	Method Destroy() 
		List.Remove( Self )
	EndMethod
	
	Function DestroyAll()
		
		Local Lightning:TLightning
		For Lightning = EachIn List
			Lightning.Destroy()
		Next
		
	End Function
	
End Type
'-----------------------------------------------------------------------------
'Glowing Debris 
'-----------------------------------------------------------------------------
Type TGlow

	Field X:Float
	Field Y:Float
	Field XSpeed:Float
	Field YSpeed:Float
	Field Age:Float
	Field Size:Float
	Field Transparency:Float
	Field MaxAge:Int
	Field RGB:Int[3]
	Field Kind:Byte
	Field Flicker:Byte
	Field Ticker:Float
	
	Global List:TList
	Global Image:TImage
	
	Function Init()
		
		If List = Null List = CreateList()
		
		If Not Image'First Time
			Image = LoadImage (GetBundleResource("graphics/glow.png"),MASKEDIMAGE)
			MidHandleImage( Image )
			PrepareFrame Image
		EndIf
		
	End Function
	
	Function ReCache()
		PrepareFrame Image
	End Function
	
	Function PrepareFrame(image:TImage) Private
		'Use this to cache an image or animimage in VRAM for quicker drawing later.
		For Local c=0 Until image.frames.length
			image.Frame(c)
		Next
	End Function
	
	Function MassFire (X#,Y#,Variation#,MaxSize#,Amount#,Direction#,R:Int=255,G:Int=255,B:Int=255,RandomDirection:Int=False,ShortLived:Int=False,IsBomb:Int=False,StandStill:Byte=False,Flicker:Byte=True)
		
		Local CreateAmount:Int=Amount*ParticleMultiplier
		
		If CreateAmount<=1 Then CreateAmount=1
		
		For Local i=1 To CreateAmount
			
			Local Glow:TGlow = New TGlow	 
			Local GDir:Float
			
			List.AddLast Glow
			
			Glow.X 			= X+Rand(-Variation,Variation)
			Glow.Y 			= Y+Rand(-Variation,Variation)
			Glow.Age = 0
			Glow.Size = MaxSize/3
			Glow.MaxAge = 250+Rand(30)

			If Not RandomDirection
				If Direction<0 
					GDir = Direction-Rnd(1,10)
				Else
					GDir = Direction+Rnd(1,10)
				End If
				Glow.XSpeed= Cos(GDir)*Rnd(1,2.5)
				Glow.YSpeed= Sin(GDir)*Rnd(1,2.5)
				Glow.Kind=IsBomb
			Else
				GDir = Rand(0,359)
				Glow.Age=Rand(48)
				Glow.XSpeed= Cos(GDir)*Rnd(2,4)
				Glow.YSpeed= Sin(GDir)*Rnd(2,4)
				Glow.Kind=IsBomb
			End If
			
			
			Glow.RGB[0]=R*1.25
			Glow.RGB[1]=G*1.25
			Glow.RGB[2]=B*1.25
			Glow.Flicker=Flicker
			
			If ShortLived
				Glow.MaxAge=222
				Glow.XSpeed:/2
				Glow.YSpeed:/2
			End If
			
			If StandStill
				Glow.XSpeed=0
				Glow.YSpeed=0
			End If
			
		Next
				
	End Function
	
	Method Draw()	
		
		If Not Flicker SetScale .6,.6
		SetAlpha Transparency
		SetColor (RGB[0],RGB[1],RGB[2])
		DrawImage(Image,X,Y)
		If Not Flicker SetScale .7,.7

	EndMethod
	
	Method Update()
		
		Age:+1*Delta
		Ticker:+1*Delta		
		If Age>=MaxAge Destroy()
				
		X:+XSpeed*Delta
		Y:+YSpeed*Delta
		
		If Not IsVisible(x,y,6) Then Destroy()
		
		Transparency=(MaxAge-Age)/210
		If Flicker
			If Rand(0,30)<15
				If Age>50-Rand(0,25) And Age<MaxAge-Rand(55,100)
					Transparency=Transparency*5
				End If
			End If
		End If
		
		If Kind And Ticker>=1
			x:+Rnd(-2.6,2.6)
			y:+Rnd(-2.6,2.6)
			Ticker=0
		End If

		XSpeed:-(XSpeed)*0.009*Delta
		YSpeed:-(YSpeed)*0.009*Delta
		
	EndMethod

	Function DrawAll()
		If Not List Return 
		
		SetScale .7,.7
		Local link:TLink= List.FirstLink()
		While link
			Local Glow:TGlow=TGlow(link._value)
			Glow.Draw() 
			If link._succ._value<>link._succ 
			link=link._succ
			
			Else
				link=Null
			End If		
		Wend
		
		'scSetRotation(0)
		'SetScale(1,1)
		SetAlpha(1)
		SetColor(255,255,255)
	EndFunction

	Function UpdateAll()
		If Not List Return 
		
		Rem
		Local Glow:TGlow
		For Glow = EachIn List
			Glow.Update()
		Next
		End Rem
		Local link:TLink= List.FirstLink()
		While link
			Local Glow:TGlow=TGlow(link._value)
			Glow.Update()
			If link._succ._value<>link._succ 
				link=link._succ
			Else
				link=Null
			End If		
		Wend
		
	EndFunction

	Method Destroy() 
		List.Remove( Self )
	EndMethod
	
EndType	
'-----------------------------------------------------------------------------
'ShotGhost because it looks cool!
'-----------------------------------------------------------------------------
Type TShotGhost 
	
	Field X:Float
	Field Y:Float
	Field Direction:Float
	Field Size:Float
	Field Transparency:Float
	'Field Shooter
	Field IsSuper:Byte
	
	Global List:TList
	Global Image:TImage
	
	Function Init()

		If List = Null List = CreateList()
		
		If Not Image'First Time
			Image=Shot.ShotGlow
			'Image = LoadImage(GetBundleResource("Graphics/yellowshot.png"),MASKEDIMAGE)
			MidHandleImage( Image )
			PrepareFrame Image
		EndIf
		
	End Function
	
	Function ReCache()
		PrepareFrame Image
	End Function
	
	Function RegetImage()
	
		Image=Null
		
		If Not Image'First Time
			Image=Shot.ShotGlow
			MidHandleImage( Image )
			PrepareFrame Image
		EndIf
		
	End Function
	
	Function PrepareFrame(image:TImage) Private
		'Use this to cache an image or animimage in VRAM for quicker drawing later.
		For Local c=0 Until image.frames.length
			image.Frame(c)
		Next
	End Function

	Function Fire( X:Float,Y:Float, Direction:Float, IsSuper:Byte)
		
		If MotionBlurEnable=False Return
		
		Local ShotGhost:TShotGhost = New TShotGhost	 
		
		List.AddLast ShotGhost
		
		'Local ShotGhostSpeed#= 0
		ShotGhost.X 			= X
		ShotGhost.Y 			= Y
		ShotGhost.Direction 	= Direction
		'ShotGhost.Age = 1
		'ShotGhost.MaxAge = 140
		ShotGhost.Size = 1
		If FullScreenGlow
			ShotGhost.Transparency= .55
		Else
			ShotGhost.Transparency= .8
		End If
		'ShotGhost.Shooter = Shooter
		ShotGhost.IsSuper = IsSuper
		
	EndFunction
	
	Method Draw()	
		
		If IsSuper
			SetColor 255,0,0
		Else
			SetColor 255,255,255
		End If
		SetAlpha (Transparency)
		SetRotation(Direction)
		DrawImage(Image,X,Y)

	EndMethod
	
	Function DrawAll()
		If Not List Return 
		If List.Count()=0 Return
		
		SetBlend LIGHTBLEND
		SetScale 3,3
		
		'Local ShotGhost:TShotGhost
		'For ShotGhost = EachIn List
		'	ShotGhost.Draw()
		'Next
		Local link:TLink= List.FirstLink()
		While link
			Local ShotGhost:TShotGhost=TShotGhost(link._value)
			ShotGhost.Draw()
			If link._succ._value<>link._succ 
				link=link._succ
			Else
				link=Null
			End If		
		Wend
		SetAlpha 1
		SetBlend ALPHABLEND
	
	End Function
	
	Method Update()

		If MotionBlurEnable=1
			Transparency:-0.0035*Delta			
		ElseIf MotionBlurEnable=2
			Transparency:-0.003*Delta
		End If
	
		If Transparency<0 Destroy()
		If Not IsVisible(x,y) Destroy()
		
	EndMethod

	Function UpdateAll()
		If Not List Return 
		
		'Local ShotGhost:TShotGhost
		'For ShotGhost = EachIn List
		'	ShotGhost.Update()
		'Next
		Local link:TLink= List.FirstLink()
		While link
			Local ShotGhost:TShotGhost=TShotGhost(link._value)
			ShotGhost.Update()
			If link._succ._value<>link._succ 
				link=link._succ
			Else
				link=Null
			End If		
		Wend
	EndFunction

	Method Destroy() 
		List.Remove( Self )
	EndMethod
	
EndType
'-----------------------------------------------------------------------------
'Motion Blur Ghosting effect
'-----------------------------------------------------------------------------
Type TMotionBlur

	Global List:TList
	
	Field X:Float
	Field Y:Float
	Field Direction:Float
	Field AnimFrame:Int
	Field Image:TImage
	Field Scale:Float
	Field Transparency:Float
	
	Function Init()
		If List = Null List = CreateList()
	End Function
	
	Function Spawn(X:Float,Y:Float,Direction:Float,Scale:Float,Image:TImage,Force:Byte=False,AnimFrame:Int=0)
		
		If Not Force
			If FPSTarget<>SLOW_FPS Or MotionBlurEnable=0 Return
		End If
		
		
		Local MotionBlur:TMotionBlur = New TMotionBlur
		List.AddLast MotionBlur
		
		MotionBlur.X=X
		MotionBlur.Y=Y
		MotionBlur.Direction=Direction
		MotionBlur.Image=Image
		MotionBlur.Scale=Scale
		MotionBlur.AnimFrame=AnimFrame
		MotionBlur.Transparency=1
		
	End Function
		
	Method Draw()
	
		SetTransform (Direction,Scale,Scale)
		SetAlpha Transparency
		DrawImage Image,x,y,AnimFrame
	
	EndMethod
	
	Method Update()
		
		If MotionBlurEnable=1
			Transparency:-0.01*Delta
		ElseIf MotionBlurEnable=2
			Transparency:-0.0065*Delta
		End If
		
		If Transparency<=0 Destroy()
	
	EndMethod
	
	Method Destroy()
	
		List.Remove(Self)
		
	End Method
	
	
	Function DrawAll()
		'Local draw:Int=MilliSecs()
		If Not List Return
		If List.Count()=0 Return 
		
		SetBlend LIGHTBLEND
		
		'Local MotionBlur:TMotionBlur
		'For MotionBlur = EachIn List
		'	MotionBlur.Draw()
		'Next
		Local link:TLink= List.FirstLink()
		While link
			Local MotionBlur:TMotionBlur=TMotionBlur(link._value)
			MotionBlur.Draw()
			If link._succ._value<>link._succ 
				link=link._succ
			Else
				link=Null
			End If		
		Wend
		
		SetBlend ALPHABLEND
		SetAlpha 1
		'It's faster to re-set the scale and transparency once than every time for a particle
		'Print "Draw Time:"+(MilliSecs()-Draw)

	
	End Function

	Function UpdateAll()
		'Local update:Int=MilliSecs()
		If Not List Return
		'Local MotionBlur:TMotionBlur
		'For MotionBlur = EachIn List
		'	MotionBlur.Update()
		'Next
		Local link:TLink= List.FirstLink()
		While link
			Local MotionBlur:TMotionBlur=TMotionBlur(link._value)
			MotionBlur.Update()
			If link._succ._value<>link._succ 
				link=link._succ
			Else
				link=Null
			End If		
		Wend
		'Print "Update Time:"+(MilliSecs()-Update)
	End Function
	
End Type
Rem
'-----------------------------------------------------------------------------
'Corruption effect makes invaders display a trail of white noise
'-----------------------------------------------------------------------------
Type TCorruptionEffect Extends TObject

	Global List:TList
	Global Image:TImage
	
	Field Scale:Float
	Field Transparency:Float
	Field Frame:Float
	
	Function Init()
	
		If Not Image
			Image=LoadAnimImage(GetBundleResource("graphics/chaosshield.png"),4,4,0,20,MASKEDIMAGE) 
			MidHandleImage Image
		End If
		
	End Function
	
	Function Spawn(X:Float,Y:Float,Direction:Float,Scale:Float)
		
		'If CorruptionEffectEnable=0 Return
		
		If List = Null List = CreateList()
		
		Local CorruptionEffect:TCorruptionEffect = New TCorruptionEffect
		List.AddLast CorruptionEffect
		
		CorruptionEffect.X=X
		CorruptionEffect.Y=Y
		CorruptionEffect.Direction=Direction
		CorruptionEffect.Scale=Scale
		CorruptionEffect.Transparency=.9
		
	End Function
		
	Method Draw()
	
		SetTransform (Direction,Scale,Scale)
		SetAlpha Transparency
		DrawImage Image,x,y,Frame
	
	EndMethod
	
	Method Update()
	
		Transparency:-0.005*Delta
		If Transparency<=0 Destroy()
		Frame=Rand(0,19)
		Scale:+0.02*Delta
	
	EndMethod
	
	Method Destroy()
	
		List.Remove(Self)
		
	End Method
	
	
	Function DrawAll()
		If Not List Return 
		
		'SetBlend ALPHABLEND
		
		Local CorruptionEffect:TCorruptionEffect
		For CorruptionEffect = EachIn List
			CorruptionEffect.Draw()
		Next
		
		'SetBlend ALPHABLEND
		SetAlpha 1
		'It's faster to re-set the scale and transparency once than every time for a particle
		
	
	End Function

	Function UpdateAll()
		If Not List Return
		
		Local CorruptionEffect:TCorruptionEffect
		For CorruptionEffect = EachIn List
			CorruptionEffect.Update()
		Next
		
	End Function
	
End Type
End Rem
'-----------------------------------------------------------------------------
'Spawn Effect opens a colored square in the color of the monster being spawned
'-----------------------------------------------------------------------------
Type TSpawnEffect Extends TObject

	Global List:TList
	Global Image:TImage
	
	Field Transparency	:Float
	Field ScaleX:Float
	Field ScaleY:Float
	Field RGB:Int[3]
	
	Function Init()
		
		If List = Null List = CreateList()
		
		If Not Image'First Time
			Image = LoadImage(GetBundleResource("Graphics/spawn.png"))
			MidHandleImage( Image )
			PrepareFrame Image
			
		EndIf
		
	End Function
	
	Function ReCache()
		PrepareFrame Image
	End Function
	
	Function PrepareFrame(image:TImage) Private
		'Use this to cache an image or animimage in VRAM for quicker drawing later.
		For Local c=0 Until image.frames.length
			image.Frame(c)
		Next
	End Function
	
	Function Fire(X:Int,Y:Int,Scale:Float,R:Int,G:Int,B:Int)

		If List = Null List = CreateList()
	
		Local SpawnEffect:TSpawnEffect = New TSpawnEffect	 
		List.AddLast SpawnEffect
			
		SpawnEffect.X=X
		SpawnEffect.Y=Y
		SpawnEffect.Transparency=0.5
		SpawnEffect.ScaleX=Scale
		SpawnEffect.ScaleY=Scale
		SpawnEffect.RGB[0]=R
		SpawnEffect.RGB[1]=G
		SpawnEffect.RGB[2]=B
		
	EndFunction
	
	Method Draw()	
		
		
		SetAlpha Transparency
		SetColor RGB[0],RGB[1],RGB[2]
		SetScale ScaleX,ScaleY
		DrawImage Image,X,Y
		
		'See note below about performance concerns (resetting the alpha & rot)
		'SetAlpha (1)
	EndMethod
	
	Method Update()

		If Transparency>0
			Transparency:-.005*Delta
		End If
		
		If ScaleX<=0 Destroy()
		
		ScaleX:-.016*Delta
		ScaleY:-.005*Delta
		
	End Method
	
	Function DrawAll()
		If Not List Return 
		
		SetRotation 0
		
		Local link:TLink= List.FirstLink()
		While link
			Local SpawnEffect:TSpawnEffect=TSpawnEffect(link._value)
			SpawnEffect.Draw() 
			If link._succ._value<>link._succ 
				link=link._succ
			Else
				link=Null
			End If		
		Wend

		'Local SpawnEffect:TSpawnEffect
		'For SpawnEffect = EachIn List
		'	SpawnEffect.Draw()
		'Next
		
		SetColor 255,255,255
		SetAlpha 1
		'It's faster to re-set the scale and transparency once than every time for a particle
		
	
	End Function

	Function UpdateAll()
		
		'Local SpawnEffect:TSpawnEffect
		'For SpawnEffect = EachIn List
		'	SpawnEffect.Update()
		'Next
		
		Local link:TLink= List.FirstLink()
		While link
			Local SpawnEffect:TSpawnEffect=TSpawnEffect(link._value)
			SpawnEffect.Update() 
			If link._succ._value<>link._succ 
				link=link._succ
			Else
				link=Null
			End If		
		Wend
		
	End Function
	
	Method Destroy() 
		List.Remove( Self )
	EndMethod
	
End Type


'-----------------------------------------------------------------------------
'Thrust Exhaust Particles
'-----------------------------------------------------------------------------
Type TThrust
	
	Field X:Float
	Field Y:Float
	Field Size:Float
	Field Transparency:Float
	Field RGB:Float[3]
	
	Global List:TList
	Global Image:TImage
	
	Function Init()
		
		If List = Null List = CreateList()
		
		If Not Image'First Time
			
			Local TempMap:TPixmap=CreatePixmap(9,9,PF_RGBA8888)
			ClearPixels (TempMap)
			For Local i=0 To 4
				WritePixel (TempMap,i+3,3,$ffffffff)
				WritePixel (TempMap,i+3,4,$ffffffff)
				WritePixel (TempMap,i+3,5,$ffffffff)
				WritePixel (TempMap,i+3,6,$ffffffff)
				WritePixel (TempMap,i+3,7,$ffffffff)
			Next
			
			Image=LoadImage(GaussianBlur(TempMap,2,220,35,245))
		
			MidHandleImage Image
			
			image.Frame(0)
		EndIf
		
	End Function
	
	
	Function ReCache()
		image.Frame(0)
	End Function
	
	Function Fire( X, Y, Size#=1,ThrustR:Int,ThrustG:Int,ThrustB:Int,HalfAlpha:Byte=False)
		
		Local Thrust:TThrust = New TThrust	 
		
		List.AddLast Thrust
		
		Thrust.X 			= X
		Thrust.Y 			= Y
		'Thrust.Direction 	= Direction
		Thrust.Size = Size*2
		If HalfAlpha
			Thrust.Transparency = 0.35
		Else	
			Thrust.Transparency = 0.8
		End If
		Thrust.RGB[0]=ThrustR*1.1
		Thrust.RGB[1]=ThrustG*1.1
		Thrust.RGB[2]=ThrustB*1.1
		
		'Add Thrust Start Speed
		'Thrust.XSpeed= -Cos(Direction)*ThrustSpeed '+ XSpeed
		'Thrust.YSpeed= -Sin(Direction)*ThrustSpeed '+ YSpeed
	EndFunction
	
	Method Draw()	
		
		SetAlpha (Transparency)
		SetScale (Size,Size)
		SetColor RGB[0],RGB[1],RGB[2]
		DrawImage(Image,X,Y)
		
		'See note below about performance concerns (resetting the alpha & rot)
		'SetAlpha (1)
	EndMethod
	
	Function DrawAll()
		If Not List Return 
		
		SetRotation 0
		SetBlend LIGHTBLEND
		'Local Thrust:TThrust
		'For Thrust = EachIn List
		'	Thrust.Draw()
		'Next
		Local link:TLink= List.FirstLink()
		While link
			Local Thrust:TThrust=TThrust(link._value)
			Thrust.Draw()
			If link._succ._value<>link._succ 
				link=link._succ
			Else
				link=Null
			End If		
		Wend
		
		SetColor 255,255,255
		SetAlpha 1
		SetBlend ALPHABLEND
		'It's faster to re-set the scale and transparency once than every time for a particle
		
		'SetScale(1,1)
		'SetAlpha(1)
	
	End Function
	
	Method Update()
		'Draw()
		Size:-0.005*Delta
		Transparency:-0.0045*Delta
		
		RGB[0]:-1.15*Delta
		RGB[1]:-1.3*Delta
		RGB[2]:-1.1*Delta
		
		'x:+Rnd(-.1,-.1)*Delta
		'y:+Rnd(-.1,-.1)*Delta

		If Transparency<=0 Destroy()
		If Not IsVisible(x,y) Destroy()
		
	EndMethod

	Function UpdateAll()
		If Not List Return 
		
		'Local Thrust:TThrust
		'For Thrust = EachIn List
		'	Thrust.Update()
		'Next
		Local link:TLink= List.FirstLink()
		While link
			Local Thrust:TThrust=TThrust(link._value)
			Thrust.Update()
			If link._succ._value<>link._succ 
				link=link._succ
			Else
				link=Null
			End If		
		Wend
		
	EndFunction

	Method Destroy() 
		List.Remove( Self )
	EndMethod
	
EndType

'-----------------------------------------------------------------------------
'A Shot either from a player or an Invader
'-----------------------------------------------------------------------------
Type TShot Extends TObject
	
	Field Age:Float
	Field MaxAge#
	Field Size#, Transparency#
	Field Kind:Byte
	Field Shooter:Int
	Field i:Float
	Field Immune:Float
	Field Bounce:Int=0
	Field SuperShot:Byte
	Field BouncyShot:Byte
	Field ImmolationShot:Byte
	
	Global ShotRGB:Int[3]
	Global List:TList
	Global ShotBody:TImage
	Global ShotGlow:TImage
	
	Function Generate()
		
		GenerateShot()
		PrepareFrame ShotBody
		PrepareFrame ShotGlow
		
	EndFunction
	
	Function Init()
	
		If List = Null List = CreateList()
		
	End Function
	
	Function ReCache()
		PrepareFrame ShotBody
		PrepareFrame ShotGlow
	End Function
	
	Method CalculateNewDirection(x:Float,y:Float,x1:Float,y1:Float)
	
		Local nx:Float
		Local ny:Float
		Local NL:Float
		
		nx=y-y1
		ny=-x+x1
		
		Rem
		If(ny/nx*xpseed+barrier2y-(ny/nx)*barrier2x-yspeed<0)
			nx=-nx
			ny=-ny
		EndIf
		End Rem
		
		nx= nx/Sqr(nx*nx+ny*ny)
		ny= ny/Sqr(nx*nx+ny*ny)
		
		'DrawLine x,y,x+nx*100,y+ny*100
	
		
		NL=nx*-xspeed+ny*-yspeed
		
		Local RX:Float
		Local RY:Float
		
		
		rx=2*nx*NL+xspeed
		ry=2*ny*NL+yspeed
		
		'SetColor 255,0,0
		'DrawLine x,y,x+rx*100,y+ry*100
		'SetColor 255,255,255
		
		'Why halfing this?
		xspeed=rx/2
		yspeed=ry/2
		
		Direction=ATan2(Yspeed,XSpeed)+90
	
	EndMethod
	
	Function Fire( X, Y, Direction, XSpeed, YSpeed, Kind=1, ShotSpeed:Float, ImmolationShot=False	)
		Local Shot:TShot = New TShot	 
		If List = Null List = CreateList()
		List.AddLast Shot
		
		'Local ShotSpeed:Float= 5
		
		Shot.X 			= X
		Shot.Y 			= Y
		Shot.Direction 	= Direction+90
		Shot.Age = 1
		Shot.MaxAge = 150'215
		Shot.Size = 1
		Shot.Kind=Kind
		Shot.Shooter=1
		Shot.ImmolationShot=ImmolationShot
		If Player.HasSuper<>0 Then Shot.SuperShot=True
		If Player.HasBounce<>0 Then Shot.BouncyShot=True
		'Shot.SuperShot = Player.HasSuper
		'Shot.BouncyShot = Player.HasBounce
		
		'Add Thrust Start Speed
		Shot.XSpeed= Cos(Direction)*ShotSpeed + XSpeed
		Shot.YSpeed= Sin(Direction)*ShotSpeed + YSpeed
		
		
	EndFunction
	
	Method Draw()
		
		If SuperShot
			SetColor 235,40,0
		Else
			SetColor 255,255,255
		End If
		SetRotation(Direction)
		'scDrawImage(Image,X,Y)
		DrawImage(ShotBody,X,Y)
	
	EndMethod
	
	Method DrawGlow()
		
		If SuperShot
			SetColor 230,40,0
		Else
			SetColor 255,255,255
		End If
		SetRotation(Direction)
		DrawImage(ShotGlow,X,Y)
	
	EndMethod
	
	Method Update()
		
		i:+1*Delta
		
		If FPSTarget=SLOW_FPS Or ImmolationShot
			ImmolationShot=True			
			If i>=(12*(1/BlurDivider))
				i=0
				ShotGhost.Fire(x,y,direction,SuperShot)
			End If	
		End If

		X:+ XSpeed*Delta
		Y:+ YSpeed*Delta					
		
		If FPSTarget=SLOW_FPS And FPSCurrent<=FAST_FPS*.97 And Kind=1
			X:+ XSpeed*(1/(FPSCurrent/11.5))*Delta
			Y:+ YSpeed*(1/(FPSCurrent/11.5))*Delta
		End If
		
		If Not BouncyShot And Not IsVisible(x,y,-1) Then
			If ParticleMultiplier>=1
				If SuperShot 
					Glow.MassFire(X,Y,1.5,.25,4,AwayFrom(FieldWidth/2,FieldHeight/2,X,Y),ShotRGB[0]+128,ShotRGB[1]-160,ShotRGB[2]-160,False,True,False,False,True)			
				Else
					Glow.MassFire(X,Y,1.5,.25,4,AwayFrom(FieldWidth/2,FieldHeight/2,X,Y),ShotRGB[0],ShotRGB[1],ShotRGB[2],False,True,False,False,False)
				End If
			End If
			Destroy()
			'Glow.MassFire(X,Y,1,.5,5,-Direction+90,ShotRGB[0],ShotRGB[1],ShotRGB[2])
		End If
		
		
		If Immune>0 Immune:-0.1*Delta
		'Bouncy Shots
		If BouncyShot
			If X > FieldWidth
				If Bounce=0
					Flash.Fire(X,Y,.2,50)
					XSpeed=-Xspeed
					X=FieldWidth-2'X = 0
					'Direction=Direction*-1
					Direction=Direction*-1
					'Direction=Rad2Deg(ATan2(XSpeed,YSpeed))
				End If
				Bounce:+1
			End If
			If Y > FieldHeight
				If Bounce=0
					Flash.Fire(X,Y,.2,50)
					YSpeed=-YSpeed
					Y=FieldHeight-2'Y = 0
					Direction=Direction*-1
				End If
				'Direction=Rad2Deg(ATan2(XSpeed,YSpeed))
				Bounce:+1
			End If
			If X < 0
				If Bounce=0
					Flash.Fire(X,Y,.2,50) 
					XSpeed=-Xspeed
					X=2'X = FieldWidth
					Direction=Direction*-1
				End If
				'Direction=Rad2Deg(ATan2(XSpeed,YSpeed))
				Bounce:+1
			End If
			If Y < 0 
				If Bounce=0
					Flash.Fire(X,Y,.2,50)
					YSpeed=-Yspeed
					Y=2'Y = FieldHeight
					Direction=Direction*-1
				End If
				'Direction=Rad2Deg(ATan2(XSpeed,YSpeed))
				Bounce:+1
			End If
		End If
		
		If Bounce>=2
			If ParticleMultiplier>=1
				If SuperShot 
					Glow.MassFire(X,Y,1.5,.25,4,AwayFrom(FieldWidth/2,FieldHeight/2,X,Y),ShotRGB[0]+128,ShotRGB[1]-160,ShotRGB[2]-160,False,True,False,False,True)			
				Else
					Glow.MassFire(X,Y,1.5,.25,4,AwayFrom(FieldWidth/2,FieldHeight/2,X,Y),ShotRGB[0],ShotRGB[1],ShotRGB[2],False,True,False,False,False)
				End If
			End If
			Destroy()
		End If
		
	EndMethod
	
	Function DrawAll()
		If Not List Return 
		
		'If Player.HasSuper Then SetColor (255,0,0)
		
		SetScale 3,3
		SetAlpha 1
		
		Local Shot:TShot
		For Shot = EachIn List
			Shot.Draw()
		Next
		
		SetScale 5,5
		SetBlend LIGHTBLEND
		
		Local ShotGlow:TShot
		For ShotGlow = EachIn List
			ShotGlow.DrawGlow()
		Next
		SetBlend ALPHABLEND
		SetColor 255,255,255
		'If Player.HasSuper Then SetColor (255,255,255)
	
	End Function
	
	Function DrawAllGlow()
		If Not List Return 
		
		SetScale 5,5
		
		Local Shot:TShot
		For Shot = EachIn List
			Shot.DrawGlow()
		Next
		
		SetColor 255,255,255
	
	End Function

	Function UpdateAll()
		If Not List Return 
		
		Local Shot:TShot
		For Shot = EachIn List
			Shot.Update()
		Next
	
	EndFunction

	Method Destroy()
		List.Remove( Self )
	EndMethod
	
	Method EnemyDestroy(Fizzle:Int=False,Force:Byte=False)
		If Not SuperShot Or Force=True
			If Fizzle=True And Not SuperShot
				ParticleManager.Create(X,Y,8,ShotRGB[0]+40,ShotRGB[1]+40,ShotRGB[2]+40,Direction+90,1.5)			
				Flash.Fire(X,Y,.15,8)
				PlaySoundBetter Sound_Player_ShotFizzle,X,Y
			ElseIf Fizzle And SuperShot
				ParticleManager.Create(X,Y,8,ShotRGB[0]+255,ShotRGB[1]-130,ShotRGB[2]-130,Direction+90,1.5)			
				Flash.Fire(X,Y,.15,8)
				PlaySoundBetter Sound_Player_ShotFizzle,X,Y
			End If
			List.Remove( Self )
		End If
	EndMethod
	
	Function GenerateShot:TPixmap() Private
		'The amount of White Pixels
		Local PixelCount:Int=0	
		'Stores the Spinners Pixels
		Local ShotPixels:Int[8,8]
		'Stores the Spinners Colors
		Local ShotColor[3]
		
		'-----------------MATH GEN ROUTINE-----------------
		
		'As long as there are less than 3 or more than 14 White pixels, redo Spinner
		Repeat
			PixelCount=0
			For Local i=0 To 2
				For Local j=0 To 6
						
					'A Pixel can be either 0 (Black) or 1 (White)
					ShotPixels[i,j]=Rand(0,1)
						
					'Count the number of White Pixels
					PixelCount:+ShotPixels[i,j]
						
				Next
				
				ShotColor[i]=Rand(55,150)
				
			Next	

		Until PixelCount>10 And PixelCount<20 
		
		
		'Mirror Shot along the Y axis
		For Local m=0 To 6
			ShotPixels[2,m]=ShotPixels[0,m]
		Next
		
		'Sometimes the shot is hollow or striped
		If PixelCount>15 And Rand(0,15)>13
			If Rand(0,15)>14
				ShotPixels[1,0]=0
				ShotPixels[1,1]=0
				ShotPixels[1,2]=0
				ShotPixels[1,3]=0
				ShotPixels[1,4]=0
				ShotPixels[1,5]=0
				ShotPixels[1,6]=0
			Else
				ShotPixels[1,0]=0
				ShotPixels[1,1]=1
				ShotPixels[1,2]=0
				ShotPixels[1,3]=1
				ShotPixels[1,4]=0
				ShotPixels[1,5]=1
				ShotPixels[1,6]=0
			End If
			
		End If
		
		RGB_to_HSL(ShotColor[0],ShotColor[1],ShotColor[2])
			
		If Result_S<.23 Result_S:+.25
			
		HSL_to_RGB(Result_H,Result_S,Result_L)
		
		ShotColor[0]=Result_R
		ShotColor[1]=Result_G
		ShotColor[2]=Result_B
		
		If EasterEgg Or SeedJumble(Seed)="LIAP@ELLI"
			ShotColor[0]=ShotColor[1]
			ShotColor[2]=ShotColor[1]
		End If
		
		'-----------------DRAWING ROUTINE-----------------

		Local ShotPixmap:TPixmap=CreatePixmap(7,11,PF_RGBA8888)
		Local GlowPixmap:TPixmap
		
		ClearPixels (ShotPixmap)
		
		'Loop through the Spinner's pixel array 
		For Local x=0 To 2
			For Local y=0 To 6
				
				'Proceed to draw the Shot
				If ShotPixels[x,y]=1
					
					WritePixel ShotPixmap,2+x,2+y,ToRGBA(ShotColor[0],ShotColor[1],ShotColor[2],255)
				
				End If
			
			Next
		Next

		'WritePixel ShotPixmap,2+1,2+1,ToRGBA(185,185,185,255)
		If Rand(0,4) < 1
			If ShotPixels[1,2] WritePixel ShotPixmap,2+1,2+2,ToRGBA(185,185,185,255)
			If ShotPixels[1,3] WritePixel ShotPixmap,2+1,2+3,ToRGBA(185,185,185,255)
			If ShotPixels[1,4] WritePixel ShotPixmap,2+1,2+4,ToRGBA(185,185,185,255)
			If ShotPixels[1,5] WritePixel ShotPixmap,2+1,2+5,ToRGBA(185,185,185,255)
		Else
			WritePixel ShotPixmap,2+1,2+2,ToRGBA(185,185,185,255)
			WritePixel ShotPixmap,2+1,2+3,ToRGBA(185,185,185,255)
			WritePixel ShotPixmap,2+1,2+4,ToRGBA(185,185,185,255)
			WritePixel ShotPixmap,2+1,2+5,ToRGBA(185,185,185,255)
		End If
		
		'WritePixel ShotPixmap,2+1,2+6,ToRGBA(0,0,0,255)

		For Local i=0 To 2
			ShotRGB[i]=ShotColor[i]
		Next
		
		GlowPixmap=CopyPixmap(ShotPixmap)
		
		ShotBody=LoadImage(ShotPixmap,MASKEDIMAGE)
				
		GlowPixmap=GaussianBlur(GlowPixmap,3,225,5,225)
		
		ShotGlow=LoadImage(GlowPixmap,FILTEREDIMAGE)
		
		ShotPixmap=Null;GlowPixmap=Null
		
	End Function
	
	Function PrepareFrame(image:TImage) Private
		'Use this to cache an image or animimage in VRAM for quicker drawing later.
		If image<>Null
			image.Frame(0)
			MidHandleImage Image
		End If
	End Function
	
	Function ToRGBA%(r%,g%,b%,a%) Private
		'return (a << 24) | (r << 16) | (g << 8) | (b);
	Return ((A Shl 24) | (R Shl 16) | (G Shl 8) | B)
	End Function
	
EndType	

'-----------------------------------------------------------------------------
'Highscore Type
'-----------------------------------------------------------------------------
Type THighscore

	Const SCORE_COUNT:Int = 10
	Const MARK:String=Chr(42)
	Field Scores:Int[SCORE_COUNT]
	Field Names:String[SCORE_COUNT]
	Field ScoreSeed:String[SCORE_COUNT]
	Field ScoreDifficulty:String[SCORE_COUNT]
	Field Tracking:String[SCORE_COUNT]
	Field PlayTime:Int[SCORE_COUNT]
	'Field RequestScores=False
	'Field NotOnline:Int
	Field MyScores:Int[15]
	Field HighLightID:Int
	Field TotalPlayTime:Int
	
	Method Render(x:Int, y:Int)
		
		'SetImageFont BoldFont
		SetRotation(0)
		
		Select GameMode
		
			Case VIEWSCORE
				
				DarkenScreen(.35)
				
				SetAlpha 1
				'SetScale 1.2,1.2 
				SetScale 2,2
				SetColor 230,230,230
				
				BoldFont.Draw ("TOP 10 PLAYERS",x,y-25,True)
				'BoldFont.Draw ("LOCAL TOP 10 PLAYERS",x,y,True)
				
				
				SetScale .75,.75
				'SetAlpha .75
				'SetColor 175,175,175
				Local CurrentSeed:String
				Local ToolTipDisplayed:Byte

				
				For Local Count:Int = 0 To SCORE_COUNT - 1
					Local FirstInstance:Int
					Local Secondinstance:Int
					Local TempInstance:Int

					If Len(Tracking[Count])>2
						FirstInstance=Instr(Right(Tracking[Count],13),"/",1)
						SecondInstance=Instr(Right(Tracking[Count],13),"/",FirstInstance+1)
					End If
					
					If HitBox(XMouse,YMouse,2,2,x-310,y+75+(Count*30),590,25)
						If ScoreSeed[Count]<>""
							ToolTip="Click to use Seed '"+ScoreSeed[Count]+"' ("+Mid(Right(Tracking[Count],13),FirstInstance+1,SecondInstance-(FirstInstance+1))+"%)"
							CurrentSeed=ScoreSeed[Count]
						Else
							ToolTip="Score has no Seed"
							CurrentSeed=""
						End If
						If CurrentSeed=Seed
							ToolTip="Already using '"+ScoreSeed[Count]+"' ("+Mid(Right(Tracking[Count],13),FirstInstance+1,SecondInstance-(FirstInstance+1))+"%)"
						End If
						SetAlpha 0.5
						ToolTipDisplayed=True
					Else
						SetAlpha 1
					End If
					
					SetColor 195,195,195

					'Print Self.Names[Count]+" - "+Self.Scores[Count]+" - "+Self.ScoreSeed[Count]
					If Left(Names[Count],1)=MARK
						BoldFont.Draw(Right(Self.Names[Count],Len(Names[Count])-1), x-210,y + 75 +(Count * 30),True)
					Else
						BoldFont.Draw(Self.Names[Count], x-210,y + 75 +(Count * 30),True)
					End If
					BoldFont.Draw(ScoreDotted(Self.Scores[Count]-OpenGLHash), x+210,y + 75 + (Count * 30),True)
					
					SetColor 125,125,125
					
					Local Minutes:Int
					Local Seconds:String
					If Int(PlayTime[Count])<>-1
						Minutes=Int(PlayTime[Count]/60)
						Seconds=String(PlayTime[Count] Mod 60)
						If Len(Seconds)=1 Then Seconds="0"+Seconds
						BoldFont.Draw(Minutes+"'"+Seconds, x+45,y+ 75+ (Count*30),True)
					Else
						BoldFont.Draw("--'--", x+45,y+75+ (Count*30),True)
					End If
				Next
				
				
				SetColor 125,125,125
				SetScale 1,1
				SetAlpha 1
				'BoldFont.Draw ("CLICK to switch between on- and offline scores.",x,y+410,True)
				BoldFont.Draw ("Hit ESC to return to the main menu!",x,y+470,True)
				'SetScale .5,.5
				'BoldFont.Draw ("Your best local score will be automatically sent.",x,y+460,True)
				'SetAlpha 1
				SetAlpha 1
				SetScale 1,1
				
				'Empty out the Tooltip if nothing is being displayed
				If Not ToolTipDisplayed ToolTip=""
				
				'If we click a seed and it's not already set - set it!
				If CurrentSeed<>"" And Seed<>CurrentSeed And MouseHit(1)
					PlaySoundBetter Sound_Menu_Click,FieldWidth/2,FieldHeight/2,False,False
					ToolTip=""
					Seed=CurrentSeed
					GetRandSeed(False,True)
					GameState=MENU
					Player.Alive=False
					Player.Dying=False
					
					'Start up the fixed rate logic
					FixedRateLogic.ResetFPS()
					FixedRateLogic.CalcMS()
					Score=WriteMask
					
					FPSTarget = FAST_FPS
					FPSCurrent = FAST_FPS
					FixedRateLogic.Init()
					FlushMouse()
					FlushKeys()
				End If
				
			Default
				'DarkenScreen(.35)
				
				SetAlpha GUIFadeIn
				SetScale 2,2
				SetColor 230,230,230
				
				
				BoldFont.Draw ("TOP 10 PLAYERS",x,y-75,True)
				
				SetScale .75,.75
				SetColor 195,195,195
				
				'Brightness=Sqr((PlayerColor[0]*PlayerColor[0]*0.241) + (PlayerColor[1]*PlayerColor[1]*0.691) + (PlayerColor[2]*PlayerColor[2]*0.068))

				
				For Local Count:Int = 0 To SCORE_COUNT - 1
					
					If Count=HighLightID
						RGB_to_HSL(Player.RGB[0],Player.RGB[1],Player.RGB[2])
			
						If Result_S<.45 Result_S:+.35
						Result_L=Result_L*1.2
						HSL_to_RGB(Result_H,Result_S,Result_L)
		
						SetColor Result_R,Result_G,Result_B
					End If
					If Left(Names[Count],1)=MARK
						DrawTextCentered(Right(Self.Names[Count],Len(Names[Count])-1), x-210,y + (Count * 30))
					Else
						DrawTextCentered(Self.Names[Count], x-210,y + (Count * 30))
					End If
					SetColor 195,195,195
				Next
		
				For Local Count2:Int = 0 To SCORE_COUNT - 1
					If Count2=HighLightID
						RGB_to_HSL(Player.RGB[0],Player.RGB[1],Player.RGB[2])
			
						If Result_S<.45 Result_S:+.35
						Result_L=Result_L*1.2
						HSL_to_RGB(Result_H,Result_S,Result_L)
		
						SetColor Result_R,Result_G,Result_B
					End If
					DrawTextCentered(ScoreDotted(Self.Scores[Count2]-OpenGLHash), x+210,y + (Count2 * 30))
					SetColor 195,195,195
				Next
				
				'SetAlpha 0.7
				SetColor 125,125,125
				For Local Count3:Int = 0 To SCORE_COUNT - 1
					Local Minutes:Int
					Local Seconds:String
					If Int(PlayTime[Count3])<>-1
						Minutes=Int(PlayTime[Count3]/60)
						Seconds=String(PlayTime[Count3] Mod 60)
						If Len(Seconds)=1 Then Seconds="0"+Seconds
						If Count3=HighLightID
							RGB_to_HSL(Player.RGB[0],Player.RGB[1],Player.RGB[2])
				
							If Result_S<.45 Result_S:+.35
							Result_L=Result_L*1.2
							HSL_to_RGB(Result_H,Result_S,Result_L)
			
							SetColor Result_R,Result_G,Result_B
						Else
							SetColor 125,125,125
						End If
						BoldFont.Draw(Minutes+"'"+Seconds, x+45,y+ (Count3*30),True)
					Else
						SetColor 125,125,125
						BoldFont.Draw("--'--", x+45,y+ (Count3*30),True)
					End If
				Next
				
				SetColor 255,255,255
				SetScale 1,1
				SetAlpha 1
				
		End Select
		

		
	End Method
	
	Method IsHighScore:Int(Score:Int)
		For Local Count:Int = 0 To SCORE_COUNT - 1
			If Score > Self.Scores[Count] Then
				'Print Score + " is a highScore"
				
				'Allow for quick submission online
				'OnlineScore.TimeStamp=0
				Return True
			EndIf
		Next
		Return False
	End Method
	
	Method Add(Score:Int,PlayerName:String,Seed:String,PlayTime:Int,Tracking:String)
		' Find out where we should put the score..
		Local PlaceAt:Int = SCORE_COUNT - 1
		For Local Count:Int = SCORE_COUNT - 1 To 0 Step -1
			If Score > Self.Scores[Count] Then
				PlaceAt = Count
			EndIf
		Next
		HighLightID=PlaceAt
		' Shuffle them all down..
		For Local Shuffle:Int = SCORE_COUNT - 2 To PlaceAt Step -1
			Self.Scores[Shuffle + 1] = Self.Scores[Shuffle]
			Self.Names[Shuffle + 1] = Self.Names[Shuffle]
			Self.ScoreSeed[Shuffle + 1] = Self.ScoreSeed[Shuffle]
			Self.PlayTime[Shuffle + 1] = Self.PlayTime[Shuffle]
			Self.Tracking[Shuffle + 1] = Self.Tracking[Shuffle]
		Next

		'Print Self.Scores[1]
		Self.Scores[PlaceAt] = Score:Int
		Self.Names[PlaceAt] = PlayerName
		Self.ScoreSeed[PlaceAt] = Seed
		Self.PlayTime[PlaceAt]=PlayTime
		Self.Tracking[PlaceAt]=Tracking
		
	End Method


	Method Save(File:String)
		Local TempName:String, TempScore:String, TempCRC:String="B4SMIBDSIWGHISYGdHIUYSHFIDdgth3l" '32 Bytes of "Temporary Garbage" to pad CRC Hash
		Local TempSeed:String, TempTime:String, TempTrack:String
		Local Out:TStream = OpenStream(File,False,True)
		If Out <> Null
			
			WriteString(Out,RC4("HIGHSCORE HEADER",SeedJumble(LocalKey$,False)))
			
			For Local Count:Int = 0 To SCORE_COUNT - 1
				
				
				TempName=RC4(Self.Names[Count],SeedJumble(LocalKey$,False))
				TempScore=RC4(Self.Scores[Count]-OpenGLHash,SeedJumble(LocalKey$,False))
				TempSeed=RC4(Self.ScoreSeed[Count],SeedJumble(LocalKey$,False))
				TempTime=RC4(Self.PlayTime[Count],SeedJumble(LocalKey$,False))
				TempTrack=RC4(Self.Tracking[Count],SeedJumble(LocalKey$,False))
				
				WriteInt(Out,Len(TempScore))
				WriteInt(Out,Len(TempName))
				WriteInt(Out,Len(TempSeed))
				WriteInt(Out,Len(TempTime))
				WriteInt(Out,Len(TempTrack))
				WriteString(Out,TempScore)
				WriteString(Out,TempName)
				WriteString(Out,TempSeed)
				WriteString(out,TempTime)
				WriteString(out,TempTrack)
				
			Next
			
			TempCRC=RC4(TempCRC,SeedJumble(LocalKey$,False))
			WriteString(Out,TempCRC)
			
			CloseStream(Out)

			TempCRC=CRC(File)

			While Len(TempCRC)<32
				TempCRC:+Chr(Rand(65,90))
			Wend
			
			Local Out2:TStream = OpenStream(File,False,True)
			
			If Out2 <> Null
			
				WriteString(Out2,RC4("HIGHSCORE HEADER",SeedJumble(LocalKey$,False)))

				For Local Count:Int = 0 To SCORE_COUNT - 1
					
					TempName=RC4(Self.Names[Count],SeedJumble(LocalKey$,False))
					TempScore=RC4(Self.Scores[Count]-OpenGLHash,SeedJumble(LocalKey$,False))
					TempSeed=RC4(Self.ScoreSeed[Count],SeedJumble(LocalKey$,False))
					TempTime=RC4(Self.PlayTime[Count],SeedJumble(LocalKey$,False))
					TempTrack=RC4(Self.Tracking[Count],SeedJumble(LocalKey$,False))
					
					WriteInt(Out2,Len(TempScore))
					WriteInt(Out2,Len(TempName))
					WriteInt(Out2,Len(TempSeed))
					WriteInt(Out2,Len(TempTime))
					WriteInt(Out2,Len(TempTrack))
					WriteString(Out2,TempScore)
					WriteString(Out2,TempName)
					WriteString(Out2,TempSeed)
					WriteString(Out2,TempTime)
					WriteString(Out2,TempTrack)
					'Print Self.Scores[Count] + " " + Self.Names[Count]
				Next
				
				TempCRC=RC4(TempCRC,SeedJumble(LocalKey$,False))
				
				WriteString(Out2,TempCRC)
				
				CloseStream(Out2)
				
				'TempCRC=CRC(File)
			
			EndIf
		EndIf
	End Method
	
	Function Load:THighscore(File:String)
		Local in:TStream = OpenStream(File,True,False)
		Local Out:THighscore = New THighscore
		If in = Null
			' Fill it full of high scores..
			Out.Names[0] = MARK+"T. NISHIKADO"
			Out.Names[1] = MARK+"J. CARMACK"
			Out.Names[2] = MARK+"C. HUELSBECK"
			Out.Names[3] = MARK+"N. BUSHNELL"
			Out.Names[4] = MARK+"T. IWATANI"
			Out.Names[5] = MARK+"A. ALCORN"
			Out.Names[6] = MARK+"S. RUSSELL"
			Out.Names[7] = MARK+"E. JARVIS"
			Out.Names[8] = MARK+"S. MYAMOTO"
			Out.Names[9] = MARK+"S. WOZNIAK"

			Out.Scores[0] = Int(SeedJumble(";8333"))+OpenGLHash
			Out.Scores[1] = Int(SeedJumble(":3333"))+OpenGLHash
			Out.Scores[2] = Int(SeedJumble("93333"))+OpenGLHash
			Out.Scores[3] = Int(SeedJumble("83333"))+OpenGLHash
			Out.Scores[4] = Int(SeedJumble("73333"))+OpenGLHash
			Out.Scores[5] = Int(SeedJumble("63333"))+OpenGLHash
			Out.Scores[6] = Int(SeedJumble("53333"))+OpenGLHash
			Out.Scores[7] = Int(SeedJumble("43333"))+OpenGLHash
			Out.Scores[8] = Int(SeedJumble("<333"))+OpenGLHash
			Out.Scores[9] = Int(SeedJumble(";833"))+OpenGLHash
			
			For Local i=0 To 9
				Out.PlayTime[i] = -1
				Out.ScoreSeed[i]=""
				Out.Tracking[i]="--"
			Next
			
			BestScore=Int(SeedJumble(";8333"))+OpenGLHash

		Else
				Local TempName:String, TempScore:String,ReadCRC:String, CheckCRC:Int, LoadCRC:Int
				Local TempNLen:String,TempSLen:String
				Local TempSeed:String, TempSeedLen:String, TempPlayTime:String, TempPlayTimeLen:String
				Local TempTrackingLen:String,TempTracking:String
				Try
				
				If RC4(ReadString(in,16),SeedJumble(LocalKey$,False))<>"HIGHSCORE HEADER" Throw "ERROR"
				
				For Local Count:Int = 0 To SCORE_COUNT - 1
					
					
					'Print "1. Okay: "+Count
					
					TempSLen=ReadInt(in)
					TempNLen=ReadInt(in)
					TempSeedLen=ReadInt(in)
					TempPlayTimeLen=ReadInt(in)
					TempTrackingLen=ReadInt(in)
					
					'Print "2. Okay: "+Count
					
					TempScore = ReadString(in,Int(TempSLen))
				 	TempName = ReadString(in,Int(TempNLen))
				 	TempSeed = ReadString(in,Int(TempSeedLen))
					TempPlayTime = ReadString(in,Int(TempPlayTimeLen))
					TempTracking = ReadString(in,Int(TempTrackingLen))
						
					'Print "3. Okay: "+Count
								
					'Decrypt Scores
					TempScore = RC4(TempScore,SeedJumble(LocalKey$,False))
					TempName = RC4(TempName,SeedJumble(LocalKey$,False))
					TempSeed = RC4(TempSeed,SeedJumble(LocalKey$,False))
					TempPlayTime = RC4(TempPlayTime,SeedJumble(LocalKey$,False))
					TempTracking = RC4(TempTracking,SeedJumble(LocalKey$,False))
					'TypeCast				
					Out.Scores[Count]=Int(TempScore)+OpenGLHash
					Out.Names[Count]=TempName
					Out.ScoreSeed[Count]=TempSeed
					Out.PlayTime[Count]=Int(TempPlayTime)
					Out.Tracking[Count]=TempTracking
					'Print Tempname+"-"+TempTracking
					'If Out.playtime[Count]<>0 Print Out.PlayTime[Count]
					If Count=0 Then BestScore=Int(TempScore)+OpenGLHash
					
					If Eof(in) Throw "ERROR"
					
				Next
				
				ReadCRC=ReadString(in,32)
							
				CloseStream(in)
				
				'The file ended prematurely, well that sucks!
				Catch ERROR:Object
					CloseStream(in)

					?MacOS
					DeleteFile(File)
					?
					?Win32
					Local MaxLoop:Int
					While Not DeleteFile(File)
						MaxLoop:+1
						Delay(100)
						If MaxLoop>=150 Exit
					Wend
					?
					If Not FullScreen
						Notify("Problem reading HighScore file -- Scores Reset!")
					End If
					' Fill it full of high scores..
					Out.Names[0] = MARK+"T. NISHIKADO"
					Out.Names[1] = MARK+"J. CARMACK"
					Out.Names[2] = MARK+"C. HUELSBECK"
					Out.Names[3] = MARK+"N. BUSHNELL"
					Out.Names[4] = MARK+"T. IWATANI"
					Out.Names[5] = MARK+"A. ALCORN"
					Out.Names[6] = MARK+"S. RUSSELL"
					Out.Names[7] = MARK+"E. JARVIS"
					Out.Names[8] = MARK+"S. MYAMOTO"
					Out.Names[9] = MARK+"S. WOZNIAK"
		
					Out.Scores[0] = Int(SeedJumble(";8333"))+OpenGLHash
					Out.Scores[1] = Int(SeedJumble(":3333"))+OpenGLHash
					Out.Scores[2] = Int(SeedJumble("93333"))+OpenGLHash
					Out.Scores[3] = Int(SeedJumble("83333"))+OpenGLHash
					Out.Scores[4] = Int(SeedJumble("73333"))+OpenGLHash
					Out.Scores[5] = Int(SeedJumble("63333"))+OpenGLHash
					Out.Scores[6] = Int(SeedJumble("53333"))+OpenGLHash
					Out.Scores[7] = Int(SeedJumble("43333"))+OpenGLHash
					Out.Scores[8] = Int(SeedJumble("<333"))+OpenGLHash
					Out.Scores[9] = Int(SeedJumble(";833"))+OpenGLHash
					
					For Local i=0 To 9
						Out.PlayTime[i] = -1
						Out.ScoreSeed[i]=""
						Out.Tracking[i]="--"
					Next
					
					BestScore=Int(SeedJumble(";8333"))+OpenGLHash
				End Try
				
				CheckCRC=Int(RC4(ReadCRC,SeedJumble(LocalKey$,False)))
				
				LoadCRC=CRC(File)
				
				If CheckCRC<>LoadCRC Then
					CloseStream(in)

					?MacOS
					DeleteFile(File)
					?
					
					'Print LoadCRC
					'Print CheckCRC
					
					?Win32
					Local MaxLoop:Int
					While Not DeleteFile(File)
						MaxLoop:+1
						Delay(110)
						If MaxLoop>=150 Exit
					Wend
					?
					If Not FullScreen
						Notify("Highscore file checksum failed -- Scores Reset!")
					End If
					
					' Fill it full of high scores..
					Out.Names[0] = MARK+"T. NISHIKADO"
					Out.Names[1] = MARK+"J. CARMACK"
					Out.Names[2] = MARK+"C. HUELSBECK"
					Out.Names[3] = MARK+"N. BUSHNELL"
					Out.Names[4] = MARK+"T. IWATANI"
					Out.Names[5] = MARK+"A. ALCORN"
					Out.Names[6] = MARK+"S. RUSSELL"
					Out.Names[7] = MARK+"E. JARVIS"
					Out.Names[8] = MARK+"S. MYAMOTO"
					Out.Names[9] = MARK+"S. WOZNIAK"
		
					Out.Scores[0] = Int(SeedJumble(";8333"))+OpenGLHash
					Out.Scores[1] = Int(SeedJumble(":3333"))+OpenGLHash
					Out.Scores[2] = Int(SeedJumble("93333"))+OpenGLHash
					Out.Scores[3] = Int(SeedJumble("83333"))+OpenGLHash
					Out.Scores[4] = Int(SeedJumble("73333"))+OpenGLHash
					Out.Scores[5] = Int(SeedJumble("63333"))+OpenGLHash
					Out.Scores[6] = Int(SeedJumble("53333"))+OpenGLHash
					Out.Scores[7] = Int(SeedJumble("43333"))+OpenGLHash
					Out.Scores[8] = Int(SeedJumble("<333"))+OpenGLHash
					Out.Scores[9] = Int(SeedJumble(";833"))+OpenGLHash
					
					For Local i=0 To 9
						Out.PlayTime[i] = -1
						Out.ScoreSeed[i]=""
						Out.Tracking[i]="--"
					Next
					
					BestScore=Int(SeedJumble(";8333"))+OpenGLHash
					
				End If
					
			EndIf
			
		Return Out
		
	End Function	
	
End Type

Rem
'-------------------------------------------------------------------------------------
'The reacher can either simulate a length of rope or a tentacle reaching for things
'Set Gravity to zero for cool spline-ey swirly effects
'-------------------------------------------------------------------------------------
Type TReacher
	Global List:TList
	Global image:TImage
	
	Const Gravity:Float = -0.025
	Const MaxBrightness:Int=105
	
	Field numSegments:Int
	Field x:Float[]
	Field y:Float[]
	Field angle:Float[]
	Field LitSegment:Float
	Field FadeColor:Int[]
	Field segLength:Float
	Field targetX:Float, targetY:Float
	
	Function Init()
		If Not Image Then
		
			Image= LoadImage(GetBundleResource("Graphics/particle.png"),FILTEREDIMAGE)
			MidHandleImage Image
		
		End If
	End Function
	
	Function Spawn( setNumSegments:Int, setSeglength#, xpos#, ypos# )
		
		If Not List Then List = CreateList()
		
		Local Reacher:TReacher = New TReacher
		List.AddLast Reacher
		
		Reacher.numSegments = setNumSegments
		Reacher.X = New Float[Reacher.numSegments]
		Reacher.Y = New Float[Reacher.numSegments]
		Reacher.Angle = New Float[Reacher.numSegments]
		Reacher.FadeColor = New Int[Reacher.numSegments]
		Reacher.LitSegment=Reacher.X.Length-1
		Reacher.segLength = setSeglength
		
		Reacher.X[Reacher.X.length-1] = xpos
		Reacher.Y[Reacher.X.length-1] = ypos
		
	End Function
	
	Method setTarget( tx:Float, ty:Float )
		targetX = tx
		targetY = ty
	End Method
	
	Method Draw(IsBackBuffer:Int)
		
		If IsBackBuffer
			For Local i:Int=0 Until x.length 
				drawSegmentBackBuffer( x[i], y[i], angle[i], (i+1)*2 )
			Next
		Else
			If GlLines
				For Local i:Int=0 Until x.length
					If i-1<=Int(LitSegment) And i+1>Int(LitSegment)
						drawSegment( x[i], y[i], angle[i], (i+1)*2,MaxBrightness )
						FadeColor[i]=MaxBrightness
					Else
						drawSegment( x[i], y[i], angle[i], (i+1)*2,FadeColor[i])
					End If
				Next
			Else
				For Local i:Int=0 Until x.length 
					If i-1<=Int(LitSegment) And i+1>Int(LitSegment)
						drawSegmentBasic( x[i], y[i], angle[i], (i+1)*2,MaxBrightness )
						FadeColor[i]=MaxBrightness
					Else
						drawSegmentBasic( x[i], y[i], angle[i], (i+1)*2,FadeColor[i])
					End If
				Next
				SetOrigin 0,0
				SetRotation 0
			End If
		End If		
	End Method
	
	Method Update()
		
		
		For Local i:Int=0 Until numSegments
			reachSegment(i, targetX, targetY+gravity )
			If FadeColor[i]>0 FadeColor[i]:-2*Delta
			'reachSegment(i, Player.X,Player.Y+Gravity)
		Next
		
		For Local i:Int=x.length-1 Until 0 Step -1
			positionSegment(i, i-1 )
		Next
		
		LitSegment:-.25*Delta
		
		If LitSegment<-1 LitSegment=numSegments+1
		
	End Method
	
	Function UpdateAll()
		If Not List Return 
		
		For Local Reacher:TReacher = EachIn List
			Reacher.SetTarget(Player.X,Player.Y)
			Reacher.Update()
		Next
	EndFunction
	
	Function DrawAll(BackBuffer:Int=False)
		If Not List Return 

		If BackBuffer
			SetBlend LIGHTBLEND
			SetAlpha .35
			SetColor Player.RGB[0]*1.5,Player.RGB[1]*1.5,Player.RGB[2]*1.5 
			
			If GlowQuality>256
				SetScale 3.5,3.5
			ElseIf GlowQuality=256
				SetScale 3,3
			ElseIf GlowQuality=128
				SetScale 2.5,2.5
			ElseIf GlowQuality=64
				SetScale 2,2
			End If
			
			For Local Reacher:TReacher = EachIn List
				Reacher.Draw(True)
			Next
			
			SetScale 1,1
			SetAlpha 1
			SetColor 255,255,255
			SetBlend ALPHABLEND
		Else
			SetLineWidth 4
			SetColor 0,0,0
			SetAlpha 1
			If GlLines glDisable GL_TEXTURE_2D; glBegin GL_LINES
			For Local Reacher:TReacher = EachIn List
				Reacher.Draw(False)
			Next
			SetColor 255,255,255
			If GlLines glEnd; glEnable GL_TEXTURE_2D
		End If
					
		
	End Function
	
	Method positionSegment( a:Int, b:Int )
	
		x[b] = x[a] + Cos(angle[a]) * segLength
		y[b] = y[a] + Sin(angle[a]) * segLength
		
	End Method
	
	Method reachSegment( i:Int, xin:Float, yin:Float)
	
		Local dx:Float = xin - x[i]
		Local dy:Float = yin - y[i]
		angle[i] = ATan2(dy, dx)
		targetX =( xin - Cos(angle[i]) * segLength )
		targetY =( yin - Sin(angle[i]) * segLength )
		
	End Method
	
	Method drawSegment( x:Float, y:Float, angle:Float, sw:Float, Brightness:Int )
		
		SetColor Brightness,Brightness,Brightness
		DrawLineGL 0, 0, segLength, 0,x,y,angle
		SetColor 0,0,0
		
	End Method
	
	Method drawSegmentBasic( x:Float, y:Float, angle:Float, sw:Float, Brightness:Int )
		
		SetColor Brightness,Brightness,Brightness
		SetOrigin x, y
		SetRotation angle
		DrawLine 0, 0, segLength, 0
		SetColor 0,0,0
		
	End Method
	
	Method drawSegmentBackBuffer( x:Float, y:Float, angle:Float, sw:Float )
		
		DrawImage Image,X,Y
	
	End Method
	
	Function DrawLineGL( x0#,y0#,x1#,y1#,tx#,ty#,rot# )
		
		Local s:Float=Sin(rot)
		Local c:Float=Cos(rot)
		Local ix:Float= c
		Local iy:Float=-s
		Local jx:Float= s
		Local jy:Float= c
		
		glVertex2f x0*ix+y0*iy+tx+.5,x0*jx+y0*jy+ty+.5
		glVertex2f x1*ix+y1*iy+tx+.5,x1*jx+y1*jy+ty+.5
	End Function
	
	Method Destroy()
		
		List.Remove (Self)
	
	End Method
	
End Type
End Rem

'-------------------------------------------------------------------------------------
' The ScoreServer type handles Online Score Submission and Tracking
'-------------------------------------------------------------------------------------
Type TScoreServer
	
	Global Connected:Byte
	Global Connecting:Byte
	Global NotifyUser:Byte
	Global Monthly:Byte
	Global InGame:Byte
	
	Global ScoreAmount:Int
	
	Global OnlineScoreCount:Int
	Global OnlineRank:Int
	
	Global TopNames:String[25]
	Global TopScores:Int[25]
	Global TopUIDs:String[25]
	Global TopRank:Int[25]
	Global IsTopTwenty:Byte
	
	Global RankNames:String[25]
	Global RankScores:Int[25]
	Global RankUIDs:String[25]
	Global RankRank:Int[25]
	Global RankSeed:String[25]
	Global RankTime:Int[25]
	Global RankDifficulty:String[25]
	
	Global ServerMonth:Int
	
	Global AlphaFade:Float=1
	Global AlphaDir:Int=1
	'Global 
	
	Method Update()
		
		'If we shouldn't connect return to the function
		If ConnectScoreServer=False Or GameState<>HISCORE Return
		
		If GameMode=VIEWONLINE
			
			Connected=False
			Connecting=True
			
			'Dont Access until we have notified the user
			If NotifyUser=False Return
			If Not Monthly
				GetTopScores()
			Else
				GetMonthlyScores()
			End If
		ElseIf GameMode=VIEWRANK
			
			Connected=False
			Connecting=True
			HighScore = Highscore.Load(HighScoreFile)
			'Dont Access until we have notified the user
			If NotifyUser=False Return
			'Print HighScore.Tracking[0]
			RankScore(HighScore.Scores[0]-OpenGLHash,HighScore.Names[0],UniqueID,HighScore.ScoreSeed[0],HighScore.PlayTime[0],HighScore.Tracking[0])
		
		End If
		
	
	End Method
	
	Method Render(x:Int,y:Int,Rank:Byte=True)
		Local ToolTipDisplayed:Byte=False
		Local CurrentSeed:String
		
		If GameState<>HISCORE Return

		DarkenScreen(.55)
		
		If Connecting=False And Connected=False And ConnectScoreServer=False
		
			SetScale 1,1
			DoubleBoldFont.Draw ("NOT CONNECTED"),ScreenWidth/2,ScreenHeight/2-70,True
			SetAlpha .6
			SetScale .75,.75
			BoldFont.Draw ("Invaders: Corruption can't connect to the score-server."),ScreenWidth/2,ScreenHeight/2+10,True
			BoldFont.Draw ("Please verify that you are online & not firewalling this game."),ScreenWidth/2,ScreenHeight/2+35,True
			
			SetScale 1,1
			SetAlpha .55
			If Not InGame
				BoldFont.Draw ("Hit ESC to return to the Menu!",x,y+500,True)
			Else
				BoldFont.Draw ("Hit "+KeyNames[InputKey[FIRE_BOMB]]+" for another game, or ESC For Menu!",x,y+500,True)
				InGame=2
				GetResumeInput()
			End If
			SetAlpha 1
			NotifyUser=True
			
		ElseIf Left(HighScore.Names[0],1)=HighScore.MARK And GameMode=VIEWRANK
	
			SetScale 1,1
			DoubleBoldFont.Draw ("CAN'T SUBMIT YET"),ScreenWidth/2,ScreenHeight/2-70,True
			SetAlpha .6
			SetScale .75,.75
			BoldFont.Draw ("Play the game for a while - score over 85.000 points first."),ScreenWidth/2,ScreenHeight/2+10,True
			BoldFont.Draw ("Best of Luck!"),ScreenWidth/2,ScreenHeight/2+35,True
			
			SetScale 1,1
			SetAlpha .55
			If Not InGame
				BoldFont.Draw ("Hit ESC to return to the Menu!",x,y+500,True)
			Else
				If InputMethod<3
					BoldFont.Draw "Hit "+KeyNames[InputKey[FIRE_BOMB]]+" to retry, or ESC For Menu!",x,y+500
				Else
					BoldFont.Draw "Hit Bomb Button to retry, or ESC For Menu!",x,y+500
				End If
				'BoldFont.Draw ("Hit "+KeyNames[InputKey[FIRE_BOMB]]+" for another game, or ESC For Menu!",x,y+500,True)
				InGame=2
				GetResumeInput()
			End If
			SetAlpha 1
			NotifyUser=True
			
		ElseIf Connecting=True And Connected=False
		
			SetScale 1,1
			If AlphaDir=1
				If AlphaFade<1
					AlphaFade:+0.02*Delta
					SetAlpha 0.45
				Else AlphaDir=2
				End If
			ElseIf AlphaDir=2
				If AlphaFade=>0.35
					AlphaFade:-0.02*Delta
					SetAlpha 1
				Else AlphaDir=1
				End If
			End If
			
			DoubleBoldFont.Draw ("CONNECTING"),ScreenWidth/2,ScreenHeight/2-70,True
			SetAlpha .6
			SetScale .75,.75
			BoldFont.Draw ("Exchanging HI-SCORES with the server, please be patient."),ScreenWidth/2,ScreenHeight/2+10,True
		
			SetScale 1,1
			SetAlpha 1
			NotifyUser=True
			
		ElseIf Connecting=False And ConnectScoreServer=False And Connected=True
		
			SetAlpha(0.97)
			SetScale(1.25,1.25)
			
			If Rank
				If OnlineRank>OnlineScoreCount OnlineScoreCount=OnlineRank
				BoldFont.Draw ("YOUR SCORE RANKING: "+OnlineRank+"/"+OnlineScoreCount,x,y,True)
			Else
				If Not Monthly
					If ScoreAmount>0
						BoldFont.Draw ("WORLDWIDE TOP 20 PLAYERS",x,y,True)
					Else
						BoldFont.Draw ("NO HI-SCORES TO DISPLAY - YET!",x,ScreenHeight/2,True,False,True,True,True)
					End If
				Else
					If ScoreAmount>1
						If ScoreAmount>20 Then ScoreAmount=20
						BoldFont.Draw (ReturnMonth(ServerMonth)+"'S TOP "+ScoreAmount+" PLAYERS",x,y,True)
					ElseIf ScoreAmount=1
						BoldFont.Draw (ReturnMonth(ServerMonth)+"'S TOP PLAYER",x,y,True)
					ElseIf ScoreAmount=0
						BoldFont.Draw (ReturnMonth(ServerMonth)+" HAS NO SCORES YET!",x,ScreenHeight/2-15,True,False,True,True,True)
					End If
				End If
			End If
			
			SetScale(.6,.6)
			SetAlpha .8
			ToolTipDisplayed=False
		
			If Rank
				Local DontDisplay=False
				For Local Count:Int = 1 To 20
					
					If Int(RankTime[Count])=0 And RankSeed[Count]="" And RankNames[Count]="" Continue
					
					If RankUIDs[Count]=UniqueID
						SetColor 125,0,0
						'SetColor Player.RGB[0]*1.3,Player.RGB[1]*1.3,Player.RGB[2]*1.3
					Else
						SetColor 125,125,125
					End If
					
					If Not IsTopTwenty And Count=4
						DontDisplay=True
					Else
						DontDisplay=False
					End If

					If HitBox(XMouse,YMouse,4,4,x-190,y+50+(Count*25),335,20) And DontDisplay=False'And InGame<=0
						If RankSeed[Count]<>""
							ToolTip="Click to Set Seed '"+RankSeed[Count]+"' ("+RankDifficulty[Count]+"%)"
							CurrentSeed=RankSeed[Count]
						Else
							ToolTip="Score has no Seed"
							CurrentSeed=""
						End If
						If CurrentSeed=Seed
							ToolTip="Already using '"+RankSeed[Count]+"' ("+RankDifficulty[Count]+"%)"
						End If
						SetAlpha 0.5
						ToolTipDisplayed=True
					Else
						SetAlpha 1
					End If
					
					If Not IsTopTwenty And Count=4
						
						'Count:+1
						SetColor 150,150,150
						SetScale 1,1
						DrawLine (x-270,y+30+(count+1)*25,x+270,y+30+(count+1)*25)
						SetScale .6,.6
						SetColor 125,125,125
						Continue

					End If
					
					If Int(RankTime[Count])<>-1
						Local Minutes:Int=Int(RankTime[Count]/60)
						Local Seconds:String=String(RankTime[Count] Mod 60)
						If Len(Seconds)=1 Then Seconds="0"+Seconds
						BoldFont.Draw(Minutes+"'"+Seconds, x+10,y+ 50+ (Count*25),True)
					Else
						BoldFont.Draw("--'--", x+10,y+50+ (Count*25),True)
					End If
					
					If RankUIDs[Count]=UniqueID
						SetColor 255,0,0
						'SetColor Player.RGB[0]*1.3,Player.RGB[1]*1.3,Player.RGB[2]*1.3
					Else
						SetColor 255,255,255
					End If
					
					If RankNames[Count]="" RankNames[Count]="ANONYMOUS PLAYER"
					BoldFont.Draw(RankRank[Count]+". "+RankNames[Count], x-175,y + 50 +(Count * 25),True)
					BoldFont.Draw(ScoreDotted(RankScores[Count]), x+175,y + 50 + (Count * 25),True)
				Next
			Else
				For Local Count:Int = 1 To 20
					
					If Int(RankTime[Count])=0 And RankSeed[Count]="" And TopNames[Count]="" Continue
					
					If TopUIDs[Count]=UniqueID
						SetColor 125,0,0
						'SetColor Player.RGB[0]*1.3,Player.RGB[1]*1.3,Player.RGB[2]*1.3
					Else
						SetColor 125,125,125
					End If
					
					If HitBox(XMouse,YMouse,4,4,x-190,y+50+(Count*25),335,20)
						If RankSeed[Count]<>""
							ToolTip="Click to Set Seed '"+RankSeed[Count]+"' ("+RankDifficulty[Count]+"%)"
							CurrentSeed=RankSeed[Count]
						Else
							ToolTip="Score has no Seed"
							CurrentSeed=""
						End If
						If CurrentSeed=Seed
							ToolTip="Already using '"+RankSeed[Count]+"' ("+RankDifficulty[Count]+"%)"
						End If
						SetAlpha 0.5
						ToolTipDisplayed=True
					Else
						SetAlpha 1
					End If
					
					If Int(RankTime[Count])<>-1
						Local Minutes:Int=Int(RankTime[Count]/60)
						Local Seconds:String=String(RankTime[Count] Mod 60)
						If Len(Seconds)=1 Then Seconds="0"+Seconds
						BoldFont.Draw(Minutes+"'"+Seconds, x+10,y+ 50+ (Count*25),True)
					Else
						BoldFont.Draw("--'--", x+10,y+50+ (Count*25),True)
					End If
					
					If TopUIDs[Count]=UniqueID
						SetColor 255,0,0
						'SetColor Player.RGB[0]*1.3,Player.RGB[1]*1.3,Player.RGB[2]*1.3
					Else
						SetColor 255,255,255
					End If
					
					If TopNames[Count]="" TopNames[Count]="UNNAMED PLAYER"
					BoldFont.Draw(String(Count)+". "+TopNames[Count], x-175,y + 50 +(Count * 25),True)
					BoldFont.Draw(ScoreDotted(TopScores[Count]), x+175,y + 50 + (Count * 25),True)

				Next
			End If
			
			SetColor 255,255,255
			SetScale .75,.75
			SetAlpha 0.55
			If Not InGame
				BoldFont.Draw ("Hit ESC to return to the Menu!",x,y+620,True)
			Else
				BoldFont.Draw ("Hit "+KeyNames[InputKey[FIRE_BOMB]]+" for another game, or ESC For Menu!",x,y+620,True)
				InGame=2
				GetResumeInput()
			End If
			SetScale 1,1
			SetAlpha 1
			
			'Empty out the Tooltip if nothing is being displayed
			If Not ToolTipDisplayed ToolTip=""
			
			'If we click a seed and it's not already set - set it!
			If CurrentSeed<>"" And Seed<>CurrentSeed And MouseHit(1)
				PlaySoundBetter Sound_Menu_Click,FieldWidth/2,FieldHeight/2,False,False
				ToolTip=""
				Seed=CurrentSeed
				GetRandSeed(False,True)
				GameState=MENU
				Player.Alive=False
				Player.Dying=False
				
				'Start up the fixed rate logic
				FixedRateLogic.ResetFPS()
				FixedRateLogic.CalcMS()
				Score=WriteMask
				
				FPSTarget = FAST_FPS
				FPSCurrent = FAST_FPS
				FixedRateLogic.Init()
				FlushMouse()
				FlushKeys()
			End If
			
		End If
	End Method
	
	Method RankScore(Score:Int,Name:String,UID:String,ScoreSeed:String,PlayTime:Int,TrackingVar:String)

		Local i:Int=0
		Local Success:Byte
		
		'Dont bother submitting preset scores
		If Left(HighScore.Names[0],1)=HighScore.MARK Return
		
		'Check the Name & Other strings, just to make sure that there are no sheannigans involved
		Name=SanitizeInput(Name,21)
		ScoreSeed=SanitizeInput(ScoreSeed,25)
		UID=SanitizeInput(UID,33,True)
		
		'Encrypt Score & Name
		TempName=RC4(Name,SeedJumble(EncKey$,False))
		TempScore=RC4(Score,SeedJumble(EncKey$,False))
		TempSeed=RC4(ScoreSeed,SeedJumble(EncKey$,False))
		TempPlayTime=RC4(PlayTime,SeedJumble(EncKey$,False))
		TempTrack=RC4(TrackingVar,SeedJumble(EncKey$,False))
		
		'Apply CRC and get ready for PHP transfer
		TempName=AscList(TempName)
		TempScore=AscList(TempScore)
		TempSeed=AscList(TempSeed)
		TempPlayTime=AscList(TempPlayTime)
		TempTrack=AscList(TempTrack)
		
		
		'Kill previously saved scores
		OnlineScore.Unload()
		ScoreAmount=0
		
		'Get the TOP20
		'Success=OnLineScore.GetScores(0,21)
		
		
		
		If ConnectScoreServer And Thread = Null
			AbortThread=False
			Thread:TThread = CreateThread (ServerThread, "3")
			'CloseMutex ScoreMutex
			'ConnectScoreServer=False
		End If
		

		
		If Not Thread= Null

			While ThreadRunning (Thread)
				ThreadLoop()
			Wend
			ReturnFromThread=True
			Success = Int(WaitThread(Thread).toString())
			
			ConnectScoreServer=False
			'End If
			Thread = Null
			
			If Not Success
				Connected=False
				Connecting=False
				Return
			End If
			
			Connected=True
			Connecting=False
		End If

		
		Rem
		OnlineRank = OnlineScore.RankScore(TempScore)
		
		If Not OnlineScore.SetScore(TempName,TempScore,UniqueID,TempSeed,TempPlayTime,TempTrack)
			'Need to debug the "ONLINESCORE" module to fix up returns
			'TO cause a proper - Can't connect action here
		End If
		
		OnlineScoreCount = OnlineScore.CountScores()
		
		ConnectScoreServer=False
		
		If OnlineRank=-1 Then
			Connected=False
			Connecting=False
			Return
		End If
		
		'Kill previously saved scores
		OnlineScore.Unload()
		
		'Top 20
		If OnlineRank<21
			'Get the TOP20
			OnLineScore.GetScores(0,20)
			
			If Not OnlineScore.Scores.List Return
			
			IsTopTwenty=True
			For Local Score:TScores = EachIn OnlineScore.Scores.List
				i:+1
				RankNames[i]=Score.User_Name
				RankScores[i]=Score.User_Score
				RankUIDs[i]=Score.Score_ID
				RankSeed[i]=Score.ScoreSeed
				RankTime[i]=Score.ScoreTime
				RankRank[i]=i	
			Next
		
		'Rock bottom
		ElseIf OnlineRank>OnlineScoreCount-21
			'Print "rock bottom"
			OnLineScore.GetScores(0,3)
			OnLineScore.GetScores(OnlineRank-16,17)
			
			If Not OnlineScore.Scores.List Return
			
			IsTopTwenty=False
			For Local Score:TScores = EachIn OnlineScore.Scores.List
				i:+1
				If i<4
					RankRank[i]=i
				Else
					RankRank[i]=OnlineRank-19+i
				End If
				RankNames[i]=Score.User_Name
				RankScores[i]=Score.User_Score
				RankUIDs[i]=Score.Score_ID
				RankSeed[i]=Score.ScoreSeed
				RankTime[i]=Score.ScoreTime	
			Next	
		
		'The middle field
		Else
			
			OnLineScore.GetScores(0,3)
			OnLineScore.GetScores(OnlineRank-7,17)
			
			If Not OnlineScore.Scores.List Return
			
			IsTopTwenty=False
			For Local Score:TScores = EachIn OnlineScore.Scores.List
				i:+1
				If i<4
					RankRank[i]=i
				Else
					RankRank[i]=OnlineRank-10+i
				End If
				RankNames[i]=Score.User_Name
				RankScores[i]=Score.User_Score
				RankUIDs[i]=Score.Score_ID
				RankSeed[i]=Score.ScoreSeed
				RankTime[i]=Score.ScoreTime	
			Next		
		
		End If
		
		Connected=True
		Connecting=False
		End Rem
		
	End Method

	Function ServerThread:Object(data:Object)
		Local success:Int
		Local action:Int
		action = Int(data.ToString())
		'Print "Was told to do: "+data.ToString()
		'Repeat
		'Delay 500
		'Print "Im a thread"
		'Forever
		'LockMutex ScoreMutex
		If action=1
			Success=OnlineScore.GetScores(0,21)
			If AbortThread Return String("0")
		Else If action = 2
			Success=OnlineScore.GetMonthly(0,21)
			If AbortThread Return String("0")
			LockMutex ScoreMutex
			ServerMonth=OnlineScore.GetMonth()
			UnlockMutex ScoreMutex
			If AbortThread Return String("0")
		Else If action = 3
			Local i:Int=0
			If AbortThread Return String("0")
			LockMutex ScoreMutex
			OnlineRank = OnlineScore.RankScore(TempScore)
			UnlockMutex ScoreMutex
			If AbortThread Return String("0")
			If Not OnlineScore.SetScore(TempName,TempScore,UniqueID,TempSeed,TempPlayTime,TempTrack)
				Return String("0")
				'Need to debug the "ONLINESCORE" module to fix up returns
				'TO cause a proper - Can't connect action here
			End If
			If AbortThread Return String("0")
			TempName=Null
			TempScore=Null
			TempSeed=Null
			TempPlayTime=Null
			TempTrack=Null
			
			LockMutex ScoreMutex
			OnlineScoreCount = OnlineScore.CountScores()
			UnlockMutex ScoreMutex
			If AbortThread Return String("0")
			'Kill previously saved scores
			LockMutex ScoreMutex
			OnlineScore.Unload()
			UnlockMutex ScoreMutex
			If AbortThread Return String("0")
			'Top 20
			If OnlineRank<21
				'Get the TOP20
				OnLineScore.GetScores(0,20)
				If AbortThread Return String("0")
				If Not OnlineScore.Scores.List Return
				LockMutex ScoreMutex
				IsTopTwenty=True
				For Local Score:TScores = EachIn OnlineScore.Scores.List
					i:+1
					RankNames[i]=Score.User_Name
					RankScores[i]=Score.User_Score
					RankUIDs[i]=Score.Score_ID
					RankSeed[i]=Score.ScoreSeed
					RankTime[i]=Score.ScoreTime
					RankDifficulty[i]=Score.ScoreDifficulty
					RankRank[i]=i	
				Next
				UnlockMutex ScoreMutex
			'Rock bottom
			ElseIf OnlineRank>OnlineScoreCount-21
				'Print "rock bottom"
				OnLineScore.GetScores(0,3)
				If AbortThread Return String("0")
				OnLineScore.GetScores(OnlineRank-16,17)
				If AbortThread Return String("0")
				If Not OnlineScore.Scores.List Return
				LockMutex ScoreMutex
				IsTopTwenty=False
				For Local Score:TScores = EachIn OnlineScore.Scores.List
					i:+1
					If i<4
						RankRank[i]=i
					Else
						RankRank[i]=OnlineRank-19+i
					End If
					RankNames[i]=Score.User_Name
					RankScores[i]=Score.User_Score
					RankUIDs[i]=Score.Score_ID
					RankSeed[i]=Score.ScoreSeed
					RankDifficulty[i]=Score.ScoreDifficulty
					RankTime[i]=Score.ScoreTime	
				Next	
				UnlockMutex ScoreMutex
			'The middle field
			Else
				
				OnLineScore.GetScores(0,3)
				If AbortThread Return String("0")
				OnLineScore.GetScores(OnlineRank-7,17)
				If AbortThread Return String("0")
				
				If Not OnlineScore.Scores.List Return
				LockMutex ScoreMutex
				IsTopTwenty=False
				For Local Score:TScores = EachIn OnlineScore.Scores.List
					i:+1
					If i<4
						RankRank[i]=i
					Else
						RankRank[i]=OnlineRank-10+i
					End If
					RankNames[i]=Score.User_Name
					RankScores[i]=Score.User_Score
					RankUIDs[i]=Score.Score_ID
					RankSeed[i]=Score.ScoreSeed
					RankDifficulty[i]=Score.ScoreDifficulty
					RankTime[i]=Score.ScoreTime	
				Next	
				UnlockMutex ScoreMutex	
			
			End If
			
			If OnlineRank=-1 
				Success = 0
			Else
				Success = 1
			End If
			
		End If
		'UnlockMutex ScoreMutex
		Return String(Success)
	End Function

	
	Method GetTopScores()
		Local i:Int=0
		Local Success:Byte
		'Kill previously saved scores
		OnlineScore.Unload()
		ScoreAmount=0
		
		'Get the TOP20
		'Success=OnLineScore.GetScores(0,21)
		
		
		
		If ConnectScoreServer And Thread = Null
			AbortThread=False
			Thread:TThread = CreateThread (ServerThread, "1")
			'CloseMutex ScoreMutex
			'ConnectScoreServer=False
		End If
		

		
		If Not Thread= Null
			
			While ThreadRunning (Thread)
				ThreadLoop()
			Wend
			ReturnFromThread=True
			Success = Int(WaitThread(Thread).toString())

			ConnectScoreServer=False
			'End If
			Thread = Null
			
			If Not Success
				Connected=False
				Connecting=False
				Return
			End If
			
			If OnlineScore.Scores.List
				For Local Score:TScores = EachIn OnlineScore.Scores.List
					i:+1
					TopNames[i]=Score.User_Name
					TopScores[i]=Score.User_Score
					TopUIDs[i]=Score.Score_ID	
					RankSeed[i]=Score.ScoreSeed
					RankDifficulty[i]=Score.ScoreDifficulty
					RankTime[i]=Score.ScoreTime
				Next
			End If
			
			Connected=True
			Connecting=False
			ScoreAmount=i
		End If
		
	End Method
	
	Method GetMonthlyScores()
		Local i:Int=0
		Local Success:Byte
		
		ScoreAmount=0
		
		'Kill previously saved scores
		OnlineScore.Unload()
		For Local i=1 To 20
			TopNames[i]=""
			TopScores[i]=0
			TopUIDs[i]=""
			RankSeed[i]=""
			RankDifficulty[i]=""
			RankTime[i]=0
		Next
		'Get the TOP20
		Rem
		Success=OnLineScore.GetMonthly(0,21)
		
		ConnectScoreServer=False
		End Rem
		If ConnectScoreServer And Thread = Null
			AbortThread=False
			Thread:TThread = CreateThread (ServerThread, "2")
			'CloseMutex ScoreMutex
			'ConnectScoreServer=False
		End If
		
		
		If Not Thread= Null

			While ThreadRunning (Thread)
				ThreadLoop()
			Wend
			ReturnFromThread=True
			Success = Int(WaitThread(Thread).toString())
			
			Thread = Null
			ConnectScoreServer=False
			
			If Not Success
			'If Not OnlineScore.Scores.List
				Connected=False
				Connecting=False
				Return
			End If
			'ServerMonth = Int(WaitThread(Thread).toString())
		
			If OnlineScore.Scores.List
				For Local Score:TScores = EachIn OnlineScore.Scores.List
					i:+1
					TopNames[i]=Score.User_Name
					TopScores[i]=Score.User_Score
					TopUIDs[i]=Score.Score_ID	
					RankSeed[i]=Score.ScoreSeed
					RankDifficulty[i]=Score.ScoreDifficulty
					RankTime[i]=Score.ScoreTime
				Next
			End If
			
			Connected=True
			Connecting=False
			
			ScoreAmount=i
		End If
		
	End Method
End Type
