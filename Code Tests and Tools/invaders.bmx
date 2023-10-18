Strict

Framework BRL.GlMax2d
Import BaH.Random
'Import BRL.Retro

AppTitle="Invader Generator 0.01"

Global InvaderPixels[12,12,100]
Global InvaderColor[100,12]
Global Regen=False
Global InvaderSolids:Int=0
Global Horizontal=0:Int,Vertical=0:Int
Global exitcode, key
Global superimpose


Graphics 1024,768

SetClsColor 20,20,20

SetColor 32,32,32

While Not ExitCode
	
	Cls
	
	
	
	SeedRnd(MilliSecs())
	
	'Print "Generating..."
	
	For Local k=0 To 99
	Repeat
	InvaderSolids=0
		For Local i=0 To 4
			For Local j=0 To 7
		
				InvaderPixels[i,j,k]=Rand(0,1)
				InvaderColor[k,i]=Rand(70,140)
				InvaderSolids:+InvaderPixels[i,j,k]
			Next
		Next
	
	If InvaderPixels[0,0,k]=1 And InvaderPixels[0,7,k]=1 Then InvaderSolids=40	
	
	Until InvaderSolids>26 And InvaderSolids<38
	Next
	'Print "Mirroring...."
	For Local m=0 To 99
		For Local n=0 To 7
		
			InvaderPixels[8,n,m]=InvaderPixels[0,n,m]
			InvaderPixels[7,n,m]=InvaderPixels[1,n,m]
			InvaderPixels[6,n,m]=InvaderPixels[2,n,m]
			InvaderPixels[5,n,m]=InvaderPixels[3,n,m]
			
		Next
	Next
	
	For Local s=0 To 99
		For Local d=1 To 7
			For Local f=1 To 6
			
				If InvaderPixels[d,f,s]>0
					If InvaderPixels[d-1,f,s]>0
						If InvaderPixels[d+1,f,s]>0
							If InvaderPixels[d,f+1,s]>0
								If InvaderPixels[d,f-1,s]>0
									InvaderPixels[d,f,s]=2
								End If
							End If
						End If
					End If
				End If
		
			Next
		Next
	Next
	
	For Local s=0 To 99
		For Local d=0 To 8
			For Local f=0 To 7
				If InvaderPixels[d,f,s]>0
					If InvaderPixels[d-1,f,s]=0
						If InvaderPixels[d+1,f,s]=0
							If InvaderPixels[d,f+1,s]=0
								If InvaderPixels[d,f-1,s]=0
									InvaderPixels[d,f,s]=0
								End If
							End If
						End If
					End If
				End If
		
			Next
		Next
	Next
	'Print "Drawing..."
	For Local z=1 To 100
		If Horizontal>= 11 Then Vertical:+1; Horizontal=0
		
		SetColor 180,180,180
		DrawRect(4+Horizontal*90,4+Vertical*90,82,82)
		
		For Local x=1 To 9
			For Local y=1 To 8
				
				If InvaderPixels[x-1,y-1,z-1]=1 
					
					SetColor InvaderColor[z-1,0],InvaderColor[z-1,1],InvaderColor[z-1,2]
					DrawRect(x*8+(Horizontal*90),y*8+(Vertical*90),8,8)
					
					
				ElseIf InvaderPixels[x-1,y-1,z-1]=2 
					
					SetColor InvaderColor[z-1,0]+25,InvaderColor[z-1,1]+25,InvaderColor[z-1,2]+25
					DrawRect(x*8+(Horizontal*90),y*8+(Vertical*90),8,8)
				
				End If
		
			Next
		Next
		'If SuperImpose=2 
		Horizontal:+1; Superimpose=0
		'SuperImpose:+1
	Next
	
	Flip
	
	Horizontal=0; Vertical=0
	
	
	
	While Not Key
		If KeyHit(KEY_ESCAPE) Then ExitCode=True; Key=True
		If KeyDown(KEY_SPACE) Then Key=True
	Wend
	
	Key=False
	
Wend

