Strict
Framework BRL.GLMax2D
Import BAH.Random
Import Koriolis.ZipStream
Import BRL.PNGLoader
Import BRL.StandardIO

Include "includes/fixedratelogic.bmx"

SetZipStreamPasssword("data.big","SanitaryW@sh1911!")

SetGraphicsDriver GLMax2DDriver()

Graphics 800,600

Global ParticleMultiplier:Int=1
Global VerticalSync:Int=0
Global Delta:Double
Global GlLines:Byte=True
Global ParticleTick:Int
Global GlowQuality=256	
Global FullScreenGlow:Byte=True


'Create a new fixed rate logic
Global FixedRateLogic: TFixedRateLogic = New TFixedRateLogic
FixedRateLogic.Create()
FixedRateLogic.Init()

ParticleManager.Init()
'PorticleManager.Init()

While Not KeyHit(KEY_ESCAPE) Or AppTerminate()

	Cls
	
	
	FixedRateLogic.Calc()

 	'Now we do the logic loop ... from 1 not 0!
 	For Local i = 1 To Floor(FixedRateLogic.NumTicks)
  		FixedRateLogic.SetDelta(1)
		PartTest()
 	Next

	'Is there a remaining bit in the Numticks float?
 	Local remainder# = FixedRateLogic.NumTicks Mod 1
	If remainder > 0 Then
 		FixedRateLogic.SetDelta(remainder)
		PartTest()
 	EndIf

	ParticleManager.DrawAll()
	'PorticleManager.DrawAll()
	
	'DrawText "Millisecs: "+ParticleManager.CycleTime/ParticleManager.DataPoints,30,30
	DrawText "Amount: "+ ParticleManager.List.Count(),30,50
	DrawText "Memory: "+ GCMemAlloced()/1024,30,70

	
	Flip 0

Wend


Function PartTest()
	
	If MilliSecs()-ParticleTick>50
		'PorticleManager.Create(300,300,1000,Rand(0,255),Rand(0,255),Rand(0,255),0,1)	
		ParticleManager.Create(300,300,1000,Rand(0,255),Rand(0,255),Rand(0,255),0,1)
		ParticleTick=MilliSecs()
	End If
	
	ParticleManager.UpdateAll()
	'PorticleManager.UpdateAll()
	
End Function

'-----------------------------------------------------------------------------
'Particle Manager, Manages glowy particles
'-----------------------------------------------------------------------------
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
				If link._succ._value<>link._succ 
					link=link._succ
	

				SetColor Particle.R,Particle.G,Particle.B
				
				glVertex2f Particle.X,Particle.Y
				glVertex2f Particle.X+(Particle.XSpeed*LengthMultiplier),Particle.Y+(Particle.YSpeed*LengthMultiplier)
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
				If link._succ._value<>link._succ 
					link=link._succ
	
					SetColor Particle.R,Particle.G,Particle.B
					
					DrawLine Particle.X,Particle.Y,Particle.X+Particle.XSpeed,Particle.Y+Particle.YSpeed
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
				If link._succ._value<>link._succ 
					link=link._succ

					rr = Particle.R*1.25
					gg = Particle.G*1.25
					bb = Particle.B*1.25
					SetColor rr,gg,bb
					
					glVertex2f Particle.X,Particle.Y
					glVertex2f Particle.X+(Particle.XSpeed*LengthMultiplier),Particle.Y+(Particle.YSpeed*LengthMultiplier)
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
				If link._succ._value<>link._succ 
					link=link._succ
	
					rr = Particle.R*1.25
					gg = Particle.G*1.25
					bb = Particle.B*1.25
					SetColor rr,gg,bb
					
					DrawLine Particle.X,Particle.Y,Particle.X+Particle.XSpeed,Particle.Y+Particle.YSpeed
				
				Else
			  		link=Null
			  End If		
			Wend			

		End If
		
			Local link:TLink= List.FirstLink()
			While link
			  Local Particle:ParticleManager=ParticleManager(link._value)
			  If link._succ._value<>link._succ 
				link=link._succ

							
				rr = Particle.R*1.25
				gg = Particle.G*1.25
				bb = Particle.B*1.25
					
				SetColor rr,gg,bb
					
				SetAlpha .4
				'SetTransform Rotation Direction, This stretches the sprite along it's speed * Factor, Y Stretch along the width
				SetTransform Particle.Direction,Sqr(Particle.XSpeed*Particle.XSpeed+Particle.YSpeed*Particle.YSpeed)*.4,1.2
				DrawImage Image,Particle.X+Particle.XSpeed*1.0,Particle.Y+Particle.YSpeed*1.0
					
				'DrawImage Image,Particle.X+Particle.XSpeed*2.0,Particle.Y+Particle.YSpeed*2.0

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
		  If link._succ._value<>link._succ 
			link=link._succ
			Particle.Update()
		  Else
		    link=Null
		  End If		
		Wend
		'GrabTime:+MilliSecs()-Point3	
	End Function
	

End Type

'-----------------------------------------------------------------------------
'Porticle Manager, Manages glowy Porticles
'-----------------------------------------------------------------------------
Type PorticleManager
	
	Field X:Float,Y:Float
	Field XSpeed:Float,YSpeed:Float
	Field Direction:Float
	
	Field R:Int,G:Int,B:Int
	Field Age:Float
	
	Global List:TList 
	Global Image:TImage
	
	Const PorticleLife:Int = 145
	
	Global ActiveElements:Int
	
	Global DeltaOne:Float
	Global DeltaTwo:Float
	Global DeltaDecay:Float
	Const PorticleDecay:Float = .9925
	
	Const MAXPorticleS:Int = 4096
	Const LengthMultiplier:Byte=2
	
	Global PorticleArray:PorticleManager[]
	
	Global GrabTime:Int
	Global CycleTime:Float
	Global DataPoints:Int
	
	Function Init()
		
		
		
		PorticleArray = New PorticleManager[MAXPorticleS]
		
		If Not List List = CreateList()
		
		If Not Image Then
			Image= LoadImage(GetBundleResource("Graphics/Particle.png"),FILTEREDIMAGE)
			MidHandleImage Image
			image.Frame(0)
		End If

		For Local i = 0 To MAXPorticleS-1
			PorticleArray[i] = New PorticleManager
			PorticleArray[i].Y = 0
			PorticleArray[i].X = 0
			PorticleArray[i].R = 0
			PorticleArray[i].G = 0
			PorticleArray[i].B = 0
			PorticleArray[i].Age = 0
			PorticleArray[i].Direction = 0
			PorticleArray[i].XSpeed = 0
			PorticleArray[i].YSpeed = 0
			PorticleManager.List.Addlast( PorticleArray[i] )				
		Next
		ActiveElements = 0
	End Function	
	
	Function ReCache()
		image.Frame(0)
	End Function

	Function Create( x:Float, y:Float ,Amount:Int, R:Int,G:Int,B:Int, Rotation:Float = 0, Size:Float = 1)	
		
		Local Point1:Int=MilliSecs()
		
		Local Porticle:PorticleManager
		Local Magnitude:Float

		For Local i=1 To Amount*ParticleMultiplier
			
			Porticle:PorticleManager = PorticleArray[ActiveElements]
		
			Porticle.X = X
			Porticle.Y = Y
			Porticle.R = R
			Porticle.G = G
			Porticle.B = B
			Porticle.Age = Rand(PorticleLife-20,PorticleLife)
			
			If ParticleMultiplier>=150 Porticle.Age:+35
			
			If Size>=3 Then Porticle.Age:+10
			
			If Rotation=0
				Porticle.Direction = Rand(0,359)
			Else
				Porticle.Direction = Rnd(Rotation-20,Rotation+20)
			EndIf
			Magnitude = Rnd(7.5,14)
			Porticle.XSpeed = Cos(Porticle.Direction)*Magnitude*Size
			Porticle.YSpeed = Sin(Porticle.Direction)*Magnitude*Size

			Porticle.X:+ Porticle.XSpeed/12
			Porticle.Y:+ Porticle.YSpeed/12
			
			ActiveElements:+1
			
			If ActiveElements=>MAXPORTICLES-1 Then ActiveElements=0
			
		Next
		
		GrabTime:+MilliSecs()-Point1


	EndFunction
		
	Method Update()

		'Local DeltaDecay:Float=PorticleDecay^Delta
		X:+ (XSpeed/7.15)*Delta
		Y:+ (YSpeed/7.15)*Delta

		XSpeed = XSpeed * DeltaDecay
		YSpeed = YSpeed * DeltaDecay
		'XSpeed = XSpeed * PorticleDecay
		'YSpeed = YSPeed * PorticleDecay
		Age:-1*Delta
		
		If Age < 50		
			If Age < 25
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
	
		
	Function DrawAll()
		Local Point2:Int=MilliSecs()

		If ActiveElements = 0
			SetTransform 0,1,1
			Return
		End If
		Local Porticle:PorticleManager
		Local Angle:Float, dx:Float, dy:Float
		Local rr:Int ,gg:Int ,bb:Int
		
		SetBlend LIGHTBLEND								
				
		SetAlpha .8
		SetLineWidth 2
		
		If GlLines
			glDisable GL_TEXTURE_2D; glBegin GL_LINES
			glLineWidth 2.0
			
			For Local t = 0 Until MAXPORTICLES
				Porticle:PorticleManager = PorticleArray[t]

				rr = Porticle.R*1.25
				gg = Porticle.G*1.25
				bb = Porticle.B*1.25
				SetColor rr,gg,bb
				
				glVertex2f Porticle.X,Porticle.Y
				glVertex2f Porticle.X+(Porticle.XSpeed*LengthMultiplier),Porticle.Y+(Porticle.YSpeed*LengthMultiplier)


			Next
			glEnd; glEnable GL_TEXTURE_2D
		Else
			SetTransform 0,2,2
			SetLineWidth 2.0
			For Local t = 0 Until MAXPORTICLES
				Porticle:PorticleManager = PorticleArray[t]

				rr = Porticle.R*1.25
				gg = Porticle.G*1.25
				bb = Porticle.B*1.25
				SetColor rr,gg,bb
				
				DrawLine Porticle.X,Porticle.Y,Porticle.X+Porticle.XSpeed,Porticle.Y+Porticle.YSpeed
					

			Next
		End If
		
		For Local t = 0 Until MAXPORTICLES
			Porticle:PorticleManager = PorticleArray[t]
							
			rr = Porticle.R*1.25
			gg = Porticle.G*1.25
			bb = Porticle.B*1.25
				
			SetColor rr,gg,bb
				
			SetAlpha .4
			'SetTransform Rotation Direction, This stretches the sprite along it's speed * Factor, Y Stretch along the width
			SetTransform Porticle.Direction,Sqr(Porticle.XSpeed*Porticle.XSpeed+Porticle.YSpeed*Porticle.YSpeed)*.4,1.2
			DrawImage Image,Porticle.X+Porticle.XSpeed*1.0,Porticle.Y+Porticle.YSpeed*1.0
				
			'DrawImage Image,Porticle.X+Porticle.XSpeed*2.0,Porticle.Y+Porticle.YSpeed*2.0

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
	
	
	Function UpdateAll()
		Local Point3:Int=MilliSecs()
		If ActiveElements = 0 Return
		'Local counter:Int=0
		DeltaDecay=(PorticleDecay^Delta)
		DeltaTwo=(.98^Delta)
		DeltaOne=(.965^Delta)
		Local Porticle:PorticleManager
			For Local t = 0 Until MAXPORTICLES
				Porticle:PorticleManager = PorticleArray[t]
				Porticle.Update()
			Next
			'CurrentPorticles=Counter	
		GrabTime:+MilliSecs()-Point3		
	End Function
	
	Function ResetAll()
		Local Porticle:PorticleManager
		
		For Local t = 0 To MAXPorticleS-1
			Porticle:PorticleManager = PorticleArray[t]
			Porticle.X = 0
			Porticle.Y = 0
			Porticle.R = 0
			Porticle.G = 0
			Porticle.B = 0
			Porticle.Direction = 0
			Porticle.Age = 0
			Porticle.XSpeed = 0
			Porticle.YSpeed = 0
		Next
		ActiveElements = 0
	End Function

End Type



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
' BIG File Loader
' -----------------------------------------------------------------------------
Function GetBundleResource:String(resourceName:String,chop=False, subDirName:String="")
	Local url:String
	'Local url:String = Left(AppFile, Instr(AppFile, ".app/", 0)) + "app/Contents/Resources/"
	'If(subDirName) Then url :+ subDirName + "/"
	'If Chop Then url=Right(url,Len(url)-1)
	url="zip::data.big//"+ resourceName
	'Print url
	Return url
End Function

