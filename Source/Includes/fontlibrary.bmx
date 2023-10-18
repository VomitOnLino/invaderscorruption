'FONT SPECIFIERS
Const MAX_BITMAPFONT_STANDARD_CHARS%=256 'for standard chars
Const MAX_BITMAPFONT_EXTRA_CHARS%=150 'for special Unicode chars higher than MAX_BITMAPFONT_CHARS. (If more are needed the arrays will be resized dynamically.)
Const MAX_BITMAPFONT_CHARS% = MAX_BITMAPFONT_STANDARD_CHARS + MAX_BITMAPFONT_EXTRA_CHARS

'Alignment
Const ALIGN_LEFT% = 0
Const ALIGN_CENTRE% = 1 'Centre Horizontally
Const ALIGN_RIGHT% = 2
Const ALIGN_CENTRE_ALL% = 3 'Centre horizontally AND vertically.
' -----------------------------------------------------------------------------
' TBitmapFont: Loads in a font from a png file and can be used to draw bitmap-based text
' -----------------------------------------------------------------------------
' Thanks to Tim Fisher of Indiepath Ltd. for the original code (now heavily modified)
' Tim's documentation (with extra notes by Jake Birkett):
'
' Generate Fonts using the BitMap Font Editor from www.AngelCode.com (called Bitmap Font Generator)
' The version I'm using is 1.8c (Note by Jake Birkett)
'
' You must do the following to the generated .fnt file!
' Note that since V1.09 of the framework you don't need to modify the .fnt file at all unless
' you want to use a different Scale Factor. (Note by Jake Birkett)

' 1) Replace the very first line with a Scale Factor, this is the scale factor that the Module will reference
'
' The first line will look something like :-
' info face="Arial" size=32 bold=0 italic=0 charset="ANSI" stretchH=100 smooth=1 aa=1 padding=0,0,0,0 spacing=1,1

' Replace it with :-
' scaleF=1.3 (please make sure character case is exactly the same (Note by Jake Birkett))

' 2) Delete lines 2 and 3 which start with "page id" and "chars count". (Note by Jake Birkett)

' It will now look something like :-
' scaleF=1.3
' common lineHeight=64 base=57 scaleW=512 scaleH=512 pages=1
' char id=32   x=0     y=0     width=1     height=0     xoffset=0     yoffset=64    xadvance=14    page=0 
'
' 3) Delete all references to Kerning, they appear after char id=255 (we don't need these)
'
' Note that you can use chars beyond id=255 (Unicode chars for example).  If you have more than
' MAX_BITMAPFONT_EXTRA_CHARS (declared at the top of this file) then you will need to increase
' the value of that Const declaration. (Note by Jake Birkett)

'Finally ***THE FONT IMAGE FILE MUST BE A .PNG***
'
'That's all folks.

Type TBitmapFont

	'Public (Optional Flags)
	Field CharGap:Double=0 'Optional gap between each character.
	Field ChangeHandle%=0 'Set this if you are rotating the text and want the handle to be altered so that the whole string rotates properly.
	Field HandleX: Double=0
	Field HandleY: Double=0
	Field ScaleFactor: Double 'optional scale factor in the file will set a scale in addtion to SetScale
	Field TestString$="ABCXYZ 123" 'I recommend adding 0123 (or whatever is suitable) to this if you are using a font without latin characters.
	
	'Private
	Field ArraySize% = MAX_BITMAPFONT_CHARS 'This may be increased if there are a lot of Unicode characters.
	Field ID%[MAX_BITMAPFONT_CHARS]  'The character code (can be a Unicode character).
	Field Image: TImage 'Set with Create().
	Field NumChars: Short 'Number of characters read in.
	Field NumExtraChars: Short 'Number of extra unicode chars read in.
	Field TextureH: Double 'This is needed so that we can divide integer x and y source coords by it for UV to work.
	Field TextureW: Double 'This is needed so that we can divide integer x and y source coords by it for UV to work.
	Field width: Double[MAX_BITMAPFONT_CHARS] 'Width of character graphic.
	Field height: Double[MAX_BITMAPFONT_CHARS] 'Height of character graphic.
	Field xAdvance: Double[MAX_BITMAPFONT_CHARS] 'This is how much gap is left between the current char and the next one.
	Field xOffset: Double[MAX_BITMAPFONT_CHARS] 'Optional offset to start drawing from.
	Field yOffset: Double[MAX_BITMAPFONT_CHARS] 'Optional offset to start drawing from.
	Field xPos: Double[MAX_BITMAPFONT_CHARS] 'x coordinate to grab character from image.
	Field yPos: Double[MAX_BITMAPFONT_CHARS] 'y coordinate to grab character from image.
		
	Function Create:TBitmapFont(url:Object, flags:Int = -1, LoadBitmap% = 1, YAdjustment% = 0)
		'Load in the bitmap font image and data about the font from a file.
		'URL is the path to the font file.
		'Flags are standard image loading flags.
		'If LoadBitmap is 0 then you must assign an Image later manually.
		'Tip: Don't use textures (bitmap font images) bigger than 1024x1024 as
		'many older cards won't handle them.
		'Often a font exported from BMFont has a YOffset for the characters that makes it hard to centre vertically
		'because the characters are drawn with a space at the top.  You can counter this by adding a YAdjustment
		'which will get applied to YOffset as the font file is read in.  A good value to set it at is the YOffset
		'of the character A (ASCII code 65) in the font file but negative instead of positive.

		Local b:TBitmapFont = New TBitmapFont
		AutoMidHandle False 'Important (don't forget to turn it back on if you need it).
		b.Image = LoadImage(String(url)+".png",flags)
		b.NumChars = 0
		b.NumExtraChars = 0
		Local myfile:TStream = LoadFile("littleendian::" + String(url)+".fnt")
		'Read the Scale Factor if it exists.
		Local temp:String = ReadLine(myfile)
		Local pos1:Byte
		If Upper(Mid(temp,1,6)) = "SCALEF" Then
			pos1:Byte = temp.Find("scaleF=")
			If pos1=255 Then pos1=temp.Find("ScaleF=") 'Check another case if pos1 is -1 (255 for an unsigned byte)
			b.ScaleFactor = Double(Mid(temp,pos1+8,4)) 'Read in 4 chars from after the = sign.
		Else
			b.ScaleFactor = 1 'Default is 1.0
		EndIf
		'Read the Scale Width and Height.
		temp:String = ReadLine(myfile)
		'Ignore info line if it exists.
		If Mid(temp,1,4) = "info" Then temp = ReadLine(myfile)
		pos1:Byte = temp.Find("scaleW=")
		b.TextureW = Double(Mid(temp,pos1+8,4)) 'Read in 4 chars from after the = sign.
		pos1:Byte = temp.Find("scaleH=")
		b.TextureH = Double(Mid(temp,pos1+8,4)) 'Read in 4 chars from after the = sign.
		'Ignore page and chars lines if they exist.
		temp = ReadLine(myfile)		
		If Mid(temp,1,4) = "page" Then temp = ReadLine(myfile)
		If Mid(temp,1,5) = "chars" Then temp = ReadLine(myfile)
		
		'Now loop and read in the data for each character.		
		While True
			pos1:Byte = temp.Find("id=")
			Local ID% = Int(Mid(temp,pos1+4,5))
			Local index% = ID
			If ID>0 Then 'Ignore any negative values (I've seen them outputted from Bitmap Font Generator before)
				'Is this a Unicode char?
				If ID>=MAX_BITMAPFONT_STANDARD_CHARS Then
					index = MAX_BITMAPFONT_STANDARD_CHARS+b.NumExtraChars
					b.NumExtraChars:+1
					If index>=b.ArraySize Then b.ExpandArrays()
				EndIf				
				b.ID[index] = ID
				
				'New code for BMax 1.36
				pos1:Byte = temp.find("x=")
				b.xPos[index] = Double(Mid(temp,pos1+3,4)) 'allow 4 chars for >1000
				pos1:Byte = temp.find("y=")
				b.yPos[index] = Double(Mid(temp,pos1+3,4)) 'allow 4 chars for >1000
				pos1:Byte = temp.find("width=")
				b.Width[index] = Double(Mid(temp,pos1+7,3)) 'allow 3 chars
				pos1:Byte = temp.find("height=")
				b.Height[index] = Double(Mid(temp,pos1+8,3)) 'allow 3 chars
				pos1:Byte = temp.find("xoffset=")
				b.xOffset[index] = Double(Mid(temp,pos1+9,3)) 'allow 3 chars
				pos1:Byte = temp.find("yoffset=")
				b.yOffset[index] = Double(Mid(temp, pos1 + 9, 3)) + YAdjustment 'allow 3 chars
				pos1:Byte = temp.find("xadvance=")
				b.xadvance[index] = Double(Mid(temp,pos1+10,3)) 'allow 3 chars
				b.NumChars:+1	


			EndIf

			If Eof(myfile) Then Exit
						
			'Get the next line ready.
			temp:String = ReadLine(myfile)
			'Have we reached the kernings section?  If so abort the loop.
			If Mid(temp,1,7) = "kerning" Then Exit
		Wend
		CloseStream(myfile)
		Return b		
	End Function

	Method CalcVRAM%() 'in bytes
		'Each pixel takes 4 bytes (32-bit = 24 bit for RGB + 8 bit alpha channel).
		'The texture dimensions are rounded up to the nearest power of
		'2 size in VRAM so take up a lot more room.
		Return 4*Pow2Size(ImageWidth(image))*Pow2Size(ImageHeight(image)) 'Only one frame.
	EndMethod	

	Method Draw(text:String, x:Double, y:Double, Center:Byte = False, RightJustify:Byte = False, RoundX% = False, RoundY% = False, CentreVertically% = 0,Wobble% = False)

		'By default the text is draw Left-Justified, but you can alter that with the Center and RightJustify params.
		'Sometimes drawing characters at sub-pixel positions makes them look blurry, so
		'if you want them to look crisp use the RoundX and RoundY params.  However if you
		'plan to move the text around on-screen smoothly, then you should not use those param.

		'Ingore null strings.
		If text="" Then Return

		Local char:Int
		Local scale_x:Float
		Local scale_y:Float
		
		HandleX=0; HandleY=0
		
		'Store the current scale.
		GetScale(scale_x,scale_y)
				
		'Justify.
		If Center Then
			Local halfwidth:Double = (StringWidth(text) / 2)
			If ChangeHandle Then
				HandleX:+halfwidth
			Else
				x:-halfwidth*scale_x
			EndIf
		EndIf
		If RightJustify Then
			If ChangeHandle Then
				HandleX:+StringWidth(text)*scale_x			
			Else
				x:-StringWidth(text)*scale_x
			EndIf
		EndIf

		'Centre Vertically?
		If CentreVertically Then
			Local halfheight:Double = (StringHeight(TestString) / 2)
			If ChangeHandle Then
				HandleY:+halfheight
			Else
				y:-halfheight * scale_y
			EndIf		
		EndIf

		'Uncomment this test code to see the bounding box of the text.
		'SetAlpha 1
		'DrawRect(x, y, StringWidth(text), StringHeight(TestString))
		'DebugLog StringWidth(text)
		'DebugLog StringHeight(text)
		'SetAlpha 1		
		
	 	'Scale the font by the ScaleFactor.
		scale_x :* ScaleFactor
	 	scale_y :* ScaleFactor
		
		'Loop and output each character.
		Local a:Byte
		For a = 0 To Len(text) -1
			Local letter$ = Mid(text,a+1,1)
			char = Asc(letter)
			
			
			
			If char >= MAX_BITMAPFONT_STANDARD_CHARS Then char=FindChar(letter) 
			
			If char >= 0 Then
				Local xpos:Double = xPos[char]
				Local ypos:Double = yPos[char]
				Local width:Double = width[char]
				Local height:Double = height[char]
				
				
				'Take into account any character offset.
				Local x1:Double = x
				Local y1:Double = y 
				
				If Not ChangeHandle Then
					x1 :+ xOffset[char] * scale_x
					y1 :+ yOffset[char] * scale_y
				Else
					'x1 :+ xOffset[char] * scale_x 
					'y1 :+ yOffset[char] * scale_y '* GraphicInfo.tform_jx
				EndIf
				Local w:Double = width * scalefactor
				Local h:Double = height * scalefactor
				'Local w:Double = width * TextureW * scalefactor 'For pre BMax 1.36
				'Local h:Double = height * TextureH * scalefactor 'For pre BMax 1.36

				'Shall we round the coords for a nice crisp image?
				'Only round if the text is not scaled, otherwise the letters can sometimes draw at different Y coords and it looks bad.
				'RoundX=True
				'roundY=True
				If RoundX And scale_x=1 Then
					x1 = Round(x1)
					w = Round(w)
				EndIf
				If RoundY And scale_y=1 Then
					y1 = Round(y1)
					h = Round(h)
				EndIf
			
				'Prepare to move onto next character.
				Local increment: Double = (xAdvance[char] + CharGap)
				
				If Wobble<>0
					'Print y1
					y1:+Sin((wobble*(a+1)))*4.5
					'Print y1
				End If
				
				'Deal with the Handle.
				If ChangeHandle Then
					'DrawSubImageRect(Image, x1, y1, w, h, xpos, ypos, width, height) 
					DrawSubImageRect(Image, x1-HandleX, y1-HandleY, w, h, xpos, ypos, width, height) 
					HandleX:+ w*GraphicInfo.tform_ix*scale_y
					HandleY:+ w*GraphicInfo.tform_jx*scale_x
				Else
					'Draw normally.
					DrawSubImageRect(Image, x1, y1, w, h, xpos, ypos, width, height) 
					'DrawImageRect(Image,x1,y1,w,h) 'For pre BMax 1.36
					x :+ increment*scale_x
				EndIf
			EndIf
		Next
		
	End Method

	Method DrawAligned(text:String,x:Double,y:Double,alignment%=0,RoundX%=False,RoundY%=False,Shadow%=False)
		'Wrapper function.
		'Pass in an Alignment Const (see below)
		Select alignment
			Case ALIGN_LEFT
				Draw(text,x,y,False,False,RoundX,RoundY)
			Case ALIGN_CENTRE
				Draw(text,x,y,True,False,RoundX,RoundY)
			Case ALIGN_RIGHT
				Draw(text,x,y,False,True,RoundX,RoundY)
			Case ALIGN_CENTRE_ALL
				Draw(text, x, y, True, False, RoundX, RoundY, True)
		End Select
	End Method

	Method DrawStringArray(Text$[],x:Double,y:Double,Center:Byte=False,RightJustify:Byte=False,RoundX%=False,RoundY%=False, lineGap%=0, CentreVert%=0)
		'If LineGap<>0 it will be used as the gap between each line instead of the String Height.
		'CentreVert will centre all the lines vertically based on the y coord passed in.

		'Work out a line height?
		Local gap% = LineGap
		If gap=0 Then gap=StringHeight(TestString)*1.25
		
		'Work out how many lines are in the array.
		Local lines%=Len(Text)
		'Should we centre vertically?
		Local ly#=y
		If CentreVert Then ly:-Round(gap*(lines/2.0))		
		'Draw the lines.
		For Local i%=0 To lines-1
			If Left(text[i],2)=";;" Then
				SetAlpha 0.4
				text[i]=Right(text[i],Len(text[i])-2)
			ElseIf Left(text[i],2)="::" Then
				SetAlpha .8
				text[i]=Right(text[i],Len(text[i])-2)
			Else
				SetAlpha .55
			End If
			Draw(text[i],x,ly,Center,RightJustify,RoundX,RoundY,0)			
			ly:+gap
		Next
	End Method
	
	Method ExpandArrays()
		'Increase all arrays by 100 slots.
		'It's best to increase in batches to save processing time as increasing a single slot at a time
		'would be much more CPU intensive. Also a few extra unused bytes in some arrays won't make any real difference.
		Local Expansion%=100
		ID = ID[0..Len(ID)+Expansion]
		width = width[0..Len(ID)+Expansion]
		height = height[0..Len(ID)+Expansion]
		xAdvance = xAdvance[0..Len(ID)+Expansion]
		xOffset = xOffset[0..Len(ID)+Expansion]
		yOffset = yOffset[0..Len(ID)+Expansion]
		xPos = xPos[0..Len(ID)+Expansion]
		yPos = yPos[0..Len(ID)+Expansion]
		ArraySize :+ Expansion
	End Method
	
	Method FindChar%(char:String)
		Local index%
		Local AscValue% = Asc(char) 'Work out before the loop for speed.
		For index = MAX_BITMAPFONT_STANDARD_CHARS To MAX_BITMAPFONT_STANDARD_CHARS+NumExtraChars-1
			If AscValue = ID[index] Then Return index
		Next
		Return 0 'Error, character not found (Return array slot 0 for safety as -1 would crash array reads).
	EndMethod

	Method Precache()
		'Send to VRAM now to avoid delays later.
		CreateFrames(Image)
	End Method

	Method ResetHandle()
		ChangeHandle=0
		HandleX=0
		HandleY=0
		SetImageHandle(Image,0,0)
	End Method
			
	Method StringHeight:Double(text:String)
		'Hmm this returns an average not sure how useful that is...
		'Also spaces will be treated as 0 height so best not to pass them in.
		'Any characters not in the font will be treated as 0 height too, so be careful.
		'FIX: Now this code ignores 0 height characters.
		'I recommend using a string like "ABCXYZ" or "ABCXYZ0123" if the font may not have latin characters.
		Local i:Int
		Local char%
		Local HeightTotal:Double		
		Local Count%=0
		Local H:Double
		For i = 1 To Len(text)
			Local letter$ = Mid(text,i,1)
			char = Asc(letter)
			If char >= MAX_BITMAPFONT_STANDARD_CHARS Then char=FindChar(letter) 
			H = height[char]
			If H>0 Then
				HeightTotal:+ H
				'HeightTotal:+ H * TextureH 'For pre BMax 1.36
				Count:+1
			EndIf
		Next

		Return (HeightTotal/Double(Count))*scalefactor 

	End Method
	
	Method StringWidth:Double(text:String)
		Local a:Int
		Local char%
		Local width1:Double
		For a = 0 To Len(text) -1
			Local letter$ = Mid(text,a+1,1)
			char = Asc(letter)
			If char >= MAX_BITMAPFONT_STANDARD_CHARS Then char=FindChar(letter) 
			width1:+ xAdvance[char] + CharGap
		Next
		'Subtract the last CharGap if width>0.
		If width1>0 Then width1:-CharGap		
		Return width1*scalefactor
	End Method
		
	Method TruncateString$(text$, width%)
		'Pass in a string and this will truncate it to fit within Width (in pixels).
		Local result$ = ""
		For Local i%=1 To Len(text$)
			Local char$ = Mid(text,i,1)
			If StringWidth(result+char)>width*scalefactor Then Exit
			result :+ char
		Next
		Return result
	End Method
End Type


' -----------------------------------------------------------------------------
' ccLoadFile: Load a file and show error if not found
' -----------------------------------------------------------------------------
Function LoadFile:TStream (ThePath$)
	Local pointer:TStream = ReadFile(ThePath$)
	If Not pointer Then
	    	RuntimeError ("Error loading data: "+ThePath$)
		End
	Else
    	Return Pointer	
  	EndIf
End Function

' -----------------------------------------------------------------------------
' ccPow2Size: Pass in a size and this will return the nearest higher power of 2 size
' -----------------------------------------------------------------------------
Function Pow2Size%(n%)
	Local t%=1
	While t<n
		t:*2
	Wend
	Return t
End Function

' -----------------------------------------------------------------------------
' ccCreateFrames: Caches an Image or Anim Image in VRAM
' by Ian Duff
' -----------------------------------------------------------------------------
Function CreateFrames(image:TImage) 
	'Use this to cache an image or animimage in VRAM for quicker drawing later.
	For Local c%=0 Until image.frames.length
		image.Frame(c)
	Next
End Function