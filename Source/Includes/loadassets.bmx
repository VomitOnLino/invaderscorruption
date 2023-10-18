' -----------------------------------------------------------------------------------------------------------------------------------------------------------
' These functions override the regular image loading functions so that we can display an error when an image is missing. 
' -----------------------------------------------------------------------------------------------------------------------------------------------------------

	Function LoadImage:TImage(Url:Object, Flags%=-1)
	
		Local Image:TImage
		
		Image = Brl.Max2D.LoadImage(Url, Flags)
		If Image = Null Then RuntimeError("The following image failed to load: ''" + Replace(String(Url),"zip::","") + "''.  Please reinstall the game.")

		'DrawImage Image, 0, 0
		
		Return Image
		
	End Function
	

	Function LoadAnimImage:TImage(Url:Object, Cell_Width%, Cell_Height%, First_Cell%, Cell_Count%, Flags%=-1)
	
		Local Image:TImage
		Local Frame%

		Image = Brl.Max2D.LoadAnimImage(Url, Cell_Width, Cell_Height, First_Cell, Cell_Count, Flags)
		If Image = Null Then RuntimeError("The following image failed to load: ''" + Replace(String(Url),"zip::","") + "''.  Please reinstall the game.")
		
		'For Frame = First_Cell To First_Cell+(Cell_Count-1)
		'	DrawImage Image, 0, 0, Frame
		'Next  
		
		Return Image
		
	End Function
	
	
' -----------------------------------------------------------------------------------------------------------------------------------------------------------
' This function overrides the regular sound loading function so that we can display an error when a sound-file is missing. 
' -----------------------------------------------------------------------------------------------------------------------------------------------------------

		
	Function LoadSound:TSound(Url:Object, Flags%=0)
	
		Local Sound:TSound
		
		Sound = Brl.Audio.LoadSound(Url, Flags)
		If Sound = Null Then RuntimeError("The following sound failed to load: ''" + Replace(String(Url),"zip::","") + "''.  Please reinstall the game.")

		'DrawImage Image, 0, 0
		
		Return Sound
		
	End Function

' -----------------------------------------------------------------------------------------------------------------------------------------------------------
' This function overrides the regular Font loading function so that we can display an error when a Font is missing. 
' -----------------------------------------------------------------------------------------------------------------------------------------------------------

		
	Function LoadImageFont:TImageFont(Url:Object, Size%=1,FontType%=SMOOTHFONT)
	
		Local Font:TImageFont
		DebugLog FileSize(String(url))
		
		Font = Brl.Max2D.LoadImageFont(Url, Size,FontType)
				
		Return Font
		
	End Function

' -----------------------------------------------------------------------------------------------------------------------------------------------------------
' This function overrides the regular Bank loading function so that we can display an error when a Bank is missing. 
' -----------------------------------------------------------------------------------------------------------------------------------------------------------

		
	Function LoadBank:TBank(Url:Object)
	
		Local Bank:TBank
		
		Bank = Brl.Bank.LoadBank(Url)
		If Bank = Null Then RuntimeError("The following bank failed to load: ''" + Replace(String(Url),"zip::","") + "''.  Please reinstall the game.")

		'DrawImage Image, 0, 0
		
		Return Bank
		
	End Function



' -----------------------------------------------------------------------------------------------------------------------------------------------------------
' This function overrides the standard RuntimeError function which does not work properly.  Assert also does not work.
' -----------------------------------------------------------------------------------------------------------------------------------------------------------

	Function RuntimeError(Error$)
		ShowMouse()
		EndGraphics
		Notify(Error$, True)
		End
	End Function
