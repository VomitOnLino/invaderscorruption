'rectangle type to store rectangles
Type TRect
	Field L%, T%, R%, B%
End Type

'point type to store points
Type TPoint
	Field X:Int
	Field Y:Int
End Type


Type TWindowInfo
  	Field cbSize%
	Field wl%,wt%,wr%,wb% 'need to inline the TRect as 4xIntegers
	Field cl%,ct%,cr%,cb% 'need to inline the TRect as 4xIntegers
    Field dwStyle%
    Field dwExStyle%
    Field dwWindowStatus% 
    Field cxWindowBorders%
    Field cyWindowBorders%
    Field atomWindowType:Short 'Research shows an Atom to be a 16-bit value (I hope)
	Field wCreatorVersion:Short
End Type

?win32
Extern "win32"
	Function CreateMutex:Int(lpMutexAttributes :Byte Ptr, bInitialOwner:Int, lpName : Byte Ptr) = "CreateMutexA@12" 
	Function ExtractIconA%(hWnd%,File$z,Index%)
	Function FindWindowA%(NullString%,WindowText$z) 'pass 0 (int) for NullString
	Function GetActiveWindow%()
	Function GetCursorPos%(point: Byte Ptr)
	Function GetDesktopWindow%()
	Function GetDeviceCaps%(hdc, nIndex)
	Function GetDC%(hWnd%)
	Function GetLastError:Int() = "GetLastError@0"
	Function GetWindowInfo(hWnd%, WindowInfo: Byte Ptr)       
    Function GetWindowRect%(hWnd%, lpRect: Byte Ptr)
	Function IsZoomed%(hwnd%)
	Function SetClassLongA%(hWnd%,nIndex%,Value%)
    Function SetWindowPos%(hWnd%, after%, x%, y%, w%, h%, flags%)
    Function SetWindowText%(hWnd%, lpString$z) = "SetWindowTextA@8"
End Extern
?

?Win32
Const SW_MINIMIZE:Int = 6 'used with ShowWindow
Const ERROR_ALREADY_EXISTS:Int = 183 'used with Mutex code
?


Function CentreWindow()
	'Centres the current graphics window on the desktop
	?Win32
	Local hWnd% = GetActiveWindow()
	CentreWindowHandle(hWnd%)
	?
End Function

Function CentreWindowHandle(hWnd%)
	'Centres the current graphics window on the desktop
	'Pass a handle in
	?Win32
	Local desk_hWnd% = GetDesktopWindow()
	Local desk:TRect = New TRect
	Local window:TRect= New TRect

	GetWindowRect(desk_hWnd,desk) ' Get Desktop Dimensions
    'Get Window Dimensions because final window may have been resized (by BlitzMax) to fit the desktop resultion! (Grey Alien)
	GetWindowRect(hWnd,window)
	
	'Centre Window
	SetWindowPos(hWnd, -2, (desk.r / 2) - ((window.r-window.l) / 2), (desk.b / 2) - ((window.b-window.t) / 2), 0, 0, 1)
	?
End Function