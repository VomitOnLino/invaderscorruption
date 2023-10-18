Strict

Framework BRL.GlMax2d
Import BaH.Random
Import BRL.StandardIO
Import BRL.PNGLoader

AppTitle="Method 3"

Global Horizontal=0:Int,Vertical=0:Int
Global ExitCode,Mirror

Global FrameCount:Float[10000],RenderCount:Float[10000]
Global cn:Int

AutoMidHandle True

SeedRnd(1253434)

Global Invader:TInvader = New TInvader


Graphics 1280,800

Cls
DrawText ("Generating Procedural Invaders...",385,355)
Flip

While Not ExitCode
	cn:+1
	
	Local t1:Float=MilliSecs()
	
	Invader.Init(1200)
	
	
	RenderCount[cn]=(MilliSecs()-t1)
	
		SetColor 255,255,255
		Local t3:Float=MilliSecs()
		Cls
		
		SetColor 40,40,40
		DrawRect (0,0,GraphicsWidth(),GraphicsHeight())
		SetColor 255,255,255
		
		Invader.DrawAll()		
		
		'SetScale 1,1
		'Local NoString:String="Frametime: "+(MilliSecs()-t3)+"  |  Generation Time: "+GenTime+"  |   Mirrored Invaders: "+Mirror
		'DrawText NoString,39,5
		
		FrameCount[cn]=(MilliSecs()-t3)
		
		Flip
		
		'While Not MouseHit(1)
		'	If KeyHit(KEY_ESCAPE) Or AppTerminate() Then End
		'Wend
		SetScale 1,1
		
		invader.destroyall()
		
		Mirror=0
		
		If cn=99 Then
			Local FinalFrame:Float
			Local FinalRender:Float
			
			For Local i=1 To 99
			
				FinalRender:+RenderCount[i]
				FinalFrame:+FrameCount[i]
			
			
			Next
			
			Notify "Average render time: "+FinalRender/99+"ms. ~n Average time per frame: "+FinalFrame/99+"ms."
			
			End
		
		End If
		
		WaitKey()
		Local p:TPixmap = GrabPixmap( 0, 0, GraphicsWidth(), GraphicsHeight() )
		SavePixmapPNG( p, "Wallpaper"+GraphicsWidth()+".png" )
		
		If KeyHit(KEY_ESCAPE) Or AppTerminate() Then End
	
Wend


'-----Gaussian Blur filter by "Flameduck" - Optimization & clamping by Manuel van Dyck 2009

Function GaussianBlur:TPixmap(tex:TPixmap, radius:Float,clamptop:Int,clampbottom:Int)
	If radius <=0 Return tex
	Local texclone:TPixmap = tex.copy()			'clone incoming texture
	Local filter:TGaussianFilter = New TGaussianFilter		'instantiate a new gaussian filter
		filter.radius = radius					'configure it
		filter.TopClamp=ClampTop
		filter.BottomClamp=ClampBottom
	Return filter.apply(tex, texclone)
End Function

Type TGaussianFilter

	Field radius:Double
	Field kernel:TKernel
	Field TopClamp:Int
	Field BottomClamp:Int
	
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
					If alpha = True Then ia = clamp(Int(a+0.5),TopClamp,BottomClamp) Else ia = $FF
				Local ir:Int =clamp( Int(r+0.5),TopClamp,BottomClamp)
				Local ig:Int = clamp(Int(g+0.5),TopClamp,BottomClamp)
				Local ib:Int = clamp(Int(b+0.5),TopClamp,BottomClamp)
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

Function Clamp:Int(val:Int,Top:Int,Bottom:Int)
	If val < Bottom
		Return 0
	ElseIf val > Top
		Return 255
	Else
		Return val
	EndIf
End Function


'-----------------------------------------------------------------------------
'The Very Basic "Entity-Skeleton" of my Engine, Each animated Object should inherit these functions
'-----------------------------------------------------------------------------
Type TObject

	Field X#,Y#
	Field XSpeed#,YSpeed#
	Field Direction#

	Function Create() EndFunction
	
	Function UpdateAll() EndFunction
	
	Method New() EndMethod
	
	Method Update() EndMethod

	Method Destroy() EndMethod

	Method Draw() EndMethod

End Type


'-----------------------------------------------------------------------------
'The Basic Invader Type
'-----------------------------------------------------------------------------
Type TInvader Extends TObject

	Global List:TList
	Field InvaderBody:TImage
	Field InvaderGlow:TImage
	

	
	Function Init(NumInvaders:Int)
		Local r:Int=0
		Local d:Int=0
		

		If Not List List = CreateList()
		
		Cls
		SetBlend SOLIDBLEND
		
		For Local i=1 To NumInvaders
			
			Local Invader:TInvader = New TInvader	 
			List.AddLast Invader
			
			'Generate and Draw
			GenerateInvader()
			
			'Grab Image and Glow
			Invader.InvaderBody=ReturnSprite()
			Invader.InvaderGlow=ReturnGlow()
			
			
			'Align them in neat rows (for now)
			'Invader.X=40+d*16
			'Invader.Y=40+r*16
			
			Invader.X=40+d*60
			Invader.Y=40+r*60
			'60 width
			'16
			d:+1
			'If d>=59 Then d=0; r:+1
			If d=>42 d=0;r:+1
			
			CacheFrame(Invader.InvaderBody)
			CacheFrame(Invader.InvaderGlow)
			
		Next
		
			
	End Function
	

	Method DrawBody()


		DrawImage InvaderBody,x,y

		
	EndMethod
	
	Method DrawGlow()
		

		DrawImage InvaderGlow,x,y

		
	EndMethod
	
	
	Method Update()

		
	EndMethod

	Function DrawAll()
		If Not List Return 
		
		SetScale 8,8
		SetBlend MASKBLEND
		
		For Local Invader:TInvader = EachIn List
			Invader.DrawBody()
		Next
		
		SetBlend LIGHTBLEND
		'SetScale 8,8
		
		For Local Invader:TInvader = EachIn List
			Invader.DrawGlow()
		Next
		
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
	
	Function GenerateInvader() Private 
		'The amount of White Pixels
		Local PixelCount:Int=0	
		'Stores the Invaders Pixels
		Local InvaderPixels:Int[5,5]
		'Stores the Invaders Colors
		Local InvaderColor[3]
		
		'-----------------MATH GEN ROUTINE-----------------
		
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
				InvaderColor[i]=Rand(85,210)
				
			Next
				
			'If condition is met, X mirror Invader
			If PixelCount>=6 And Rand(0,100)=42 
				
				Mirror:+1
				For Local n=0 To 4
					InvaderPixels[n,4]=InvaderPixels[n,0]
					InvaderPixels[n,3]=InvaderPixels[n,1]
				Next
				
			End If
		Until PixelCount>=5 And PixelCount<=14 

	
		'Mirror invader along the Y axis
		For Local m=0 To 4
			InvaderPixels[4,m]=InvaderPixels[0,m]
			InvaderPixels[3,m]=InvaderPixels[1,m]
		Next
		
		'-----------------DRAWING ROUTINE-----------------
		
		'Cls 'Hack
		SetColor 0,0,0
		DrawRect(30,30,5,5)
		
		'Set the invader color
		SetColor InvaderColor[0],InvaderColor[1],InvaderColor[2]
		
		'Loop through the invader's pixel array 
		For Local x=0 To 4
			For Local y=0 To 4
				
				'Proceed to draw the smaller GLOW invader
				If InvaderPixels[x,y]=1
					
					Plot 30+x,30+y
				
				End If
			
			Next
		Next

	End Function
	
	
	Function ReturnGlow:TImage() Private
		
		'Stores the temporary glow Pixmap
		Local TempGlow:TPixmap
		
		'Grab the Invader Glow and mask it
		'TempGlow=GrabPixmap(29,29,9,9)
		TempGlow=GrabPixmap(28,28,9,9)
		
		
		'Don't need to mask the glow when drawing with LIGHTBLEND
		TempGlow=MaskPixmap(TempGlow,0,0,0)
		
		'Blur the Glow
		TempGlow=GaussianBlur(TempGlow,2,220,35)
		
		'Transfer the Glow
		Return LoadImage(TempGlow)
		
	End Function
	
	Function ReturnSprite:TImage() Private 
	
		'Stores the actual invader sprite Pixmap
		Local TempInvader:TPixmap
	
		'Grab the Invader sprite and mask it against the color 0,0,0
		TempInvader=GrabPixmap(30,30,5,5)
		TempInvader=MaskPixmap(TempInvader,0,0,0)
		
		Return LoadImage(TempInvader,MASKEDIMAGE)
	
	End Function

	Function CacheFrame(image:TImage) 
		'Use this to cache an image or animimage in VRAM for quicker drawing later.
		image.Frame(0)
	End Function

End Type

