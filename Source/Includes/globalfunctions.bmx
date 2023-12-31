Rem
'-----------------------------------------------------------------------------
'Activates OPENGL Texture
'-----------------------------------------------------------------------------
Function SetTexturePoint( image:TImage )
	glBindTexture GL_TEXTURE_2D, TGLImageFrame(image.Frame(0)).name
	glTexParameteri GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR
	glTexParameteri GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR
	glEnable GL_TEXTURE_2D
End Function
'-----------------------------------------------------------------------------
'Check Graphics's card OPEN GL Capabilities
'-----------------------------------------------------------------------------
Function openglcheck()
	glewInit
	
	Local isDriverSupported:Int = False
	If(GL_POINT_SPRITE_ARB) isDriverSupported = True
	
	Local out:String
	If GL_VERSION_1_1
		If GL_VERSION_1_2
			If GL_VERSION_1_3
				If GL_VERSION_1_4
					If GL_VERSION_1_5
						If GL_VERSION_2_0
							out = "GL 2.0"
						Else
							out = "GL 1.5"
						EndIf
					Else
						out = "GL 1.4"
					EndIf
				Else
					out = "GL 1.3"
				EndIf
			Else
				out = "GL 1.2"
			EndIf
		Else
			out = "GL 1.1"
		EndIf
	Else
		out = "OpenGL version not recognized. GL ?.?"
	EndIf
	Local fSizes:Float[2]
	GLGetFloatv(GL_ALIASED_POINT_SIZE_RANGE, fSizes)
	
	out :+"~nGL_ALIASED_POINT_SIZE_RANGE, the smallest And largest supported sizes For aliased points:"
	For Local i:Float = EachIn fSizes
		out :+ "~n = "+i
	Next
	
	out :+ "~nPoint sprite extensions supported:"
	If(GL_POINT_SPRITE_ARB) Then out :+ "~nGL_POINT_SPRITE_ARB"
	If(GL_ARB_point_sprite) Then out :+ "~nGL_ARB_point_sprite"
	If(GL_ATIX_point_sprites) Then out :+ "~nGL_ATIX_point_sprites"
	If(GL_POINT_SPRITE_NV) Then out :+ "~nGL_POINT_SPRITE_NV"
	If(GL_NV_point_sprite) Then out :+ "~nGL_NV_point_sprite"		
	
	If(Not isDriverSupported)
		Notify("NOTHING! Your hardware or driver isn't good enough.~nYou need at least OpenGL 1.3.")
		End 'end program
	EndIf
	
	Print out
	
	RenderMethod=DRAW_GL_QUADS
	
End Function
End Rem
'-----------------------------------------------------------------------------
'Evens a number to always end with '5' or '0'
Function EvenScore:Int(Score:Int)

	Local ScoreString:String
	
	ScoreString=String(Score)
	
	'Print Right(ScoreString,1)
	
	If Right(ScoreString,1)="5"
		Return Score
	End If
	
	If Score<5 Return 5
	
	If Int(Right(ScoreString,1))<5
		Return Score-Int(Right(ScoreString,1))
	End If
	
	If Int(Right(ScoreString,1))>5
		Return Score-Int(Right(ScoreString,1))+10
	End If
	

End Function
'-----------------------------------------------------------------------------
'-----------------------------------------------------------------------------
'Quicksorts two linked (int) Arrays
'-----------------------------------------------------------------------------
Function FastDualQuickSortInt(array:Int[],array2:Int[])
	DualQuickSort(array, array2, 0, array.Length - 1)
	InsertionSort(array, array2, 0, array.Length - 1)

	Function DualQuickSort(a:Int[],a2:Int[],l:Int, r:Int)
		If (r - l) > 4
			Local tmp:Int
			Local tmp2:Int
			Local i:Int, j:Int, v:Int
			i = (r + l) / 2
			If (a[l] > a[i]) 'swap(a, l, i)
				tmp = a[l]
				tmp2 = a2[l]
				a[l] = a[i]
				a2[l] = a2[i]
				a[i] = tmp
				a2[i] = tmp2
			End If
			If (a[l] > a[r]) 'swap(a, l, r)
				tmp = a[l]
				tmp2 = a2[l]
				a[l] = a[r]
				a2[l] = a2[r]
				a[r] = tmp
				a2[r] = tmp2
			End If
			If (a[i] > a[r]) 'swap(a, i, r)
				tmp = a[i]
				tmp2 = a2[i]
				a[i] = a[r]
				a2[i] = a2[r]
				a[r] = tmp
				a2[r] = tmp2
			End If
			j = r - 1
			'swap(a, i, j)
			tmp = a[i]
			tmp2 = a2[i]
			a[i] = a[j]
			a2[i] = a2[j]
			a[j] = tmp
			a2[j] = tmp2
			i = l
			v = a[j]
			Repeat
				i:+1
				While a[i] < v ; i:+1; Wend
				j:-1
				While a[j] > v ; j:-1;Wend
				If (j < i) Exit
				'swap (a, i, j)
				tmp = a[i]
				tmp2 = a2[i]
				a[i] = a[j]
				a2[i] = a2[j]
				a[j] = tmp
				a2[j] = tmp2
			Forever
			'swap(a, i, r - 1)
			tmp = a[i]
			tmp2 = a2[i]
			a[i] = a[r - 1]
			a2[i] = a2[r - 1]
			a[r - 1] = tmp
			a2[r - 1] = tmp2
			DualQuickSort(a,a2, l, j)
			DualQuickSort(a,a2, i + 1, r)
		End If
	End Function

	Function InsertionSort(a:Int[],a2:Int[],lo0:Int, hi0:Int)
		Local i:Int, j:Int, v:Int, v2:Int
		For i = lo0 + 1 To hi0
			v = a[i]
			v2 = a2[i]
			j = i
			While (j > lo0) And (a[j - 1] > v)
				a[j] = a[j - 1]
				a2[j] = a2[j -1]
				j:-1
			Wend
			a[j] = v
			a2[j] = v2
		Next
	End Function

End Function
'-----------------------------------------------------------------------------
'Enumerates graphics modes & sorts them according to aspect-ratio
'-----------------------------------------------------------------------------
Function EnumerateGraphics()
	Local i:Int
	Local Width:Int
	Local Height:Int
	Local Depth:Int
	Local Hertz:Int
	Local isWide:Byte
	Local isDuplicate:Byte
	Local isDesktopWide:Byte
	Local WideCount:Int
	Local TallCount:Int
	'Array Reverse Temps
	Local WideScreenWidthTemp[50]
	Local WideScreenHeightTemp[50]
	Local TallScreenHeightTemp[50]
	Local TallScreenWidthTemp[50]
	
	
	
	?MacOS
	For i=CountGraphicsModes()-1 To 0 Step -1
	?
	?Win32
	For i=0 To CountGraphicsModes()-1
	?
	
		'Reset Widescreen & Duplicate bits
		isWide=False
		isDuplicate=False
		'Get the Graphics Mode
		GetGraphicsMode(i,Width,Height,Depth,Hertz)
		'Discard 16 Bit depth resolutions
		If Depth=16 Continue
		'Check for widescreen resolutions
		If Float(Width)/Float(Height)=>1.38 Then isWide=True
		'Discard Resolutions smaller than 640x480 & 800x500
		If isWide=False
			If DWidth>1680
				If Width<800 Or Height<600 Continue
			Else
				If Width<640 Or Height<480 Continue
			End If
		Else
			If Width<800 Or Height<500 Continue
		End If
		'Discard Resolutions bigger or same than Desktop Res
		If Width>DWidth Or Height>DHeight Continue
		'Discard the Desktop resolution, too. We are going to add it manually later.
		If Width=DWidth And Height=DHeight Continue
		'Put the resolution In
		Select isWide
			Case 1
				For Local n=1 To WideCount
					'Prevent Duplicates
					If WidescreenWidth[n]=Width And WidescreenHeight[n]=Height Then
						isDuplicate=True
					End If
					'Also Prevent too similar resolutions
					If WidescreenWidth[n]+80>Width And WideScreenWidth[n]-80<Width And WideScreenHeight[n]+80>Height And WideScreenHeight[n]-80<Height Then
						isDuplicate=True
					End If
				Next
				If Not isDuplicate Then
					'Sanity Stop Prevent Array Out Of Bounds
					If (WideCount >= 48) Continue;
					WideCount:+1
					WidescreenWidth[WideCount]=Width
					WidescreenHeight[WideCount]=Height
				End If
			Case 0
				For Local n=1 To TallCount
					'Prevent Duplicates
					If TallscreenWidth[n]=Width And TallscreenHeight[n]=Height Then
						isDuplicate=True
					End If
					'Also Prevent too similar resolutions
					If TallscreenWidth[n]+80>Width And TallscreenWidth[n]-80<Width And TallscreenHeight[n]+80>Height And TallscreenHeight[n]-80<Height Then
						isDuplicate=True
					End If
				Next
				If Not isDuplicate Then
					'Sanity Stop Prevent Array Out Of Bounds
					If (TallCount >= 48) Continue;
					TallCount:+1
					TallscreenWidth[TallCount]=Width
					TallscreenHeight[TallCount]=Height
				End If
		End Select		
	Next
		
	For Local i=0 To 19
		If WideScreenWidth[i]=0 Then
			WideScreenWidth[i]=9999914
			WideScreenHeight[i]=9999914
		End If
		If TallScreenWidth[i]=0 Then
			TallScreenWidth[i]=9999914
			TallScreenHeight[i]=9999914
		End If
	Next
	
	'Print(WideScreenWidth[5])
	
	FastDualQuickSortInt(TallScreenWidth,TallScreenHeight)
	FastDualQuickSortInt(WideScreenWidth,WideScreenHeight)
	
	
	If Float(DWidth)/Float(DHeight)=>1.38 Then
		'is Wide
		If WideCount<5 Then
			WideScreenWidth[WideCount]=DWidth
			WideScreenHeight[WideCount]=DHeight
		Else
			WideScreenWidth[5]=DWidth
			WideScreenHeight[5]=DHeight
		End If
	Else
		'is Tall
		If TallCount<5 Then
			TallScreenWidth[TallCount]=DWidth
			TallScreenHeight[TallCount]=DHeight
		Else
			TallScreenWidth[5]=DWidth
			TallScreenHeight[5]=DHeight
		End If
	End If
	
	
	For Local i=0 To 19
		If WideScreenWidth[i]=9999914 And WideScreenHeight[i]=9999914 Then
			WideScreenWidth[i]=0
			WideScreenHeight[i]=0
		End If
		If TallScreenWidth[i]=9999914 And TallScreenHeight[i]=9999914 Then
			TallScreenWidth[i]=0
			TallScreenHeight[i]=0
		End If
	Next
	
	
	If Dwidth=>2560 And Dwidth<=6560
		For Local i=5 To 0 Step -1
			If WideScreenWidth[i]<=1980 And WideScreenWidth[i]>=1200 Then
				RecommendedWideWidth=WideScreenWidth[i]
				RecommendedWideHeight=WideScreenHeight[i]
				Exit
			End If
		Next
		
		For Local i=5 To 0 Step -1
			If TallScreenWidth[i]<=1980 And TallScreenWidth[i]>=1200 Then
				RecommendedTallWidth=TallScreenWidth[i]
				RecommendedTallHeight=TallScreenHeight[i]
				Exit
			End If
		Next
	ElseIf Dwidth=>1600 And Dwidth<=2560
		For Local i=5 To 0 Step -1
			If WideScreenWidth[i]<=1280 And WideScreenWidth[i]>=1024 Then
				RecommendedWideWidth=WideScreenWidth[i]
				RecommendedWideHeight=WideScreenHeight[i]
				Exit
			End If
		Next
		
		For Local i=5 To 0 Step -1
			If TallScreenWidth[i]<=1280 And TallScreenWidth[i]>=1024 Then
				RecommendedTallWidth=TallScreenWidth[i]
				RecommendedTallHeight=TallScreenHeight[i]
				Exit
			End If
		Next
	ElseIf Dwidth=>1200 And Dwidth<1650
		For Local i=5 To 0 Step -1
			If WideScreenWidth[i]<=1024 And WideScreenWidth[i]>=800 Then
				RecommendedWideWidth=WideScreenWidth[i]
				RecommendedWideHeight=WideScreenHeight[i]
				Exit
			End If
		Next
		
		For Local i=5 To 0 Step -1
			If TallScreenWidth[i]<=1024 And TallScreenWidth[i]>=800 Then
				RecommendedTallWidth=TallScreenWidth[i]
				RecommendedTallHeight=TallScreenHeight[i]
				Exit
			End If
		Next
	ElseIf Dwidth=>800 And Dwidth<1280
		RecommendedWideWidth=WideScreenWidth[0]
		RecommendedWideHeight=WideScreenHeight[0]
		RecommendedTallWidth=TallScreenWidth[0]
		RecommendedTallHeight=TallScreenHeight[0]
	End If
	
	'If nothing is found always use minimal resolution
	If RecommendedWideWidth=0 Or RecommendedTallWidth=0 Then
		RecommendedWideWidth=WideScreenWidth[0]
		RecommendedWideHeight=WideScreenHeight[0]
		RecommendedTallWidth=TallScreenWidth[0]
		RecommendedTallHeight=TallScreenHeight[0]
	End If
	
End Function
'-----------------------------------------------------------------------------------
'Re initializes the virtual mouse system on a resolution change
'-----------------------------------------------------------------------------------
Function InitMouse:Int()
	
	'ShowMouse()
	HideMouse()

	If FullScreen
		CenterMouseX=RealWidth/2
		CenterMouseY=RealHeight/2
	Else
		CenterMouseX=GraphicsWidth()/2
		CenterMouseY=GraphicsHeight()/2
	End If
	
	FilterMouseXSpeed = 0
	FilterMouseYSpeed = 0
	
	MoveMouse(CenterMouseX,CenterMouseY)
	
	prevMouseX=MouseX()
	prevMouseY=MouseY()
	
	If GameState=MENU
		XMouse = RealWidth/2
		YMouse = RealHeight/2
	End If

End Function
'-----------------------------------------------------------------------------------
'Counts the amount of enemies currently on-screen
'-----------------------------------------------------------------------------------
Function CountEnemies:Int()
	Local Count:Int=0
	
	If SeedDifficultyJudge<75
		If Invader.List Count:+CountList(Invader.List)
		If Spinner.List Count:+CountList(Spinner.List)
		If Thief.List Count:+CountList(Thief.List)
		If MineLayer.List Count:+CountList(MineLayer.List)
		If Chaser.List Count:+CountList(Chaser.List)
		If Snake.List Count:+Int(((CountList(Snake.List)-CountList(Snake.List) Mod 20)/20)*3)
		If Boid.List Count:+CountList(Boid.List)
		If Asteroid.List Count:+CountList(Asteroid.List)
		If DataProbe.List Count:+CountList(DataProbe.List)
		If CorruptedInvader.List Count:+CountList(CorruptedInvader.List)
		If CorruptionNode.List Count:+CountList(CorruptionNode.List)*2
	Else
		If Invader.List Count:+CountList(Invader.List)
		If Spinner.List Count:+CountList(Spinner.List)
		If Thief.List Count:+CountList(Thief.List)
		If MineLayer.List Count:+CountList(MineLayer.List)
		If Chaser.List Count:+CountList(Chaser.List)
		If Snake.List Count:+Int((CountList(Snake.List)-CountList(Snake.List) Mod 20)/20)
		If Boid.List Count:+CountList(Boid.List)
		If Asteroid.List Count:+CountList(Asteroid.List)
		If DataProbe.List Count:+CountList(DataProbe.List)
		If CorruptedInvader.List Count:+CountList(CorruptedInvader.List)
		If CorruptionNode.List Count:+CountList(CorruptionNode.List)
	End If
	Return Count

End Function
'-----------------------------------------------------------------------------------
'Precaches all graphics into the GFX-Card V-RAM
'-----------------------------------------------------------------------------------
Function WarmCaches()

	Shot.ReCache()
	ShotGhost.Recache()
	SpawnEffect.ReCache()
	PowerUp.ReCache()
	Invader.ReCache()
	Spinner.ReCache()
	Snake.ReCache()
	Chaser.ReCache()
	Mine.ReCache()
	MineLayer.ReCache()
	Asteroid.ReCache()
	Boid.ReCache()
	Thief.ReCache()
	DataProbe.ReCache()
	Corruption.ReCache()
	CorruptionNode.ReCache()
	CorruptedInvader.ReCache()
	ParticleManager.ReCache()
	Thrust.ReCache()
	Player.ReCache()
	Glow.ReCache()
	Explosion.ReCache()
	ShockWave.ReCache()
	Flash.ReCache()
	BombHUD.ReCache()
		
	BoldFont.PreCache()
	IngameFont.PreCache()
	ScoreFont.PreCache()
	DoubleBoldFont.PreCache()
	
	PrepareFrame(MouseCursor)
	PrepareFrame(FrenzyBar)
	PrepareFrame(FrenzyMeter)

End Function
'-----------------------------------------------------------------------------------
'Gets Called on Program End, Saves INI file, cleans up
'-----------------------------------------------------------------------------------
Function EndCleanup:Int()
	WriteIniFile
	TypeDestroy(True)
	MusicPlayer.Destroy(); 'SoundLoop.DestroyAll()
	Return Null
End Function
'-----------------------------------------------------------------------------------
'Resets and restarts the game from Different places
'-----------------------------------------------------------------------------------
Function GetResumeInput()
	If InputKey[FIRE_BOMB]>3 And InputKey[FIRE_BOMB]<200
		If KeyHit(InputKey[FIRE_BOMB])
		
			ToolTip=""
			TypeDestroy(False)
			
			'Reset All Variables
			GameInit()
			
			'The Player is alive Again
			Player.Alive=True
			
			'Gamestate is Getting Ready
			GameState=READY
			GameMode=ARCADE
			PlaySoundBetter Sound_Game_Start,FieldWidth/2,FieldHeight/2,False,False
			
		End If
	ElseIf InputKey[FIRE_BOMB]<=3
		If MouseHit(InputKey[FIRE_BOMB])
			
			ToolTip=""
			TypeDestroy(False)
			
			'Reset All Variables
			GameInit()
			
			'The Player is alive Again
			Player.Alive=True
			
			'Gamestate is Getting Ready
			GameState=READY
			GameMode=ARCADE
			PlaySoundBetter Sound_Game_Start, FieldWidth/2,FieldHeight/2,False,False
		
		End If
	Else
		If JoyInput(InputKey[FIRE_BOMB],True)
			
			ToolTip=""
			TypeDestroy(False)
			
			'Reset All Variables
			GameInit()
			
			'The Player is alive Again
			Player.Alive=True
			
			'Gamestate is Getting Ready
			GameState=READY
			GameMode=ARCADE
			PlaySoundBetter Sound_Game_Start, FieldWidth/2,FieldHeight/2,False,False
			
		End If
	End If
End Function
'-----------------------------------------------------------------------------------
'Checks wether a graphics mode exists or not
'-----------------------------------------------------------------------------------
Function CheckGraphics(Width:Int,Height:Int, Force:Byte=False)
	
	If Width=RealWidth And Height=RealHeight Return
	
	If FullScreen=True
		If GraphicsModeExists(Width,Height) Or Force
			RealWidth=Width
			RealHeight=Height
			ReInitGraphics=True
			ForceGraphics=Force
		Else
			MainMenu.GraphicsError=True
		End If
	Else
		If Width<=DWidth And Height<=DHeight	
			RealWidth=Width
			RealHeight=Height
			ReInitGraphics=True
			ForceGraphics=Force
		Else
			MainMenu.GraphicsError=True
		End If
	End If
	
End Function
'-----------------------------------------------------------------------------------
'Draws the game logo with a static effect
'-----------------------------------------------------------------------------------
Function CalcLogo()
	If Rand(0,3) < 3
		For Local i=0 To 54 Step 2
			If Rand(0,7)<7
				LogoFlickerOffset[i]=Rnd(-44,44)
			Else
				LogoFlickerOffset[i]=0
			End If
		Next
	End If
End Function
Function DoLogo(x:Int,y:Int)
	
	DrawImage GameLogo,x,y
	

	

	For Local i=0 To 54 Step 2
		DrawSubImageRect GameBuzz,x+LogoFlickerOffset[i],y+i,812,2,0,i,812,2,406,29
	Next

End Function
'-----------------------------------------------------------------------------------
'Precaches an image into VRAM to prevent short pauses upon drawing said image
'-----------------------------------------------------------------------------------
Function PrepareFrame(image:TImage) Private
	'Use this to cache an image or animimage in VRAM for quicker drawing later.
	For Local c=0 Until image.frames.length
		image.Frame(c)
	Next
End Function
'-----------------------------------------------------------------------------------
'Finds duplicate/multiple instances of the Application in Win32 and terminates
'-----------------------------------------------------------------------------------
?Win32
Function FindDuplicateInstances()
	Extern "win32"
		Const ERROR_ALREADY_EXISTS:Int = 183
		
		Function CreateMutexW:Int(security:Byte Ptr,owner: Int, name$w)
		Function GetLastError:Int() = "GetLastError@0"
	End Extern
	
	Local Ret:Int = CreateMutexW(Null,True,AppTitle)'+VersionString)
	
	If GetLastError() = ERROR_ALREADY_EXISTS
		DuplicateClose=True
		RuntimeError("Another instance of 'Invaders Corruption' is already running.~nThis instance will now terminate.")
		End
	End If
End Function
?
'-----------------------------------------------------------------------------
'Converts a Pixmap to Greyscale
'-----------------------------------------------------------------------------
Function ConvertToGreyScale(i:TPixmap)
  For Local y=0 Until i.height
    For Local x=0 Until i.width
      Local col = ReadPixel( i, x, y )
      Local a = ( col & $ff000000)
      Local r = ( col & $ff0000 ) Shr 16
      Local g = ( col & $ff00 ) Shr 8
      Local b = ( col & $ff )
      Local cc= (r+g+b)/3
      col = a | (cc Shl 16) | (cc Shl 8) | cc
      WritePixel i, x, y, col
    Next
  Next
EndFunction
'-----------------------------------------------------------------------------
'Shake the Screen, old-style arcade Effect
'-----------------------------------------------------------------------------
Rem
Function ScreenQuake()
	If GameState=Pause Return
	Local ShakeX:Float
	Local ShakeY:Float
	Local CurrX:Float
	Local CurrY:Float
	
	If ScreenShake>=0
		If ScreenShake>1.4
			GetOrigin (CurrX,CurrY)
			Repeat
				ShakeX=Rnd(0-ScreenShake*2,ScreenShake*2)
				ShakeY=Rnd(0-ScreenShake*2,ScreenShake*2)
			Until Abs(CurrX-ShakeX)>1.25 Or Abs(CurrY-ShakeY)>1.25
		Else
			ShakeX=Rnd(0-ScreenShake,ScreenShake)
			ShakeY=Rnd(0-ScreenShake,ScreenShake)
		End If

		SetOrigin ShakeX,ShakeY
		
		ScreenShake:-.09*Delta
	ElseIf ScreenShake<0

		SetOrigin 0,0

	End If

End Function
End Rem
'-----------------------------------------------------------------------------
'Jumble Easter Egg Strings so they're harder to find
'-----------------------------------------------------------------------------
Function SeedJumble:String(Seed:String,UpCase:Byte=True,Reverse:Byte=False)
	Local Jumble:String=Seed
	Local Output:String=""
	
	If UpCase Then Jumble=Upper(Jumble)
	
	If Not Reverse
		For Local i=1 To Len(Jumble)
			Output:+Chr(Asc(Mid(Jumble,i,1))-3)
		Next
	Else
		For Local i=1 To Len(Jumble)
			Output:+Chr(Asc(Mid(Jumble,i,1))+3)
		Next
	End If

	Return Output
End Function
'-----------------------------------------------------------------------------
'A quick and externalized Hitbox checking Function
'-----------------------------------------------------------------------------
Function HitBox:Int(x1:Int,y1:Int,w1:Int,h1:Int,x2:Int,y2:Int,w2:Int,h2:Int)

	If x1 > x2+w2 
		' rec 1 is too far right
		Return False
	Else
		If x1+w1 < x2
			' rec 1 is too far left
			Return False
		Else
			' xs are overlapping - check ys
			If y1 > y2+h2 
				' rec 1 is too far down
				Return False
			Else
				If y1+h1 < y2 
					' rec 1 is too far above
					Return False
				Else
					' overlap?
					Return True				
				EndIf
			EndIf
		EndIf
	EndIf

End Function
'-----------------------------------------------------------------------------
'Joystick input related Functions
'-----------------------------------------------------------------------------
Function JoyInput(Button:Int,HitCheck:Int=False)
	
	If Button<210	And Button>190 'Negative Axis
	
		If JoyAxis(0,Button-200)<-.1 Return True
		
	ElseIf Button<270 And Button>=260 'Positive Axis
	
		If JoyAxis(0,Button-260)>.1 Return True
	
	ElseIf Button>219 And Button<255 And HitCheck=False'Button
	
		If JoyButton(Button-220) Return True
	
	ElseIf Button>219 And Button<255 And HitCheck'Button
		
		If JoyHit(Button-220) Return True
	
	End If
	
End Function

Function JoyAnalogInput:Float(Button:Int,DontEqualize:Byte=True)
	
	If DontEqualize
		If Button<210 And Button>190 'Negative Axis
		
			If JoyDeadZone[0]=0
				If Abs(JoyAxis(0,Button-200))>Abs(Float(JoyDeadZoneAdjust)/100) Return JoyAxis(0,Button-200)
			Else
				If Abs(JoyAxis(0,Button-200))>Abs(Float(JoyDeadZoneAdjust)/100+JoyDeadZone[0])  Return JoyAxis(0,Button-200)
			End If
			
		ElseIf Button<270 And Button>=260 'Positive Axis
		
			If JoyDeadZone[0]=0
				If Abs(JoyAxis(0,Button-260))>Abs(Float(JoyDeadZoneAdjust)/100) Return JoyAxis(0,Button-260)
			Else
				If Abs(JoyAxis(0,Button-260))>Abs(Float(JoyDeadZoneAdjust)/100+JoyDeadZone[0]) Return JoyAxis(0,Button-260)
			End If
		End If
	Else
		If Button<210	And Button>190 'Negative Axis
		
			If JoyDeadZone[0]=0
				If Abs(JoyAxis(0,Button-200))>Abs(Float(JoyDeadZoneAdjust)/100) Return JoyAxis(0,Button-200)
			Else
				If Abs(JoyAxis(0,Button-200))>Abs(Float(JoyDeadZoneAdjust)/100+JoyDeadZone[0])  Return JoyAxis(0,Button-200)
			End If
			
		ElseIf Button<270 And Button>=260 'Positive Axis
		
			If JoyDeadZone[0]=0
				If Abs(JoyAxis(0,Button-260))>Abs(Float(JoyDeadZoneAdjust)/100) Return JoyAxis(0,Button-260)
			Else
				If Abs(JoyAxis(0,Button-260))>Abs(Float(JoyDeadZoneAdjust)/100+JoyDeadZone[0])  Return JoyAxis(0,Button-260)
			End If
			
		End If
	End If

End Function

Function JoyCalibrate( port=0)
	For Local i=0 To 7
		SampleJoy port
		JoyDeadZone[i]=joy_axis[port*16+i]
		'Print JoyDeadZone[i]
	Next
	
	If JoyCount()=0
		Local HasJoyInput:Byte
		
		For Local i=1 To 6
			If InputKey[i]>200 HasJoyInput=True
		Next
		
		'Reset controls
		If HasJoyInput And JoyCount()=0
			InputKey[MOVE_UP]=KEY_W
			InputKey[MOVE_DOWN]=KEY_S
			InputKey[MOVE_LEFT]=KEY_A
			InputKey[MOVE_RIGHT]=KEY_D
			InputKey[FIRE_CANNON]=1
			InputKey[FIRE_BOMB]=2
			MainMenu.UpdateOptionStates()
		End If
		
	End If
	
End Function

Function JoyAxis:Float( port=0, axis )
	SampleJoy port
	If JoyDeadZone[axis]=0
		If Abs(joy_axis[port*16+axis])>Abs(Float(JoyDeadZoneAdjust)/100)
			Return joy_axis[port*16+axis]'-(Float(JoyDeadZoneAdjust)/100)
		End If
	Else
		If Abs(joy_axis[port*16+axis])>Abs(JoyDeadZone[axis]+(Float(JoyDeadZoneAdjust)/100))
			Return joy_axis[port*16+axis]'-JoyDeadZone[axis]*Float(JoyDeadZoneAdjust)
		End If
	End If
End Function

Function JoyButton:Int(Button:Int,port=0)
	
	If JoyDown(Button,port) Return Button+1

End Function
'-----------------------------------------------------------------------------
'Tweening Functions
'-----------------------------------------------------------------------------
Function Tween:Float(p1:Float, p2:Float, t:Float)
	Return p1 + t * (p2 - p1)
End Function

Function TweenSmooth:Float(p1:Float, p2:Float, t:Float)
	Local v# = SmoothStep(t)
	Return p1 + v * (p2 - p1)
End Function

Function RotateSmooth:Float(ang:Float,angto:Float,amount:Float)
	If ang>268.5 And angto>0
		'Print "ang:"+ang
		'Print "angto:"+angto
		angto=-90
	ElseIf ang<-88.5 And Angto>0
		'ang=270
		angto=180+angto
	End If
	'If ang<-89 And angto>0 Then ang=1
	Local angdiff:Float=((angto - ang) Mod 360 + 540) Mod 360 - 180
	'distance to 'angto' is less than 'amount'
	If Abs(angdiff)<amount	
		Return angto
	Else
		Return ang+Sgn(angdiff)*amount
	EndIf
End Function

Function SmoothStep:Float(x#)
	Return x*x * (3-2*x)
End Function
'-----------------------------------------------------------------------------
'Convert Radians to Degrees
'-----------------------------------------------------------------------------
Function Rad2Deg:Float(Rad:Float)
	Return Rad*180.0/Pi
End Function
'-----------------------------------------------------------------------------
'Limit an Angle to 0-360 degrees
'-----------------------------------------------------------------------------
Function FixAngle:Float(angle:Float)
	If angle >= 0.0
		Return angle Mod 360.0
	Else
		Return angle - (360.0 * (angle/360.0 - 1.0))
	End If
End Function
'-----------------------------------------------------------------------------
'Angle between two points
'-----------------------------------------------------------------------------
Function Angle360:Float(x1,y1,x2,y2)
	Return (ATan2(y2 - y1, x2 - x1) + 450) Mod 360
End Function 
'-----------------------------------------------------------------------------
'Add 1000's dots to the scores for easier leglibity
'-----------------------------------------------------------------------------
Function ScoreDotted:String(Score:Int,Padding:Int=0)
	Local TextScore:String=String(Score)
	Local Output:String[32]
	Local Length:Int=Len(TextScore)
	Local k:Int
	
	While Length<Padding
		TextScore="0"+TextScore
		Length:+1
	Wend
	
	'Print TextScore
		
	For Local i=1 To Length Step 3
		
		k:+1
		Output[k]:+Mid(TextScore,Length-i-1,3)

	Next
	
	TextScore=""
	
	For Local i=k To 1 Step -1
		
		If i>1
			TextScore:+Output[i]+"."
		Else
			TextScore:+Output[i]
		End If
	Next
	
	Return TextScore
		
End Function
'-----------------------------------------------------------------------------
'Generate the users unique user identifier
'-----------------------------------------------------------------------------
Function GenerateUniqueID:String(Seed:String)
	Local Characters:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789abcdefghijklmABCDEFHJIJKLMNOP0123456789"
	Local TempString:String=""
	Local UniqueID:String=""
	Local SeedVal:Int
	
	For Local i=1 To Len(Seed)
		SeedVal:+Asc(Mid$(Seed,i,1))*(i/2)
	Next
	
	TempString:+String(SeedVal)
	TempString:+String(MilliSecs())
	TempString:+String(Rand(1,60000))
	TempString:+String(MouseX())
	TempString:+String(SeedVal*128*Rand(32))
	
	For Local i=1 To Len(TempString)
	
			UniqueID:+Mid(Characters,(Int(Mid(TempString,i,2))),1)
	
	Next
	
	Return Left(UniqueID,32)

End Function
'-----------------------------------------------------------------------------
'Darken the screen by a certain Alpha Value
'-----------------------------------------------------------------------------
Function DarkenScreen(Alpha:Float)
	Local OldRotation:Float=GetRotation()
	Local OldBlend:Int=GetBlend()
	Local OldAlpha:Float=GetAlpha()
	Local OldScaleX:Float, OldScaleY:Float
	
	GetScale(OldScaleX,OldScaleY)
	
	SetBlend ALPHABLEND
	SetTransform 0,1,1
	'SetRotation 0
	'SetScale 1,1
	SetColor 0,0,0
	SetAlpha Alpha
	DrawRect 0,0,ScreenWidth,ScreenHeight
	
	'SetRotation OldRotation
	SetBlend OldBlend
	SetAlpha OldAlpha
	SetTransform OldRotation,OldScaleX,OldScaleY
	SetColor 255,255,255

End Function

'-----------------------------------------------------------------------------
'Distance between a Finite line and a Point (Used for laser barriers)
'-----------------------------------------------------------------------------
Function LineDistance:Float(x1:Float,y1:Float,x2:Float,y2:Float,x3:Float,y3:Float)
	Local LineX:Float
	Local LineY:Float
	Local PointX:Float
	Local PointY:Float
	Local DistanceX:Float
	Local DistanceY:Float
	Local TempDist:Float
	Local PointDist:Float
	
	LineX=x2-x1
	LineY=y2-y1
	
	TempDist = LineX*LineX + LineY*LineY
	
	PointDist = ((x3 - x1) * LineX + (y3 - y1) * LineY)/TempDist
	
	If PointDist > 1
		PointDist=1
	ElseIf PointDist<0
		PointDist=0
	End If
	
	PointX = x1 + PointDist * LineX
	PointY = y1 + PointDist * LineY
	
	DistanceX = PointX - x3
	DistanceY = PointY - y3
	
	Return Sqr(DistanceX*DistanceX + DistanceY*DistanceY)

End Function
'-----------------------------------------------------------------------------
'Generates notes, sorted by octave, for the sound pitch-shifter
'-----------------------------------------------------------------------------
Function GenerateNotes()
	For Local Octave:Float=-4 To 4
		DebugLog Octave
		Note[4+Octave]=2^(Octave/12)

	Next

End Function
'-----------------------------------------------------------------------------
'Plays Stereo Positional Audio; Makes sounds unique
'-----------------------------------------------------------------------------
Function PlaySoundBetter(sound:TSound,soundx:Float,soundy:Float,MakeUnique:Int=True,IsGameSound:Int=True,LoopingSound:Byte=False)
	
	'If we are muted dont play sounds
	If SoundMute Return
	
	Local channel:TChannel
	Local volume:Double
	Local panvalue:Double
	
	Local VolSpread:Double=0.988
	
	'If ExplosionSounds=False And Sound=Sound_Explosion Return
	
	'Dont play the sounds inside Menus/Highscore tables etc...
	If IsGameSound And GameState<>Playing Return
	
	If Not LoopingSound
		channel:TChannel = AllocChannel() ' allocate a channel
	Else
		If ChannelPlaying(LoopChannel) Return
	End If
	
	If SoundMode
	
		volume   = (1 - ((PlayerDistance(soundx,soundy) * (1 - volspread)) / 100))
		
		volume=volume*SoundVol
	
		panvalue = (2 * ((soundx / ScreenWidth)) - 1)
		
		If panvalue < -1 panvalue = -1
		If panvalue > 1 panvalue = 1
	
	Else
	
		Volume=SoundVol
	
	End If
	
	If volume > 0 'only allocate resources if we are really going to play the sound
		If MakeUnique
			If FPSTarget<>SLOW_FPS
				SetChannelRate(channel:TChannel,Note[Rand(0,8)]) ' make each sound unique
			Else
				SetChannelRate(channel:TChannel,Note[Rand(0,8)]/2) ' make each sound unique
			End If
		End If
		
		If Not LoopingSound
			SetChannelVolume(channel:TChannel,volume)
			If SoundMode SetChannelPan(channel:TChannel,panvalue)
			PlaySound(sound:TSound,channel:TChannel) ' play sound
		Else
			SetChannelVolume(LoopChannel:TChannel,volume)
			If SoundMode SetChannelPan(LoopChannel:TChannel,panvalue)
			PlaySound(sound:TSound,LoopChannel:TChannel)
		End If
	End If
	
End Function

'-----------------------------------------------------------------------------
'Handle slowdown and speedup of the game
'-----------------------------------------------------------------------------
Function DoFPSLogic()
		
		'Don't Change FPS Logic during Pause!
		If GameState=PAUSE Return
		
		
		'Switch in and out of Slowmotion smoothly
		If FPSTarget-FPSCurrent>=0.01 Or FPSTarget-FPSCurrent<=-0.01  Then
		
			FPSCurrent:- ((FPSCurrent-FPSTarget)/150)*Delta

			FixedRateLogic.SetFPS(FPSCurrent)
			FixedRateLogic.CalcMS()
						
		End If
		
		'Handle Scanline Fading Transition
		If FPSTarget=SLOW_FPS
			If ScanlineFader<=.25 ScanlineFader:+0.001*Delta
		Else
			If ScanlineFader>=0 ScanlineFader:-0.0006*Delta
		End If
		
End Function

'-----------------------------------------------------------------------------
'Trackmouse provides relative mouse input which supports Mouse sensitivy
'-----------------------------------------------------------------------------
Function TrackMouse()
	
	If GAMESTATE=PAUSE And FullScreen=False Return
	
	Local curMouseX:Int, curMouseY:Int
	Local TempSens:Float
	
	?MacOS
	curMouseX=MouseX()'VirtualMouseX()
	curMouseY=MouseY()'VirtualMouseY()
	?
	?Win32
	curMouseX=MouseX()'AspectMouseX()
	curMouseY=MouseY()'AspectMouseY()
	?

	FilterMouseXSpeed=curMouseX - prevMouseX
	FilterMouseYSpeed=curMouseY - prevMouseY
	
	If Abs(centerMouseX - curMouseX) > SAFEZONE Or Abs(centerMouseY - curMouseY) > SAFEZONE And Logic_LostFocus=False Then
		'Print "tried to recenter "+MilliSecs()
		MoveMouse centerMouseX, centerMouseY
		prevMouseX = centerMouseX - FilterMouseXSpeed
		prevMouseY = centerMouseY - FilterMouseYSpeed
	Else
		prevMouseX = curMouseX
		prevMouseY = curMouseY
	EndIf
	
	TempSens=Float(MouseSensivity)
	
	'reposition "controllers"
	XMouse=XMouse+(Float(FilterMouseXSpeed)*(TempSens/10))
	YMouse=YMouse+(Float(FilterMouseYSpeed)*(TempSens/10))
	
	If XMouse<0 Then XMouse=0
	If YMouse<0 Then YMouse=0
	If Xmouse>ScreenWidth Then XMouse=ScreenWidth
	If YMouse>ScreenHeight Then YMouse=ScreenHeight
	
End Function
' -----------------------------------------------------------------------------
' Rounds a float down to the next integer (As Integer)
' -----------------------------------------------------------------------------
Function Round:Int(flot:Float)
	Return Floor(flot+0.5)
End Function

'-----------------------------------------------------------------------------
'Round long floating point numbers e.g. for the countdown (As String)
'-----------------------------------------------------------------------------
Function FloatRound:String(f:Float,decimals:Int=3)		'Rounds Float Values to the specified number of decimals

	Local i:Long = (10^decimals)*f
	Local value:String = String.fromlong(i)
		
	If value.length<=decimals
		Return "0."+(RSet("",decimals-value.length)).Replace(" ","0")+value
	Else
		Return value[0..value.length-decimals] + "." + value[value.length-decimals..value.length]  
	EndIf
End Function 

'-----------------------------------------------------------------------------
'Calculate angle facing away from a set of two points
'-----------------------------------------------------------------------------
Function AwayFrom:Float(X1:Float,Y1:Float,X2:Float,Y2:Float)
	Local dx:Float=x1-x2
	Local dy:Float=y1-y2
	Local Angle:Float=(ATan2(dy,dx))
	
	Return Angle 
End Function

'-----------------------------------------------------------------------------
'Calculate the distance between two points
'-----------------------------------------------------------------------------
Function Distance:Float(x1,y1,x2,y2)				
	Local dx# = x2-x1
	Local dy# = y2-y1
	
	Return Sqr(dx*dx + dy*dy)

End Function

'-----------------------------------------------------------------------------
'Calculate the distance between Player and another Object
'-----------------------------------------------------------------------------
Function PlayerDistance:Float(x1,y1)				
	Local dx# = Player.X-x1
	Local dy# = Player.Y-y1
	
	Return Sqr(dx*dx + dy*dy)

End Function

'-----------------------------------------------------------------------------
'Is an Object Visible on screen?
'-----------------------------------------------------------------------------
Function IsVisible:Byte(x#,y#,tolerance#=0)		
	
	If X <= -Tolerance 
		' too far right
		Return False
	Else
		If X >= ScreenWidth+Tolerance
			' too far left
			Return False
		Else
			' X is in boundary; check Y
			If Y <= -Tolerance
				' too far down
				Return False
			Else
				If Y >= ScreenHeight+Tolerance 
					' too far above
					Return False
				Else
					' O.K.
					Return True				
				EndIf
			EndIf
		EndIf
	EndIf

End Function
'-----------------------------------------------------------------------------
'Returns the name of the current month as string
'-----------------------------------------------------------------------------
Function ReturnMonth:String(ServerMonth:Int)
	Local month:String
	
	'convert month short name to digit
	Select ServerMonth
		Case 1
			month="JANUARY"
		Case 2
			month="FEBRUARY"
		Case 3
			month="MARCH"
		Case 4
			month="APRIL"
		Case 5
			month="MAY"
		Case 6
			month="JUNE"
		Case 7
			month="JULY"
		Case 8
			month="AUGUST"
		Case 9
			month="SEPTEMBER"
		Case 10
			month="OCTOBER"
		Case 11
			month="NOVEMBER"
		Case 12
			month="DECEMBER"
	End Select
	
	Return month

End Function

'-----------------------------------------------------------------------------
'Center text on-screen (Kept around for Backward Compatibility)
'-----------------------------------------------------------------------------
Function DrawTextCentered(text$,x#,y#)
	'Local xs#,ys#
	'GetScale(xs,ys)
	'Local w# = TextWidth(text)*ys
	BoldFont.Draw(text,x,y,True)
End Function

'-----------------------------------------------------------------------------
'Count the number of Screenshots in the folder
'-----------------------------------------------------------------------------
Function GetScreenShotNumber:Int()
	?Win32
	Local dir=ReadDir(CurrentDir())
	?
	?MacOS
	Local dir=ReadDir(GetUserHomeDir()+"/Pictures/Invaders Corruption")
	?
	Local DirContents:String
	Local NumberCount:Int
	Local DirLen:Int
	?Win32
	DirLen=31
	?
	?MacOS
	DirLen=20
	?
	
	If Dir
		Repeat 
			DirContents=NextFile(Dir)
			If Upper(Right(DirContents,4))=".PNG"
				If Len(DirContents)=DirLen
					?Win32
					If Upper(Left(DirContents,22))="CORRUPTION_SCREENSHOT_"
						If Int(Mid(DirContents,23,5))>NumberCount Then NumberCount=Int(Mid(DirContents,23,5))
					?
					?MacOS
					If Upper(Left(DirContents,11))="SCREENSHOT_"
						If Int(Mid(DirContents,12,5))>NumberCount Then NumberCount=Int(Mid(DirContents,12,5))
					?	
					End If
				End If
			End If
			If DirContents="" Then Exit
		Forever
	End If
	
	ScreenShotNumber=NumberCount
	
End Function
'-----------------------------------------------------------------------------
'Save a screenshot
'-----------------------------------------------------------------------------
Function Screenshot:Int()

	ScreenshotNumber:+1
	Local p:TPixmap = GrabPixmap( 0, 0, RealWidth, RealHeight )
	
	?MacOS
	Local DirExists:Byte
	Local DirCreated:Byte
	Try
		ChangeDir "./"
		DirExists=ChangeDir(GetUserHomeDir()+"/Pictures/Invaders Corruption")

		If Not DirExists
			DirCreated=CreateDir(GetUserHomeDir()+"/Pictures/Invaders Corruption")
		End If
		
		If DirCreated=False And DirExists=False Then Throw "NoDir"
		
	Catch NoDir$
		
		RuntimeError("Couldn't create screnshot-directory:~n"+GetUserHomeDir()+"/Pictures/Invaders Corruption")
		End
	
	End Try
	Local filename:String = GetUserHomeDir()+"/Pictures/Invaders Corruption/screenshot_"+PadWithZeros(ScreenshotNumber,5)+".png"
	?
	?Win32
	Local filename:String = "corruption_screenshot_"+PadWithZeros(ScreenshotNumber,5)+".png"	
	?
	
	SavePixmapPNG( p, filename, 2 )
	p=Null
	Return Null
End Function
'-----------------------------------------------------------------------------
'Sanitize strings, just in case to deter hacking attempts
'-----------------------------------------------------------------------------
Function SanitizeInput:String(InputString:String,Truncate:Int=20,IsUniqueID=False)
	
	If IsUniqueID
		InputString=Trim(InputString)
		For Local i=1 To Len(InputString)
			If Asc(Mid(InputString,i,1))<32
				InputString=Replace(InputString,Mid(InputString,i,1),"*")
			End If
			If Asc(Mid(InputString,i,1))>32 And Asc(Mid(InputString,i,1))<48
				InputString=Replace(InputString,Mid(InputString,i,1),"*")
			End If
			If Asc(Mid(InputString,i,1))>57 And Asc(Mid(InputString,i,1))<65
				InputString=Replace(InputString,Mid(InputString,i,1),"*")
			End If
			If Asc(Mid(InputString,i,1))>90 And Asc(Mid(InputString,i,1))<97
				InputString=Replace(InputString,Mid(InputString,i,1),"*")
			End If
			If Asc(Mid(InputString,i,1))>122
				InputString=Replace(InputString,Mid(InputString,i,1),"*")
			End If
		Next
	Else
		InputString=Upper(Trim(InputString))
		For Local i=1 To Len(InputString)
			If Asc(Mid(InputString,i,1))<32
				InputString=Replace(InputString,Mid(InputString,i,1),"*")
			End If
			If Asc(Mid(InputString,i,1))>32 And Asc(Mid(InputString,i,1))<48
				InputString=Replace(InputString,Mid(InputString,i,1),"*")
			End If
			If Asc(Mid(InputString,i,1))>57 And Asc(Mid(InputString,i,1))<65
				InputString=Replace(InputString,Mid(InputString,i,1),"*")
			End If
			If Asc(Mid(InputString,i,1))>90
				InputString=Replace(InputString,Mid(InputString,i,1),"*")
			End If
		Next
	End If
	InputString=Replace(InputString,"*","")
	inputString=Left(InputString,Truncate)
	Return InputString
End Function
'-----------------------------------------------------------------------------
'Get Player's name for the Highscore Table
'-----------------------------------------------------------------------------
Function GetInput(x:Float,y:Float,InputChar:String Var,MaxLength:Int=20)	
	Global LastDeletion:Int
	
	If InputChar.length <= MaxLength Then
			
		' Check for alpha keys.
		For Local Count:Int = KEY_A To KEY_Z
			If KeyHit(Count) Then InputChar = InputChar + Chr(Count)
		Next
		
		' Check for number key hits
		For Local Count:Int = KEY_0 To KEY_9
			If KeyHit(Count) Then InputChar = InputChar + Chr(Count)
		Next
		
		' Special case, check for space bar
		If KeyHit(KEY_SPACE)
			InputChar = InputChar + " "
		EndIf
	Else

	End If	
	Rem
	If KeyHit(KEY_BACKSPACE)
		If  MilliSecs()-LastDeletion>105
			If Len(InputChar) > 0
				'FlushKeys()
				LastDeletion=MilliSecs()
				InputChar = Mid(InputChar,0,Len(InputChar))
			EndIf
		Else
			'FlushKeys()
		End If
	EndIf
	End Rem

	' Remove a character when user hits backspace.
	If KeyHit(KEY_BACKSPACE)
		If Len(InputChar) > 0
			FlushKeys()
			InputChar = Mid(InputChar,0,Len(InputChar))
		EndIf
	EndIf
	
	If KeyHit(KEY_DELETE)
		InputChar=""
		FlushKeys()
	End If
	
	'A rather crude way to "blink" the cursor to show that we want input
	If MilliSecs()-CursorInterval>300 Then 
		DrawTextCentered InputChar+"_",x,y
		If MilliSecs()-CursorInterval>600 Then CursorInterval=MilliSecs()
	Else 
		DrawTextCentered InputChar+" ",x,y	
	End If
	
End Function

'-----------------------------------------------------------------------------
' SetIcon: Uses Windows API call to set the window icon
'-----------------------------------------------------------------------------
Function SetIcon(iconname$, TheWindow%)	
	?Win32
	Local icon%=ExtractIconA(TheWindow,iconname,0)
	Const WM_SETICON% = $80
'	Const ICON_SMALL% = 0
	Const ICON_BIG% = 1
'	sendmessage(TheWindow, WM_SETICON, ICON_SMALL, icon) 'don't need this
	sendmessage(TheWindow, WM_SETICON, ICON_BIG, icon)
'	SetClassLongA(TheWindow,-14,icon) 'Obsolete as it doesn't work with Windows XP Theme!
	?
End Function


'-----------------------------------------------------------------------------
' Removes and Refreshes all game relevant Types and Objects
'-----------------------------------------------------------------------------
Function TypeDestroy(Absolute:Byte=False)
	
	If Absolute
		For Local i=0 To Spinner.Variations
			Spinner.SpinnerGlow[i]=Null
			Spinner.SpinnerBody[i]=Null
		Next
		
		For Local i=0 To TCorruptionNode.Variations
			CorruptionNode.CorruptionNodeGlow[i]=Null
			CorruptionNode.CorruptionNodeBody[i]=Null
		Next 
	
		For Local i=0 To Invader.Variations
			Invader.InvaderBody[i]=Null
			Invader.InvaderGlow[i]=Null
		Next
		
		For Local i=0 To Asteroid.Variations
			Asteroid.AsteroidBody[i]=Null
			Asteroid.AsteroidGlow[i]=Null
			Asteroid.SmallAsteroidBody[i]=Null
			Asteroid.SmallAsteroidGlow[i]=Null
		Next
		
		For Local i=0 To Minelayer.Variations
			MineLayer.MineLayerBody[i]=Null
			MineLayer.MineLayerGlow[i]=Null
			MineLayer.MineLayerBodyHit[i]=Null
		Next
		
		For Local i=0 To Mine.Variations
			Mine.MineBody[i]=Null
			Mine.MineGlow[i]=Null
		Next
		
		For Local i=0 To Chaser.Variations
			Chaser.ChaserBody[i]=Null
			Chaser.ChaserGlow[i]=Null
		Next
		
		For Local i=0 To Thief.Variations
			Thief.ThiefBody[i]=Null
			Thief.ThiefGlow[i]=Null
			Thief.ThiefBodyHit[i]=Null
		Next
		
		For Local i=0 To Snake.Variations
			Snake.SnakeBody[i]=Null
			Snake.SnakeBodyGlow[i]=Null
			Snake.SnakeHead[i]=Null
			Snake.SnakeHeadGlow[i]=Null
		Next
		
		For Local i=0 To Boid.Variations
			Boid.BoidBody[i]=Null
			Boid.BoidGlow[i]=Null
			Boid.BoidHit[i]=Null
		Next
		
		For Local i=0 To CorruptedInvader.Variations
			CorruptedInvader.CorruptedInvaderBody[i]=Null
			CorruptedInvader.CorruptedInvaderGlow[i]=Null
		Next
		
		For Local i=0 To CorruptionNode.Variations
			CorruptionNode.CorruptionNodeBody[i]=Null
			CorruptionNode.CorruptionNodeGlow[i]=Null
		Next
		
		For Local i=0 To Corruption.Variations
			Corruption.CorruptionBody[i]=Null
			Corruption.CorruptionGlow[i]=Null
		Next
	
		For Local i=0 To DataProbe.Variations
			DataProbe.ProbeBody[i]=Null
			DataProbe.ProbeGlow[i]=Null
			DataProbe.ProbeLaunch[i]=Null
		Next
	End If
	
	'GlowManager.ResetAll()
	
	'MotionBlur.ResetAll()
	
	'ShotGhost.ResetAll()
	
	'Thrust.ResetAll()
	
	If ParticleManager.List
		If ParticleManager.List.Count()>0
			For Local Particle:ParticleManager = EachIn ParticleManager.List
				Particle.Destroy()
			Next
		End If
	End If
	
	If TLightning.List
		If TLightning.List.Count()>0
			For Local Lightning:TLightning = EachIn TLightning.List
				Lightning.Destroy()
			Next
		End If
	End If
	
	If TCorruption.List
		Corruption.Reset()
	End If
	
	If TCorruptionNode.List
		If TCorruptionNode.List.Count()>0
			For Local CorruptionNode:TCorruptionNode = EachIn TCorruptionNode.List
				CorruptionNode.Destroy()
			Next
		End If
		'TReacher.List=Null
	End If
	
	If TDataProbe.List
		If TDataProbe.List.Count()>0
			For Local DataProbe:TDataProbe = EachIn TDataProbe.List
				DataProbe.Destroy()
			Next
		End If
	End If
	
	
	If TCorruptedInvader.List
		If TCorruptedInvader.List.Count()>0
			For Local CorruptedInvader:TCorruptedInvader = EachIn TCorruptedInvader.List
				CorruptedInvader.Destroy()
			Next
		End If
		'TReacher.List=Null
	End If
	
	'If TReacher.List
	'	If TReacher.List.Count()>0
	'		For Local Reacher:TReacher = EachIn TReacher.List
	'			Reacher.Destroy()
	'		Next
	'	End If
	'	'TReacher.List=Null
	'End If
	
	If TInvader.List
		If TInvader.List.Count()>0
			For Local Invader:TInvader = EachIn TInvader.List
				Invader.Destroy()
			Next
		End If
		'TInvader.List=Null
	End If
	
	If TSpinner.List
		If TSpinner.List.Count()>0
			For Local Spinner:TSpinner = EachIn TSpinner.List
				Spinner.Destroy()
			Next
		End If
		'TSpinner.List=Null
	End If
		
	If TSnake.List
		If TSnake.List.Count()>0
			For Local Snake:TSnake = EachIn TSnake.List
				Snake.Destroy()
			Next
		End If
		'TSnake.List=Null
	End If
	
	If TChaser.List
		If TChaser.List.Count()>0
			For Local Chaser:TChaser = EachIn TChaser.List
				Chaser.Destroy()
			Next
		End If
		'TChaser.List=Null
	End If

	If TMineLayer.List
		If TMineLayer.List.Count()>0
			For Local MineLayer:TMineLayer = EachIn TMineLayer.List
				MineLayer.Destroy()
			Next
		End If
		'TMineLayer.List=Null
	End If

	If TMine.List
		If TMine.List.Count()>0
			For Local Mine:TMine = EachIn TMine.List
				Mine.Destroy()
			Next
		End If
		'TMine.List=Null
	End If

	If TAsteroid.List
		If TAsteroid.List.Count()>0
			For Local Asteroid:TAsteroid = EachIn TAsteroid.List
				Asteroid.Destroy()
			Next
		End If
		'TAsteroid.List=Null
	End If
	
	If TBoid.List
		If TBoid.List.Count()>0
			For Local Boid:TBoid = EachIn TBoid.List
				Boid.Destroy()
			Next
		End If
		'TBoid.List=Null
	End If
	
	If TThief.List
		If TThief.List.Count()>0
			For Local Thief:TThief = EachIn TThief.List
				Thief.Destroy()
			Next
		End If
		'TThief.List=Null
	End If
	
	If TSpawnQueue.List
		If TSpawnQueue.List.Count()>0
			For Local SpawnQueue:TSpawnQueue = EachIn TSpawnQueue.List
				SpawnQueue.Destroy()
			Next
		End If
		'TSpawnQueue.List=Null
	End If

	If TMotionBlur.List
		If TMotionBlur.List.Count()>0
			For Local MotionBlur:TMotionBlur = EachIn TMotionBlur.List
				MotionBlur.Destroy()
			Next
		End If
		'TMotionBlur.List=Null
	End If
	Rem
	If TCorruptionEffect.List
		If TCorruptionEffect.List.Count()>0
			For Local CorruptionEffect:TCorruptionEffect = EachIn TCorruptionEffect.List
				CorruptionEffect.Destroy()
			Next
		End If
		'TCorruptionEffect.List=Null
	End If
	End Rem
	'If TDataNode.List
	'	If TDataNode.List.Count()>0
	'		For Local DataNode:TDataNode = EachIn TDataNode.List
	'			DataNode.Destroy()
	'		Next
	'	End If
	'	'TDataNode.List=Null
	'End If

	If TPlayerBomb.List
		If TPlayerBomb.List.Count()>0
			For Local PlayerBomb:TPlayerBomb = EachIn TPlayerBomb.List
				PlayerBomb.Destroy()
			Next
		End If
		'TPlayerBomb.List=Null
	End If
	
	If TSpawnEffect.List
		If TSpawnEffect.List.Count()>0
			For Local SpawnEffect:TSpawnEffect = EachIn TSpawnEffect.List
				SpawnEffect.Destroy()
			Next
		End If
		'TSpawnEffect.List=Null
	End If

	If TShot.List		
		If TShot.List.Count()>0
			For Local Shot:TShot = EachIn TShot.List
				Shot.Destroy()
			Next
		End If
		'TShot.List=Null
	End If
	
	If TPlayerShip.List
		If TPlayerShip.List.Count()>0
			For Local Player:TPlayerShip = EachIn TPlayerShip.List
				Player.Destroy()
			Next
		End If
		'TPlayerShip.List=Null
	End If
	
	If TScoreRegister.List
		If TScoreRegister.List.Count()>0
			For Local Score:TScoreRegister = EachIn TScoreRegister.List
				Score.Destroy()
			Next
		End If
		'TScoreRegister.List=Null
	End If
	
	If TExplosion.List
		If TExplosion.List.Count()>0
			For Local Explosion:TExplosion = EachIn TExplosion.List
				Explosion.Destroy()
			Next
		End If
		'TExplosion.List=Null
	End If

	If TThrust.List
		If TThrust.List.Count()>0
			For Local Thrust:TThrust = EachIn TThrust.List
				Thrust.Destroy()
			Next
		End If
		'TThrust.List=Null
	End If

	If TShotGhost.List
		If TShotGhost.List.Count()>0
			For Local ShotGhost:TShotGhost = EachIn TShotGhost.List
				ShotGhost.Destroy()
			Next
		End If
		'TShotGhost.List=Null
	End If

	If TGlow.List
		If TGlow.List.Count()>0
			For Local Glow:TGlow = EachIn TGlow.List
				Glow.Destroy()
			Next
		End If
		'TGlow.List=Null
	End If

	If TFlash.List
		If TFlash.List.Count()>0
			For Local Flash:TFlash = EachIn TFlash.List
				Flash.Destroy()
			Next
		End If
		'TFlash.List=Null
	End If
	
	If TShockWave.List
		If TShockWave.List.Count()>0
			For Local ShockWave:TShockWave = EachIn TShockWave.List
				ShockWave.Destroy()
			Next
		End If
		'TShockWave.List=Null
	End If
	
	If TPowerUp.List
		If TPowerUp.List.Count()>0
			For Local PowerUp:TPowerUp = EachIn TPowerUp.List
				PowerUp.Destroy()
			Next
		End If
		'PowerUp.List=Null
	End If
	
	GCCollect()
	
End Function

'-----------------------------------------------------------------------------
' Handles the Pause Mode and Pause Mode Key Input as other Keys are not read
'-----------------------------------------------------------------------------
Function DoPause()
	
	'DebugKeys()
	
	If GameState=Pause And KeyHit(KEY_ESCAPE) 
			FixedRateLogic.SetFPS(PreviousFPS)
			FixedRateLogic.CalcMS()
			FlushKeys()
			FlushMouse()
			HideMouse()
			FlushJoy()
			Player.Invincible=False
			GameState=Playing
			If RemainingSlowMo<>0 Then
				Player.HasSlowMotion=MilliSecs()+RemainingSlowMo
				RemainingSlowMo=0
			End If
			If HasSuperShotPause<>0 Then
				Player.HasSuper=MilliSecs()+HasSuperShotPause
				HasSuperShotPause=0
			End If
			If HasBouncyShotPause<>0 Then
				Player.HasBounce=MilliSecs()+HasBouncyShotPause
				HasBouncyShotPause=0
			End If
			If HasFrenzyPause<>0 Then
				FrenzyMode=MilliSecs()+HasFrenzyPause
				HasFrenzyPause=0
			End If
			If WipeOutOncePause<>0
				WipeOutOnce=MilliSecs()+WipeOutOncePause
				WipeOutOncePause=0
			End If
			LastDifficultyChange=MilliSecs()-DifficultyUpgradePause
			PlaySecs:+(MilliSecs()-PauseSecs)
			AutoPause=False
			SoundMute=PreviousSoundMute
	End If
	
	If GameState=Pause
		DoInput()
	End If
	
	If Not MainMenu.WaitingForInput And TYPING=False
		If KeyHit(KEY_P) Then
			If GameState=PAUSE Then
				HideMouse()
				SoundMute=PreviousSoundMute
				'ResumeChannel(MusicChannel_One)
				'ResumeChannel(MusicChannel_Two)
				FixedRateLogic.SetFPS(PreviousFPS)
				FixedRateLogic.CalcMS()
				FlushKeys()
				FlushMouse()
				FlushJoy()
				Player.Invincible=False
				GameState=Playing
				LastDifficultyChange=MilliSecs()-DifficultyUpgradePause
				Player.LastGunPickup=MilliSecs()-GunPickupPause
				If RemainingSlowMo<>0 Then
					Player.HasSlowMotion=MilliSecs()+RemainingSlowMo
					RemainingSlowMo=0
				End If
				If HasSuperShotPause<>0 Then
					Player.HasSuper=MilliSecs()+HasSuperShotPause
					HasSuperShotPause=0
				End If
				If HasBouncyShotPause<>0 Then
					Player.HasBounce=MilliSecs()+HasBouncyShotPause
					HasBouncyShotPause=0
				End If
				If HasFrenzyPause<>0 Then
					FrenzyMode=MilliSecs()+HasFrenzyPause
					HasFrenzyPause=0
				End If
				If WipeOutOncePause<>0
					WipeOutOnce=MilliSecs()+WipeOutOncePause
					WipeOutOncePause=0
				End If
				'PlaySecs=MilliSecs()
				PlaySecs:+(MilliSecs()-PauseSecs)
				AutoPause=False
			ElseIf GameState=PLAYING
				GCCollect()
				If Not FullScreen ShowMouse()
				AutoPause=False
				PreviousFPS=FixedRateLogic.FrameRate
				FixedRateLogic.SetFPS(0)
				FixedRateLogic.CalcMS()
				GameState=Pause
				PauseSecs=MilliSecs()
				GunPickupPause=MilliSecs()-Player.LastGunPickup
				DifficultyUpgradePause=MilliSecs()-LastDifficultyChange
				If Player.HasSlowmotion<>-1 Then
					RemainingSlowMo=Player.HasSlowMotion-MilliSecs()
				End If
				If Player.HasBounce<>0 Then
					HasBouncyShotPause=Player.HasBounce-MilliSecs()
				End If
				If Player.HasSuper<>0 Then
					HasSuperShotPause=Player.HasSuper-MilliSecs()
				End If
				If FrenzyMode<>0 Then
					HasFrenzyPause=FrenzyMode-MilliSecs()
				End If
				If WipeOutOnce<>0
					WipeOutOncePause=WipeOutOnce-MilliSecs()
				End If
				PreviousSoundMute=SoundMute
				SoundMute=1
				'PauseChannel(MusicChannel_One)
				'PauseChannel(MusicChannel_Two)
			End If
		End If
	End If
End Function

'------------------------------------------------------------------------------------------
'Function TogglePause() Pauses the game after fullscreen toggle to prevent uncessary deaths
'------------------------------------------------------------------------------------------
Function TogglePause()
	GCCollect()
	If GameState<>PLAYING Return
	AutoPause=True
	PreviousSoundMute=SoundMute
	SoundMute=1
	If WipeOutOnce<>0
		WipeOutOncePause=WipeOutOnce-MilliSecs()
	End If
	PreviousFPS=FixedRateLogic.FrameRate
	FixedRateLogic.SetFPS(0)
	FixedRateLogic.CalcMS()
	If Player.HasSlowmotion<>-1 Then
		RemainingSlowMo=Player.HasSlowMotion-MilliSecs()
	End If
	GameState=Pause
	FlushKeys()
	FlushMouse()
	FlushJoy()
	PauseSecs=MilliSecs()
End Function

'-----------------------------------------------------------------------------
'Function AnyInput() Tests for any key hit or any mouse button hit
'-----------------------------------------------------------------------------
Function AnyInput:Int()
	If AnyKeyPressed() Or MouseHit(1) Or MouseHit(2) Or MouseHit(3) Then
		Return 1
	Else
		Return 0
	EndIf
End Function

'-----------------------------------------------------------------------------
'Function AnyKeyPressed() Tests if any key has been hit
'-----------------------------------------------------------------------------
Function AnyKeyPressed:Int()
	For Local i% = 0 To 255		
		If KeyHit(i) Then Return 1
	Next
	Return 0

End Function


'-----------------------------------------------------------------------------
'External Functions for Windows, enable Windows(TM) Specific Behavior
'-----------------------------------------------------------------------------
Extern "win32"
	Function SendMessage%(hWnd%,MSG%,wParam%,lParam%) = "SendMessageA@16"
End Extern
?

'-----------------------------------------------------------------------------
'RC4 Encryption for Highscores!
'-----------------------------------------------------------------------------
Function RC4:String(inp$, key$)
    
	'If there is nothing to encode return, otherwise we might be writing a null byte
	If Len(inp$)<=0 Or inp$="" Return

	Local S%[512+Ceil(inp.Length*.55)]
	Local i%, j%, t%, x%
	Local outbuf@@ Ptr = Short Ptr(Varptr s[512])
    
	
    j = 0
    For i = 0 To 255
        S[i] = i
        If j > (Key.length-1) Then
            j = 0
        EndIf
        S[256+i] = key[j]&$ff
        j:+ 1
    Next
    
    j = 0
    For i = 0 To 255
        j = (j + S[i] + S[256+i]) & $ff
        t = S[i]
        S[i] = S[j]
        S[j] = t
    Next
    
    i = 0
    j = 0
    For Local x% = 0 To inp.Length-1
        i = (i + 1) & $ff
        j = (j + S[i]) & $ff
        t = S[i]
        S[i] = S[j]
        S[j] = t
        t = (S[i] + S[j]) & $ff
        outbuf[x] = (inp[x] ~ S[t])
    Next
    
    Return String.FromShorts(outbuf, inp.Length)
End Function

' -----------------------------------------------------------------------------
' File CRC Checker
' -----------------------------------------------------------------------------
Function CRC:Int(FileName:String, bufferSize:Int=$40000) 'default bufferSize = 400KB
	Local crc = $FFFFFFFF
	Global CRCTable[]
	
	If CRCTable = Null
		CRCTable = New Int[256]
	
	  For Local i=0 To 255
	    Local value = i
	    For Local j=0 To 7
	      If value & $1 
	        value = (value Shr 1) ~ $EDB88320
	      Else
	        value = value Shr 1
	      EndIf
	    Next
	    CRCTable[i] = value
	  Next
	EndIf
	
  Local fileStream:TStream = ReadStream(fileName$)
  If fileStream = Null Then Return
  
	Local buffPtr:Byte Ptr = MemAlloc(bufferSize)
	'Print "StreamSize:"+StreamSize(filestream)
	Repeat
		'Print StreamPos(filestream)
		
		Local bytesRead = fileStream.Read(buffPtr, bufferSize)
		'Basically don't read the last 34 bytes of the score file
		BytesRead:-34
		'Print "BytesRead:"+BytesRead
		For Local b=0 Until bytesRead
			crc = (crc Shr 8) ~ CRCTable[buffPtr[b] ~ (crc & $FF)]
			
		Next
	Until Eof(FileStream)
	
	CloseStream FileStream
	MemFree(buffPtr)
	
	'Print "CRC: "+~crc
	
	Return ~crc
End Function

' -----------------------------------------------------------------------------
' PadWithZeros: Pad a string with zeros (on the left) to a set length
' -----------------------------------------------------------------------------
Function PadWithZeros:String(TheText$, NumDigits%)
	'this does not truncate, only enlarges or does nothing
	While Len(TheText) < NumDigits 
		TheText = "0" + TheText
	Wend
	Return TheText
End Function

' -----------------------------------------------------------------------------
' Generate checksummed ASCII string for the server
' -----------------------------------------------------------------------------
Function AscList:String(InputString:String)
	
	Local TempString:String, ReturnString:String, CheckSum:Int, Result:String
	
	For Local i=1 To Len InputString
	
		TempString=PadWithZeros(Asc(Mid$(InputString,i,1)),3)
		ReturnString:+TempString
		CheckSum:+Int(TempString)
	
	Next
	
	ReturnString:+PadWithZeros(CheckSum,8)
	
	Return ReturnString
	
End Function

'-----------------------------------------------------------------------------
' Multicolored line connecting two enemies
'-----------------------------------------------------------------------------
Function DrawMultiColorLines(x0:Float , y0:Float , x1:Float , y1:Float , rgb0:Byte[] , rgb1:Byte[]) 
	glDisable GL_TEXTURE_2D
	glBegin GL_LINES
	glColor3ub(rgb0[0] , rgb0[1] , rgb0[2]) 
	glVertex2f(x0,y0)
	glColor3ub(rgb1[0] , rgb1[1] , rgb1[2]) 
	glVertex2f(x1 , y1)		
	glEnd
	glEnable GL_TEXTURE_2D
	glColor3ub(255,255,255)
End Function

'-----------------------------------------------------------------------------
' How many needed to turn, to face a certain point.
'-----------------------------------------------------------------------------
Function TurnToAim:Int(angle1:Float,angle2:Float)

	Local ret:Int

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

'-----------------------------------------------------------------------------
' How many needed to turn, to face a certain point.
'-----------------------------------------------------------------------------
Function TurnToFacePoint:Int(targetx#,targety#,x#,y#, XSpeed#, YSpeed#)

	Local angle1#, angle2#, ret:Int
	
	angle1 = ATan2(targety-y,targetx-x)
	angle2 = ATan2(YSpeed,XSpeed)
	
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

'-----------------------------------------------------------------------------
' Is a point X in the specified Triangle?
'-----------------------------------------------------------------------------
Function InTriangle:Byte(x0#,y0#,x1#,y1#,x2#,y2#,x3#,y3#)
	Local b0#,b1#,b2#,b3#
	
	b0# =  (x2 - x1) * (y3 - y1) - (x3 - x1) * (y2 - y1)
	b1# = ((x2 - x0) * (y3 - y0) - (x3 - x0) * (y2 - y0)) / b0 
	If b1 <= 0 Then Return False
	
	b2# = ((x3 - x0) * (y1 - y0) - (x1 - x0) * (y3 - y0)) / b0
	If b2 <= 0 Then Return False

	b3# = ((x1 - x0) * (y2 - y0) - (x2 - x0) * (y1 - y0)) / b0 
	If b3 <= 0 Then Return False
	
	Return True

End Function

'-----------------------------------------------------------------------------
' GenerateColor Generates Colors within a preset local/global gamut/treshold
'-----------------------------------------------------------------------------
Function GenerateColor:Int(Color:Int[] Var,MinColor:Int,MaxColor:Int,SaturationOverride:Float=-1,BrightnessOverride:Float=-1,Treshold:Float=.15)
	
	For Local i=0 To 2
		Color[i]=Rand(MinColor,MaxColor)
	Next
	
	RGB_to_HSL(Color[0],Color[1],Color[2])
	
	If GlobalBrightness<>-1
		If Result_B>GlobalBrightness-Treshold Or Result_B<GlobalBrightness+Treshold
			Result_B=(Result_B+GlobalBrightness*3)/4 '4x weighted average
		End If
	End If
	
	If BrightnessOverride<>-1
		If Result_B>BrightnessOverride-Treshold Or Result_B<BrightnessOverride+Treshold
			Result_B=(Result_B+BrightnessOverride*3)/4 '4x weighted average
		End If
	End If
	
	If GlobalSaturation<>-1
		If Result_S>GlobalSaturation-Treshold Or Result_S<GlobalSaturation+Treshold
			Result_S=(Result_S+GlobalSaturation*3)/4 '4x weighted average
		End If
	End If
	
	If SaturationOverride<>-1
		If Result_S>SaturationOverride-Treshold Or Result_S<SaturationOverride+Treshold
			Result_S=(Result_S+SaturationOverride*3)/4 '4x weighted average
		End If
	End If
	
	If EasterEgg>0
		'Desaturate All Colors
		Result_S=0
	End If
	
	HSL_to_RGB(Result_H,Result_S,Result_L)
	
	Color[0]=Result_R
	Color[1]=Result_G
	Color[2]=Result_B
	
End Function

'-----------------------------------------------------------------------------
' Setcolor Modification to cater for Eastereggs and other special effects
'-----------------------------------------------------------------------------
Function SetColor(r:Int,g:Int,b:Int)
	
	'Color Value Sanity Checks (0-255 Range Only)
	Rem
	If r>255
		r=255
	ElseIf r<0
		r=0
	End If
	
	If g>255
		g=255
	ElseIf g<0
		g=0
	End If
	
	If b>255
		b=255
	ElseIf b<0
		b=0
	End If
	End Rem
	
	If Not EasterEgg
		Brl.Max2D.SetColor r,g,b
	ElseIf EasterEgg=1
		If r=255 And b=255 And g=255
			Brl.Max2D.SetColor 90,255,100
		Else
			RGB_to_HSL(R,G,B)
			
			If Result_S<0.2 Then Result_S=.4
			
			HSL_to_RGB(124.705879,Result_S,Result_L)
			
			Brl.Max2D.SetColor Result_R,Result_G,Result_B	
		End If
	ElseIf EasterEgg=2
		RGB_to_HSL(R,G,B)
			
		HSL_to_RGB(Result_H,0,Result_L)
			
		Brl.Max2D.SetColor Result_R,Result_G,Result_B	
	EndIf
	
End Function

'-----------------------------------------------------------------------------
' Converts from RGB to HSL Color Space
'-----------------------------------------------------------------------------
Function RGB_to_HSL(ir%, ig%, ib%)
	Local r:Float,g:Float,b:Float
	Local Max_is:Float, Max_color:Float, Min_color:Float
	Local deltacolor:Float
	' Scale RGB down To unit range (0-1).
	r# = ir/255.0
	g# = ig/255.0
	b# = ib/255.0
	
	If r > g
		max_is = 0
		max_color# = r
		min_color# = g
	Else
		max_is = 1
		max_color# = g
		min_color# = r
	EndIf
	
	If b > max_color
		max_is = 2
		max_color = b
	ElseIf b < min_color
		min_color = b
	EndIf
	
	' Luminance.
	result_l = (max_color + min_color) / 2.0

	If max_color = min_color
		' Color is grey.
		result_s = 0
		'result_h = 0
	Else
		deltacolor# = (max_color - min_color)

		' Saturation.
		If result_l < 0.5
			result_s = deltacolor / (max_color + min_color)
		Else
			result_s = deltacolor / (2.0 - max_color - min_color)
		EndIf
	
		' Hue.
		Select max_is
		Case 0
			' Red.
			result_h = (g - b) / Delta
		Case 1
			' Green.
			result_h = 2.0 + (b - r) / Delta
		Case 2
			' Blue.
			result_h = 4.0 + (r - g) / Delta
		End Select

		result_h = result_h * 60.0
		If result_h < 0 Then result_h = result_h + 360.0
	EndIf

End Function

'-----------------------------------------------------------------------------
' Converts from HSL to RGB Color Space
'-----------------------------------------------------------------------------
Function HSL_to_RGB(h#, s#, l#)
	Local rtemp:Float, gtemp:Float, btemp:Float
	Local rtemp2:Float, gtemp2:Float, btemp2:Float
	Local rtemp3:Float, gtemp3:Float, btemp3:Float
	Local temp1:Float,temp2:Float,temp3:Float
	
	If s = 0
		result_r# = l
		result_g# = l
		result_b# = l
	Else
		If l < 0.5
			temp2# = l * (1.0 + s)
		Else
			temp2# = (l + s) - (l * s)
		EndIf
		temp1# = 2.0 * l - temp2
		
		h = h / 360.0
		
		rtemp3# = h + 1.0 / 3.0
		If rtemp3 < 0
			rtemp3 = rtemp3 + 1.0
		ElseIf rtemp3 > 1
			rtemp3 = rtemp3 - 1.0
		EndIf

		gtemp3# = h
		If gtemp3 < 0
			gtemp3 = gtemp3 + 1.0
		ElseIf gtemp3 > 1
			gtemp3 = gtemp3 - 1.0
		EndIf

		btemp3# = h - 1.0 / 3.0
		If btemp3 < 0
			btemp3 = btemp3 + 1.0
		ElseIf btemp3 > 1
			btemp3 = btemp3 - 1.0
		EndIf
		
		' Set red.
		If (6.0 * rtemp3) < 1
			result_r# = temp1 + (temp2 - temp1) * 6.0 * rtemp3
		ElseIf (2.0 * rtemp3) < 1
			result_r# = temp2
		ElseIf (3.0 * rtemp3) < 2
			result_r# = temp1 + (temp2 - temp1) * ((2.0 / 3.0) - rtemp3) * 6.0
		Else
			result_r# = temp1
		EndIf

		' Set green.
		If (6.0 * gtemp3) < 1
			result_g# = temp1 + (temp2 - temp1) * 6.0 * gtemp3
		ElseIf (2.0 * gtemp3) < 1
			result_g# = temp2
		ElseIf (3.0 * gtemp3) < 2
			result_g# = temp1 + (temp2 - temp1) * ((2.0 / 3.0) - gtemp3) * 6.0
		Else
			result_g# = temp1
		EndIf

		' Set blue.
		If (6.0 * btemp3) < 1
			result_b# = temp1 + (temp2 - temp1) * 6.0 * btemp3
		ElseIf (2.0 * btemp3) < 1
			result_b# = temp2
		ElseIf (3.0 * btemp3) < 2
			result_b# = temp1 + (temp2 - temp1) * ((2.0 / 3.0) - btemp3) * 6.0
		Else
			result_b# = temp1
		EndIf
	EndIf

	' Scale RGB back To 0-255 range.
	' Remove this If you want To keep RGB in the range 0-1!
	result_r = result_r * 255
	result_g = result_g * 255
	result_b = result_b * 255

End Function

'-----------------------------------------------------------------------------
'Function InitW32() initializes and does some windows runtime mods
'-----------------------------------------------------------------------------
Function InitW32()
	'center the window so it is always in the same spot when starting up
	CentreWindow()
	?Win32
	Local hWnd% = GetActiveWindow()
	?
	'adds a minimize button to the window
	?Win32
	Local min_tmp:Long = GetWindowLongA( hWnd, GWL_STYLE )
	min_tmp = min_tmp | WS_MINIMIZEBOX
	SetWindowLongA( hWnd, GWL_STYLE, min_tmp )
	DrawMenuBar( hWnd )
	?
End Function

'-----------------------------------------------------------------------------
'Function GetBundleRessource allows OSX Bundles to work like a normal APP
'-----------------------------------------------------------------------------
?MacOS
'-- Returns the location of a resource contained in the app bundle
' @ resourceName : String - filename including filename extension
' @ subDirName   : String - subdirectory of the bundle’s resources directory
Function GetBundleResource:String(resourceName:String,chop=False, subDirName:String="")
	Local url:String
	If Chop=False
		url:+"zip::"
	End If
	
	If(subDirName) Then url :+ subDirName + "/"
	url:+ Left(AppFile, Instr(AppFile, ".app/", 0)) + "app/Contents/Resources/"
	
	If Chop=False
		url:+ "data.big//"+resourceName
	Else
		url:+ resourceName
	End If
	'If Chop Then url=Right(url,Len(url)-1)
	'Print url
	Return url
End Function
?

'-----------------------------------------------------------------------------
'Function GetBundleRessource allows Windows BIG File to Function
'-----------------------------------------------------------------------------
?Win32
'-- Returns the location of a resource contained in the app bundle
' @ resourceName : String - filename including filename extension
' @ subDirName   : String - subdirectory of the bundle’s resources directory
Function GetBundleResource:String(resourceName:String,chop=False, subDirName:String="")
	Local url:String
	'Local url:String = Left(AppFile, Instr(AppFile, ".app/", 0)) + "app/Contents/Resources/"
	'If(subDirName) Then url :+ subDirName + "/"
	'If Chop Then url=Right(url,Len(url)-1)
	url="zip::data.big//"+ resourceName
	'Print url
	Return url
End Function
?

'-----------------------------------------------------------------------------
'Function SetupKeyTable reads out the key names for the control setup
'-----------------------------------------------------------------------------
Function SetupKeyTable()
	
	Local TempString:String, DataPointer:Int
	
	RestoreData Keyboard_Scancodes
	
	Repeat
		ReadData TempString
		ReadData DataPointer
		KeyNames[DataPointer] = TempString
	Until DataPointer=299

End Function

'-------------------------------------------------------------------------------
'Function Cyclecolors cycles to various RGB colors to achieve the PowerUp Effect
'-------------------------------------------------------------------------------
Function CycleColors(CycleSpeed:Float=10)
		
	RCol = RCol + RColDelta/10*CycleSpeed
	
	Rem
	If RCol<80
		RCol=80
		RcolDelta=Rand(1,CycleSpeed)
	ElseIf RCol>255
		RCol=255
		RColDelta=-Rand(1,CycleSpeed)
	End If
	
	GCol = GCol + GColDelta/10*CycleSpeed
	
	If GCol<45
		GCol=45
		GColDelta=Rand(1,CycleSpeed)
	ElseIf GCol>255
		GCol=255
		GColDelta=-Rand(1,CycleSpeed)
	End If
	
	BCol = BCol + BColDelta/10*CycleSpeed
	
	If BCol<45
		BCol=45
		BColDelta=Rand(1,CycleSpeed)
	ElseIf BCol>255
		BCol=255
		BColDelta=-Rand(1,CycleSpeed)
	End If
	End Rem
	RCol = RCol + (RColDelta/10*CycleSpeed)
	
	If RCol<80
		RCol=80
		RcolDelta:*-1
	ElseIf RCol>255
		RCol=255
		RColDelta:*-1
	End If
	
	GCol = GCol + (GColDelta/10*CycleSpeed)
	
	If GCol<35
		GCol=35
		GColDelta:*-1
	ElseIf GCol>255
		GCol=255
		GColDelta:*-1
	End If
	
	BCol = BCol + (BColDelta/10*CycleSpeed)
	
	If BCol<45
		BCol=45
		BColDelta:*-1
	ElseIf BCol>255
		BCol=255
		BColDelta:*-1
	End If
	
End Function

'-------------------------------------------------------------------------------
'Function FastRect, draws a faster GL accelerated rectangle
'-------------------------------------------------------------------------------
Function FastRect(x%,y%,w%,h%)
	glVertex2f x,y ; glVertex2f x+w,y
	glVertex2f x+w,y+h ; glVertex2f x,y+h
End Function

'-------------------------------------------------------------------------------
'Function DrawOnPixmap - Enables to draw Images on Pixmaps
'-------------------------------------------------------------------------------
Function DrawOnPixmap(image:TImage, framenr:Int = 0, pixmap:TPixmap, x:Int, y:Int, alpha:Float = 1.0, colorize:Int = 0) 
	Local imagepix:TPixmap = Null
	
	If framenr = 0 imagepix = LockImage(image) 
	If framenr > 0 imagepix = LockImage(image, framenr)
	
	DrawPixmapOnPixmap(imagepix, framenr, pixmap, x, y, alpha, colorize) 
	
	If framenr = 0 UnlockImage(image) 
	If framenr > 0 UnlockImage(image, framenr) 
End Function

'-------------------------------------------------------------------------------
'Function PixmapOnPixmap - Pixmap Blending
'-------------------------------------------------------------------------------
Function DrawPixmapOnPixmap(imagepix:TPixmap, framenr:Int = 0, pixmap:TPixmap, x:Int, y:Int, alpha:Float = 1.0, colorize:Int = 0) 
	Local sourcepixel:Int 
	Local sourceA:Float 
	Local sourceR:Float 
	Local sourceG:Float 
	Local sourceB:Float 
	Local destpixel:Int
	Local destA:Float 
	Local destR:Float 
	Local destG:Float
	Local destB:Float
	Local Xalpha:Int 
	Local colorA:Float 
	Local colorR:Float 
	Local colorG:Float 
	Local colorB:Float 
	Local CLalpha:Float 
	
	Local w:Int = PixmapWidth(imagepix) - 1
	Local h:Int = PixmapHeight(imagepix) - 1
	Local i:Int
	Local j:Int
	
	For i = 0 To w 
		For j = 0 To h
			If x + i < pixmap.width And y + j < pixmap.Height
				
				'Source
				sourcepixel = ReadPixel(imagepix, i, j) 
				sourceA = ARGB_A(sourcepixel) * alpha
				If sourceA <> 0 Then
					sourceR = ARGB_R(sourcepixel) 
					sourceG = ARGB_G(sourcepixel) 
					sourceB = ARGB_B(sourcepixel)
					 
					'Colorize
					colorA = ARGB_A(colorize) 
					If colorA <> 0
						colorR = ARGB_R(colorize) 
						colorG = ARGB_G(colorize) 
						colorB = ARGB_B(colorize) 
						
						If colorA <> 255 Then
							sourceR = sourceR + ((colorR - sourceR) * colorA / 255)
							sourceG = sourceG + ((colorG - sourceG) * colorA / 255)
							sourceB = sourceB + ((colorB - sourceB) * colorA / 255)
						Else
							sourceR = colorR
							sourceG = colorG
							sourceB = colorB
						End If
					End If
					
					
					
					'Blend (if has alpha and is not transperant)
					'Xalpha = sourceA
					If sourceA <> 255 Then
						destpixel = ReadPixel(pixmap, x + i, y + j) 
						destA = ARGB_A(destpixel) 
						destR = ARGB_R(destpixel) 
						destG = ARGB_G(destpixel) 
						destB = ARGB_B(destpixel) 

						Xalpha = destA + sourceA
						
						sourceR = (sourceR * sourceA / Xalpha) + (destA / Xalpha * (destR * destA / Xalpha))
						sourceG = (sourceG * sourceA / Xalpha) + (destA / Xalpha * (destG * destA / Xalpha))
						sourceB = (sourceB * sourceA / Xalpha) + (destA / Xalpha * (destB * destA / Xalpha))
						If Xalpha > 255 Then Xalpha = 255
					EndIf
					
					If SourceR<10 And SourceG<10 And SourceB<10 Then Xalpha=0
					
					'If visable pixel
					WritePixel(Pixmap, x + i, y + j, ARGB(Xalpha, sourceR, sourceG, sourceB)) 
				End If
			EndIf
		Next
	Next
End Function
'-------------------------------------------------------------------------------
'Function ThreadLoop() - Loops the main loop during threading action
'-------------------------------------------------------------------------------
Function ThreadLoop()
	DoEventHooks()
	?MacOS
	Cls()
	?
	?Win32
	AspectCls()
	?

	FixedRateLogic.Calc()

	For Local i = 1 To Floor(FixedRateLogic.NumTicks)
  		FixedRateLogic.SetDelta(1)
		If GameState<>PAUSE GameTicks:+1
		ProcessMainMenu()
		ProcessHelp()
		DoFPSLogic()
		DoInput()
		DoAI()
		DoGame()

 	Next
	
	'let the other apps have a piece of the computing power cake
	If Not FullScreen
		Delay(4)
	Else
		Delay(1)
	End If
	'Is there a remaining bit in the Numticks float?
 	Local remainder# = FixedRateLogic.NumTicks Mod 1
	If remainder > 0 Then
 		FixedRateLogic.SetDelta(remainder)
		If GameState<>PAUSE GameTicks:+1
		ProcessMainMenu()
		ProcessHelp()
		DoFPSLogic()
		DoInput()
		DoAI()	
		DoGame()
		
 	EndIf
	DoPause()
	PerformDrawCalls()
	
	Flip VerticalSync
	If KeyHit(KEY_F8) And MainMenu.WaitingForInput=False Then ScreenShot()
	If ExitCode
		EndGraphics()
		OnEnd EndCleanUp
		DetachThread(Thread)
		End
	End If
End Function
'-------------------------------------------------------------------------------
'Function DrawOnPixmap - HELPERS
'-------------------------------------------------------------------------------
Function ARGB_R:Int(r:Int)
	Return (r Shr 16) & $FF
End Function

Function ARGB_G:Int(g:Int)
	Return (g Shr 8) & $FF
End Function

Function ARGB_B:Int(b:Int)
	Return b & $FF
End Function

Function ARGB_A:Int(a:Int) 
	Return (a Shr 24) & $FF
End Function

Function ARGB:Int(a:Int, r:Int, g:Int, b:Int) 
	Return Int(a * $1000000) + Int(r * $10000) + Int(g * $100) + Int(b)
End Function
'-------------------------------------------------------------------------------
'Function DrawOnPixmap - HELPERS END
'-------------------------------------------------------------------------------