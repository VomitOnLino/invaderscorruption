SuperStrict

Rem
bbdoc: Graphics/Direct3D9 Odd2D
about:
The Direct3D9 Odd2D module provides an Direct3D9 driver for #Odd2D.
End Rem
Module ODD.D3D9Odd2D

ModuleInfo "Version: 1.02"
ModuleInfo "Author: David Williamson"
ModuleInfo "License: Public Domain"

?Win32

Import ODD.Odd2D
Import BRL.D3D9Max2D

Private

Global _driver:TD3D9Odd2DDriver

Public

Type TOD3D9ImageFrame Extends TImageFrame
	Field d3d9if:TD3D9ImageFrame
	
	Method Draw( x0#,y0#,x1#,y1#,tx#,ty#,sx#,sy#,sw#,sh# )
		Local rot:Float=GetRotation()
		Local sclx:Float,scly:Float
		GetScale sclx,scly
		SetRotation rot-_odd2dDriver.tform_scr_rot
		SetScale sclx*_odd2dDriver.tform_scr_zoom,scly*_odd2dDriver.tform_scr_zoom
		_odd2dDriver.TransformPoint tx,ty
		tx:+_odd2dDriver.focus_x+_odd2dDriver.border_x
		ty:+_odd2dDriver.focus_y+_odd2dDriver.border_y
		
		d3d9if.Draw x0,y0,x1,y1,tx,ty,sx,sy,sw,sh
		
		SetRotation rot
		SetScale sclx,scly
	End Method
	
	Function CreateFromPixmap:TOD3D9ImageFrame( pixmap:TPixmap,flags:Int )
		Local frame:TOD3D9ImageFrame=New TOD3D9ImageFrame
		frame.d3d9if:TD3D9ImageFrame=TD3D9ImageFrame(D3D9Max2DDriver().CreateFrameFromPixmap(pixmap,flags))
		Return frame
	End Function
	
End Type

Type TD3D9Odd2DDriver Extends TOdd2DDriver
	Field _d3dDev:IDirect3DDevice9
	
	Method Create:TD3D9Odd2DDriver()
		_m2ddriver=D3D9Max2DDriver()
		
		InitFields
		
		If Not _m2ddriver Then Return Null Else Return Self
	End Method
	
'	Method GraphicsModes:TGraphicsMode[]() Abstract
	
	Method AttachGraphics:TMax2DGraphics( widget:Int, flags:Int )
		Local g:TD3D9Graphics=D3D9GraphicsDriver().AttachGraphics( widget,flags )
		If g Return TMax2DGraphics.Create( g,Self )
	End Method
	
	Method CreateGraphics:TGraphics( width:Int, height:Int ,depth:Int, hertz:Int, flags:Int )
		Local g:TD3D9Graphics=D3D9GraphicsDriver().CreateGraphics( width,height,depth,hertz,flags )
		If g Return TMax2DGraphics.Create( g,Self )
	End Method
	
	Method SetGraphics( g:TGraphics )
		Super.SetGraphics g
		If g Then _d3dDev=TD3D9Graphics(TMax2DGraphics(g)._graphics).GetDirect3DDevice()
	End Method
	
'	Method Flip( sync ) Abstract
	
	Method CreateFrameFromPixmap:TOD3D9ImageFrame( pixmap:TPixmap, flags:Int )
		Return TOD3D9ImageFrame.CreateFromPixmap(pixmap,flags)
	End Method
	
	Method SetBlend( blend:Int )
		Super.SetBlend blend
		Select m2d_blend
		Case MOD2XBLEND
			_d3dDev.SetRenderState D3DRS_ALPHATESTENABLE,False
			_d3dDev.SetRenderState D3DRS_ALPHABLENDENABLE,True
			_d3dDev.SetRenderState D3DRS_SRCBLEND,D3DBLEND_DESTCOLOR
			_d3dDev.SetRenderState D3DRS_DESTBLEND,D3DBLEND_SRCCOLOR
		End Select
	End Method
	
'	Method SetAlpha( alpha# ) Abstract
'	Method SetColor( red,green,blue ) Abstract
'	Method SetClsColor( red,green,blue ) Abstract
'	Method SetViewport( x,y,width,height ) Abstract
'	Method SetTransform( xx#,xy#,yx#,yy# ) Abstract
'	Method SetLineWidth( width# ) Abstract
	
'	Method Cls() Abstract
'	Method Plot( x#,y# ) Abstract
'	Method DrawLine( x0#,y0#,x1#,y1#,tx#,ty# ) Abstract
'	Method DrawRect( x0#,y0#,x1#,y1#,tx#,ty# ) Abstract
'	Method DrawOval( x0#,y0#,x1#,y1#,tx#,ty# ) Abstract
'	Method DrawPoly( xy#[],handlex#,handley#,originx#,originy# ) Abstract
		
'	Method DrawPixmap( pixmap:TPixmap,x,y ) Abstract
'	Method GrabPixmap:TPixmap( x,y,width,height ) Abstract
	
'	Method SetResolution( width#,height# ) Abstract


End Type

Rem
bbdoc: Get Direct3D9 Odd2D Driver
about:
The returned driver can be used with #SetGraphicsDriver to enable Direct3D9 Odd2D 
rendering.
End Rem
Function D3D9Odd2DDriver:TD3D9Odd2DDriver()
	If Not _driver Then
		_driver=New TD3D9Odd2DDriver.Create()
	EndIf
	Return _driver
End Function

?

