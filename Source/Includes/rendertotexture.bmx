Const DDERR_INVALIDSURFACETYPE 	= $88760250
Const DDERR_INVALIDPARAMS		= $80070057
Const DDERR_INVALIDOBJECT 		= $88760082
Const DDERR_NOTFOUND 			= $887600ff
Const DDERR_SURFACELOST 		= $887601c2

Global tRenderERROR:String

Function tError:String(err:Int)

	Select err
		Case DDERR_INVALIDSURFACETYPE
			Return "DDERR_INVALIDSURFACETYPE"
			
		Case DDERR_INVALIDPARAMS
			Return "DDERR_INVALIDPARAMS"
			
		Case DDERR_INVALIDOBJECT 
			Return "DDERR_INVALIDOBJECT"
			
		Case DDERR_NOTFOUND
			Return "DDERR_NOTFOUND"
			
		Case DDERR_SURFACELOST
			Return "DDERR_SURFACELOST"
			
	End Select
End Function

Type tRender
	
	?Win32
	Global DXFrame:TD3D7ImageFrame
	Global backbuffer:IDirectDrawSurface7

	?
	Global GLFrame:TGLImageFrame
	Global DX:Int 
	Global Image:TImage = CreateImage(1,1)
	Global Width:Int
	Global Height:Int
	Global o_r,o_g,o_b
Rem
bbdoc: Initialise the Module
about: 
The module must be initialised before use. This ensures usage of the correct render pipeline. If the render device is changed then you must 
re initialise the module.
End Rem		
	Function Init()
	?Win32
		If _max2dDriver.ToString() = "DirectX7"
			DX = True
			D3D7GraphicsDriver().Direct3DDevice7().GetRenderTarget Varptr backbuffer

		'	ViewPort = New D3DVIEWPORT7
		Else
	?
			DX = False
			GlEnable(GL_TEXTURE_2D)
	?Win32
		EndIf
	?
		DebugLog "Render2Texture: Initialise OK"
		Return True
	End Function
	
'#################################################################################

Rem
bbdoc: Create Image with Render Characteristics
returns: TImage Handle to Object
about: 
 <table>
		<tr><td><b>Width:Int</td><td>Width in Pixels of Image, try to follow the normal rules of textures</td></tr>
		<tr><td><b>Height:Int</td><td>Height in Pixels of Image</td></tr>
		<tr><td><b>Flags:Int</td><td>Normal Image Flags</td></tr>
	</table>
End Rem	
	Function Create:TImage(Width:Int,Height:Int,Flags:Int=FILTEREDIMAGE)

		Local t:TImage=New TImage
		t.width=width
		t.height=height
		t.flags=flags
		t.mask_r= 0
		t.mask_g= 0
		t.mask_b= 0
		t.pixmaps=New TPixmap[1]
		t.frames=New TImageFrame[1]
		t.seqs=New Int[1]
		t.pixmaps[0]= t.Lock(0,True,False)
		t.seqs[0]=GraphicsSeq
		
	'	MaskPixmap( t.pixmaps[0],mask_r,mask_g,mask_b )
	?Win32	
		If DX
			t.frames[0] = CreateFrame(TD3D7Max2DDriver(_max2dDriver),t.Width,t.Height,t.flags)
		Else
	?
			t.frames[0] = TGLImageFrame.CreateFromPixmap:TGLImageFrame( t.pixmaps[0],t.flags )
	?Win32
		EndIf
	?
		
		DebugLog "Render2Texture: Create OK"
		
		
		Return t

	End Function

'#################################################################################
?Win32			
	Function CreateFrame:TD3D7ImageFrame( driver:TD3D7Max2DDriver,width,height,flags )				
		Function Pow2Size( n )
			Local t=1
			While t<n
				t:*2
			Wend
			Return t
		End Function

		Local	swidth=Pow2Size(width)
		Local	sheight=Pow2Size(height)
		Local	desc:DDSURFACEDESC2=New DDSURFACEDESC2
		Local	res
						
		desc.dwSize=SizeOf(desc)
		desc.dwFlags=DDSD_WIDTH|DDSD_HEIGHT|DDSD_CAPS|DDSD_PIXELFORMAT
		desc.dwWidth=swidth
		desc.dwHeight=sheight	
		desc.ddsCaps=DDSCAPS_TEXTURE|DDSCAPS_3DDEVICE|DDSCAPS_VIDEOMEMORY|DDSCAPS_LOCALVIDMEM  ' **************************************************
		desc.ddsCaps2=DDSCAPS2_HINTDYNAMIC'|DDSCAPS2_TEXTUREMANAGE
		desc.ddpf_dwSize=SizeOf(DDPIXELFORMAT)
		desc.ddpf_dwFlags=DDPF_RGB|DDPF_ALPHAPIXELS
		desc.ddpf_BitCount=32
		desc.ddpf_BitMask_0=$ff0000
		desc.ddpf_BitMask_1=$00ff00
		desc.ddpf_BitMask_2=$0000ff
		desc.ddpf_BitMask_3=$ff000000

		
		Local surf:IDirectDrawSurface7
		If flags & MIPMAPPEDIMAGE desc.ddsCaps:|DDSCAPS_MIPMAP|DDSCAPS_COMPLEX
		res=D3D7GraphicsDriver().DirectDraw7().CreateSurface( desc,Varptr surf,Null )
			
		If res<>DD_OK 
			tRenderERROR = tError(res)
			'DebugLog "tRender : CreateFrame ERROR : "+tRenderERROR
			Return Null
		EndIf
		'RuntimeError "Create DX7 surface Failed"	
							
		Local frame:TD3D7ImageFrame=New TD3D7ImageFrame
		frame.driver=driver
		frame.surface=surf
		frame.sinfo=New DDSURFACEDESC2
		frame.sinfo.dwSize=SizeOf(frame.sinfo)
		frame.xyzuv=New Float[24]
		frame.width=width
		frame.height=height
		frame.flags=flags
		frame.SetUV 0.0,0.0,Float(width)/swidth,Float(height)/sheight
	
			
		'frame.BuildMipMaps()
		'DebugLog "tRender : CreateFrame OK"
		Return frame
	End Function
?
	
'#################################################################################
Rem
bbdoc: Set Screen Viewport
about: 
 <table>
	<tr><td><b>X:Int</td><td>Set the X Position of the Viewport</td></tr>
	<tr><td><b>Y:Int</td><td>Set the Y Position of the Viewport</td></tr>
	<tr><td><b>Width:Int</td><td>Set the Viewport Width in Pixels</td></tr>
	<tr><td><b>Height:Int</td><td>Set the Viewport Height in Pixels</td></tr>
	<tr><td><b>FlipY:Byte</td><td>Flip the Viewport on the Y Axis, OpenGL only. Automatically done by the Texture Renderer.</td></tr>
 </table>
End Rem	
	Function ViewportSet(X:Int=0,Y:Int=0,Width:Int,Height:Int,FlipY:Byte=False)
	?Win32
		If DX
			Local viewport:D3DVIEWPORT7=New D3DVIEWPORT7
			viewport.dwX=x
			viewport.dwY=y
			viewport.dwWidth=width
			viewport.dwHeight=height
			D3D7GraphicsDriver().Direct3DDevice7().SetViewport(viewport)
		Else
	?
			If FlipY
				glViewport(X, Y, Width, Height)
				glMatrixMode(GL_PROJECTION)
				glPushMatrix()
				glLoadIdentity()
				gluOrtho2D(X,  VirtualResolutionWidth(),  VirtualResolutionHeight(),Y)
				glScalef(1, -1, 1)
				glTranslatef(0, -VirtualResolutionHeight(), 0)
				glMatrixMode(GL_MODELVIEW)
			Else
				glViewport(X, Y, Width, Height)
				glMatrixMode(GL_PROJECTION)
				glLoadIdentity()
				glOrtho(X, VirtualResolutionWidth(), VirtualResolutionHeight(), Y, -1, 1)
				glMatrixMode(GL_MODELVIEW)
				glLoadIdentity()
			EndIf
	?Win32
		EndIf
	?
		'DebugLog "tRender : ViewportSet OK"
		Return True
	EndFunction
	
'#################################################################################
Rem
bbdoc: Begin the Texture Render Process
about: 
 <table>
	<tr><td><b>Image:TImage</td><td>The Image to Render to, as created with "Create" command.</td></tr>
	<tr><td><b>Viewport:Byte</td><td>True (default) to Automatically resize the viewport to the image size</td></tr>
 </table>
End Rem
	Function TextureRender_Begin(Image1:TImage,Viewport:Byte=True)
	SetScale Float(VirtualResolutionWidth())/Float(ImageWidth(image1)),Float(VirtualResolutionHeight())/Float(ImageHeight(image1))


		Image = Image1
		If Viewport Then 
			Width = image1.width
			Height = image1.height
		Else
			Width = GraphicsWidth()
			Height = GraphicsHeight()
		EndIf
		
		If DX
			?Win32
			D3D7GraphicsDriver().Direct3DDevice7().EndScene()
			?
			'DebugLog "w : " + width + " h : " + height
			SetViewport(0,0,Width,Height)
			'ViewportSet(0,0,Width,Height)
		Else
			'SetViewport(0,0,Width,Height)
			ViewportSet(0,0,Width,Height,True)
		EndIf
		
	?Win32	
		If DX
			Local DXFrame:TD3D7ImageFrame = TD3D7ImageFrame (image1.frame(0))
			D3D7GraphicsDriver().Direct3DDevice7().SetRenderTarget( DXFrame.Surface,0)
			D3D7GraphicsDriver().Direct3DDevice7().BeginScene()
		Else
	?
			GLFrame:TGLImageFrame = TGLImageFrame(Image1.frame(0))
		'	ViewportSet(0,0,Width,Height,True)
	?Win32
		EndIf		
	?
	'	'DebugLog "tRender : TextureRender_Begin OK"
		Return True
	End Function
	
'#################################################################################
Rem
bbdoc: Clear the Current Viewport with color
about: 
 <table>
	<tr><td><b>col:Int</td><td>The Color to clear the Viewport with includes Alpha AARRGGBB format.</td></tr>
 </table>
End Rem
	Function Cls(col:Int=$FF000000)
	?Win32	
		If dx
			D3D7GraphicsDriver().Direct3DDevice7().Clear 1,Null,D3DCLEAR_TARGET,col,0,0
		Else
	?
				Local Red# 	= (col Shr 16) & $FF
				Local Green# 	= (col Shr 8) & $FF
				Local Blue# 	= col & $FF
				Local Alpha# 	= (col Shr 24) & $FF
			'	'DebugLog Alpha
				glClearColor red/255.0,green/255.0,blue/255.0,alpha/255.0
				glClear GL_COLOR_BUFFER_BIT
	?Win32	
		EndIf
	?
	End Function
	
'#################################################################################
?win32	
	Function SetMipMap(Image:TImage,Level:Int)
		If DX
			Local DXFrame:TD3D7ImageFrame = TD3D7ImageFrame (image.frame(0))
			
			'DXFrame.BuildMipMaps()
			
			Local	src:IDirectDrawSurface7
			Local	dest:IDirectDrawSurface7
			Local	caps2:DDSCAPS2
			caps2=New DDSCAPS2
			caps2.dwCaps=DDSCAPS_TEXTURE|DDSCAPS_MIPMAP'|DDSCAPS_3DDEVICE
			caps2.dwCaps2= DDSCAPS2_MIPMAPSUBLEVEL
		
			src = DXFrame.Surface
					
			Local res = src.GetAttachedSurface(caps2,Varptr dest)
			
			If res<>DD_OK 
				tRenderERROR = tError(res)
				Return False
			EndIf
			
			DXFrame.Surface =  dest
			dest.Release_
			
			'DebugLog "MipMap Selected OK"
			Return True
		Else
			Return False
		EndIf	
	End Function
?	
'#################################################################################
Rem
bbdoc: End the Texture Render Process
about: 
This Must be called when you have finished rendering to the Texture
End Rem	
	Function TextureRender_End()
	SetScale 1.0, 1.0

	?Win32
		If dx
			D3D7GraphicsDriver().Direct3DDevice7().EndScene()
		Else
	?
			glBindTexture GL_TEXTURE_2D, GLFrame.name
'			glCopyTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, 0, 0, Width, Height, 0)
			glCopyTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, 0, 0, NextPowSize(width), NextPowSize(Height), 0) 
			glBindTexture GL_TEXTURE_2D, 0
	?Win32
		EndIf
	?
		'SetViewport(0,0,ScreenWidth,ScreenHeight)
		ViewportSet(0,0,GraphicsWidth(),GraphicsHeight())
		DrawImageRect Image,-2000,-2000,1,1


	'	'DebugLog "tRender : TextureRender_End OK"
		Return True
	End Function
	
'#################################################################################
Rem
bbdoc: Begin the Normal BackBuffer Rendering Process
End Rem
	Function BackBufferRender_Begin()
	?Win32
		If DX Then 
			D3D7GraphicsDriver().Direct3DDevice7().SetRenderTarget(backbuffer,0)
			
			
		Else
	?		
		'	If GLFrame <> Null Then glBindTexture GL_TEXTURE_2D,GLFrame.name
	?Win32
		EndIf
	?
		'SetViewPort(0,0,ScreenWidth,ScreenHeight)
		ViewportSet(0,0,GraphicsWidth(),GraphicsHeight())
	If DX SetViewport (0,0,ScreenWidth,ScreenHeight)
		'DebugLog "tRender : BackBufferRender_Begin OK"
		Return True
	End Function
	
'#################################################################################
Rem
bbdoc: End the Normal BackBuffer Rendering process
about: 
This Must be called when you have finished rendering to the BackBuffer and Before the Flip Command.
End Rem	
	Function BackBufferRender_End()
	?Win32
		If DX
			D3D7GraphicsDriver().Direct3DDevice7().EndScene()
		Else
	?
			glBindTexture GL_TEXTURE_2D,0
	?Win32
		EndIf
	?
		'DebugLog "tRender : BackBufferRender_End OK"
		Return True
	End Function
	
'#################################################################################
	
		Function NextPowSize(n) 
			Local t = 1
			While t<n
				t:*2
			Wend
			Return t
		End Function	

End Type