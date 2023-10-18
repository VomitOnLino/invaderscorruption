'Aspect correction module
SuperStrict

Rem
bbdoc: Gaphics/Aspect
End Rem
Module ODD.Aspect

ModuleInfo "Version: 1.0"
ModuleInfo "Author: David Williamson"
ModuleInfo "License: Public Domain"

Import BRL.Max2D

Const ASPECT_KEEP:Int=1
Const ASPECT_STRETCH:Int=0
Const ASPECT_LETTERBOX_FILL:Int=2
Const ASPECT_LETTERBOX_BORDER:Int=3
Const ASPECT_BESTFIT_FILL:Int=4
Const ASPECT_BESTFIT_BORDER:Int=5	'Bestfit border may not work with all drivers(i.e. DirectX)

Private

Global _xoffset:Float
Global _yoffset:Float
Global _vwidth:Float
Global _vheight:Float
Global _mode:Int=ASPECT_STRETCH
Global _bred:Int=0
Global _bgreen:Int=0
Global _bblue:Int=0

Public

Rem
bbdoc: Sets a virtual graphics resolution
about: Similar to #SetVirtualResolution this function allows you to set a 'virtual' resolution independent of the graphics resolution.

This allows you to design an application to work at a fixed resolution, say 640 by 480, and run it at any graphics resolution.

@mode allows you to specify how mismatched aspect ratios are handled. The available modes are:
[ @ASPECT_KEEP | Keeps the previously set mode
* @ASPECT_STRETCH | Stretches/distorts the display to fit the screen
* @ASPECT_LETTERBOX_FILL | Scales the display to fit the screen but maintains it's aspect ratio. Any draw space left around it is @not clipped
* @ASPECT_LETTERBOX_BORDER | Scales the display to fit the screen but maintains it's aspect ratio. Any draw space left around it is clipped
* @ASPECT_BESTFIT_FILL | Scales the display by whole numbers only whilst maintaining it's aspect ratio. Any draw space left around it is @not clipped
* @ASPECT_BESTFIT_BORDER | Scales the display by whole numbers only whilst maintaining it's aspect ratio. Any draw space left around it is clipped
]
@ASPECT_BESTFIT_BORDER may not display corectly with some drivers.
End Rem
Function SetAspectResolution( width:Float, height:Float, mode:Int=ASPECT_KEEP )
	If mode<>ASPECT_KEEP Then _mode=mode
	If _mode=ASPECT_STRETCH
		_xoffset=0;_yoffset=0;_vwidth=width;_vheight=height
		SetVirtualResolution(_vwidth,_vheight)
		SetViewport _xoffset,_yoffset,Ceil(_vwidth),Ceil(_vheight)
		SetOrigin _xoffset,_yoffset
		Return
	EndIf
	Local gwidth:Int=GraphicsWidth()
	Local gheight:Int=GraphicsHeight()
	_vwidth=width
	_vheight=height
	Local wratio:Float=gwidth/_vwidth
	Local hratio:Float=gheight/_vheight
	If wratio<hratio Then hratio=wratio
	If _mode&4
		hratio=Floor(hratio)
		hratio=Max(hratio,1)
	EndIf
	height=gheight/hratio
	width=gwidth/hratio
	
	_xoffset=(width-_vwidth)*.5
	_yoffset=(height-_vheight)*.5
	If _mode&4
		_xoffset=Floor(_xoffset)
		_yoffset=Floor(_yoffset)
	EndIf
	SetVirtualResolution(width,height)
	
	If _mode&1
		Local red:Int,green:Int,blue:Int
		GetClsColor red,green,blue
		SetClsColor _bred,_bgreen,_bblue
		Cls
		SetClsColor red,green,blue
		SetViewport _xoffset,_yoffset,_vwidth,_vheight
	Else
		SetViewport 0,0,Ceil(VirtualResolutionWidth()),Ceil(VirtualResolutionHeight())
	EndIf
	
	SetOrigin _xoffset,_yoffset
	
End Function

Rem
bbdoc: Sets the border color for modes that have a border
about: Sets the color that the border will be cleared with. See #AspectCls for how to clear the border.
End Rem
Function SetAspectColor( red:Int, green:Int, blue:Int )
	_bred=red
	_bgreen=green
	_bblue=blue
End Function

Rem
bbdoc: Clears the screen and border.
about: Use this function to clear the screen and border. Use #Cls to only clear the virtual display area.
End Rem
Function AspectCls()
	If _mode&1
		SetViewport 0,0,Ceil(VirtualResolutionWidth())+1,Ceil(VirtualResolutionHeight())+1
		Local red:Int,green:Int,blue:Int
		GetClsColor red,green,blue
		SetClsColor _bred,_bgreen,_bblue
		Cls
		SetClsColor red,green,blue
		SetViewport _xoffset,_yoffset,_vwidth,_vheight
	EndIf
	Cls
End Function

Rem
bbdoc: Switches the aspect ratio correction mode.
about: See #SetAspectResolution for an explination of the modes.
End Rem
Function SwitchAspectMode( mode:Int )
	SetAspectResolution _vwidth,_vheight,mode
End Function

Rem
bbdoc: Sets the draw origin.
about: Use instead of #SetOrigin to set the draw origin of the display.
End Rem
Function SetAspectOrigin( x:Float, y:Float )
	SetOrigin x+_xoffset,y+_yoffset
End Function

Rem
bbdoc: Get the current origin position
returns: The horizontal and vertical position of the current origin.
End Rem
Function GetAspectOrigin( x:Float Var, y:Float Var )
	GetOrigin x,y
	x:-_xoffset
	y:-_yoffset
End Function

Rem
bbdoc: Set drawing viewport
about: Use in place of #SetViewport
End Rem
Function SetAspectViewport( x:Int, y:Int, width:Int, height:Int )
	Local x2:Float=Min(x+width,_xoffset+_vwidth)
	Local y2:Float=Min(y+height,_yoffset+_vheight)
	x=Max(x,_xoffset)
	y=Max(y,_yoffset)
	SetViewport x,y,x2-x,y2-y
End Function

Rem
bbdoc: Get viewport values.
returns: The horizontal, vertical, width and height values of the current Viewport in the variables supplied.
about: Use insted of #GetViewport
End Rem
Function GetAspectViewport( x:Int Var,y:Int Var,width:Int Var,height:Int Var )
	GetViewport x,y,width,height
	x:-_xoffset
	y:-_yoffset
End Function

Rem
bbdoc: Get virtual mouse X coordinate
returns: Mouse X position
about: Use in place of #VirtualMouseX
End Rem
Function AspectMouseX:Float()
	Return VirtualMouseX()-_xoffset
End Function

Rem
bbdoc: Get virtual mouse Y coordinate
returns: Mouse Y position
about: Use instead of #VirtualMouseY
End Rem
Function AspectMouseY:Float()
	Return VirtualMouseY()-_yoffset
End Function

Rem
bbdoc: Move the virtual mouse.
End Rem
Function MoveAspectMouse( x:Float, y:Float )
	MoveVirtualMouse x+_xoffset,y+_yoffset
End Function

Rem
bbdoc: Get virtual graphics resolution width
returns: Virtual width
End Rem
Function AspectResolutionWidth:Float()
	Return _vwidth
End Function

Rem
bbdoc: Get virtual graphics resolution heght
returns: Virtual height
End Rem
Function AspectResolutionHeight:Float()
	Return _vheight
End Function
