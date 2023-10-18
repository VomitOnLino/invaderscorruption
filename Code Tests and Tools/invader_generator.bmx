Strict

Framework BRL.GlMax2d
Import BaH.Random
'Import BRL.Retro

AppTitle="Method 1"

Global InvaderPixels:Int[5,5,200]
Global InvaderColor[200,4]
Global Horizontal=0:Int,Vertical=0:Int
Global ExitCode


AutoMidHandle True

Local InvaderBlur:TImage=Null
Local Invader:TImage[200]
Local InvaderGlow:TImage[200]

Graphics 1024,768
SeedRnd(MilliSecs())
Cls
DrawText ("Generating Procedural Invaders...",385,355)
Flip
While Not ExitCode

	Local t1=MilliSecs()
	Local TempGlow:TPixmap
	Local TempInvader:TPixmap
	Local GenTime:Int
	
	GenerateInvaders(192)

	'For all of the invaders we have
	For Local z=0 To 191
		
		Cls
		'Loop through one invader's pixel array
		For Local x=0 To 4
			For Local y=0 To 4
				
				'If the Pixel is not 0 Draw it
				If InvaderPixels[x,y,z]=1
					
					'Set the invader color
					SetColor InvaderColor[z,0],InvaderColor[z,1],InvaderColor[z,2]
					'Then draw the pixel
					DrawRect(30+x*16,30+y*16,16,16)
				
				End If
			
			Next
		Next
		
		
		TempInvader=GrabPixmap(30,30,80,80)
		TempInvader=MaskPixmap(TempInvader,0,0,0)

		For Local x=0 To 4
			For Local y=0 To 4
				
				'If the Pixel is not 0 Draw it
				If InvaderPixels[x,y,z]=1
					
					'Then draw the pixel
					DrawRect(130+x*4,130+y*4,4,4)
				
				End If
			
			Next
		Next
		
		TempGlow=GrabPixmap(125,125,30,30)
		
		TempGlow=MaskPixmap(TempGlow,0,0,0)
		
		TempGlow=GaussianBlur(TempGlow,6)
		
		TempGlow=ResizePixmap(TempGlow,128,128)
		
		Invader[z]=LoadImage(TempInvader)
		InvaderGlow[z]=LoadImage(TempGlow)
		
		
		

	Next
	
	
	Gentime=(MilliSecs()-t1)
	
	Local d:Int=0,r=0
	
		Local t3=MilliSecs()
		Cls
		
		SetColor 40,40,40
		DrawRect (0,0,GraphicsWidth(),GraphicsHeight())
		SetColor 255,255,255
		
		SetScale .5,.5
		SetBlend ALPHABLEND
		
		For Local h=0 To 191
			
			DrawImage Invader[h],60+d*60,60+r*60
			

			SetBlend LIGHTBLEND

		
			DrawImage InvaderGlow[h],60+d*60,60+r*60
			
			d:+1
			
			If d>=16 Then d=0; r:+1

		
		Next
		
		
		SetScale 1,1
		Local NoString:String="Frametime: "+(MilliSecs()-t3)+"  |  Generation Time: "+GenTime
		DrawText NoString,0,0
		
		Flip

		
		While Not MouseHit(1)
			If KeyHit(KEY_ESCAPE) Or AppTerminate() Then End
		Wend
		SetScale 1,1
		
		If KeyHit(KEY_ESCAPE) Or AppTerminate() Then End
	
Wend


Function GenerateInvaders(NumInvaders)
	Local PixelCount:Int
	
	'SeedRnd(1234)
	
	'Generate NumInvaders Invaders
	For Local k=0 To NumInvaders-1
		For Local i=0 To 2
			For Local j=0 To 4
				
				'A Pixel can be either 0 (Black) or 1 (White)
				InvaderPixels[i,j,k]=Rand(0,1)
				InvaderColor[k,i]=Rand(100,230)
				'Count the number of White Pixels
				PixelCount:+InvaderPixels[i,j,k]
			Next
		Next
		
		'If a special chance is met, X mirror the invader too
		If Rand(0,100)=42 And PixelCount<=8
	
			For Local n=0 To 4
		
				InvaderPixels[n,4,k]=InvaderPixels[n,0,k]
				InvaderPixels[n,3,k]=InvaderPixels[n,1,k]
		
			Next
			
			'Print Mirror
		
		End If
		
		'If there are less than 3 White pixels, redo this invader
		If PixelCount<=5 Or PixelCount>=14 Then 
			PixelCount=0
			k:-1
		Else
			PixelCount=0
		End If
	Next
	

	
	'Then go and mirror all invaders along the Y axis
	For Local m=0 To NumInvaders-1
		For Local n=0 To 4
		
			InvaderPixels[4,n,m]=InvaderPixels[0,n,m]
			InvaderPixels[3,n,m]=InvaderPixels[1,n,m]
		
		Next
	Next

End Function


Function gaussianblur:TPixmap(tex:TPixmap, radius:Int)
	If radius <=0 Return tex
	Local texclone:TPixmap = tex.copy()			'clone incoming texture
	Local filter:TGaussianFilter = New TGaussianFilter		'instantiate a new gaussian filter
		filter.radius = radius					'configure it
	Return filter.apply(tex, texclone)
End Function

Type TGaussianFilter

	Field radius:Double
	Field kernel:TKernel
	
	Method apply:TPixmap(src:TPixmap, dst:TPixmap)
		Self.kernel = makekernel(Self.radius)
		Self.convolveAndTranspose(Self.kernel, src, dst, PixmapWidth(src), PixmapHeight(src), True)
		Self.convolveAndTranspose(Self.kernel, dst, src, PixmapHeight(dst), PixmapWidth(dst), True)
		dst = Null
		GCCollect()
		Return src
	End Method

'Make a Gaussian blur kernel.

	Method makekernel:TKernel(radius:Double)
		Local r:Int = Int(Ceil(radius))
		Local rows:Int = r*2+1
		Local matrix:Double[] = New Double[rows]
		Local sigma:Double = radius/3.0
		Local sigma22:Double = 2*sigma*sigma
		Local sigmaPi2:Double = 2*Pi*sigma
		Local sqrtSigmaPi2:Double = Double(Sqr(sigmaPi2))
		Local radius2:Double = radius*radius
		Local total:Double = 0
		Local index:Int = 0

		For Local row:Int = -r To r
			Local distance:Double = Double(row*row)
			If (distance > radius2)
				matrix[index] = 0
			Else
				matrix[index] = Double(Exp(-(distance/sigma22)) / sqrtSigmaPi2)
				total:+matrix[index]
				index:+1
			End If
		Next

		For Local i:Int = 0 Until rows
			matrix[i] = matrix[i]/total			'normalizes the gaussian kernel
		Next 

		Return mkernel(rows, 1, matrix)
	End Method
	
	Function mkernel:TKernel(w:Int, h:Int, d:Double[])
		Local k:TKernel = New TKernel
			k.width = w
			k.height = h
			k.data = d
		Return k
	End Function


	Method convolveAndTranspose(kernel:TKernel, in:TPixmap, out:TPixmap, width:Int, height:Int, alpha:Int)
		Local inba:Byte Ptr = in.pixels
		Local outba:Byte Ptr = out.pixels
		Local matrix:Double[] = kernel.getKernelData()
		Local cols:Int = kernel.getWidth()
		Local cols2:Int = cols/2
		
		For Local y:Int = 0 Until height
			Local index:Int = y
			Local ioffset:Int = y*width
				For Local x:Int = 0 Until width
					Local r:Double = 0, g:Double = 0, b:Double = 0, a:Double = 0
					Local moffset:Int = cols2
						For Local col:Int = -cols2 To cols2
							Local f:Double = matrix[moffset+col]
					If (f <> 0)
						Local ix:Int = x+col
						If ( ix < 0 )
							ix = 0
						Else If ( ix >= width)
							ix = width-1
						End If
						
						Local rgb:Int = (Int Ptr inba)[ioffset+ix]
						a:+f *((rgb Shr 24) & $FF)
						b:+f *((rgb Shr 16) & $FF)
						g:+f *((rgb Shr 8) & $FF)
						r:+f *(rgb & $FF)
					End If
				Next
				Local ia:Int
					If alpha = True Then ia = clamp(Int(a+0.5)) Else ia = $FF
				Local ir:Int =clamp( Int(r+0.5))
				Local ig:Int = clamp(Int(g+0.5))
				Local ib:Int = clamp(Int(b+0.5))
				(Int Ptr outba)[index] =((ia Shl 24) | (ib Shl 16) | (ig Shl 8) | (ir Shl 0))
				index:+height
				Next
		Next
	End Method
End Type

Type TKernel

	Field width:Int
	Field height:Int
	Field data:Double[]
	
	Method getkerneldata:Double[]()
		Return Self.data
	End Method
	
	Method getwidth:Int()
		Return Self.width
	End Method
	
	Method getheight:Int()
		Return Self.height
	End Method

End Type

Function clamp:Int(val:Int)
If val < 0
	Return 0
ElseIf val > 255
	Return 255
Else
	Return val
EndIf
End Function
