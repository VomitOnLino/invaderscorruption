'-----------------------------------------------------------------------------
'The Main Menu
'-----------------------------------------------------------------------------
Type TMainMenu

	Global Option:String[16,11]
	Global OptionState:String[16,11]
	Global OptionAlpha:Float[16,11]
	Global OptionX:Int
	Global OptionY:Int=180
	Global OptionsNum:Int[]=[0,7,7,8,8,7,5,8,6,8,6]
	Global SubMenuTitle:String[16]
	Global OptionSelect:Int=0
	Global SoundOnce:Int=False
	Global OptionLevel:Int=1
	Global WaitingForInput:Int=False
	Global PreviousKey:Int
	Global PreviousScanCode:Int
	
	Global TitleOffset:Float
	Global GraphicsError:Byte
	
	Function Init()
			
		UpdateOptionStates()
		
		SubMenuTitle[2]="OPTIONS MENU "
		SubMenuTitle[3]="GRAPHIC DETAIL SETTINGS "
		SubMenuTitle[4]="PLAYER-CONTROL SETUP "
		SubMenuTitle[5]="SCREEN CONFIGURATION "
		SubMenuTitle[6]="SOUND & MUSIC SETTINGS "
		SubMenuTitle[7]="DEFINE CONTROL SCHEME "
		SubMenuTitle[8]="ON/OFFLINE HI-SCORES " 
		SubMenuTitle[9]="SELECT A RESOLUTION "
		SubMenuTitle[10]="DEFINE AIM CONTROLS " 
		
			
		Option[1,1]="ARENA SURVIVAL"
		'Option[2,1]="DATA DEFENSE"
		Option[3,1]="INFO/HOW TO PLAY"
		Option[4,1]="ON/OFFLINE SCORES"
		Option[5,1]="OPTIONS"
		Option[6,1]=""
		Option[7,1]="LEAVE"
		
		Option[1,2]="GRAPHIC DETAILS"
		Option[2,2]="SOUND SETTINGS"
		Option[3,2]="SCREEN SETUP"
		Option[4,2]="CONTROL SETUP"
		Option[5,2]="EDIT CORE-SEED"
		Option[6,2]=""
		Option[7,2]="BACK"
		
		Option[1,3]="FRAMEBUFFER EFFECTS"
		Option[2,3]="FRAMEBUFFER QUALITY"
		Option[3,3]="MOTION BLUR"
		Option[4,3]="BACKGROUND"
		Option[5,3]="PARTICLE AMOUNT"
		Option[6,3]="SCREEN SHAKE"
		Option[7,3]=""
		Option[8,3]="BACK"
		
		Option[1,4]="MAIN CONTROLLER"
		Option[2,4]="DEFINE CONTROL LAYOUT"
		Option[3,4]="RESTORE DEFAULTS"
		Option[4,4]="MOUSE SENSIVITY"
		Option[5,4]="JOY DEADZONE"
		Option[6,4]="CURSOR TYPE"
		Option[7,4]=""
		Option[8,4]="BACK"
		
		Option[1,5]="RESOLUTION"
		Option[2,5]="FULL-SCREEN MODE"
		Option[3,5]="WIDESCREEN"
		Option[4,5]="V-SYNC"
		Option[5,5]="BLACK LEVEL"
		Option[6,5]=""
		Option[7,5]="BACK"
		
		Option[1,6]="SOUND"
		Option[2,6]="MUSIC"
		Option[3,6]="SOUND"
		Option[4,6]=""
		Option[5,6]="BACK"
		

		Option[1,7]="MOVE UP"
		Option[2,7]="MOVE DOWN"
		option[3,7]="STRAFE LEFT"
		Option[4,7]="STRAFE RIGHT"
		Option[5,7]="FIRE CANNON"
		Option[6,7]="RELEASE BOMB"
		Option[7,7]=""
		Option[8,7]="BACK"

		Option[1,10]="AIM UP"
		Option[2,10]="AIM DOWN"
		Option[3,10]="AIM LEFT"
		Option[4,10]="AIM RIGHT"
		Option[5,10]=""
		Option[6,10]="BACK"	
				
		Option[1,8]="VIEW LOCAL HISCORES"
		Option[2,8]="RANK YOUR HISCORE [ONLINE]"
		Option[3,8]="ALL TIME TOP 20 [ONLINE]"
		Option[4,8]="MONTHLY TOP 20 [ONLINE]"
		Option[5,8]=""
		Option[6,8]="BACK"
		
		If WideScreen=False
			For Local i=0 To 5
				Option[i+1,9]=""
				If TallscreenWidth[i]=0 Then Continue
				Option[i+1,9]="SET "+TallScreenWidth[i]+"x"+TallScreenHeight[i]
				'Print "DipShit"
			Next
		Else
			For Local i=0 To 5
				Option[i+1,9]=""
				If WidescreenWidth[i]=0 Then Continue
				Option[i+1,9]="SET "+WideScreenWidth[i]+"x"+WideScreenHeight[i]
				'Print "AssHat"
			Next
		End If
		
		Option[7,9]=""
		Option[8,9]="BACK"
		
		ResetAlpha()
		
		OptionX:Int=ScreenWidth/2-387'332-55
	
	End Function
	
	Function ResetAlpha()
		For Local i=1 To 11
			For Local j=1 To 9
				OptionAlpha[i,j]=1
			Next
		Next
	End Function
	
	Function UpdateOptionStates()
		Local OnOff:String[2]
		OnOff[0]=" OFF"
		OnOff[1]=" ON"
		
		If InputMethod<4
			Option[7,7]=""
		Else
			Option[7,7]="DEFINE SECOND AXIS"
		End If
		
		If FullScreenGlow<>-1
			OptionState[1,3]=OnOff[FullScreenGlow]
		Else
			OptionState[1,3]=" NOT AVAILABLE"
		End If
		
		OptionState[5,2]=" "+Chr(39)+Seed+Chr(39)
		
		OptionState[2,5]=OnOff[FullScreen]
		
		'OptionState[3,3]=OnOff[MotionBlurEnable]
		Select MotionBlurEnable
			
			Case 0
				OptionState[3,3]=" OFF"
			Case 1
				OptionState[3,3]=" NORMAL"
			Case 2
				OptionState[3,3]=" HIGH"
		
		End Select
		
		If MotionBlurEnable<=1 Then
			BlurDivider=2.4
		ElseIf MotionBlurEnable=2
			BlurDivider=3.6
		End If

		OptionState[6,3]=OnOff[ScreenShakeEnable]
		
		If JoyDeadZoneAdjust>0
			OptionState[5,4]=" SIZE "+String(JoyDeadZoneAdjust)
		Else
			OptionState[5,4]=" OFF"
		End If
		
		If InputMethod<3
			OptionState[5,4]=" NOT AVAILABLE"
		End If
		
		OptionState[6,4]=" "+String(CrossHairType)
		
		OptionState[1,5]=" "+String(RealWidth)+"x"+String(RealHeight)
		
		OptionState[4,4]=" "+String(MouseSensivity)
		
		OptionState[3,5]=OnOff[WideScreen]
		
		If MusicVolInt>0
		
			OptionState[2,6]=" VOLUME "
			OptionState[2,6]:+String(Int(MusicVolInt))
		Else
			OptionState[2,6]=" OFF"
		End If
		
		If SoundVolInt>0
		
			OptionState[1,6]=" VOLUME "
			OptionState[1,6]:+String(Int(SoundVolInt))
		Else
			OptionState[1,6]=" OFF"
		End If
		
		If SoundVolInt>0
			SoundVol=Float(SoundVolInt)/100
		Else
			SoundVol=0
		End If
		
		If MusicVolInt>0
			MusicVol=Float(MusicVolInt)/100
		Else
			MusicVol=0
		End If
		
		For Local i=1 To 6
			OptionState[i,9]=""
		Next
		
		If WideScreen=False
			For Local i=0 To 5
				If TallScreenWidth[i]=RealWidth And TallScreenHeight[i]=RealHeight Then OptionState[i+1,9]=" [Current]"
			Next

		ElseIf WideScreen=True
			For Local i=0 To 5
				If WideScreenWidth[i]=RealWidth And WideScreenHeight[i]=RealHeight Then OptionState[i+1,9]=" [Current]"
			Next
			
		End If
		
		If WideScreen=False
			For Local i=0 To 5
				Option[i+1,9]=""
				If TallscreenWidth[i]=0 Then Continue
				Option[i+1,9]="SET "+TallScreenWidth[i]+"x"+TallScreenHeight[i]
				'Print "DipShit"
			Next
		Else
			For Local i=0 To 5
				Option[i+1,9]=""
				If WidescreenWidth[i]=0 Then Continue
				Option[i+1,9]="SET "+WideScreenWidth[i]+"x"+WideScreenHeight[i]
				'Print "AssHat"
			Next
		End If

		Select GlowQuality
			
			Case 256
				OptionState[2,3]=" Normal"
			
			Case 64
				OptionState[2,3]=" Blobby"
			
			Case 128
				OptionState[2,3]=" Coarse"
				
			Case 512
				OptionState[2,3]=" Fine"
			Case 768
				OptionState[2,3]=" Super Fine"
			Default
				OptionState[2,3]=" Custom"
		
		End Select
		
		If FullScreenGlow<=0
			OptionState[2,3]=" Not Available"
		End If
		
		Select ParticleMultiPlier
			
			Case 0.35
				OptionState[5,3]=" Minimal"
			Case 0.75
				OptionState[5,3]=" Reduced"
			Case 1
				OptionState[5,3]=" Normal"
			Case 1.4
				OptionState[5,3]=" High"
			Case 2.0
				OptionState[5,3]=" Insane"
			Default
				OptionState[5,3]=" Custom"
		
		End Select
		
		Select SoundMode
		
			Case 1
				OptionState[3,6]=" STEREO"
			
			Case 0
				OptionState[3,6]=" MONAURAL"
				
		End Select
		
		Select InputMethod
		
			Case 0
				OptionState[1,4]=" KEYBOARD"
			
			Case 1
				OptionState[1,4]=" MOUSE"
			
			Case 2
				OptionState[1,4]=" MOUSE RELATIVE"
			
			Case 3
				OptionState[1,4]=" JOYPAD"
				
			Case 4
				OptionState[1,4]=" JOYPAD DUAL-ANALOG"
		
		End Select
		
		Select PureBlacks
		
			Case 0
				OptionState[5,5]=" NORMAL"
				
			Case 1
				OptionState[5,5]=" DARKENED"
				
		End Select
		
		Select VerticalSync
		
			Case -1
				OptionState[4,5]=" ON"
				
			Case 0
				OptionState[4,5]=" OFF"
		
		End Select

		
		If BackGroundStyle<>0
			OptionState[4,3]=" STYLE "+String(BackgroundStyle)
		ElseIf BackgroundStyle=0
			OptionState[4,3]=" NONE"
		End If
		
		If UseSeedStyle Then
			OptionState[4,3]=" SEED DEFINED ("+BackgroundStyle+")"
		End If
		
		For Local i=1 To 6
			OptionState[i,7]=" "+KeyNames[InputKey[i]]
		Next
	
		For Local i=7 To 10
			OptionState[i-6,10]=" "+KeyNames[InputKey[i]]
		Next
		ResetAlpha()
		
	End Function

	Function Draw(x:Int=0,y:Int=0,FadeAlpha:Float=0)
		
		If GraphicsError
			If FullScreen = 0
				SetScale 1,1
				DoubleBoldFont.Draw ("GFX MODE ERROR!"),ScreenWidth/2,ScreenHeight/2-70,True
				SetAlpha .6
				SetScale .75,.75
				BoldFont.Draw ("Invaders: Corruption can't set the requested graphics mode."),ScreenWidth/2,ScreenHeight/2+10,True
				BoldFont.Draw ("Please make sure your graphics-card and screen support it."),ScreenWidth/2,ScreenHeight/2+35,True
				
				SetScale 1,1
				SetAlpha .55
				BoldFont.Draw ("Hit ESC to return to the Menu.",ScreenWidth/2,ScreenHeight/2+265,True)
				SetAlpha 1
				Return
			Else
				SetScale 1,1
				DoubleBoldFont.Draw ("GFX MODE ERROR!"),ScreenWidth/2,ScreenHeight/2-70,True
				SetAlpha .6
				SetScale .75,.75
				BoldFont.Draw ("Invaders: Corruption can't set the requested full-screen resolution."),ScreenWidth/2,ScreenHeight/2+10,True
				BoldFont.Draw ("Please make sure your graphics-card and screen support it."),ScreenWidth/2,ScreenHeight/2+35,True
				
				SetScale 1,1
				SetAlpha .55
				BoldFont.Draw ("Hit ESC to return to the Menu.",ScreenWidth/2,ScreenHeight/2+265,True)
				SetAlpha 1
				Return
			End If
		End If
		
		SetScale 2,2
		SetAlpha .15-FadeAlpha
		
		For Local i=1 To 6
			BoldFont.Draw SubMenuTitle[OptionLevel],OptionX-ScreenWidth-TitleOffset+i*2*BoldFont.StringWidth(SubMenuTitle[OptionLevel])+x,OptionY+30+y
		Next
		
		SetScale 1,1
		SetAlpha 1-FadeAlpha
		SetColor 148,148,148
		
		For Local i=1 To OptionsNum[OptionLevel]
			SetAlpha OptionAlpha[i,OptionLevel]
			If i=1 And OptionLevel=3 And FullScreenGlow=-1 Then SetColor 90,90,90
			If i=2 And OptionLevel=3 And FullScreenGlow<=0 Then SetColor 90,90,90
			If i=3 And OptionLevel=5 And RecommendedWideWidth=0 And RecommendedWideHeight=0 Then SetColor 90,90,90
			If i=3 And OptionLevel=5 And RecommendedTallWidth=0 And RecommendedTallHeight=0 Then SetColor 90,90,90
			If i=5 And Optionlevel=4 And InputMethod<3 Then SetColor 90,90,90
			BoldFont.Draw Option[i,OptionLevel]+OptionState[i,OptionLevel],OptionX+x,OptionY+(63*i)+y
			If i=1 And OptionLevel=3 And FullScreenGlow=-1 Then SetColor 148,148,148
			If i=2 And OptionLevel=3 And FullScreenGlow<=0 Then SetColor 148,148,148
			If i=5 And Optionlevel=4 And InputMethod<3 Then SetColor 148,148,148
			If i=3 And OptionLevel=5 And RecommendedWideWidth=0 And RecommendedWideHeight=0 Then SetColor 148,148,148
			If i=3 And OptionLevel=5 And RecommendedTallWidth=0 And RecommendedTallHeight=0 Then SetColor 148,148,148
			SetAlpha 1-FadeAlpha
		Next
		
		SetColor 255,255,255
		SetAlpha 1-FadeAlpha
		
		For Local i=1 To OptionsNum[OptionLevel]
			SetAlpha OptionAlpha[i,OptionLevel]
				If i=1 And OptionLevel=3 And FullScreenGlow=-1 Then SetColor 90,90,90
				If i=2 And OptionLevel=3 And FullScreenGlow<=0 Then SetColor 90,90,90
				If i=3 And OptionLevel=5 And RecommendedWideWidth=0 And RecommendedWideHeight=0 Then SetColor 90,90,90
				If i=3 And OptionLevel=5 And RecommendedTallWidth=0 And RecommendedTallHeight=0 Then SetColor 90,90,90
				If i=5 And Optionlevel=4 And InputMethod<3 Then SetColor 90,90,90
				If MusicVolInt>0 And OptionLevel=6 And i=2 Then BoldFont.Draw Option[i,OptionLevel]+" VOLUME",OptionX+x,OptionY+(63*i)+y
				If SoundVolInt>0 And OptionLevel=6 And i=1 Then BoldFont.Draw Option[i,OptionLevel]+" VOLUME",OptionX+x,OptionY+(63*i)+y
				If i=4 And OptionLevel=3 And BackGroundStyle<>0 And UseSeedStyle=0 Then BoldFont.Draw Option[i,OptionLevel]+" STYLE",OptionX+x,OptionY+(63*i)+y
				If i=5 And Optionlevel=4 And InputMethod=>3 And JoyDeadZoneAdjust>0 Then BoldFont.Draw Option[i,OptionLevel]+" SIZE",OptionX+x,OptionY+(63*i)+y
				BoldFont.Draw Option[i,OptionLevel],OptionX+x,OptionY+(63*i)+y
				If i=1 And OptionLevel=3 And FullScreenGlow=-1 Then SetColor 255,255,255
				If i=2 And OptionLevel=3 And FullScreenGlow<=0 Then SetColor 255,255,255
				If i=5 And Optionlevel=4 And InputMethod<3 Then SetColor 255,255,255
				If i=3 And OptionLevel=5 And RecommendedWideWidth=0 And RecommendedWideHeight=0 Then SetColor 255,255,255
				If i=3 And OptionLevel=5 And RecommendedTallWidth=0 And RecommendedTallHeight=0 Then SetColor 255,255,255
			SetAlpha 1-FadeAlpha
		Next	

	End Function
	
	Function Update(x:Int=0,y:Int=0,NoScroll:Byte=False)
		
		If GameState=HISCORE And GameMode=VIEWONLINE Then
			FlushMouse()
			FlushKeys()
			Return
		End If
		
		If Not NoScroll
			TitleOffset:+.5*Delta
			If TitleOffset=>2*BoldFont.StringWidth(SubMenuTitle[OptionLevel]) Then TitleOffset=0
		End If
				
		For Local i=1 To OptionsNum[OptionLevel]
			
			If WaitingForInput Exit
			'Before the value was 65
			If XMouse>=OptionX+x And XMouse<=OptionX+x+BoldFont.StringWidth(Option[i,OptionLevel])*1.1+BoldFont.StringWidth(OptionState[i,OptionLevel])*1.1 Then
				If YMouse>=OptionY+y+(63*i) And YMouse<=OptionY+y+(63*i)+BoldFont.StringHeight(Option[i,OptionLevel])*1.7 Then
					OptionAlpha[i,OptionLevel]=0.42
					If OptionLevel=2 And i=5 Then
						ToolTip="Relative difficulty: "+FloatRound(SeedDifficultyJudge,1)+"% "
					Else
						ToolTip=""
					End If
					If Not SoundOnce Then
						PlaySoundBetter Sound_Menu_Hover,FieldWidth/2,FieldHeight/2,False,False
						SoundOnce=True
					End If
					OptionSelect=i
					Exit
				Else
					If OptionLevel=2 And i=5 Then
						ToolTip=""
					End If
					OptionAlpha[i,OptionLevel]=1
					OptionSelect=0
					'SoundOnce=False
				End If
			Else
				If OptionLevel=2 And i=5 Then
					ToolTip=""
				End If
				OptionAlpha[i,OptionLevel]=1
				OptionSelect=0
				'SoundOnce=False
			End If
		
		Next

		If OptionSelect=0 Then SoundOnce=False
		
		If OptionLevel=7 Or OptionLevel=10 If WaitingForInput And MilliSecs() Mod 10=0
			
			'If we select the axis keys we need to add 6 to the input arry, so the keys get parsed
			'To the correct slot
			If OptionLevel=10 Then OptionSelect:+6
			
			'Have gotten Joy Input
			If InputMethod=>3
				Local Button:Float
				FlushJoy(0)
				For Local i=0 To 7
					Button=JoyAxis(0,i)
					If Button>.25 Or Button<-.25 
						WaitingForInput=False
						If Button<-.25 InputKey[OptionSelect]=200+i
						If Button>.25 InputKey[OptionSelect]=260+i
						UpdateOptionStates()
						PlaySoundBetter Sound_Menu_Click,FieldWidth/2,FieldHeight/2,False,False
						FlushJoy()
						Exit
					End If
				Next
				
				For Local i=0 To 31
					Button=JoyButton(i)
					If Button
						WaitingForInput=False
						InputKey[OptionSelect]=220+i
						UpdateOptionStates()
						FlushJoy()
						PlaySoundBetter Sound_Menu_Click,FieldWidth/2,FieldHeight/2,False,False
						Exit
					End If
				Next
			End If
			'GetJoy(WaitingForInput, OptionSelect)
			
			'Have gotten key input for input config	
			For Local kk:Int = 8 To 255
				If kk<>KEY_P And kk<>KEY_F8 And kk<> KEY_F11 And kk<>KEY_F10 And kk<>KEY_F7
					If KeyHit(kk)
						InputKey[OptionSelect]=kk
						WaitingForInput=False
						UpdateOptionStates()
						PlaySoundBetter Sound_Menu_Click,FieldWidth/2,FieldHeight/2,False,False
						FlushKeys()
						Exit
					End If
				ElseIf  kk=KEY_P Or kk=KEY_F8 Or kk=KEY_F11 Or kk=KEY_F10
					If KeyHit(kk)	
						PlaySoundBetter Sound_Menu_No,ScreenWidth/2,ScreenHeight/2,False,False
						'Print "sucker"
						FlushKeys()
						Exit
					End If
				End If
			Next
			
			'Have gotten mouse input for input config
			If MouseHit(1) Then
				PlaySoundBetter Sound_Menu_Click,FieldWidth/2,FieldHeight/2,False,False
				InputKey[OptionSelect]=1
				WaitingForInput=False
				UpdateOptionStates()
				FlushMouse()
			End If
			If MouseHit(2) Then
				InputKey[OptionSelect]=2
				WaitingForInput=False
				UpdateOptionStates()
				FlushMouse()
				PlaySoundBetter Sound_Menu_Click,FieldWidth/2,FieldHeight/2,False,False
			End If
			If MouseHit(3) Then
				InputKey[OptionSelect]=3
				WaitingForInput=False
				UpdateOptionStates()
				FlushMouse()
				PlaySoundBetter Sound_Menu_Click,FieldWidth/2,FieldHeight/2,False,False
			End If


			InputCache[OptionSelect,InputMethod]=InputKey[OptionSelect]

			If OptionLevel=10 Then OptionSelect:-6
			
		End If	
		
		'And revert it again - Quite the hack actually
		
		
		If WaitingForInput=False And MouseHit(1) 'Or MouseDown(1) Then 
			
			If OptionLevel=7 And OptionSelect<7 And OptionSelect<>0
				PlaySoundBetter Sound_Menu_Click,FieldWidth/2,FieldHeight/2,False,False
				PreviousKey=OptionSelect
				PreviousScanCode=InputKey[OptionSelect]
				InputKey[OptionSelect]=299
				WaitingForInput=True
				UpdateOptionStates()
				FlushMouse()
				FlushKeys()
			ElseIf OptionLevel=10 And OptionSelect<5 And OptionSelect<>0
				PlaySoundBetter Sound_Menu_Click,FieldWidth/2,FieldHeight/2,False,False
				PreviousKey=OptionSelect+6
				PreviousScanCode=InputKey[OptionSelect+6]
				InputKey[OptionSelect+6]=299
				WaitingForInput=True
				UpdateOptionStates()
				FlushMouse()
				FlushKeys()
			End If	
			
			Select OptionSelect
				
				Case 1
					
					If OptionLevel=1
						GameMode=ARCADE
						TypeDestroy(False)
						GameInit()
						GameState=READY
						Player.Alive=True
						PlaySoundBetter Sound_Game_Start,FieldWidth/2,FieldHeight/2,False,False
					ElseIf OptionLevel=2
						OptionLevel=3
						PlaySoundBetter Sound_Menu_Click,FieldWidth/2,FieldHeight/2,False,False
					ElseIf OptionLevel=3
						If FullScreenGlow<>-1
							FullScreenGlow=1-FullScreenGlow
							UpdateOptionStates()
							PlaySoundBetter Sound_Menu_Click,FieldWidth/2,FieldHeight/2,False,False
						Else
							PlaySoundBetter Sound_Menu_No,FieldWidth/2,FieldHeight/2,False,False
						End If
					ElseIf OptionLevel=4
						InputMethod:+1
						If InputMethod=>3 And JoyCount()=0 InputMethod=0
						If InputMethod>4 Then InputMethod=0
						For Local i=0 To 10
							InputKey[i]=InputCache[i,InputMethod]
						Next
						UpdateOptionStates()
						PlaySoundBetter Sound_Menu_Click,FieldWidth/2,FieldHeight/2,False,False
					ElseIf OptionLevel=6
						If SoundVolInt<110 SoundVolInt:+10
						If SoundVolInt>100 SoundVolInt=0
						UpdateOptionStates()
						PlaySoundBetter Sound_Menu_Click,FieldWidth/2,FieldHeight/2,False,False
					ElseIf Optionlevel=8
						GameMode=VIEWSCORE
						GameState=HISCORE
						PlaySoundBetter Sound_Menu_Click,FieldWidth/2,FieldHeight/2,False,False
						ResetAlpha()
					ElseIf OptionLevel=5
						PlaySoundBetter Sound_Menu_Click,FieldWidth/2,FieldHeight/2,False,False
						OptionLevel=9
					ElseIf OptionLevel=9
						PlaySoundBetter Sound_Menu_Click,FieldWidth/2,FieldHeight/2,False,False
						If WideScreen=False
							If KeyDown(KEY_RALT) Or KeyDown(KEY_LALT)
								CheckGraphics(TallScreenWidth[0],TallScreenHeight[0],True)
							Else
								CheckGraphics(TallScreenWidth[0],TallScreenHeight[0])
							End If
						Else
							If KeyDown(KEY_RALT) Or KeyDown(KEY_LALT)
								CheckGraphics(WideScreenWidth[0],WideScreenHeight[0],True)
							Else
								CheckGraphics(WideScreenWidth[0],WideScreenHeight[0])
							End If
						End If
						UpdateOptionStates()
					End If
				
				Case 2
					If OptionLevel=1
						PlaySoundBetter Sound_Menu_Click,FieldWidth/2,FieldHeight/2,False,False
						'GameMode=DEFENDER
						'TypeDestroy()
						'GameInit()
						'GameState=READY
						'Player.Alive=True
						'PlaySoundBetter Sound_Game_Start,FieldWidth/2,FieldHeight/2,False,False
					ElseIf OptionLevel=2
						OptionLevel=6
						PlaySoundBetter Sound_Menu_Click,FieldWidth/2,FieldHeight/2,False,False
					ElseIf OptionLevel=4
						OptionLevel=7
						PlaySoundBetter Sound_Menu_Click,FieldWidth/2,FieldHeight/2,False,False
					ElseIf OptionLevel=3
						If FullScreenGlow
							PlaySoundBetter Sound_Menu_Click,FieldWidth/2,FieldHeight/2,False,False
						Else
							PlaySoundBetter Sound_Menu_No,FieldWidth/2,FieldHeight/2,False,False
							Return
						End If
						Select GlowQuality
						
						Case 64
							GlowQuality=128
						
						Case 128
							GlowQuality=256
						
						Case 256
							GlowQuality=512
						
						Case 512
							GlowQuality=768
							
						Case 768
							GlowQuality=64
						
						Default
							GlowQuality=256
							
						End Select
						'Make sure that the GLOW fits within the current real resolution
						'As otherwise there will be ugly graphical errors
						If RealHeight<GlowQuality Then
							If RealHeight<768
								GlowQuality=64
							End If
							If RealHeight<512
								GlowQuality=64
							End If
						End If
						If RealWidth<GlowQuality Then
							If RealWidth<768
								GlowQuality=64
							End If
							If RealWidth<512
								GlowQuality=64
							End If
						End If
						UpdateOptionStates()
						ReInitGraphics=True
					ElseIf OptionLevel=5
						PlaySoundBetter Sound_Menu_Click,FieldWidth/2,FieldHeight/2,False,False
						If GraphicsModeExists(RealWidth,RealHeight,32)
							FullScreen=1-FullScreen
							UpdateOptionStates()
							ReInitGraphics=True
						Else
							GraphicsError=True
							UpdateOptionStates()
						End If
						
					ElseIf OptionLevel=6
						PlaySoundBetter Sound_Menu_Click,FieldWidth/2,FieldHeight/2,False,False
						If MusicVolInt<110 MusicVolInt:+10
						If MusicVolInt>100 MusicVolInt=0
						UpdateOptionStates()
						'SetChannelVolume MusicChannel_One, MusicVol/2
						'SetChannelVolume MusicChannel_Two, MusicVol/2
						DoMusic()
					ElseIf OptionLevel=8
						PlaySoundBetter Sound_Menu_Click,FieldWidth/2,FieldHeight/2,False,False
						GameMode=VIEWRANK
						GameState=HISCORE
						ConnectScoreServer=True
						ScoreServer.NotifyUser=False
						ScoreServer.Monthly=False
						ResetAlpha()
					ElseIf OptionLevel=9
						PlaySoundBetter Sound_Menu_Click,FieldWidth/2,FieldHeight/2,False,False
						If WideScreen=False
							If KeyDown(KEY_RALT) Or KeyDown(KEY_LALT)
								CheckGraphics(TallScreenWidth[1],TallScreenHeight[1],True)
							Else
								CheckGraphics(TallScreenWidth[1],TallScreenHeight[1])
							End If
						Else
							If KeyDown(KEY_RALT) Or KeyDown(KEY_LALT)
								CheckGraphics(WideScreenWidth[1],WideScreenHeight[1],True)
							Else
								CheckGraphics(WideScreenWidth[1],WideScreenHeight[1])
							End If
						End If
						UpdateOptionStates()
					End If
				
				Case 3
					If OptionLevel=1
						GameState=VIEWHELP
						PlaySoundBetter Sound_Menu_Click,FieldWidth/2,FieldHeight/2,False,False
					ElseIf OptionLevel=2
						OptionLevel=5
						PlaySoundBetter Sound_Menu_Click,FieldWidth/2,FieldHeight/2,False,False
					ElseIf OptionLevel=3
						MotionBlurEnable:+1
						If MotionBlurEnable=3 Then MotionBlurEnable=0
						'MotionBlurEnable=1-MotionBlurEnable
						UpdateOptionStates()
						PlaySoundBetter Sound_Menu_Click,FieldWidth/2,FieldHeight/2,False,False
					ElseIf Optionlevel=4
						InputKey[MOVE_UP]=KEY_W
						InputKey[MOVE_DOWN]=KEY_S
						InputKey[MOVE_LEFT]=KEY_A
						InputKey[MOVE_RIGHT]=KEY_D
						InputKey[FIRE_CANNON]=1
						InputKey[FIRE_BOMB]=2
						MouseSensivity=10
						InputMethod=1
						For Local i=1 To 10
							InputCache[i,InputMethod]=InputKey[i]
						Next
						UpdateOptionStates()
						PlaySoundBetter Sound_Menu_Click,FieldWidth/2,FieldHeight/2,False,False
					ElseIf OptionLevel=5 
						WideScreen=1-WideScreen
						If WideScreen
							If RecommendedWideWidth=0 And RecommendedWideHeight=0 Then
								WideScreen=0
								UpdateOptionStates()
								PlaySoundBetter Sound_Menu_No,FieldWidth/2,FieldHeight/2,False,False
								Return
							End If
						Else
							If RecommendedTallWidth=0 And RecommendedTallHeight=0 Then
								WideScreen=1
								UpdateOptionStates()
								PlaySoundBetter Sound_Menu_No,FieldWidth/2,FieldHeight/2,False,False
								Return
							End If
						End If
						If WideScreen
							PlaySoundBetter Sound_Menu_Click,FieldWidth/2,FieldHeight/2,False,False
							RealWidth=RecommendedWideWidth
							RealHeight=RecommendedWideHeight
							'ForceRes=1
							FullScreen=0
							ScreenWidth = 1280					
							ScreenHeight = 768
							FieldWidth = 1280
							FieldHeight = 768
							GridHit.Generate(ScreenWidth,ScreenHeight)
							Squared.Generate(ScreenWidth,ScreenHeight)
							Background.Generate(ScreenWidth,ScreenHeight)
							Background.Reset()
							Corruption.ReGenerate(ScreenWidth,ScreenHeight)
							BoxedIn.WarmUp()
							UpRising.WarmUp()
							BombHUD.AspectChange()
							Water.AspectChange()
							GameOfLife.AspectChange()
							TStarfield.AspectChange(256)
						Else
							PlaySoundBetter Sound_Menu_Click,FieldWidth/2,FieldHeight/2,False,False
							RealWidth=RecommendedTallWidth
							RealHeight=RecommendedTallHeight
							'ForceRes=1
							FullScreen=0
							ScreenWidth = 1024
							ScreenHeight = 768
							FieldWidth = 1024
							FieldHeight = 768
							GridHit.Generate(ScreenWidth,ScreenHeight)
							Squared.Generate(ScreenWidth,ScreenHeight)
							Background.Generate(ScreenWidth,ScreenHeight)
							Background.Reset()
							Corruption.ReGenerate(ScreenWidth,ScreenHeight)
							BoxedIn.WarmUp()
							UpRising.WarmUp()
							BombHUD.AspectChange()
							Water.AspectChange()
							GameOfLife.AspectChange()
							TStarfield.AspectChange(256)

						End If
						UpdateOptionStates()
						ReInitGraphics=True	
					ElseIf OptionLevel=6
						SoundMode=1-SoundMode
						UpdateOptionStates()
						PlaySoundBetter Sound_Menu_Click,FieldWidth/2,FieldHeight/2,False,False
					ElseIf OptionLevel=8
						ConnectScoreServer=True
						GameMode=VIEWONLINE
						GameState=HISCORE
						ScoreServer.NotifyUser=False
						ScoreServer.Monthly=False
						PlaySoundBetter Sound_Menu_Click,FieldWidth/2,FieldHeight/2,False,False
						ResetAlpha()
					ElseIf OptionLevel=9
						PlaySoundBetter Sound_Menu_Click,FieldWidth/2,FieldHeight/2,False,False
						If WideScreen=False
							If KeyDown(KEY_RALT) Or KeyDown(KEY_LALT)
								CheckGraphics(TallScreenWidth[3],TallScreenHeight[2],True)
							Else
								CheckGraphics(TallScreenWidth[2],TallScreenHeight[2])
							End If
						Else
							If KeyDown(KEY_RALT) Or KeyDown(KEY_LALT)
								CheckGraphics(WideScreenWidth[2],WideScreenHeight[2],True)
							Else
								CheckGraphics(WideScreenWidth[2],WideScreenHeight[2])
							End If
						End If
						UpdateOptionStates()
						PlaySoundBetter Sound_Menu_Click,FieldWidth/2,FieldHeight/2,False,False
					End If
				
				Case 4
					If OptionLevel=1
						OptionLevel=8
						PlaySoundBetter Sound_Menu_Click,FieldWidth/2,FieldHeight/2,False,False
					ElseIf OptionLevel=2
						OptionLevel=4
						PlaySoundBetter Sound_Menu_Click,FieldWidth/2,FieldHeight/2,False,False
					ElseIf OptionLevel=3
						PlaySoundBetter Sound_Menu_Click,FieldWidth/2,FieldHeight/2,False,False
						BackGroundStyle:+1
						If BackgroundStyle=9 Or BackgroundStyle=10 BoxedIn.WarmUp()
						If BackgroundStyle=12 Or BackgroundStyle=13 UpRising.WarmUp()
						If BackGroundStyle>=17 Then BackGroundStyle=16
						If BackgroundStyle=16 And UseSeedStyle=False Then
							UseSeedStyle=True
							BackgroundStyle=SeedBackStore
						ElseIf UseSeedStyle=True
							BackgroundStyle=0
							UseSeedStyle=False
						End If
						UpdateOptionStates()
					ElseIf OptionLevel=4
						PlaySoundBetter Sound_Menu_Click,FieldWidth/2,FieldHeight/2,False,False
						MouseSensivity:+1
						If MouseSensivity>20 Then MouseSensivity=1
						UpdateOptionStates()
					ElseIf OptionLevel=5	
						PlaySoundBetter Sound_Menu_Click,FieldWidth/2,FieldHeight/2,False,False					
						If VerticalSync=-1
							VerticalSync=0
						Else
							VerticalSync=-1
						End If
						UpdateOptionStates()
						ReInitGraphics=True
					ElseIf OptionLevel=8
						PlaySoundBetter Sound_Menu_Click,FieldWidth/2,FieldHeight/2,False,False
						'Monthly TOP 10 [ONLINE]
						'OptionLevel=1
						ConnectScoreServer=True
						GameMode=VIEWONLINE
						GameState=HISCORE
						ScoreServer.NotifyUser=False
						ScoreServer.Monthly=True
						ResetAlpha()
					ElseIf OptionLevel=9
						PlaySoundBetter Sound_Menu_Click,FieldWidth/2,FieldHeight/2,False,False
						If WideScreen=False
							If KeyDown(KEY_RALT) Or KeyDown(KEY_LALT)
								CheckGraphics(TallScreenWidth[3],TallScreenHeight[3],True)
							Else
								CheckGraphics(TallScreenWidth[3],TallScreenHeight[3])
							End If
						Else
							If KeyDown(KEY_RALT) Or KeyDown(KEY_LALT)
								CheckGraphics(WideScreenWidth[3],WideScreenHeight[3],True)
							Else
								CheckGraphics(WideScreenWidth[3],WideScreenHeight[3])
							End If
						End If
						UpdateOptionStates()
					End If
				
				Case 5
					PlaySoundBetter Sound_Menu_Click,FieldWidth/2,FieldHeight/2,False,False
					If OptionLevel=1 Then
						OptionLevel:+1
					ElseIf OptionLevel=2
						'Seed=""
						GetRandSeed(False)
						UpdateOptionStates()
					ElseIf OptionLevel=3
						Select ParticleMultiplier
						
						Case .35
							ParticleMultiPlier=.75
						Case .75
							ParticleMultiPlier=1
						Case 1
							ParticleMultiPlier=1.4
						Case 1.4
							ParticleMultiPlier=2.0
						Case 2.0
							ParticleMultiPlier=.35
						Default
							ParticleMultiplier=1
						
						End Select
						UpdateOptionStates()
					ElseIf OptionLevel=4
						If InputMethod<3
							PlaySoundBetter Sound_Menu_No,ScreenWidth/2,ScreenHeight/2,False,False
						Else
							PlaySoundBetter Sound_Menu_Click,FieldWidth/2,FieldHeight/2,False,False
							JoyDeadZoneAdjust:+1
							If JoyDeadZoneAdjust>10 Then JoyDeadZoneAdjust=0
						End If
						UpdateOptionStates()
					ElseIf OptionLevel=5
						PlaySoundBetter Sound_Menu_Click,FieldWidth/2,FieldHeight/2,False,False
						PureBlacks=1-PureBlacks
						UpdateOptionStates()
						ReInitGraphics=True
					ElseIf OptionLevel=6 
						PlaySoundBetter Sound_Menu_Click,FieldWidth/2,FieldHeight/2,False,False
						OptionLevel=2
					ElseIf OptionLevel=9
						PlaySoundBetter Sound_Menu_Click,FieldWidth/2,FieldHeight/2,False,False
						If WideScreen=False
							If KeyDown(KEY_RALT) Or KeyDown(KEY_LALT)
								CheckGraphics(TallScreenWidth[4],TallScreenHeight[4],True)
							Else
								CheckGraphics(TallScreenWidth[4],TallScreenHeight[4])
							End If
						Else
							If KeyDown(KEY_RALT) Or KeyDown(KEY_LALT)
								CheckGraphics(WideScreenWidth[4],WideScreenHeight[4],True)
							Else
								CheckGraphics(WideScreenWidth[4],WideScreenHeight[4])
							End If
						End If
						UpdateOptionStates()
					End If
				
				Case 6
					If OptionLevel=3
						PlaySoundBetter Sound_Menu_Click,FieldWidth/2,FieldHeight/2,False,False
						ScreenShakeEnable=1-ScreenShakeEnable
						UpdateOptionStates()
					ElseIf OptionLevel=4
						PlaySoundBetter Sound_Menu_Click,FieldWidth/2,FieldHeight/2,False,False
						CrossHairType:+1
						If CrossHairType>12 Then CrossHairType=1
						UpdateOptionStates()	
					ElseIf OptionLevel=8
						PlaySoundBetter Sound_Menu_Click,FieldWidth/2,FieldHeight/2,False,False
						OptionLevel=1
					ElseIf OptionLevel=9
						PlaySoundBetter Sound_Menu_Click,FieldWidth/2,FieldHeight/2,False,False
						If WideScreen=False
							If KeyDown(KEY_RALT) Or KeyDown(KEY_LALT)
								CheckGraphics(TallScreenWidth[5],TallScreenHeight[5],True)
							Else
								CheckGraphics(TallScreenWidth[5],TallScreenHeight[5])
							End If
						Else
							If KeyDown(KEY_RALT) Or KeyDown(KEY_LALT)
								CheckGraphics(WideScreenWidth[5],WideScreenHeight[5],True)
							Else
								CheckGraphics(WideScreenWidth[5],WideScreenHeight[5])
							End If
						End If
						UpdateOptionStates()
						UpdateOptionStates()
					ElseIf OptionLevel=10
						PlaySoundBetter Sound_Menu_Click,FieldWidth/2,FieldHeight/2,False,False
						OptionLevel=7
					End If

				Case 7
					If OptionLevel=1
						ExitCode=True
					ElseIf OptionLevel=2
						OptionLevel=1
						PlaySoundBetter Sound_Menu_Click,FieldWidth/2,FieldHeight/2,False,False
					ElseIf OptionLevel=5
						OptionLevel=2
						PlaySoundBetter Sound_Menu_Click,FieldWidth/2,FieldHeight/2,False,False
					ElseIf OptionLevel=7 And InputMethod=4
						OptionLevel=10
						PlaySoundBetter Sound_Menu_Click,FieldWidth/2,FieldHeight/2,False,False
					End If
					
				Case 8
					PlaySoundBetter Sound_Menu_Click,FieldWidth/2,FieldHeight/2,False,False
					If OptionLevel = 7 Then
						OptionLevel=4
						Return
					End If
					If OptionLevel = 3 Then
						OptionLevel=2
						Return
					End If
					If OptionLevel = 9 Then
						OptionLevel=5
						Return
					End If
					If OptionLevel = 4 Then
						OptionLevel=2
						Return
					End If
			End Select
		
		ElseIf WaitingForInput=False And MouseHit(2)
		
			Select OptionSelect
			
			Case 1
				If OptionLevel=6
					PlaySoundBetter Sound_Menu_Click,FieldWidth/2,FieldHeight/2,False,False
					If SoundVolInt>=0 SoundVolInt:-10
					If SoundVolInt<0 SoundVolInt=100
					UpdateOptionStates()
				ElseIf OptionLevel=3
					PlaySoundBetter Sound_Menu_Click,FieldWidth/2,FieldHeight/2,False,False
					If FullScreenGlow<>-1
						FullScreenGlow=1-FullScreenGlow
						UpdateOptionStates()
					End If
				ElseIf OptionLevel=4
					PlaySoundBetter Sound_Menu_Click,FieldWidth/2,FieldHeight/2,False,False
					InputMethod:-1
					If InputMethod<0 Then InputMethod=4
					If InputMethod=4 And JoyCount()=0 InputMethod=2
					For Local i=1 To 10
						InputKey[i]=InputCache[i,InputMethod]
					Next
					UpdateOptionStates()
				End If
			
			Case 2
				If OptionLevel=3
					If FullScreenGlow
						PlaySoundBetter Sound_Menu_Click,FieldWidth/2,FieldHeight/2,False,False
					Else
						PlaySoundBetter Sound_Menu_No,FieldWidth/2,FieldHeight/2,False,False
						Return
					End If
					Select GlowQuality
					
					Case 64
						GlowQuality=768
					
					Case 128
						GlowQuality=64
					
					Case 256
						GlowQuality=128
					
					Case 512
						GlowQuality=256
					
					Case 768
						GlowQuality=512
					
					Default
						GlowQuality=256
						
					End Select
					'Make sure that the GLOW fits within the current real resolution
					'As otherwise there will be ugly graphical errors
					If RealHeight<GlowQuality Then
						If RealHeight<768
							GlowQuality=512
						End If
						If RealHeight<512
							GlowQuality=256
						End If
					End If
					If RealWidth<GlowQuality Then
						If RealWidth<768
							GlowQuality=512
						End If
						If RealWidth<512
							GlowQuality=256
						End If
					End If
					UpdateOptionStates()
					ReInitGraphics=True
				ElseIf OptionLevel=6
					PlaySoundBetter Sound_Menu_Click,FieldWidth/2,FieldHeight/2,False,False
					If MusicVolInt>=0 MusicVolInt:-10
					If MusicVolInt<0 MusicVolInt=100
					UpdateOptionStates()
					'SetChannelVolume MusicChannel_One, MusicVol/2
					'SetChannelVolume MusicChannel_Two, MusicVol/2
					DoMusic()
				ElseIf OptionLevel=5
					PlaySoundBetter Sound_Menu_Click,FieldWidth/2,FieldHeight/2,False,False
					FullScreen=1-FullScreen
					UpdateOptionStates()
					ReInitGraphics=True
				End If
				
			Case 3
				If OptionLevel=3
					PlaySoundBetter Sound_Menu_Click,FieldWidth/2,FieldHeight/2,False,False
					'MotionBlurEnable=1-MotionBlurEnable
					MotionBlurEnable:-1
					If MotionBlurEnable=-1 Then MotionBlurEnable=2
					UpdateOptionStates()
				ElseIf OptionLevel=6
					PlaySoundBetter Sound_Menu_Click,FieldWidth/2,FieldHeight/2,False,False
					SoundMode=1-SoundMode
					UpdateOptionStates()
				ElseIf OptionLevel=5 
						WideScreen=1-WideScreen
						If WideScreen
							If RecommendedWideWidth=0 And RecommendedWideHeight=0 Then
								WideScreen=0
								UpdateOptionStates()
								PlaySoundBetter Sound_Menu_No,FieldWidth/2,FieldHeight/2,False,False
							End If
						Else
							If RecommendedTallWidth=0 And RecommendedTallHeight=0 Then
								WideScreen=1
								UpdateOptionStates()
								PlaySoundBetter Sound_Menu_No,FieldWidth/2,FieldHeight/2,False,False
							End If
						End If
						If WideScreen
							PlaySoundBetter Sound_Menu_Click,FieldWidth/2,FieldHeight/2,False,False
							RealWidth=RecommendedWideWidth
							RealHeight=RecommendedWideHeight
							'ForceRes=1
							FullScreen=0
							ScreenWidth = 1280					
							ScreenHeight = 768
							FieldWidth = 1280
							FieldHeight = 768
							GridHit.Generate(ScreenWidth,ScreenHeight)
							Squared.Generate(ScreenWidth,ScreenHeight)
							Background.Generate(ScreenWidth,ScreenHeight)
							Background.Reset()
							Corruption.ReGenerate(ScreenWidth,ScreenHeight)
							BoxedIn.WarmUp()
							UpRising.WarmUp()
							BombHUD.AspectChange()
						Else
							PlaySoundBetter Sound_Menu_Click,FieldWidth/2,FieldHeight/2,False,False
							RealWidth=RecommendedTallWidth
							RealHeight=RecommendedTallHeight
							'ForceRes=1
							FullScreen=0
							ScreenWidth = 1024
							ScreenHeight = 768
							FieldWidth = 1024
							FieldHeight = 768
							GridHit.Generate(ScreenWidth,ScreenHeight)
							Squared.Generate(ScreenWidth,ScreenHeight)
							Background.Generate(ScreenWidth,ScreenHeight)
							Background.Reset()
							Corruption.ReGenerate(ScreenWidth,ScreenHeight)
							BoxedIn.WarmUp()
							UpRising.WarmUp()
							BombHUD.AspectChange()
						End If
						UpdateOptionStates()
						ReInitGraphics=True	
				End If
			
			Case 4
				If OptionLevel=3
					PlaySoundBetter Sound_Menu_Click,FieldWidth/2,FieldHeight/2,False,False
					BackGroundStyle:-1
					If BackGroundStyle<0 Then BackGroundStyle=16
					If BackgroundStyle=16 Then
						UseSeedStyle=True
						BackgroundStyle=SeedBackStore
					ElseIf UseSeedStyle=True
						BackgroundStyle=15
						UseSeedStyle=False
					End If
					If BackgroundStyle=9 Or BackgroundStyle=10 BoxedIn.WarmUp()
					If BackgroundStyle=12 Or BackgroundStyle=13 UpRising.WarmUp()
					UpdateOptionStates()
				ElseIf OptionLevel=4
					PlaySoundBetter Sound_Menu_Click,FieldWidth/2,FieldHeight/2,False,False
					MouseSensivity:-1
					If MouseSensivity<1 Then MouseSensivity=20
					UpdateOptionStates()
				ElseIf OptionLevel=5 
					PlaySoundBetter Sound_Menu_Click,FieldWidth/2,FieldHeight/2,False,False
					If VerticalSync=-1
						VerticalSync=0
					Else
						VerticalSync=-1
					End If
					UpdateOptionStates()
					ReInitGraphics=True
				End If
			
			Case 5
				If OptionLevel=3
					PlaySoundBetter Sound_Menu_Click,FieldWidth/2,FieldHeight/2,False,False
					Select ParticleMultiplier
					
					Case .35
						ParticleMultiPlier=2.0
					Case .75
						ParticleMultiPlier=.35
					Case 1
						ParticleMultiPlier=.75
					Case 1.4
						ParticleMultiPlier=1
					Case 2.0
						ParticleMultiPlier=1.4
					Default
						ParticleMultiplier=1
					End Select
					UpdateOptionStates()
				ElseIf OptionLevel=4
					If InputMethod<3
						PlaySoundBetter Sound_Menu_No,ScreenWidth/2,ScreenHeight/2,False,False
					Else
						PlaySoundBetter Sound_Menu_Click,FieldWidth/2,FieldHeight/2,False,False
						JoyDeadZoneAdjust:-1
						If JoyDeadZoneAdjust<0 Then JoyDeadZoneAdjust=10
					End If
					UpdateOptionStates()
				ElseIf OptionLevel=5
					PlaySoundBetter Sound_Menu_Click,FieldWidth/2,FieldHeight/2,False,False
					PureBlacks=1-PureBlacks
					UpdateOptionStates()
					ReInitGraphics=True
				End If
				
			  Case 6
				If OptionLevel=3
					PlaySoundBetter Sound_Menu_Click,FieldWidth/2,FieldHeight/2,False,False
					ScreenShakeEnable=1-ScreenShakeEnable
					UpdateOptionStates()
				ElseIf OptionLevel=4
					PlaySoundBetter Sound_Menu_Click,FieldWidth/2,FieldHeight/2,False,False
					CrossHairType:-1
					If CrossHairType<1 Then CrossHairType=12
					UpdateOptionStates()	
				End If
					
			End Select
		
		End If 

	End Function

End Type

'-----------------------------------------------------------------------------
'The Generative Tree-Logo Type
'-----------------------------------------------------------------------------

Type TreeLogo

	Global b#=0.75,p#=33,z#=150,v#=0.0073,d=0,e=1,t=0,n#=0,g#,w#
	Global InternalAlpha:Float=1
	
	Global BackLogo:TImage
	Global TreePixmap:TPixmap
	Global TreeLogoPart:TImage
	
	Global gcw:Float
	Global gch:Float

	
	Function Init(SecondTime:Byte)
		
		gcw = VirtualResolutionWidth() / GraphicsWidth()
		gch = VirtualResolutionHeight() / GraphicsHeight()
		
		If Not BackLogo And SecondTime=False Then
			BackLogo=LoadImage(GetBundleResource("graphics/rekursionlogo.png"))
		End If
		
		n#=0
		g=200
		w=512
		'Current time as random seed
		'SeedRnd(MilliSecs()/2.321)
		t=-5
		'prepare p
		p:+Sin(t)*0.08
	End Function
	
	Function Render(SecondTime:Byte)
		
		'Flip
		Cls
		'Load Neccessary Imagery, Set generation parameters
		Init(SecondTime:Byte)
		
		
		'Generate the tree
		Generate(256,512,z,-90)
		'Flip
		'WaitKey
		'SetColor 0,0,255
		'DrawRect(100,(90+Rand(-20,15)),294,394)
		'SetColor 255,255,255
		'Flip

		
		'Grab The tree

		If SecondTime=False
			TreePixmap=GrabPixmap(100/gcw,(90+Rand(-20,15))/gch,294/gcw,394/gch)
		Else
			Local Trash=Rand(-20,15)
		End If
			'Small easter Egg
			Local day:String=CurrentDate()[..2]
			Local mon:String=CurrentDate()[3..6].toUpper()
		
		If SecondTime=False
			If Int(day)=5 And Upper(mon)="OCT" TreePixmap=YFlipPixmap(TreePixmap)
		End If	
		
		If SeedJumble(Seed)="LIAP@ELLI" And SecondTime=False
			TreePixmap=ResizePixmap(TreePixmap,PixmapWidth(TreePixmap)/4,PixmapHeight(TreePixmap)/4)
			'TreePixmap=ResizePixmap(TreePixmap,PixmapWidth(TreePixmap)*8,PixmapHeight(TreePixmap)*8)
		End If

		'Convert it to an Image
		If SecondTime=False TreeLogoPart=LoadImage(TreePixmap,MASKEDIMAGE)
		
		
		
		'Clear the screen and set the mix-color to white
		Cls
		
		SetColor 255,255,255
	
	End Function
	
	Function Remove()
		
		TreePixMap=Null
		TreeLogoPart=Null
		BackLogo=Null
		
	End Function
	
	Function Draw(x,y,Alpha#=1)
		
		'Adjust the handle of the image to the center
		x:-374/2
		y:-565/2
		
		SetBlend AlphaBlend
		SetScale 1,1
		'SetAlpha Alpha
		'Draw The Background
		DrawImage (BackLogo,x,y)
		'Dont write black pixels for the tree
		SetBlend lightblend
		'Mix in the generative tree
		SetScale 1*gcw,1*gch
		If SeedJumble(Seed)="LIAP@ELLI" 
			'TreePixmap=ResizePixmap(TreePixmap,PixmapWidth(TreePixmap)/8,PixmapHeight(TreePixmap)/8)
			'TreePixmap=ResizePixmap(TreePixmap,PixmapWidth(TreePixmap)*8,PixmapHeight(TreePixmap)*8)
			SetScale 4.1,4.1
			DrawImage (TreeLogoPart,x+40,y+35)
			SetScale 1,1
		Else
			DrawImage (TreeLogoPart,x+40,y+35)
		End If

		
		SetBlend alphablend
		
	End Function
	
	Function Generate(x#,y#,l#,a#)
		Local c#=0,s#=0,x2#=0,y2#=0,h#=0
		
		'Return after 13 recursions hence the logo's name
		If d>13 Return
	
		d:+1
		c#=Cos(a)*l
		s#=Sin(a)*l
		x2#=x+c
		y2#=y+s
		
		'For low recursions do some shading for the tree trunk
		If d<5 Then
			SetColor 140,140,140
			SetLineWidth 7-d
			DrawLine x,y,x2,y2
			
			SetColor 130,130,130
			SetLineWidth 4-d
			DrawLine x,y,x2,y2
			
			SetColor 100,100,100
			SetLineWidth 2-d
			DrawLine x,y,x2,y2
		Else
			h#=Rnd(0.4,1)
			SetColor 230*h,230*h,230*h
			SetLineWidth 1
		End If
		'Draw and call the function itself (Recurse)
		DrawLine x,y,x2,y2
		w#=Rnd(0.3,1)
		Generate(x+c*w,y+s*w,l*b,a-Rnd(p-20,p+20))
		w=Rnd(0.3,1)
		Generate(x+c*w,y+s*w,l*b,a+Rnd(p-20,p+20))
		d:-1
			
	EndFunction

End Type

'-----------------------------------------------------------------------------
'A fade type which allows to fade in or out
'-----------------------------------------------------------------------------
Type TFade
	
	Field Px:Int
	Field Py:Int
	Field Tx:Int
	Field Ty:Int
	
	Field Red:Byte
	Field Green:Byte
	Field Blue:Byte
	
	Field ImageScr:TImage
	Field ImageDes:TImage
	
	Field FadeType:Int
	Field FadeStart:Int=False
	
	Field AlphaValue:Float

	Field AlphaRate:Int
	Field AlphaTimer:Fade_Timer
	
	' ----------------------------------
	' Colorfade the screen to RGB
	' ----------------------------------
	Function CreateColorFade:TFade(Red:Byte=10,Green:Byte=10,Blue:Byte=10)
		Local F:TFade = New TFade
		F.Px=0
		F.Py=0
		'Get the Screen Geometry
		F.Tx=ScreenWidth
		F.Ty=ScreenHeight
		
		F.Red=Red
		F.Green=Green
		F.Blue=Blue
		
		F.AlphaValue=1
		F.FadeType=1
		
		F.AlphaRate=15
		F.AlphaTimer=Fade_Timer.Create(F.AlphaRate)
		
		Return F
	End Function
	
	' -------------------------------------
	' Crossfade between two images
	' -------------------------------------
	Function CreateCrossFade:TFade(Source:TImage,Destination:TImage)
		Local F:TFade = New TFade
		F.Px=0
		F.Py=0
		'Get the Screen Geometry
		F.Tx=GraphicsWidth()
		F.Ty=GraphicsHeight()

		F.Red=255
		F.Green=255
		F.Blue=255
	
		F.ImageScr=Source
		F.ImageDes=Destination
		
		F.AlphaValue=0
		F.FadeType=3
		
		F.AlphaRate=15
		F.AlphaTimer=Fade_Timer.Create(F.AlphaRate)
		
		Return F
	End Function
	
	' --------------------------
	' Start Fading
	' --------------------------
	Method Start()
		FadeStart=True
	End Method
	
	' ------------------------
	' Stop Fading
	' ------------------------
	Method Stop()
		FadeStart=False
	End Method
	
	' ------------------------------------------
	' Force fade out
	' ------------------------------------------
	Method ConvertToFadeOut()
		FadeType=2
	End Method
	
	' ---------------------------------------
	' Returns if the fade has already completed
	' ---------------------------------------
	Method Test()
		Return FadeStart
	End Method
	
	' ------------------------------
	' Redraw the screen for the various modes
	' ------------------------------
	Method Redraw()
		Local OldBlend:Int=GetBlend()
		Local OldAlpha:Float=GetAlpha()
		Select FadeType
		' -------
		' Fade In
		' -------
		Case 1
			If FadeStart=True Then
				If AlphaTimer.TestEnd()=True Then
					AlphaValue=AlphaValue-0.015
					AlphaTimer=Fade_Timer.Create(AlphaRate)
				EndIf
				
				If AlphaValue<=0 Then 
					AlphaValue=0
					FadeStart=False
				EndIf
			EndIf
			
			'Reset any parameters the game may have changed
			SetScale (1,1)
			SetRotation (0)
			SetBlend AlphaBlend
			SetAlpha AlphaValue
			SetColor Red,Green,Blue
			
			DrawRect Px,Py,Tx,Ty
		
		' --------
		' Fade Out
		' --------
		Case 2
			If FadeStart=True Then
				If AlphaTimer.TestEnd()=True Then
					AlphaValue=AlphaValue+0.012
					AlphaTimer=Fade_Timer.Create(AlphaRate)
				EndIf
				
				If AlphaValue>=1 Then 
					AlphaValue=1
					FadeStart=False
				EndIf
			EndIf
			'Reset any parameters the game may have changed
			SetScale (1,1)
			SetRotation (0)
			
			SetBlend AlphaBlend
			SetAlpha AlphaValue
			SetColor Red,Green,Blue
			
			DrawRect Px,Py,Tx,Ty
		
		
		
		' ----------
		' Cross Fade 
		' ----------
		Case 3
			If FadeStart=True Then
				If AlphaTimer.TestEnd()=True Then
					AlphaValue=AlphaValue+0.005
					AlphaTimer=Fade_Timer.Create(AlphaRate)
				EndIf
				
				If AlphaValue>=1 Then 
					AlphaValue=1
					FadeStart=False
				EndIf
			EndIf
			
			SetBlend AlphaBlend
			SetColor Red,Green,Blue
			
			DrawImage ImageScr,Px,Py	
			
			SetAlpha AlphaValue		
			DrawImage ImageDes,Px,Py				
		End Select
		
		' -----------------------------
		' Reset the type to default values
		' -----------------------------
		SetColor 255,255,255		
		SetBlend OldBlend
		SetAlpha OldAlpha
	End Method
End Type

' ---------------------------------
' Multitask timer for gadget events
' ---------------------------------
Type Fade_Timer
	Field Start:Int
	Field TimeOut:Int
	
	' ----------------
	' Define the timer
	' ----------------
	Function Create:Fade_Timer(Out:Int) 
		Local NewTimer:Fade_Timer
	
		NewTimer = New Fade_Timer
		NewTimer.Start = MilliSecs() 
		NewTimer.TimeOut = NewTimer.Start + Out
	
		Return NewTimer
	End Function

	' --------------
	' Free the timer
	' --------------	
	Function Freetimer(Timer:Fade_Timer)
		Timer=Null	
	End Function

	' ------------------
	' Test the timer end
	' ------------------
	Method TestEnd()
		If TimeOut < MilliSecs()
			Freetimer(Self)
			Return True
		Else
			Return False
		EndIf
	End Method
End Type